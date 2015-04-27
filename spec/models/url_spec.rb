require 'rails_helper'

RSpec.describe Url, type: :model do
  describe "#primary_key" do
    it "should use short_url as the primary key for find methods" do
      u = Url.create :short_url => "http://babylin.ks/short", :long_url => "http://example.com?thisisreallytoolong"
      u2 = Url.find("http://babylin.ks/short")

      expect(u2).to eq(u)
    end
  end

  describe "@short_url_valid?" do
    it "should return false if the provided short url is within 1 Levenshtein edit of any other short urls" do
      Url.create :short_url => "tomato", :long_url => "http://example.com"

      expect(Url::short_url_valid?("tomaato")).to eq(false)
    end

    it "should return true if the provided short url is distinct from every other short url" do
        Url.create :short_url => "tomato", :long_url => "http://example.com"

        expect(Url::short_url_valid?("cucumber")).to eq(true)
    end
  end

  describe "@find_close_to" do
    it "should return exact matches on short_url" do
      u = Url.create :short_url => "tomato", :long_url => "http://example.com"
      expect(Url.find_close_to("tomato")).to eq(u)
    end

    it "should return a url record that is within 1 Levenshtein edit of any other url" do
      u = Url.create :short_url => "tomoto", :long_url => "http://example.com"
      expect(Url.find_close_to("tomato")).to eq(u)
    end

    it "should return nil if no exact or close match is found" do
      u = Url.create :short_url => "tomato", :long_url => "http://example.com"
      expect(Url.find_close_to("cucumber")).to be_nil
    end
  end
end
