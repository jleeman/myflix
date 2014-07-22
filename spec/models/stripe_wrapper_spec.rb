require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    before do
        StripeWrapper::Charge.set_api_key
    end

    let(:token) do
        Stripe::Token.create(
          :card => {
            :number => card_number,
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => 123
          }
        ).id
    end

    describe ".create" do
    end

    context "with valid card" do
      let(:card_number) { '4242424242424242' }

      it "charges the card successfully" do
        response = StripeWrapper::Charge.create(amount: 300, card: token)
        expect(response).to be_successful
      end
    end


    context "with invalid card" do
      let(:card_number) { '4000000000000002' }

      let(:response) do
        StripeWrapper::Charge.create(amount: 300, card: token)
      end

      it "does not charge the card" do
        expect(response).not_to be_successful
      end

      it "contains an error message" do
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
