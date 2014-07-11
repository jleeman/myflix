class InvitationsController < ApplicationController
before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    # note use of merge here to associate foreign key of inviter id
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.delay.send_invitation(@invitation)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}!"
      redirect_to new_invitation_path
    else
      flash[:danger] = "Please check the fields below."
      render :new
    end
  end

  private

  def invitation_params
      params.require(:invitation).permit(:inviter_id, :recipient_name, :recipient_email, :message)
  end
end
