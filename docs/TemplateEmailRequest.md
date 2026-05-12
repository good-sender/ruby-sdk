# GoodSender::TemplateEmailRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **from** | [**Address**](Address.md) | Sender address (required) |  |
| **to** | [**Address**](Address.md) | Recipient address (required) |  |
| **subject** | **String** | The subject of the email (required) |  |
| **template** | [**TemplateEmailRequestTemplate**](TemplateEmailRequestTemplate.md) |  |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::TemplateEmailRequest.new(
  from: null,
  to: null,
  subject: null,
  template: null
)
```

