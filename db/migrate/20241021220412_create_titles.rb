# frozen_string_literal: true

# titlesテーブルを作成
class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles, primary_key: :title_id do |t|
      t.string :title, null: false, default: '未定', limit: 128
      t.timestamps
    end
  end
end
