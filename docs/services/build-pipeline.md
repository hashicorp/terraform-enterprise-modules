# Build Pipeline

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

The Terraform Enterprise build pipeline consists of a Manager and Worker service for each of Packer and Terraform.

## `packer-build-manager`

The `packer-build-manager` service is responsible for queueing and providing updates for builds running in Packer back to Atlas. Atlas Frontend then presents this information to the user. `packer-build-manager` does not execute Packer.

Upon running a build in Atlas, `packer-build-manager` queues and beings monitoring a build's progress, executed by `packer-build-worker`.  Additionally, `packer-build-manager` will upload logs from a build to [`logstream`](archivist.md) for displaying in the TFE UI

`packer-build-manager` also handles build cancelation requests made from the Atlas Frontend.

### Dependencies

- [`atlas-frontend`](atlas.md)
- [`logstream`](archivist.md)
- `packer-build-worker`
- RabbitMQ

### Impact of Failure

When failing, builds can fail to queue, run, and cancel. Builds will appear to not be queued or no progress updates will be given for running builds. Essentially, all Packer related TFE activity will fail.

## `packer-build-worker`

The `packer-build-worker` service is responsible for executing Packer and providing updates for builds running in Packer back to the [Packer Build Manager](/help/private-atlas/services/packer-build-manager), which then sends that infromation to the Atlas Frontend service for display to the user.

Upon running a build in TFE, `packer-build-worker` pulls the build from the queue and executes it with Packer in an isolated network environment. Each build in a Packer template is split and executed independently. This service will send a signal to interrupt Packer if a user requests a cancelation.

Because of its network isolation, the `packer-build-worker` service will not show up in the admin monitoring UI.

### Impact of Failure

When failing, builds can fail to execute. Essentially, all Packer related TFE activity will fail.

### Dependencies

- `packer-build-manager`
- RabbitMQ

## `terraform-build-manager`

The `terraform-build-manager` service is responsible for queueing and providing updates for runs (plans, applies) running in Terraform back to Atlas. Atlas then presents this information to the user. `terraform-build-manager` does not execute Terraform.

Upon running a plan or apply in Atlas, `terraform-build-manager` queues and beings monitoring a run's progress, executed by `terraform-build-worker`.
Additionally, `terraform-build-manager` will upload logs from a build to [`logstream`](archivist.md) for display in the Atlas UI.
Additionally, run cancelation is handled by `terraform-build-manager`.

### Impact of Failure

When failing, plans or applies can fail to queue, run, and cancel. Builds will
appear to not be queued or no progress updates will be given for running
plans or applies. Essentially, all Terraform related Atlas activity will fail.

### Dependencies

- [`atlas-frontend`](atlas.md)
- [`logstream`](archivist.md)
- `terraform-build-worker`
- RabbitMQ

## `terraform-build-worker`

The `terraform-build-worker` service is responsible for executing Terraform and providing updates for runs (plans, applies) running in Terraform back to the `terraform-build-manager`, which then sends that information to the Atlas Frontend service for display to the user.

Upon queueing a plan or confirm an apply in Atlas, `terraform-build-worker` pulls the run from the queue and executes it with Terraform in an isolated network environment. Plans and applies are executed independently. This service will send a signal to interrupt Terraform if a user requests a cancelation.

Because of its network isolation, the `terraform-build-worker` service
will not show up in the admin monitoring UI.


### Impact of Failure

When failing, runs can fail to execute. Essentially, all Terraform related TFE activity will fail.

### Dependencies

- `terraform-build-manager`
- RabbitMQ
