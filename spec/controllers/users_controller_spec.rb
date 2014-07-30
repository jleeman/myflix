require 'rails_helper.rb'

describe UsersController do

  describe "GET new" do
    it "sets new @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    let (:user) { Fabricate(:user) }

    context "successful user sign up" do

      it "redirects to videos_path" do
        result = double(:sign_up_result, successful?: true)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to videos_path
      end
    end

    context "failed user signup" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Error Message.")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        result = double(:sign_up_result, successful?: false, error_message: "Error Message.")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123123'
        expect(flash[:danger]).to eq("Error Message.")
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      joe = Fabricate(:user)
      get :show, id: joe.id
      expect(assigns(:user)).to eq(joe)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders :new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @ user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: '123'
      expect(response).to redirect_to expired_token_path
    end
  end
end
