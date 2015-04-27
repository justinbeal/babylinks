require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe '#show' do
    it 'should redirect to the long_url for the provided short_url' do
      url = Url.create :short_url => "short", :long_url => "http://example.com/long"
      get :show, :short => url.short_url
      expect(response).to redirect_to url.long_url
    end

    it 'should redirect to the root URL if the provided short_url is unknown.' do
      get :show, :short => 'donaldduck'
      expect(response).to redirect_to root_path
    end
  end
end