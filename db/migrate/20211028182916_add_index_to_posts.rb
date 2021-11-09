class AddIndexToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :id_post, :integer
    add_index :posts, :id_post
  end
end
