def set_current_user
  session[:user_id] = Fabricate(:user).id
end

def get_current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end