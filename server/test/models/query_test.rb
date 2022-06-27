require "test_helper"

class QueryTest < ActiveSupport::TestCase
  test "query should save" do
    query = Query.new(query_id: "kk")
    assert query.save
  end

  test "query should have UUID" do
    query = Query.new
    refute query.valid?, 'query is valid without UUID'
    assert_not_nil query.errors[:query_id], 'no validation error for query present'
  end

  test "query should have unique UUID" do
    query1 = Query.new(query_id: "1111")
    query1.save
    query2 = Query.new(query_id: "1111")
    refute query2.valid?, 'query is valid without unique UUID'
    assert_not_nil query2.errors[:query_id], 'no validation error for query2 present'
  end
end
