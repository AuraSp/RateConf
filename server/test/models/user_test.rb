require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user should save" do
    user = User.new(name: "kk")
    assert user.save
  end

  test "user should have name" do
    user = User.new
    refute user.valid?, 'user is valid without name'
    assert_not_nil user.errors[:name], 'no validation error for user present'
  end

  test "user should have unique name" do
    user1 = User.new(name: "1")
    user1.save
    user2 = User.new(name: "1")
    refute user2.valid?, 'user is valid without unique name'
    assert_not_nil user2.errors[:query_id], 'no validation error for user2 present'
  end
end