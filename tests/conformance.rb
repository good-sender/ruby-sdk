# State-aware conformance test for the Ruby SDK against the real dev API.
# Mirrors tests/runners/node/conformance.ts (same scenario IDs).

require 'goodsender'
require 'securerandom'

def require_env(key)
  v = ENV[key]
  if v.nil? || v.empty?
    warn "FATAL: #{key} is not set in .env.dev"
    exit 2
  end
  v
end

BASE_URL = require_env('BASE_URL')
API_KEY  = require_env('GOODSENDER_API_KEY')
ALLOW_DESTRUCTIVE = ENV['ALLOW_DESTRUCTIVE'] == '1'

VERIFIED_DOMAIN   = require_env('VERIFIED_SENDER_DOMAIN')
VERIFIED_EMAIL    = require_env('VERIFIED_SENDER_EMAIL')
VERIFIED_NAME     = ENV['VERIFIED_SENDER_NAME'] || 'GoodSender SDK Tests'
UNVERIFIED_DOMAIN = require_env('UNVERIFIED_SENDER_DOMAIN')
UNVERIFIED_EMAIL  = require_env('UNVERIFIED_SENDER_EMAIL')
GRANTED_1 = require_env('RECIPIENT_GRANTED_1')
GRANTED_2 = require_env('RECIPIENT_GRANTED_2')
DENIED_1  = require_env('RECIPIENT_DENIED_1')
DENIED_2  = require_env('RECIPIENT_DENIED_2')
TEMPLATE_ID = require_env('TEMPLATE_ID')

RUN_TAG = "sdk-#{Time.now.to_i.to_s(16)}-#{SecureRandom.alphanumeric(5).downcase}"
FRESH_1 = "#{RUN_TAG}-1@#{VERIFIED_DOMAIN}"
FRESH_2 = "#{RUN_TAG}-2@#{VERIFIED_DOMAIN}"

