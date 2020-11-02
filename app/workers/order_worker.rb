class OrderWorker
  include Sidekiq::Worker

  def perform order_id
    @order = Order.find order_id
    return if @order.blank?

    OrderMailer.send_order_email(@order).deliver_now
  end
end
