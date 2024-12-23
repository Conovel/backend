# frozen_string_literal: true

# EvaluationHelper
module EvaluationHelper
  # 評価数を取得
  def fetch_evaluation_counts(sentence)
    counts = sentence.evaluations.each_with_object(Hash.new(0)) do |evaluation, hash|
      hash[evaluation.evaluation] += 1
    end

    {
      good: counts['good'],
      stay: counts['stay']
    }
  end
end
