# GoodSender::TemplateEmailResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **status** | **String** | \&quot;sent\&quot; if the email was sent, \&quot;declined\&quot; if the recipient has opted out |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::TemplateEmailResponse.new(
  status: sent
)
```

