class Role < ActiveRecord::Base
  validates_presence_of :name

  has_and_belongs_to_many :admins
  has_and_belongs_to_many :rights
#  translates :name
end
