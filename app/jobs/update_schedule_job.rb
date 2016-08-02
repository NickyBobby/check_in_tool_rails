class UpdateScheduleJob < ActiveJob::Base
  queue_as :default

  def self.perform(student)
    scheduled_events = CalendarEventParser.parse_events(GoogleService.fetch_events(student))
    playlist = student.playlist_activities
    master_calendar = student.grove.master_calendar
    schedule = CalendarZipper.new(master_calendar, playlist, scheduled_events).schedule
    checksum = ChecksumGenerator.get_checksum(schedule)
    # schedule the next update in 15 minutes
    if checksum != student.schedule[:checksum]
      student.schedule.update({ schedule: schedule.to_json, checksum: checksum })
    end
  end
end
