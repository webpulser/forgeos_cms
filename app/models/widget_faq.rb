class WidgetFaq < Widget
  has_many :faqs
  accepts_nested_attributes_for :faqs, :allow_destroy => true
end
