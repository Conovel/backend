# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserHelper, type: :helper do
  describe '#user_display_info' do
    let(:anonymous) { helper.send(:anonymous_display) }

    it 'returns anonymous display when nil' do
      expect(helper.user_display_info(nil)).to eq({ pen_name: anonymous, profile_icon_image: '' })
    end

    it 'returns display info for a user' do
      user = build_stubbed(:user)
      # We don't assert on exact internals here, just that it returns a Hash with expected keys
      result = helper.user_display_info(user)
      expect(result).to include(:pen_name, :profile_icon_image)
    end
  end
end
