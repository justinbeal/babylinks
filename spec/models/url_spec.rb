require 'rails_helper'

RSpec.describe Url, type: :model do
  describe "#primary_key" do
    it "should use short_url as the primary key for find methods" do
      u = Url.create :short_url => "http://babylin.ks/short", :long_url => "http://example.com?thisisreallytoolong"

      u2 = Url.find("http://babylin.ks/short")

      expect(u2).to eq(u)
    end
  end
end
