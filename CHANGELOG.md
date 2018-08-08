# Changelog

Terraform Enterprise release versions have the format:

```
vYYYYMM-N
```

Where:

* `YYYY` and `MM` are the year and month of the release.
* `N` is increased with each release in a given month, starting with `1`

## <a name="v201808-1"></a> v201808-1 (Aug 6, 2018)

APPLICATION LEVEL FEATURES:

1. Added a system email when a site admin is removed. This email is sent to all remaining site admins. 
1. Added settings that allow site admins to configure API rate limiting. By default, API rate limiting is enabled and limits clients to making 30 requests per second. However, by visiting the site admin and navigating to general settings, the global rate limit can be raised or disabled entirely. Due to the number of API requests Terraform Enterprise makes with regular use, the rate limit cannot be set lower than the default value of 30 requests per second. 
1. Added a download button for SAML metadata to the admin settings. An XML file is downloaded that can be imported into an identity provider. 
1. Changed link to module status page to always display if any module versions had ingress errors, instead of only when the latest version had ingress errors. 
1. Changed organization dropdown to simplify it. Organization settings are now linked at the top level. 
1. Changed webpage page titles for all pages to be unique. 
1. Added URL validation, to help prevent typos when adding VCS providers or setting up SAML authentication. 
1. Added ability to create state versions for a workspace using the v2 API. See API documentation for details. 
1. Added current state version as a relationship to workspaces in the API. See API documentation for details. 
1. Changed run comments design to make them more prominent. 
1. Changed the workspace "working directory" setting to be available even if no VCS integration is being used. 
1. Added a new site admin setting that allows customization of the support@hashicorp.com email address. 
1. Added confirmation step before regenerating or deleting API tokens, and before deleting SSH keys. 
1. Added "speculative" as a boolean attribute when creating configuration-versions via the API in order to trigger plan only runs. See the API documentation for details. 
1. Removed plan state versions output in the UI when there are no state versions for a run. 
1. Added enhanced error reporting for Sentinel policy checks. A policy check that encountered multiple evaluation errors will now have all errors displayed in the policy check error output. 
1. Added the ability to use the types standard library import with Sentinel policy checks. 
1. Parse summary metadata from `terraform plan` output 
1. Add support for the new Remote backend; this requires Terraform 0.11.8. 

APPLICATION LEVEL BUG FIXES:

1. Fixed a sporadically displaying error message when successfully queueing a plan. 
1. Fixed an issue where applies that take longer than 3 hours would fail to upload their state when finished. Applies will still time out after 24 hours. 
1. Fixed issue where the apply or plan logs were blank for the current run. 
1. Fixed an issue that prevented Bitbucket Cloud commits from getting Terraform plan status updates. 
1. Fixed an issue with pull request runs being initiated regardless of the branch the workspace is tracking. 
1. Fixed spacing on "clear filters" icon in Safari. 
1. Fixed an issue that caused malformed GitLab commit URLs. 
1. Fixed message when password update fails. 
1. Fixed an issue with missing SAML settings during migration. 
1. Improved postgresql container startup orchestration 
1. Fixed a bug in the Run state machine when certain transitions fail. 
1. Fixed an issue where policy checked runs would transition before confirmation. 
1. Fixed an issue that could cause Sentinel policy checks to hang when a configuration uses a module where all provider blocks in the module have aliases assigned to them. 
1. Fixed state truncation issue when Terraform dumps an "errored.tfstate" file. 

APPLICATION API BREAKING CHANGES:

1. Removed two-factor settings and recovery codes from API calls with an API token. They can now only be accessed with an active session. 

APPLICATION LEVEL SECURITY FIXES:

1. Purify module README Markdown before rendering. 

## <a name="v201807-2"></a> v201807-2 (July 20, 2018)

APPLICATION LEVEL BUG FIXES:

1. Fixed an issue where partial SAML settings prevented the application from booting.

## <a name="v201807-1"></a> v201807-1 (July 16, 2018)

APPLICATION LEVEL FEATURES:

