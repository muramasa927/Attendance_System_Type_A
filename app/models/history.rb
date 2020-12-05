class History < ApplicationRecord
  belongs_to :attendance, autosave: true

end
