module RailsContent
  # Set available widgets
  Widgets = {
    Carousel => { :id => 'carousel', :model => Carousel, :controller => 'admin/carousels' },
    WidgetActuality => { :id => 'widget_actuality', :model => WidgetActuality, :controller => 'admin/widget_actualities' }
  }
end

# Set administration's menu
Forgeos::AdminMenu << { :title => 'pages',
  :url => { :controller => 'admin/pages' }, :i18n => true,
  :html => { :class => 'left last'}
}

# Set attachable media types
Forgeos::AttachableTypes << 'CarouselItem'
