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

    # save
    before_save :validate_product
    after_save :send_notification

    def validate_product
        puts "\n\n\n>>>>>> Un nuevo producto sera añadido a almacen!"
    end

    def send_notification
        puts "\n\n\n>>>>>> Un nuevo producto fue añadido a almacen: #{self.title} - $#{self.total} USD"
    end

    def total
        # el precio esta guardado en centavos
        self.price / 100
    end

end
