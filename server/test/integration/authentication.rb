# def test_access_granted_from_xml
#     authorization = ActionController::HttpAuthentication::Token.encode_credentials(users(:dhh).token)
  
#     get "/pdf/index", headers: { 'HTTP_AUTHORIZATION' => authorization }
  
#     assert_equal 200, status

#   end