1. Added ability to cancel a run during a Sentinel policy check. 
1. Added ability for user to update their username and email in the UI. 
1. Added ability to rename a workspace. 
1. Added user's email address to account details API. 
1. Added a new API for configuring an installation's Twilio settings, and a migration from previous settings. 
1. Added a link to runs created from pull requests to the pull request. 
1. Added a new first user creation page for new PTFE installations. 
1. Added a new API for configuring an installation's SMTP settings, and a migration from previous settings. 
1. Changed runs page to display Terraform logs by default when they are last event. 
1. Added a new API for configuring an installations SAML settings, and a migration from previous settings. 
1. Added a new site admin user interface, and a link to it in the account drop down. 
1. Added a periodic worker to kill Sentinel jobs that hang or otherwise error out in a way that does not send a correct response back to TFE and mark the run as errored. 
1. Added validation of OAuth client API URL at creation time. 
1. Changed the GitLab.com base API URL to the v4 API for new OAuth clients.  
1. Added current user avatar in site header when it is available. 
1. Removed "Plan successfully queued" notification. 
1. Added confirmation dialog when deleting a Sentinel policy. 
1. Added a debug setting for SAML SSO that allows an admin to see the SAMLResponse XML and processed values when login fails. 
1. Added a copyable signup link when adding new team members. 
1. Added ability to migrate legacy environments to workspaces. When creating a workspace, select the "Import from legacy (Atlas) environment" tab. For more information, see the Upgrade guide. 
1. Added an error when unpacking an unknown file type from a slug. 
1. Added warning log and halt execution of runs when any Terraform state file is detected in the configuration version. 
1. Change regsitry module repo validation to disallow uppercase characters. 
1. Enable bootstrap-less workflow in PTFE 
1. Split the PostgreSQL URI into component parts 

APPLICATION LEVEL BUG FIXES:

1. Fixed an issue where duplicate headers were being sent to Bitbucket Server, sometimes causing a 400 response. 
1. Fixed an issue where Bitbucket Server would send malformed webhook settings. 
1. Fixed an issue that brok browser history when API or network errors were encountered. 
1. Fixed an issue when Bitbucket Cloud sends a webhook payload with a changeset with no commits. 
1. Fixed an issue where Bitbucket Server returns an empty body during an unauthorized request. 
1. Fixed an issue where an organization could not be deleted due to dependencies being referenced. 
1. Fixed an issue where a run would attempt to queue up the wrong operation. 
1. Fixed an issue where changing workspace VCS settings then navigating away and back resulted in a broken VCS settings page. 
1. Fixed an issue with publishing registry modules inside of organizations with long names. 
1. Fixed an issue that prevented `X-Forwarded-For` headers from be respected and used for audit log entries. 
1. Fixed an issue where `no_proxy` environment variable was being ignored. 
1. Fixed an issue that prevented editing a variable name immediately after creating it 
1. Fixed an issue where auto-apply combined with a Sentinel policy check would prevent some runs from applying after confirmation. 
1. Fixed an issue that caused git branches ending in `master` to be treated as the default branch. 
1. Fixed an issue that prevented SAML SSO for admins logging in when SMTP was not properly configured. 
1. Fixed an issue that prevented GitLab merge request webhooks from creating plans and reporting back the plans status. 
1. Fixed an issue that caused tage creation events to sometimes incorrectly cause a run to be created. 
1. Fixed an issue that prevented providers from being filtered properly during module registry downloads. 
1. Fixed an issue where renaming organizations with published registry modules did not correctly re-namespace the modules and remain published in the same organization. 
1. Fixed an issue that prevented password managers from working well when updating a user's password. 
1. Fixed an issue that prevented sensitive variables from being edited in the UI. 
1. Fixed an issue where the first run on a workspace when using Gitlab as the VCS provider displayed a malformed commit url. 
1. Fixed an issue where run that take longer than 3 hours will no longer fail to upload their state when finished applying. Applies will still time out after 24 hours. 
1. Fixed an issue that prevented registry modules with plus signs in their version number from being accessed. 

## <a name="v201806-2"></a> v201806-2 (June 22, 2018)

APPLICATION LEVEL FEATURES:

- Add GCS support for artifact storage. (Replicated only)
- Allow for tuning of max usable memory per run. (Replicated only)

APPLICATION LEVEL BUG FIXES:

- Error when a state file is found in a VCS repository.
- Fix occasional proxy config failure. (Replicated only)
- Use `X-Forwarded-For` in audit log entries, if provided. (Replicated only)

