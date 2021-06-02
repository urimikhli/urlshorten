class AddUserToShortens < ActiveRecord::Migration[6.1]
  def change
    add_reference :shortens, :user, null: false, foreign_key: true
  end
end
