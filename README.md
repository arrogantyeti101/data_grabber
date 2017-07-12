# Data Grabber!

## What is this??
Tool that reads through a CSV of data.  Given the required information, it will reach out to a database, query a set of columns (using aliases) from a specific table, and merge that info into the CSV data.

## Okay...what?
Let's say you've got a baller data warehouse that co-locates data from several different production databases in a convenient place and manner, but for security reasons you've decided to not house any PII.
Then let's say somebody important wants a bunch of data that specifically includes some PII.  It would be a million times easier to query the warehouse, but you don't have the PII in there that you need.
Using this tool, you can export the data you DO have in the warehouse, alongside a uniquely identifiable column (ie - `USER_ID`).  Feed the necessary info to this script, and it will reach out and query
your production database, grabbing the requested info, and plopping it back into a CSV output alongside the already-queried data.

## I dig it.  How does it work?
You call the main script, data_grabber.sh, and supply the pertinent info:
* `db_host|name|role`: Should all be self-explanatory.  The host, db name, and user/role to use.
* `fields`: This is a hash of alias:query values.  ie - `full_name:"first_name || ' ' || last_name" zip_code:"postal"`
  * The hash keys are what will be used as an alias and column headers.  The values are the actual text sent to the query
* `id_field`: This specifices what column to query on.  Important that the CSV header matches the actual column label in the database
* `table`: Schema-Qualified table name to query.

## Example
`./data_grabber.sh grab_data --db-host=localhost --db-name=mydb --db-role=myrole --fields=first:first_name last:last_name --id_field:user_id --table=public.users`

## Current Assumptions / Limitations
* The database being used is PostgreSQL, uses the 'pg' gem.
* There are column headers present in the source CSV.
* The identifier is a single column.