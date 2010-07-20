class AddPositionToLocations < ActiveRecord::Migration
  def self.up
    add_column  :locations, :position, :integer
  end

  def self.down
    remove_column :locations, :position
  end
end
