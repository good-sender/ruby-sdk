# GoodSender::DomainsApi

All URIs are relative to *https://api.goodsender.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**list_domains**](DomainsApi.md#list_domains) | **GET** /v1/domains | List domains |


## list_domains

> <DomainListResponse> list_domains(opts)

List domains

Retrieve a paginated list of sender domains for the workspace the API key belongs to. Each entry includes the domain's verification state so callers can detect when DNS records still need attention. 

### Examples

```ruby
require 'time'
require 'goodsender'
# setup authorization
GoodSender.configure do |config|
  # Configure Bearer authorization (ApiKey): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = GoodSender::DomainsApi.new
opts = {
  limit: 56, # Integer | Maximum number of records to return.
  cursor: 'cursor_example' # String | Cursor for pagination, returned as `nextCursor` from a previous response.
}

begin
  # List domains
  result = api_instance.list_domains(opts)
  p result
rescue GoodSender::ApiError => e
  puts "Error when calling DomainsApi->list_domains: #{e}"
end
```

#### Using the list_domains_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DomainListResponse>, Integer, Hash)> list_domains_with_http_info(opts)

```ruby
begin
  # List domains
  data, status_code, headers = api_instance.list_domains_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DomainListResponse>
rescue GoodSender::ApiError => e
  puts "Error when calling DomainsApi->list_domains_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **limit** | **Integer** | Maximum number of records to return. | [optional][default to 50] |
| **cursor** | **String** | Cursor for pagination, returned as &#x60;nextCursor&#x60; from a previous response. | [optional] |

### Return type

[**DomainListResponse**](DomainListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

