# frozen_string_literal: true

module Authorized
  extend ActiveSupport::Concern

  class UnauthorizedTokenError < StandardError; end
  class MalformedAuthorizationHeaderError < StandardError; end

  MALFORMED_AUTHORIZATION_HEADER = {
    error: "invalid_request",
    error_description: "Authorization header must follow the format: Bearer access-token",
    message: "Bad credentials"
  }.freeze

  UNAUTHORIZED_TOKEN = {
    error: "unauthorized",
    error_description: "Unauthorized request, token is invalid",
    message: "Unauthorized request"
  }.freeze

  included do
    rescue_from UnauthorizedTokenError do
      render json: UNAUTHORIZED_TOKEN, status: :unauthorized
    end

    rescue_from MalformedAuthorizationHeaderError do
      render json: MALFORMED_AUTHORIZATION_HEADER, status: :unauthorized
    end
  end

  def decoded_token_payload
    @decoded_token_payload ||= decode_token!
  rescue JWT::DecodeError
    raise UnauthorizedTokenError
  end

  def current_user
    return @current_user if defined?(@current_user)

    token = token_from_request
    if token.blank?
      @current_user = nil
    else
      # Here we assume that the decoded token's subject holds the Supabase user id.
      @current_user = User.find_by(supabase_id: decoded_token_payload["sub"])
    end
    @current_user
  end

  private

  def decode_token!
    token = token_from_request
    return nil if token.blank?

    # Use a custom handler to decode the Supabase JWT. Implement SupabaseJwtHandler.decode_token! accordingly.
    SupabaseJwtHandler.decode_token!(token)
  end

  def token_from_request
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    header_elements = auth_header.split
    unless header_elements.length == 2 && header_elements.first.downcase == "bearer"
      raise MalformedAuthorizationHeaderError
    end

    header_elements.last
  end
end
