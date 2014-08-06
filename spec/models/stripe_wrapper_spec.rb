require 'rails_helper'

describe StripeWrapper do
  let(:valid_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 3,
        :exp_year => 2018,
        :cvc => 123
      }
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 3,
        :exp_year => 2018,
        :cvc => 123
      }
    ).id
  end

  describe StripeWrapper::Charge do

    context "with valid card" do
      it "charges the card successfully" do
        VCR.use_cassette('create charge with valid card') do
          response = StripeWrapper::Charge.create(amount: 300, card: valid_card_token)
          expect(response).to be_successful
        end
      end
    end

    context "with invalid card" do
      let(:response) do
        VCR.use_cassette('create charge with invalid card') do
          StripeWrapper::Charge.create(amount: 300, card: declined_card_token)
        end
      end

      it "does not charge the card" do
        expect(response).not_to be_successful
      end

      it "contains an error message" do
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates customer with valid card" do
        joe = Fabricate(:user)
        response = VCR.use_cassette('creates customer with valid card') do
          StripeWrapper::Customer.create(user: joe, card: valid_card_token)
        end
        expect(response).to be_successful
      end

      it "does not create customer with invalid card" do
        joe = Fabricate(:user)
        response = VCR.use_cassette('creates customer with declined card') do
          StripeWrapper::Customer.create(user: joe, card: declined_card_token)
        end
        expect(response).not_to be_successful
      end

      it "returns error message for declined card" do
        joe = Fabricate(:user)
        response = VCR.use_cassette('returns error message for declined card') do
          StripeWrapper::Customer.create(user: joe, card: declined_card_token)
        end
        expect(response.error_message).to eq("Your card was declined.")
      end

      it "returns the customer token for a valid card" do
        joe = Fabricate(:user)
        response = VCR.use_cassette('returns the customer token for a valid card') do
          StripeWrapper::Customer.create(user: joe, card: valid_card_token)
        end
        expect(response.customer_token).to be_present
      end
    end
  end
end
