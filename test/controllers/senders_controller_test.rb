require "test_helper"

class SendersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get senders_create_url
    assert_response :success
  end

  test "should get destroy" do
    get senders_destroy_url
    assert_response :success
  end
end
