module DeviseGoogleAuthenticator
  class Engine < ::Rails::Engine # :nodoc:
    if Rails.version > '5'
      ActiveSupport::Reloader.to_prepare do
        DeviseGoogleAuthenticator::Patches.apply
      end
    else
      ActionDispatch::Callbacks.to_prepare do
        DeviseGoogleAuthenticator::Patches.apply
      end
    end
  end
end
