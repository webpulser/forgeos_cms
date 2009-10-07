# Set administration's menu
Forgeos::AdminMenu << { :title => 'pages',
  :url => { :controller => 'admin/pages' }, :i18n => true,
  :html => { :class => 'left last'}
}

# Set attachable media types
Forgeos::AttachableTypes << 'CarouselItem'
