class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcome to MyFlix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Reset your password"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: "info@myflix.com", subject: "Join MyFlix!", message: invitation.message
  end
end
