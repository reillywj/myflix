require "spec_helper"

feature "Signing In" do
  given(:alice) {Fabricate :user, password: "password"}

  scenario "with correct credentials" do
    sign_in(alice)
    expect(page).to have_content "You are signed in, enjoy!"
    expect(page).to have_content alice.full_name
  end
  
  scenario "with invalid email" do
    visit sign_in_path
    fill_in "Email", with: "some@email.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    expect(page).to have_content "Invalid credentials."
  end

  scenario "with invalid password" do
    visit sign_in_path
    fill_in "Email", with: alice.email
    fill_in "Password", with: "invalid_password"
    click_button "Sign in"
    expect(page).to have_content "Invalid credentials."
  end
end