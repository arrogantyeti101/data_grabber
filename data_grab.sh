#!/usr/bin/env ruby
require 'thor'
require_relative 'grabber'

class Parser < Thor
  desc "grab_data", "Grabs data"

  option :db_host,          type: :string, required: true,                          desc: "Database host"
  option :db_name,          type: :string, required: true,                          desc: "Database name"
  option :db_role,          type: :string, required: true,                          desc: "Database role"
  option :fields,           type: :hash,   required: true,                          desc: "Hash of alias keys with query mappings"
  option :id_field,         type: :string, required: true,                          desc: "Field to use for querying data"
  option :input,            type: :string, required: true,                          desc: "Filename to import from"
  option :output,           type: :string, required: false, default: 'output.csv',  desc: "Filename to output to"
  option :table,            type: :string, required: true,                          desc: "schema-qualified table name to query"
  option :headers,          type: :boolean,required: false, default: true,          desc: "True if headers should be in output file"

  def grab_data
    db_opts = {
      :dbname => options[:db_name],
      :host   => options[:db_host],
      :user   => options[:db_role]
    }

    fields_to_query = options[:fields].each_with_object({}) do |(key,val),f|
      f[key.gsub(/ /,'_').downcase.to_sym] = val
    end

    opts = {
      db_opts:          db_opts,
      fields_to_query:  fields_to_query,
      id_field:         options[:id_field],
      input:            options[:input],
      output:           options[:output],
      table_to_query:   options[:table],
      headers:          options[:headers]
    }

    DataGrabber.new(opts).process
  end

  Parser.start(ARGV)
end
