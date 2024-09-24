# frozen_string_literal: true

require "active_record"
require "scenic"
require "scenic/oracle_adapter/version"
require "scenic/adapters/oracle"
require "scenic/adapters/oracle/railtie" if defined?(Rails)

module Scenic
  module OracleAdapter
    module ToSchemaMonkeyPatch
      def to_schema
        materialized_option = materialized ? "materialized: true, " : ""

        <<-DEFINITION
  create_view #{UnaffixedName.for(name).inspect}, #{materialized_option}sql_definition: <<-\SQL
#{escaped_definition.indent(6)}
  SQL
      DEFINITION
      end
    end
  end
end

Scenic::View.prepend Scenic::OracleAdapter::ToSchemaMonkeyPatch
