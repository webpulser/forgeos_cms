# Set administration's menu
Forgeos::AdminMenu << { :title => 'sections', :url => { :controller => 'admin/sections' }, :i18n => true }
Forgeos::AdminMenu << { :title => 'news', :url => { :controller => 'admin/news' }, :i18n => true }
Forgeos::AdminMenu << { :title => 'pages', :url => { :controller => 'admin/pages' }, :i18n => true,
  :children => [
    { :title => 'blocks', :url => { :controller => 'admin/blocks' }, :i18n => true }
  ]
}
Forgeos::AdminMenu << { :title => 'widgets', :url => { :controller => 'admin/widgets' }, :i18n => true,
  :children => [
    { :title => 'carousels', :url => { :controller => 'admin/widget_carousels' }, :i18n => true },
    { :title => 'wnews', :url => { :controller => 'admin/widget_wnews' }, :i18n => true }
  ]
}

# Set attachable media types
Forgeos::AttachableTypes << 'CarouselItem'