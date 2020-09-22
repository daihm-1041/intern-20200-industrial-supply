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

  validates :name, presence: true,
            uniqueness: {case_sensitive: false},
            length: {maximum: Settings.validate.products.max_length_name}
  validates :description, presence: true,
            length: {maximum: Settings.validate.products.max_length_description}
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

  scope :by_supplier, (lambda do |brand_ids|
    where brand_id: brand_ids if brand_ids.present?
  end)

  scope :by_name, (lambda do |value|
    where("products.name LIKE '%#{value}%'") if value.present?
  end)

  scope :by_category, (lambda do |category_id|
    where(category_id: category_id) if category_id.present?
  end)

  scope :by_from_price, (lambda do |from_price|
    where("price >= ?", from_price) if from_price.present?
  end)

  scope :by_to_price, (lambda do |to_price|
    where("price <= ?", to_price) if to_price.present?
  end)

  scope :order_by_price, (lambda do |order_type|
    order(price: order_type) if order_type.present?
  end)
end
