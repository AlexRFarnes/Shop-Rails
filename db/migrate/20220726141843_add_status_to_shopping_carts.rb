class AddStatusToShoppingCarts < ActiveRecord::Migration[6.1]
  def change
    add_column :shopping_carts, :status, :integer, default: 0
  end
end

# Status para el carrito
# creado = 0
# cancelado = 1
# pagado = 2
# completado = 3