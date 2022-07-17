module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    http_basic_authenticate_with(
      name: ENV['my_auth_name'] || 'admin',
      password: ENV['my_auth_password'] || 'pass',
      only: :destroy
    )
  end
end
