Rails.application.routes.draw do
  root :to => 'urls#new'
  post   '/urls', :to => 'urls#create', :as => 'shorten'
  get    '/:short', :to => 'urls#show'
end
