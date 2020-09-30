class Order < ApplicationRecord
  PERMIT_CREATE_ATTRIBUTES = [:user_id, :name_receiver, :address_receiver,
                              :phone_receiver, :type, :status,
                              order_details_attributes: [:id, :order_id,
                                                       :product_id, :quantity,
                                                       :amount, :_destroy]]
                             .freeze
  PERMIT_UPDATE_ATTRIBUTES = [:status].freeze

  belongs_to :user
  has_many :order_details, dependent: :destroy

  accepts_nested_attributes_for :order_details, allow_destroy: true

  enum status: {pending: 3, handing: 2, resolved: 1}, _suffix: true

  validates :name_receiver, :address_receiver, :phone_receiver, :status,
            presence: true
  validates :status, inclusion: {in: %w(pending handing resolved)}

  default_scope{order(id: :desc)}

  def total_quantity
    order_details.to_a.sum(&:quantity)
  end

  def total_amount
    order_details.to_a.sum(&:amount)
  end
end
