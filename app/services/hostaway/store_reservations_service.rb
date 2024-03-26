class Hostaway::StoreReservationsService
  def initialize
    @hostaway = HostawayClient.instance
  end

  def call(params: {})
    reservations = @hostaway.fetch_reservations(params)
    Reservation.transaction do
      reservations.each { |reservation| self.class.save_reservation(reservation) }
    end
  end

  def self.save_reservation(reservation)
    reservation_record = Reservation.find_or_initialize_by(
      external_id: reservation["reservationId"]
    )
    reservation_record.update!(
      listing_id: reservation["listingMapId"],
      checkin_at: reservation["checkInTime"],
      checkout_at: reservation["checkOutTime"],
      price: reservation["totalPrice"],
      guest_name: reservation["guestName"],
      status: reservation["status"]
    )
  rescue => e
    Rails.logger.error("Error saving reservation #{reservation["reservationId"]}: #{e.message}")
  end
end
