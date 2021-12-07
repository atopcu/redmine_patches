require 'redmine'


Redmine::Plugin.register :redmine_patches do
  name 'Patches for Redmine'
  description 'Configurable patches for Redmine'
  version '1.1.0'
  author_url 'https://github.com/marcelbonnet/'
  url 'https://github.com/marcelbonnet/redmine_patches'
  author 'Marcel Bonnet'

  requires_redmine :version_or_higher => '3.0.0'

  settings partial: 'settings/redmine_patches_settings.html', default: {
     "attachment_destroy_issue_closed" => true,
     "attachment_destroy_allow_admin" => false,
     "time_entry_when_issue_closed" => true,
     "time_entry_when_issue_closed_until" => 48,
     "time_entry_when_issue_closed_roles" => nil,
  }
  
end

require_dependency "utils"
require_dependency "patches/attachment_patch"
require_dependency "patches/time_entry_patch"
require_dependency "patches/timelog_controller_patch"