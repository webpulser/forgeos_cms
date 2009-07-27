class Admin < Person
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :rights

  attr_accessible :role_ids, :right_ids
  before_create :activate
end 
