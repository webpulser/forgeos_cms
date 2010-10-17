namespace :forgeos do
  task :generate_acl, :roles => [:web, :app] do
    run "export RAILS_ENV=production;
    cd #{current_path};
    rake forgeos:core:generate:acl[.];
    rake forgeos:core:generate:acl[vendor/plugins/forgeos_core];
    rake forgeos:core:generate:acl[vendor/plugins/forgeos_cms];"
  end

  task :assets, :roles => [:web, :app] do
    run "mkdir #{release_path}/tmp/attachment_fu"
    run "cd #{release_path}; rake forgeos:cms:sync RAILS_ENV=production;"
  end
end
