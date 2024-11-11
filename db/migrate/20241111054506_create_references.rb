class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.string :text
      t.string :url
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    # Remove the old references field from posts
    remove_column :posts, :references, :text
  end
end
