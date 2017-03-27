# Terraform Enterprise Architecture

This document describes aspects of the architecture of Terraform Enterprise.

## Services

These are the services used to run Terraform Enterprise. Each service contains a description of what actions it performs, a policy for restarts, impact of failing or degraded performance, and the service's dependencies.

- [`atlas-frontend` and `atlas-worker`](services/atlas.md)
- [`archivist`, `binstore`, `storagelocker`, and `logstream`](services/archivist.md)
- [`packer-build-manager`, `packer-build-worker`, `terraform-build-manager`, and `terraform-build-worker`](services/build-pipeline.md)
- [`slug-extract`, `slug-ingress`, `slug-merge`](services/slugs.md)

## Data Flow Diagram

The following diagram shows the way data flows through the various services and data stores in Terraform Enterprise.

![tfe-data-flow-arch](assets/tfe-data-flow-arch.png)

(Note: The services in double square brackets are soon to be replaced by the service that precedes them.)

