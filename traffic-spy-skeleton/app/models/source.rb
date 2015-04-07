class Source < ActiveRecord::Base
  validates :identifier, presence: true
  validates :rootURL, presence: true
end