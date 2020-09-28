class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :amount, presence: true
  validate :validate_quantity

  after_save :update_inventory_number

  def validate_quantity
    errors.add(:quantity, :errors) if quantity > product.inventory_number
  end

  private

  def update_inventory_number
    product_quantity = product.inventory_number - quantity
    product.update inventory_number: product_quantity
  end
end
