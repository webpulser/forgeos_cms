class Faq < ActiveRecord::Base
  translates :question, :answer
  belongs_to :widget_faq
end