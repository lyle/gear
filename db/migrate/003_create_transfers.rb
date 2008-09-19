class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.column :equipment_id, :integer
      t.column :reservation_id, :integer
      t.column :transfer_from_id, :integer
      t.column :transfer_from_type, :string
      t.column :transfer_to_id, :integer
      t.column :transfer_to_type, :string
      t.column :created_by, :integer
      t.column :confirmed, :boolean
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :date, :datetime
      t.column :active, :boolean, :default => true
    end
  end

  def self.down
    drop_table :transfers
  end
end
