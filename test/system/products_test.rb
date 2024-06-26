require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit products_url
    click_on "New product"

    fill_in "Brand", with: @product.brand
    fill_in "Description", with: @product.description
    fill_in "Kind", with: @product.kind
    fill_in "Name", with: @product.name
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "should update Product" do
    visit product_url(@product)
    click_on "Edit this product", match: :first

    fill_in "Brand", with: @product.brand
    fill_in "Description", with: @product.description
    fill_in "Kind", with: @product.kind
    fill_in "Name", with: @product.name
    click_on "Update Product"

    assert_text I18n.t('messages.saved')
    click_on "Back"
  end

  test "should destroy Product" do
    visit product_url(@product)
    click_on "Destroy this product", match: :first

    assert_text "Product was successfully destroyed"
  end
end
