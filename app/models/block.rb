class Block < ActiveRecord::Base

  validates_presence_of     :title
  validates_presence_of     :content

  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}
  validates_uniqueness_of   :title

  has_and_belongs_to_many   :pages, :order => 'position', :list => true

  before_destroy            :check_has_no_single_key

private

  # if the block contains a single_key, it can not be destroyed
  def check_has_no_single_key
    if !self.single_key.blank?
      errors.add_to_base("The block is protected")
      return false 
    end
  end
end
