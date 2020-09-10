# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Category.create!(detail: "loai 1")
Supplier.create!(name: "nha cung cap 1", address: "ha noi", phone_number: "0101010101", detail: "day la nha cung cap san pham so 1 viet nam", email: "ncc@gmail.com" )

30.time do |n|
  name = "San pham #{n}"
  description = "day la san pham #{n}"
  price = 1000000
  inventory_number = 100
  category_id = 1
  supplier_id = 1
  Product.create!( name, description, price, inventory_number, category_id, supplier_id )
end

30.time do |n|
product_id = n
image_data = "https://www.google.com/url?sa=i&url=http%3A%2F%2Ftrangvangtructuyen.vn%2Fc3%2Fvat-tu-cong-nghiep.html&psig=AOvVaw0rANHTAfZzUnMystq5WE2m&ust=1599547188879000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOCdgfK31usCFQAAAAAdAAAAABAD"
Image.create!()
end
