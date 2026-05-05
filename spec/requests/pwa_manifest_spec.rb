require 'rails_helper'

RSpec.describe 'PWA Manifest', type: :request do
  describe 'GET /manifest.json' do
    it 'returns a successful response' do
      get '/manifest.json'
      expect(response).to be_successful
    end

    it 'returns valid JSON' do
      get '/manifest.json'
      expect { JSON.parse(response.body) }.not_to raise_error
    end

    it 'has required PWA fields' do
      get '/manifest.json'
      manifest = JSON.parse(response.body)

      expect(manifest).to have_key('name')
      expect(manifest).to have_key('short_name')
      expect(manifest).to_have_key('start_url')
      expect(manifest).to have_key('display')
      expect(manifest).to have_key('background_color')
      expect(manifest).to have_key('theme_color')
      expect(manifest).to have_key('icons')
    end

    it 'has correct content type' do
      get '/manifest.json'
      expect(response.content_type).to include('application/json')
    end

    it 'has standalone display mode' do
      get '/manifest.json'
      manifest = JSON.parse(response.body)
      expect(manifest['display']).to eq('standalone')
    end

    it 'has app icons with multiple sizes' do
      get '/manifest.json'
      manifest = JSON.parse(response.body)
      icons = manifest['icons']

      expect(icons).to be_an(Array)
      expect(icons).not_to be_empty

      sizes = icons.map { |icon| icon['sizes'] }
      expect(sizes).to include('192x192')
      expect(sizes).to include('512x512')
    end
  end
end
