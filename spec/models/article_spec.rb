require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(10) }
    it { should validate_inclusion_of(:status).in_array(%w[public private archived]) }
  end

  describe 'scopes' do
    describe '.public_count' do
      it 'returns count of public articles' do
        Article.create!(title: 'Public Article', body: 'Content here', status: 'public')
        Article.create!(title: 'Private Article', body: 'Content here', status: 'private')

        expect(Article.public_count).to eq(1)
      end
    end
  end

  describe '#archived?' do
    it 'returns true for archived status' do
      article = Article.new(status: 'archived')
      expect(article.archived?).to be true
    end

    it 'returns false for non-archived status' do
      article = Article.new(status: 'public')
      expect(article.archived?).to be false
    end
  end
end