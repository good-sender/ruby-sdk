# GoodSender::DomainVerification

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **verified** | **Boolean** | Overall verification status. True only when every required DNS record is in place. |  |
| **tracking_verified** | **Boolean** | Whether the tracking subdomain CNAME is in place. |  |
| **return_path_verified** | **Boolean** | Whether the return-path subdomain CNAME is in place. |  |
| **dkim1_verified** | **Boolean** | Whether the first DKIM record is in place. |  |
| **dkim2_verified** | **Boolean** | Whether the second DKIM record is in place. |  |

## Example

```ruby
require 'goodsender'

instance = GoodSender::DomainVerification.new(
  verified: true,
  tracking_verified: true,
  return_path_verified: true,
  dkim1_verified: true,
  dkim2_verified: true
)
```

