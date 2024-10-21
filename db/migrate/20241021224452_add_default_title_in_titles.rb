# frozen_string_literal: true

# titlesテーブルのtitleのデフォルト値を追加
class AddDefaultTitleInTitles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :titles, :title, from: nil, to: '未定'
  end
end
