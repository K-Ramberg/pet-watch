require "application_system_test_case"

class AnimalsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one)
    @animal = animals(:one)
  end

  test "visiting the index" do
    visit account_animals_url(@account)
    assert_selector "h1", text: /Animals/
  end

  test "animal form creates animal when valid" do
    visit account_animals_url(@account)
    click_on "Create new animal"

    assert_selector "h1", text: "New Animal"
    fill_in "Name", with: "Rex"
    fill_in "Additional hour fee", with: "12.50"
    click_on "Create Animal"

    assert_text "Animal was successfully created"
    assert_current_path account_animals_path(@account)
    assert_text "Rex"
  end

  test "animal form shows validation errors when invalid" do
    visit new_account_animal_url(@account)

    fill_in "Name", with: ""
    fill_in "Additional hour fee", with: ""
    click_on "Create Animal"

    assert_text "error"
    assert_selector "h1", text: "New Animal"
  end

  test "animal form updates animal when valid" do
    visit animal_url(@animal)
    click_on "Edit this animal", match: :first

    assert_selector "h1", text: /Editing/
    fill_in "Name", with: "Updated Pet"
    fill_in "Additional hour fee", with: "15.00"
    click_on "Update Animal"

    assert_text "Animal was successfully updated"
    assert_text "Updated Pet"
  end

  test "animal form shows validation errors on edit when invalid" do
    visit edit_animal_url(@animal)

    fill_in "Name", with: ""
    click_on "Update Animal"

    assert_text "error"
    assert_selector "h1", text: /Editing/
  end

  test "should destroy Animal" do
    visit animal_url(@animal)
    click_on "Destroy this animal", match: :first

    assert_text "Animal was successfully destroyed"
  end
end
