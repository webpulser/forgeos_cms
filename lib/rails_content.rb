module RailsContent
  # Set available widgets
  Widgets = {
    Carousel => { :id => 'carousel', :model => Carousel, :controller => 'admin/widget_carousels' },
    Wnew => { :id => 'wnew', :model => Wnew, :controller => 'admin/widget_wnews' }
  }
end

# Set administration's menu
Forgeos::AdminMenu << { :title => 'pages',
  :url => { :controller => 'admin/pages' }, :i18n => true,
  :html => { :class => 'left last'}
}

# Set attachable media types
Forgeos::AttachableTypes << 'CarouselItem'
