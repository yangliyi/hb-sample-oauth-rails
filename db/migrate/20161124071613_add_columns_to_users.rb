class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hb_access_token, :string
    add_column :users, :honestbee_raw_info, :text
    add_column :users, :username, :string
  end
end
