class Group < ActiveRecord::Base
    validates :user, :name, :description, presence: true
    validates :name, length: {minimum: 5, too_short: "%{count} characters is the minimum allowed"}
    validates :description, length: {minimum: 10, too_short: "%{count} characters is the minimum allowed"}

    # A GROUP:
    #   belongs_to a User
    belongs_to :user

    #   has_many TOTAL Likes
    has_many :memberships, dependent: :destroy # IF GROUP IS DELETED, SO ARE THE MEMBERSHIPS FOR IT!
    
    #   has_many Users (who likeMd it)! 
    # ( associated with User's ."groups_joined" )
    has_many :users, through: :memberships
end