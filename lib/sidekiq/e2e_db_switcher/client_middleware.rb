module Sidekiq
  module E2eDbSwitcher
    class ClientMiddleware
      def call(worker_class, job, queue, redis_pool)
        current_db = Sidekiq.server? ? ::E2eDbSwitcher::DbSwitcher.db_from_redis : ::E2eDbSwitcher::DbSwitcher.current
        job['database_name'] = current_db
        Sidekiq.logger.info("Tagged #{worker_class} with database #{current_db}")
        yield
      end
    end
  end
end
