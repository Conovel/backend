# frozen_string_literal: true

# titlesテーブルのtitleのデフォルト値を修正
class FixDefaultTitleInTitles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :titles, :title, from: '??', to: '未定'
  end
end
