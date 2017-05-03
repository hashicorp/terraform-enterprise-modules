# Storing Terraform Enterprise State

The Terraform Enterprise install process uses Terraform, and therefore must store Terraform State. This presents a bootstrapping problem, because while generally you can use Terraform Enterprise to securely store versioned Terraform State, in this case Terraform Enterprise is not ready yet.

So therefore, you must choose a mechanism for storing the Terraform State produced by the install process.

## Security Considerations for Terraform State

The Terraform State file for the Terraform Enterprise instance will contain the RDS Database password used by the application. While sensitive fields are separately encrypted-at-rest via Vault, this credential and network access to the database would yield access to all of the unencrypted metadata stored by Terraform Enterprise.

HashiCorp recommends storing the Terraform State for the install in an encrypted data store.

## Recommended State Storage Setup

Terraform supports various [Remote State](https://www.terraform.io/docs/state/remote.html) backends that can be used to securely store the Terraform State produced by the install.

HashiCorp recommends a versioned, encrypted-at-rest S3 bucket as a good default choice.

Here are steps for setting up and using an S3 bucket for Remote State Storage:

```bash
# From the root dir of your Terraform Enterprise installation config
BUCKETNAME="mycompany-terraform-enterprise-state"

# Create bucket
aws s3 mb "s3://${BUCKETNAME}"

# Turn on versioning for the bucket
aws s3api put-bucket-versioning --bucket "${BUCKETNAME}" --versioning-configuration status=Enabled

# Configure terraform backend to point to the S3 bucket
cat <<EOF >backend.tf
terraform {
  backend "s3" {
    bucket  = "${BUCKETNAME}"
    key     = "terraform-enterprise.tfstate"
    encrypt = true
  }
}
EOF

# Initialize Terraform with the Remote Backend
terraform init 
```

Now, if you keep the `backend.tf` file in scope when you run `terraform` operations, all state will be stored in the configured bucket.
