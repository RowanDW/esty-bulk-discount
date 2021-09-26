require 'rails_helper'

RSpec.describe "the bulk discounts new page" do

  before :each do
    @merch1 = create(:merchant)
  end

  it "has a form to create a new discount" do
    visit new_merchant_bulk_discount_path(@merch1)

    expect(page).to have_field("Percentage")
    expect(page).to have_field("Quantity")

    fill_in "Percentage", with: 20
    fill_in "Quantity", with: 12

    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merch1))
    expect(page).to have_content("Bulk discount created successfully")
    expect(page).to have_content("20% off ")
    expect(page).to have_content("12 items")
  end

  it "displays an error message if invalid submission" do
    visit new_merchant_bulk_discount_path(@merch1)

    expect(page).to have_field("Percentage")
    expect(page).to have_field("Quantity")

    fill_in "Percentage", with: 20

    click_button "Submit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merch1))
    expect(page).to have_content("Error: please fill in all fields")
  end
end
