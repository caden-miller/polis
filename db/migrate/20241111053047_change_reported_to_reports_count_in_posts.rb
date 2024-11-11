class ChangeReportedToReportsCountInPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :reported, :boolean, default: false, null: false
    add_column :posts, :reports_count, :integer, default: 0, null: false
  end
end
