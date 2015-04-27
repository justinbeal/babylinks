class UrlsController < ApplicationController
  def show
    url = Url.find_close_to params[:short]

    if url
      url.last_seen = Time.now
      url.view_count += 1
      url.save!
      redirect_to url.long_url
    else
      flash[:notice] = "We don't recognize this link."
      redirect_to root_url
    end
  end

  def info

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
      flash.now[:notice] = "Shortened #{long_url} to #{short_url}. Enjoy!"
    else
      if params[:url][:long_url].present?
        flash.now[:error] = "Babylinks will only shorten http or https urls."
      else
        flash.now[:error] = "Babylinks needs a url to generate a short url to point to."
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
