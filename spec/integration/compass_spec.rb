require 'rails_helper'
include Pages::Authentication

RSpec.feature 'Student Compass' do
  let(:grove) { create(:grove_with_resources) }
  let(:teacher) { grove.teachers.first }
  let(:student) { grove.students.first }
  let(:activity) { grove.activities.first }
  let(:location) { grove.locations.first }
  let(:event) { create(:event, student: student,
                               location: location,
                               creator_id: teacher.id,
                               activity: activity,
                               start_time: Time.now-10,
                               end_time: Time.now+10) }
  let(:event2) { create(:event, student: student,
                               location: grove.locations.last,
                               creator_id: grove.teachers.last.id,
                               activity: create(:activity, grove: grove, location: grove.locations.last),
                               start_time: Time.now+10,
                               end_time: Time.now+100 ) }

  let(:compass_page) { Pages::CompassPage.new }

  describe "student views compass" do
    before do
      grove
      Scan.delete_all
      Event.delete_all
      event
      login(student)
    end

    it "shows details of current event" do
      compass_page.visit_page
      expect(compass_page).to have_content event.location.name
      expect(compass_page).to have_content event.activity.name
      expect(compass_page).to have_content event.creator.name
      expect(compass_page).to have_image event.location.image_url
      expect(compass_page).to have_image event.activity.image_url
      expect(compass_page).to have_image event.creator.avatar
    end

    context "no event is scheduled" do
      it "shows an error message" do
        Event.delete_all
        compass_page.visit_page
        expect(compass_page).to have_content "No Event Scheduled"
      end
    end

    context "student is checked in" do
      it "does not show the scan button" do
        create(:scan, event: event,
                      location: location,
                      correct: true,
                      timestamp: Time.now,
                      student: student)
        compass_page.visit_page
        expect(compass_page).not_to have_content "Scan"
        expect(compass_page).to have_css ".scanned-in"
        expect(compass_page).not_to have_css ".enroute"
      end
    end

    context "student is not checked in" do
      it "shows the scan button" do
        compass_page.visit_page
        expect(compass_page).to have_content "Scan"
        expect(compass_page).to have_css ".enroute"
        expect(compass_page).not_to have_css ".scanned-in"
      end
    end

  end

  describe "transitions to new events", js: true do
    before do
      grove
      Scan.delete_all
      Event.delete_all
      event
      event2
      login(student)
    end

    it "automatically transitions to the next event" do
      compass_page.visit_page
      expect(compass_page).to have_content event.location.name
      expect(compass_page).to have_content event.activity.name
      expect(compass_page).to have_content event.creator.name

      sleep(11)
      expect(compass_page).to have_content event2.location.name
      expect(compass_page).to have_content event2.activity.name
      expect(compass_page).to have_content event2.creator.name
    end
  end
end
