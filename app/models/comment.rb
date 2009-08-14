class Comment < ActiveRecord::Base
  belongs_to :actuality
  belongs_to :person
end