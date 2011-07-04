class ExternalLink < MenuLink
  validates :url,
    :if => Proc.new { |menu_link| menu_link.class.name == 'ExternalLink' },
    :presence => true
end
