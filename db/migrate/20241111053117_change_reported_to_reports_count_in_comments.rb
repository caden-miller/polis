class ChangeReportedToReportsCountInComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :reported, :boolean, default: false, null: false
    add_column :comments, :reports_count, :integer, default: 0, null: false
  end
end
