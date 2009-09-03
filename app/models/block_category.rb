class BlockCategory < Category
  has_and_belongs_to_many :blocks
  has_and_belongs_to_many :elements, :class_name => 'Block'
end
