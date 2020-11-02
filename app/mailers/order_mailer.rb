class OrderMailer < ApplicationMailer
  def send_order_email order
    @order = order
    @user = @order.user
    mail to: @user.email, subject: @order.name_receiver
  end
end
