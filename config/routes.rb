Rails.application.routes.draw do
  post   '/urls', :to => 'urls#create', :as => 'shorten'
  get    '/:short', :to => 'urls#show'
end
