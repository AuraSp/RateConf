require "test_helper"

class Api::V1::PdfApiControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #GET
  test "GET auth and id should success" do
    get "/api/v1/pdf_api", params: {"id": ""}, headers: { "Authorization": "Token Test" }
    assert_response :success
  end

  test "GET no auth should fail" do
    get "/api/v1/pdf_api", params: {"id": ""}, headers: { "Authorization": "wrong test" }
    assert_response 401
  end

  #POST
  test "POST auth and id should success" do
    post "/api/v1/pdf_api", params: {"company": "kenco"}, headers: { "Authorization": "Token Test" }
    assert_response :success
  end

  test "POST no auth should fail" do
    post "/api/v1/pdf_api", params: {"company": "kenco"},headers: { "Authorization": "wrong test" }
    assert_response 401
  end

end
