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
      url_id = Url.where(address: url).pluck(:id)
      response_times = Payload.where(url_id: url_id).pluck(:responded_in)
      response_times.max_by{|x| x}
    end

    def self.shortest_response_time(url)
      url_id = Url.where(address: url).pluck(:id)
      response_times = Payload.where(url_id: url_id).pluck(:responded_in)
      response_times.min_by{|x| x}
    end

    def self.average_response_time(url)
      url_id = Url.where(address: url).pluck(:id)
      response_times = Payload.where(url_id: url_id).pluck(:responded_in)
      response_times.inject(0.0){|x, el| x + el}/response_times.size
    end

    def self.http_verbs(url)
      url_id = Url.where(address: url).pluck(:id)
      Payload.where(url_id: url_id).pluck(:request_type).uniq
    end

    def self.most_referred(url)
      url_id = Url.where(address: url).pluck(:id)
      referral_ids = Payload.where(url_id: url_id).pluck(:referral_id)
      referrals = referral_ids.map {|id| Referral.where(id: id)}
      referred_bys = referrals.map {|ref| ref.pluck(:referred_by)}
      referred_bys.max_by{|x| x}.pop
    end

    def self.most_popular_user_agent(url)
      url_id = Url.where(address: url).pluck(:id)
      ua_id = Payload.where(url_id: url_id).pluck(:user_agent_id)
      uas = ua_id.map {|id| UserAgent.where(id: id)}
      user_agents = uas.map {|ua| ua.pluck(:information)}
      user_agents.max_by{|x| x}.pop
    end
  end
end