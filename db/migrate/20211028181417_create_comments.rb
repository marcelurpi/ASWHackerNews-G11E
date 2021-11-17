class CreateComments < ActiveRecord::Migration[5.2]
  def change
    
    
    
    create_table :comments do |t|
      t.integer :comment_id
      t.integer :id_post
      t.string :content
      t.integer :points, default: 0

      t.timestamps
      add_foreign_key :posts, :id_post
      
      
    end
  end
end
 