GoodSender.configure do |c|
  c.host         = BASE_URL.sub(%r{^https?://}, '')
  c.base_path    = ''
  c.scheme       = BASE_URL.start_with?('https://') ? 'https' : 'http'
  c.access_token = API_KEY
end

emails  = GoodSender::EmailsApi.new
domains = GoodSender::DomainsApi.new

results = []

def record(results, id, name, status, detail)
  results << [id, name, status, detail]
end

def scenario(results, id, name)
  ok, detail = yield
  record(results, id, name, ok ? 'PASS' : 'FAIL', detail)
rescue => e
  record(results, id, name, 'FAIL', "unexpected: #{e.class.name}: #{e.message[0..160]}")
end

def http_status(e)
  e.respond_to?(:code) ? e.code.to_i : nil
end

def http_body(e)
  e.respond_to?(:response_body) ? e.response_body.to_s[0..160] : e.message[0..160]
end

# ─── Read-only (R1–R6) ───────────────────────────────────────────

scenario(results, 'R1', 'listDomains returns both fixtures with correct verification flags') do
  res = domains.list_domains(limit: 100)
  by_name = res.domains.each_with_object({}) { |d, h| h[d.domain] = d }
  v = by_name[VERIFIED_DOMAIN]
  u = by_name[UNVERIFIED_DOMAIN]
  if v.nil?
    [false, "#{VERIFIED_DOMAIN} not in listDomains response"]
  elsif u.nil?
    [false, "#{UNVERIFIED_DOMAIN} not in listDomains response"]
  elsif !v.verification.verified
    [false, "#{VERIFIED_DOMAIN} has verification.verified=false; should be true"]
  elsif u.verification.verified
    [false, "#{UNVERIFIED_DOMAIN} has verification.verified=true; should be false"]
  else
    [true, "domains=#{res.domains.length}, verified=true, unverified=false"]
  end
end

scenario(results, 'R2', 'getEmailConsentStatus returns granted for approved recipient') do
  res = emails.get_email_consent_status(GRANTED_1, domain: VERIFIED_DOMAIN)
  entry = res.find { |e| e.domain == VERIFIED_DOMAIN }
  if entry.nil?
    [false, "no entry for domain=#{VERIFIED_DOMAIN}"]
  elsif entry.consent_status != 'granted'
    [false, "consentStatus=#{entry.consent_status}, expected granted"]
  else
    [true, "consentStatus=#{entry.consent_status}"]
  end
end

scenario(results, 'R3', 'getEmailConsentStatus returns denied for rejected recipient') do
  res = emails.get_email_consent_status(DENIED_1, domain: VERIFIED_DOMAIN)
  entry = res.find { |e| e.domain == VERIFIED_DOMAIN }
  if entry.nil?
    [false, "no entry for domain=#{VERIFIED_DOMAIN}"]
  elsif entry.consent_status != 'denied'
    [false, "consentStatus=#{entry.consent_status}, expected denied"]
  else
    [true, "consentStatus=#{entry.consent_status}"]
  end
end

scenario(results, 'R4', 'getEmailConsentStatus returns 404 for unknown recipient') do
  probe = "#{RUN_TAG}-r4-probe@#{VERIFIED_DOMAIN}"
  begin
    res = emails.get_email_consent_status(probe, domain: VERIFIED_DOMAIN)
    [false, "expected 404, got 200 with #{res.length} entries"]
  rescue GoodSender::ApiError => e
    if e.code == 404
      [true, "404 (probe=#{probe})"]
    else
      [false, "expected 404, got #{e.code} #{http_body(e)}"]
    end
  end
end

scenario(results, 'R5', 'listEmailConsents for verified domain includes all 4 fixtures') do
  collected = []
  cursor = nil
  20.times do
    res = emails.list_email_consents(VERIFIED_DOMAIN, limit: 100, cursor: cursor)
    collected.concat((res.emails || []).map(&:email))
    cursor = res.next_cursor
    break if cursor.nil? || cursor.empty?
  end
  expected = [GRANTED_1, GRANTED_2, DENIED_1, DENIED_2]
  missing = expected.reject { |e| collected.include?(e) }
  if missing.empty?
    [true, "#{collected.length} entries scanned; all 4 fixtures present"]
  else
    [false, "missing from listEmailConsents: #{missing.join(', ')}"]
  end
end

scenario(results, 'R6', 'listEmailConsents with consentStatus=granted filter excludes denied') do
  collected = []
  statuses  = []
  cursor = nil
  pages = 0
  20.times do
    res = emails.list_email_consents(VERIFIED_DOMAIN, consent_status: 'granted', limit: 100, cursor: cursor)
    pages += 1
    (res.emails || []).each do |e|
      collected << e.email
      statuses << e.consent_status
    end
    cursor = res.next_cursor
    break if cursor.nil? || cursor.empty?
  end
  unique_statuses = statuses.uniq
  if (unique_statuses - ['granted']).any?
    [false, "filter leaked non-granted statuses: #{unique_statuses.sort.join(',')}"]
  else
    missing = [GRANTED_1, GRANTED_2].reject { |e| collected.include?(e) }
    if missing.any?
      sample = collected.uniq.sort.first(5).join(', ')
      sample = '(none)' if sample.empty?
      [false, "filter returned #{collected.uniq.length} entries across #{pages} page(s); missing=#{missing.join(',')}; sample=[#{sample}]"]
    elsif collected.include?(DENIED_1) || collected.include?(DENIED_2)
      [false, 'denied fixtures leaked into granted filter']
    else
      [true, "#{collected.uniq.length} granted entries; denied fixtures absent"]
    end
  end
end

# ─── Destructive (D1–D6, E1–E5) ──────────────────────────────────

if ALLOW_DESTRUCTIVE
  scenario(results, 'D1', 'sendEmail to 2 granted recipients delivers both') do
    req = GoodSender::SendEmailRequest.new(emails: [GoodSender::SendEmail.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL, name: VERIFIED_NAME),
      to: [GoodSender::Address.new(email: GRANTED_1), GoodSender::Address.new(email: GRANTED_2)],
      subject: "SDK conformance D1 #{RUN_TAG}",
      text_content: 'Conformance D1 — granted recipients.'
    )])
    res = emails.send_email(req)
    if res.sent == 2 && res.declined == 0
      [true, "sent=#{res.sent} declined=#{res.declined}"]
    else
      [false, "sent=#{res.sent} declined=#{res.declined}, expected 2/0"]
    end
  end

  scenario(results, 'D2', 'sendEmail to 2 denied recipients declines both') do
    req = GoodSender::SendEmailRequest.new(emails: [GoodSender::SendEmail.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL, name: VERIFIED_NAME),
      to: [GoodSender::Address.new(email: DENIED_1), GoodSender::Address.new(email: DENIED_2)],
      subject: "SDK conformance D2 #{RUN_TAG}",
      text_content: 'D2'
    )])
    res = emails.send_email(req)
    if res.sent == 0 && res.declined == 2
      [true, "sent=#{res.sent} declined=#{res.declined}"]
    else
      [false, "sent=#{res.sent} declined=#{res.declined}, expected 0/2"]
    end
  end

  scenario(results, 'D3', 'sendEmail granted+denied mix splits correctly') do
    req = GoodSender::SendEmailRequest.new(emails: [GoodSender::SendEmail.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL, name: VERIFIED_NAME),
      to: [GoodSender::Address.new(email: GRANTED_1), GoodSender::Address.new(email: DENIED_1)],
      subject: "SDK conformance D3 #{RUN_TAG}",
      text_content: 'D3'
    )])
    res = emails.send_email(req)
    if res.sent == 1 && res.declined == 1
      [true, "sent=#{res.sent} declined=#{res.declined}"]
    else
      [false, "sent=#{res.sent} declined=#{res.declined}, expected 1/1"]
    end
  end

  scenario(results, 'D4', 'sendTemplateEmail to granted recipient returns status=sent') do
    req = GoodSender::TemplateEmailRequest.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL, name: VERIFIED_NAME),
      to: GoodSender::Address.new(email: GRANTED_1),
      subject: "SDK conformance D4 #{RUN_TAG}",
      template: GoodSender::TemplateEmailRequestTemplate.new(template_id: TEMPLATE_ID, variables: {})
    )
    res = emails.send_template_email(req)
    res.status == 'sent' ? [true, "status=#{res.status}"] : [false, "status=#{res.status}, expected sent"]
  end

  scenario(results, 'D5', 'sendTemplateEmail to denied recipient returns status=declined') do
    req = GoodSender::TemplateEmailRequest.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL, name: VERIFIED_NAME),
      to: GoodSender::Address.new(email: DENIED_1),
      subject: "SDK conformance D5 #{RUN_TAG}",
      template: GoodSender::TemplateEmailRequestTemplate.new(template_id: TEMPLATE_ID, variables: {})
    )
    res = emails.send_template_email(req)
    res.status == 'declined' ? [true, "status=#{res.status}"] : [false, "status=#{res.status}, expected declined"]
  end

  scenario(results, 'D6', 'requestEmailConsent registers 2 fresh addresses') do
    req = GoodSender::ConsentEmailRequest.new(domain: VERIFIED_DOMAIN, emails: [
      GoodSender::ConsentEmailRecipient.new(email: FRESH_1, name: 'Fresh 1'),
      GoodSender::ConsentEmailRecipient.new(email: FRESH_2, name: 'Fresh 2'),
    ])
    res = emails.request_email_consent(req)
    entries = res.emails || []
    if entries.length == 2
      statuses = entries.map(&:consent_status).sort.join(',')
      [true, "2 fresh addresses; statuses=[#{statuses}] #{FRESH_1} #{FRESH_2}"]
    else
      [false, "expected 2 entries in ConsentEmailResult.emails, got #{entries.length}"]
    end
  end

  scenario(results, 'E1', 'sendEmail from unverified domain is rejected') do
    req = GoodSender::SendEmailRequest.new(emails: [GoodSender::SendEmail.new(
      from: GoodSender::Address.new(email: UNVERIFIED_EMAIL),
      to: [GoodSender::Address.new(email: GRANTED_1)],
      subject: "SDK conformance E1 #{RUN_TAG}",
      text_content: 'should be rejected'
    )])
    begin
      res = emails.send_email(req)
      [false, "expected 4xx, got 200 sent=#{res.sent}"]
    rescue GoodSender::ApiError => e
      e.code && e.code >= 400 && e.code < 500 ? [true, "#{e.code} #{http_body(e)}"] : [false, "expected 4xx, got #{e.code} #{http_body(e)}"]
    end
  end

  scenario(results, 'E2', 'sendTemplateEmail from unverified domain is rejected') do
    req = GoodSender::TemplateEmailRequest.new(
      from: GoodSender::Address.new(email: UNVERIFIED_EMAIL),
      to: GoodSender::Address.new(email: GRANTED_1),
      subject: "SDK conformance E2 #{RUN_TAG}",
      template: GoodSender::TemplateEmailRequestTemplate.new(template_id: TEMPLATE_ID, variables: {})
    )
    begin
      res = emails.send_template_email(req)
      [false, "expected 4xx, got 200 status=#{res.status}"]
    rescue GoodSender::ApiError => e
      e.code && e.code >= 400 && e.code < 500 ? [true, "#{e.code} #{http_body(e)}"] : [false, "expected 4xx, got #{e.code} #{http_body(e)}"]
    end
  end

  scenario(results, 'E3', 'sendTemplateEmail with bogus template_id returns 404') do
    bad = "#{RUN_TAG}-does-not-exist"
    req = GoodSender::TemplateEmailRequest.new(
      from: GoodSender::Address.new(email: VERIFIED_EMAIL),
      to: GoodSender::Address.new(email: GRANTED_1),
      subject: "SDK conformance E3 #{RUN_TAG}",
      template: GoodSender::TemplateEmailRequestTemplate.new(template_id: bad, variables: {})
    )
    begin
      res = emails.send_template_email(req)
      [false, "expected 404, got 200 status=#{res.status}"]
    rescue GoodSender::ApiError => e
      e.code == 404 ? [true, "404 #{http_body(e)}"] : [false, "expected 404, got #{e.code} #{http_body(e)}"]
    end
  end

  scenario(results, 'E4', 'requestEmailConsent for unverified domain is rejected') do
    fresh = "#{RUN_TAG}-e4-target@example.com"
    req = GoodSender::ConsentEmailRequest.new(domain: UNVERIFIED_DOMAIN, emails: [fresh])
    begin
      res = emails.request_email_consent(req)
      [false, "expected 4xx, got 200 emails=#{(res.emails || []).length}"]
    rescue GoodSender::ApiError => e
      e.code && e.code >= 400 && e.code < 500 ? [true, "#{e.code} #{http_body(e)}"] : [false, "expected 4xx, got #{e.code} #{http_body(e)}"]
    end
  end

  scenario(results, 'E5', 'listEmailConsents for non-existent domain') do
    bogus = "not-a-real-domain-#{RUN_TAG}.invalid"
    begin
      res = emails.list_email_consents(bogus, limit: 1)
      [true, "200 emails=#{(res.emails || []).length} (no error path for unknown domain)"]
    rescue GoodSender::ApiError => e
      e.code && e.code >= 400 && e.code < 500 ? [true, "#{e.code} #{http_body(e)}"] : [false, "unexpected: #{e.code} #{http_body(e)}"]
    end
  end
