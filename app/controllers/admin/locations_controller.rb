class Admin::LocationsController < ApplicationController
  
  layout "admin"  
  include AuthenticatedSystem
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ],
         :redirect_to => { :action => :index }
  verify :method => :delete, :only => :destroy,
         :redirect_to => { :action => :index }

  def list
    
    @locations = Location.paginate :page => params[:page]
    #, :order => 'created_at DESC'
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
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to :action => 'show', :id => @location
    else
      render :action => 'edit'
    end
  end

  def destroy
    Location.find(params[:id]).destroy
    flash[:notice] = "Okay, I killed that pesky location."
    
    redirect_to :action => 'index'
  end
end