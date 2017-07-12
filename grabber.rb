require 'pg'
require 'smarter_csv'

class DataGrabber

  attr_reader :options, :db, :id_field, :table_to_query, :fields_to_query

  def initialize(options)
    @options          = options
    @id_field         = options[:id_field]
    @table_to_query   = options[:table_to_query]
    @fields_to_query  = options[:fields_to_query]

    setup_db_connection
  end

  def setup_db_connection
    @db ||= PG::Connection.new(:dbname => options[:db_opts][:dbname], :host => options[:db_opts][:host], :user => options[:db_opts][:user])
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
      "#{field} AS #{als}"
    end.join(",")
  end

  def process
    input = SmarterCSV.process('./tst.csv')
    output = File.open('./output.csv', 'w')

    input.each do |line|
      results = db.exec(query(line[id_field.to_sym]))[0]
      fields_to_query.each do |field,queryable|
        line[field.to_sym] = "\"#{results[field]}\""
      end
      output.puts line.values.join(",")
    end

    output.close
    db.close
  end
end