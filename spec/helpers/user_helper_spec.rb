# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserHelper, type: :helper do
  describe '#user_display_info' do
    it 'delegates to UserDisplayInfoService.build and returns its result' do
      user = build_stubbed(:user)
      fake_result = { pen_name: 'stubbed', profile_icon_image: 'stub.png' }
      expect(UserDisplayInfoService).to receive(:build).with(user).and_return(fake_result)

      expect(helper.user_display_info(user)).to eq(fake_result)
    end

    it 'delegates nil to UserDisplayInfoService.build' do
      fake_result = { pen_name: UserDisplayInfoService.anonymous_display, profile_icon_image: '' }
      expect(UserDisplayInfoService).to receive(:build).with(nil).and_return(fake_result)

      expect(helper.user_display_info(nil)).to eq(fake_result)
    end
  end
end
