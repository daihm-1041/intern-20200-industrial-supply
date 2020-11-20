module API
  module Entities
    class Product < Grape::Entity
      expose :name
      expose :description
      expose :price
      expose :inventory_number
      expose :supplier_id
      expose :category_id
    end
  end
end
