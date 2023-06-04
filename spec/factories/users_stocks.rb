FactoryBot.define do
  factory :users_stock do
    user_id { nil }
    stock_ticker { "MyString" }
    shares { 1.5 }
    purchase_price { 1.5 }
  end
end
