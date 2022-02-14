get '/redmine_patches/users', to: 'patches#users'
post '/redmine_patches/users/tokens/invalidate', to: 'patches#invalidate_user_tokens'
post '/redmine_patches/users/tokens/invalidate_old', to: 'patches#invalidate_older_tokens'