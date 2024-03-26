json.extract! reservation, :id, :checkin_at, :checkout_at, :price, :guest_name, :listing_id, :status, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
