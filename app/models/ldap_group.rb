class LdapGroup < ActiveLdap::Base
  ldap_mapping :dn_attribute => "gidNumber",
               :prefix => "cn=Groups"

  has_many :members, :class => "Ldapuser",
           :primary_key => "uid", # User#gidNumber
           :foreign_key => "memberUid"  # Group#gidNumber
  #has_many :members, :class => "Ldapuser",
           #:wrap => "memberUid" # Group#memberUid
           
           
  def name
    self['apple-group-realname']
  end
end
