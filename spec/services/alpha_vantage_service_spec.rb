require 'rails_helper'

RSpec.describe AlphaVantageService, :vcr do 
  describe "#weekly_adjusted_data returns a stock's specific data", :vcr do 
    it "returns a json response with top level keys: Meta Data and Weekly Adjusted Time Series" do
      response = AlphaVantageService.weekly_adjusted_data("pypl")
      require 'pry';binding.pry
      expect(response).to be_a(Hash)
      expect(response.keys).to eq([:"Meta Data", :"Weekly Adjusted Time Series"])

      # method to calculate when the earliest data is from
      #get the end of month for the 7 yr 11 months ago
      #this is the last key in the returned has (the earliest data)
      target_date = Date.today.prev_year(7).prev_month(11)
      last_day_of_month = target_date.end_of_month.day
      formatted_date = target_date.strftime("%Y-%m")
      formatted_date_with_last_day = "#{formatted_date}-#{last_day_of_month}"
      
  end
end