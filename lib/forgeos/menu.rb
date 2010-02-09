# Set administration's menu
module Forgeos
  AdminMenu << { 
    :title => 'back_office.menu.pages',
    :url => [ 
      { :controller => 'admin/pages' },
      { :controller => 'admin/static_content_blocks' },
      { :controller => 'admin/widgets' },
      { :controller => 'admin/carousels' },
      { :controller => 'admin/widget_actualities' },
      { :controller => 'admin/menus' }
    ],
    :i18n => true,
    :html => { :class => 'left last'}
  }
end
