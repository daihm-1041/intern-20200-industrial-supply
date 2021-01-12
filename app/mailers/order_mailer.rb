class OrderMailer < ApplicationMailer
  def send_order_email order
    @order = order
    @user = @order.user
    mail to: @user.email, subject: @order.name_receiver
  end

  def send_notification_to_admin order, admin
    @order = order
    @admin = Array admin
    @admin.each do |ad|
      mail to: ad.email, subject: @order.id.to_s
    end
  end

  def order_errors order
    @user = order.user
    mail to: @user.email, subject: t(".fail_order")
  end
end
