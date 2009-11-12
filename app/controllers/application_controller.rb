# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_danm_gear_session_id'
  include AuthenticatedSystem
  
  
  require "rubygems"
  require 'RMagick'
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie
  #ActiveScaffold.set_defaults do |config| 
  #  config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  #end
end
