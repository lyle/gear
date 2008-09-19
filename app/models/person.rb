require 'digest/sha1'
class Person < ActiveRecord::Base
  #has_one :ldapuser, :foreign_key=> "ldap_uid"
  
  #has_many :custodianships, :class_name => "Custodian", :foreign_key => "person_id", :conditions => "child_id IS NULL"
  #has_many :items, :through => :custodianships, :class_name => "Equipment", :source => :equipment
  
  # notes, we need the following for each user
  # confirmed items that they have - part of items
  # non-confimed items that they might have - part of items
  # items that they did have, and have not been confirmed by someone else
  
  has_many :recived_transfers, :as => :transfer_to, :class_name=> "Transfer"
  has_many :given_transfers, :as => :transfer_from, :class_name=> "Transfer"
  has_many :active_transfers, :as => :transfer_to, :class_name=> "Transfer", :conditions=>"active = true"
  has_many :items, :through=> :active_transfers, :source=> :equipment
  has_and_belongs_to_many :groups, :uniq=>true, :order => "position"
  
  #has_many :active_recived_transfers, :class_name => "Transfers", :foring_key => 'received_from'
  
#  has_many :items, :through => :recived_items

  
  def display_name
    name ? name : login 
  end
  def checked_out_item_count
    items.length
  end
  def master_readable_name
    return "with #{name}"
  end
  # Virtual attribute for the unencrypted password
  attr_accessor :password

 # validates_presence_of     :login, :email
#  validates_presence_of     :password,                   :if => :password_required?
#  validates_presence_of     :password_confirmation,      :if => :password_required?
#  validates_length_of       :password, :within => 4..40, :if => :password_required?
#  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
#  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
#  before_save :encrypt_password




  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
