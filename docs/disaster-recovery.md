# Disaster Recovery (DR)

Private Terraform Enterprise (PTFE) is designed to withstand failures of the
primary host and loss of a single availability zone or RDS replica in AWS, and
to be capable of self-upgrade and automatic recovery within a single region.
PTFE relies on features in AWS KMS, S3, RDS, and EC2 to accomplish this.

For a combination of cost, security, and complexity reasons, HashiCorp does not
configure cross-region backups in a normal installation. You may add this
capability yourself.

The rest of this document will explain the mechanisms that PTFE uses to perform
automated backup and restore, and how you can reproduce this process across
regions (with some manual intervention). Familiarity with AWS, Terraform, and
Linux is assumed.

## Automated Upgrade and Recovery

When you install PTFE, the default configs place a bundle of data into EC2 user
data. At boot time, the instance reads this data to discover the S3 bucket from
which it retrieves additional encrypted data, including its database password
and any existing instance state. After retrieving this data, the instance
proceeds with the upgrade/recovery process automatically.

The upgrade/recovery process is idempotent and runs each time the instance
boots, allowing seamless unattended operation under normal circumstances.

### Limitations

Automated upgrade and recovery may cease to work if the instance is booted in a
new region, if configuration changes have been made outside of HashiCorp's
Terraform configuration or provided AMI, or if some other service (such as RDS,
S3, or ElastiCache) is unavailable, such as in a region-wide failure scenario.

## State

PTFE stores state in 6 places:

- KMS
- S3
- RDS
- EC2 API
- PTFE EC2 instance
- ElastiCache (ephemeral data)

### KMS

PTFE uses AWS KMS to encrypt data at rest, including data in S3 and RDS. KMS
keys cannot be exported or copied between regions. Instead, when migrating data
between regions, data is decrypted from rest using the KMS in the source region,
encrypted in transit using TLS, and then re-encrypted using a new KMS key in the
target region.

As such, when performing a cross-region backup you will need to have access to
both keys. However, when performing a restore operation you will only need to
have the KMS key in the target region.

#### Action Items

- Perform a cross-region backup using the source KMS key created by Hashicorp's
	Terraform configuration and a new target KMS key
- Make sure the target KMS key is available for restore

### S3

PTFE stores blob data (tarballs, logs, etc) in S3. S3 data must be copied in
order for the application to continue functioning after a restore operation. It
should be sufficient to copy the bucket verbatim using any of S3's cross-region
bucket replication features.

You will want to sync and replicate the entire contents of the bucket _except_
for the `tfe-backup` folder, which includes encrypted backup files. For more
details see the **Internal Data** section, below.

#### Action Items

