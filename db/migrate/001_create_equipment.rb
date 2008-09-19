class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
      t.column :name,                 :string
      t.column :description,          :text
      t.column :inventory_identifier, :int
      t.column :manufacturer,         :string
      t.column :model,                :string
      t.column :serial_number,        :string
      t.column :status,               :string
      t.column :notes,                :text
      t.column :parent_id,            :int
      t.column :children_count,       :int
      t.column :created_by,           :int
      t.column :created_at,           :datetime
      t.column :updated_at,           :datetime
    end
  end

  def self.down
    drop_table :equipment
  end
end
