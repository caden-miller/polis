class AddValueToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :value, :integer
  end
end
