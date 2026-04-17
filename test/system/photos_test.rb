require 'application_system_test_case'

class PhotoTest < ApplicationSystemTestCase
  setup do
    @gallery = galleries(:first)
    @photo = photos(:first)
  end

  test 'visiting a photo' do
    visit gallery_path(@gallery)
    click_link @photo.id

    assert_selector 'h1', text: @photo.title
  end
end
