class AddRestOfFields < ActiveRecord::Migration
  
   def change
    create_table :resolutions do |t|
      t.string   :resolution_height
      t.string   :resolution_width
    end

    create_table :referrals do |t|
      t.string   :referred_by
    end

    create_table :user_agents do |t|
      t.string   :information
    end

    create_table :ips do |t|
      t.string   :address
    end

    change_table :payloads do |t|
      t.integer  :resolution_id 
      t.integer  :referral_id
      t.integer  :user_agent_id
      t.integer  :ip_id
    end
  end
end
