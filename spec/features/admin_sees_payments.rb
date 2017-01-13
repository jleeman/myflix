require 'rails_helper'

feature "Admin sees payments" do
  background do
    bob = Fabricate(:user, full_name: "Bob Smith", email: "bob@test.com")
    Fabricate(:payment, amount: 999, user: bob)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Bob Smith")
    expect(page).to have_content("bob@test.com")
  end
  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Bob Smith")
    expect(page).not_to have_content("bob@test.com")
    expect(page).to have_content("You do not have access.")
  end
end
