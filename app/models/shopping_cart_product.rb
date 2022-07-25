# == Schema Information
#
# Table name: shopping_cart_products
#
#  id               :bigint           not null, primary key
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
class ShoppingCartProduct < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  after_create :update_total!
  after_destroy :update_total!

  private

  def update_total!
    self.shopping_cart.update_total!
  end

end
