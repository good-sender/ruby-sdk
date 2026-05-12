# GoodSender::Address

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | Valid email address is required. | [default to &#39;&#39;] |
| **name** | **String** | Optional display name | [optional][default to &#39;&#39;] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::Address.new(
  email: null,
  name: null
)
```

