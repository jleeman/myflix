require 'rails_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_14OGrf4P9PjYyYg2BeC0wjvd",
      "created" => 1407279427,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14OGrf4P9PjYyYg2ld8nOnx8",
          "object" => "charge",
          "created" => 1407279427,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14OGre4P9PjYyYg2jXPiIISP",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 9,
            "exp_year" => 2014,
            "fingerprint" => "4yWzT11HwdFfDH85",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4XLYG7sbDldGK4"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14OGrf4P9PjYyYg2ld8nOnx8/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_14OGrf4P9PjYyYg2Lo6yYa1Q",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4XLYG7sbDldGK4",
          "invoice" => "in_14OGrf4P9PjYyYg2dzrKXB4p",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4XLYC0fUKL6uEQ"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded" do
    VCR.use_cassette("payment with webhook from stripe") do
      post "/stripe_events", event_data
    end
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user" do
    bob = Fabricate(:user, customer_token: "cus_4XLYG7sbDldGK4")
    VCR.use_cassette("creates the payment associated with user") do
      post "/stripe_events", event_data
    end
    expect(Payment.first.user).to eq(bob)
  end

  it "creates the payment with the amount" do
    bob = Fabricate(:user, customer_token: "cus_4XLYG7sbDldGK4")
    VCR.use_cassette("creates the payment associated with user") do
      post "/stripe_events", event_data
    end
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id" do
    bob = Fabricate(:user, customer_token: "cus_4XLYG7sbDldGK4")
    VCR.use_cassette("creates the payment associated with user") do
      post "/stripe_events", event_data
    end
    expect(Payment.first.reference_id).to eq("ch_14OGrf4P9PjYyYg2ld8nOnx8")
  end

end
