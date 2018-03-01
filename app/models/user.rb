class User < ActiveRecord::Base
  # :dependent - Controls what happens to the associated objects when their owner is destroyed:
  # :destroy - causes all the associated objects to also be destroyed (i.e. DESTROYS THE 
  #            RELATIONSHIP RECORD AND ASSOCIATED/DEPENDENT MODEL RECORDS 4.3.2.5)
  # :delete_all - causes all the associated objects to be deleted directly from the database 
  # (so callbacks will not execute)
  # :nullify - causes the Foreign Keys to be set to NULL. 'Save' callbacks are not executed.
  # :restrict_with_exception - causes an exception to be raised if there are any associated records
  # :restrict_with_error - causes an error to be added to the owner if there are any associated objects
      
  # BCRYPT method - adds validations, methods, attributes to User Instance:
  has_secure_password

  EMAIL_REGEX = /\A@\z/i
  has_many :groups  #USER is 'owner' of Groups
  has_many :groups_joined, through: :memberships, source: :group
  has_many :memberships, dependent: :destroy

  # BCRYPT method - adds validations, methods, attributes to User Instance:
  has_secure_password

  # VALIDATIONS:
  validates :first_name, :last_name, :email, presence: true

  # before_validate :uniqueness
  validates :email, :uniqueness=> true, :format => /@/   # OR.... {with: EMAIL_REGEX}
  
  # validates :email, :normalize_email=> true, :format => {with: EMAIL_REGEX, message: "is invalid"}
  before_save :normalize_email, on: [:create, :update]
  
  # def self.combined_name(student)
      # RUBY by DEFAULT returs the last statement:
      # student.first_name + student.last_name
  # end
  
  private
    def normalize_email
      puts "Initially: ", self.email
      self.email = email.downcase
      puts "After: ", self.email
      # or self.email.downcase!
    end
end
