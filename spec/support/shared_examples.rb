shared_examples "require_sign_in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect_redirect_to_sign_in_path
  end
end