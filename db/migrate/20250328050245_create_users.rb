class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :supabase_id
      t.jsonb :supabase_metadata

      t.timestamps
      t.index :supabase_id, unique: true, where: "supabase_id IS NOT NULL"
      t.index :email, unique: true, where: "email IS NOT NULL"
    end
  end
end
