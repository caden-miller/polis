class ChangePostsUserIdForeignKey < ActiveRecord::Migration[6.0]
  def change
    # First, remove the existing foreign key constraint
    remove_foreign_key :posts, :users

    # Then, add a new foreign key constraint with ON DELETE SET NULL
    add_foreign_key :posts, :users, on_delete: :nullify

    # Make sure the user_id column allows NULL values
    change_column_null :posts, :user_id, true
  end
end