## <a name="v201806-1"></a> v201806-1 (June 7th, 2018)

APPLICATION LEVEL FEATURES:

- Added links on state version page to run page and VCS commit.
- Added the workspace repo’s webhook URL to the VCS settings page.
- Added ability to submit run comments using the keyboard: just hit Command-Enter or Ctrl-Enter.
- Added appropriate error message when an invalid JSON request body is passed
- Added ability to disabling auto-queueing of runs when creating configuration versions via the API.
- Added pagination support to configuration versions API endpoint.
- Added download button to the modules configuration designer.
- Updated privacy policy.
- Removed SAML "Enable Team Membership Management" setting. Instead of enabling or disabling team membership management within TFE, team membership management is enabled or disabled by adding or removing the "Team Attribute Name" attribute in the identity provider.

APPLICATION LEVEL BUG FIXES:

- Fixed bug caused by starting the application while database migrations are running, resulting in inconsistent behavior.
- Fixed Bitbucket Cloud build status update failure for workspaces with long names.
- Fixed bug where spaces were added when copying VCS client URLs and tokens.
- Fixed display of newlines in run comments.
- Fixed display issues when VCS branch information is missing.
- Fixed an issue where runs would not show up for Bitbucket Server if the default branch was not "master".
- Fixed an issue that allowed a run to be applied before Sentinel policy checks have completed.
- Fixed an error when invalid Terraform versions are specified during workspace creation.
- Fixed errors generated when passing invalid filter parameters to the runs API.
- Fixed an issue with Bitbucket Server where non-default branch Runs did not appear.
- Fixed bug preventing users from generating personal authentication tokens via the UI.
- Fixed issue that caused some newly created workspaces to select a disabled Terraform verion as the latest version.
- Fixed issues with Terraform modules using semver metadata in their version number.
- Fixed an issue where duplicate headers were being sent to Bitbucket Server, sometimes causing a 400 response.
- Fixed an issue that caused Bitbucket Server to send malformed webhook settings.

APPLICATION API BREAKING CHANGES:

- Updated API endpoints to return external id as the user's id, changed from username.

## <a name="v201805-1"></a> v201805-1 (May 2nd, 2018)

APPLICATION LEVEL FEATURES:

1. Added API rate request limiting. Attempting to make more than 30 requests/second will result in throttling.
1. Added Terraform 0.11.2, 0.11.3, 0.11.4, 0.11.5, 0.11.6, and 0.11.7 to available version list.
1. Added VCS repo autocompletion when adding modules to the registry.
1. Added `message` as an attribute when creating a run through the API.
1. Added ability for modules in the registry to include git submodules.
1. Added compression and encryption for Terraform plan and apply logs at rest.
1. Added resiliency for temporary network failures when accesing configuration, state, and log files.
1. Added the ability to enable and disable SMTP integration.
1. Added a link to Support docs in the footer.
1. Added automatic unlinking of workspaces connected to VCS repositories when authorization repeatedly fails for the VCS repo.
1. Added copy to organization API token page to explain permissions for different token types.
1. Added one-click copy to clipboard for VCS provider callback URLs.
1. Added pagination controls to module registry list pages.
1. Added the repo identifier to the run page.
1. Changed module registry search to only returns results from the current organization.
1. Changed 2FA SMS issue name from `Atlas by HashiCorp` to `Terraform Enterprise`.
1. Changed 2FA application issuer name from `Atlas by HashiCorp` to `Terraform Enterprise`.
1. Changed redirect after deleting a module versions to redirect to the module page instead of the index.

APPLICATION LEVEL BUG FIXES:

1. Fixed issue that allowed plan-only destroy runs to be queued when the `CONFIRM_DESTROY` variable was not set.
1. Fixed issue copying two-factor auth recovery codes.
1. Fixed issue where returning to edit variables page after update displayed the old values.
1. Fixed issue creating a workspace with a Bitbucket Server repo that has no preexisting webhooks.
1. Fixed issue creating a workspace with no VCS repo in UI following validation error.
1. Fixed issue that allowed runs to be queued from the UI before the configuration version had finished uploading.
1. Fixed issue that caused unneeded polling for plan logs by stopping polling once the logs are complete.
1. Fixed issue that caused unwanted scrollbars to show up in run and state version lists.
1. Fixed issue that prevented auto-refresh on the workspace page while waiting for first run.
1. Fixed issue that prevented enabling the requirement of 2FA for an organization.
1. Fixed issue that sometimes caused the list of organizations to be out of date in the UI.
1. Fixed issue when editing some variables in the UI.
1. Fixed issue with module designer code generation when using modules with no required variables.
1. Fixed issue that prevented some build status updates to Bitbucket Cloud to fail.
1. Fixed some cases where editing a workspace would error.
1. Fixed some outdated documentation links.
1. Removed error message that displayed when a user visited the login page when they're already signed in.

