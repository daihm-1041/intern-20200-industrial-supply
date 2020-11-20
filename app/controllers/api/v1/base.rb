module API
  module V1
    class Base < Grape::API
      mount V1::Auth
      mount V1::Users
      mount V1::Products
      # mount API::V1::AnotherResource
    end
  end
end
