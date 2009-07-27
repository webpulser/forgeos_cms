class New < ActiveRecord::Base
  belongs_to :admin
  
  validates_presence_of :title
  validates_presence_of :content
end
