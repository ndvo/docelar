require 'rails_helper'

RSpec.describe LogInspector::Parser do
  let(:parser) { described_class.new }

  describe '#parse' do
    it 'parses request lines' do
      line = 'Started GET "/galleries/1" for 127.0.0.1 at 2024-01-01 12:00:00'
      entry = parser.parse(line)

      expect(entry[:type]).to eq(:request)
      expect(entry[:method]).to eq('GET')
      expect(entry[:path]).to eq('/galleries/1')
    end

    it 'parses completed response lines' do
      line = 'Completed 200 OK in 45ms (ActiveRecord: 10.5ms)'
      entry = parser.parse(line)

      expect(entry[:type]).to eq(:response)
      expect(entry[:status]).to eq(200)
      expect(entry[:duration_ms]).to eq(45.0)
    end
  end
end

RSpec.describe LogInspector::Analyzer do
  let(:analyzer) { described_class.new }

  describe '#add' do
    it 'tracks responses' do
      response_entry = { type: :response, status: 200, duration_ms: 100.0, timestamp: '12:00:00' }
      analyzer.add(response_entry)

      results = analyzer.results
      expect(results[:summary][:total_entries]).to eq(1)
    end

    it 'calculates average response time' do
      analyzer.add({ type: :response, status: 200, duration_ms: 50.0, timestamp: '12:00:00' })
      analyzer.add({ type: :response, status: 200, duration_ms: 150.0, timestamp: '12:00:00' })

      results = analyzer.results
      expect(results[:summary][:avg_response_time]).to eq(100.0)
    end
  end

  describe '#results' do
    it 'returns summary statistics' do
      analyzer.add({ type: :response, status: 200, duration_ms: 100.0, timestamp: '12:00:00' })

      results = analyzer.results

      expect(results[:summary]).to include(
        total_entries: 1,
        error_count: 0,
        slow_query_count: 0
      )
    end
  end
end

RSpec.describe 'Error Prevention Tests' do
  it 'Active Storage variant processor is configured' do
    processor = Rails.application.config.active_storage.variant_processor

    expect(processor).to eq(:mini_magick).or eq(:vips)
  end

  it 'Gallery has photos association' do
    gallery = Gallery.new(name: 'Test', folder_name: 'test')
    expect(gallery).to respond_to(:photos)
  end

  it 'Photo has file attachment' do
    photo = Photo.new
    expect(photo).to respond_to(:file)
  end

  it 'GalleriesController responds to show action' do
    expect(GalleriesController.new).to respond_to(:show)
  end
end
