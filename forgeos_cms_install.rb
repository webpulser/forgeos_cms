git :init
plugin 'attachment_fu', :git => 'git://github.com/technoweenie/attachment_fu.git'
plugin 'open_flash_chart', :git => 'git://github.com/pullmonkey/open_flash_chart.git'

route "mount Forgeos::Cms::Engine => '/', :as => 'forgeos_cms'"
route "mount Forgeos::Core::Engine => '/', :as => 'forgeos_core'"

rake 'db:create'
rake 'forgeos:cms:install'

run 'rm -rf config/locales/* public/*.html'
