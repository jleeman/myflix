require 'rails_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid credit card" do
      let(:customer) { double(:customer, successful?: true) }

      before do
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes user follow inviter" do
        joe = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: joe, recipient_email: "bob@test.com")
        UserSignup.new(Fabricate.build(:user, email: "bob@test.com", password: "password", full_name: "Bob Smith")).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: "bob@test.com").first
        expect(bob.follows?(joe)).to be_truthy
      end

      it "makes inviter follow user" do
        joe = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: joe, recipient_email: "bob@test.com")
        UserSignup.new(Fabricate.build(:user, email: "bob@test.com", password: "password", full_name: "Bob Smith")).sign_up("some_stripe_token", invitation.token)
        bob = User.where(email: "bob@test.com").first
        expect(joe.follows?(bob)).to be_truthy
      end

      it "expires the invitation after acceptance" do
        joe = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: joe, recipient_email: "bob@test.com")
        UserSignup.new(Fabricate.build(:user, email: "bob@test.com", password: "password", full_name: "Bob Smith")).sign_up("some_stripe_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end

      it "sends out an email to user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "bob@test.com")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@test.com"])
      end

      it "sends email body content including users's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "bob@test.com", full_name: "Bob Smith")).sign_up("some_stripe_token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Welcome to MyFlix, Bob Smith!")
      end
    end

    context "valid personal info and declined card" do
      it "does not create new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("123123", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not create the user" do
        UserSignup.new(User.new(email: "bob@test.com")).sign_up("123123", nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).not_to receive(:customer)
        UserSignup.new(User.new(email: "bob@test.com")).sign_up("123123", nil)
      end

      it "does not send email" do
        UserSignup.new(User.new(email: "bob@test.com")).sign_up("123123", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message).to eq(nil)
      end
    end
  end
end
