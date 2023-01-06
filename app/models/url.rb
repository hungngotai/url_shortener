# frozen_string_literal: true

class Url < ApplicationRecord
  validates :original_url, presence: true, url: true
  validates :shortened, presence: true, uniqueness: true
end
