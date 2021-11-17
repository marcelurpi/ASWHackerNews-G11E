class AddAuthorNameComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :name_author, :string
  end
end
