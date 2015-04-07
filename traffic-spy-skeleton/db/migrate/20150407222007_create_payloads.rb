class CreatePayloads < ActiveRecord::Migration
  def change
     create_table :payloads do |t|
      t.datetime   :requested_at
      t.string     :request_type
      t.integer    :responded_in
    end
  end
end