APPLICATION API BREAKING CHANGES:

APPLICATION LEVEL SECURITY FIXES:

## <a name="v201804-3"></a> v201804-3 (April 17, 2018)

APPLICATION LEVEL BUG FIXES:

- Do not configure statsd; works around a possible Rails bug when starting Atlas. 
- Remove race condition when starting Vault. (installer only)
- More sane timeouts when unable to download slugs. 

## <a name="v201804-2"></a> v201804-2 (April 10, 2018)

APPLICATION LEVEL BUG FIXES:

* Fix terraform being able to properly authenticate to the Module Registry running in the cluster (installer only)

## <a name="v201804-1"></a> v201804-1 (April 5, 2018)

APPLICATION LEVEL FEATURES:

* GitLab is now supported as a source for Terraform modules. 
* When SAML SSO is enabled, the user session must have an active session to make API commands. The API token timeout may be set site-wide when SSO is enabled. 
* Remove the AuthContextClassRef element from the SAML SSO request so the identity provider's default AuthenticationMethod setting is used. 
* The username of a user can be specified for SAML SSO. 
* Add the ability to connect to SMTP without authentication. 
* We now enforce that ENV variable names conform to typical `bash` rules (beginning with a letter or underscore, and containing only alphanumerics and underscores) and that Terraform variable names only contain alphanumerics, underscores, and hyphens. 
* Allow ecdsa (`EC`) and ed25519 (`OPENSSH`) private keys. 
* Add an API and UI to allow organizations and users to mange their 2FA settings. 
* Revoking a VCS connection or deleting a VCS client now requires confirmation. 
* When a workspace becomes unlinked from its VCS repository, an email is sent to the organization owners. 
* Add ability to cancel in-progress plans and applies. 
* Workspaces can be created without a VCS connection in the UI. 
* A workspace's VCS connection can be edited through the UI and API. 
* Configuration error messages are exposed in the UI and API. 
* Rename workspace "Integrations" page to "Version Control" in UI. 
* Rename organization "OAuth Configuration" page to "Version Control" in UI. 
* Add Azure blob storage support. 

APPLICATION LEVEL BUG FIXES:

* Data cleanup is more reliable via HTTP retries and better exception handling. 
* Fixes issue with registry modules that require deep cloning of git submodules. 
* Fixed an internal server error that prevented some workspaces from being created with specific repsitories. 
* Fixed inline error messages for form fields with multi word labels. 
* Improved error messages in the API and UI when adding an OAuth client. 
* Fixed UI layout widths for widescreen. 
* The email address entered when a user forgot their password is no longer case sensitive. 
* We now redirect back to the OAuth page with error message when there is a failure to connect the client. 
* The UI now clarifies that Bitbucket Server VCS connections require a private SSH key. 
* Fixed missing "Override & Continue" button for Sentinel soft-mandatory policy check failures. 
* Very long lines in statefile diffs are now wrapped in the UI. 
* Flash notices in the UI now auto hide after 3 seconds, instead of 10. 
* Users are redirected to the v2 page they were trying to access after login. 
* Show an error message in the UI instead of a 500 error when an exception occurs while connecting an org oauth client to a VCS provider. 
* Fix a data race that cause some runs to get stuck when using the "Run this plan now" feature. 

APPLICATION API BREAKING CHANGES:

* The Registry Modules creation API has changed. Instead of supplying `ingress-trigger-attributes`, supply a `vcs-repo` object. Additionally, instead of supplying a `linkable-repo-id`, supply a `vcs-repo.identifier` 
* The `linkable-repos` resource has been renamed to `authorized-repos`, so please use that phrase in API requests. 
* Requests which contain invalid `include` parameters will now return 400 as required by the JSON API spec. 

