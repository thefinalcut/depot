require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes shouldn't be empty" do
    product = Product.new
    assert product.invalid? 
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be > 0" do
    product = Product.new(title: "blah title", description: "whatever", image_url: "xxx.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join(';')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join(';')

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    product = Product.new(title: "blah title", description: "whatever", price: 1, image_url: image_url)
  end

  test "image url should end in jpg or png ..." do
    ok = %w{ fred.jpg fred.png fred.gif fred.JPG fred.PNG fred.GIF }
    not_ok = %w{ fred.doc fred.tiff fred.gif.xxx }

    ok.each do |file_name|
      assert new_product(file_name).valid?, "#{file_name} shouldn't be invalid"
    end

    not_ok.each do |file_name|
      assert new_product(file_name).invalid?, "#{file_name} shouldn't be valid"
    end
  end

  test "product title must be unique" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "whatever",
                          :price => 12.34,
                          :image_url => "dsds.jpg")
    assert !product.save
    assert_equal "MUST BE UNIQUE", product.errors[:title].join(';')
    
  end

  test "title must be at least 10 char long" do
    product = products(:ruby_short)
    assert !product.save
  end
    
end
