class Widget < ActiveRecord::Base
  
  belongs_to :widgetable, :polymorphic => true

  has_and_belongs_to_many   :pages, :order => 'position', :list => true

end
