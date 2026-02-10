# Terraform Snippet

## This Repo

I recently deployed a project to AWS, this is a touched up snippet of the terraform code.

The snippet is not a one to one:

- Sections have been purposefully excluded
- Files have been broken up, where it seemed to make sense

## Notes

1. Some comments have been added, mostly for myself, but hopefully they're helpful.
2. Many resources were created manually and then used as `data`. For example the dafault vpc and subnets are being used, and, all acm certificates were created manually.
3. This might not run as is. I moved around a bunch of code, renamed things, and I'm not going to validate everything still works because I'm broke.
