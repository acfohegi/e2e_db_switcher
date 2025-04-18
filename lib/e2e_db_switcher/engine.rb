module E2eDbSwitcher
  class Engine < ::Rails::Engine
    isolate_namespace E2eDbSwitcher

    initializer 'e2e_db_switcher.sidekiq' do
      if ENV['WV_E2E_TEST'] == 'true'
        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add ::Sidekiq::E2eDbSwitcher::ServerMiddleware
          end
          config.client_middleware do |chain|
            chain.add ::Sidekiq::E2eDbSwitcher::ClientMiddleware
          end
        end
        Sidekiq.configure_client do |config|
          config.client_middleware do |chain|
            chain.add ::Sidekiq::E2eDbSwitcher::ClientMiddleware
          end
        end
      end
    end
  end
end
