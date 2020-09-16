class Product < ApplicationRecord
  PERMIT_ATTRIBUTES = [:name, :category_id, :supplier_id, :price,
                       :description, :inventory_number,
                       images_attributes: [:id, :image_data, :_destroy]]
                      .freeze
  belongs_to :category
  belongs_to :supplier
  has_many :images, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_many :comments, dependent: :destroy

  delegate :name, to: :category, prefix: true
  delegate :name, to: :supplier, prefix: true

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, :description, presence: true,
              uniqueness: {case_sensitive: false}
  validates :inventory_number, presence: true,
    numericality: {
      less_than_or_equal_to: Settings.admins.products.max_inventory,
      greater_than_or_equal_to: Settings.admins.products.min_inventory,
      only_integer: true
    }
  validates :price, presence: true,
    numericality: {
      less_than_or_equal_to: Settings.admins.products.max_price,
      greater_than_or_equal_to: Settings.admins.products.min_price,
      only_integer: true
    }
end
