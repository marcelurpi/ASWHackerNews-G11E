class DeleteRepeatedPostReference < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :id_post
  end
end
