FactoryGirl.define do
  factory :food do
    description   "Pizza Snacks"
    brand_name    "Dominoes"
    product_name  "Peperoni"
    nutrition     Hash.new({
      :calories     => '140',
      :carbohydrate => '18'
    })
    sequence (:upc) {|n| "YOLO#{n}" }
  end
end
