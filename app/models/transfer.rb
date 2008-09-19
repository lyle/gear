class Transfer < ActiveRecord::Base
  belongs_to :equipment
  
  belongs_to :transfer_to, :polymorphic => true
  belongs_to :transfer_from, :polymorphic => true
  belongs_to :creator, :class_name => 'Person', :foreign_key => "created_by"
  
  validates_presence_of     :transfer_to_id
  
  def after_create() 
    @former_record = Transfer.find(:first, :conditions => [ "equipment_id = ? and id <> ? and active = 1", self.equipment_id, self.id])
    if @former_record
      @former_record.active = false
      @former_record.save()
      self.transfer_from_type = @former_record.transfer_to_type
      self.transfer_from_id = @former_record.transfer_to_id
      self.save
    end
  end
  def in_or_with
    if self.transfer_to_type == 'Person'
      "with #{self.transfer_to.name}"
    else
      "in #{self.transfer_to.name}"
    end
  end
  def transfer_to_person_id
    return transfer_to_id if self.transfer_to_type == 'Person'
  end
  def transfer_to_location_id
    return transfer_to_id if self.transfer_to_type == 'Location'
  end
  def transfer_to_person_id=(val)
    if self.transfer_to_type == 'Person'
      self.transfer_to_id = val
    end
  end
  def transfer_to_location_id=(val)
    if self.transfer_to_type == 'Location'
      self.transfer_to_id = val
    end
  end
end
