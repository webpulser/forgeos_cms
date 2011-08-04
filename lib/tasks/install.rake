namespace :forgeos do
  namespace :cms do
    desc "load fixtures and generate forgeos_cms controllers ACLs"
    task :install => ['forgeos:core:install'] do
      Rake::Task['forgeos:core:fixtures:load'].invoke('forgeos_cms','pages page_translations people menus menu_links menu_link_translations')
      Rake::Task['forgeos:core:generate:acl'].invoke(Gem.loaded_specs['forgeos_cms'].full_gem_path)
    end
  end
end
