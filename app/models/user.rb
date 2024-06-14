# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :orders
  belongs_to :store, optional: true

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true, if: -> { password.present? }

  # Roles
  ROLES = %w[admin manager employee].freeze

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def employee?
    role == 'employee'
  end

  def assign_to_store(store)
    update(store: store) if manager? || employee?
  end
end
