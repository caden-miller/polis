class AddPolicyIssueToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :policy_issue, :string
  end
end
