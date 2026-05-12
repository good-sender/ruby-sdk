# GoodSender::DomainListResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **domains** | [**Array&lt;Domain&gt;**](Domain.md) |  |  |
| **next_cursor** | **String** | Cursor to retrieve the next page of results. Omitted if there are no more results. | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::DomainListResponse.new(
  domains: null,
  next_cursor: eyJsYXN0RG9tYWluIjoiZXhhbXBsZS5jb20ifQ
)
```

