require 'useragent'

module TrafficSpy
  class Source < ActiveRecord::Base
    has_many :payloads
    validates :identifier, uniqueness: :true, presence: true
    validates :root_url, presence: true

    attr_reader :url_addresses, :browsers, :screen_resolutions
   
    def self.url_index(id)
      payloads = find_by_source_id(id)
      url_ids = payloads.map {|payload| payload.url_id}
      @url_addresses = url_ids.map {|id| Url.where(id: id)}
    end

    def self.all_url_addresses
      @url_addresses.map {|obj| obj.pluck(:address)}
    end

    def self.resolutions_index(id)
      sres = find_by_source_id(id).pluck(:resolution_id)
      sres_objs = sres.map {|id| Resolution.where(id: id)}
      screen_heights = sres_objs.flat_map {|sres| sres.pluck(:resolution_height)}
      screen_widths = sres_objs.flat_map {|sres| sres.pluck(:resolution_width)}
      @screen_resolutions = screen_widths.zip(screen_heights)
    end

    def self.browser_index(id)
      ua = find_by_source_id(id).pluck(:user_agent_id)
      user_agents = ua.map {|id| UserAgent.where(id: id)}
      @browsers = user_agents.flat_map {|ua| ua.pluck(:information)}
    end

    def self.platforms_from_index
      @browsers.map {|ua| ::UserAgent.parse(ua).platform}
    end

    def self.browsers_from_index
      @browsers.map {|ua| ::UserAgent.parse(ua).browser}
    end

    def self.most_requested_to_least_requested
      remove_counts_from_address_array
    end

    def self.url_response_time
      url_ids = @url_addresses.map {|url| url.pluck(:id)}.flatten.uniq
      responded_ins = url_ids.map {|id| Payload.where(url_id: id).pluck(:responded_in)}
    end

    def self.average_responses_per_url
      url_response_time.map {|rt| rt.inject(0.0) { |sum, el| sum + el } / rt.size}
    end

    private 

    def self.find_by_source_id(id)
      Payload.where(source_id: id)
    end

    def self.group_by_frequency
      all_url_addresses.group_by{|x| x}
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