module E2eDbSwitcher
  class ApplicationController < ActionController::Base

    skip_before_action :verify_authenticity_token
    before_action :check_e2e_env

    private

    def check_e2e_env
      head :forbidden unless ENV['WV_E2E_TEST'] == 'true'
    end

  end
end
