class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :id_post
      t.string :title
      t.string :url
      t.string :content
      t.string :author
      t.integer :numcomments, default: 0
      t.integer :points, default: 0

      t.timestamps
    end
  end
end