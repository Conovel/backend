# frozen_string_literal: true

# EvaluationHelper
module EvaluationHelper
  # 評価数を取得
  def fetch_evaluation_counts(sentence)
    EvaluationCountsService.for_sentence(sentence)
  end
end
