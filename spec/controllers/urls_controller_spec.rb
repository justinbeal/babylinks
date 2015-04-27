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

  describe '#create' do
    context 'when a valid url is provided' do
      it 'should save a url to the database' do
        count = Url.count
        post :create, :url => {:long_url => "http://www.example.com"}
        expect(Url.count).to eq(count + 1)
      end

      it 'should render the new page with a flash notice on success' do
        post :create, :url => {:long_url => "http://www.example.com"}
        expect(response).to render_template(:new)
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include("<a href='http://www.example.com'>http://www.example.com</a>")
      end

      it 'should return 200' do
        post :create, :url => {:long_url => "http://www.example.com"}
        expect(response.status).to eq(200)
      end
    end

    context 'when an invalid url is provided' do
      it "should not save when the provided url doesn't look like an http url" do
        count = Url.count
        post :create, :url => {:long_url => "ftp://mozilla.com"}
        expect(Url.count).to eq(count)
      end

      it 'should return 400' do
        post :create, :url => {:long_url => "ftp://mozilla.com"}
        expect(response.status).to eq(400)
      end

      it 'should render the new page with a flash error' do
        post :create, :url => {:long_url => "ftp://mozilla.com"}
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to include("Babylinks will only shorten http or https urls.")
      end

      it 'should render a special flash if no url is provided' do
        post :create, :url => {}
        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to include("Babylinks needs a url to generate a short url to point to.")
      end
    end
  end
end
