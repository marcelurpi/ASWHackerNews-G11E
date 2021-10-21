class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.string :content
      t.string :author
<<<<<<< HEAD:hacker_news/db/migrate/20211019162801_create_posts.rb
      t.string :title
      t.string :url
      t.integer :points
      t.integer :numcomments
=======
      t.integer :numcomments, default: 0
      t.integer :points, default: 0
>>>>>>> new_page:hacker_news/db/migrate/20211020164657_create_posts.rb

      t.timestamps
    end
  end
end