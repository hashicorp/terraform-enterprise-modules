# Internal Settings

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

The product has a few settings which can be changed to manipulate the behavior
of the product. Below are a complete listing of them, please read the cavaets
about each before using them.

These values can be reand and write using the `ptfe-settings` command on the
machine.

## Worker Autoscaling

The options concern the product scaling the maximum number of concurent packer
and terraform jobs to run concurrently. It automatically scales up based on
the amount of memory available in the machine, so booting on a larger instance
type will automatically increase the maximum throughput.

* _reserved-system-memory_: The amount of memory (in MB) to reserve for system
  tasks, such as consul, vault, shells, and anything else that is installed on
  the machine by customers. *Default: 4000*
* _minimum-workers_: The minimum number of workers to use when auto-scaling
  the worker count. *Default: 10*
* _packer-memory_: The amount of memory (in MB) to give to each packer build
  as it's running: *Default: 256*
* _terraform-memory_: The amount of memory (in MB) to give to each packer build
  as it's running: *Default: 256*
* _explicit-build-workers_: Specify how many packer and terraform build
  workers to use. *NOTE* This value is used regardless of the amount of memory in the
  machine, please only use it if the above settings don't auto-scale properly.
  *No Default*
