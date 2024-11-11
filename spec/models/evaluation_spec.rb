# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Evaluation, type: :model do
  let(:user) { User.find_by(email: 'user1@example.com') }
  let(:sentence) { Sentence.find_by(sentence: '吾輩は猫である。') }

  it 'is valid with valid attributes' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.id,
      sentence_id: sentence.id,
      evaluation: 'good'
    )
    expect(evaluation).to be_valid
  end

  it 'is not valid without an evaluator_user_id' do
    evaluation = Evaluation.new(
      sentence_id: sentence.id,
      evaluation: 'good'
    )
    expect(evaluation).not_to be_valid
  end

  it 'is not valid without a sentence_id' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.id,
      evaluation: 'good'
    )
    expect(evaluation).not_to be_valid
  end

  it 'is not valid without an evaluation' do
    evaluation = Evaluation.new(
      evaluator_user_id: user.id,
      sentence_id: sentence.id
    )
    expect(evaluation).not_to be_valid
  end
end
# rubocop:enable Metrics/BlockLength
