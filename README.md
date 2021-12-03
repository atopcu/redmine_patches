Redmine Custom Tables
==================

Redmine utilities as configurable patches.

I'm adding new patches as needed. Checkout the plugin settings to enable/disable a patch.

Attachment Removal from Issues
-------------
* Enable/disable: disallow an attachment removal from a closed issue. Redmine currently allows and attachment from being removed.
* Enable/disabe: admin is allowed to remove an attachment from a closed issue


Compatibility
-------------
* Redmine 3.2.3 or higher

Installation and Setup
----------------------

* Clone or [download](https://github.com/marcelbonnet/redmine_patches/archive/master.zip) this repo into your **redmine_root/plugins/** folder

```
$ git clone https://github.com/marcelbonnet/redmine_patches.git
```
* If you downloaded a tarball / zip from master branch, make sure you rename the extracted folder to `redmine_patches`
* You have to run the plugin rake task to provide the assets (from the Redmine root directory):
```
$ RAILS_ENV=production bundle exec rake redmine:plugins:migrate
```
* Restart redmine

Usage
----------------------
Visit **Administration->Plugins->Patches for Redmine** to enable/disable a patch