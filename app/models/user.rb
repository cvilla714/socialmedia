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
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :confirmed_friendships, -> { where status: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  # pending_friends
  has_many :pending_friendships, -> { where status: nil }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  # friend_requests
  has_many :inverted_friendships, -> { where status: nil }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :requests, through: :inverted_friendships, source: :user

  # def friends
  # Friendship.where(['user_id = ?', self[:id]])
  # end

  def friends_without_status
    # Friendship.select(:user_id).where(['friend_id = ? AND status = true', self[:id]])
    friends.select(:friend_id)
  end

  # def requests
  # Friendship.where(['friend_id = ? AND status IS null', self[:id]])
  # end

  def request?(user_id)
    # friend = Friendship.select(:status).where("(friend_id = #{self[:id]} AND user_id = #{user_id})")
    # friend2 = Friendship.select(:status).where("(friend_id = #{user_id} AND user_id = #{self[:id]})")
    # return false if friend.empty? || !friend2.empty?
    #
    # true
    friend = requests.where("id = #{user_id}")
    return false if friend.empty?

    true
  end

  def friend?(user_id)
    # friend = Friendship.select(:status).where("(friend_id = #{self[:id]} AND user_id = #{user_id})")
    # friend2 = Friendship.select(:status).where("(friend_id = #{user_id} AND user_id = #{self[:id]})")
    # return nil if friend.empty? && !friend2.empty?
    # return false if friend2.empty?
    #
    # friend2.first.status
    friend = pending_friends.where("id = #{user_id}")
    return nil unless friend.empty?
   friend = friends.where("id = #{user_id}")
    return true unless friend.empty?

    false
  end
end
