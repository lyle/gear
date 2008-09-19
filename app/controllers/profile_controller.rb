class ProfileController < ApplicationController
  include AuthenticatedSystem

  before_filter :login_required
  #def authorize?
    #current_person.administrator?
  #end
  layout "application"  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @people = Person.paginate :page => params[:page], :order => 'login DESC'
    
  end

  def show
    @person = Person.find(params[:id])
  end



  def edit
    @person = Person.find(params[:id])
    if not (current_person.administrator? or current_person==@person)
      redirect_to :action=>'list'
    end
    
  end

  def update
    @person = Person.find(params[:id])
    if current_person == @person and @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      flash[:notice] = 'Person was not updated.'
      render :action => 'show'
    end
  end


  def live_search
      @phrase = params[:searchtext]
      request.raw_post || request.query_string
      a1 = "%"
      a2 = "%"
      @searchphrase = a1  + @phrase + a2
      @results = Person.find(:all, :conditions => [ "login LIKE ? OR name LIKE ?", @searchphrase, @searchphrase])
      @number_match = @results.length
      render(:layout => false)
  end





end
