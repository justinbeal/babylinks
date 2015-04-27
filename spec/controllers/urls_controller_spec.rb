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
    context 'when valid info is provided' do
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

    context 'when invalid info is provided' do
      
    end
  end
end