- Configure [cross-region S3 replication](http://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html)
- Perform a one-time sync of existing data (replication only applies to _new_
	objects after it has been enabled)
- Remember to exclude objects with the `tfe-backup` prefix, which must be backed
	up separately

### RDS

PTFE stores data (builds, ids, etc.) in RDS. RDS data must be copied in order
for the application to continue functioning after a restore operation.

You may either setup a cross-region streaming backup (read replica) or copy
individual snapshots. We commend setting up a [cross-region read replica](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html#USER_ReadRepl.XRgn),
which will proactively provide you with a copy of your database in the event of
a total region outage.

Note that when restoring PTFE using a read replica, you will need to promote the
read replica into primary as well as convert it into a cluster. This will take
some time depending on the size of your database. You may opt to create a read
replica cluster to reduce downtime, though this will incur additional costs.

Additionally, after you promote your new primary but before you spin up a PTFE
VM, take a snapshot of your cross-region replica. This ensures you can roll your
database back to a consistent state if there is a problem with the restore
process.

#### Action Items

- Configure a cross-region encrypted read replica of your PTFE RDS
instance
- (During restore) take a snapshot of your RDS instance so you can restore your
	data to a point in time if there is a problem during the restore operation
- (During restore) promote the read-replica to act as a cluster primary

### EC2 and EC2 User Data

You will have a different AMI ID in the target region. Make sure this AMI is the
same release or later than the one you are restoring from. For example if you
take the backup with 201705-1 make sure you use that version, or a later
version like 201705-2 or 201706-1. Newer versions of the AMI sometimes include
data migrations but we do not test these in reverse, so downgrading from e.g.
201705-2 to 201705-1 may cause data loss.

The default Terraform configuration provided by HashiCorp uses EC2 user data to
specify where the instance should find its bootstrapping data, which includes
the database password and S3 bucket to search for backups.

When you want to restore your instance to a new region, you will need to specify
the new RDS instance data, password, KMS key, and S3 endpoint in Terraform so
the instance will find it.

#### Action Items

- Make sure the PTFE AMI in the target region is at least the same version as
	the one you are restoring from
- (During restore) make sure to reconfigure Terraform to reflect the new RDS
	read replica, S3 bucket, and KMS key

### Internal Data

PTFE captures a rolling snapshot of its internal data every hour and during a
clean OS shutdown (during typical maintenance, for example). This snapshot data
is pushed into S3 and encrypted at rest using AWS KMS.

You can invoke this process manually by running `/usr/local/bin/atlas-backup`
inside the instance. The corresponding restore command is
`/usr/local/bin/atlas-restore`. Both of these are bash scripts and you can
inspect them to learn more about how they work.

Because KMS keys are restricted to individual regions, you will need to decrypt
and re-encrypt the snapshot file(s) in order to copy them to another region and
have them usable by PTFE.

For example, you may copy from S3 to an EC2 instance in the source region, `scp`
the archive to an EC2 instance in the target region, and then copy to the S3
bucket in the target region. Using this approach you can keep your KMS keys
restricted using IAM roles, and run the backup process on a regular interval.

	# source region EC2 instance
    aws configure set s3.signature_version s3v4
    aws s3 cp $BACKUP_BUCKET/tfe-backup/$BACKUP_FILE ./$BACKUP_FILE

	scp ./$BACKUP_FILE target.host:/tmp/$BACKUP_FILE

	# target region EC2 instance
	aws configure set s3.signature_version s3v4
	aws s3 cp --sse=aws:kms --sse-kms-key-id=$KMS_KEY_ID $BACKUP_FILE $BACKUP_BUCKET/tfe-backup/$BACKUP_FILE

Please note that the path inside the bucket _must_ use `tfe-backup`. For more
details please refer to `/usr/local/bin/atlas-restore` inside the PTFE VM.

#### Action Items

- Make sure the latest `atlas-backup-[timestamp].tar.gz` file is copied into the
	S3 bucket you will use to restore your PTFE installation.
- Make sure the `atlas-backup-[timestamp].tar.gz` file is decrypted with the KMS
	key from the source region and re-encrytped with the KMS key in the target
	region.

## Testing the Restore

Inside a single-region context you can verify the restore process is working
simply by terminating your VM and allowing AWS autoscaling to replace it with
a new one. Using HashiCorp's default configuration, the restore process will
happen automatically.

In a cross-region context you will need to take the extra steps outlined above,
but if you do so the restore process should also happen automatically. Because
of the way the startup process works, there is no "manual" restore process.
As long as you have your S3 backup in place and correct user data configured for
the instance, it will boot and automatically perform the restore operation.

It is _possible_ to invoke the various commands manually to restore (for
example) an unencrypted backup archive so in the worst case scenario, as long as
your data is intact, we will be able to assist you with a restore operation.
However, for simplicity and forward-compatibility with new versions of PTFE, we
strongly recommend verifying that the automated restore process works in your
second region before you encounter a disaster scenario.

### Validation Steps

To validate the restore you should login to the Private Terraform Enterprise UI
and inspect a secret from one of your environments, as well as viewing logs from
a past build. This validates the following actions took place:

1. The VM is booted correctly
2. The database was restored
3. Vault has unsealed and is able to decrypt secret data stored in the database
4. PTFE is able to retrieve data (logs) from S3

This is not an exhaustive verification of functionality but these criteria
indicate a successful restore.

If you have trouble validating the restore the following logs may be helpful:

	journalctl -u atlas-setup

The primary indicator of a failed restore operation is a sealed vault, or a
vault that has been initialized from scratch. This will prevent you from logging
into with your admin credentials or from decrypting secrets inside the Terraform
Enterprise UI.

If you are unable to reach the instance (or it is stuck in a getting ready
state) verify that all of the required Terraform resources are available. You
can also inspect:

	journalctl -u nomad
	journalctl -u vault
	journalctl -u consul

to see other types of startup issues.

If you get stuck, please use the `hashicorp-support` command and reach out
to HashiCorp support for assistance.

## After a Restore

After a cross-region restore operation some ephemeral data from PTFE is lost,
including the list of work that is currently in progress. This is mostly a
cosmetic issue. Because Terraform operates in an idempotent, transactional way
all essential data can be refreshed from your cloud provider's APIs.

However, you may need to manually cancel jobs via the admin UI, and any work
that is in flight at the time of restore (including Packer and Terraform runs)
will need to be re-queued. Additionally, if Terraform was in the process of
creating or destroying resources, these operations may happen twice. Make sure
to check your cloud provider(s) for orphaned resources after performing a
restore.
