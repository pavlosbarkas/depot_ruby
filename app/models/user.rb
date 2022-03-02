class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password

  # if after the user delete, zero will remain then rollback the delete
  after_destroy :ensure_an_admin_remains

  class Error < StandardError
  end

  attr_accessor :current_password
  validate :current_password_is_correct, on: :update

  def current_password_is_correct
    if !password.blank?
      user = User.find_by_id(id)

      if (user.authenticate(current_password) == false)
        errors.add(:current_password, 'is incorrect.')
      end
    end
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

end
