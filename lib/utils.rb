module RedminePatches
	module Utils

		# convert string to Boolean
		def self.bool(str)
			if Rails::VERSION::MAJOR == 4
				b = ActiveRecord::Type::Boolean.new.type_cast_from_database(str)
				return b.nil?? false : b
			elsif Rails::VERSION::MAJOR >= 5
				b = ActiveModel::Type::Boolean.new.cast(str)
				return b.nil?? false : b
			end
		end

		def self.has_allowed_roles?(issue)
			s = Setting['plugin_redmine_patches']
			roles = User.current.roles_for_project(issue.project).collect{|role| role.id.to_s}
			# roles.collect{|role| role.id.to_s}.intersection(Array.wrap(s['time_entry_when_issue_closed_roles'])).size > 0
			# Array#intersection doesn't exist in Ruby 2.2.2 :
			result = roles - Array.wrap(s['time_entry_when_issue_closed_roles'])
			result.size < roles.size
		end

		def self.editable?(issue)
			s = Setting['plugin_redmine_patches']
			user = User.current
			if bool(s['time_entry_when_issue_closed'])
				return	before_deadline?(issue) || has_allowed_roles?(issue) || user.admin?
			else
				return true
			end
		end

		def self.before_deadline?(issue)
			return (issue.closed_on + Setting['plugin_redmine_patches']['time_entry_when_issue_closed_until'].to_i.abs.hours) >= DateTime.now
		end

	end
end