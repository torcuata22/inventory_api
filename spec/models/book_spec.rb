require 'pry'

RSpec.describe User, type: :model do
  describe 'validations' do
    it "is invalid without a title" do
      book = build(:book, title: nil)
      expect(book).to_not be_valid
    end

    it "is invalid without a title" do
      book = build(:book, title: nil)
      expect(book).to_not be_valid
    end

    it "is invalid without an author" do
      book = build(:book, author: nil)
      expect(book).to_not be_valid
    end

    it "is invalid without a description" do
      book = build(:book, description: nil)
      expect(book).to_not be_valid
    end

    it "is invalid without a description" do
      book = build(:book, description: nil)
      expect(book).to_not be_valid
    end

    it "is invalid without a publication_details" do
      book = build(:book, publication_details: nil)
      expect(book).to_not be_valid
    end
  end


  describe "associations" do

    it "belongs to many stores" do
      association = Book.reflect_on_association(:stores)
      puts "Book associations: #{Book.reflect_on_association(:stores)}"
      expect(association.macro).to eq :has_and_belongs_to_many
    end


    it "belongs to store_books" do
      # binding.pry
      association = Book.reflect_on_association(:store_books)
      puts "Association: #{association}"
      expect(association.macro).to eq :has_many
    end

    it "has many shipment items" do
      association = Book.reflect_on_association(:shipment_items)
      puts "Association: #{association}"
      expect(association.macro).to eq :has_many
    end

    it "has many shipments through shipment items" do
      association = Book.reflect_on_association(:shipments)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :shipment_items
    end
  end
end
