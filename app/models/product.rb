class Product < ApplicationRecord
  belongs_to :category
  belongs_to :supplier
  has_many :images, dependent: :destroy
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_many :comments, dependent: :destroy
end
