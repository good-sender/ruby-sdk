# GoodSender::EmailListResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **emails** | [**Array&lt;EmailAccount&gt;**](EmailAccount.md) |  |  |
| **next_cursor** | **String** | Cursor to retrieve the next page of results. Omitted if there are no more results. | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::EmailListResponse.new(
  emails: null,
  next_cursor: eyJjcmVhdGVkQXRNaWNyb3MiOjE2ODAxMjM0NTY3ODksImVtYWlsIjoidXNlckBleGFtcGxlLmNvbSJ9
)
```

