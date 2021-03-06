require 'rails_helper'

RSpec.describe UrlsController, type: :controller do

  describe '#info' do
    context 'when a known short url is provided' do
      it 'should render json information about the provided short_url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        get :info, :short => url.short_url
        expect(response.body).to eq(url.to_json)
      end

      it 'should render json information if a close match exists as well' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        get :info, :short => "shirt"
        expect(response.body).to eq(url.to_json)
      end

      it 'should not update the last_seen timestamp for this url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long", :last_seen => Time.now
        last_seen_before = url.last_seen
        get :info, :short => url.short_url

        expect(url.reload.last_seen.utc.to_s).to eq(last_seen_before.to_s)
      end

      it 'should not increment the view count for this url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        views_before = url.view_count

        get :info, :short => url.short_url
        expect(url.reload.view_count).to eq(views_before)
      end
    end

    it 'should render nothing if the provided short_url is unknown.' do
      get :info, :short => 'donaldduck'
      expect(response.body).to be_empty
    end
  end

  describe '#show' do
    context 'when a known short url is provided' do
      it 'should redirect to the long_url for the provided short_url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        get :show, :short => url.short_url
        expect(response).to redirect_to url.long_url
      end

      it 'should redirect if a close match exists as well' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        get :show, :short => "shirt"
        expect(response).to redirect_to url.long_url
      end

      it 'should update the last_seen timestamp for this url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        get :show, :short => url.short_url

        expect(url.reload.last_seen.utc).to be_within(1.second).of Time.now
      end

      it 'should increment the view count for this url' do
        url = Url.create :short_url => "short", :long_url => "http://example.com/long"
        views_before = url.view_count

        get :show, :short => url.short_url
        expect(url.reload.view_count).to eq(views_before + 1)
      end
    end

    it 'should redirect to the root URL with a flash if the provided short_url is unknown.' do
      get :show, :short => 'donaldduck'
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq("We don't recognize this link.")
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
