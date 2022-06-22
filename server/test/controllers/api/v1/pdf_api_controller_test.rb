require "test_helper"

class Api::V1::PdfApiControllerTest < ActionDispatch::IntegrationTest
  #GET
  test "GET with auth should return success" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    get "/api/v1/pdf_api", params: {"id": ""}, headers: { "Authorization": "Bearer Token Test" }
    assert_response :success
  end

  test "GET with no auth should return access denied" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    get "/api/v1/pdf_api", params: {"id": ""}, headers: { "Authorization": "Wrong token" }
    assert_response 401
  end

  test "GET with ID should return proper query" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    @query = Query.new(id: 0, query_id: "1111-1111", status: "started")
    @query.save
    get "/api/v1/pdf_api", params: {"id": "1111-1111"}, headers: { "Authorization": "Bearer Token Test" }
    assert_match "\"query_id\":\"1111-1111\",\"rate_conf_data\":null,\"error_data\":null,", @response.body
  end

  #POST
  test "POST with auth should return success" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    post "/api/v1/pdf_api", params: {"company": "kenco"}, headers: { "Authorization": "Bearer Token Test" }
    assert_response :success
  end

  test "POST with no auth should return access denied" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    post "/api/v1/pdf_api", params: {"company": "kenco"},headers: { "Authorization": "wrong Test" }
    assert_response 401
  end

  test "POST with auth should return proper UUID" do
    @user = User.create(name:"test")
    @user.api_keys.create(token: 'Token Test')
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    post "/api/v1/pdf_api", params: {"company": "kenco"}, headers: { "Authorization": "Bearer Token Test" }
    assert_response :success
    responseData = JSON.parse(@response.body)['queryUUID']
    assert uuid_regex.match?(responseData)
  end

end
