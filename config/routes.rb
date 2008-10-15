ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.connect 'admin/groups/import_ldap_group/:id/:ldap_group_id', :controller=> 'admin/groups', :action=>'import_ldap_group'
  map.connect 'admin/equipment/destroy_all', :controller=>'admin/equipment', :action=>'destroy_all'

  map.connect 'admin/groups/sort', :controller=>"admin/groups", :action=>"sort", :conditions => { :method => :post }
  
  
  map.namespace :admin do |admin|
    admin.resources :equipment
    admin.equipment_full_image 'equipment/full_image/:id.:format', :controller=>'equipment', :action => 'full_image' 
    admin.resources :groups
    admin.resources :people
    admin.resources :locations
  end
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "overview"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.connect 'admin', :controller => 'admin/equipment'
end
