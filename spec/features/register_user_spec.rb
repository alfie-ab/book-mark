require 'spec_helper'

feature 'registering users' do

  scenario 'sign up a user' do
    expect { sign_up }.to change(User, :count).by(1)
    new_user = User.first
    expect(new_user.email).to eq('santa@northpole.com')
    expect(page).to have_content 'Welcome, Santa'
  end

  scenario 'no new users created unless password confirmed' do
    expect{ sign_up(password_confirmation: 'wrong') }.to_not change(User, :count)
    expect(page).to have_content('Password does not match the confirmation')
    expect(page).to have_field('username', with: 'Santa')
    expect(page).to have_field('email', with: 'santa@northpole.com')
  end

  scenario 'no flash present before signup' do
    visit '/users/new'
    expect(page).to_not have_content('Password does not match the confirmation')
  end

  scenario 'user must enter a valid email to sign up' do
    expect{ sign_up(email: nil) }.to_not change(User, :count)
    expect{ sign_up(email: 'invalid@email') }.to_not change(User, :count)
    expect{ sign_up(email: 'invalidemail.com') }.to_not change(User, :count)
  end

  scenario 'cannot sign up with an already existing email address' do
    sign_up
    expect{sign_up}.to_not change(User, :count)
    expect(page).to have_content("Email is already taken")
  end
end
