# frozen_string_literal: true

# sentenceカラムをNOT NULL制約に変更
class ChangeSentenceToNotNullInSentences < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sentences, :sentence, false
  end
end
