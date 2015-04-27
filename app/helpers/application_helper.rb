module ApplicationHelper
 def route
    "#{ params[:controller] }/#{ params[:action] }"
  end
end
