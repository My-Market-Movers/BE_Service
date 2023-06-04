FactoryBot.define do
  factory :user_stock do
    user { nil }
    stock_ticker { "MyString" }
    shares { 1.5 }
    purchase_price { 1.5 }
  end
end
