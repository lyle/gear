class Admin::TransfersController < ApplicationController

  layout "admin"   
  include AuthenticatedSystem
  before_filter :login_required
  
  def index

    list 
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @transfers = Transfer.paginate :page => params[:page], :order => 'active DESC, id DESC', :per_page => 100
  end

  def show
    @transfer = Transfer.find(params[:id])
  end

  def new
    @transfer = Transfer.new(params[:transfer])
    @groups = Group.find(:all, :order=>"position")
    @locations = Location.find(:all)
    if @transfer.equipment_id
      @item = Equipment.find(@transfer.equipment_id)

      render :partial => "transfer", :locals => {:item => @item, :transfer => @transfer, :groups => @groups, :locations => @locations }
    else
        @equipment = Equipment.find(:all)
        render
    end

    
  end

  def create
    @transfer = Transfer.new(params[:transfer])
    @transfer.created_by = current_person.id
    @item = Equipment.find(@transfer.equipment_id)

    if @transfer.save
      flash[:notice] = "\"#{@item.name}\" was transfered to #{@transfer.transfer_to.display_name}."
      if params[:commit] == "Transfer"
        redirect_to :action => 'index', :controller => 'admin/equipment'
      else
        redirect_to :action => 'list'
      end
    else
      @people = Person.find(:all)
      @equipment = Equipment.find(:all)
      @locations = Location.find(:all)
      render :action => 'new'
    end
  end

  def edit
    @transfer = Transfer.find(params[:id])
    @people = Person.find(:all)
    @equipment = Equipment.find(:all)
    @locations = Location.find(:all)
  end

  def update
    @transfer = Transfer.find(params[:id])
    if @transfer.update_attributes(params[:transfer])
      flash[:notice] = 'Transfer was successfully updated.'
      redirect_to :action => 'show', :id => @transfer
    else
      render :action => 'edit'
    end
  end

  def destroy
    Transfer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
