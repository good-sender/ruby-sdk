# GoodSender::SendEmailResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sent** | **Integer** | Number of emails sent (recipients had consent allowing delivery) |  |
| **declined** | **Integer** | Number of emails not sent because recipients did not have granted consent to receive emails |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::SendEmailResponse.new(
  sent: 8,
  declined: 2
)
```

