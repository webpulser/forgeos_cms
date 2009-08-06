class Widget < ActiveRecord::Base
  belongs_to :widgetable, :polymorphic => true
  has_and_belongs_to_many   :pages, :order => 'position', :list => true

  def linked_with?(page)
    self.pages.include?(page)
  end

  def link_with(page)
    page.widgets << self
    page.widgets.reset_positions
  end

  def unlink_with(page)
    page.widgets.delete self
    page.widgets.reset_positions
  end
end
