module Patch

  # module AttachmentsControllerPatch extend ActiveSupport::Concern

  #   included do
  #     before_action :check_issue_closed, :only => :destroy
  #   end

  #   def check_issue_closed
  #     @attachment.deletable? ? true : deny_access
  #   end
  # end

  module AttachmentPatch extend ActiveSupport::Concern

    def prepended(base)
      base.extend ClassMethods
    end

    def deletable?(user=User.current)
      if container_id
        if container_type == "Issue"
          s = Setting::[]('plugin_redmine_patches')
          return super unless RedminePatches::Utils::bool(s["attachment_destroy_issue_closed"])
          return super if RedminePatches::Utils::bool(s["attachment_destroy_allow_admin"]) and user.admin?
          return !container.closed?
        else
          return super
        end
      end
    end

  end

end

# AttachmentsController.send :include, Patch::AttachmentsControllerPatch 
Attachment.send :prepend, Patch::AttachmentPatch