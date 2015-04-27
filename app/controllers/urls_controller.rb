class UrlsController < ApplicationController
  def show
    url = Url.find_by :short_url => params[:short]

    if url
      redirect_to url.long_url
    else
      redirect_to root_url
    end
  end

  def new
    @url = Url.new
  end

  def create
    
  end
end
