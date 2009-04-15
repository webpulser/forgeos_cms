class Role < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :rights
  translates :name
end
