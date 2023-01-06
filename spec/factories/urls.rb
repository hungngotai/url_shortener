# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    original_url { 'https://www.example.com' }
    shortened { SecureRandom.hex.first(UrlShortenerService::LIMIT_LENGTH) }
  end
end
