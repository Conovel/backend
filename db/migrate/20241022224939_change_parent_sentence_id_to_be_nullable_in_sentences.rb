# frozen_string_literal: true

# sentencesテーブルのparent_sentence_idカラムをNULL許可に変更
class ChangeParentSentenceIdToBeNullableInSentences < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sentences, :parent_sentence_id, true
  end
end
