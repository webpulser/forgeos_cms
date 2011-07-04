class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true

  belongs_to :actuality, :person
  belongs_to :author, :foreign_key => 'person_id', :class_name => 'Person'
end
