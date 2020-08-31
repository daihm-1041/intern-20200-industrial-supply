class Supplier < ApplicationRecord
  has_many :products, dependent: :destroy
end
