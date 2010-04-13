class PageLink < MenuLink
  def url
    #TODO update syntax with target method
    page = Page.find_by_id(self.target_id)
    if page
     "/#{page.url}"
    else
      "#"
    end
 end

  def page_and_children_pages
    pages = [self.target]
    self.children.all(:conditions => {:type => 'PageLink'}).each do |child|
      pages += child.page_and_children_pages
    end
    return pages
  end
end
