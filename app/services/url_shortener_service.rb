# frozen_string_literal: true

class UrlShortenerService
  LIMIT_LENGTH = 7
  BASE_62_STRING = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

  attr_reader :original_url

  def self.call(original_url)
    new(original_url).call
  end

  def initialize(original_url)
    @original_url = CGI.unescape(original_url)
  end

  def call
    url = Url.new(original_url: original_url, shortened: shortened)
    url.save
    url
  end

  private

  def counter
    @counter ||= begin
      cache = Rails.cache
      counter = cache.read(:counter).to_i
      cache.write(:counter, counter + 1)
      counter.to_s
    end
  end

  def to_base62(decimal)
    hash_str = ''
    while decimal.positive?
      hash_str = BASE_62_STRING[decimal % 62] + hash_str
      decimal /= 62
    end
    hash_str
  end

  def shortened
    url_digest = Digest::MD5.hexdigest(original_url + counter).to_i(16)
    to_base62(url_digest).first(LIMIT_LENGTH)
  end
end
