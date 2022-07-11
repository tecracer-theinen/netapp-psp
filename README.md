# README

```
mkdir /workspaces/netapp-psp-chef18/cookbooks
ln -s /workspaces/netapp-psp-chef18 /workspaces/netapp-psp-chef18/cookbooks

chef-client -z -r "recipe[netapp-psp-chef18]" -t ontap910
```
