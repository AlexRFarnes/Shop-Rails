# La clase debe heredar del ActiveModel::Validator
class ProductValidator < ActiveModel::Validator
    # Debe sobreescribir el metodo validate de manera obligatoria
    # Todas las validaciones deben ir dentro del metodo validate
    # Por convencion el parametro se llama record
    def validate(record)
        # if record.stock < 0
        #     record.errors.add(:stock, "El stock no puede ser un valor negativo.")
        # end
        self.validate_stock(record)
    end

    def validate_stock(record)
        if record.stock < 0
            record.errors.add(:stock, "El stock no puede ser un valor negativo.")
        end
    end

end