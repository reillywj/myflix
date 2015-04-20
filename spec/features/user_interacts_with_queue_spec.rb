require "spec_helper"

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    comedies = Fabricate :category
    monk = Fabricate :video, title: "Monk", category: comedies
    south_park = Fabricate :video, title: "South Park", category: comedies
    futurama = Fabricate :video, title: "Futurama", category: comedies
    alice = Fabricate :user

    sign_in(alice)
    expect(page).to have_content alice.full_name

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    click_link "Monk"
    expect_link_not_to_be_see("+ My Queue")

    add_video_to_queue(futurama)
    add_video_to_queue(south_park)

    expect_video_to_be_in_queue futurama
    expect_video_to_be_in_queue south_park

    visit my_queue_path
    expect(page).to have_content "List Order"
    set_video_position(monk,3)
    set_video_position(futurama, 2)
    set_video_position(south_park, 1)

    click_button "Update Instant Queue"

    expect_video_position(monk, 3)
    expect_video_position(futurama, 2)
    expect_video_position(south_park, 1)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_see(link_text)
    expect(page).not_to have_content(link_text)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video,position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq("#{position}")
  end
end