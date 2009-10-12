# Set administration's menu
Forgeos::AdminMenu << { :title => 'pages',
  :url => [ 
    { :controller => 'admin/pages' },
    { :controller => 'admin/static_content_blocks' },
    { :controller => 'admin/widgets' }
  ],
  :i18n => true,
  :html => { :class => 'left last'}
}
