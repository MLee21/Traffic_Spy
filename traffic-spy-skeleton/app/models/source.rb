class Source < ActiveRecord::Base
  has_many :payloads
  validates :identifier, uniqueness: :true, presence: true
  validates :rootURL, presence: true
end