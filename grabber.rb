require 'pg'
require 'smarter_csv'

class DataGrabber

  attr_reader :options, :db, :id_field, :table_to_query, :input_file, :output_file, :fields_to_query

  def initialize(options)
    @options          = options
    @id_field         = options[:id_field]
    @fields_to_query  = options[:fields_to_query]
    @table_to_query   = options[:table_to_query]
    @input_file       = options[:input]
    @output_file      = options[:output]

    setup_db_connection
  end

  def setup_db_connection
    @db ||= PG::Connection.new(options[:db_opts])
  end

  def query(id)
    <<-SQL
      SELECT #{queryable_fields}
      FROM #{table_to_query}
      WHERE #{id_field} = #{id};
    SQL
  end

  def queryable_fields
    fields_to_query.map do |als,field|
      "#{field} AS \"#{als.to_s}\""
    end.join(",")
  end

  def process
    input = SmarterCSV.process("./#{input_file}")
    output = File.open("./#{output_file}", 'w')

    input.each do |line|
      results = db.exec(query(line[id_field.to_sym]))[0]
      fields_to_query.each { |field,queryable| line[field.to_sym] = "\"#{results[field.to_s]}\"" }
      output.puts line.values.join(",")
    end

    output.close
    db.close
  end
end
