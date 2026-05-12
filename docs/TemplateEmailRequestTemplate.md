# GoodSender::TemplateEmailRequestTemplate

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **template_id** | **String** | The ID of the template to use |  |
| **variables** | **Hash&lt;String, String&gt;** | Key-value pairs to populate template variables | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::TemplateEmailRequestTemplate.new(
  template_id: null,
  variables: null
)
```

