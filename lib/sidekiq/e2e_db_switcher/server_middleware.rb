module Sidekiq
  module E2eDbSwitcher
    class ServerMiddleware
      def call(worker, job, queue)
        db_name = job['database_name']
        Sidekiq.logger.info("Switching database for job #{job['class']} to #{db_name}")
        ::E2eDbSwitcher::DbSwitcher.switch(db_name)
        yield
      end
    end
  end
end
