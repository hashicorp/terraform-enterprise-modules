# Installing Terraform Enterprise

Terraform Enterprise currently targets Amazon Web Services environments. Support for additional infrastructure providers is planned.

## Amazon Web Services (AWS)`

![aws-infra-architecture](docs/assets/aws-infra-architecture.png)

In AWS, a Terraform Enterprise install consists of:

 * Compute Tier
  * Elastic Load Balancer (ELB)
  * Single EC2 instance launched as part of an AutoScaling Group (ASG)
 * Data Tier
  * RDS PostgreSQL for primary application storage
  * ElastiCache Redis for ephemeral application storage
  * An S3 Bucket for object storage

Each of the `aws-` prefixed directories contains a full Terraform Enterprise installation for a certain situation.

Please see the documentation for the relevant install flavor:

* [`aws-standard`](aws-standard/) - Manages compute, data layer and (optionally) Route 53 DNS.
* [`aws-expert`](aws-expert/) - Manages compute layer only, customer manages DNS and data layer separately.

## Documentation

Further documentation can be found in the [`docs`](docs/) subdir.
