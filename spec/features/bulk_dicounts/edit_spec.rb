require 'rails_helper'

RSpec.describe "the bulk discounts index page" do

  before :each do
    @merch = create(:merchant)

    @discount = create(:bulk_discount, merchant: @merch1, percentage: 4, quantity: 4)
  end

  it "has a pre-populated form to edit the discount" do
    visit merchant_bulk_discounts_path(@merch)
    expect(page).to have_content("4% off ")
    expect(page).to have_content("4 items")

    visit edit_merchant_bulk_discount_path(@merch, @discount)

    expect(page).to have_field("Percentage", with: @discount.percentage)
    expect(page).to have_field("Quantity", with: @discount.quantity)

    fill_in "Percentage", with: 20
    fill_in "Quantity", with: 12

    click_button "Submit"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merch))
    expect(page).to have_content("Bulk discount updated successfully")
    expect(page).to have_content("20% off ")
    expect(page).to have_content("12 items")
  end

  it "displays an error message" do
    visit edit_merchant_bulk_discount_path(@merch, @discount)

    expect(page).to have_field("Percentage", with: @discount.percentage)
    expect(page).to have_field("Quantity", with: @discount.quantity)

    fill_in "Percentage", with: ""
    fill_in "Quantity", with: 12

    click_button "Submit"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merch, @discount))
    expect(page).to have_content("Error: invalid discount, please try again")
    expect(page).to have_field("Percentage", with: @discount.percentage)
    expect(page).to have_field("Quantity", with: @discount.quantity)
  end
end
