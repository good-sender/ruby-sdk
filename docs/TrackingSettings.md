# GoodSender::TrackingSettings

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **opens** | **Boolean** | Whether to track email opens | [optional] |
| **clicks** | **Boolean** | Whether to track link clicks | [optional] |
| **unsubscribes** | **Boolean** | Whether to track unsubscribes | [optional] |
| **unsubscribe_group_id** | **Integer** | Optional unsubscribe group ID. If not specified, uses global unsubscribe list. This setting is ignored if unsubscribes is false. | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::TrackingSettings.new(
  opens: null,
  clicks: null,
  unsubscribes: null,
  unsubscribe_group_id: null
)
```

