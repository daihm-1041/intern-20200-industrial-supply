require "rails_helper"

RSpec.describe Product, type: :model do
  subject {product}

  let!(:supplier) { FactoryBot.create :supplier }
  let!(:category) { FactoryBot.create :category }
  let!(:product) do
    FactoryBot.build :product,
      supplier_id: supplier.id, category_id: category.id
  end
  let!(:r1) do
    FactoryBot.create :product, name: "may khoan",
    price: 100000, supplier_id: supplier.id, category_id: category.id
  end

  let!(:r2) do
    FactoryBot.create :product, name: "may khoan2",
    price: 170000, supplier_id: supplier.id, category_id: category.id
  end

  let!(:r3) do
    FactoryBot.create :product, name: "bua ta",
    price: 120000, supplier_id: supplier.id, category_id: category.id
  end

  let!(:r4) do
    FactoryBot.create :product, name: "bua ta nho",
    price: 190000, supplier_id: supplier.id, category_id: category.id
  end

  describe "associations" do
    it "belong to category" do
      is_expected.to belong_to :category
    end

    it "belong to supplier" do
      is_expected.to belong_to :supplier
    end

    it "has many image" do
      is_expected.to have_many :images
    end

    it "has many order_details" do
      is_expected.to have_many :order_details
    end

    it "has many comments" do
      is_expected.to have_many :comments
    end
  end

  describe "Delegate" do
    it do
      is_expected.to delegate_method(:name).to(:category).with_prefix(true)
    end
  end

  describe "Validations" do
    before {product.save}

    it "valid all field" do
      expect(subject).to be_valid
    end

    [:name, :description,:inventory_number, :price].each do |field|
      it do
        is_expected.to validate_presence_of(field)
      end
    end

    it do
      is_expected.to validate_length_of(:name)
        .is_at_most(Settings.validate.products.max_length_name)
    end

    it do
      is_expected.to validate_length_of(:description)
        .is_at_most(Settings.validate.products.max_length_description)
    end

    it do
      is_expected.to validate_numericality_of(:inventory_number)
    end

    it do
      is_expected.to validate_numericality_of(:price)
    end
  end

  describe ".by_name" do
    context "when valid param" do
      it "return record" do
        expect(Product.by_name(r1.name).pluck(:id)).to eq [r1.id, r2.id]
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_name(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end

  describe ".by_supplier" do
    context "when valid param" do
      it "return record" do
        expect(Product.by_supplier(r1.supplier_id).first).to eq r1
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_supplier(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end

  describe ".by_category" do
    context "when valid param" do
      it "return record" do
        expect(Product.by_category(r1.category_id).first).to eq r1
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_category(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end

  describe ".by_from_price" do
    context "when valid param" do
      it "return record" do
        expect(Product.by_from_price(r2.price)).to eq [r2, r4]
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_from_price(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end

  describe ".by_to_price" do
    context "when valid param" do
      it "return record" do
        expect(Product.by_to_price(r3.price)).to eq [r1, r3]
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_to_price(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end

  describe ".filter_by_ids" do
    context "when valid param" do
      it "return record" do
        expect(Product.filter_by_ids(r1).pluck(:id)).to eq [r1.id]
      end
    end

    context "when nil param" do
      it "return all record" do
        expect(Product.by_to_price(nil)).to eq [r1, r2, r3, r4]
      end
    end
  end
end