APPLICATION LEVEL SECURITY FIXES:

* Upgrade loofah gem to 2.2.1 to address CVE-2018-8048. 
* Upgrade rails-html-sanitizer to  1.0.3 to address CVE-2018-374. 

MACHINE IMAGE FIXES:

* Adjust for EBS volumes have unexpected tags

## <a name="v201802-3"></a> v201802-3 (Feb 28, 2018)

APPLICATION LEVEL FEATURES:

* Enable the Module Registry for everyone, but disable unsupported VCS providers (GitLab, Bitbucket Cloud).
* Allow site admin membership to be managed through SAML and make the team name configurable.
* The SAML email address setting was removed in favor of always using `urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress`.
* The SAML `AuthnContextClassRef` is hardcoded to `urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport` instead of being sent as a blank value.
* Improved SAML error handling and reporting.
* Adds support for configuring the "including submodules on clone" setting when creating a workspace. Previously this had to be configured after creating a workspace, on the settings page.
* Move workspace SSH key setting from integrations page to settings page in UI.
* Add top bar with controls to plan and apply log viewer when in full screen mode.
* Improvements to VCS respository selection UI when creating a workspace.
* Improvements to error handling in the UI when creating a workspace.
* Remove VCS root path setting from workspaces in UI and API.
* API responses with a 422 status have a new format with better error reporting.
* Remove unused attributes from run API responses: `auto-apply`, `error-text`, `metadata`, `terraform-version`, `input-state-version`, `workspace-run-alerts`.
* Remove the `compound-workspace` API endpoints in favor of the `workspace` API endpoints.
* API responses that contain `may-<action>` keys will have those keys moved into a new part of the response: `actions`.
* Organizations now have names in place of usernames. API responses will no longer serialize a `username` key but will instead serialize a `name`.

APPLICATION LEVEL BUG FIXES:

* Allow workspace admins to read and update which SSH key is associated with a workspace. Previously only workspace owners could do this.
* Reject environment variables that contain newlines.
* Fix a bug that caused the VCS repo associated with a workspace displayed incorrectly for new workspaces without runs and workspaces whose current run used to a promoted configuration version.
* Fix a bug that resulted in plan and apply log output to sometimes be truncated in the UI.
* Fix a bug that prevented some environments and workspaces from being deleted.
* A few small fixes to Sentinel error reporting during creation and policy check in the UI.
* A few small fixes to UI when managing SSH keys.
* Missing translation added for configuration versions uploaded via the API.

APPLICATION LEVEL SECURITY FIXES:

* Upgrade ruby-saml gem to 1.7.0 to address CVE-2017-11428.
* Upgrade sinatra gem to 1.4.8 to address CVE-2018-7212.

## <a name="v201802-2"></a> v201802-2 (Feb 15, 2018)

APPLICATION LEVEL FEATURES:
  * Ensure the Archivist storage service sets the `x-amz-server-side-encryption` and `x-amz-server-side-encryption-aws-kms-key-id` HTTP headers on all `PutObject` calls to S3, when a KMS key is configured.
  * Add new `no_proxy` variable to support hosts to exclude from being proxied via `proxy_url`, if configured.

APPLICATION LEVEL BUG FIXES:
  * Fix a bug related to audit logging that prevented webhooks from being handled properly.

CUSTOMER NOTES:
  * Added documentation to `aws-standard/README.md` describing character constraints on user-provided values, such as `db_password`.

## <a name="v201802-1"></a> v201802-1 (Feb 6, 2018)

APPLICATION LEVEL FEATURES:
  * Adds support to publish modules from Github and Github Enterprise to the Module Registry
  * Adds the ability to search by keyword and filter the workspace list
  * Improves UI response to permissions by hiding/disabling forms/pages based on user’s access level.
  * Adds audit events to the logs to capture the user identity, operation performed and target resource.
  * Configurations can now be promoted across workspace via the API
  * Improves SAML team mapping to use custom names to perform matching

APPLICATION LEVEL BUG FIXES:
  * Fixes the provider and module name parsing when ‘-’ is used in publishing of modules to the module registry.
  * Fixes broken redirects to external site on bad requests.
  * Fixes bug with triggering runs from Bitbucket Server when a module and workspace are both linked to the same source.
  * Fixes rendering issues in IE11
  * Fixes rendering issue with scroll bars on some input fields in Chrome 40.0.2214.115+ on Windows

