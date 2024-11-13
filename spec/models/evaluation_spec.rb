# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Evaluation, type: :model do
  let(:user) { create(:user) }
  let(:sentence) { create(:sentence, user:) }

  it 'is valid with valid attributes' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.user_id,
      sentence_id: sentence.sentence_id,
      evaluation: 'good'
    )
    expect(evaluation).to be_valid
  end

  it 'is not valid without an evaluator_user_id' do
    evaluation = Evaluation.new(
      sentence_id: sentence.sentence_id,
      evaluation: 'good'
    )
    expect(evaluation).not_to be_valid
  end

  it 'is not valid without a sentence_id' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.user_id,
      evaluation: 'good'
    )
    expect(evaluation).not_to be_valid
  end

  it 'is not valid without an evaluation' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.user_id,
      sentence_id: sentence.sentence_id
    )
    expect(evaluation).not_to be_valid
  end
end
# rubocop:enable Metrics/BlockLength
