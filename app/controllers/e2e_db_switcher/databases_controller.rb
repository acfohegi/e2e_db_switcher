module E2eDbSwitcher
  class DatabasesController < ApplicationController

    def switch
      success = DbSwitcher.switch
      render json: {
        success:          success,
        current_database: DbSwitcher.current
      }
    end

    def current
      render json: { database: DbSwitcher.current }
    end

  end
end
