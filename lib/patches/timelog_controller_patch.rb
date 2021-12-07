module Patch

  module TimelogControllerPatch extend ActiveSupport::Concern

    included do
      before_action :authorize_destroy, :only => [:destroy]
    end

    def authorize_destroy
      user = User.current
      s = Setting['plugin_redmine_patches']

      @time_entries.each_with_index{|te, i|
        if te.issue.closed?
          if !RedminePatches::Utils::editable?(te.issue) && !RedminePatches::Utils::has_allowed_roles?

            respond_to do |format|
              format.html do
                flash[:error] = l(:error_time_entry_issue_closed_destroy, :limit=>s['time_entry_when_issue_closed_until'])
                redirect_back_or_default project_time_entries_path(@projects.first), :referer => true
              end
              format.api do
                @time_entries[i].errors.add(
                  :base,
                  I18n.t(:error_time_entry_issue_closed_destroy, :limit=>s['time_entry_when_issue_closed_until']))
                render_validation_errors(@time_entries)
              end
            end

          end
        end
      }
    end # method

  end
end

TimelogController.send :include, Patch::TimelogControllerPatch 