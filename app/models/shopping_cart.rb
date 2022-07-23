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
end
