namespace :forgeos_cms do
  task :sync => ['forgeos_core:sync'] do
    system 'rsync -rvC vendor/plugins/forgeos_cms/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    system 'rake forgeos_cms:fixtures:load FIXTURES=pages'
    system 'rake forgeos_core:generate:acl vendor/plugins/forgeos_cms'
  end

  task :install => [ 'gems:install', :initialize, :sync]
end
