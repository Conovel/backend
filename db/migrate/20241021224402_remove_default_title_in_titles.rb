# frozen_string_literal: true

# titlesテーブルのtitleのデフォルト値を削除
class RemoveDefaultTitleInTitles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :titles, :title, from: '??', to: nil
  end
end
