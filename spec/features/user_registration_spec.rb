feature 'Adding new users' do
  scenario 'User count increments by 1 when user registers' do
    expect{register_and_sign_in}.to change{User.all.length}.by 1
  end

  scenario 'Displays welcome message for newly registered users' do
    register_and_sign_in
    expect(page).to have_content('Welcome, Cameron')
  end

  scenario 'Email address submitted is the same as the one recorded in the database' do
    register_and_sign_in
    expect(User.first.email).to eq "cameron@gmail.com"
  end

  scenario "User can't sign up without an email address" do
    visit('/')
    fill_in('name', with: 'Cameron')
    fill_in('password', with: 'password')
    fill_in('password_test', with: 'password')
    fill_in('email', with: '')
    click_button('Register')
    expect(User.first).to be_nil
    expect(current_path).to eq('/')
    expect(page).to have_content('Email must not be blank')
  end

  scenario "User-provided email must be properly formatted" do
    visit('/')
    fill_in('name', with: 'Cameron')
    fill_in('password', with: 'password')
    fill_in('password_test', with: 'password')
    fill_in('email', with: 'invalid@email')
    click_button('Register')
    expect(User.first).to be_nil
  end

  scenario 'Different passwords do not create a user' do
    visit('/')
    fill_in('name', with: 'Cameron')
    fill_in('password', with: 'password')
    fill_in('password_test', with: 'not_the_same_password')
    fill_in('email', with: 'cameron@gmail.com')
    click_button('Register')
    expect(User.first).to be_nil
  end

  scenario 'User can\'t register twice in a row' do
    register_and_sign_in
    expect{register_and_sign_in}.to_not change{User.all.count}
  end

  scenario 'User can\'t sign in with previously registered email' do
    User.create(name: 'Cameron', password: 'addhth', password_test: 'addhth', email: 'cameron@gmail.com')
    expect{register_and_sign_in}.to_not change{User.all.count}  
    expect(page).to have_content('Email is already taken')
  end

  scenario "Different passwords display a flash error message" do
    visit('/')
    fill_in('name', with: 'Cameron')
    fill_in('password', with: 'password')
    fill_in('password_test', with: 'not_the_same_password')
    fill_in('email', with: 'cameron@gmail.com')
    click_button('Register')
    expect(current_path).to eq '/'
    expect(page).to have_content 'Password does not match the confirmation'
  end
end
