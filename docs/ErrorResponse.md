# GoodSender::ErrorResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Machine-readable error code. |  |
| **message** | **String** | Human-readable error message. |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::ErrorResponse.new(
  code: consent_failed,
  message: Unable to process the request.
)
```

