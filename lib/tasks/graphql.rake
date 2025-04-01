namespace :graphql do
  desc "Dump the GraphQL schema"
  task schema_dump: :environment do
    schema = PlutusFlowApiSchema
    schema_path = Rails.root.join("app/graphql/schema.graphql")
    File.write(schema_path, schema.to_definition)
    puts "GraphQL schema dumped to #{schema_path}"
  end
end
