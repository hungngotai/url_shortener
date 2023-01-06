# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { build :url }

  context 'validation' do
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_presence_of(:shortened) }
    it { is_expected.to validate_uniqueness_of(:shortened) }

    context 'when original_url is url' do
      it { is_expected.to be_valid }
    end

    context 'when original_url is not url' do
      subject { build(:url, original_url: 'invalid url') }

      it { is_expected.to be_invalid }
    end
  end
end
