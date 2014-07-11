require 'rails_helper.rb'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation to new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@test.com", message: "Check it out!" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@test.com", message: "Check it out!" }
        expect(Invitation.count).to eq(1)
      end

      it "sends email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@test.com", message: "Check it out!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@test.com"])
      end

      it "sets flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@test.com", message: "Check it out!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "renders :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@test.com", message: "Check it out!" }
        expect(response).to render_template :new
      end

      it "does not create invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@test.com", message: "Check it out!" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@test.com", message: "Check it out!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash danger message" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@test.com", message: "Check it out!" }
        expect(flash[:danger]).to be_present
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@test.com", message: "Check it out!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
