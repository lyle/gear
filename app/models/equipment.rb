class Equipment < ActiveRecord::Base
  
  
  acts_as_taggable
  
  acts_as_fleximage do
    image_directory 'public/images/equipment'
    require_image false
  end
  
  #has_many :former_custodians,
  #  :class_name => "Custodian", :foreign_key => "equipment_id", :conditions => "custodians.child_id IS NOT NULL"
  #has_one :custodian,
  #  :class_name => "Custodian", :foreign_key => "equipment_id", :conditions => "child_id IS NULL"
  has_many :transfers, :order => 'active DESC, id DESC', :dependent => :destroy
  has_one :active_transfer,
    :class_name=> "Transfer", :foreign_key => "equipment_id", :conditions => ["active = ?", true], :include => :transfer_to
  
  #has_one :transfer_to, :through=> :active_transfer

  acts_as_tree :order => "name"

  def make_n_model
    "#{manufacturer}, #{model}"  
  end
  def ident_n_name
    if inventory_identifier.nil?
      "______ #{name}"
    else
      "#{inventory_identifier} #{name}"
    end
  end

  
end
