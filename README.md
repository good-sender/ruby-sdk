# GoodSender SDK for Ruby

Official client library for the GoodSender email API. Gem: `goodsender`

## Installation

```bash
gem install goodsender
```

Or in your `Gemfile`:

```ruby
gem 'goodsender'
```

## Quick start

```ruby
require 'goodsender'

GoodSender.configure do |c|
  c.scheme       = 'https'
  c.host         = 'api.goodsender.com'
  c.base_path    = ''
  c.access_token = 'YOUR_API_KEY'
end

emails  = GoodSender::EmailsApi.new
domains = GoodSender::DomainsApi.new

req = GoodSender::SendEmailRequest.new(emails: [
  GoodSender::SendEmail.new(
    from: GoodSender::Address.new(email: 'sender@example.com'),
    to: [GoodSender::Address.new(email: 'recipient@example.com')],
    subject: 'Hello',
    text_content: 'Body'
  )
])
res = emails.send_email(req)
puts "sent=#{res.sent} declined=#{res.declined}"
```

## Examples

### Send via a template

```ruby
req = GoodSender::TemplateEmailRequest.new(
  from: GoodSender::Address.new(email: 'sender@example.com'),
  to: GoodSender::Address.new(email: 'recipient@example.com'),
  subject: 'Your OTP',
  template: GoodSender::TemplateEmailRequestTemplate.new(
    template_id: 'otp_code',
    variables: { 'code' => '123456' }
  )
)
res = emails.send_template_email(req)
puts "status=#{res.status}"
```

### List domains

```ruby
res = domains.list_domains(limit: 50)
puts "domains=#{res.domains.length}"
```

### Check consent status

```ruby
res = emails.get_email_consent_status('user@example.com', domain: 'example.com')
puts "entries=#{res.length}"

# List all consents for a domain
res = emails.list_email_consents('example.com', limit: 50)
puts "emails=#{(res.emails || []).length}"
```

## Documentation

- API reference: <https://api.goodsender.com/docs>
- OpenAPI spec: `openapi/goodsender.yaml` in this repo
- Conformance tests: `tests/`

## Development

- Regenerate from spec: `scripts/regen.sh` (preserves `tests/`, `.github/`, and hand-curated files per `.regen-ignore`)
- Run conformance tests against local mock: `tests/run.sh mock`
- Run conformance against real dev API: `tests/run.sh dev` (requires `tests/.env.dev`)

## License

MIT — see [LICENSE](LICENSE).
