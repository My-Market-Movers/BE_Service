require 'rails_helper'

RSpec.describe AlphaVantageService, :vcr do 
  describe "#weekly_adjusted_data returns a stock's specific data", :vcr do 
    before(:each) do
      @ticker = "pypl"
      @response = AlphaVantageService.weekly_adjusted_data(@ticker)
    end
    
    it "returns a json response with top level keys: Meta Data and Weekly Adjusted Time Series" do
      expect(@ticker).to be_a(String)

      expect(@response).to be_a(Hash)
      expect(@response.keys).to eq([:"Meta Data", :"Weekly Adjusted Time Series"])

      expect(@response[:"Meta Data"]).to be_a(Hash)
      expect(@response[:"Meta Data"].keys).to eq([:"1. Information", :"2. Symbol", :"3. Last Refreshed", :"4. Time Zone"])
      
      expect(@response[:"Meta Data"][:"2. Symbol"]).to eq(@ticker)

      expect(@response[:"Weekly Adjusted Time Series"]).to be_a(Hash)
    end

    it "responds with weekly stock value info that are numerical within the key :Weekly Adjusted Time Series" do
      @response[:"Weekly Adjusted Time Series"].each do |week, values|
        expect(values.keys).to eq([:"1. open", :"2. high", :"3. low", :"4. close", :"5. adjusted close", :"6. volume", :"7. dividend amount"])
        values.each do |value|
          expect(value.last).to match(/^\d+(\.\d+)?$/) #the string response matches, either, an Integer or Floats
        end
      end
    end

    it "includes data from the week 7 years and 11 months ago - so we know the period range of the data we receive" do
      # method to calculate when the earliest data is from (ie earliest wk key in :Weekly Adjusted Time Series)
      #which is from the end of month for the 7 yr 11 months ago
      
      target_date = Date.today.prev_year(7).prev_month(11)
      last_day_of_month = target_date.end_of_month.day
      formatted_date = target_date.strftime("%Y-%m")

      week_7_years_11_months_ago = "#{formatted_date}-#{last_day_of_month}"
      earliest_week = @response[:"Weekly Adjusted Time Series"].keys.last.to_s

      expect(earliest_week).to eq(week_7_years_11_months_ago)
    end
  end
end