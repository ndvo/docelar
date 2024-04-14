require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: random_product }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { brand: @product.brand, description: @product.description, kind: @product.kind, name: @product.name } }
    assert_redirected_to product_url(@product)
  end

  test "should not destroy product wih purchases" do
    assert_difference("Product.count", 0) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(products(:with_no_purchases))
    end

    assert_redirected_to products_url
  end

  private

  def random_product
    {
      name: Faker::Commerce.unique.product_name,
      description: Faker::Marketing.buzzwords,
      brand: Faker::Commerce.brand,
      kind: Faker::Commerce.material,
    }
  end
end
