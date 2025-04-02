# frozen_string_literal: true

require "jwt"

class SupabaseJwtHandler
  def self.secret_key
    Rails.application.credentials.dig(:supabase, :jwt_secret) || raise("Supabase JWT secret is missing")
  end

  def self.decode_token!(token)
    decoded_token_payload = JWT.decode(token, secret_key, true, { algorithm: "HS256" })
    DecodedTokenPayload.new(decoded_token_payload)
  end

  class DecodedTokenPayload
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def subject
      payload.dig("sub")
    end

    def metadata
      payload.dig("user_metadata")
    end

    def metadata_email
      metadata&.dig("email")
    end
  end
end
