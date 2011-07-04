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
    [self.target] +
      self.children.all(:conditions => {:type => 'PageLink'}).
      map(&:page_and_children_pages)
  end
end
