namespace :rails_content do
  task :patch do
    #system 'cp vendor/plugins/rails_content/config/initializers/*.rb ./config/initializers/'
  end

  task :sync do
    system 'rsync -rvC vendor/plugins/rails_content/public .'
  end

  task :initialize => [ 'db:migrate' ] do
    system 'rake rails_content:fixtures:load FIXTURES=people,pages'
  end

  task :install => [ 'gems:install', :initialize, 'generate:rights_and_roles', :sync, :patch]
end
