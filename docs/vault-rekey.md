# Rekeying Vault

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

(Requires a machine image `v201709-1` or later)

The Vault instance used by Terraform Enterprise (TFE) self-manages its unseal key by
default. This unseal key is stored in a KMS-encrypted file on S3 and is
downloaded by the instance on boot to automatically unseal Vault.

If the above configuration is insufficient for your security needs, you can
choose to rekey the Vault instance after bootstrapping is completed. This
allows you to change the key shares and key threshold settings, places the
Vault unseal keys under your control, and deactivates the auto-unseal behavior
of the TFE instance.

The Vault documentation has a
[guide](https://www.vaultproject.io/guides/rekeying-and-rotating.html#rekeying-vault)
on how to perform a rekey operation and `vault rekey -help` output provides
full docs on the various options available.

## Walkthrough of Rekey Operation

Here is an example of rekeying the TFE vault to use 5 key shares with a key
threshold of 2. These commands are executed from an SSH session on the TFE
instance as the `tfe-admin` user.

```
vault rekey -init -key-shares=5 -key-threshold=2

WARNING: If you lose the keys after they are returned to you, there is no
recovery. Consider using the '-pgp-keys' option to protect the returned unseal
keys along with '-backup=true' to allow recovery of the encrypted keys in case
of emergency. They can easily be deleted at a later time with
'vault rekey -delete'.

Nonce: acdd8a46-3b...
Started: true
Key Shares: 5
Key Threshold: 2
Rekey Progress: 0
Required Keys: 1
```

The rekey operation has now been started. The printed nonce and the current
unseal key are required to complete it.

The current unseal key can be found under `/data/vault-unseal-key`

```
VAULT_UNSEAL_KEY=$(sudo cat /data/vault-unseal-key)
vault rekey -nonce=acdd8a46-3b... $VAULT_UNSEAL_KEY

Key 1: jcLit6uk...
Key 2: qi/AfO30...
Key 3: t3TezCbE...
Key 4: 5O6E8WFU...
Key 5: +bWaQapk...

Operation nonce: acdd8a46-3b2a-840e-0db8-e53e84fa7e64

Vault rekeyed with 5 keys and a key threshold of 2. Please
securely distribute the above keys. When the Vault is re-sealed,
restarted, or stopped, you must provide at least 2 of these keys
to unseal it again.

Vault does not store the master key. Without at least 2 keys,
your Vault will remain permanently sealed.
```

## IMPORTANT: After Rekeying

**Note**: After performing a rekey it's important to remove the old unseal key
and trigger a backup before rebooting the machine. This will ensure that TFE
knows to prompt for Vault unseal keys.

```
sudo rm /data/vault-unseal-key
sudo atlas-backup
```
