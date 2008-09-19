class Admin::EquipmentController < ApplicationController
  layout "admin"  
  include AuthenticatedSystem
  before_filter :login_required
 # before_filter :login_from_cookie


  def index
    @items = Equipment.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html { render :action =>'list' }
    end
  end
  
  def show
    @equipment = Equipment.find(params[:id])
  end
  def thumbnail
    @equipment = Equipment.find(params[:id])
  end
  def edit
    @equipment = Equipment.find(params[:id])
  end
  def update
    @equipment = Equipment.find(params[:id])
    respond_to do |format|
      if  @equipment.update_attributes(params[:equipment])
        flash[:notice] = "The equipment was updated."
        format.html {redirect_to(:controller=>'admin/equipment',:action=>'show',:id=>@equipment)}
        format.xml { head :ok}
      else
        flash[:notice] = "Sorry, but something went bad."
        format.html {render :action => "edit" }
        format.xml { render :xml =>@equipment.errors, :status => :unprocessable_entry}
      end
    end
  end
 
  def new
    @equipment = Equipment.new
  end
  def create 
    @equipment = Equipment.new(params[:equipment])
    respond_to do |format|
      if @equipment.save
        flash[:notice] = 'Equipment was successfully created.'
        format.html { redirect_to admin_equipment_url(:id=>@equipment)}
      else
        format.html { render :action=> "new"}
      end
    end
  end
  def destroy_all
    @equipment = Equipment.find(:all)
    for @item in @equipment
      @item.destroy
    end
    render :text => "done"
  end
  
  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    flash[:notice] = "Okay, I killed that pesky \"#{@equipment.name}\" item."
    
    
    respond_to do |format|
      format.html { redirect_to(:controller=>"admin/equipment", :action=>"index")}
      format.xml {head :ok}
    end

  end
  def live_search

      @phrase = params[:searchtext]
      request.raw_post || request.query_string
      a1 = "%"
      a2 = "%"
      @searchphrase = a1  + @phrase + a2
      @results = Equipment.find(:all, :conditions => [ "description LIKE ? OR name LIKE ? OR manufacturer LIKE ? OR model LIKE ? OR inventory_identifier LIKE ? OR notes LIKE ?", @searchphrase, @searchphrase, @searchphrase, @searchphrase, @searchphrase, @searchphrase])

      @number_match = @results.length

      render(:layout => false)
  end
  
  #active_scaffold :equipment do |config|
      #config.label = "Customers"
  #    config.list.columns = [:name, :make_n_model, :description, :custodian]
      
  #    config.update.columns = [:name, :description, :status]      
  #    config.update.columns.add_subgroup "Details" do |name_group|
  #      name_group.add :inventory_identifier, :manufacturer, :model, :serial_number
  #    end
  #    config.create.columns = [:name, :description, :status]      
  #    config.create.columns.add_subgroup "Details" do |name_group|
  #      name_group.add :inventory_identifier, :manufacturer, :model, :serial_number
  #    end
  #    config.update.columns.add [:custodian]
  #    config.show.columns.add
      
  #    columns[:inventory_identifier].label = "DANM S/N"
      #columns[:phone].description = "(Format: ###-###-####)"
      
      
   # end
end
