class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships, {:id => false}  do |t|
      t.references :user, foreign_key: true
      t.references :friend,index: true

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :friend_id
    execute "ALTER TABLE friendships ADD PRIMARY KEY (user_id, friend_id);"
  end
end
