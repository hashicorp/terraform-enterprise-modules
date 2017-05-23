# Support for Private Terraform Enterprise

If some aspect of Private Terraform Enterprise (PTFE) is not working as
expected, please reach out to support for help.

## Email

You can engage HashiCorp support via <support@hashicorp.com>. Please make sure
to use your organization email (not your personal email) when contacting us so
we can associate the support request with your organization and expedite our
response.

## Diagnostics

For most technical issues HashiCorp support will ask you to include diagnostic
information in your support request. You can create a support bundle by
connecting to your PTFE instance via SSH and running

    sudo hashicorp-support

You will see output similar to:

    ==> Creating HashiCorp Support Bundle in /var/lib/hashicorp-support
    ==> Wrote support tarball to /var/lib/hashicorp-support/hashicorp-support.tar.gz
    gpg: checking the trustdb
    gpg: marginals needed: 3  completes needed: 1  trust model: PGP
    gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
    gpg: next trustdb check due at 2019-04-14
    ==> Wrote encrypted support tarball to /var/lib/hashicorp-support/hashicorp-support.tar.gz.enc
    Please send your support bundle to HashiCorp support.

Attach the `hashicorp-support.tar.gz.enc` file to your support request. If it is
too large to attach you can send this to us via S3, FTP, or another data store
you control.

**Warning:** Make sure to attach the file ending in `.tar.gz.enc` as the
contents of `.tar.gz` are not encrypted!

**Note:** The GPG key used to encrypt the bundle is imported for the `root` user
only. If you use `sudo -sH`, change `$HOME`, or take a similar action, the
encryption step will fail. To assume `root` use `sudo -s` instead.

### About the Bundle

The support bundle contains logging and telemetry data from various components
in Private Terraform Enterprise. It may also include log data from Terraform or
Packer builds you have executed on your PTFE installation. For your privacy and
security, the entire contents of the support bundle are encrypted with a 2048
bit RSA key.

### Scrubbing Secrets

If you have extremely sensitive data in your Terraform or Packer build logs you
may opt to omit these logs from your bundle. However, this may impede our
efforts to diagnose any problems you are encountering. To create a custom
support bundle, run the following commands:

    sudo -s
    hashicorp-support
    cd /var/lib/hashicorp-support
    tar -xzf hashicorp-support.tar.gz
    rm hashicorp-support.tar.gz*
    rm nomad/*build-worker*
    tar -czf hashicorp-support.tar.gz *
    gpg2 -e -r "Terraform Enterprise Support" \
        --cipher-algo AES256 \
        --compress-algo ZLIB \
        -o hashicorp-support.tar.gz.enc \
        hashicorp-support.tar.gz

You will note that we first create a support bundle using the normal procedure,
extract it, remove the files we want to omit, and then create a new one.
