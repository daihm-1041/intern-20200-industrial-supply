module API
  module V1
    class Products < Grape::API
      include API::V1::Defaults
      prefix "api"
      version "v1", using: :path
      format :json

      before {authenticate_user!}

      resource :products do
        desc "Return all producs"
        get "", root: :products do
          products = Product.all
          present products
        end

        desc "Return a products"
        params do
          requires :id, type: String, desc: "ID of the Product"
        end

        get ":id", root: "product" do
          product = Product.find params[:id]
          present product, with: API::Entities::Product
        end

        desc "Create a product"
        params do
          requires :name, type: String, desc: "Name of the product"
          requires :description, type: String, desc: "Description of product"
          requires :price, type: Integer, desc: "Status of the product"
          requires :inventory_number, type: Integer, desc: "number of product"
          requires :category_id, type: Integer, desc: "caterory_id of product"
          requires :supplier_id, type: Integer, desc: "suppier_id of product"
        end

        post do
          product = Product.new name: params[:name],
                            description: params[:description],
                            price: params[:price],
                            inventory_number: params[:inventory_number],
                            category_id: params[:category_id],
                            supplier_id: params[:supplier_id]
          present product if product.save
        end

        desc "Update a product"
        params do
          requires :id, type: String, desc: "ID of the product"
        end

        patch ":id" do
          product = Product.find_by id: params[:id]
          product_params = {
            name: params[:name] || product.name,
            description: params[:description] || product.description,
            price: params[:price] || product.price,
            inventory_number: ( params[:inventory_number] ||
              product.inventory_number),
            category_id: params[:category_id] || product.category_id,
            supplier_id: params[:supplier_id] || product.supplier_id
          }
          present product if product.update product_params
        end

        desc "Delete a product"
        params do
          requires :id, type: String, desc: "ID of the product"
        end

        delete ":id" do
          product = Product.find_by id: params[:id]
          present Product.all if product.destroy
        end
      end
    end
  end
end
