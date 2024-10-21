# frozen_string_literal: true

# sentence_hierarchyカラムを追加
class AddSentenceHierarchyToSentences < ActiveRecord::Migration[7.0]
  def change
    add_column :sentences, :sentence_hierarchy, :integer, null: false
  end
end
