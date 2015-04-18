def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
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

def it_validates_presence_of_set(*args)
  args.each { |arg| it { should validate_presence_of arg}}
end

def it_belongs_to_set(*args)
  args.each {|arg| it { should belong_to arg}}
end