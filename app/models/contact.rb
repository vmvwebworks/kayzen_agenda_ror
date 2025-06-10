class Contact < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Wrong email format" }
end