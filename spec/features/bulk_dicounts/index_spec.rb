require 'rails_helper'

RSpec.describe "the bulk discounts index page" do

  before :each do
    @merch1 = create(:merchant)
    @merch2 = create(:merchant)

    @discounts = create_list(:bulk_discount, 3, merchant: @merch1)
    @discount2 = create(:bulk_discount, merchant: @merch2, percentage: 80, quantity: 80)
  end

  it "shows each discount and their attributes" do
    visit merchants_bulk_discounts_index_path(@merch)

    @discounts.each do |discount|
      within("#discount-#{discount.id}") do
        expect(page).to have_content("Discount: #{discount.id}")
        expect(page).to have_content("#{discount.percentage}%")
        expect(page).to have_content("#{discount.quantity} items")
      end
    end

    expect(page).to have_content("Discount: #{@discount2.id}")
    expect(page).to have_content("#{@discount2.percentage}%")
    expect(page).to have_content("#{@discount2.quantity} items")
  end

  it "links each discount to its show page" do
    visit merchants_bulk_discounts_index_path(@merch)

    within("#discount-#{@discounts[0].id}") do
      expect(page).to have_link(@discounts[0].id)
      click_link @discounts[0].id
    end

    expect(current_path).to eq(merchants_bulk_discounts_path(@merch, @discounts[0]))
  end
end
