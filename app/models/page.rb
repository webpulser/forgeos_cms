class Page < ActiveRecord::Base

  validates_presence_of     :title
  validates_presence_of     :content
  validates_presence_of     :url

  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}
  validates_uniqueness_of   :title
  validates_uniqueness_of   :url, :scope => [:section_id]

  belongs_to                :section
  has_and_belongs_to_many   :blocks, :order => 'position', :list => true

  before_destroy            :check_has_no_single_key

private

  # if the page contains a single_key, it can not be destroyed
  def check_has_no_single_key
    if !self.single_key.blank?
      errors.add_to_base("The page is protected")
      return false 
    end
  end
end
