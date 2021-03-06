class ExternalLink < MenuLink
  validates_presence_of :url, :if => Proc.new { |menu_link| menu_link.class.name == 'ExternalLink' }
end
