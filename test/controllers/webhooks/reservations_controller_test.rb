require "test_helper"

class Webhooks::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should create reservation" do
    assert_difference("Reservation.count") do
      post webhooks_reservations_url, params: {
        reservationId: 3,
        checkInTime: "2024-03-26 10:00:00",
        checkOutTime: "2024-03-28 10:00:00",
        totalPrice: 100,
        guestName: "John Doe",
        listingMapId: 1,
        status: "new"
      }
    end

    assert_response :ok
  end
end
