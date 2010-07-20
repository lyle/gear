class Location < ActiveRecord::Base
  acts_as_list
  
  has_many :recived_transfers, :as => :transfer_to, :class_name=> "Transfer"
  has_many :given_transfers, :as => :transfer_from, :class_name=> "Transfer"
  has_many :active_transfers, :as => :transfer_to, :class_name=> "Transfer", :conditions=>"active = true"
  has_many :items, :through=> :active_transfers, :source=> :equipment
  
  default_scope :order => 'position ASC'
  
  validates_presence_of :name
  def display_name
    name
  end
  def to_s
    name
  end
  def master_readable_name
    return "in #{name}"
  end
end
