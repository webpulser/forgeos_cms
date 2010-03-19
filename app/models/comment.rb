class Comment < ActiveRecord::Base
  #include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  belongs_to :actuality
  belongs_to :person
  belongs_to :author, :foreign_key => 'person_id', :class_name => 'Person'
end
