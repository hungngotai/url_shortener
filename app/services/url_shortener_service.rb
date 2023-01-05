class UrlShortenerService
  LIMIT_LENGTH = 7
  BASE_62_STRING = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze

  attr_reader :original_url

  def self.call(original_url)
    new(original_url).call
  end

  def initialize(original_url)
    @original_url = original_url
  end

  def call
    unescape_url = CGI.unescape(original_url)
    url_with_counter = "#{unescape_url}counter=#{counter}"
    url_md5_digest = Digest::MD5.hexdigest(url_with_counter)
    shortened = to_base62(url_md5_digest.to_i(16)).first(LIMIT_LENGTH)
    url = Url.new(original_url: url_with_counter, shortened: 'shortened')
    url.save
    url
  end

  private

  def counter
    cache = Rails.cache
    counter = cache.read(:counter).to_i
    cache.write(:counter, counter + 1)
    counter.to_s
  end

  def to_base62(decimal)
    hash_str = ''
    while decimal.positive?
      hash_str = BASE_62_STRING[decimal % 62] + hash_str
      decimal /= 62
    end
    hash_str
  end
end
