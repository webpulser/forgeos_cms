namespace :forgeos do
  namespace :cms do
    task :sync => ['forgeos:core:sync'] do
      system "rsync -rvC #{File.join('vendor','plugins','forgeos_cms','public')} ."
    end

    task :initialize => ['forgeos:core:initialize'] do
      system 'rake "forgeos:core:fixtures:load[forgeos_cms,pages people]"'
      system "rake 'forgeos:core:generate:acl[#{File.join('vendor','plugins','forgeos_cms')}]'"
    end

    task :install => [ 'forgeos:core:install', :initialize, :sync]
  end
end
