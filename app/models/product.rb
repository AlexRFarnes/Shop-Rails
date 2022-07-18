# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string
#  price      :decimal(10, 2)   default(0.0)
#  stock      :integer          default(0)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
end
