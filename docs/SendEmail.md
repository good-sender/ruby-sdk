# GoodSender::SendEmail

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **from** | [**Address**](Address.md) | Sender address (required) |  |
| **to** | [**Array&lt;Address&gt;**](Address.md) | To recipients. At least one recipient (to, cc, or bcc) is required. Maximum 1000 recipients per email. |  |
| **subject** | **String** | The subject of the email (required) | [default to &#39;&#39;] |
| **text_content** | **String** | Plain text content | [optional] |
| **html_content** | **String** | HTML content | [optional] |
| **markdown_content** | **String** | Markdown content. When provided, text_content and html_content are ignored. The raw markdown is used as text_content and rendered to HTML for html_content.  | [optional] |
| **template_id** | **String** | Template ID for templated emails | [optional] |
| **template_data** | **Hash&lt;String, Object&gt;** | Data to populate template variables | [optional] |
| **attachments** | [**Array&lt;Attachment&gt;**](Attachment.md) | Email attachments | [optional] |
| **headers** | **Hash&lt;String, String&gt;** | Custom email headers | [optional] |
| **reply_to** | [**Address**](Address.md) | Reply-to address | [optional] |
| **send_time** | **Integer** | Unix timestamp for when to send the email. Must not be more than 72 hours in the future. If 0, sends immediately. | [optional] |
| **webhook_data** | **Hash&lt;String, String&gt;** | Custom data to include in webhook events. Maximum 10 keys, key length 50 chars, value length 100 chars. | [optional] |
| **tag** | **String** | Custom tag for tracking. Maximum 100 characters. | [optional] |
| **tracking** | [**TrackingSettings**](TrackingSettings.md) | Email tracking settings | [optional] |

## Example

```ruby
require 'goodsender'

instance = GoodSender::SendEmail.new(
  from: null,
  to: null,
  subject: null,
  text_content: null,
  html_content: null,
  markdown_content: null,
  template_id: null,
  template_data: null,
  attachments: null,
  headers: null,
  reply_to: null,
  send_time: null,
  webhook_data: null,
  tag: null,
  tracking: null
)
```

