require 'rails_helper'
include Pages::Authentication

RSpec.feature 'User can login' do
  let(:student) { create :student }
  let(:teacher) { create :teacher }

  # before do
  #   OmniAuth.config.test_mode = true
  #
  #   OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  #     provider: "Google",
  #     uid: "11111111",
  #     info: {
  #       name: "jj_letest",
  #       email: "letest@rootselementary.org",
  #       first_name: "JJ",
  #       last_name: "Letest",
  #       image: ""
  #     },
  #     credentials: {
  #       token: "token",
  #       refresh_token: "another_token",
  #       expires_at: 1354920555,
  #       expires: true
  #     },
  #     extra: {
  #       id_token: 1000.times.map { "string" }.join, # this huge chunk is used to test for CookieOverflow exception
  #       raw_info: OmniAuth::AuthHash.new(
  #         email: "test@example.com",
  #         email_verified:"true",
  #         kind:"plus#personOpenIdConnect",
  #         name:"Test Person",
  #       )
  #     }
  #   })
  # end
  #
  # describe "as a google user within the Roots org" do
  #   scenario "Teacher within Roots org with correct credentials logs in" do
  #     login_with_google(teacher)
  #
  #     expect(page).to have_content("Welcome, letest@rootselementary.org")
  #     expect(page).to have_content("Not you?")
  #
  #   end
  # end
  #
  # after do
  #   OmniAuth.config.test_mode = false
  # end

end