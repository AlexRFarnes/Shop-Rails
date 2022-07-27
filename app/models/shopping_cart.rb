# == Schema Information
#
# Table name: shopping_carts
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  status     :integer          default(0)
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

  include AASM

  # atributo user generado de manera automatica que hace referencia al modelo user
  belongs_to :user
  has_many :shopping_cart_products
  has_many :products, through: :shopping_cart_products

  enum status: [:created, :canceled, :paid, :completed]

  aasm column: 'status' do 
    state :created, initial: true
    state :canceled
    state :paid
    state :completed

    event :cancel do 
      transitions from: :created, to: :canceled
    end

    event :pay do 
      transitions from: :created, to: :paid
    end

    event :complete do
      transitions from: :paid, to: :completed
    end

  end

  def format_total
    self.total / 100
  end

  def update_total!
    self.update(total: self.get_total)
  end

  def paid!
    ActiveRecord::Base.transaction do 
      self.update!(status: :paid)
  
      self.products.each do |product|
        quantity = ShoppingCartProduct.find_by(shopping_cart_id: self.id, product_id: product.id).quantity

        product.with_lock do 
          product.update!(stock: product.stock - quantity)
        end
      end
    
    end
  end

  def get_total
    # ShoppingCart.joins(:shopping_cart_products) # joins es un metodo de clase y por default implementa un inner join
    # .joins(:products)
    # .where(shopping_carts: { id: self.id })
    # .group(:shopping_cart_products)
    # .select('SUM(products.price) AS total')[0].total
    Product.joins(:shopping_cart_products)
    .where(shopping_cart_products: { shopping_cart_id: self.id })
    .select('SUM(products.price * shopping_cart_products.quantity) AS t')[0].t
  end

  # def products_in_cart
  #   Product.joins(:shopping_cart_products)
  #   .where(shopping_cart_products: {shopping_cart_id: self.id })
  #   .group('products.id')
  #   .select('COUNT(products.id) AS quantity, products.id, products.title, products.price')
  # end

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
