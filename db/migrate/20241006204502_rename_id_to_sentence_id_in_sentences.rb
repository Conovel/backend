# frozen_string_literal: true

# カラム名id（Railsデフォルト）をsentence_idに変更
class RenameIdToSentenceIdInSentences < ActiveRecord::Migration[7.0]
  def change
    rename_column :sentences, :id, :sentence_id
  end
end
