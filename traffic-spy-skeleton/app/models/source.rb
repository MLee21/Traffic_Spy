module TrafficSpy
  class Source < ActiveRecord::Base
    has_many :payloads
    validates :identifier, uniqueness: :true, presence: true
    validates :root_url, presence: true

    attr_reader :url_addresses
   
    def self.url_index(id)
      related_payloads = Payload.where(source_id: id)
      ids = related_payloads.pluck(:url_id)
      url_objects = ids.map do |id|
        Url.where(id: id)
      end
      index = url_objects.map do |obj|
        obj.pluck(:address)
      end
      @url_addresses = index
    end

    def self.most_requested_to_least_requested
      remove_counts_from_address_array
    end

    private 

    def self.group_by_frequency
      @url_addresses.group_by{|x| x}
    end

    def self.count_frequency_of_each_address
      group_by_frequency.map {|k,v| [k,v.size]}
    end

    def self.sort_addresses_from_most_to_least
      count_frequency_of_each_address.sort_by(&:last).reverse
    end

    def self.remove_counts_from_address_array
      r = sort_addresses_from_most_to_least.flatten
      r.values_at(* r.each_index.select(&:even?))
    end
  end
end