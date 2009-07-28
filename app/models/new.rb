class New < ActiveRecord::Base
  belongs_to :admin
  
  validates_presence_of :title
  validates_presence_of :content
  
  has_many :comments
  
  acts_as_commentable
end
