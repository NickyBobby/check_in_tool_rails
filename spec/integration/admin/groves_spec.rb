require 'rails_helper'
include Pages::Authentication

RSpec.feature 'Adding new groves to the application' do
  let(:school) { create(:school) }
  let(:dashboard_page) { Pages::DashboardPage.new }
  let(:grove_admin_page) { Pages::GroveAdminPage.new }


  describe 'as a teacher with an administrative role' do
    let(:administrator) { create(:teacher, :admin, school: school) }

    before { login(administrator) }

    it 'provides a link to manage the groves' do
      expect(dashboard_page).to have_content("Manage Groves")
    end

    it 'shows the groves in the school' do
      create(:grove, name: "Aspen", school: school)
      create(:grove, name: "Fir", school: school)
      dashboard_page.click_on("Manage Groves")
      expect(dashboard_page).to have_content("Aspen")
      expect(dashboard_page).to have_content("Fir")
    end

    it 'does not show groves in other schools' do
      other_school = create(:school)
      create(:grove, name: "Aspen", school: school)
      create(:grove, name: "Cherry", school: other_school)
      dashboard_page.click_on("Manage Groves")
      expect(dashboard_page).to_not have_content("Cherry")
    end

    describe 'creating a new grove' do
      before {visit_new_grove_page }

      it 'allows creation of a new grove' do
        expect {
          grove_admin_page.create_new_grove("Aspen")
        }.to change { Grove.count }.by(1)
      end

      it 'provides error message if there is a validation problem' do
        create(:grove, name: "Aspen")

        expect {
          grove_admin_page.create_new_grove("Aspen")
        }.to change { Grove.count }.by(0)

        expect(grove_admin_page).to have_content("Name has already been taken")
      end
    end

  end

  describe 'as a teacher without an administrative role' do
    let(:teacher) { create(:teacher) }

    before { login(teacher) }

    it 'does not show the link' do
      expect(dashboard_page).not_to have_content("Manage Groves")
    end

    it 'does not allow access' do
      expect{ dashboard_page.visit('/admin/groves') }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  def visit_new_grove_page
    dashboard_page.click_on("Manage Groves")
    grove_admin_page.click_on "New Grove"
  end
end
