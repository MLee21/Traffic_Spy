module TrafficSpy
  class Source < ActiveRecord::Base
    has_many :payloads
    validates :identifier, uniqueness: :true, presence: true
    validates :root_url, presence: true
    #based off the identifier, grab all payloads associated
    # ** grab all data from each category **
    #grab all the urls
    #order by most to least
  end
end