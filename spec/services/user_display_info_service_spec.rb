# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDisplayInfoService, type: :service do
  describe '.build' do
    context 'when user is nil' do
      it 'returns anonymous pen name and empty profile' do
        expect(UserDisplayInfoService.build(nil)).to eq({ pen_name: UserDisplayInfoService.anonymous_display,
                                                          profile_icon_image: '' })
      end
    end

    context 'when user is anonymous' do
      let(:user) { build_stubbed(:user, is_anonymous: true) }

      it 'returns anonymous pen name and empty profile' do
        expect(UserDisplayInfoService.build(user)).to eq({ pen_name: UserDisplayInfoService.anonymous_display,
                                                           profile_icon_image: '' })
      end
    end

    context 'when user has empty pen_name' do
      let(:user) { build_stubbed(:user, pen_name: '', profile_icon_image: 'icon.png') }

      it 'falls back to anonymous for pen_name and preserves profile' do
        expect(UserDisplayInfoService.build(user)).to eq({ pen_name: UserDisplayInfoService.anonymous_display,
                                                           profile_icon_image: 'icon.png' })
      end
    end

    context 'when user is normal' do
      let(:user) { build_stubbed(:user, pen_name: 'Alice', profile_icon_image: 'alice.png') }

      it 'returns actual pen_name and profile_icon_image' do
        expect(UserDisplayInfoService.build(user)).to eq({ pen_name: 'Alice', profile_icon_image: 'alice.png' })
      end
    end
  end
end
