# GoodSender::Attachment

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **file_name** | **String** | File name for the attachment | [optional][default to &#39;&#39;] |
| **content** | **String** | Base64 encoded content | [optional] |
| **content_type** | **String** | MIME content type (required) | [default to &#39;&#39;] |
| **inline_id** | **String** | Inline attachment ID | [optional][default to &#39;&#39;] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::Attachment.new(
  file_name: null,
  content: null,
  content_type: null,
  inline_id: null
)
```

