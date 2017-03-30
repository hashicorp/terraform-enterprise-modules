*NOTE:* This document only applies to customers who are running the Legacy TFE
architecture (mid-late 2016). If you're unsure if that's you, it likely is not.

## Migrating from a Legacy Terraform Enterprise (TFE) Installation

The legacy TFE platform (v2) shipped as a complex multi-VM deployment. The
current generation (v3) ships as a single VM with supporting AWS services,
including S3 and RDS. This vastly simplifies deployment considerations and
reduces estimated operating costs by almost 90%.

Additionally, v2 shipped with a proprietary orchestration tool that was critical
for installation and maintenance. In v3, these functions are either performed
by Terraform configuration, with full source provided to you, or by simple
scripts self-contained inside the VM.

We hope that the improvements in v3 reduce the time you spend managing your TFE
installation and increase your confidence in delivering TFE to the rest of your
organization.

### Data

To upgrade your version of TFE to v3, you will need to access your existing
v2 installation to create backups and copy some configuration. Afterwards, v3
will be ready to resume work where you left off.

- Both v2 and v3 store most of their data in RDS. v3 is designed to use RDS
  encryption by default. When migrating from v2 to v3 we _strongly_ recommend
  enabling RDS encryption. To do this, you will need to create an encrypted RDS
  snapshot and specify the encrypted snapshot and KMS key in the v3 terraform
  config.

- Vault and Consul data will be migrated using a supplemental backup script
  provided by HashiCorp. This must be run from a bastion instance created by the
  legacy installer tool. The script will create a v3-compatible backup from your
  v2 consul and vault clusters.

- The primary S3 bucket in the v2 installation is the one with the
  `-storagelocker` suffix. This S3 bucket may be left as-is, and you will have
  the option to configure your existing S3 bucket in the v3 Terraform
  configuration by adding `manage_bucket = false` to your `tfvars` file. Please
  note that v3 expects the bucket to be versioned to facilitate cross-region
  disaster recovery. If your bucket is not versioned please use this opportunity
  to enable versioning. The remainder of the buckets in the v2 installation are
  administrative and can be cleaned up after a successful upgrade.

### Installation Steps

#### Step 1. Configuration

Begin by configuring the `tfvars` file found in the `aws-standard`
directory. Please reference [the README.md](../aws-standard/README.md) for
full descriptions of all the variables. You will provide your existing S3 bucket
as `bucket_name`, and `tfe-legacy-upgrade` as the `db_snapshot_identifier`.

 * Set existing `-storagelocker` S3 bucket as `bucket_name`
 * Set `manage_bucket` to `false` to indicate that this Terraform config will
   not create and manage a new bucket
 * Set `tfe-legacy-upgrade` as the `db_snapshot_identifier` - this will be the
   name of the encrypted snapshot copy below.

Specify `fqdn` as the DNS name used to access your installation, for example
`tfe.mycompany.io`. This value is used internally for redirects and CSRF.
Externally, you will need to direct your DNS server to the CNAME output from
`terraform apply`. **NOTE:** This value does not have to be the same as the the
value used for the v2 TFE installation. You're free to pick whatever you'd
like, but the `fqdn` must match your v3 installation's external DNS or you will
be unable to login.

#### Step 2. KMS key creation

TFE v3 uses KMS to encrypt sensitive data stored in S3 and RDS. Because you will
be migrating data, you will need to create a KMS key in advance. We will use
this key to create an encrypted RDS snapshot and to encrypt the v2-to-v3 backup
in S3.

First, plan the change: `$ terraform plan --target=aws_kms_key.key`

This should only be creating the kms key, nothing else. Once this is approved:

`$ terraform apply --target=aws_kms_key.key`

This will output a KMS key ARN as `aws_kms_key.key`. You will use this value in
subsequent steps.

**Note:** The Terraform configuration provided by HashiCorp assumes that the v3
install is taking place in the same account and region where your v2
installation is located. If you are migrating to a new account or region you
will need to make minor adjustments, such as creating a new KMS key in the
target region or sharing a KMS key between accounts. Please refer to the AWS
documentation for details.

#### Step 3. Shutting down Legacy Application

Terminate the Atlas job inside your v2 installation. This will allow you
to perform a clean data migration without losing in-flight work.

To do this, bring up a bastion in the legacy installation and run the following
commands:

```
# Back up Atlas job contents
nomad inspect atlas > atlas.job.json
# Stop atlas
nomad stop atlas
```

Leave the bastion host running as you will also use it to migrate Consul and
Vault data in a subsequent step.

**Note:** Make sure the Atlas jobs have completely terminated before you
proceed. This ensures you will produce a consistent snapshot of work in TFE.

#### Step 4. RDS snapshot creation

Create an RDS snapshot from your v2 database. You can create a snapshot via the
AWS api or via the AWS console. We suggest naming the snapshot `tfe-legacy-1`.

