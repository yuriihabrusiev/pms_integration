class Hostaway::StoreReservationsService < IntegrationsBaseService
  ATTRIBUTES_MAPPING = {
    "reservationId" => "external_id",
    "listingMapId" => "listing_id",
    "checkInTime" => "checkin_at",
    "checkOutTime" => "checkout_at",
    "totalPrice" => "price",
    "guestName" => "guest_name",
    "status" => "status"
  }.freeze

  def initialize
    @hostaway = HostawayClient.instance
  end

  def call(params: {})
    reservations = @hostaway.fetch_reservations(params)
    Reservation.transaction do
      reservations.each { |reservation| self.class.save_reservation(reservation) }
    end
  rescue => e
    Rails.logger.error("Error fetching reservations: #{e.message}")
  end

  def self.save_reservation(reservation)
    attributes = transform_attributes(reservation, mapping: ATTRIBUTES_MAPPING)
    reservation_record = Reservation.find_or_initialize_by(
      external_id: attributes["external_id"]
    )
    reservation_record.update!(attributes)
  rescue => e
    Rails.logger.error("Error saving reservation #{reservation["reservationId"]}: #{e.message}")
  end
end
