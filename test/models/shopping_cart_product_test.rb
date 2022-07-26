# == Schema Information
#
# Table name: shopping_cart_products
#
#  id               :bigint           not null, primary key
#  quantity         :integer          default(1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint           not null
#  shopping_cart_id :bigint           not null
#
# Indexes
#
#  index_shopping_cart_products_on_product_id        (product_id)
#  index_shopping_cart_products_on_shopping_cart_id  (shopping_cart_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (shopping_cart_id => shopping_carts.id)
#
require "test_helper"

class ShoppingCartProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