## <a name="v201801-2"></a> v201801-2 (Jan 18, 2018)

APPLICATION LEVEL BUG FIXES:
  * Increase memory allocation for Terraform Module Registry to prevent forced termination when processing large modules.

## <a name="v201801-1"></a> v201801-1 (Jan 12, 2018)

APPLICATION LEVEL BUG FIXES:
  * Fix a bug in the Terraform Module Registry where multiple jobs trying to ingress the same version of the same module concurrently errored and would not be retried

MACHINE IMAGE BUG FIXES:
  * Includes OS-level security updates to address Meltdown (see https://usn.ubuntu.com/usn/usn-3522-1/)

## <a name="v201712-2"></a> v201712-2 (Dec 18, 2017)

APPLICATION LEVEL BUG FIXES:
  * Clarify the purpose of organization API tokens

MACHINE IMAGE BUG FIXES:
  * Fix postgres compatibility with the private module registry


## <a name="v201712-1"></a> v201712-1 (Dec 7, 2017)

APPLICATION LEVEL FEATURES:
  * Includes new Terraform Enterprise interface featuring Workspaces (see https://www.hashicorp.com/blog/hashicorp-terraform-enterprise-beta for details)

APPLICATION LEVEL BUG FIXES:
  * Properly handle repositories with many webhooks
  * Screens with many elements now use pages to display all data

## <a name="v201711-1"></a> v201711-1 (Nov 1, 2017)

APPLICATION LEVEL BUG FIXES:
  * The Bitbucket Server integration no longer sends empty JSON payloads with get requests
  * Force Canceled runs will create a run event so that they no longer appear to be planning in the UI

MACHINE IMAGE BUG FIXES:
  * Increase the capacity of the UI to prevent it being unavailable due
    to starvation.

## <a name="v201709-3"></a> v201709-3 (Sep 29, 2017)

MACHINE IMAGE BUG FIXES:
  * Properly write the vault root key envvar file.

## <a name="v201709-2"></a> v201709-2 (Sep 28, 2017)

MACHINE IMAGE BUG FIXES:
  * cloud.cfg no longer conflicts with the cloud-init package.
  * Restoring from an older, timestamp based backup no longer hangs when
    there are a large number of backups.

## <a name="v201709-1"></a> v201709-1 (Sep 13, 2017)

APPLICATION LEVEL FEATURES:
  * Sends a flag to terraform workers on all new runs to enable filesystem 
    preservation between plan/apply.
  * Add support for Terraform 0.10.

APPLICATION LEVEL BUG FIXES:
  * State uploads now validate lineage values.
  * Fixes a potential race during Terraform state creation.
  * Fixes a subtle bug when loading Terraform states which were created prior
    to having the MD5 checksum in a database column.
  * Gradually migrate all Terraform states out of the Postgres DB and 
    into our storage service, Archivist.

MACHINE IMAGE FEATURES:

  * Add ability to prompt for setup data and store it inside Vault rather than
    store it in S3+KMS (activated via new `local_setup` Terraform option).

TERRAFORM CONFIG FEATURES:

  * Add `local_setup` variable to tell TFE to prompt for setup data on first
    boot and store it within Vault rather than rely on S3+KMS for setup data.
  * Make `key_name` variable optional, allowing for deployments without SSH
    access.

## <a name="v201708-2"></a> v201708-2 (Aug 16, 2017)

MACHINE IMAGE BUG FIXES:

  * Correct out of memory condition with various internal services that prevent
    proper operation.

## <a name="v201708-1"></a> v201708-1 (Aug 8, 2017)

APPLICATION LEVEL BUG FIXES:

  * Fixes a bug where TF slugs would only get encrypted during terraform push.
  * Fixes state parser triggering for states stored in external storage (Archivist).
  * Fixes a bug where encryption contexts could be overwritten.
  * Send commit status updates to the GitHub VCS provider when plan is "running" (cosmetic)

MACHINE IMAGE BUG FIXES:

  * Manage upgrading from v201706-4 and earlier properly.

## <a name="v201707-2"></a> v201707-2 (July 26, 2017)

APPLICATION LEVEL BUG FIXES:

  * Send commit status updates to VCS providers while waiting for MFA input

## <a name="v201707-1"></a> v201707-1 (July 18, 2017)

APPLICATION LEVEL FEATURES:

  * Add support for releases up to Terraform 0.9.9.

APPLICATION LEVEL BUG FIXES:

  * Displays an error message if the incorrect MFA code is entered to confirm a Run.
  * Address issue with large recipient groups in new admin notification emails.
  * Fixes a 500 error on the Events page for some older accounts.
  * Fix provider names in new environment form.
  * Update wording in the Event Log for version control linking and unlinking.
  * Fetch MFA credential from private registries when enabled.
  * Fix ability to cancel Plans, Applies, and Runs

MACHINE IMAGE FEATURES:

  * Add ability to use local redis.
  * This adds a new dependency on EBS to store the redis data.

TERRAFORM CONFIG FEATURES:

  * Add `local_redis` variable to configure cluster to use redis locally, eliminating
    a dependency on ElasticCache.
  * Add `ebs_size` variable to configure size of EBS volumes to create to store local
    redis data.
  * Add `ebs_redundancy` variable to number of EBS volumes to mirror together for
    redundancy in storing redis data.
  * Add `iam_role` as an output to allow for additional changes to be applied to
    the IAM role used by the cluster instance.


## <a name="v201706-4"></a> v201706-4 (June 26, 2017)

APPLICATION LEVEL FEATURES:

  * Add support for releases up to Terraform 0.9.8.

APPLICATION LEVEL BUG FIXES:

  * VCS: Send commit status updates after every `terraform plan` that has a
    commit.
  * Fix admin page that displays Terraform Runs.
  * Remove application identifying HTTP headers.

MACHINE IMAGE BUG FIXES:

  * Fix `rails-console` to be more usable and provide a command prompt.
  * Fix DNS servers exposed to builds to use DNS servers that are configured
    for the instance.
  * Redact sensitive information from error output generated while talking to
    VCS providers.
  * Refresh tokens for Bitbucket and GitLab properly.
  * Update build status on Bitbucket Cloud PRs.

EXTRAS CHANGES:

  * Parametirez s3 endpoint region used for setup of S3 <=> VPC peering.


## <a name="v201706-3"></a> v201706-3 (June 7, 2017)

MACHINE IMAGE BUG FIXES:

  * Exclude all cluster local traffic from using the outbound proxy.

## <a name="v201706-2"></a> v201706-2 (June 5, 2017)

APPLICATION LEVEL BUG FIXES:

  * Clear all caches on boot to prevent old records from being used.

MACHINE IMAGE FEATURES:

  * Added `clear-cache` to clear all caches used by the cluster.
  * Added `rails-console` to provide swift access to the Ruby on Rails
    console, used for lowlevel application debugging and inspection.

## <a name="v201706-1"></a> v201706-1 (June 1, 2017)

APPLICATION LEVEL FEATURES:

  * Improve page load times.
  * Add support for releases up to Terraform 0.9.6.
  * Make Terraform the default page after logging in.

APPLICATION LEVEL BUG FIXES:

  * Bitbucket Cloud stability improvements.
  * GitLab stability improvements.
  * Address a regression for Terraform Runs using Terraform 0.9.x that
    caused Plans run on non-default branches (e.g. from Pull Requests)
    to push state and possibly conflict with default branch Terraform Runs.
  * Ignore any state included by a `terraform push` and always use state
    within Terraform Enterprise.
  * Prevent `terraform init` from accidentially asking for any input.
  * Allow sensitive variable to be updated.
  * Fix "Settings" link in some cases.

MACHINE IMAGE FEATURES:

  * Automatically scale the number of total concurrent builds up based on
    the amount of memory available in the instance.
  * Add ability to configure instance to send all outbound HTTP and HTTPS
    traffic through a user defined proxy server.

TERRAFORM CONFIG FEATURES:

  * Add `proxy_url` variable to configure outbound HTTP/HTTPS proxy.

DOCUMENTATION CHANGES:

  * Remove deprecated references to Consul environments.
  * Include [Encrypted AMI](docs/encrypt-ami.md) for information on using
    encrypted AMIs/EBS.
  * Add [`network-access`](docs/network-access.md) with information about
    the network access required by TFE.
  * Add [`managing-tool-versions`](docs/managing-tool-versions.md) to document
    usage of the `/admin/tools` control panel.

## <a name="v201705-2"></a> v201705-2 (May 23, 2017)

APPLICATION LEVEL CHANGES:

  * Prevent sensitive variables from being sent in the clear over the API.
  * Improve setup UI.
  * Add support for releases up to Terraform 0.9.5.
  * Fix bug that prevented packer runs from having their logs automatically
    display.

MACHINE IMAGE CHANGES:

  * Fix archivist being misreported as failing checks.
  * Add ability to add SSL certificates to be trusted into /etc/ssl/certs.
  * Add awscli to build context for use with local\_exec.
  * Infer the s3 endpoint from the region to support different AWS partitions.
  * Add ability to run custom shell code on the first boot.

TERRAFORM CONFIG CHANGES:

  * Add `startup_script` to allow custom shell code to be injected and run on
    first boot.
  * Allow for customer managed security groups.


DOCUMENTATION CHANGES:

  * Include [documentation](docs/support.md) on sending support information via the
    `hashicorp-support` tool.

## <a name="v201705-1"></a> v201705-1 (May 12, 2017)

APPLICATION LEVEL CHANGES:

 * Improve UI performance by reducing how often and when pages poll for new
   results.
 * Add support for releases up to Terraform 0.9.4.
 * Add support for releases up to Packer 0.12.3.
 * Fix the From address in email sent by the system.
 * Allow amazon-ebssurrogate builder in Packer.
 * Handle sensitive variables from `packer push`.
 * Improve speed of retrieving and uploading artifacts over HTTP.
 * Added integrations with GitLab and BitBucket Cloud.
 * Removed Consul and Applications functionality.

MACHINE IMAGE CHANGES:

 * Fix an issue preventing the `hashicorp-support` command from successfully
   generating a diagnostic bundle.
 * Fix ability to handle more complex database paswords.
 * More explicit region utilization in S3 access to support S3 in Govcloud.

TERRAFORM CONFIG CHANGES:

 * Make `region` a required input variable to prevent any confusion from the
   default value being set to an unexpected value. Customers who were not
   already setting this can populate it with the former default: `"us-west-2"`
 * Add ability to specify the aws partition to support govcloud.
 * Reorganize supportive modules into a separate `aws-extra` directory
 * Remove a stale output being referenced in `vpc-base`
 * Work around a Terraform bug that prevented the outputs of `vpc-base` from
   being used as inputs for data subnets.
 * Explicitly specify the IAM policy of the KMS key when creating it.
 * Add an Alias to the created KMS key so it is more easily identifiable AWS
   console.
 * Add ability to start the ELB in internal mode.
 * Specify KMS key policy to allow for utilization of the key explicitly by
   the TFE instance role.
 * Add KMS alias for key that is utilized for better inventory tracking.


## <a name="v201704-3"></a> v201704-3

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Properly handle database passwords with non-alphanumeric characters
* Remove nginx's `client_max_body_size` limit so users can upload files larger than 1MB

TERRAFORM CONFIG CHANGES:

* Fix var reference issues when specifying `kms_key_id` as an input
* Add explicit IAM policy to KMS key when Terraform manages it
* Add explicit KMS Key Alias for more easily referencing the KMS key in the AWS Web Console

## <a name="v201704-2"></a> v201704-2

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Add `hashicorp-support` script to create an encrypted bundle of diagnostic information for passing to HashiCorp Support
* Switch main SSH username to `tfe-admin` from default `ubuntu`
* Allow AMI to be used in downstream Packer builds without triggering bootstrap behavior

TERRAFORM CONFIG CHANGES:

* Allow `kms_key_id` to be optionally specified as input
* Remove unused `az` variable

## <a name="v201704-1"></a> v201704-1

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Disable Consul remote exec
* Install git inside build worker Docker container to facilitate terraform module fetching
* Don't redirect traffic incoming from local build workers

TERRAFORM CONFIG CHANGES:

* Prevent extraneous diffs after RDS database creation

## <a name="v201703-2"></a> v201703-2

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Prevent race condition by waiting until Consul is running before continuing boot 
* Ensure that Vault is unsealed when instance reboots

## <a name="v201703-1"></a> v201703-1

* Initial release!
