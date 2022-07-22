# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string
#  price      :integer          default(0)
#  stock      :integer          default(0)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

    before_create :validate_product
    after_create :send_notification

    before_update :code_notification_changed, if: :code_changed? # el metodo code_changed? consiste en el nombre del atributo mas '_changed?' y se hereda del ApplicationRecord

    after_update :send_notification_stock, if: :stock_limit?
    
    # save runs both on create and update
    after_save :push_notification, if: :discount?

    # El metodo update_attribute omite las validaciones
    validates :title, presence: { message: "Es necesario definir un valor para el titulo" }
    validates :code, presence: { message: "Es necesario definir un valor para el codigo" }

    validates :code, uniqueness: { message: "El codigo %{value} ya se encuentra en uso" } # El placeholder %{value} permite pasar el valor del atributo

    # validates :price, length: { minimum: 3, maximum: 10 }
    validates :price, length: { in: 3..10, message: "El precio se encuentra fuera de rango (Min: 3, Max: 10" }, if: :has_price?

    validate :code_validate

    validates_with ProductValidator

    # Usar scopes para registrar consultas pre-establecidas
    # El metodo scope recibe como primer argumento el nombre del scope, y como segundo argumento una funcion anonima que debe realizar unicamente una sola accion
    # El metodo scope se encarga de crear un metodo de clase
    scope :available, -> (min = 1) { where('stock >= ?', min) }
    scope :order_price_desc, -> { order("price DESC") }

    # Los scopes se pueden combinar para realizar tareas mas complejas
    scope :available_and_order_price_desc, -> (min = 1) { available(min).order_price_desc }


    def total
        # el precio esta guardado en centavos
        self.price / 100
    end

    def discount?
        self.total <= 5
    end

    def has_price?
        # primero chequear que tenga un precio y luego que sea mayor a 0
        !self.price.nil? && self.price > 0
    end

    # Metodo de clase se utiliza cuando las consultas sean en extremo complejas para realizarse unicamente con funciones anonimas
    def self.top_5_available
        self.available.order_price_desc.limit(5).pluck(:title, :code)
    end

    private

    def stock_limit?
        self.saved_change_to_stock? && self.stock <= 5
    end

    def code_validate
        if self.code.nil? || self.code.length < 3 
            self.errors.add(:code, "El codigo debe poseer al menos 3 caracteres.")
        end
    end

    def validate_product
        puts "\n\n\n>>>>>> Un nuevo producto sera añadido a almacen!"
    end

    def send_notification
        puts "\n\n\n>>>>>> Un nuevo producto fue añadido a almacen: #{self.title} - $#{self.total} USD"
    end

    # Si el precio es menor o igual que $5
    def push_notification
        puts "\n\n\n>>>>>> Un nuevo producto en descuento se encuentra disponible: #{self.title}"
    end

    def code_notification_changed
        puts "\n\n\n>>>>>> El codigo fue modificado."
    end

    def send_notification_stock
        puts "\n\n\n>>>>>> El producto #{self.title} se encuentra escaso en almacen: #{self.stock}."
    end

end
