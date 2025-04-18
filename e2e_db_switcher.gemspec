Gem::Specification.new do |spec|
  spec.name          = "e2e_db_switcher"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["your@email.com"]
  spec.summary       = "Database switcher for Rails e2e testing with Sidekiq support"
  spec.description   = "Allows switching databases for end-to-end tests in Rails and Sidekiq environments."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "app/**/*", "config/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "sidekiq"
  spec.add_dependency "redis"
end
