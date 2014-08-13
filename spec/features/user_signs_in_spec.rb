require 'rails_helper.rb'

feature "user signs in" do
  scenario "with valid email & password" do
    john = Fabricate(:user)
    sign_in(john)
    expect(page).to have_content john.full_name
  end

  scenario "with deactivated user" do
    john = Fabricate(:user, active: false)
    sign_in(john)
    expect(page).not_to have_content john.full_name
    expect(page).to have_content("Your account has been deactivated, please contact customer service.")
  end
end
