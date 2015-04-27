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
    if params[:url][:long_url] && params[:url][:long_url].start_with?("http")
      params[:url][:short_url] = Url.generate_short_url unless params[:url][:short_url]
      url = Url.create user_params

      long_url = "<a href='#{url.long_url.html_safe}'>#{url.long_url.html_safe}</a>"
      short_url = "<a href='#{url.short_url.html_safe}'>#{request.protocol}#{request.domain}/#{url.short_url.html_safe}</a>"
      flash[:notice] = "Shortened #{long_url} to #{short_url}. Enjoy!"
    else
      if params[:url][:long_url].present?
        flash[:error] = "Babylinks will only shorten http or https urls."
      else
        flash[:error] = "Babylinks needs a url to generate a short url to point to."
      end
      response.status = 400
    end

    @url = Url.new
    render :new
  end

  private

  def user_params
    params.require(:url).permit(:long_url, :short_url)
  end
end
