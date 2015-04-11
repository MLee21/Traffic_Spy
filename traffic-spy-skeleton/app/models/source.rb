module TrafficSpy
  class Source < ActiveRecord::Base
    has_many :payloads
    validates :identifier, uniqueness: :true, presence: true
    validates :root_url, presence: true

    #based off the identifier, grab all payloads associated
    # ** grab all data from each category **
    #grab all the urls
    #order by most to least
    def self.url_index(id)
      related_payloads = Payload.where(source_id: id)
      ids = related_payloads.pluck(:url_id)
      url_objects = ids.map do |id|
        Url.where(id: id)
      end
      index = url_objects.map do |obj|
        obj.pluck(:address).first
      end
    end

  end
end