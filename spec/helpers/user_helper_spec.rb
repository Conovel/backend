# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserHelper, type: :helper do
  describe '#user_display_info' do
    let(:anonymous) { helper.send(:anonymous_display) }

    context 'when user is nil' do
      it 'returns anonymous pen name and empty profile' do
        expect(helper.user_display_info(nil)).to eq({ pen_name: anonymous, profile_icon_image: '' })
      end
    end

    context 'when user is anonymous' do
      let(:user) { build_stubbed(:user, is_anonymous: true) }

      it 'returns anonymous pen name and empty profile' do
        expect(helper.user_display_info(user)).to eq({ pen_name: anonymous, profile_icon_image: '' })
      end
    end

    context 'when user is logically deleted (deleted_at present)' do
      let(:user) do
        build_stubbed(:user, pen_name: 'ShouldBeMasked', profile_icon_image: 'icon.png', deleted_at: Time.current,
                             is_anonymous: true)
      end

      # 論理削除ユーザーはis_anonymousがtrueになる想定だが、念のため論理削除ユーザー単体もテスト実行
      it 'returns anonymous pen name and empty profile' do
        expect(helper.user_display_info(user)).to eq({ pen_name: anonymous, profile_icon_image: '' })
      end
    end

    context 'when user has empty pen_name' do
      let(:user) { build_stubbed(:user, pen_name: '', profile_icon_image: 'icon.png') }

      # pen_nameはnull: falseになる想定だが、念のためpen_nameが空文字のケースもテスト実行
      it 'falls back to anonymous for pen_name and preserves profile (or empty if blank)' do
        expect(helper.user_display_info(user)).to eq({ pen_name: anonymous, profile_icon_image: 'icon.png' })
      end
    end

    context 'when user is normal' do
      let(:user) { build_stubbed(:user, pen_name: 'Alice', profile_icon_image: 'alice.png') }

      it 'returns actual pen_name and profile_icon_image' do
        expect(helper.user_display_info(user)).to eq({ pen_name: 'Alice', profile_icon_image: 'alice.png' })
      end
    end
  end
end
