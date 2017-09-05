# Debugging PTFE

There will be times when PTFE doesn't behave as you'd like. This document is
designed to provide you, the human trying to run PTFE, with information about
how to figure out what is going wrong.

## Problem: Access to HTTPS - DNS

If you are trying to access the URL you configured for PTFE, check that the
hostname resolves in DNS. If you did not use route53, you had to configure
this separately from `terraform apply`, so it's possible it was not configured.
It should be configured to the `dns_name` value that was output (an ELB address CNAME).

## Problem: Access to HTTPS - Hanging

If connections to the hostname hang and do not return any results, check in
EC2 that the instance is booted and registered with the ELB. If the instance
is up but failing health checks for more than a few minutes, you'll need to
ssh to the instance to continue. Jump to [Accessing via SSH](#ssh).

# Accessing via SSH
Connect as the `tfe-admin` user.

On the instance, there are a few elements you'll want to check exist before
continuing:

## `/etc/atlas/boot.env`

This file written by terraform during the apply
process to S3 and downloaded by the instance using a script that runs at
boot. If this file is absent, that means that the necessary services to run
the system did not start properly. You'll need to look at the output of
`systemctl status cloud-final` and see if it is listed as `active (exited)`.
If so, then there was an error accessing the S3 bucket to download boot.env.

Run `sudo cat /var/lib/cloud/instance/user-data.txt` and check the bucket
listed on the last line. If it's not the bucket you believe it should be,
then PTFE was misconfigured and you'll need to rebuild the cluster.

If it is the right bucket, then run that command again and look at the
output like this: `sudo bash /var/lib/cloud/instance/user-data.txt`. If the
output mentions permission or access errors, then the IAM role that the
instance is using was not configured properly and does not have access to
the bucket and/or object. Please review the IAM rules that you used in the
terraform configuration.

## UI

You can verify that the UI is running by executing:
`curl -s localhost:80/admin/bootstrap/status.json`. If you get JSON output
that says `"All Systems Operational"`, then the UI is up and running. If
you still can't connect to the hostname for the cluster, then you now know
that the issue is either between the instance and the ELB or between your
browser and the ELB.

If `curl` can not get output, then the UI job was unable to run. You need to
query the job and find out if it was able to run even: `nomad status atlas`.
If that reports that there was no job found, then the system was unable to
bootstrap at all, and you likely did not have boot.env present when the system
booted. We suggest you rebuild the machine and make sure boot.env is present
at the booting of the instance.

If the output reports that the status of the allocations is not `running`,
then the system has suffered some unrecoverable damage and needs to be
rebuilt.

If the output from curl doesn't report that everything is ok, for instance it
says that there was any kind of error, then it's possible that the database
migrations did not run properly. See the `Rails Console` section for that.

## Rails Console

There are generally 2 activities associated with using the rails console.

### Running Migrations

To run migrations, exec: `sudo docker exec -ti -u app $(sudo docker ps -q -f name=atlas-frontend) bash -ic 'cd /home/app/atlas && rake db:migrate'`

You can also simply list all the migrations without running them, and see if
any are pending: `sudo docker exec -ti -u app $(sudo docker ps -q -f name=atlas-frontend) bash -ic 'cd /home/app/atlas && bin/rake db:migrate:status'`

### Ruby Console

To access the ruby console to be able to type in code, exec: `sudo docker exec -ti -u app $(sudo docker ps -q -f name=atlas-frontend) bash -ic 'cd /home/app/atlas && bin/rails c`
