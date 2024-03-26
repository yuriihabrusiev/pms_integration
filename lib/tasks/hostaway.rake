namespace :hostaway do
  desc "Update reservations for last 2 weeks"
  task update_reservations: :environment do
    latest_activity_start = 2.weeks.ago.strftime("%Y-%m-%d")
    latest_activity_end = Time.current.strftime("%Y-%m-%d")
    Hostaway::StoreReservationsService.new.call(
      params: { latest_activity_start: latest_activity_start, latest_activity_end: latest_activity_end }
    )
  end
end
