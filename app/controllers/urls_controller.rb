class UrlsController < ApplicationController
  def show
    url = Url.find params[:short]
    redirect_to url.long_url
  end
end
