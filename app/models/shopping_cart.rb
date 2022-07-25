# == Schema Information
#
# Table name: shopping_carts
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  total      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_shopping_carts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ShoppingCart < ApplicationRecord
  # atributo user generado de manera automatica que hace referencia al modelo user
  belongs_to :user
  has_many :shopping_cart_products
  has_many :products, through: :shopping_cart_products

  def format_total
    self.total / 100
  end

  def update_total!
    self.update(total: self.get_total)
  end

  def get_total
    ShoppingCart.joins(:shopping_cart_products) # joins es un metodo de clase y por default implementa un inner join
    .joins(:products)
    .where(shopping_carts: { id: self.id })
    .group(:shopping_cart_products)
    .select('SUM(products.price) AS total')[0].total
  end

  # def get_total
  #   total = 0
  #   # self.shopping_cart_products.includes(:product).each do |scp|
  #   #   total += scp.product.price
  #   # end
  #   self.products.each do |product|
  #     total += product.price
  #   end

  #   total
  # end

end
