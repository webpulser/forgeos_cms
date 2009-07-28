class Comment < ActiveRecord::Base
  belongs_to :new
  belongs_to :person
end