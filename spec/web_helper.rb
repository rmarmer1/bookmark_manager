def create_a_new_link
  visit('/links/new')
  fill_in('url', with: 'http://www.makersacademy.com/')
  fill_in('title', with: 'Makers Academy')
  fill_in('tags', with: 'coding')
  click_button 'Create Link'
end

def register_and_sign_in
  visit('/')
  fill_in('name', with: 'Cameron')
  fill_in('password', with: 'password')
  fill_in('password_confirmation', with: 'password')
  fill_in('email', with: 'cameron@gmail.com')
  click_button('Register')
end

def create_user 
  User.create(email: 'user@example.com',
      password: 'secret1234',
      password_confirmation: 'secret1234')
end

def sign_in(email:, password:)
    visit '/sessions/new'
    fill_in :email, with: email
    fill_in :password, with: password
    click_button 'Sign in'
end