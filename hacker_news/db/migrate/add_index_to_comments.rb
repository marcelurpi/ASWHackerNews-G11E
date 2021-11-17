class AddIndexToComments < ActiveRecord::Migration[5.2]
  def change
    add_index(:comments, [:comment_id], order: {comment_id: :asc})
  end
end
