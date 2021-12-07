module Patch

  module TimeEntryPatch extend ActiveSupport::Concern

    included do
      validate :validate_time_entry_conditions
    end

    def validate_time_entry_conditions
      user = User.current
      s = Setting['plugin_redmine_patches']

      if issue.closed?
        # not_in_allowed_roles = user.roles.collect{|role| role.id.to_s}.intersection(Array.wrap(s['time_entry_when_issue_closed_roles'])).size == 0

        # if RedminePatches::Utils::bool(s['time_entry_when_issue_closed']) 
          # if (issue.closed_on + s['time_entry_when_issue_closed_until'].to_i.hours) < DateTime.now && !user.admin? && not_in_allowed_roles
          #   errors.add(
          #     :base,
          #     I18n.t(:error_time_entry_issue_closed_deadline, :limit=>s['time_entry_when_issue_closed_until']))
          # end
        # else
        #   errors.add(
        #     :base,
        #     I18n.t(:error_time_entry_issue_closed))
        # end
        if !RedminePatches::Utils::editable?(issue) && !RedminePatches::Utils::has_allowed_roles?

          if RedminePatches::Utils::bool(s['time_entry_when_issue_closed']) 
          errors.add(
            :base,
            I18n.t(:error_time_entry_issue_closed))
          else
            errors.add(
              :base,
              I18n.t(:error_time_entry_issue_closed_deadline, :limit=>s['time_entry_when_issue_closed_until']))
          end
        end
        
      end
    end # method
  end
end

TimeEntry.send :include, Patch::TimeEntryPatch 