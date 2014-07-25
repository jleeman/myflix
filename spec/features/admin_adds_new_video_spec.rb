require "rails_helper.rb"

feature "admin adds new video" do
  scenario "user successfully adds a new video" do
    admin = Fabricate(:admin)
    comedies = Fabricate(:category, name: "Comedies")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Monk"
    select "Comedies", from: "Category"
    fill_in "Description", with: "Detective Comedy"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.test.com/video.mp4"

    click_button "Add Video"

    sign_out
    sign_in

    video = Video.first
    visit video_path(video)
    expect(page).to have_selector("img[src='/uploads/video/large_cover/#{video.id}/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.test.com/video.mp4']")
  end
end
