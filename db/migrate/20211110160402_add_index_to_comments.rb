class AddIndexToComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :id_author
    add_reference :comments, :user, foreign_key: true

  end
end
