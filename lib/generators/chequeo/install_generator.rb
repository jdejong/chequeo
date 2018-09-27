module Chequeo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_initializer
        template "initializer.rb", "config/initializers/chequeo.rb"
      end
    end
  end
end