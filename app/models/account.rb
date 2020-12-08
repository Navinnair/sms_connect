class Account < ApplicationRecord
  has_many :phone_numbers

  class << self
    # account authentication
    def authenticate_user(encoded_auth_details)
      username, auth_id = ::Base64.decode64(encoded_auth_details.split(' ', 2).last || '').split(/:/, 2)
      authenticate(username, auth_id)
    end

    def authenticate(username, auth_id)
      user = find_by(username: username, auth_id: auth_id)
      raise 'invalid_credentials' unless user

      user
    end
  end

  # check number exists in the phone numbers
  def phone_numbers_search(phone_number)
    phone_numbers.find_by(number: phone_number)
  end

end
