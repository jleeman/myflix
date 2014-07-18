class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added #{@video.title}."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Please review required fields."
      render :new
    end
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You do not have access."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
  end
end
