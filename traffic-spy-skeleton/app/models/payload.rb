module TrafficSpy
  class Payload < ActiveRecord::Base
    belongs_to :source
    belongs_to :url
    belongs_to :event
    belongs_to :resolution
    belongs_to :referral
    belongs_to :user_agent
    belongs_to :ip
    validates_presence_of :requested_at, :request_type,
    :responded_in, :source_id, :url_id, :event_id, :resolution_id, :referral_id, :user_agent_id, :ip_id
    validates_uniqueness_of :sha
  end
end