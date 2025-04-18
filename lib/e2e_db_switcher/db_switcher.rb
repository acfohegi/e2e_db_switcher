require 'redis'

module E2eDbSwitcher
  module DbSwitcher

    def self.switch(database_name = nil)
      database_name ||= db_from_redis

      return false unless ENV['WV_E2E_TEST'] && database_name && !database_name.empty?

      if current == database_name
        Rails.logger.info("DbSwitcher: Already connected to #{database_name}")
        return true
      end

      config = ActiveRecord::Base.connection_db_config.configuration_hash.dup
      config[:database] = database_name

      ActiveRecord::Base.connection_pool.disconnect!
      ActiveRecord::Base.establish_connection(config)

      success = current == database_name
      Rails.logger.info("DbSwitcher: Switched database to: #{database_name}") if success
      success
    end

    def self.current
      ActiveRecord::Base.connection.current_database
    end

    def self.db_from_redis
      redis_host = ENV['E2E_DB_SWITCHER_REDIS_HOST'] || 'localhost'
      redis_pass = ENV['E2E_DB_SWITCHER_REDIS_PASS']
      r = Redis::Namespace.new(
        'wv_e2e_test',
        redis: Redis.new(host: redis_host, password: redis_pass)
      )
      r.get('current_db_name_sc')
    end

  end
end
