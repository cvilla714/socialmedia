class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  # has_many :friendship2, class_name: 'Friendship',foreign_key: 'friend_id'
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    # Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id").where(['user_id = ? OR friend_id = ?', self[:id], self[:id]])
    # Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id, status").where(['(user_id = ? OR friend_id = ?) AND status = true', self[:id], self[:id]])
    # Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id, status").where([
    #  '(user_id = ? OR friend_id = ?)', self[:id], self[:id]
    #  ])
    friend = Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id, status")
    friend.where(['(user_id = ? OR friend_id = ?)', self[:id], self[:id]])
  end

  def friends_without_status
    # Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id").where([
    #  '(user_id = ? OR friend_id = ?)', self[:id], self[:id]
    #  ])
    friend = Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id")
    friend.where(['(user_id = ? OR friend_id = ?)', self[:id], self[:id]])
  end

  def requests
    Friendship.where(['friend_id = ? AND status IS null', self[:id]])
  end

  def friend?(user_id)
    friend = Friendship.select(:status).where("friend_id = #{user_id} AND user_id = #{self[:id]}")
    puts "#{friend} klk"
    return false if friend.empty?

    friend.first.status
  end
end
