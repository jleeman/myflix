require "rails_helper.rb"

feature "user invites friend" do
  scenario "user successfully invites friend and invitation is accepted" do
    joe = Fabricate(:user)
    sign_in(joe)

    invite_a_friend
    friend_accepts_invitation

    # solution had login step after registration
    # left auto-login code in controller after registration
    # fill_in "Email Address", with: "sarah@test.com"
    # fill_in "Password", with: "password"
    # click_button "Sign In"

    friend_should_follow(joe)
    inviter_should_follow_friend(joe)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Sarah Smith"
    fill_in "Friend's Email Address", with: "sarah@test.com"
    fill_in "Message", with: "Please join!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "sarah@test.com"
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Sarah Smith"
    click_button "Sign Up"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content "Sarah Smith"
  end
end
