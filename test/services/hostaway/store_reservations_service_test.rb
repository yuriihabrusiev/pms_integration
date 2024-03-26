require 'test_helper'

class Hostaway::StoreReservationsServiceTest < ActiveSupport::TestCase
  DEFAULT_STUB_HEADERS = {content_type: 'application/json'}
  RESERVATION_RESPONSE = [
    {
      "reservationId" => SecureRandom.uuid,
      "listingMapId" => 1,
      "checkInTime" => "2024-03-26 10:00:00",
      "checkOutTime" => "2024-03-28 10:00:00",
      "totalPrice" => 100,
      "guestName" => "John Doe",
      "status" => "confirmed"
    },
    {
      "reservationId" => SecureRandom.uuid,
      "listingMapId" => 2,
      "checkInTime" => "2024-03-26 10:00:00",
      "checkOutTime" => "2024-03-28 10:00:00",
      "totalPrice" => 100,
      "guestName" => "Jane Doe",
      "status" => "confirmed"
    }
  ].freeze

  def setup
    @service = Hostaway::StoreReservationsService.new
  end

  test "should fetch reservations" do
    stub_request(:post, "https://api.hostaway.com/v1/accessTokens")
      .to_return(status: 200, body: {access_token: :abc}.to_json, headers: DEFAULT_STUB_HEADERS)

    stub_request(:get, "https://api.hostaway.com/v1/reservations")
      .with(headers: {"Authorization" => "Bearer abc"})
      .to_return(status: 200, body: {status: "success", result: RESERVATION_RESPONSE }.to_json, headers: DEFAULT_STUB_HEADERS)

    assert_difference("Reservation.count", 2) do
      @service.call

      assert_equal 1, Reservation.find_by(external_id: RESERVATION_RESPONSE[0]["reservationId"]).listing_id
      assert_equal 2, Reservation.find_by(external_id: RESERVATION_RESPONSE[1]["reservationId"]).listing_id
    end
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
