class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table "people", :force => true do |t|
      t.column :login,                     :string
      t.column :ldap_uid,                  :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :administrator,             :boolean
      t.column :name,                      :string
    end
  end

  def self.down
    drop_table "people"
  end
end
