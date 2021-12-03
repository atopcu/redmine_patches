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
	end
end