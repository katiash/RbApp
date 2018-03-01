class Membership < ActiveRecord::Base 
    belongs_to :user # Users who became members of any group
    belongs_to :group # Groups who have members
end
