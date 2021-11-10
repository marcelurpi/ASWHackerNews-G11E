class CreateComments < ActiveRecord::Migration[5.2]
  def change
    
    add_index(:posts, [:post_id], order: {post_id: :asc})
    
    create_table :comments do |t|
      t.integer :comment_id
      t.integer :post_id
      t.string :content
      t.integer :points, default: 0

      t.timestamps
      add_foreign_key :posts, :post_id
      add_index(:comments, [:comment_id], order: {comment_id: :asc})
    end
  end
end
