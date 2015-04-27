class Url < ActiveRecord::Base
  self.primary_key = 'short_url'

  KEY_LENGTH=8

  def self.generate_short_url
    range = [*'0'..'9',*'A'..'Z',*'a'..'z']
    Array.new(KEY_LENGTH){ range.sample }.join
  end

end
