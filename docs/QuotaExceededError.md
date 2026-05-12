# GoodSender::QuotaExceededError

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Machine-readable error code. |  |
| **kind** | **String** | Whether the daily or monthly quota was exhausted. |  |
| **message** | **String** | Human-readable error message. |  |
| **limit** | **Integer** | Quota limit that was reached. |  |
| **used** | **Integer** | Number of emails already used against the quota. |  |
| **reset_at** | **Time** | Timestamp at which the quota window resets. |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::QuotaExceededError.new(
  code: null,
  kind: null,
  message: null,
  limit: null,
  used: null,
  reset_at: null
)
```

