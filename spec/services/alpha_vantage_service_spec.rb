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

    context "finding data date range" do 
      it 'returns with this wks data through yesterday (current day - 1 day) - latest data' do
        yesterday = Date.yesterday.strftime("%Y-%m-%d")
        lastest_wk_data = @response[:"Weekly Adjusted Time Series"].keys.first.to_s

        expect(lastest_wk_data).to eq(yesterday)
      end

      it "returns data dated every thursday or friday of every wk - ASIDE FROM the current wk (first key)" do
        weeks = @response[:"Weekly Adjusted Time Series"].keys[1...] 
        weeks.each do |week_key|
          date = Date.parse(week_key.to_s)
          expect(date.thursday? || date.friday?).to eq(true) #if Friday is a bank holiday, returns data on Thursday
        end
      end

      it "includes data from the week 7 years and 11 months ago - earliest data" do
        # method to calculate when the earliest data is from (ie earliest wk key in :Weekly Adjusted Time Series)
        
        target_date = Date.today.prev_year(7).prev_month(11)
        last_day_of_month = target_date.end_of_month.day
        formatted_date = target_date.strftime("%Y-%m")

        week_7_years_11_months_ago = "#{formatted_date}-#{last_day_of_month}"
        earliest_week = @response[:"Weekly Adjusted Time Series"].keys.last.to_s

        expect(earliest_week).to eq(week_7_years_11_months_ago)
      end
    end
  end
end