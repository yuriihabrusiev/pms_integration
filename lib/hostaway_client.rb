require 'singleton'

class HostawayClient
  include Singleton
  include HTTParty

  PARAMS_MAPPING = {
    latest_activity_start: "latestActivityStart",
    latest_activity_end: "latestActivityEnd"
  }.freeze
  BASE_URL = "https://api.hostaway.com/v1".freeze
  SUCCESS_STATUS = "success".freeze

  def fetch_reservations(params = {})
    response = self.class.get(
      "#{BASE_URL}/reservations",
      headers: default_headers,
      query: transform_params(params)
    )
    if response["status"] == SUCCESS_STATUS
      response["result"]
    else
      raise "Error fetching reservations"
    end
  end

  private

  def authenticate
    self.class.post("#{BASE_URL}/accessTokens", body: {
      client_id: Rails.application.credentials.hostaway.client_id,
      client_secret: Rails.application.credentials.hostaway.client_secret,
      grant_type: :client_credentials,
      scope: :general
    })
  end

  def access_token
    @access_token ||= authenticate["access_token"]
  end

  def default_headers
    @default_headers ||= { "Authorization" => "Bearer #{access_token}" }
  end

  def transform_params(params)
    params.each_with_object({}) do |(key, value), query|
      query[PARAMS_MAPPING[key]] = value
    end
  end
end
