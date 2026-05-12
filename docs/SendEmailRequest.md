# GoodSender::SendEmailRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **emails** | [**Array&lt;SendEmail&gt;**](SendEmail.md) | List of emails to send. Cannot be empty. |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::SendEmailRequest.new(
  emails: null
)
```

