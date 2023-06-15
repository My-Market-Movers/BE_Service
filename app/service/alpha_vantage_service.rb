class AlphaVantageService
  def self.weekly_adjusted_data(ticker)
    response = domain.get("/query?") do |search|
      search.params["function"] = "TIME_SERIES_WEEKLY_ADJUSTED"
      search.params["symbol"] = ticker
    end
    parsed_symbolized(response)
  end

  def self.domain
    Faraday.new("https://www.alphavantage.co") do |req|
      req.params["apikey"] = ENV["alpha_vantage_key"]
    end
  end

  def self.parsed_symbolized(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end