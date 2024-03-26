require 'test_helper'

class Hostaway::StoreReservationsServiceTest < ActiveSupport::TestCase
  def setup
    @service = Hostaway::StoreReservationsService.new
  end

  test "should save reservation" do
    reservation = {
      "reservationId" => 3,
      "listingMapId" => 1,
      "checkInTime" => "2024-03-26 10:00:00",
      "checkOutTime" => "2024-03-28 10:00:00",
      "totalPrice" => 100,
      "guestName" => "John Doe",
      "status" => "confirmed"
    }
    assert_difference("Reservation.count") do
      @service.class.save_reservation(reservation)
    end
    reservation_record = Reservation.find_by(external_id: 3)
    assert_equal 1, reservation_record.listing_id
    assert_equal DateTime.parse("2024-03-26 10:00:00"), reservation_record.checkin_at
    assert_equal DateTime.parse("2024-03-28 10:00:00"), reservation_record.checkout_at
    assert_equal 100, reservation_record.price
    assert_equal "John Doe", reservation_record.guest_name
    assert_equal "confirmed", reservation_record.status
  end
end
