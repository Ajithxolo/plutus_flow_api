module Mutations
  class CreateUserWithSupabase < BaseMutation
    argument :token, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(jwt)
      raise GraphQL::ExecutionError, "Token must be a valid string" unless jwt[:token].is_a?(String)

      begin
        decoded_payload = SupabaseJwtHandler.decode_token!(jwt[:token])

        subject = decoded_payload.subject
        metadata = decoded_payload.metadata
        metadata_email = decoded_payload.metadata_email

        user = User.find_or_initialize_by(supabase_id: subject)
        user.email = metadata_email
        user.name = ""
        user.supabase_metadata = metadata

        if user.save
          {
            user: user,
            errors: []
          }
        else
          {
            user: nil,
            errors: user.errors.full_messages
          }
        end
      rescue JWT::DecodeError => e
        {
          user: nil,
          errors: [ "Invalid token: #{e.message}" ]
        }
      rescue StandardError => e
        {
          user: nil,
          errors: [ "An error occurred: #{e.message}" ]
        }
      end
    end
  end
end
