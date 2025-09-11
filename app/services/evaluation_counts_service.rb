# frozen_string_literal: true

# EvaluationCountsService
# Service responsible for aggregating evaluation counts for a sentence.
class EvaluationCountsService
  # Returns hash like { good: Integer, stay: Integer }
  def self.for_sentence(sentence)
    counts = sentence.evaluations.each_with_object(Hash.new(0)) do |evaluation, hash|
      hash[evaluation.evaluation] += 1
    end

    {
      good: counts['good'],
      stay: counts['stay']
    }
  end
end
