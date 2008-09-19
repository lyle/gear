class EquipmentController < ApplicationController
  layout "application"
  
  before_filter :login_required #, :except => [ :index ]
  
  def index
    @equipment = Equipment.find(:all, :conditions=>"parent_id IS NULL")
  end
  def show
    @item = Equipment.find(params[:id])
  end
  
  def live_search

      @phrase = params[:searchtext]
      request.raw_post || request.query_string
      a1 = "%"
      a2 = "%"
      @searchphrase = a1  + @phrase + a2
      @results = Equipment.find(:all, :conditions => [ "description LIKE ? OR name LIKE ? OR manufacturer LIKE ? OR model LIKE ? OR inventory_identifier LIKE ?", @searchphrase, @searchphrase, @searchphrase, @searchphrase, @searchphrase])

      @number_match = @results.length

      render(:layout => false)
  end
  
  
end
