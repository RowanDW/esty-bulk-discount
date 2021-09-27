require 'rails_helper'

RSpec.describe "the bulk discounts show page" do

  before :each do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)

    @discounts = create_list(:bulk_discount, 3, merchant: @merch1)
    @discount2 = create(:bulk_discount, merchant: @merch2, percentage: 80, quantity: 80)
  end

  it "displays the discount attributes" do
    visit merchant_bulk_discount_path(@merch1, @discounts[0])

    expect(page).to have_content("Discount #{@discounts[0].id}")
    expect(page).to have_content("#{@discounts[0].percentage}% off ")
    expect(page).to have_content("#{@discounts[0].quantity} items")

    expect(page).to_not have_content("Discount #{@discounts[1].id}: ")
    expect(page).to_not have_content("Discount #{@discount2.id}: ")
  end

  it "has a button to edit the discount" do
    visit merchant_bulk_discount_path(@merch1, @discounts[0])

    expect(page).to have_button("Update Discount")

    click_button "Update Discount"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merch1, @discounts[0]))
  end
end
