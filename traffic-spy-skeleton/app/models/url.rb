module TrafficSpy
  class Url < ActiveRecord::Base
    has_many :payloads
    validates :address, uniqueness: true, presence: true
  end
end