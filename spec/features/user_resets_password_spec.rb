require "rails_helper.rb"

feature "user resets password" do
  scenario "successfully resets password" do
    joe = Fabricate(:user, password: "old_password", email: "joe@test.com")

    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: joe.email
    click_button "Send Email"

    open_email(joe.email)
    expect(current_email).to have_content "Please click on the link below to reset your password:"
    current_email.click_link "Reset My Password"

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email", with: joe.email
    fill_in "Password", with: "new_password"
    click_button "Sign In"
    expect(page).to have_content("Welcome, #{joe.full_name}")
  end
end
