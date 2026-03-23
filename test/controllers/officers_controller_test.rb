require "test_helper"

class OfficersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @officer = officers(:one)
  end

  test "should get index" do
    get officers_url, as: :json
    assert_response :success
  end

  test "should create officer" do
    assert_difference("Officer.count") do
      post officers_url, params: { officer: { bn: @officer.bn, incident: @officer.incident, name: @officer.name } }, as: :json
    end

    assert_response :created
  end

  test "should show officer" do
    get officer_url(@officer), as: :json
    assert_response :success
  end

  test "should update officer" do
    patch officer_url(@officer), params: { officer: { bn: @officer.bn, incident: @officer.incident, name: @officer.name } }, as: :json
    assert_response :success
  end

  test "should destroy officer" do
    assert_difference("Officer.count", -1) do
      delete officer_url(@officer), as: :json
    end

    assert_response :no_content
  end
end
