def set_current_user
  session[:user_id] = Fabricate(:user).id
end

def get_current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def expect_redirect_to_sign_in_path
  expect(response).to redirect_to sign_in_path
end