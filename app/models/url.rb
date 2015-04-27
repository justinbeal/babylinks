class Url < ActiveRecord::Base
  self.primary_key = 'short_url'

  before_save :validate_short_url

  KEY_LENGTH=8

  def validate_short_url
    Url::short_url_valid?(short_url)
  end

  def self.generate_short_url
    range = [*'0'..'9',*'A'..'Z',*'a'..'z']
    url = Array.new(KEY_LENGTH){ range.sample }.join

    until Url::short_url_valid?(url)
      url = Array.new(KEY_LENGTH){ range.sample }.join
    end

    url
  end

  def self.short_url_valid?(url)
    Url.all.each do |u|
      return false if Levenshtein::distance(u.short_url, url) <= 1
    end

    true
  end

  def self.find_close_to(url)
    Url.all.each do |u|
      return u if Levenshtein::distance(u.short_url, url) <= 1
    end

    nil
  end
end
