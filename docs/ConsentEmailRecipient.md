# GoodSender::ConsentEmailRecipient

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | Recipient email address. Leading and trailing whitespace are stripped server-side. |  |
| **name** | **String** | Optional display name. Pass a non-empty string to set or replace the stored name. Passing &#x60;null&#x60;, an empty string, or omitting the field on a re-submitted recipient leaves any previously-stored name unchanged — clearing must be done via the dashboard / authenticated edit flow.  | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::ConsentEmailRecipient.new(
  email: user@example.com,
  name: Jane Doe
)
```

