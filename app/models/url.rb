class Url < ActiveRecord::Base
  self.primary_key = 'short_url'

  before_create :validate_short_url

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

  def self.short_url_profane?(url)
    url.include? "foo"
  end

  def self.short_url_valid?(url)
    !Url::short_url_has_neighbors?(url) && !Url::short_url_profane?(url)
  end

  def self.short_url_has_neighbors?(url)
    Url.all.each do |u|
      return true if Levenshtein::distance(u.short_url, url) <= 1
    end

    false
  end

  def self.find_close_to(url)
    Url.all.each do |u|
      return u if Levenshtein::distance(u.short_url, url) <= 1
    end

    nil
  end
end
