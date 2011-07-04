# Set administration's menu
Forgeos::AdminMenu << {
    :title => 'back_office.menu.pages',
    :url => [
      '/admin/pages',
      '/admin/static_content_blocks',
      '/admin/widgets',
      '/admin/carousels',
      '/admin/widget_actualities',
      '/admin/menus'
    ],
    :i18n => true,
    :html => { :class => 'left last'}
  }
