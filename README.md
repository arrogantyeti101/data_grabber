# Data Grabber!

## What is this??
Tool that reads through a CSV of data.  Given the required information, it will reach out to a database, query a set of columns (using aliases) from a specific table, and merge that info into the CSV data.

## Okay...what?
Sometimes you have a data warehouse that has been stripped of PII, but is otherwise much more convenient to query than a set of production databases with said PII.  Also sometimes, you WANT that PII in query results.
In these circumstances, what we've ended up doing is querying the data we have in the warehouse alongside a unique identifier (ie - USER_ID) that can then be used to query information such as names and emails from prodction.
After a couple of instance of this, I got tired of manually lining things up and checking.  So I automated it.

## I dig it.  How does it work?
You call the main script, data_grabber.sh, and supply the pertinent info:
* `db_host|name|role`: Should all be self-explanatory.  The host, db name, and user/role to use.
* `fields`: This is a hash of alias:query values.  ie - `full_name:"first_name || ' ' || last_name" zip_code:"postal"`
  * The hash keys are what will be used as an alias and column headers.  The values are the actual text sent to the query
* `id_field`: This specifices what column to query on.  Important that the CSV header matches the actual column label in the database
* `table`: Schema-Qualified table name to query.

## Example
`./data_grabber.sh grab_data --db-host=localhost --db-name=mydb --db-role=myrole --fields=first:first_name last:last_name --id_field:user_id --table=public.users`

## Prereqs?
Written to work with postgres specifically.  Also requires a handful of gems, visible in Gemfile
