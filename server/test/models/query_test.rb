require "test_helper"

class QueryTest < ActiveSupport::TestCase
  test "query should save" do
    query = Query.new
    assert query.save
  end
end
