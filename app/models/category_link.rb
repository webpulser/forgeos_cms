class CategoryLink < MenuLink

  def url
    category = Category.find(self.target_id)
    "/catalog/#{category.name}"
  end
end
