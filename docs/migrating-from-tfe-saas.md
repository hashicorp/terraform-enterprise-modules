# Migrating from Terraform Enterprise SaaS

If you are already a user of the Terraform Enterprise SaaS (hereafter "the SaaS"), you may have Environments that you want to migrate over to your new Private Terraform Enterprise (PTFE) installation.

This document contains instructions on migrating an Environment from the SaaS to PTFE.

These instructions assume Terraform 0.9 or greater. See [docs on legacy remote state](https://www.terraform.io/docs/backends/legacy-0-8.html) for information on upgrading usage of remote state in prior versions of Terraform.

### Prerequisites

Have an Atlas Token handy for both PTFE and the SaaS. The following examples will assume you have these stored in `PTFE_ATLAS_TOKEN` and `SAAS_ATLAS_TOKEN`, respectively.

### Step 1: Connect local config to SaaS

Set up a local copy of your Terraform config that's wired in to the SaaS via a `backend` block.

Assuming your environment is located at `my-organization/my-environment` in the SaaS - make your way to a local copy of the Terraform config, and ensure you have a backend configuration like this:

```tf
terraform {
  backend "atlas" {
    name = "my-organization/my-environment"
  }
}
```

Place your SaaS token in scope and initialize:

```
export ATLAS_TOKEN=$SAAS_ATLAS_TOKEN
terraform init
```

### Step 2: Copy state locally

Now we'll want to get the latest copy of the state locally so we can push it to PTFE - you can do this by commenting out the `backend` section of your config:

```tf
# Temporarily commented out to copy state locally
# terraform {
#   backend "atlas" {
#     name = "my-organization/my-environment"
#   }
# }
```

Now, rerunning initialization:

```
terraform init
```

This will cause Terraform to detect the change in backend and ask you if you want to copy the state.

Type `yes` to allow the state to be copied locally. Your state should now be present on disk as `terraform.tfstate`, ready to be uploaded to the PTFE backend.

### Step 3: Update backend configuration for PTFE

Change the backend config to point to your PTFE installation:

```tf
terraform {
  backend "atlas" {
    address = "https://tfe.mycompany.example.com" # the address of your PTFE installation
    name    = "my-organization/my-environment"
  }
}
```

Now, place your PTFE token in scope and re-initialize:

```
export ATLAS_TOKEN=$PTFE_ATLAS_TOKEN
terraform init
```

You will again be asked if you want to copy the state file. Type `yes` and the state will be uploaded to your PTFE installation.
