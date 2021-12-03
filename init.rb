require 'redmine'


Redmine::Plugin.register :redmine_patches do
  name 'Patches for Redmine'
  description 'Patches for Redmine'
  version '1.0.0'
  author_url 'https://github.com/marcelbonnet/'
  url 'https://github.com/marcelbonnet/redmine_patches'
  author 'Marcel Bonnet'

  requires_redmine :version_or_higher => '3.0.0'

  settings partial: 'settings/redmine_patches_settings.html', default: {
     "attachment_destroy_issue_closed" => true,
     "attachment_destroy_allow_admin" => false
  }
  
end

require_dependency "patches/attachment_patch"
require_dependency "utils"