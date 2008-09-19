class Ldapuser < ActiveLdap::Base
  ldap_mapping :dn_attribute => "uid",
               :prefix => "cn=Users"
  belongs_to :groups, :class => 'LdapGroup', :many => 'memberUid', :foreign_key => 'uid'
    
  def name
    self.cn
  end
  
  
  require 'rubygems'
  require 'net/ldap'

  def self.login(username, password)
    ldap = Net::LDAP.new :host => "danm.ucsc.edu",
      :port => 636,
      :encryption => :simple_tls,
      :auth => {:method => :simple,
                :username => "uid=#{username},cn=Users,dc=danm,dc=ucsc,dc=edu",
                :password => password}
  
    #  p (ldap.bind) ? "Authorization Succeeded!" : "Authorization Failed: #{ldap.get_operation_result.message}" 

  
    if ldap.bind
      return true
      #{}"Authorization Succeeded!"
    else
      return false
      #{}"Authorization Failed: #{ldap.get_operation_result.message}"
    end

  end
#  and with no encryption you need:
#  :port => 389,
  
  
  
      #ActiveLdap::Base.connect \
 #     if self.establish_connection \
 #       :bind_format => "uid=#{username},cn=Users,dc=your,dc=ldap,dc=binding,dc=config,dc=com",
 #       :password_block => Proc.new { password },
 #       :allow_anonymous => false

 #     return true
 #   rescue ActiveLdap::AuthenticationError
      
 #     return false
 
  def define_attribute_methods(attr)
    if @attr_methods.has_key? attr
      return
    end
    aliases = Base.schema.attribute_aliases(attr)
    aliases.each do |ali|
      @attr_methods[ali.gsub(/-/,’_’)] = attr
    end
  end
  def make_subtypes(attr, value)
    return [attr.gsub(/-/,’_’), value] unless attr.match(/;/)
    ret_attr, *subtypes = attr.split(/;/)
    return [ret_attr.gsub(/-/,’_’), [make_subtypes_helper(subtypes, value)]]
  end


end
