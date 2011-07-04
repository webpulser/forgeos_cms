class Actuality < ActiveRecord::Base
  translates :title, :content, :short_description
  belongs_to :administrator
  belongs_to :widget_actuality
  belongs_to :picture
  has_many :comments
  validates :title, :content,
    :presence => true

  acts_as_commentable

  def clone
    cloned = super
    cloned.translations = translations.clone unless translations.empty?
    return cloned
  end

  def activate
    self.update_attribute('active', !self.active )
  end
end
