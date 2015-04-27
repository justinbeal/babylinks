Rails.application.routes.draw do
  root :to => 'urls#new'
  post   '/urls', :to => 'urls#create', :as => 'shorten'

  get    '/info/:short', :to => 'urls#info', :as => 'url_info'
  get    '/:short', :to => 'urls#show'
end
