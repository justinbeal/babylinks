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
    params[:url][:short_url] = Url.generate_short_url unless params[:url][:short_url]

    url = Url.create user_params
    flash[:notice] = "Shortened #{url.long_url} to #{url.short_url}. Enjoy!"
    @url = Url.new
    render :new
  end

  private

  def user_params
    params.require(:url).permit(:long_url, :short_url)
  end
end
