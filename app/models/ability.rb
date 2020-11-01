class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Product, Image, Category]

    return if user.blank?

    can :manage, :all if user.role_admin?
    can %i(read update destroy), User, id: user.id
    can :create, [Order, OrderDetail]
    can :read, Order, user_id: user.id

    can :read, OrderDetail do |k|
      user.orders.pluck(:id).include? k.order_id
    end
  end
end
