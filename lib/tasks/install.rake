namespace :forgeos do
  namespace :cms do
    task :sync => ['forgeos:core:sync'] do
      system "rsync -r#{'v' unless Rails.env == 'production'}C #{File.join(Rails.plugins['forgeos_cms'].directory,'public')} ."
    end

    task :initialize => ['forgeos:core:initialize'] do
      system 'rake "forgeos:core:fixtures:load[forgeos_cms,pages page_translations people menus menu_links menu_link_translations]"'
      system "rake 'forgeos:core:generate:acl[#{Rails.plugins['forgeos_cms'].directory}]'"
    end

    task :install => [ 'forgeos:core:install', :initialize, :sync]
  end
end