else
  [
    ['D1', 'sendEmail to 2 granted recipients'],
    ['D2', 'sendEmail to 2 denied recipients'],
    ['D3', 'sendEmail granted+denied mix'],
    ['D4', 'sendTemplateEmail to granted'],
    ['D5', 'sendTemplateEmail to denied'],
    ['D6', 'requestEmailConsent for 2 fresh addresses'],
    ['E1', 'sendEmail from unverified domain rejected'],
    ['E2', 'sendTemplateEmail from unverified domain rejected'],
    ['E3', 'sendTemplateEmail with bogus template_id'],
    ['E4', 'requestEmailConsent for unverified domain rejected'],
    ['E5', 'listEmailConsents for non-existent domain'],
  ].each { |sid, name| record(results, sid, name, 'SKIP', 'destructive — set ALLOW_DESTRUCTIVE=1') }
end

# ─── Report ──────────────────────────────────────────────────────

results.each do |sid, name, status, detail|
  printf("%-4s  ruby    %s  %-58s  %s\n", status, sid, name[0..57], detail)
end

passed  = results.count { |_, _, s, _| s == 'PASS' }
failed  = results.count { |_, _, s, _| s == 'FAIL' }
skipped = results.count { |_, _, s, _| s == 'SKIP' }
puts
puts "#{passed} passed, #{failed} failed, #{skipped} skipped"
puts "\nDestructive run created consent records for cleanup:\n  #{FRESH_1}\n  #{FRESH_2}" if ALLOW_DESTRUCTIVE
exit(failed > 0 ? 1 : 0)
