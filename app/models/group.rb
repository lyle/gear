class Group < ActiveRecord::Base
  acts_as_list
  has_and_belongs_to_many :people, :uniq=>true
  
  
  def to_s
    name
  end
end
