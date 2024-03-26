class Webhooks::ReservationsController < ApplicationController
  def create
    Hostaway::StoreReservationsService.save_reservation(reservation_params)
    head :ok
  end

  private

  def reservation_params
    @reservation_params ||= params.permit(
      :reservationId, :checkInTime, :checkOutTime, :totalPrice, :guestName, :id, :status, :listingMapId
    )
  end
end
