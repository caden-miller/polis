class AddReportedAndVerifiedToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :reported, :boolean, null: false, default: false
    add_column :posts, :verified, :boolean, null: false, default: false

    add_column :comments, :reported, :boolean, null: false, default: false
    add_column :comments, :verified, :boolean, null: false, default: false
  end
end
