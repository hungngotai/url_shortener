class UrlShortenerService
  attr_reader :original_url

  def self.call(original_url)
    new(original_url).call
  end

  def initialize(original_url)
    @original_url = original_url
  end

  def call
    unescape_url = CGI.unescape(original_url)
    Url.find_or_create_by(original_url: unescape_url) do |url|
      url.shortened = SecureRandom.hex.first(7)
    end.shortened
  end
end
