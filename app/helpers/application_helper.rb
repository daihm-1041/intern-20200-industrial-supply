module ApplicationHelper
  def option_role_select
    User.roles.keys.map do |key|
      [I18n.t("admins.users.form.#{key}"), key]
    end
  end

  def option_role_select_search
    User.roles.map do |value, key|
      [I18n.t("admins.users.form_search.#{value}"), key]
    end
  end

  def option_status_order_update
    Order.statuses.map do |value, _key|
      [I18n.t("admins.orders.form_search.#{value}"), value]
    end
  end

  def option_status_order_search
    Order.statuses.map do |value, key|
      [I18n.t("admins.orders.form_search.#{value}"), key]
    end
  end
end
