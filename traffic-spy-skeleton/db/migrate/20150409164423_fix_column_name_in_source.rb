class FixColumnNameInSource < ActiveRecord::Migration
   def change
    change_table :sources do |t|
      t.rename :rootURL, :root_url
    end
  end
end
