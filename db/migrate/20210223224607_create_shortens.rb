class CreateShortens < ActiveRecord::Migration[6.1]
  def change
    create_table :shortens do |t|
      t.string :slug
      t.string :full_url

      t.timestamps
    end
    add_index :shortens, :slug, unique: true
  end
end
