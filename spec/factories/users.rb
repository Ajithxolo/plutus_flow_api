FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email {"john@example.com"}
    supabase_id { "tf0f8637-a893-4a54-a790-296348ccccca" }
    supabase_metadata {
      {
        "email": "john@example.com",
        "email_verified": true,
        "phone_verified": false,
        "sub": "tf0f8637-a893-4a54-a790-296348ccccca"
      }
    }
  end
end
