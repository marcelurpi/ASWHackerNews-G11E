class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :author
      t.text :content
      t.integer :points
      t.integer :numcomments

      t.timestamps
    end
  end
end
