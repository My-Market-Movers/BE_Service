class NewsApiService 
  def self.search_articles(keyword)
    response = conn.get("/v2/everything?") do |req|
      req.params["q"] = keyword
      req.params["pageSize"] = 2
    end
    
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def self.conn
    Faraday.new('https://newsapi.org/') do |req|
      req.params["apiKey"] = ENV['news_api_key']
    end
  end
end