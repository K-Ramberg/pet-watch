require "test_helper"

class AnimalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @animal = animals(:one)
  end

  test "should get index" do
    get account_animals_url(@animal.account)
    assert_response :success
  end

  test "should get new" do
    get new_account_animal_url(@animal.account)
    assert_response :success
  end

  test "should create animal" do
    assert_difference("Animal.count") do
      post account_animals_url(@animal.account), params: { animal: { account_id: @animal.account_id, additional_hour_fee: @animal.additional_hour_fee, name: @animal.name } }
    end

    assert_redirected_to account_animals_url(@animal.account)
  end

  test "should show animal" do
    get animal_url(@animal)
    assert_response :success
  end

  test "should get edit" do
    get edit_animal_url(@animal)
    assert_response :success
  end

  test "should update animal" do
    patch animal_url(@animal), params: { animal: { account_id: @animal.account_id, additional_hour_fee: @animal.additional_hour_fee, name: @animal.name } }
    assert_redirected_to animal_url(@animal)
  end

  test "should destroy animal" do
    assert_difference("Animal.count", -1) do
      delete animal_url(@animal)
    end

    assert_redirected_to account_animals_url(@animal.account)
  end
end
