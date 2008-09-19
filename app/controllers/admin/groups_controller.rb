class Admin::GroupsController < ApplicationController
  layout "admin"  
  include AuthenticatedSystem
  before_filter :login_required
  
  
  def import_ldap_group
    @group = Group.find(params[:id])
    @ldap_group = LdapGroup.find(params[:ldap_group_id])
    
    
     @ldap_group.members.each do |user|
    	  login = user.id
        #login ='felicia'
        person = Person.find(:first, :conditions => [ "login = ?", login])
        if not person
            # the login / username does not exist in the people table - let's make it
            # Create a person from an LDAP server user and return that newly created person
            luser = Ldapuser.find(login)

            person = Person.new(:login => login) 
            if (luser.mail.nil?)
              person.email = "#{login}, please Enter your Email"
            else
              person.email = luser.mail 
            end
            person.name = luser.cn
            person.save!
        end
        @group.people<< person
    end
    redirect_to([:admin,@group])
  end
  
  
  def sort
      params[:groups].each_with_index do |id,idx|
        Group.update(id, :position => idx)
      end
    respond_to do |wants|
      wants.html {render :text => "re-ordered the groups"}
      wants.js
   end
  end
  
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.find(:all, :order=>"position")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    @ldap_groups = LdapGroup.find(:all,:sort_by => 'cn' )
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to([:admin, @group]) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to([:admin, @group]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(admin_groups_url) }
      format.xml  { head :ok }
    end
  end
end
