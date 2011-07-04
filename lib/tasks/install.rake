namespace :forgeos do
  namespace :cms do
    desc "load fixtures and generate forgeos_cms controllers ACLs"
    task :install => ['forgeos_cms_engine:install:migrations', 'forgeos:core:install'] do
      system 'rake "forgeos:core:fixtures:load[forgeos_cms,pages page_translations people menus menu_links menu_link_translations]"'
      system "rake 'forgeos:core:generate:acl[#{Gem.loaded_specs['forgeos_cms'].full_gem_path}]'"
    end
  end
end
