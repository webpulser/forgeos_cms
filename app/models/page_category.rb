class PageCategory < Category
  has_and_belongs_to_many :elements, :join_table => 'categories_elements', :foreign_key => 'category_id', :association_foreign_key => 'element_id', :class_name => 'Page'
  has_and_belongs_to_many :pages, :join_table => 'categories_elements', :foreign_key => 'category_id', :association_foreign_key => 'element_id'
end
