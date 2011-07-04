class PageCol < ActiveRecord::Base
  translates :content
  has_and_belongs_to_many :blocks,
    :list => true,
    :order => 'position'
  belongs_to :page

  def clone
    col = super
    col.translations = translations.clone unless translations.empty?
    col.block_ids = block_ids
    return col
  end
end
