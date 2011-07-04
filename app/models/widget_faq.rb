class WidgetFaq < Widget
  has_many :faqs,
    :dependent => :destroy
  accepts_nested_attributes_for :faqs,
    :allow_destroy => true

  def clone
    cloned = super
    cloned.faqs = faqs.map(&:clone)
    return cloned
  end
end
