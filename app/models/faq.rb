class Faq < ActiveRecord::Base
  translates :question, :answer
  belongs_to :widget_faq

  def clone
    cloned = super
    cloned.translations = translations.clone unless translations.empty?
    return cloned
  end
end
