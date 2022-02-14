class PatchesController < ApplicationController

	helper :sort
  include SortHelper

	def users
		raise Unauthorized unless User.current.admin?
		@users = User.where("status != ?", User::STATUS_ANONYMOUS).order(:login)

		sort_init 'updated_on', 'desc'
    sort_update %w(id user_id action created_on updated_on)		
		@from = params[:from_date].to_i
		@tokens = get_older_tokens(@from) if @from > 0
	end

	def invalidate_user_tokens
		raise Unauthorized unless User.current.admin?

		users = User.find(params[:users].map(&:to_i)) rescue []
		unless users.blank?
			invalidate_list(users)
		  flash[:notice] = l(:notice_successful_update) + " (#{users.size}) " + l(:label_user_plural)
		end
	  redirect_to redmine_patches_users_path
	end

	def invalidate_older_tokens
		raise Unauthorized unless User.current.admin?

		from = params[:from_date].to_i
		users = User.find( get_older_tokens(from).pluck(:user_id) )

		unless users.blank?
			invalidate_list(users)
		  flash[:notice] = l(:notice_successful_update) + " (#{users.size}) " + l(:label_user_plural)
		end

		redirect_to redmine_patches_users_path
	end

	private
	def invalidate_list(users)
		unless users.blank?
			users.each{|u|  
		    u.api_token.destroy unless u.api_token.nil?
		    u.rss_token.destroy unless u.rss_token.nil?
		    # TODO: do something aboout 2fa tokens? or maybe in a separate method
		    Token.where(:user_id => u.id, :action => 'session').delete_all
		  }
		end
	end

	def get_older_tokens(from)
		Token.where('updated_on <= ?', (DateTime.now() - from.days))
	end

end