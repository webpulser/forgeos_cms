class PageCol < ActiveRecord::Base
  translates :content
  has_and_belongs_to_many :blocks, :list => true, :order => 'position'
  belongs_to :page
end
