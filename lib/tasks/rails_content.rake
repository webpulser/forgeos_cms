namespace :forgeos_cms do
  task :sync => ['forgeos_core:sync'] do
    system 'rsync -rvC vendor/plugins/forgeos_cms/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    system 'rake forgeos_cms:fixtures:load FIXTURES=people,pages'
  end

  task :install => [ 'gems:install', :initialize, :sync]
end
