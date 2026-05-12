# Mock-mode smoke test for the Ruby SDK.
require 'goodsender'

BASE_URL = ENV.fetch('BASE_URL', 'http://localhost:4010')
API_KEY  = ENV.fetch('GOODSENDER_API_KEY', 'test-key')

GoodSender.configure do |c|
  c.host         = BASE_URL.sub(%r{^https?://}, '')
  c.base_path    = ''
  c.scheme       = BASE_URL.start_with?('https://') ? 'https' : 'http'
  c.access_token = API_KEY
end

emails  = GoodSender::EmailsApi.new
domains = GoodSender::DomainsApi.new

results = []

def run(method, results)
  detail = yield
  results << [method, :pass, detail]
rescue => e
  results << [method, :fail, "#{e.class.name}: #{e.message[0..120]}"]
end

run('sendEmail', results) do
  req = GoodSender::SendEmailRequest.new(emails: [
    GoodSender::SendEmail.new(
      from: GoodSender::Address.new(email: 'sender@example.com'),
      to: [GoodSender::Address.new(email: 'recipient@example.com')],
      subject: 'Hello',
      text_content: 'Body'
    )
  ])
  res = emails.send_email(req)
  "sent=#{res.sent} declined=#{res.declined}"
end

run('sendTemplateEmail', results) do
  req = GoodSender::TemplateEmailRequest.new(
    from: GoodSender::Address.new(email: 'sender@example.com'),
    to: GoodSender::Address.new(email: 'recipient@example.com'),
    subject: 'OTP',
    template: GoodSender::TemplateEmailRequestTemplate.new(
      template_id: 'otp_code',
      variables: { 'code' => '123456' }
    )
  )
  res = emails.send_template_email(req)
  "status=#{res.status}"
end

run('requestEmailConsent', results) do
  req = GoodSender::ConsentEmailRequest.new(
    domain: 'example.com',
    emails: ['smoke-ruby@example.com']
  )
  res = emails.request_email_consent(req)
  "emails=#{(res.emails || []).length}"
end

run('getEmailConsentStatus', results) do
  res = emails.get_email_consent_status('user@example.com', domain: 'example.com')
  "entries=#{res.length}"
end

run('listEmailConsents', results) do
  res = emails.list_email_consents('example.com', limit: 50)
  "emails=#{(res.emails || []).length}"
end

run('listDomains', results) do
  res = domains.list_domains(limit: 50)
  "domains=#{res.domains.length}"
end

results.each do |method, status, detail|
  tag = status == :pass ? 'PASS' : 'FAIL'
  printf("%-4s  ruby    %-22s  %s\n", tag, method, detail)
end

failed = results.count { |_, s, _| s == :fail }
passed = results.size - failed
puts
puts "#{passed} passed, #{failed} failed"
exit(failed > 0 ? 1 : 0)
