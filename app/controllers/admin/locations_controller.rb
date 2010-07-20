class Admin::LocationsController < ApplicationController
  
  layout "admin"  
  include AuthenticatedSystem
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create ],
         :redirect_to => { :action => :index }
  verify :method => :delete, :only => :destroy,
         :redirect_to => { :action => :index }


  def sort
     params[:locations].each_with_index do |id,idx|
       Location.update(id, :position => idx)
     end
     respond_to do |wants|
       wants.html {render :text => "re-ordered the locations"}
       wants.js
    end
  end


  def list
    @locations = Location.find(:all,:include => :active_transfers)
  end

  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'location was successfully updated.'
        format.html { redirect_to([:admin, @location]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
#  def update
#    @location = Location.find(params[:id])
#    if @location.update_attributes(params[:location])
#      flash[:notice] = 'Location was successfully updated.'
#      redirect_to :action => 'show', :id => @location
#    else
#      render :action => 'edit'
#    end
#  end

  def destroy
    Location.find(params[:id]).destroy
    flash[:notice] = "Okay, I killed that pesky location."
    
    redirect_to :action => 'index'
  end
end