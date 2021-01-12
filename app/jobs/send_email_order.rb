class SendEmailOrder < ApplicationJob
  queue_as :default

  def perform order_id
    ActiveRecord::Base.Transaction do
      @order = Order.find order_id
      @admin = User.filter_by_role Settings.admin
      OrderMailer.send_notification_to_admin(@order, @admin).deliver_now
    end
  rescue StandardError => e
    OrderMailer.order_errors(@order).deliver_now
    raise e
  end
end
