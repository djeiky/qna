module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new({
      provider: provider.downcase,
      uid: '123456',
      info: {email: 'user@usertest.com'},
      credentials: {token: 'token', secret: 'secret' }
    })
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = :invalid_credentials
  end

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new('/dev/null')
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end
end
