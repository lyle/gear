class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  layout "simple"
  
  # say something nice, you goof!  something sweet.
  def index
    #redirect_to(:action => 'signup') unless logged_in? || Person.count > 0
    @people = Person.find(:all)
    @users = Ldapuser.find(:all)
    @groups = LdapGroup.find(:all)
    #@group = LdapGroup.find("1046")
  end
  
  def login
    return unless request.post?
    login = params[:login]
    password = params[:password]
    
    #this is for over-riding the ldap stuff, in case it is not working
    # just uncomment this next two lines
  #@person = Person.find(:first, :conditions => [ "login = ?", login])
  #self.current_person = @person
    #and toggle the comments on the next two lines
  if 1==2
    
    if Ldapuser.login(login,password)
      #login successful 
      flash[:notice] = "Logged in successfully"
      # get a valid person and save it to the current_person
      
      # find out if the person exists
      @person = Person.find(:first, :conditions => [ "login = ?", login])
      if not @person
        # the login / username does not exist in the people table - let's make it
        # Create a person from an LDAP server user and return that newly created person
        luser = Ldapuser.find(login)
        
        @person = Person.new(:login => login) 
        if (luser.mail.nil?)
          @person.email = "#{login}, please Enter your Email"
        else
          @person.email = luser.mail 
        end
        @person.name = luser.cn
        @person.save!
        if @person.id == 1
          @person.administrator = true
          @person.save!
        end
        
      end
      self.current_person = @person
      
      
      
    else
      flash[:notice] = "Your login credentails did not seem to match"
    end
    
  else
    @person = Person.new(:login => login) 
    self.current_person = @person
    cookies[:auth_token] = { :value => self.current_person.remember_token , :expires => self.current_person.remember_token_expires_at }
    
  end
    
    if logged_in?
      if params[:remember_me] == "1"
        self.current_person.remember_me
        cookies[:auth_token] = { :value => self.current_person.remember_token , :expires => self.current_person.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
      redirect_to(:controller => 'overview', :action => 'index')
    end
  end
  
  def login_disabled 
    return unless request.post?
    self.current_person = Person.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_person.remember_me
        cookies[:auth_token] = { :value => self.current_person.remember_token , :expires => self.current_person.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @person = Person.new(params[:person])
    return unless request.post?
    @person.save!
    self.current_person = @person
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_person.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/overview', :action => 'index')
  end
end
