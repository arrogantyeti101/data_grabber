#!/usr/bin/env ruby
require 'thor'
require_relative 'grabber'

class Parser < Thor
  desc "grab_data", "Grabs data"

  option :db_host,          type: :string, required: true, desc: "Database host"
  option :db_name,          type: :string, required: true, desc: "Database name"
  option :db_role,          type: :string, required: true, desc: "Database role"
  option :fields,           type: :hash,   required: true, desc: "Hash of alias keys with query mappings"
  option :id_field,         type: :string, required: true, desc: "Field to use for querying data"
  option :input,            type: :string, required: true, desc: "Filename to import from"
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
      input:            options[:input],
      table_to_query:   options[:table]
    }

    DataGrabber.new(opts).process
  end

  Parser.start(ARGV)
end
