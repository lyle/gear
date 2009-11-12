class AddPeopleNotes < ActiveRecord::Migration
  def self.up
    add_column :people, :notes, :string
  end

  def self.down
    remove_column :people, :notes
  end
end
