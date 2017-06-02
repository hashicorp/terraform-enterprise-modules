# Managing Tool Versions

Terraform Enterprise has a control panel that allows admins to manage the versions of Terraform and Packer and their download locations.

This control panel is available at the `/admin/tools` path or as a link in the sidebar from the general administrative interface at `/admin/manager`.

![admin-tools-index](assets/admin-tools-index.png)

Here you'll find a list of Packer and Terraform versions. If you click the `Edit` button on an individual tool version, you'll see that each version consists of:

* **Version Number** - will show up in dropdown lists for users to select
* **Download URL** - must point to a `linux-amd64` build of the tool
* **SHA256 Checksum Value** - must match the SHA256 checksum value of the download

![admin-tools-edit](assets/admin-tools-edit.png)
