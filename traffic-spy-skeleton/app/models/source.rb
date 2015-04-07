class Source < ActiveRecord::Base
  has_many :payloads
  validates :identifier, presence: true
  validates :rootURL, presence: true
end