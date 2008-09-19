class OverviewController < ApplicationController
  layout "application"
  
  before_filter :login_required #, :except => [ :index ]
  
  def index

    @equipment = Equipment.find(:all, :conditions=>"parent_id IS NULL")
    
  end



end