Once the snapshot is complete, perform a copy of the snapshot with encryption
enabled. This procedure is documented here:
[Amazon RDS Update - Share Encrypted Snapshots, Encrypt Existing Instances](https://aws.amazon.com/blogs/aws/amazon-rds-update-share-encrypted-snapshots-encrypt-existing-instances/).

Be sure to select `Yes` to `Enable Encryption` and then select the KMS
key we created in Step 2 as the `Master Key`. We suggest naming the snapshot
`tfe-legacy-upgrade`, which is the value we indicated earlier for
`db_snapshot_identifier` in your `tfvars` file.

Once the snapshot has completed, move on to the next step.

#### Step 5. Consul/Vault data

The v2 Consul and Vault clusters contain the encryption keys needed to access
encrypted data stored in RDS (note that this application-level encryption is
different from the system-wide RDS encryption we just talked about). To restore
these keys into v3 we will create a special backup from the v2 data that is
compatible with v3's automatic restore feature.

The tools to perform this step can be found at
[`hashicorp/tfe-v2-to-v3`](https://github.com/hashicorp/tfe-v2-to-v3). You can
request access from HashiCorp if you are not able to see this repository.
Running `make` in that repository will produce `tfe-v2-to-v3.tar.gz`.

Upload `tfe-v2-to-v3.tar.gz` to the v2 bastion host you created earlier (or
create a new bastion host now).

Extract the `tfe-v2-to-v3.tar.gz` into a folder like `~/backup` or
`/tmp/backup`. It should contain the following files:

    consul (binary)
    consul.json
    legacy-backup.sh
    vault.hcl

Make sure the `consul` binary is marked executable, and then invoke
`bash legacy-backup.sh`. This will connect to consul inside your v2 cluster and
produce a file called `atlas-backup-[timestamp].tar.gz`, which v3 can restore.
For additional details please refer to the script itself.

After you have the atlas-backup file, you will need to put it in S3 and encrypt
it with KMS. It should be placed under the `tfe-backup` folder in your TFE S3
bucket, like `s3://my-tfe-data/tfe-backup/atlas-backup-[timestamp].tar.gz`.

You must encrypt the archive when copying it to S3. Either ensure that the
bastion host's IAM role can use the KMS key, or pass in a set of credentials
that can access the required resources in KMS and S3. For example:

    aws configure set s3.signature_version s3v4
    aws s3 cp --sse=aws:kms --sse-kms-key-id=$KMS_KEY_ID $BACKUP_FILE $BACKUP_BUCKET/tfe-backup/$BACKUP_FILE

#### Step 6. Full Terraform Run

Now that all data have been migrated it's time to run a terraform plan for the
remainder of the v3 installation:

`$ terraform plan`

Take a moment and look over the resources that will be created. It should be
considerably smaller than the existing legacy install. Once you're satisfied:

`$ terraform apply`

The apply will take around 30 minutes to create and restore the RDS database,
though the other resources should finish sooner. If there are any problems at
this stage, simply run `terraform apply` again.

When Terraform apply completes it will output a `dns_name` field. Use this to
configure DNS for your installation by configuring a CNAME record to point to
`dns_name`. **NOTE:** The CNAME you configure must match the one specified
earlier in `tfvars`!

Once the CNAME has propagated, you can view your v3 installation in your browser.

#### Step 7. Verification

Open your selected DNS name in your browser using `https://<hostname>` (HTTPS is
required). You will see a page indicating that Terraform Enterprise is booting.
This page automatically refreshes and will redirect you to the login screen once
the v3 database migrations and boot process have completed. Depending on the
size of your database this may take some time, possibly up to 1 hour. If you are
unsure whether your installation is making progress at this point, please reach
out to HashiCorp for help.

Once your instance boots you are ready to login with your existing admin or user
credentials. To verify that the installation is complete, browse to a previous
Terraform run and inspect the state or secrets (environment variables). If
everything loads correctly, then data and encryption keys have been successfully
restored your upgrade was successful. If you cannot login, cannot find previous
Terraform runs, or secrets are missing, please reach out to HashiCorp for help.

### Known Issues

#### GitHub Web Hooks and Callbacks

If you opt to change the hostname during your migration, existing GitHub web
hooks and callbacks will still be pointing to the prior installation. You will
need to update these in two places:

- You will need to update the GitHub OAuth Application for Terraform Enterprise
  so its callback URL references the new hostname. This is required so users can
  authorize Terraform Enterprise to list their GitHub repos and configure jobs
  to pull data from GitHub.

- Each Terraform Environment and Packer Build Configuration linked to a GitHub
  Repo will need to be relinked with GitHub by clicking "Update VCS Settings"
  on the "Integrations" page. This will update GitHub webhooks to point to the
  new hostname.
