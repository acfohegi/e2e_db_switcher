# frozen_string_literal: true

module Janus
  class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
  end
end
