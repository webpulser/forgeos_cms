class Picture < Attachment
  has_attachment  :content_type => :image,
                  :file_system_path => 'public/images/pictures',
                  :storage => :file_system,
                  :max_size => 1.megabytes,
                  :processor => 'Rmagick',
                  :thumbnails => { :thumb => '100x100' }
  validates_as_attachment
end
