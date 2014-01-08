ActionController::Routing::Routes.draw do |map|

  map.root :controller => "pages", :action => "index"

  map.login        "/login",         :controller => "user_sessions", :action => "login"
  map.login_submit "/login_submit",  :controller => "user_sessions", :action => "login_submit"
  map.logout       "/logout",        :controller => "user_sessions", :action => "logout"

  map.signup        "/signup",        :controller => "users",   :action => "signup"
  map.signup_submit "/signup_submit", :controller => "users",   :action => "signup_submit"

  map.profile        "/profile",        :controller => "users",   :action => "profile"
  map.profile_update "/profile_update", :controller => "users",   :action => "profile_update"

  map.products      "/products",                 :controller => "products", :action => "index"
  map.search        "/products/search",          :controller => "products", :action => "search"
  map.connect       "/products/add_to_cart/:id", :controller => "products", :action => "add_to_cart"
  map.list_or_item  "/products/*path",           :controller => "products", :action => "list_or_item"
  map.cart          "/cart",                     :controller => "cart"
  map.checkout      "/checkout",                 :controller => "checkout"

  map.testimonials "testimonials", :controller => "testimonials"

  map.namespace :admin do |admin|
    admin.root :controller => "staff_sessions", :action => "index"

    admin.login        "login",        :controller => "staff_sessions", :action => "login"
    admin.login_submit "login_submit", :controller => "staff_sessions", :action => "login_submit"
    admin.logout       "logout",       :controller => "staff_sessions", :action => "logout"

  end



  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'

  map.connect '*path', :controller => "pages", :action => "page"

end
