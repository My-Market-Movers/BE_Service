require 'rails_helper'

RSpec.describe NewsApiService, :vcr do 
  describe 'class methods' do 
    it 'returns articles based on keyword' do 
      response = NewsApiService.search_articles('audi')
      expect(response).to be_a Hash
      expect(response).to have_key :articles
      expect(response[:articles]).to be_a Array
      expect(response[:articles].count).to eq 2
      expect(response[:articles][0]).to have_key :title
      expect(response[:articles][0]).to have_key :description
      expect(response[:articles][0]).to have_key :url
    end
  end
end
