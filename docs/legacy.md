*NOTE:* This document only applies to customers who are running the Legacy TFE
architecture. If you're unsure if that's you, it likely is not.

## Migrating from a Legacy TFE installation

The current generation of TFE has different setup that legacy installations.
For one, the footprint is vastly reduced based on information we gathered from
customers. We believe this new smaller footprint installation will provide
users the same performance for a cheaper cost and simpler adminstration.

### Data Assets

To migrate a legacy installation, the assets of the current installation must
be gathered and made available to the new installation. With the data assets in
place, the new installation will restore from the data assets and be fully
active.

#### RDS

Both the legacy and current installations use RDS to store the vast majority of
the data. To migrate this data, it's necessary to use the RDS snapshot ability
to allow move the data between Terraform managed RDS clusters. Snapshots are
used rather than importing the legacy RDS installation into the new
installation due to RDS changes, primarly encryption.

#### Vault/Consul data

Data stored within vault and consul must also be migrated to the new
installation. This is done using a provided script that is run on a node of the
legacy cluster.

#### S3

The new installation does not require the movement of the data stored in S3.
The existing bucket need only be referenced in the `tfvars` file with
`manage_bucket = false` also set, so that the new installation, during
installation, simply uses the bucket rather than attempting to create it.

### Installation Steps

#### Step 1. Configuration

You'll be configuring a `tfvars` file in the `aws-standard-nodns` directory.
Please reference [the README.md](../aws-standard-nodns/README.md) for full
descriptions of all the variables. For your installation, you'll be providing
your existing S3 bucket as `bucket_name` and `tfe-legacy-upgrade` as the
`db_snapshot_identifier`.

The `fqdn` value is the full hostname that the cluster will be available as, for
instance `tfe.mycompany.io`. This value will be baked into the cluster on install
and you'll be configuring that value with a CNAME based on the outputs of the
terraform apply. *NOTE:* This value does not have to be the same as the the
value used for the legacy TFE installation. You're free to pick whatever you'd
like, but it just must be consistently used for the new installation.

#### Step 2. KMS key creation

The new installation uses KMS to encrypt sensitive values stored within S3 as
well as RDS. We need to create the KMS key and use it to make an encrypted RDS
snapshot before doing the full install.

First, plan the change: `$ terraform plan --target=aws_kms_key.key`

This should only be creating the kms key, nothing else. Once this is approved:

`$ terraform apply --target=aws_kms_key.key`

This will output a KMS key arn as `aws_kms_key.key`. You'll use this value in
the next steps.

#### Step 3. Shutting down Legacy Application

In order to prevent any data from being written while the application is being
migrated, we will shut down the Atlas job in the legacy installation.

Bring up a bastion in the legacy installtion and run the following commands to
stop the Atlas job:

```
# Back up Atlas job contents
nomad inspect atlas > atlas.job.json
# Stop atlas
nomad stop atlas
```

Leave the bastion host up as we'll use it to extract Consul/Vault data in a
following step.

#### Step 4. RDS snapshot creation

Now we need create a snapshot of the RDS database and then encrypt it with the
KMS key we just created. It's important that the state in RDS be consistent, so
we urge the legacy cluster be put into maintaince mode before taking the
snapshot.

The snapshot can be taken via the AWS api or via the AWS console. We suggest
the snapshot be named `tfe-legacy-1`.

Once this snapshot finishes, perform a copy of this snapshot with encryption
enabled. This document walks through the procedure nicely: [Amazon RDS Update - Share Encrypted Snapshots, Encrypt Existing Instances](https://aws.amazon.com/blogs/aws/amazon-rds-update-share-encrypted-snapshots-encrypt-existing-instances/).

Name the snapshot `tfe-legacy-upgrade` or whatever value you configured in `tfvars` for `db_snapshot_identifier`.

You'll be sure to select `Yes` to `Enable Encrytion` and then select the KMS
 key we created in Step 2 as the `Master Key`. Once the snapshot is finished,
 move on to the next step.

#### Step 5. Consul/Vault data

The legacy installation has one important piece of data in Consul/Vault we need
to extract: the Vault encryption keys, unseal keys, and access token.

From the bastion host we spun up to stop the legacy application, we are going to:

 * Extract the relevant Consul K/V data from the legacy Consul.
 * Arrange this data in a format consumable by the new architecture.
 * Upload this data into the shared S3 bucket where the new instance will find
   it and load it.

See HashiCorp employees to coordinate this process.

#### Step 6. Full Terraform Run

Now that all the data assets are in place, it's time to run the full terraform
apply, so first plan:

`$ terraform plan`

Take a moment and look over the resources it's going to be create. It should be
considerably smaller than the existing legacy install. Once you're satisfied;

`$ terraform apply`

This will take approximately 30 minutes, mostly for the creation and restore of
the RDS cluster. Once terrform finishes, you'll need to setup the DNS for the
instance. The `dns_name` output that apply printed out is what you'll need to
configure the CNAME to point to. *NOTE:* The hostname that is being configured
as a CNAME must be the same hostname that was provided in the `tfvars` file!

Once the CNAME is setup, your installation is ready.

#### Step 7. Verification

Open up `https://<hostname>`, where `hostname` is the value configured in your
`tfvars` file. You should be presented with a screen indicating that Terraform
Enterprise is booting. This screen will autoreload and eventually you'll be
presented with a login screen. Note that due to database sizes and migrations,
this initial setup may be lengthy, perhaps as long as an hour. If you feel that
it has gone for too long, contact support for further help.

Now you're ready to login, so go right ahead. To verify that the installation
is complete, browse to a previous Terraform run. If everything loads correctly,
then all the data assets are in place and your upgrade was successful. If not,
please contact support for further assistance.
