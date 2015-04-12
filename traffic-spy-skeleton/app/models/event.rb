require 'time'

module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :payloads
  
    def self.events_by_frequency(id)
      event_ids = Payload.where(source_id: id).pluck(:event_id)
      event_names = event_ids.map {|id| Event.where(id: id).pluck(:name)}
      event_hash = event_names.group_by {|x| x}
      event_hash.sort_by {|k, v| -v.size}.flatten.uniq
    end

    def self.event_total(event_name)
      event_id = Event.where(name: event_name)
      payloads = Payload.where(event_id: event_id)
      payloads.count
    end

    def self.event_by_hour(event_name)
      event_id = Event.where(name: event_name).pluck(:id)
      requested_ats = Payload.where(event_id: event_id).pluck(:requested_at)
      hours = requested_ats.map {|res| res.hour}
      hours = hours.map {|h| h - 1 }
      hours_grouped = hours.group_by{|h| h }
      frequency = hours_grouped.values.map {|x| x.size}
      hour_breakdown = hours_grouped.keys
      hour_breakdown.zip(frequency)    
    end
  
  end
end