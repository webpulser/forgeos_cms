class Newsletter < ActiveRecord::Base
  validates :email,
    :format => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i,
    :presence => true
end
