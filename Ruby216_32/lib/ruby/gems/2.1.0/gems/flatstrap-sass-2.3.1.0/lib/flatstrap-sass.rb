module Flatstrap
  class FrameworkNotFound < StandardError; end

  # Inspired by Kaminari
  def self.load!
    if compass?
      require 'flatstrap-sass/compass_functions'
      register_compass_extension
    elsif asset_pipeline?
      require 'flatstrap-sass/sass_functions'
    end

    if rails?
      require 'sass-rails'
      register_rails_engine
    end

    if !(rails? || compass?)
      raise Flatstrap::FrameworkNotFound, "flatstrap-sass requires either Rails > 3.1 or Compass, neither of which are loaded"
    end

    stylesheets = File.expand_path(File.join("..", 'vendor', 'assets', 'stylesheets'))
    ::Sass.load_paths << stylesheets
  end

  private
  def self.asset_pipeline?
    defined?(::Sprockets)
  end

  def self.compass?
    defined?(::Compass)
  end

  def self.rails?
    defined?(::Rails)
  end

  def self.register_compass_extension
    base = File.join(File.dirname(__FILE__), '..')
    styles = File.join(base, 'vendor', 'assets', 'stylesheets')
    templates = File.join(base, 'templates')
    ::Compass::Frameworks.register('flatstrap', :path => base, :stylesheets_directory => styles, :templates_directory => templates)
  end

  def self.register_rails_engine
    require 'flatstrap-sass/engine'
  end
end

Flatstrap.load!
