# GoodSender::Domain

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **domain** | **String** | The domain name. |  |
| **tracking** | **String** | Subdomain used for click tracking. |  |
| **return_path** | **String** | Subdomain used for the return path. |  |
| **require_tls** | **Boolean** | Whether outbound mail from this domain must be sent over TLS. |  |
| **verification** | [**DomainVerification**](DomainVerification.md) |  |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::Domain.new(
  domain: example.com,
  tracking: track.example.com,
  return_path: bounces.example.com,
  require_tls: true,
  verification: null
)
```

