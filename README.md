# Demo of Okta, S3, Cloudfront, λ @ edge and Terraform.

## Prerequisites
* An AWS Account
* An Okta account (you can setup a free trial)
* A domain that you own in Route53.

## To deploy:

Tweak the variables in [infra/terraform.tfvars](infra/terraform.tfvars) to match your requirements

```
export OKTA_API_TOKEN=<your okta api token>
export OKTA_BASE_URL=<maybe okta.com ??> 
export OKTA_ORG_NAME=<your okta org>
export AWS_ACCESS_KEY_ID=<access key>
export AWS_SECRET_ACCESS_KEY=<secret>
./go deploy
```