# GoodSender::EmailsApi

All URIs are relative to *https://api.goodsender.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_email_consent_status**](EmailsApi.md#get_email_consent_status) | **GET** /v1/emails/{email} | Get recipient consent status |
| [**list_email_consents**](EmailsApi.md#list_email_consents) | **GET** /v1/emails | List email consent statuses |
| [**request_email_consent**](EmailsApi.md#request_email_consent) | **POST** /v1/emails/consent | Request recipients&#39; consent to receive emails from your domain |
| [**send_email**](EmailsApi.md#send_email) | **POST** /v1/emails/send | Send an email or a batch of emails |
| [**send_template_email**](EmailsApi.md#send_template_email) | **POST** /v1/emails/template | Send a transactional email using a template |


## get_email_consent_status

> <Array<EmailAccount>> get_email_consent_status(email, opts)

Get recipient consent status

Retrieve the current consent status for an email address. Optionally filter by sender domain.

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::EmailsApi.new
email = 'user@example.com' # String | Email address to look up.
opts = {
  domain: 'example.com' # String | Optional sender domain to filter consent records by. When omitted, returns consent across all domains.
}

begin
  # Get recipient consent status
  result = api_instance.get_email_consent_status(email, opts)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->get_email_consent_status: #{e}"
end
```

#### Using the get_email_consent_status_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<EmailAccount>>, Integer, Hash)> get_email_consent_status_with_http_info(email, opts)

```ruby
begin
  # Get recipient consent status
  data, status_code, headers = api_instance.get_email_consent_status_with_http_info(email, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<EmailAccount>>
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->get_email_consent_status_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | Email address to look up. |  |
| **domain** | **String** | Optional sender domain to filter consent records by. When omitted, returns consent across all domains. | [optional] |

### Return type

[**Array&lt;EmailAccount&gt;**](EmailAccount.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## list_email_consents

> <EmailListResponse> list_email_consents(domain, opts)

List email consent statuses

Retrieve a paginated list of email consent statuses for a domain.

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::EmailsApi.new
domain = 'example.com' # String | Sender domain to filter consent records by.
opts = {
  limit: 56, # Integer | Maximum number of records to return.
  cursor: 'cursor_example', # String | Cursor for pagination.
  consent_status: 'pending', # String | Status of the recipient's consent for receiving emails. 'pending' = awaiting consent email send, 'requested' = consent email dispatched, 'failed' = consent email delivery failed, 'granted' = recipient consented to receive emails, 'denied' = recipient declined to receive emails.
  engagement_status: 'new' # String | Status of the recipient's engagement with the emails.
}

begin
  # List email consent statuses
  result = api_instance.list_email_consents(domain, opts)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->list_email_consents: #{e}"
end
```

#### Using the list_email_consents_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<EmailListResponse>, Integer, Hash)> list_email_consents_with_http_info(domain, opts)

```ruby
begin
  # List email consent statuses
  data, status_code, headers = api_instance.list_email_consents_with_http_info(domain, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <EmailListResponse>
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->list_email_consents_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **domain** | **String** | Sender domain to filter consent records by. |  |
| **limit** | **Integer** | Maximum number of records to return. | [optional][default to 50] |
| **cursor** | **String** | Cursor for pagination. | [optional] |
| **consent_status** | **String** | Status of the recipient&#39;s consent for receiving emails. &#39;pending&#39; &#x3D; awaiting consent email send, &#39;requested&#39; &#x3D; consent email dispatched, &#39;failed&#39; &#x3D; consent email delivery failed, &#39;granted&#39; &#x3D; recipient consented to receive emails, &#39;denied&#39; &#x3D; recipient declined to receive emails. | [optional] |
| **engagement_status** | **String** | Status of the recipient&#39;s engagement with the emails. | [optional] |

### Return type

[**EmailListResponse**](EmailListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## request_email_consent

> <ConsentEmailResult> request_email_consent(consent_email_request)

Request recipients' consent to receive emails from your domain

Send a consent message to each address so recipients can approve or reject future emails from your domain. Include the email addresses in the request body to start the consent flow. 

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::EmailsApi.new
consent_email_request = GoodSender::ConsentEmailRequest.new({domain: 'example.com', emails: [user1@example.com,  {email=user2@example.com,  name=Jane Doe}]}) # ConsentEmailRequest | 

begin
  # Request recipients' consent to receive emails from your domain
  result = api_instance.request_email_consent(consent_email_request)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->request_email_consent: #{e}"
end
```

#### Using the request_email_consent_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ConsentEmailResult>, Integer, Hash)> request_email_consent_with_http_info(consent_email_request)

```ruby
begin
  # Request recipients' consent to receive emails from your domain
  data, status_code, headers = api_instance.request_email_consent_with_http_info(consent_email_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ConsentEmailResult>
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->request_email_consent_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **consent_email_request** | [**ConsentEmailRequest**](ConsentEmailRequest.md) |  |  |

### Return type

[**ConsentEmailResult**](ConsentEmailResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## send_email

> <SendEmailResponse> send_email(send_email_request)

Send an email or a batch of emails

Send one or more emails. Emails can be sent only to recipients who have opted in to receive communications from your domain. The response indicates how many emails were sent versus not sent, based on each recipient's consent state. 

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::EmailsApi.new
send_email_request = GoodSender::SendEmailRequest.new({emails: [GoodSender::SendEmail.new({from: GoodSender::Address.new({email: 'email_example'}), to: [GoodSender::Address.new({email: 'email_example'})], subject: 'subject_example'})]}) # SendEmailRequest | List of emails to send

begin
  # Send an email or a batch of emails
  result = api_instance.send_email(send_email_request)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->send_email: #{e}"
end
```

#### Using the send_email_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SendEmailResponse>, Integer, Hash)> send_email_with_http_info(send_email_request)

```ruby
begin
  # Send an email or a batch of emails
  data, status_code, headers = api_instance.send_email_with_http_info(send_email_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SendEmailResponse>
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->send_email_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **send_email_request** | [**SendEmailRequest**](SendEmailRequest.md) | List of emails to send |  |

### Return type

[**SendEmailResponse**](SendEmailResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## send_template_email

> <TemplateEmailResponse> send_template_email(template_email_request)

Send a transactional email using a template

Send a transactional email using a predefined template for common use cases like OTP codes, order confirmations, and new device login alerts. If the recipient has \"denied\" consent, the response returns `{\"status\": \"declined\"}` and the email is not sent. Unknown recipients are auto-registered with \"pending\" consent. The template endpoint does not change the recipient's consent. Each email includes an approve/reject footer allowing the recipient to manage future communications. Provide the template ID and any variables to fill in the placeholders. All variables are optional and will be replaced with an empty string if omitted. URL-type variables must point to the same domain as the sender's email address. 

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::EmailsApi.new
template_email_request = GoodSender::TemplateEmailRequest.new({from: GoodSender::Address.new({email: 'email_example'}), to: GoodSender::Address.new({email: 'email_example'}), subject: 'subject_example', template: GoodSender::TemplateEmailRequestTemplate.new({template_id: 'template_id_example'})}) # TemplateEmailRequest | Template email to send

begin
  # Send a transactional email using a template
  result = api_instance.send_template_email(template_email_request)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->send_template_email: #{e}"
end
```

#### Using the send_template_email_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<TemplateEmailResponse>, Integer, Hash)> send_template_email_with_http_info(template_email_request)

```ruby
begin
  # Send a transactional email using a template
  data, status_code, headers = api_instance.send_template_email_with_http_info(template_email_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <TemplateEmailResponse>
rescue GoodSender::ApiError => e
  puts "Error when calling EmailsApi->send_template_email_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **template_email_request** | [**TemplateEmailRequest**](TemplateEmailRequest.md) | Template email to send |  |

### Return type

[**TemplateEmailResponse**](TemplateEmailResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

