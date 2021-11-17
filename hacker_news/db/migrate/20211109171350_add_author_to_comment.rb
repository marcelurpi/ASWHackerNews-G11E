class AddAuthorToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :id_author, :integer
  end
end