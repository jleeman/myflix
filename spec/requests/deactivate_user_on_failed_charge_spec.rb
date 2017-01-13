require 'rails_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_14R8e24P9PjYyYg2oLi7H2Ww",
      "created"=> 1407962814,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_14R8e24P9PjYyYg2sAfeN77I",
          "object"=> "charge",
          "created"=> 1407962814,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_14R8bo4P9PjYyYg26h2t94Jx",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 8,
            "exp_year"=> 2024,
            "fingerprint"=> "w2rjXJnmaKS6tecq",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "customer"=> "cus_4XNMFUiV5U7k4B"
          },
          "captured"=> false,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_14R8e24P9PjYyYg2sAfeN77I/refunds",
            "data"=> []
          },
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_4XNMFUiV5U7k4B",
          "invoice"=> nil,
          "description"=> "Failed Charge",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> nil,
          "receipt_email"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_4aJGgFKauiXmoO"
    }
  end

  it "deactivates a user with webhook data from strip for charge failed" do
    joe = Fabricate(:user, customer_token: "cus_4XNMFUiV5U7k4B")
    post "/stripe_events", event_data
    expect(joe.reload).not_to be_active
  end
end
