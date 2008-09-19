class CreateGroupsAndGroupsPeople < ActiveRecord::Migration
  def self.up
    create_table :groups_people, :id => false do |t|
      t.column :person_id, :integer
      t.column :group_id, :integer
      
      t.timestamps
    end
    
    create_table :groups do |t|
      t.column :name, :string
      t.column :position, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
    drop_table :groups_people
  end
end
