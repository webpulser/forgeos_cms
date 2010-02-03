class PageLink < MenuLink
  def url
    page = Page.find(self.target_id)
    "/#{page.url}"
  end

  def page_and_children_pages
    pages = [self.target]
    self.children.all(:conditions => {:type => 'PageLink'}).each do |child|
      pages += child.page_and_children_pages
    end
    return pages
  end
end
