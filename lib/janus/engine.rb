# frozen_string_literal: true

module Janus
  class Engine < ::Rails::Engine
    isolate_namespace Janus

    initializer 'janus.sidekiq' do
      require 'janus/logger'
      Sidekiq.configure_server do |config|
        config.server_middleware do |chain|
          chain.add ::Sidekiq::Janus::ServerMiddleware
        end
        config.client_middleware do |chain|
          chain.add ::Sidekiq::Janus::ClientMiddleware
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
