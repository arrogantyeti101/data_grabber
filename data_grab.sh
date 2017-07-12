#!/usr/bin/env ruby
require 'thor'
require_relative 'grabber'

class Parser < Thor
  desc "grab_data", "Grabs data"

  option :db_host,          type: :string, required: true, desc: "Database host"
  option :db_name,          type: :string, required: true, desc: "Database name"
  option :db_role,          type: :string, required: true, desc: "Database role"
  option :fields,           type: :hash,   required: true, desc: "Hash of alias keys with query mappings"
  # ex: customer_name:"last_name || ',' || first_name" street_address:"line1 || ' ' || line2"
  option :id_field,         type: :string, required: true, desc: "Field to use for querying data"
  option :table,            type: :string, required: true, desc: "schema-qualified table name to query"

  def grab_data
    db_opts = {
      :dbname => options[:db_name],
      :host   => options[:db_host],
      :user   => options[:db_role]
    }

    opts = {
      db_opts:          db_opts,
      fields_to_query:  options[:fields],
      id_field:         options[:id_field],
      table_to_query:   options[:table]
    }

    DataGrabber.new(opts).process
  end

  Parser.start(ARGV)
end