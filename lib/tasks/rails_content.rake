namespace :rails_content do
  task :sync => ['forgeos_core:sync'] do
    system 'rsync -rvC vendor/plugins/rails_content/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    system 'rake rails_content:fixtures:load FIXTURES=people,pages'
  end

  task :install => [ 'gems:install', :initialize, :sync]
end
