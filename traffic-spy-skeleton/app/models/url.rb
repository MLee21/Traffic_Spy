module TrafficSpy
  class Url < ActiveRecord::Base
    has_many :payloads
    validates :address, uniqueness: true, presence: true



    def self.assemble_full_url(source, relative, path)
      full_url = "#{source.root_url}/#{relative}"
      if path.nil?
        full_url
      else
        "#{full_url}/#{path}"
      end
    end

    def self.longest_response_time(url)
      url_id = find_the_url_id(url)
      response_times = find_response_times_from_payload(url_id)
      response_times.max_by{|x| x}
    end

    def self.shortest_response_time(url)
      url_id = find_the_url_id(url)
      response_times = find_response_times_from_payload(url_id)
      response_times.min_by{|x| x}
    end

    def self.average_response_time(url)
      url_id = find_the_url_id(url)
      response_times = find_response_times_from_payload(url_id)
      response_times.inject(0.0){|x, el| x + el}/response_times.size
    end

    def self.http_verbs(url)
      url_id = find_the_url_id(url)
      Payload.where(url_id: url_id).pluck(:request_type).uniq
    end

    def self.most_referred(url)
      url_id = find_the_url_id(url)
      referral_ids = Payload.where(url_id: url_id).pluck(:referral_id)
      referrals = referral_ids.map {|id| Referral.where(id: id)}
      referred_bys = referrals.map {|ref| ref.pluck(:referred_by)}
      referred_bys.max_by{|x| x}.pop
    end

    def self.most_popular_user_agent(url)
      url_id = find_the_url_id(url)
      ua_id = Payload.where(url_id: url_id).pluck(:user_agent_id)
      uas = ua_id.map {|id| UserAgent.where(id: id)}
      user_agents = uas.map {|ua| ua.pluck(:information)}
      user_agents.max_by{|x| x}.pop
    end

    def self.statistics(url)
      { longest: longest_response_time(url),
        shortest: shortest_response_time(url),
        average: average_response_time(url),
        verbs: http_verbs(url),
        most_popular_reffers: most_referred(url),
        most_popular_agents: most_popular_user_agent(url)
      }
    end

    def self.requested?(url)
      find_the_url_id(url).pop.is_a? Fixnum
    end

    private

    def self.find_the_url_id(url)
      Url.where(address: url).pluck(:id)
    end

    def self.find_response_times_from_payload(url_id)
       Payload.where(url_id: url_id).pluck(:responded_in)
    end
  end
end
