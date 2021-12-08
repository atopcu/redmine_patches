module Patch

  module TimeEntryPatch extend ActiveSupport::Concern

    included do
      validate :validate_time_entry_conditions
    end

    def validate_time_entry_conditions
      user = User.current
      s = Setting['plugin_redmine_patches']

      if issue.closed?
        if RedminePatches::Utils::bool(s['time_entry_when_issue_closed']) 
          if !RedminePatches::Utils::editable?(issue)
            if RedminePatches::Utils::before_deadline?(issue)
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
      end
      
    end # method
  end
end

TimeEntry.send :include, Patch::TimeEntryPatch 