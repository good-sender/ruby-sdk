# GoodSender::EmailAccount

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | Recipient email address. |  |
| **name** | **String** | Optional display name for the recipient. Used in the To header on the consent email when present, and surfaced through the Dashboard. May be null when no name has been provided. | [optional] |
| **domain** | **String** | Domain part of the email address. |  |
| **consent_status** | **String** | Status of the recipient&#39;s consent for receiving emails. &#39;pending&#39; &#x3D; awaiting consent email send, &#39;requested&#39; &#x3D; consent email dispatched, &#39;failed&#39; &#x3D; consent email delivery failed, &#39;granted&#39; &#x3D; recipient consented to receive emails, &#39;denied&#39; &#x3D; recipient declined to receive emails. |  |
| **engagement_status** | **String** | Status of the recipient&#39;s engagement with the emails. | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::EmailAccount.new(
  email: user@example.com,
  name: Jane Doe,
  domain: example.com,
  consent_status: pending,
  engagement_status: new
)
```

