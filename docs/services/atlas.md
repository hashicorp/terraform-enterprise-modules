# Atlas

Atlas is the main Rails application at the core of Terraform Enterprise. It is run in two different modes: frontends, and workers.

## `atlas-frontend`

The `atlas-frontend` service is responsible for running the main HTTP server used to access the Terraform Enterprise UI and API. This service represents the server responding to HTTP requests made to the central Atlas domain.

The frontend service also displays and provides monitoring and debugging information, including status UIs for Terraform Enterprise used to diagnose and maintain the system.

### Impact of Failure

Most services depend on the atlas-frontend service to make internal API requests, so this service being unavailable will cause widespread failure. The UI and API of Terraform Enterprise will be unavailable.

Additionally, debugging and monitoring UIs will be inaccessible and cannot be used.

### Restart Behavior

atlas-frontend restarts are not recommended, as it will cause the UI to be unavailable while restarting. This can take minutes to return to accessibility.

Because the Terraform Enterprise API server is unavailable during restarts, alerts, runs, or builds executing during a restart of `atlas-frontend` may fail.

Restarts to this service should only be issued when directed by HashiCorp support.

### Dependencies

- Postgres
- Redis

## atlas-worker

The `atlas-worker` service is responsible for executing background work for the main Atlas application. This service is critical due to it's widespread use by the Atlas Frontend to execute work based on API or UI requests.

### Impact of Failure

When the `atlas-worker` service is unhealthly, it's expected that many features will fail, including all build, run, and alert activity.

Additionally, the worker queue can build up during unavailablity and cause potential performance impact when started again.

However, the monitoring and diagnosis UI will still be available.

### Restart Behavior

`atlas-worker` restarts are only recommended during service failure to aid in debugging or maintenance. During restart the worker queue will not be processed. This means any alerts or new runs and builds could fail. However, new work will be safely queued during the restart period.

### Dependencies

- Postgres
- Redis

