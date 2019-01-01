# The output shows the total (aggregate) profit fore ach year.
#
# To also determine the total profit summed over all years, you must add up the individual
# values yourself or run an additional query.
#
# Or, you can use ROLLUP - which provides both levels of analysis with a single query.
#
# Adding a WITH ROLLUP modifier to the GROUP BY clause causes the query to produce
# another (super-aggregate) row that shows the grant total over all year values:
#
# 		SELECT year, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year WITH ROLLUP;
# 		+--------+---------------+
# 		| year 	| profit 		 |
# 		+--------+---------------+
# 		| 2000 	| 4525 			 |
# 		| 2001 	| 3010 			 |
# 		| NULL 	| 7535 			 |
# 		+--------+---------------+
#
# The NULL value in the year column identifies the grant total super-aggregate line.
#
# ROLLUP has a more complex effect when there are multiple GROUP by columns.
#
# In this case, each time there is a change in value in any but the last grouping
# column, the query produces an extra super-aggregate summary row.
#
# For example, without ROLLUP, a summary of the sales table based on year, country,
# and product might look like this, where the output indicates summary values only
# at the year/country/product level of analysis:
#
# 		SELECT year, country, product, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year, country, product;
# 		+------+-----------------+-----------------+-------------+
# 		| year | country 			 | product 			 | profit 		|
# 		+------+-----------------+-----------------+-------------+
# 		| 2000 | Finland 			 | Computer 		 | 1500 			|
# 		| 2000 | Finland 			 | Phone 			 | 100 			|
# 		| 2000 | India 			 | Calculator 		 | 150 		   |
# 		| 2000 | India 			 | Computer 		 | 1200 			|
# 		| 2000 | USA 				 | Calculator 		 | 75 			|
# 		| 2000 | USA 				 | Computer 		 | 1500 			|
# 		| 2001 | Finland 			 | Phone 			 | 10 			|
# 		| 2001 | USA 				 | Calculator 		 | 50 			|
# 		| 2001 | USA 				 | Computer 		 | 2700 			|
# 		| 2001 | USA 				 | TV 				 | 250 			|
# 		+------+-----------------+-----------------+-------------+
#
# With ROLLUP added, the query produces several extra rows:
#
# 		SELECT year, country, product, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year, country, product WITH ROLLUP;
# 		+------+-----------------+------------+-------------+
# 		| year | country 			 | product 	  | profit 		 |
# 		+------+-----------------+------------+-------------+
# 		| 2000 | Finland 			 | Computer   | 1500 		 |
# 		| 2000 | Finland 			 | Phone 	  | 100 			 |
# 		| 2000 | Finland 			 | NULL 		  | 1600 		 |
# 		| 2000 | India 			 | Calculator | 150 			 |
# 		| 2000 | India 			 | Computer   | 1200 		 |
# 		| 2000 | India 			 | NULL 		  | 1350 		 |
# 		| 2000 | USA 				 | Calculator | 75 			 |
# 		| 2000 | USA 				 | Computer   | 1500 		 |
# 		| 2000 | USA 				 | NULL 		  | 1575 		 |
# 		| 2000 | NULL 				 | NULL 		  | 4525 		 |
# 		| 2001 | Finland 			 | Phone 	  | 10 			 |
# 		| 2001 | Finland 			 | NULL 		  | 10 			 |
# 		| 2001 | USA 				 | Calculator | 50 			 |
# 		| 2001 | USA 				 | Computer   | 2700 		 |
# 		| 2001 | USA 				 | TV 		  | 250 			 |
# 		| 2001 | USA 				 | NULL 		  | 3000 		 |
# 		| 2001 | NULL 				 | NULL 		  | 3010 		 |
# 		| NULL | NULL 				 | NULL 		  | 7535 		 |
# 		+------+-----------------+------------+-------------+
#
# Now the output includes summary information at four levels of analysis, not just one:
#
# 		) Following each set of product rows for a given year and country, an extra super-aggregate summary row
# 			appears showing the total for all products.
#
# 			These rows have the product column set to NULL
#
# 		) Following each set of rows for a given year, an extra super-aggregate summary row appears showing
# 			the total for all countries and products.
#
# 			These rows have the country and products columns set to NULL
#
# 		) Finally, following all other rows, an extra super-aggregate summary row appears showing the grand total
# 			for all years, countries, and products.
#
# 			This row has the year, country and products set to NULL
#
# Previously, MySQL did not allow the use of DISTINCT or ORDER BY in a query having a WITH ROLLUP option.
#
# This restriction is lifted in MySQL 8.0.12, and later.
#
# (Bug #87450, Bug #86311, Bug#26640100, Bug#26073513)
#
# For GROUP BY --- WITH ROLLUP queries, to test whether NULL values in the result represent
# super-aggregate values, the GROUPING() function is available for use in theh select list,
# HAVING clause and (as of MySQL 8.0.12) ORDER BY clause.
#
# For example, GROUPING(year) returns 1 when NULL in the year column occurs in a super-aggregate
# row, and 0 otherwise.
#
# SImilarly, GROUPING(country) and GROUPING(product) return 1 for super-aggregate NULL values
# in the country and product columns, respectively:
#
# 		SELECT
# 			year, country, product, SUM(profit) AS profit,
# 			GROUPING(year) AS grp_year,
# 			GROUPING(country) AS grp_country,
# 			GROUPING(product) AS grp_product
# 		FROM sales
# 		GROUP BY year, country, product WITH ROLLUP;
# 		+------+------------------+----------------+---------------+-----------------+------------------+----------------+
# 		| year | country 			  | product 		 | profit 	     | grp_year   	  | grp_country 		| grp_product 	  |
# 		+------+------------------+----------------+---------------+-----------------+------------------+----------------+
# 		| 2000 | Finland 			  | Computer 		 | 1500 			  | 0 				  | 0 					| 0 				  |
# 		| 2000 | Finland 			  | Phone 			 | 100 			  | 0 				  | 0 		 			| 0 				  |
# 		| 2000 | Finland 			  | NULL 			 | 1600 			  | 0 				  | 0 					| 1 				  |
# 		| 2000 | India 			  | Calculator 	 | 150 			  | 0 				  | 0 				   | 0				  |
# 		| 2000 | India 			  | Computer 		 | 1200 			  | 0 				  | 0 					| 0 				  |
# 		| 2000 | India 			  | NULL 			 | 1350 			  | 0 				  | 0 					| 1 				  |
# 		| 2000 | USA 				  | Calculator 	 | 75 			  | 0 				  | 0 				   | 0 				  |
# 		| 2000 | USA 				  | Computer 		 | 1500 			  | 0 				  | 0 					| 0 				  |
# 		| 2000 | USA 				  | NULL 			 | 1575 			  | 0 				  | 0 					| 1 				  |
# 		| 2000 | NULL 				  | NULL 			 | 4525 			  | 0 				  | 1 					| 1 				  |
# 		| 2001 | Finland 			  | Phone 			 | 10 			  | 0 				  | 0 					| 0 				  |
# 		| 2001 | Finland 			  | NULL 			 | 10 			  | 0 				  | 0 					| 1 				  |
# 		| 2001 | USA 				  | Calculator 	 | 50 			  | 0 				  | 0 					| 0 				  |
# 		| 2001 | USA 				  | Computer 		 | 2700 			  | 0 				  | 0 					| 0 				  |
# 		| 2001 | USA 				  | TV 				 | 250 			  | 0 				  | 0 					| 0 				  |
# 		| 2001 | USA 				  | NULL 			 | 3000 			  | 0 				  | 0 					| 1 				  |
# 		| 2001 | NULL 				  | NULL 			 | 3010 			  | 0 				  | 1 					| 1 				  |
# 		| NULL | NULL 				  | NULL 			 | 7535 			  | 1 				  | 1 					| 1 				  |
# 		+------+------------------+----------------+---------------+-----------------+------------------+----------------+
#
# Instead of displaying the GROUPING()  result directly, you can use GROUPING() to substitute labels for super-aggregate
# NULL values:
#
# 		SELECT
# 			IF(GROUPING(year), 'All years', year) AS year,
# 			IF(GROUPING(country), 'All countries', country) AS country,
# 			IF(GROUPING(product), 'ALl products', product) AS product,
# 			SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year, country, product WITH ROLLUP;
# +------------+---------------------+-------------------+--------------+
# | year 		| country 				 | product 				| profit 		|
# +------------+---------------------+-------------------+--------------+
# | 2000 		| Finland 				 | Computer 			| 1500 			|
# | 2000 		| Finland 				 | Phone 				| 100 			|
# | 2000 		| Finland 				 | All products 		| 1600 			|
# | 2000 		| India 					 | Calculator 			| 150 			|
# | 2000 		| India 					 | Computer 			| 1200 			|
# | 2000 		| India 					 | All products 		| 1350 		   |
# | 2000 		| USA 					 | Calculator 			| 75 				|
# | 2000 		| USA 					 | Computer 			| 1500 		   |
# | 2000 		| USA 					 | All products 		| 1575 			|
# | 2000 		| All countries 		 | All products 		| 4525 			|
# | 2001 		| Finland 				 | Phone 				| 10 				|
# | 2001 		| Finland 				 | All products 		| 10 				|
# | 2001 		| USA 					 | Calculator 			| 50 				|
# | 2001 		| USA 					 | Computer 			| 2700 			|
# | 2001 		| USA 					 | TV 					| 250 			|
# | 2001 		| USA 					 | All Products 		| 3000 			|
# | 2001 		| All countries 		 | ALl products 		| 3010 			|
# | All years  | All countries 		 | All products 		| 7535 			|
# +------------+---------------------+-------------------+--------------+
#
# With multiple expression arguments, GROUPING() returns a result representing a bitmask
# that combines the results for each expression, with the lowest-order bit corresponding
# ot the result for the rightmost expression.
#
# For example, GROUPING(year, country, product) is evaluated like this:
#
# 		result FOR GROUPING(product)
# 	 + result FOR GROUPING(country) << 1
#   + result FOR GROUPING(year) << 2
#
# The result of such a GROUPING() is nonzero if any of the expressions represents a super-aggregate NULL,
# so you can return only the super-aggregate rows and filter out the regular grouped rows like this:
#
# 	SELECT year, country, product, SUM(profit) AS profit
# 	FROM sales
# 	GROUP BY year, country, product WITH ROLLUP
# 	HAVING GROUPING(year, country, product) <> 0;
# +--------+------------+--------+------------+
# | year   | country 	| product| profit 	 |
# +--------+------------+--------+------------+
# | 2000   | Finland 	| NULL 	| 1600 		 |
# | 2000   | India 		| NULL 	| 1350 		 |
# | 2000   | USA 			| NULL   | 1575 		 |
# | 2000   | NULL 		| NULL 	| 4525 		 |
# | 2001   | Finland 	| NULL   | 10 			 |
# | 2001   | USA 			| NULL   | 3000 		 |
# | 2001   | NULL 		| NULL 	| 3010 		 |
# | NULL   | NULL 		| NULL 	| 7535 		 |
# +--------+------------+--------+------------+
#
# The sales table contains no NULL values, so all NULL values in a ROLLUP result represent
# super-aggregate values.
#
# When the data set contains NULL values, ROLLUP summaries may contain NULL values not only
# in super-aggregate rows, but also in regular grouped rows.
#
# GROUPING() enables these to be distinguished.
#
# Suppose that table t1 contains a simple data set with two grouping factors for a
# set of quantity values, where NULL indicates something like "other" or "unknown"
#
# 		SELECT * FROM t1;
# 		+-------+----------+-----------+
# 		| name  | size 	 | quantity  | 
# 		+-------+----------+-----------+
# 		| ball  | small 	 | 10 		 |
# 		| ball  | large 	 | 20 		 |
# 		| ball  | NULL 	 | 5 			 |
# 		| hoop  | small 	 | 15 		 |
# 		| hoop  | large 	 | 5 			 |
# 		| hoop  | NULL 	 | 3 			 |
# 		+-------+----------+-----------+
#
# A simple ROLLUP operation produces these results, in which it is not so easy to distinguish
# NULL values in super-aggregate rows from NULL values in regular grouped rows:
#
# 		SELECT name, size, SUM(quantity) AS quantity
# 		FROM t1
# 		GROUP BY name, size WITH ROLLUP;
# 		+--------+-----------+----------------+
# 		| ball 	| size 		| quantity 		  |
# 		+--------+-----------+----------------+
# 		| ball 	| NULL 		| 	5 				  |
# 		| ball   | large 		|  20 			  |
# 		| ball 	| small 		|  10  			  |
# 		| ball   | NULL 		|  35 			  |
# 		| hoop   | NULL 		|  3 				  |
# 		| hoop   | large 		|  5 				  |
# 		| hoop   | small 		|  15 			  |
# 		| hoop   | NULL 		| 	23 			  |
# 		| NULL 	| NULL 		|  58 			  |
# 		+--------+-----------+----------------+
#
# Using GROUPING() to substitute labels for the super-aggregate NULL values makes the result easier
# to interpret:
#
# 		SELECT
# 			IF(GROUPING(name) = 1, 'All items', name) AS name,
# 			IF(GROUPING(size) = 1, 'All sizes', size) AS size,
# 			SUM(quantity) AS quantity
# 		FROM t1
# 		GROUP BY name, size WITH ROLLUP;
# 	+----------------+----------------+---------------+
# 	| name 			  | size 			 | quantity 	  |
# 	+----------------+----------------+---------------+
# 	| ball 			  | NULL 			 | 	5 			  |
#  | ball 			  | large 			 | 	20 		  |
# 	| ball 			  | small 			 | 	10 		  |
# 	| ball 			  | All sizes 		 | 	35 		  |
# 	| hoop 			  | NULL 			 | 	3 			  |
# 	| hoop 			  | large 			 | 	5 			  |
# 	| hoop 			  | small 			 | 	15 		  |
# 	| hoop 			  | All sizes 		 | 	23 		  |
# 	| All items 	  | All sizes 		 | 	58 		  |
# 	+----------------+----------------+---------------+
#
# OTHER CONSIDERATIONS WHEN USING ROLLUP
#
# The following discussion lists some behaviors specific to the MySQL implementation of ROLLUP.
#
# Prior to 8.0.12, when you use ROLLUP, you cannot also use an ORDER BY clause to sort the results.
# In other words, ROLLUP and ORDER BY were mutually exclusive in MySQL.
#
# However, you still have some control over sort order. To work around the restriction that prevents
# using ROLLUP with ORDER BY and achieve a specific sort order of grouped results, generate the 
# grouped result set as a derived table and apply ORDER BY to it.
#
# For example:
#
# 		SELECT * FROM
# 			(SELECT year, SUM(profit) AS profit
# 			FROM sales GROUP BY year WITH ROLLUP) AS dt
# 		ORDER BY year DESC;
# 		+-------+-----------+
# 		| year  | profit 	  |
# 		+-------+-----------+
# 		| 2001  | 3010 	  |
# 		| 2000  | 4525 	  |
# 		| NULL  | 7535 	  |
# 		+-------+-----------+
#
# As of MySQL 8.0.12, ORDER BY and ROLLUP can be used together, which enables the use
# of ORDER BY and GROUPING() to achieve a specific sort order of grouped results.
#
# For example:
#
# 		SELECT year, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year WITH ROLLUP
# 		ORDER BY GROUPING(year) DESC;
# 		+--------+----------+
# 		| year 	| profit   |
# 		+--------+----------+
# 		| NULL 	| 7535 	  |
# 		| 2000   | 4525 	  |
# 		| 2001 	| 3010 	  |
# 		+--------+----------+
#
# In both cases, the super-aggregate summary rows sort with the rows from which
# they are calculated, and their placement depends on sort order (at the end for
# ascending sort, at the beginning for descending sort)
#
# LIMIT can be used to restrict the number of rows returned to the client.
#
# LIMIT is applied after ROLLUP, so the limit applies against the extra rows
# added by ROLLUP.
#
# For example:
#
# 		SELECT year, country, product, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year, country, product WITH ROLLUP
# 		LIMIT 5;
# 		+---------+--------------+----------------+-------------+
# 		| year 	 | country 		 | product 			| profit 	  |
# 		+---------+--------------+----------------+-------------+
# 		| 2000    | Finland 		 | Computer 		| 1500 		  |
# 		| 2000 	 | Finland 		 | Phone 			| 100 		  |
# 		| 2000 	 | Finland 		 | NULL 				| 1600 		  |
# 		| 2000 	 | India 		 | Calculator 		| 150 		  |
# 		| 2000    | India 		 | Computer 		| 1200 		  |
# 		+---------+--------------+----------------+-------------+
#
# Using LIMIT with ROLLUP may produce results taht are more difficult to interpret,
# because there is less context for understanding the super-aggregate rows.
#
# The NULL indicators in each super-aggregate row are produced when the row is
# sent to the client.
#
# The server looks at the columns named in the GROUP BY clause following
# the leftmost one that has changed value.
#
# For any column in the result set with a name that matches any of those
# names, its value is set to NULL.
#
# (If you specify grouping columns by column position, the server identifies
# which columns to set to NULL by position)
#
# Because the NULL values in the super-aggregate rows are placed into the result
# set at such a late stage in query processing, you can test them as NULL values
# only in the select list or HAVING clause.
#
# You cannot test them as NULL values in join conditions or the WHERE clause
# to determine which rows to select.
#
# For example, you cannot add WHERE product IS NULL to the query to eliminate
# from the output all but the super-aggregate rows.
#
# The NULL values do appear as NULL on the client side and can be tested as such
# using any MySQL client programming interface.
#
# However, at this point, you cannot distinguish whether a NULL represents
# a regular grouped value or a super-aggregate value.
#
# A MySQL extension permits a column that does not appear in the GROUP BY list 
# to be named in teh select list.
#
# (For information about nonaggregated columns and GROUP BY, see SECTION 12.20.3,
# "MySQL HANDLING OF GROUP BY")
#
# In this case, the server is free to choose any value from this nonaggregated
# column in summary rows, and this includes the extra rows added by WITH ROLLUP.
#
# For example, in the following query, country is a nonaggregated column that does
# not appear in the GROUP BY list and values chosen for this column are nondeterministic:
#
# 		SELECT year, country, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year WITH ROLLUP;
# 		+----------+-------------+-----------+
# 		| year 	  | country 	 | profit 	 |
# 		+----------+-------------+-----------+
# 		| 2000 	  | India 		 | 4525 		 |
# 		| 2001 	  | USA 			 | 3010 		 |
# 		| NULL 	  | USA 			 | 7535 		 |
# 		+----------+-------------+-----------+
#
# This behavior is permitted when the ONLY_FULL_GROUP_BY SQL mode is not enabled.
#
# If that mode is enabled, the server rejects the query as illegal because
# country is not listed in the GROUP BY clause.
#
# With ONLY_FULL_GROUP_BY enabled, you can still execute the query by using the
# ANY_VALUE() function for nondeterministic-value columns:
#
# 		SELECT year, ANY_VALUE(country) AS country, SUM(profit) AS profit
# 		FROM sales
# 		GROUP BY year WITH ROLLUP;
# 		+-------+--------------+-----------+
# 		| year  | country 	  | profit 	  |
# 		+-------+--------------+-----------+
# 		| 2000  | India 		  | 4525 	  |
# 		| 2001  | USA 			  | 3010 	  |
# 		| NULL  | USA 			  | 7535		  |
# 		+-------+--------------+-----------+
#
# 12.20.3 MYSQL HANDLING OF GROUP BY
#
# SQL92 and earlier does not permit queries for which the select list, HAVING condition,
# or ORDER BY list refer to nonaggregated columns that are not named in the GROUP BY
# clause.
#
# For example, this query is illegal in standard SQL 92 because the nonaggregated name column
# in the select list does not appear in the GROUP BY:
#
# 		SELECT o.custid, c.name, MAX(o.payment)
# 			FROM orders AS o, customers AS c
# 			WHERE o.custid = c.custid
# 			GROUP BY o.custid;
#
# For the query to be legal in SQL92, the name column must be omitted from the select list
# or named in the GROUP BY clause.
#
# SQL99 and later permits such nonaggregates per optional feature T301 if they are functionalily
# dependent on GROUP BY columns:
#
# 		if such a relationship exists between name and custid, th query is legal.
#
# This would be the case, for example, were custid a primary key of customers.
#
# MySQL implements detection of functional dependence.
#
# If the ONLY_FULL_GROUP_BY SQL mode is enabled (which it is by default), MySQL
# rejects queries for which the select list, HAVING CONDITION or ORDER BY list
# refer to nonaggregated columns that are neither named in teh GROUP BY clause
# nor are functionally dependent on them.
#
# If ONLY_FULL_GROUP_BY is disabled, a MySQL extension to the standard SQL use of
# GROUP BY permits the select list, HAVING condition, or ORDER BY list to refer to
# nonaggregated columns even if the columns are not functionally dependent on
# GROUP BY columns.
#
# This causes MySQL to accept the preceding query. In this case, the server is free
# to choose any value from each group, so unless they are the same, the values
# chosen are nondeterministic - which is probably not what you want.
#
# Furthermore, the selection of values from each group cannot be influenced by
# adding an ORDER BY clause.
#
# Result set sorting occurs after values have been chosen, and ORDER BY does not
# affect which value within each group the server chooses.
#
# Disabling ONLY_FULL_GROUP_BY is useful primarily when you know that, due to
# some property of the data, all values in each nonaggregated column not
# named in the GROUP BY are the same for each group.
#
# You can achieve the same effect without disabling ONLY_FULL_GROUP_BY by using
# ANY_VALUE() to refer to the nonaggregated column.
#
# The following discussion demonstrates functional dependence, the error message
# MySQL produces when functional dependence is absent, and ways of causing
# MySQL to accept a query in the absence of functional dependence.
#
# This query might be invalid with ONLY_FULL_GROUP_BY enabled because the nonaggregated
# address column in the select list is not named in the GROUP BY clause:
#
# 		SELECT name, address, MAX(age) FROM t GROUP BY name;
#
# The query is valid if name is a primary key of t or is a unique NOT NULL column.
#
# In such cases, MySQL recognizes that the selected column is functionally
# dependent on a grouping column.
#
# For example, if name is a primary key, its value determines the value of
# address because each group has only one value of the primary key and thus
# only one row.
#
# As a result, there is no randomness in the choice of address value in a group
# and no need to reject the query.
#
# The query is invalid if name is not a primary key of t or a unique NOT NULL column.
# In this case, no functional dependency can be inferred and an error occurs:
#
# 		SELECT name, address, MAX(age) FROM t GROUP BY name;
# 		ERROR 1055 (42000): Expression #2 of SELECT list is not in GROUP
# 		BY clause and contains nonaggregated column 'mydb.t.address' which
# 		is not functionally dependent on columns in GROUP BY clause;
# 		this is incompatible with sql_mode=only_full_group_by
#
# If you know that, for a given data set, each name value in fact uniquely
# determines the address value, address is effectively functionally dependent
# on name.
#
# To tell MySQL to accept the query, you can use the ANY_VALUE() function:
#
# 		SELECT name, ANY_VALUE(address), MAX(age) FROM t GROUP BY name;
#
# Alternatively, disable ONLY_FULL_GROUP_BY
#
# The preceding example is quite simple, however. In particular, it is unlikely you would
# group on a single primary key because every group would contain only one row.
#
# For additional examples demonstrating functional dependence in more complex queries,
# see SECTION 12.20.4, "DETECTION OF FUNCTIONAL DEPENDENCE"
#
# if a query has aggregate functions and no GROUP BY clause, it cannot have nonaggregated
# columns in the select list, HAVING condition, or ORDER BY list with ONLY_FULL_GROUP_BY enabled:
#
# 		SELECT name, MAX(age) FROM t;
# 		ERROR 1140 (42000): In aggregated query without GROUP BY, expression
# 		#1 of SELECT list contains nonaggregated column 'mydb.t.name'; this
# 		is incompatible with sql_mode=only_full_group_by
#
# Without GROUP BY, there is a single group and it is nondeterministic which name values to choose
# for the group.
#
# Here, too, ANY_VALUE() can be used, if it is immaterial which name value MySQL chooses:
#
# 		SELECT ANY_VALUE(name), MAX(age) FROM t;
#
# ONLY_FULL_GROUP_BY also affects handling of queries that use DISTINCT and ORDER BY.
#
# Consider the case of a table t with three columns c1, c2, and c3 that contains these
# rows:
#
# 		c1 c2 c3
# 		1  2  A
# 		3  4 	B
# 		1  2  C
#
# Suppose that we execute the following query, expecting the results to be ordered
# by c3:
#
# 		SELECT DISTINCT c1, c2 FROM t ORDER BY c3;
#
# To order the result, duplicates must be eliminated first.
#
# But to do so, should we keep the first row or the third?
#
# This arbitrary choice influences the retained value of c3, which in turn
# influences ordering and makes it arbitrary as well.
#
# To prevent this problem, a query that has DISTINCT and ORDER BY is rejected
# as invalid if any ORDER BY expression does not satisfy at least one of these
# conditions:
#
# 		) The expression is equal to one in the select list
#
# 		) All columns referenced by the expression and belonging to the query's selected tables
# 			are elements of the select list.
#
# Another MySQL extension to standard SQL permits references in the HAVING clause to aliased
# expressions in the select list.
#
# For example, the following query returns name values that occur only once in table orders:
#
# 		SELECT name, COUNT(name) FROM orders
# 			GROUP BY name
# 			HAVING COUNT(name) = 1;
#
# The MySQL extension permits the use of an alias in the HAVING clause for the
# aggregated column:
#
# 		SELECT name, COUNT(name) AS c FROM orders
# 			GROUP BY name
# 			HAVING c = 1;
#
# Standard SQL permits only column expressions in GROUP BY clauses, so a statement
# such as this is invalid because FLOOR(value/100) is a noncolumn expression:
#
# 		SELECT id, FLOOR(value/100)
# 			FROM tbl_name
# 			GROUP BY id, FLOOR(value/100);
#
# MySQL extends standard SQL to permit noncolumn expressions in GROUP BY clauses
# and considers the preceding statement valid.
#
# Standard SQL also does not permit alaises in GROUP BY clauses.
#
# MySQL extends standard SQL to permit aliases, so another way to write
# the query is as follows:
#
# 		SELECT id, FLOOR(value/100) AS val
# 			FROM tbl_name
# 			GROUP BY id, val;
#
# The alias val is considered a column expression in the GROUP BY clause.
#
# In the presence of a noncolumn expression in the GROUP BY clause, MySQL recognizes
# equality between that expression and expressions in the select list.
#
# This means that with ONLY_FULL_GROUP_BY SQL mode enabled, tthe query containing 
# GROUP BY id, FLOOR(value/100) is valid because that same FLOOR() expression occurs
# in the select list.
#
# However, MySQL does not try to recognize functional dependence on GROUP BY noncolumn
# expressions, so the following query is invalid with ONLY_FULL_GROUP_BY enabled,
# even though the third selected expression is a simple formula of the id column
# and the FLOOR() expression in the GROUP BY clause:
#
# 		SELECT id, FLOOR(value/100), id+FLOOR(value/100)
# 			FROM tbl_name
# 			GROUP BY id, FLOOR(value/100);
#
# A workaround is to use a derived table:
#
# 		SELECT id, F, id+F
# 		FROM
# 			(SELECT id, FLOOR(value/100) AS F
# 			FROM tbl_name
# 			GROUP BY id, FLOOR(value/100)) AS dt;
#
# 12.20.4 DETECTION OF FUNCTIONAL DEPENDENCE
#
# The following discussion provides several examples of the ways in which MySQL detects
# functional dependencies.
#
# The examples use this notation:
#
# 		{X} -> {Y}
#
# Understand this as "X uniquely determines Y"; which also means that Y is functionally dependent on X.
#
# The examples use the world database, which can be downloaded at <link>.
#
# You can find details on how to install the database on the same page.
#
# 		) FUNCTIONAL DEPENDENCIES DERIVED FROM KEYS
#
# 		) FUNCTIONAL DEPENDENCIES DERIVED FROM MULTIPLE-COLUMN KEYS AND FROM EQUALITIES
#
# 		) FUNCTIONAL DEPENDENCY SPECIAL CASES
#
# 		) FUNCTIONAL DEPENDENCIES AND VIEWS
#
# 		) COMBINATIONS OF FUNCTIONAL DEPENDENCIES
#
# FUNCTIONAL DEPENDENCIES DERIVED FROM KEYS
#
# The following query selects, for each country, a count of spoken languages:
#
# 		SELECT co.Name, COUNT(*)
# 		FROM countrylanguage cl, country co
# 		WHERE cl.CountryCode = co.Code
# 		GROUP BY co.Code;
#
# co.Code is a primary key of co, so all columns of co are functionally dependent on it,
# as expressed using this notation:
#
# 		{co.Code} -> {co.*}
#
# Thus, co.name is functionally dependent on GROUP BY columns and the query is valid.
#
# A UNIQUE index over a NOT NULL column could be used instead of a primary key and the
# same functional dependence would apply.
#
# (This is not true for a UNIQUE index that permits NULL values because it permits multiple
# NULL values and in that case uniqueness is lost)
#
# FUNCTIONAL DEPENDENCIES DERIVED FROM MULTIPLE-COLUMN KEYS AND FROM EQUALITIES
#
# This query selects, for each country, a list of all spoken languages and how many
# people speak them:
#
# 		SELECT co.Name, cl.Language,
# 		cl.Percentage * co.Population / 100.0 AS SpokenBy
# 		FROM countrylanguage cl, country co
# 		WHERE cl.CountryCode = co.Code
# 		GROUP BY cl.CountryCode, cl.Language;
#
# The pair (cl.CountryCode, cl.Language) is a two-column composite primary key
# of cl, so that column pair uniquely determines all columns of cl:
#
# 		{cl.CountryCode, cl.Language} -> {cl.*)
#
# Moreover, because of the equality in the WHERE clause:
#
# 		{cl.CountryCode} -> {co.Code}
#
# And, because co.Code is primary key of co:
#
# 		{co.Code} -> {co.*}
#
# "Uniquely determines" relationships are transitive, therefore:
#
# 		{cl.CountryCode, cl.Language} -> {cl.*,co.*}
#
# As a result, the query is valid.
#
# AS with the previous example, a UNIQUE key over NOT NULL columns could be used
# instead of a primary key.
#
# An INNER JOIN condition can be used instead of WHERE.
#
# The same functional dependencies apply:
#
# 		SELECT co.Name, cl.Language,
# 		cl.Percentage * co.Population/100.0 AS SpokenBy
# 		FROM countrylanguage cl INNER JOIN country co
# 		ON cl.CountryCode = co.Code
# 		GROUP BY cl.CountryCode, cl.Language;
#
# FUNCTIONAL DEPENDENCY SPECIAL CASES
#
# Whereas an equality test in a WHERE condition or INNER JOIN condition is symmetric,
# an equality test in an outer join condition is not, because tables play different roles.
#
# Assume that referential integrity has been accidentally broken and there exists a row
# of countrylanguage without a coresponding row in country.
#
# Consider the same query as in the previous example, but with a LEFT JOIN:
#
# 		SELECT co.Name, cl.Language,
# 		cl.Percentage * co.Population/100.0 AS SpokenBy
# 		FROM countrylanguage cl LEFT JOIN country co
# 		ON cl.CountryCode = co.Code
# 		GROUP BY cl.CountryCode, cl.Language;
#
# For a given value of cl.CountryCode, the value of co.Code in the join
# result is either found in a matching row (determined by cl.CountryCode) or is
# NULL-complemented if there is no match (also determined by cl.CountryCode).
#
# In each case, this relationship applies:
#
# 		{cl.CountryCode} -> {co.Code}
#
# cl.CountryCode is itself functionally dependent on {cl.CountryCode, cl.Language} which
# is a primary key.
#
# If in the join result co.Code is NULL-complemented, co.Name is as well.
#
# If co.Code is not NULL-complemented, then because co.Code is a primary key,
# it determines co.Name. Therefore, in all cases:
#
# 		{co.Code} -> {co.Name}
#
# Which yields:
#
# 		{cl.CountryCode, cl.Language} -> {cl.*,co.*}
#
# As a result, the query is valid.
#
# However, suppose that the tables are swapped, as in this query:
#
# 		SELECT co.Name, cl.Language,
# 		cl.Percentage * co.Population/100.0 AS SpokenBy
# 		FROM country co LEFT JOIN countrylanguage cl
# 		ON cl.CountryCode = co.Code
# 		GROUP BY cl.CountryCode, cl.Language;
#
# Now this relationship does NOT apply:
#
# 		{cl.CountryCode, cl.Language} -> {cl.*,co.*}
#
# Indeed, all NULL-complemented rows made for cl will be put into
# a single group (they have both GROUP BY columns equal to NULL), and
# inside this group the value of co.Name can vary.
#
# It is invalid, and MySQL rejects it.
#
# Functional dependence in outer joins is thus linked to whether determinant
# columns belong to the left or right side of the LEFT JOIN.
#
# Determination of functional dependence becomes more complex if htere are
# nested outer joins or the join condition does not consist entirely
# of equality comparisons.
#
# FUNCTIONAL DEPENDENCIES AND VIEWS
#
# Suppose that a view on countries produces their code, their name in uppercase,
# and how many different official languages they have:
#
# 		CREATE VIEW Country2 AS
# 		SELECT co.Code, UPPER(co.Name) AS UpperName,
# 		COUNT(cl.Language) AS OfficialLanguages
# 		FROM country AS co JOIN countrylanguage AS cl
# 		ON cl.CountryCode = co.Code
# 		WHERE cl.isOfficial = 'T'
# 		GROUP BY co.Code;
#
# This definition is valid because:
#
# 		{co.Code} -> {co.*}
#
# In the view result, the first selected column is co.Code, which is also
# the group column and thus determines all other selected expressions:
#
# 		{Country2.Code} -> {Country2.*}
#
# MySQL understands this and uses this information, as described following.
#
# This query displays countries, how many different official languages they have,
# and how many cities they have, by joining the view with the city table:
#
# 		SELECT co2.Code, co2.UpperName, co2.OfficialLanguages,
# 		COUNT(*) AS Cities
# 		FROM country2 AS co2 JOIN city ci
# 		ON ci.CountryCode = co2.Code
# 		GROUP BY co2.Code;
#
# This query is valid because, as seen previously:
#
# 		{co2.Code} -> {co2.*}
#
# MySQL is able to discover a functional dependency in the result of a view and use
# that to validate a query which uses the view.
#
# The same would be true if country2 were a derived table (or common table expression),
# as in:
#
# 		SELECT co2.Code, co2.UpperName, co2.OfficialLanguages,
# 		COUNT(*) AS Cities
# 		FROM
# 		( 
# 			SELECT co.Code, UPPER(co.Name) AS UpperName,
# 			COUNT(cl.Language) AS OfficialLanguages
# 			FROM country AS co JOIN countrylanguage AS cl
# 			ON cl.CountryCode=co.Code
# 			WHERE cl.isOfficial='T'
# 			GROUP BY co.Code
#  	) AS co2
# 		JOIN city ci ON ci.CountryCode = co2.Code
# 		GROUP BY co2.Code;
#
# COMBINATIONS OF FUNCTIONAL DEPENDENCIES:
#
# MySQL is able to combine all of hte preceding types
# of functional dependencies (key based, equality based, view based)
# to validate more complex queries.
#
# 12.21 WINDOW FUNCTIONS
#
# 12.21.1 WINDOW FUNCTION DESCRIPTIONS
# 12.21.2 WINDOW FUNCTION CONCEPTS AND SYNTAX
# 12.21.3 WINDOW FUNCTION FRAME SPECIFICATION
# 12.21.4 NAMED WINDOWS
# 12.21.5 WINDOW FUNCTION RESTRICTIONS
#
# MySQL supports window functions that, for each row from a query, perform a calculation
# using rows related to that row.
#
# The following sections discuss how to use window functions, including descriptions
# of the OVER and WINDOW clauses.
#
# The first section provides descriptions of the nonaggregate window functions.
# For descriptions of the aggregate window functions, see 12.20.1, "AGGREGATE (GROUP BY) FUNCTION DESCRIPTIONS"
#
# For information about optimization and window functions, see SECTION 8.2.1.19, "WINDOW FUNCTION OPTIMIZATION"
#
# 12.21.1 WINDOW FUNCTION DESCRIPTIONS
#
# This section describes nonaggregate window functions that, for each row from a query,
# perform a calculation using rows related to that row.
#
# Most aggregate functions also can be used as window functions; see SECTION 12.20.1,
# "AGGREGATE (GROUP BY) FUNCTION DESCRIPTIONS"
#
# For window function usage information and examples, and definitions of terms such as
# the OVER clause, window, partition, frame and peer, see SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# TABLE 12.27 WINDOW FUNCTIONS
#
# 		Name 							Description
#
# CUME_DIST() 						Cumulative distribution value
#
# DENSE_RANK() 					Rank of current row within its partition, without gaps
#
# FIRST_VALUE() 					Value of argument from first row of window frame
#
# LAG() 								Value of argument from row lagging current row within partition
#
# LAST_VALUE() 					Value of argument from last row of window frame
#
# LEAD() 							Value of argument from row leading current row within partition
#
# NTH_VALUE() 						Value of argument from N-th row of window frame
#
# NTILE() 							Bucket number of current row within its partition
#
# PERCENT_RANK() 					Percentage rank value 
#
# RANK() 							Rank of current row within its partition, with gaps
#
# ROW_NUMBER() 					Number of current row within its partition
#
# In the following function descriptions, over_clause represents the OVER clause, described
# in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# Some window functions permit a null_treatment clause that specifies how to handle
# NULL values when calculating results.
#
# This clause is optional.
#
# It is part of the SQL standard, but the MySQL implementation permits only RESPECT
# NULLS (which is also the default)
#
# This means that NULL values are considered when calculating results.
#
# IGNORE NULLS is parsed, but produces an error.
#
# 		) CUME_DIST() over_clause
#
# 			Returns the cumulative distribution of a value within a group of values,
# 			that is, the percentage of partition values less than or equal to the value in the current row.
#
# 			This represents the number of rows preceding or peer with the current row in the
# 			window ordering of the window partition divided by the total number of rows
# 			in the window partition.
#
# 			Return values range from 0 to 1
#
# 			This function should be used with ORDER BY to sort partition rows into the desired order.
#
# 			Without ORDER BY, all rows are peers and have value N/N = 1, where N is the partition size.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			The following query shows, for the set of values in the val column, the CUME_DIST()
# 			value for each row, as well as the percentage rank value returned by the similar
# 			PERCENT_RANK() function.
#
# 			For reference, the query also displays row numbers using ROW_NUMBER():
#
# 				SELECT
# 					val,
# 					ROW_NUMBER() OVER w AS 'row_number',
# 					CUME_DIST() OVER w AS 'cume_dist',
# 					PERCENT_RANK() OVER w AS 'percent_rank'
# 				FROM numbers
# 				WINDOW w AS (ORDER BY val);
# 				+---------+--------------------+----------------------------+-------------------+
# 				| val 	 | row_number 			 | cume_dist 						| percent_rank 	  |
# 				+---------+--------------------+----------------------------+-------------------+
# 				| 1 		 | 1 						 | 0.22 etc. 						| 0 					  |
# 				| 1 		 | 2 						 | 0.22 etc. 						| 0 					  |
# 				| 2 		 | 3 						 | 0.33 etc 						| 0.25 				  |
# 				| 3 		 | 4 						 | 0.66 etc. 						| 0.375 				  |
# 				| 3 		 | 5 						 | 0.66 etc. 						| 0.375 				  |
# 				| 3 		 | 6 						 | 0.66 etc. 						| 0.375 				  |
# 				| 4 		 | 7 						 | 0.88 etc. 						| 0.75 				  |
# 				| 4 		 | 8 						 | 0.88 etc. 						| 0.75 				  |
# 				| 5 		 | 9 						 | 1 									| 1 					  |
# 				+---------+--------------------+----------------------------+-------------------+
#
# 		) DENSE_RANK() over_clause
#
# 			Returns the rank of the current row within its partition, without gaps.
#
# 			Peers are considered ties and receive the same rank. This function assigns
# 			conesecutive ranks to peer groups; the result is that groups of size greater
# 			than one do not produce noncontiguous rank numbers.
#
# 			For an example, see the RANK() function description.
#
# 			This function should be used with ORDER BY to sort partition rows into
# 			the desired order.
#
# 			Without ORDER BY, all rows are peers.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 		) FIRST_VALUE(expr) [null_treatment] over_clause
#
# 			Returns the value of expr from the first row of the window frame.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			null_treatment is as described in the section introduction.
#
# 			The following query demonstrates FIRST_VALUE(), LAST_VALUE() and two instances
# 			of NTH_VALUE():
#
# 				SELECT
# 					time, subject, val,
# 					FIRST_VALUE(val) OVER w AS 'first',
# 					LAST_VALUE(val) OVER w AS 'last',
# 					NTH_VALUE(val, 2) OVER w AS 'second',
# 					NTH_VALUE(val, 4) OVER w AS 'fourth'
# 				FROM observations
# 				WINDOW w AS (PARTITION BY subject ORDER BY time
# 								ROWS UNBOUNDED PRECEDING);
# 			+-----------------+---------------+--------+--------+-----------+---------+----------+
# 			| time 				| subject 		 | val 	 | first  | last 		 | second  | fourth 	 |
# 			+-----------------+---------------+--------+--------+-----------+---------+----------+
# 			| 07:00:00 		   | st113 			 | 10 	 | 10 	 | 10 		 | NULL 	  | NULL 	 |
# 			| 07:15:00 		   | st113 			 | 9 		 | 10 	 | 9 			 | 9 		  | NULL 	 |
# 			| 07:30:00 			| st113 			 | 25 	 | 10 	 | 25 		 | 9 		  | NULL 	 |
# 			| 07:45:00 			| st113 			 | 20 	 | 10 	 | 20 		 | 9 		  | 20 		 |
# 			| 07:00:00 			| xh458 			 | 0 		 | 0 		 | 0 			 | NULL 	  | NULL 	 |
# 			| 07:15:00 			| xh458 			 | 10 	 | 0 		 | 10 		 | 10 	  | NULL 	 |
# 			| 07:30:00 			| xh458 			 | 5 		 | 0 		 | 5 			 | 10 	  | NULL 	 |
# 			| 07:45:00 			| xh458 			 | 30 	 | 0 		 | 30 		 | 10 	  | 30 		 |
# 			| 08:00:00 			| xh458 			 | 25 	 | 0 		 | 25 		 | 10 	  | 30 		 |
# 			+-----------------+---------------+--------+--------+-----------+---------+----------+
#
# 			Each function uses the rows in the current frame, which, per the window definition shown,
# 			extends from the first partition row to the current row.
#
# 			For the NTH_VALUE() calls, the current frame does not always include the requested row,
# 			in such cases, the return value is NULL
#
# 		) LAG(expr [, N[, default]]) [null_treatment] over_clause
#
# 			Returns the value of expr from the row that lags (precedes) the current row by N rows
# 			within its partition.
#
# 			If there is no such row, the return value is default.
#
# 			For example, if N is 3, the return value is default for the first two rows.
#
# 			If N or default are missing, the defaults are 1 and NULL, respectively.
#
# 			N must be a literal nonnegative integer. If N is 0, expr is evaluated for the current row.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			null_treatment is as described in the section intro.
#
# 			LAG() (and the similar LEAD() function) are often used to compute differences between rows.
#
# 			The following query shows a set of time-ordered observations and, for each one,
# 			the LAG() and LEAD() values from the adjoining rows, as well as the differences
# 			between the current and adjoining rows:
#
# 				SELECT
# 					t, val,
# 					LAG(val) 			OVER w AS 'lag',
# 					LEAD(val) 			OVER w AS 'lead',
# 					val - LAG(val) 	OVER w AS 'lag diff',
# 					val - LEAD(val) 	OVER w AS 'lead diff'
# 				FROM series
# 				WINDOW w AS (ORDER BY t);
# 				+--------------------+---------+----------+----------+------------------+--------------------+
# 				| t 						| val 	 | lag 		| lead 	  | lag diff 			| lead diff 			|
# 				+--------------------+---------+----------+----------+------------------+--------------------+
# 				| 12:00:00 				| 100 	 | NULL 		| 125 	  | NULL 				| 	-25 					|
# 				| 13:00:00 				| 125 	 | 100 		| 132 	  | 25 					|  -7 					|
# 				| 14:00:00 				| 132 	 | 125 		| 145 	  | 7 					|  -13 					|
# 				| 15:00:00 				| 145 	 | 132 		| 140 	  | 13 					|  5 						|
# 				| 16:00:00 				| 140 	 | 145 		| 150 	  | -5 					|  -10 					|
# 				| 17:00:00 				| 150 	 | 140 		| 200 	  | 10 					|  -50 					|
# 				| 18:00:00 				| 200 	 | 150 		| NULL 	  | 50 					| 	NULL 					|
# 				+--------------------+---------+----------+----------+------------------+--------------------+
#
# 			In the example, the LAG() and LEAD() calls use the default N and default values of 1 and NULL, respectively.
#
# 			The first row shows what happens when there is no previous row for LAG(): The function returns the
# 			default value (in this case, NULL) 
#
# 			The last row shows the same thing when there is no next row for LEAD()
#
# 			LAG() and LEAD() also serve to compute sums rather than differences.
#
# 			Consider this data set, which contains the first few numbers of the Fibonacci series:
#
# 				SELECT n FROM fib ORDER BY n;
# 				+--------+-
# 				| n 	   |
# 				+--------+
# 				| 1 		|
# 				| 1 		|
# 				| 2 		|
# 				| 3 		|
# 				| 5 		|
# 				| 8 		|
# 				+--------+
#
# 			THe following query shows the LAG() and LEAD() values for the rows adjacent
# 			to the current row.
#
# 			It also uses those functions to add to the current row value the values
# 			from the preceding and following rows.
#
# 			The effect is to generate the next number in the Fibonacci series, and the
# 			next number after that:
#
# 				SELECT
# 					n,
# 					LAG(n, 1, 0) 		OVER w AS 'lag',
# 					LEAD(n, 1, 0) 		OVER w AS 'lead',
# 					n + LAG(n, 1, 0) 	OVER w AS 'next_n',
# 					n + LEAD(n, 1, 0) OVER w AS 'next_next_n'
# 				FROM fib
# 				WINDOW w AS (ORDER BY n);
# 				+--------+----------+---------+-----------+-------------------+
# 				| n 		| lag 	  | lead 	| next_n 	| next_next_n 		  |
# 				+--------+----------+---------+-----------+-------------------+
# 				| 1 		| 0 		  | 1 		| 	1 			| 2 					  |
# 				| 1 		| 1 		  | 2 		|  2 			| 3 					  |
# 				| 2 		| 1 		  | 3 		|  3 		   | 5 					  |
# 				| 3 		| 2 		  | 5 		|  5 			| 8 					  |
# 				| 5 		| 3 		  | 8  		|  8 			| 13 					  |
# 				| 8 		| 5 		  | 0 		|  13 		| 8 					  |
# 				+--------+----------+---------+-----------+-------------------+
#
# 			One way to generate the initial set of Fibonacci numbers is to use a recursive
# 			common table expression.
#
# 			For an example, see FIBONACCI SERIES GENERATION
#
# 		) LAST_VALUE(expr) [null_treatment] over_clause
#
# 			Returns the value of expr from the last row of the window frame
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			null_treatment is as described in the section intro.
#
# 			For an example, see the FIRST_VALUE() function description
#
# 		) LEAD(expr [, N[, default]]) [null_treatment] over_clause
#
# 			Returns the value of expr from the row that leads (follows) the current row
# 			by N rows within its partition.
#
# 			If there is no such row, the return value is default.
#
# 			For example, if N is 3, the return value is default for the last two rows.
#
# 			If N or default are missing, the defaults are 1 and NULL, respectively.
#
# 			N must be a literal nonnegative integer. If N is 0, expr is evaluated for the
# 			current row.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			null_treatment is as described in this section intro
#
# 			For an example, see the LAG() function description
#
# 		) NTH_VALUE(expr, N) [from_first_last] [null_treatment] over_clause
#
# 			Returns the value of expr from the N-th row of the window frame.
# 			If there is no such row, the return value is NULL.
#
# 			N must be a literal positive integer.
#
# 			from_first_last is part of the SQL standard, but the MySQL implementation
# 			permits only FROM FIRST(which is also the default)
#
# 			This means that calculations begin at the first row of the window.
#
# 			FROM LAST is parsed, but produces an error. To obtain the same effect as
# 			FROM LAST (begin calculations at the last row of the window), use 
# 			ORDER BY to sort in reverse order.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			null_treatment is as described in the section intro.
#
# 			For an example, see the FIRST_VALUE() function description
#
# 		) NTILE(N) over_clause
#
# 			Divides a partition into N groups (buckets), assigns each row in the partition
# 			its bucket number, and returns the bucket number of the current row within its partition.
#
# 			For example, if N is 4, NTILE() divides rows into four buckets.
#
# 			If N is 100, NTILE() divides rows into 100 buckets.
#
# 			N must be a literal positive integer. Bucket number return values range from 1 to N.
#
# 			This function should be used with ORDER BY to sort partition rows into the
# 			desired order.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			The following query shows, for the set of values in the val column,, the percentile values
# 			resulting from dividing the rows into two or four groups.
#
# 			For reference, the query also displays row numbers using ROW_NUMBER():
#
# 				SELECT
# 					val,
# 					ROW_NUMBER() 	OVER w AS 'row_number',
# 					NTILE(2) 		OVER w AS 'ntile2',
# 					NTILE(4) 		OVER w AS 'ntile4'
# 				FROM numbers
# 				WINDOW w AS (ORDER BY val);
# 				+---------+---------------+----------------+------------+
# 				| val 	 | row_number 	  | ntile2 			 | ntile4 	  |
# 				+---------+---------------+----------------+------------+
# 				| 1 		 | 1 				  | 1 				 | 1 			  |
# 				| 1 		 | 2 				  | 1 				 | 1 			  |
# 				| 2 		 | 3 				  | 1 				 | 1 			  |
# 				| 3 		 | 4 				  | 1 				 | 2 			  |
# 				| 3 		 | 5 				  | 1 				 | 2 			  |
# 				| 3 		 | 6 				  | 2 				 | 3 			  |
# 				| 4 		 | 7 				  | 2 				 | 3 			  |
# 				| 4 		 | 8 				  | 2 				 | 4 			  |
# 				| 5 		 | 9 				  | 2 				 | 4 			  |
# 				+---------+---------------+-----------------+-----------+
#
# 		) PERCENT_RANK() over_clause
#
# 			Returns the percentage of partition values less than the value in the current row,
# 			excluding the highest value.
#
# 			Return values range from 0 to 1 and represent the row relative rank, calculated
# 			as the result of this formula, where rank is the row rank and rows is the number
# 			of partition rows:
#
# 				(rank - 1) / (rows - 1)
#
# 			This function should be used with ORDER BY to sort partition rows into the desired order.
#
# 			Without ORDER BY, all rows are peers.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			For an example, see the CUME_DIST() function description.
#
# 		) RANK() over_clause
#
# 			Returns the rank of the current row within its partition, with gaps.
#
# 			Peers are considered ties and receive the same rank.
#
# 			This function does not assign consecutive ranks to peer groups if groups
# 			of size greater than one exist; the result is noncontiguous rank numbers.
#
# 			This function should be used with ORDER BY to sort partition rows into the
# 			desired order.
#
# 			Without ORDER BY, all rows are peers.
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 			The following query shows the difference between RANK(), which produces ranks with gaps,
# 			and DENSE_RANK(), which produces ranks without gaps.
#
# 			The query shows rank values for each member of a set of values in the val column,
# 			which contains some duplicates.
#
# 			RANK() assigns peers (the duplicates) the same rank value, and the next greater value
# 			has a rank higher by the number of peers minus one.
#
# 			DENSE_RANK() also assigns peers the same rank value, but the next higher value
# 			has a rank one greater.
#
# 			For reference, the query also displays row numbers using ROW_NUMBER():
#
# 				SELECT
# 					val,
# 					ROW_NUMBER() OVER w AS 'row_number',
# 					RANK() 		 OVER w AS 'rank',
# 					DENSE_RANK() OVER w AS 'dense_rank'
# 				FROM numbers
# 				WINDOW w AS (ORDER BY val);
# 				+--------+--------------------+----------+---------------+
# 				| val 	| row_number 			| rank 	  | dense_rank 	|
# 				+--------+--------------------+----------+---------------+
# 				| 1 		| 1 						| 1 		  | 1 				|
# 				| 1 		| 2 						| 1 		  | 1 				|
# 				| 2 		| 3 						| 3 		  | 2 				|
# 				| 3 	   | 4 						| 4 		  | 3 				|
# 				| 3 		| 5 						| 4 		  | 3 				|
# 				| 3 		| 6 						| 4 		  | 3 				|
# 				| 4 		| 7 						| 7 		  | 4 				|
# 				| 4 		| 8 					   | 7 		  | 4 				|
# 				| 5 		| 9 						| 9 		  | 5 				|
# 				+--------+--------------------+----------+---------------+
#
# 		) ROW_NUMBER() over_clause
#
# 			Returns the number of the current row within its partition.
#
# 			Rows numbers range from 1 to the number of partition rows.
#
# 			ORDER BY affects the order in which rows are numbered.
#
# 			Without ORDER BY, row numbering is nondeterministic.
#
# 			ROW_NUMBER() assigns peers different row numbers. 
#
# 			To assign peers the same value, use RANK() or DENSE_RANK()
#
# 			For an example, see the RANK() function description
#
# 			over_clause is as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 12.21.2 WINDOW FUNCTION CONCEPTS AND SYNTAX
#
# This section describes how to use window functions.
#
# Examples use the same sales information data set as found in the discussion
# of the GROUPING() function in SECTION 12.20.2, "GROUP BY MODIFIERS"
#
# 		SELECT * FROM sales ORDER BY country, year, product;
# 		+----------+-------------+-------------------+-----------+
# 		| year 	  | country 	 | product 			   | profit 	|
# 		+----------+-------------+-------------------+-----------+
# 		| 2000 	  | Finland 	 | Computer 			| 1500 		|
# 		| 2000 	  | Finland 	 | Phone 				| 100 		|
# 		| 2001 	  | Finland 	 | Phone 				| 10 			|
# 		| 2000 	  | India 		 | Calculator 			| 75 			|
# 		| 2000 	  | India 		 | Calculator 			| 75 		   |
# 		| 2000 	  | India 		 | Computer 			| 1200 		|
# 		| 2000 	  | USA 			 | Calculator 			| 75 		   |
# 		| 2000 	  | USA 			 | Computer 			| 1500 		|
# 		| 2001 	  | USA 			 | Calculator 			| 50 			|
# 		| 2001 	  | USA 			 | Computer 			| 1500 		|
# 		| 2001 	  | USA 			 | Computer 			| 1200 		|
# 		| 2001 	  | USA 			 | TV 					| 150 		|
# 		| 2001 	  | USA 			 | TV 					| 100 		|
# 		+----------+-------------+-------------------+-----------+
#
# A window function performs an aggregate-like operation on a set of query rows.
#
# However, whereas an aggregate operation groups query rows into a single
# result row, a window function produces a result for each query row:
#
# 		) The row for which function evaluation occurs is called the current row
#
# 		) The query rows related to the current row over which function evaluation occurs
# 			comprise the window for the current row.
#
# For example, using the sales information table, these two queries perform aggregate
# operations that produce a single global sum for all rows taken as a group, and sums
# grouped per country:
#
# 		SELECT SUM(profit) AS total_profit
# 		FROM sales;
# 		+---------------------------+
# 		| total_profit 				 |
# 		+---------------------------+
# 		| 	7535 							 |
# 		+---------------------------+
#
# 		SELECT country, SUM(profit) AS country_profit
# 		FROM sales
# 		GROUP BY country
# 		ORDER BY country;
# 		+------------+----------------+
# 		| country 	 | country_profit |
# 		+------------+----------------+
# 		| Finland 	 | 		1610 	   |
# 		| India 		 | 		1350 	   |
# 		| USA 		 | 		4575 		|
# 		+------------+----------------+
#
# By contrast, window operations do not collapse groups of query rows to a single
# output row.
#
# Instead, they produce a result for each row.
#
# Like the preceding queries, the following query uses SUM(), but this time
# as a window function:
#
# 		SELECT
# 			year, country, product, profit,
# 			SUM(profit) OVER() AS total_profit,
# 			SUM(profit) OVER(PARTITION BY country) AS country_profit
# 		FROM sales
# 		ORDER BY country, year, product, profit;
# 		+----------+---------------+------------------+-----------+---------------------+-------------------+
# 		| year 	  | country 		| product 			 | profit 	 | total_profit 		  | country_profit 	 |
# 		+----------+---------------+------------------+-----------+---------------------+-------------------+
# 		| 2000 	  | Finland 		| Computer 			 | 1500 		 | 7535 					  | 	1610 				 |
# 		| 2000 	  | Finland 		| Phone 				 | 100 		 | 7535 					  | 	1610 				 |
# 		| 2001 	  | Finland 		| Phone 				 | 10 		 | 7535 					  | 	1610 				 |
# 		| 2000 	  | India 			| Calculator 		 | 75 		 | 7535 					  | 	1350 				 |
# 		| 2000 	  | India 			| Calculator 		 | 75 		 | 7535 					  | 	1350 				 |
# 		| 2000 	  | India 			| Computer 			 | 1200 		 | 7535 					  | 	1350 				 |
# 		| 2000 	  | USA 				| Calculator 		 | 75 		 | 7535 					  | 	4575 				 |
# 		| 2000 	  | USA 				| Computer 			 | 1500 		 | 7535 					  | 	4575 				 |
# 		| 2001 	  | USA 				| Calculator 		 | 50 		 | 7535 					  | 	4575 				 |
# 		| 2001 	  | USA 			   | Computer 			 | 1200 		 | 7535 					  | 	4575 				 |
# 		| 2001 	  | USA 				| Computer 			 | 1500 		 | 7535 					  | 	4575 				 |
# 		| 2001 	  | USA 				| TV 					 | 100 		 | 7535 					  | 	4575 				 |
#		| 2001 	  | USA 				| TV 					 | 150 		 | 7535 					  | 	4575 				 |
# 		+----------+---------------+------------------+-----------+---------------------+-------------------+
#
# Each window operation in the query is signified by inclusion of an OVER clause that specifies
# how to partition query rows into groups for processing by the window function:
#
# 		) The first OVER clause is empty, which treats the entire set of query rows as a single partition.
#
# 			The window function thus produces a global sum, but does so for each row
#
# 		) The second OVER clause partitions rows by country, producing a sum per partition (per country)
#
# 			The function produces this sum for each partition row.
#
# Window functions are permitted only in the select list and ORDER BY clause.
#
# Query result rows are determined from the FROM clause, after WHERE, GROUP BY, and 
# HAVING processing, and windowing execution occurs before ORDER BY, LIMIT and SELECT DISTINCT.
#
# The OVER clause is permitted for many aggregate functions, which therefore can be used
# as window or nonwindow functions, depending on whether the OVER clause is present or absent:
#
# 		AVG()
# 		BIT_AND()
# 		BIT_OR()
#
# 		BIT_XOR()
# 		COUNT()
# 		JSON_ARRAYAGG()
# 			
#		JSON_OBJECTAGG()
# 		MAX()
# 		MIN()
#
# 		STDDEV_POP(), STDDEV(), STD()
# 		STDDEV_SAMP()
# 		SUM()
#
# 		VAR_POP(), VARIANCE()
# 		VAR_SAMP()
#
# For details about each aggregate function, see SECTION 12.20.1, "AGGREGATE (GROUP BY) FUNCTION DESCRIPTIONS"
#
# MySQL also supports nonaggregate functions that are used only as window functions.
#
# For these, the OVER clause is mandatory:
#
# 		CUME_DIST()
#
# 		DENSE_RANK()
#
# 		FIRST_VALUE()
#
# 		LAG()
#
# 		LAST_VALUE()
#
# 		LEAD()
#
# 		NTH_VALUE()
#
# 		NTILE()
#
# 		PERCENT_RANK()
#
# 		RANK()
#
# 		ROW_NUMBER()
#
# For details about each nonaggregate function, see SECTION 12.21.1, "WINDOW FUNCTION DESCRIPTIONS"
#
# As an example of one of those nonaggregate window functions, this query uses ROW_NUMBER(),
# which produces the row number of each row within its partition.
#
# In this case, rows are numbered per country.
#
# By default, partition rows are unordered and row numbering is nondeterministic.
#
# To sort partition rows, include an ORDER BY clause within the window definition.
#
# The query uses unordered and ordered partitions (the row_num1 and row_num2 columns)
# to illustrate the difference between omitting and including ORDER BY:
#
# 		SELECT
# 			year, country, product, profit,
# 			ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
# 			ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
# 		FROM sales;
#
# +--------+------------------+------------------+---------------+----------------+--------------+
# | year   | country 			| product 			 | profit 		  | row_num1 		 | row_num2 	 |
# +--------+------------------+------------------+---------------+----------------+--------------+
# | 2000   | Finland 			| Computer 			 | 1500 			  | 2 				 | 	1 			 |
# | 2000   | Finland 			| Phone 				 | 100 			  | 1 				 | 	2 			 |
# | 2001   | Finland 			| Phone 				 | 10 			  | 3 				 | 	3 			 |
# | 2000   | India 				| Calculator 		 | 75 			  | 2 				 | 	1 			 |
# | 2000   | India 				| Calculator 		 | 75 			  | 3 				 | 	2 			 |
# | 2000   | India 				| Computer 			 | 1200 			  | 1 				 | 	3 			 |
# | 2000   | USA 					| Calculator 		 | 75 			  | 5 				 | 	1 		    |
# | 2000   | USA 					| Computer 			 | 1500 			  | 4 				 | 	2 			 |
# | 2001   | USA 					| Calculator 		 | 50 			  | 2 				 | 	3 			 |
# | 2001   | USA 					| Computer 			 | 1500 			  | 3 				 | 	4 			 |
# | 2001   | USA 					| Computer 			 | 1200 			  | 7 				 | 	5 			 |
# | 2001   | USA 					| TV 					 | 150 			  | 1 				 | 	6 			 |
# | 2001   | USA 					| TV 					 | 100 			  | 6 				 | 	7 			 |
# +--------+------------------+------------------+---------------+----------------+--------------+
#
# As mentioned previously, to use a window function (or treat an aggregate function as a window function),
# include an OVER clause following the function call.
#
# The OVER clause has two forms:
#
# 		over_clause:
# 			{OVER (window_spec) | OVER window_name}
#
# Both forms define how the window functions should process query rows.
#
# They differ in whether the window is defined directly in the OVER clause, or
# supplied by a reference to a named window defined elsewhere in the query:
#
# 		) In the first case, the window specification appears directly in the OVER clause, between the parentheses
#
# 		) In the second case, window_name is the name for a window specification defined by a WINDOW clause elsewhere
# 			in the query.
#
# 			For details, see SECTION 12.21.4, "NAMED WINDOWS"
#
# For OVER (window_spec) syntax, the window specification has several parts, all optional:
#
# 		window_spec:
# 			[window_name] [partition_clause] [order_clause] [frame_clause]
#
# If OVER() is empty, the window consists of all query rows and the window function computes
# a result using all rows.
#
# Otherwise, the clauses present within the parentheses determine which query rows are used
# to compute the function result and how they are partitioned and ordered:
#
# 		) window_name: The name of a window defined by a WINDOW clause elsewhere in the query.
#
# 			If window_name appears by itself within the OVER clause, it completely defines
# 			the window.
#
# 			If partitioning, ordering, or framing clauses are also given, they modify interpretation
# 			of the named window.
#
# 			For details, SEE SECTION 12.21.4, "NAMED WINDOWS"
#
# 		) partition_clause: A PARTITION BY clause indicates how to divide the query rows into groups.
#
# 			The window function result for a given row is based on the rows of the partition
# 			that contains the row.
#
# 			If PARTITION BY is omitted, there is a single partition consisting of all query rows.
#
# 			NOTE:
#
# 				Partitioning for window functions differs from table partitioning. For more information about
# 				table partitioning, see CHAPTER 23, PARTITIONING
#
# 			partition_clause has this syntax:
#
# 				partition_clause:
# 					PARTITION BY expr [, expr] ---
#
# 			Standard SQL requires PARTITION BY to be followed by column names only.
#
# 			A MySQL extension is to permit expressions, not just column names.
#
# 			For example, if a table contains a TIMESTAMP column named ts, standard SQL
# 			permits PARTITION BY ts but not PARTITION BY HOUR(ts), whereas MySQL permits both.
#
# 		) order_clause: An ORDER BY clause indicates how to sort rows in each partition.
#
# 			Partition rows that are equal according to the ORDER BY clause are considered peers.
#
# 			If ORDER BY is omitted, partition rows are unordered, with no procesing order implied,
# 			and all partition rows are peers.
#
# 			order_clause has this syntax:
#
# 				order_clause:
# 					ORDER BY expr [ASC|DESC] [, expr [ASC|DESC]] ---
#
# 			Each ORDER BY expression optionally can be followed by ASC or DESC to indicate sort direction.
#
# 			The default is ASC if no direction is specified, NULL values sort first for
# 			ascending sorts, last for descending sorts.
#
# 			An ORDER BY in a window definition applies within individual partitions.
#
# 			To sort the result set as a whole, include an ORDER BY at the query top level.
#
# 		) frame_clause: A frame is a subset of the current partition and the frame clause specifies
# 			how to define the subset.
#
# 			The frame clause has many subclasses of its own.
#
# 			For details, see SECTION 12.21.3, "WINDOW FUNCTION FRAME SPECIFICATION"
#
# 12.21.3 WINDOW FUNCTION FRAME SPECIFICATION
#
# The definition of a window used with a window function can include a frame clause.
#
# A frame is a subset of the current partition and the frame clause specifies
# how to define the subset.
#
# Frames are determined with respect to the current row, which enables a frame to
# move within a partition depending on the location of the current row within its
# partition.
#
# Examples:
#
# 		) By defining a frame to be all rows from the partition start to the current row,
# 			you can compute running totals for each row
#
# 		) By defining a frame as extending N rows on either side of the current row,
# 			you can compute rolling averages.
#
# The following query demonstrates the use of moving frames to compute running totals
# within each group of time-ordered level values, as well as rolling averages computed
# from the current row and the rows that immediately precede and follow it:
#
# 		SELECT
# 			time, subject, val,
# 			SUM(val) OVER (PARTITION BY subject ORDER BY time
# 								ROWS UNBOUNDED PRECEDING)
# 			AS running_total,
# 			AVG(val) OVER (PARTITION BY subject ORDER BY time
# 								ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
# 				AS running_average
# 			FROM observations;
# 		+------------------+---------------+-------------+-------------------+-------------------+
# 		| time 				 | subject 		  | val 			 | running_total 		| running_average   |
# 		+------------------+---------------+-------------+-------------------+-------------------+
# 		| 07:00:00 			 | st113 		  | 10 			 | 		10 			| 9.5000 			  |
# 		| 07:15:00 			 | st113 		  | 9 			 | 		19 			| 14.6667 			  |
# 		| 07:30:00 			 | st113 		  | 25 			 | 		44 		   | 18.0000 			  |
# 		| 07:45:00 			 | st113 		  | 20 			 | 		64 			| 22.5000 			  |
# 		| 07:00:00 			 | xh458 		  | 0 			 | 		0 				| 5.0000 			  |
# 		| 07:15:00 			 | xh458 		  | 10 			 | 		10 			| 5.0000 			  |
# 		| 07:30:00 			 | xh458 		  | 5 			 | 		15 			| 15.0000 			  |
# 		| 07:45:00 			 | xh458 		  | 30 			 | 		45 			| 20.0000 			  |
# 		| 08:00:00 			 | xh458 		  | 25 			 | 		70 			| 27.5000 			  |
# 		+------------------+---------------+-------------+-------------------+-------------------+
#
# For the running_average column, there is no frame row preceding the first one or following the last.
#
# In these cases, AVG() computes the average of the rows that are available.
#
# Aggregate functions used as window functions operate on rows in the current row frame,
# as do these nonaggregate window functions:
#
# 		FIRST_VALUE()
# 		LAST_VALUE()
# 		NTH_VALUE()
#
# Standard SQL specifies that window functions that operate on the entire partition should
# have no frame clause.
#
# MySQL permits a frame clause for such functions but ignores it.
#
# These functions use the entire partition even if a frame is specified:
#
# 		CUME_DIST()
# 
# 		DENSE_RANK()
#
# 		LAG()
#
# 		LEAD()
#
# 		NTILE()
#
# 		PERCENT_RANK()
#
# 		RANK()
#
# 		ROW_NUMBER()
#
# The frame clause,, if given, has this syntax:
#
# 		frame_clause:
# 			frame_units frame_extent
#
# 		frame_units:
# 			{ROWS | RANGE}
#
# In the absence of a frame clause, the default frame depends on whether
# an ORDER BY clause is present, as described later in this section.
#
# The frame_units value indicates the type of relationship between the
# current row and frame rows:
#
# 		) ROWS: The frame is defined by beginning and ending row positions.
#
# 			Offsets are differences in row numbers from the current row number.
#
# 		) RANGE: The frame is defined by rows within a value range.
#
# 			Offsets are differences in row values from the current row value.
#
# The frame_extent value indicates the start and end points of the frame.
#
# You can specify just the start of hte frame (in which case the current row is implicitly the end)
# or use BETWEEN to specify both frame endpoints:
#
# 		frame_extent:
# 			{frame_start | frame_between}
#
# 		frame_between:
# 			BETWEEN frame_start AND frame_end
#
# 		frame_start, frame_end: {
# 			CURRENT ROW
# 		 | UNBOUNDED PRECEDING
# 		 | UNBOUNDED FOLLOWING
# 		 | expr PRECEDING
# 		 | expr FOLLOWING
# 		}
#
# With BETWEEN syntax, frame_start must not occur later than frame_end
#
# The permitted frame_start and frame_end values have these meanings:
#
# 		) CURRENT ROW: For ROWS, the bound is the current row. For RANGE, the bounds is the peers of the current row.
#
# 		) UNBOUNDED PRECEDING: The bound is the first partition row
#
# 		) UNBOUNDED FOLLOWING: The bound is the last partition row
#
# 		) expr PRECEDING: For ROWS, the bound is expr rows before the current row.
#
# 			For RANGE, the bound is the rows with values equal to the current row value
# 			minus expr; if the current row value is NULL, the bound is the peers of the row.
#
# 			For expr PRECEDING (and expr FOLLOWING) expr can be a ? parameter marker
# 			(for use in a prepared statement), a nonnegative numeric literal, or a temporal
# 			interval of the form INTERVAL val unit.
#
# 			For INTERVAL expressions, val specifies nonnegative interval value,
# 			and unit is a keyword indicating the units in which the value should be interpreted.
#
# 			(For details about the permitted units specifiers, see the description of the DATE_ADD()
# 			function in SECTION 12.7, "DATE AND TIME FUNCTIONS")
#
# 			RANGE on a numeric or temporal expr requires ORDER BY on a numeric or temporal expression,
# 			respectively.
#
# 			Examples of valid expr PRECEDING and expr FOLLOWING indicators:
#
# 				10 PRECEDING
# 				INTERVAL 5 DAY PRECEDING
# 				5 FOLLOWING
# 				INTERVAL '2:30' MINUTE_SECOND FOLLOWING
#
# 		) expr FOLLOWING: For ROWS, the bound is expr rows after the current row.
#
# 			For RANGE, the bound is the rows with values equal to the current row
# 			value plus expr; if the current row value is NULL, the bound is the
# 			peers of hte row.
#
# 			For permitted values of expr, see the description of expr PRECEDING
#
# The following query demonstrates FIRST_VALUE(), LAST_VALUE() and two instaces of NTH_VALUE():
#
# 		SELECT
# 			time, subject, val,
# 			FIRST_VALUE(val) 		OVER w AS 'first',
# 			LAST_VALUE(val) 		OVER w AS 'last',
# 			NTH_VALUE(val, 2) 	OVER w AS 'second',
# 			NTH_VALUE(val, 4) 	OVER w AS 'fourth'
# 		FROM observations
# 		WINDOW w AS (PARTITION BY subject ORDER BY time
# 						ROWS UNBOUNDED PRECEDING);
#
# 		+--------------+------------+---------+----------+-----------+-------------+--------+
# 		| time 			| subject 	 | val 	  | first 	 | last 	    | second 		| fourth |
# 		+--------------+------------+---------+----------+-----------+-------------+--------+
# 		| 07:00:00 		| st113 		 | 10 	  | 10 		 | 10 		 | NULL 		   | NULL 	|
# 		| 07:15:00     | st113 		 | 9 		  | 10 		 | 9 			 | 9 				| NULL   |
# 		| 07:30:00     | st113 		 | 25 	  | 10 		 | 25 		 | 9 				| NULL   |
# 		| 07:45:00 		| st113 		 | 20 	  | 10 		 | 20 		 | 9 				| 20 		|
# 		| 07:00:00  	| xh458 		 | 0 		  | 0 		 | 0 			 | NULL 		   | NULL 	|
# 		| 07:15:00     | xh458 		 | 10 	  | 0 		 | 10 		 | 10 			| NULL 	|
# 		| 07:30:00 		| xh458 		 | 5 		  | 0 		 | 5 			 | 10 			| NULL 	|
# 		| 07:45:00 	   | xh458 		 | 30 	  | 0 		 | 30 		 | 10 			| 30 		|
# 		| 08:00:00 		| xh458 		 | 25 	  | 0 		 | 25 		 | 10 			| 30 	   |
# 		+--------------+------------+---------+----------+-----------+-------------+--------+
#
# Each function uses the rows in the current frame, which, per the window definition shown,
# extends from the first partition row to the current row.
#
# For the NTH_VALUE() calls, the current frame does not always include the requested row;
# in such cases, the return value is NULL
#
# In the absence of a frame clause, the default frame depends on whether an ORDER BY clause
# is present:
#
# 		) With ORDER BY: 
#
# 			The default frame includes rows from the partition start through
# 			the current row, including all peers of the current row (rows equal to the current
# 			row according to the ORDER BY clause)
#			
# 			The default is equivalent to this frame specification:
#
# 				RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
#
# 		) Without ORDER BY:
#
# 			The default frame includes all partition rows (because, without ORDER BY, all partition
# 			rows are peers)
#
# 			The default is equivalent to this frame specification:
#
# 				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
#
# Because the default frame differs depending on presence or absence of ORDER BY,
# adding ORDER BY to a query to get deterministic results may change the results.
#
# (For example, the values produced by SUM() might change)
#
# TO obtain the same results but ordered per ORDER BY, provide an explicit
# frame specification to be used regardless of whether ORDER BY is present.
#
# The meaning of a frame specification can be nonobvious when the current
# row value is NULL.
#
# Assuming that to be the case, these examples illustrate how various frame
# specifications apply:
#
# 		) ORDER BY X ASC RANGE BETWEEN 10 FOLLOWING AND 15 FOLLOWING
#
# 			The frame starts at NULL and stops at NULL, thus includes only rows with value NULL
#
# 		) ORDER BY X ASC RANGE BETWEEN 10 FOLLOWING AND UNBOUNDED FOLLOWING
#
# 			The frame starts at NULL and stops at the end of the partition.
#
# 			Because an ASC sort puts NULL values first, the frame is the entire partition.
#
# 		) ORDER BY X DESC RANGE BETWEEN 10 FOLLOWING AND UNBOUNDED FOLLOWING
#
# 			The frame starts at NULL and stops at the end of the partition.
#
# 			Because a DESC sort puts NULL values last, the frame is only the NULL values.
#
# 		) ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND UNBOUNDED FOLLOWING
#
# 			The frame starts at NULL and stops at teh end of the partition.
#
# 			Because an ASC sort puts NULL values first, the frame is the entire partition.
#
# 		) ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND 10 FOLLOWING
#
# 			The frame starts at NULL and stops at NULL, thus includes only rows with value NULL
#
# 		) ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND 1 PRECEDING
#
# 			The frame starts at NULL and stops at NULL, thus includes only rows with value NULL
#
# 		) ORDER BY X ASC RANGE BETWEEN UNBOUNDED PRECEDING AND 10 FOLLOWING
#
# 			The frame starts at the beginning of the partition and stops at rows with value NULL.
#
# 			Because n ASC sort puts NULL values first, the frame is only the NULL values
#
# 12.21.4 NAMED WINDOWS
#
# Windows can be defined and given names by which to refer to them in OVER clauses.
#
# To do this, use a WINDOW clause.
#
# If present in a query, the WINDOW clause falls between the positions of the
# HAVING and ORDER BY clauses, and has this syntax:
#
# 		WINDOW window_name AS (window_spec)
# 			[, window_name AS (window_spec)] ---
#
# For each window definition, window_name is the window name, and window_spec is the
# same type of window specification as given between the parentheses of an OVER
# clause, as described in SECTION 12.21.2, "WINDOW FUNCTION CONCEPTS AND SYNTAX"
#
# 		window_spec:
# 			[window_name] [partition_clause] [order_clause] [frame_clause]
#
# A WINDOW clause is useful for queries in which multiple OVER clauses would otherwise
# define the same window.
#
# Instead, you can define the window once, give it a name, and refer to the name
# in teh OVER clauses.
#
# Consider this query, which defines the same window multiple times:
#
# 		SELECT
# 			val,
# 			ROW_NUMBER() OVER (ORDER BY val) AS 'row_number',
# 			RANK() 		 OVER (ORDER BY val) AS 'rank',
# 			DENSE_RANK() OVER (ORDER BY val) AS 'dense_rank'
# 		FROM numbers;
#
# The query can be written more simply by using WINDOW to define the window once and referring
# to the window by name in the OVER clauses:
#
# 		SELECT
# 			val,
# 			ROW_NUMBER() OVER w AS 'row_number',
# 			RANK() 		 OVER w AS 'rank',
# 			DENSE_RANK() OVER w AS 'dense_rank'
# 		FROM numbers
# 		WINDOW w AS (ORDER BY val);
#
# A named window also makes it easier to experiment with the window definition
# to see the effect on query results.
#
# YOu need only modify the window definition in the WINDOW clause, rather than
# multiple OVER clause definitions.
#
# If an OVER clause uses OVER (window_name ---) rather than OVER window_name,
# the named window can be modified by the addition of other clauses.
#
# For example, this query defines a window that includes partitioning, and uses
# ORDER BY in the OVER clauses to modify the window in different ways:
#
# 		SELECT
# 			DISTINCT year, country,
# 			FIRST_VALUE(year) OVER (w ORDER BY year ASC) AS first,
# 			FIRST_VALUE(year) OVER (w ORDER BY year DESC) AS last
# 		FROM sales
# 		WINDOW w AS (PARTITION BY country);
#
# An OVER clause cna only add properties to a named window, not modify them.
#
# If the named window definition includes a partitioning, ordering or framing
# property, the OVER clause that refers to the window name cannot also include
# the same kind of property or an error occurs:
#
# 		) This construct is permitted because the window definition and the referring
# 			OVER clause do not contain the same kind of properties:
#
# 			OVER (w ORDER BY country)
# 			--- WINDOW w AS (PARTITION BY country)
#
# 		) This construct is not permitted because the OVER clause specifies PARTITION BY 
# 			for a named window that already has PARTITION BY:
#
# 			OVER (w PARTITION BY year)
# 			--- WINDOW w AS (PARTITION BY country)
#
# The definition of a named window can itself begin with a window_name.
#
# In such cases, forward and backward references are permitted, but not cycles:
#
# 		) This is permitted; it contains forward and backward references but no cycles:
#
# 			WINDOW w1 AS (w2), w2 AS (), w3 AS (w1)
#
# 		) This is not permitted because it contains a cycle:
#
# 			WINDOW w1 AS (w2), w2 AS (w3), w3 AS (w1)
#
# 12.21.5 WINDOW FUNCTION RESTRICTIONS
#
# The SQL standard imposes a constraint on window functions that they cannot
# be used in UPDATE or DELETE statements to update rows.
#
# Using such functions in a subquery of these statements (to select rows)
# is permitted.
#
# MySQL does not support these window function features:
#
# 		) DISTINCT syntax for aggregate window functions
#
# 		) Nested window functions
#
# 		) Dynamic frame endpoints that depend on the value of the current row
#
# THe parser recognizes these window constructs which nevertheless are not
# supported:
#
# 		) The GROUPS frame units specifier is parsed, but produces an error.
#
# 			Only ROWS and RANGE are supported.
#
# 		) The EXCLUDE clause for frame specification is parsed, but produces an error.
#
# 		) IGNORE NULLS is parsed, but produces an error. Only RESPECT NULLS
# 			is supported.
#
# 		) FROM LAST is parsed, but produces an error. Only FROM FIRST is supported.
#
# 12.22 INTERNAL FUNCTIONS
#
# TABLE 12.28 INTERNAL FUNCTIONS
#
# NAME 								Desc
#
# CAN_ACCESS_COLUMN() 			Internal use only
#
# CAN_ACCESS_DATABASE() 		Internal
#
# CAN_ACCESS_TABLE() 			Internal
#
# CAN_ACCESS_VIEW() 				Internal
#
# GET_DD_COLUMN_PRIVILEGES() 	Internal
#
# GET_DD_CREATE_OPTIONS() 		Internal
#
# GET_DD_INDEX_SUB_PART_LENGTH() Internal
#
# INTERNAL_AUTO_INCREMENT() 	Internal
#
# INTERNAL_AVG_ROW_LENGTH() 	Internal
#
# INTERNAL_CHECK_TIME() 		Internal
#
# INTERNAL_CHECKSUM() 			Internal
#
# INTERNAL_DATA_FREE() 			Internal
#
# INTERNAL_DATA_LENGTH() 		Internal
#
# INTERNAL_DD_CHAR_LENGTH() 	Internal
#
# INTERNAL_GET_COMMENT_OR_ERROR() Internal
#
# INTERNAL_GET_VIEW_WARNING_OR_ERROR() Internal
#
# INTERNAL_INDEX_COLUMN_CARDINALITY() Internal
#
# INTERNAL_INDEX_LENGTH() 		Internal
#
# INTERNAL_KEYS_DISABLED() 	INternal
#
# INTERNAL_MAX_DATA_LENGTH() 	Internal
#
# INTERNAL_TABLE_ROWS() 		internal
#
# INTERNAL_UPDATE_TIME() 		internal
#
# The functions listed in this section are intended only for internal use by teh server.
#
# Attempts by users to invoke them, results in an error.
#
# 		) CAN_ACCESS_COLUMN(ARGS)
#
# 		) CAN_ACCESS_DATABASE(ARGS)
#
# 		) CAN_ACCESS_TABLE(ARGS)
#
# 		) CAN_ACCESS_VIEW(ARGS)
#
# 		) GET_DD_COLUMN_PRIVILEGES(ARGS)
#
# 		) GET_DD_CREATE_OPTIONS(ARGS)
#
# 		) GET_DD_INDEX_SUB_PART_LENGTH(ARGS)
#
# 		) INTERNAL_AUTO_INCREMENT(ARGS)
#
# 		) INTERNAL_AVG_ROW_LENGTH(ARGS)
#
# 		) INTERNAL_CHECK_TIME(ARGS)
#
# 		) INTERNAL_CHECKSUM(ARGS)
#
# 		) INTERNAL_DATA_FREE(ARGS)
#
# 		) INTERNAL_DATA_LENGTH(ARGS)
#
# 		) INTERNAL_DD_CHAR_LENGTH(ARGS)
#
# 		) INTERNAL_GET_COMMENT_OR_ERROR(ARGS)
#
# 		) INTERNAL_GET_VIEW_WARNING_OR_ERROR(ARGS)
#
# 		) INTERNAL_INDEX_COLUMN_CARDINALITY(ARGS)
#
# 		) INTERNAL_INDEX_LENGTH(ARGS)
#
# 		) INTERNAL_KEYS_DISABLED(ARGS)
#
# 		) INTERNAL_MAX_DATA_LENGTH(ARGS)
#
# 		) INTERNAL_TABLE_ROWS(ARGS)
#
# 		) INTERNAL_UPDATE_TIME(ARGS)
#
# 		) IS_VISIBLE_DD_OBJECT(ARGS)
#
# 12.23 MISCELLANEOUS FUNCTIONS
#
# TABLE 12.29 MISCELLANEOUS FUNCTIONS
#
# 		NAME 									DESCRIPTION
# ANY_VALUE() 			Suppress ONLY_FULL_GROUP_BY value rejection
#
# BIN_TO_UUID() 		Convert binary UUID to string
#
# DEFAULT() 			Return the default value for a table column
#
# GROUPING() 			Distinguish super-aggregate ROLLUP rows from regular rows
#
# INET_ATON() 			Return the numeric value of an IP address
#
# INET_NTOA() 			Return the IP address from a numeric value
#
# INET6_ATON() 		Return the numeric value of an IPv6 address
#
# INET6_NTOA() 		Return the IPv6 address from a numeric value
#
# IS_IPV4() 			Whether argument is an IPv4 address
#
# IS_IPV4_COMPAT() 	Whether argument is an IPv4-compatible address
#
# IS_IPV4_MAPPED() 	Whether argument is an IPV4-mapped address
#
# IS_IPV6() 			Whether argument is an IPv6 address
#
# IS_UUID() 			Whether argument is a valid UUID
#
# MASTER_POS_WAIT() 	Block until the slave has read and applied all updates up to teh specific position
#
# NAME_CONST() 		Cause the column to have the given name
#
# RAND() 				Return a random floating-point value
#
# SLEEP() 				Sleep for a number of seconds
#
# UUID() 				Returns a Universal Unique Identifier (UUID)
#
# UUID_SHORT() 		Return an integer-valued universal identifier
#
# UUID_TO_BIN() 		Convert string UUID to binary
#
# VALUES() 				Defines the values to be used during an INSERT
#
# 		) ANY_VALUE(arg)
#
# 			THis function is useful for GROUP BY queries when the ONLY_FULL_GROUP_BY SQL mode is enabled,
# 			for cases when MySQL rejects a query that you know is valid for reasons that MySQL
# 			cannot determine.
#
# 			The function return value  and type are the same as the return value and type of its argument,
# 			but the function result is not checked for the ONLY_FULL_GROUP_BY SQL mode.
#
# 			For example, if name is a nonindexed column, the following query fails with
# 			ONLY_FULL_GROUP_BY enabled:
#
# 				SELECT name, address, MAX(age) FROM t GROUP BY name;
# 				ERROR 1055 (42000): Expression #2 of SELECT list is not
# 				in GROUP BY clause and contains nonaggregated column
# 				'mydb.t.address' which is not functionally dependent
# 				on columns in GROUP BY clause; this is incompatible
# 				with sql_mode=only_full_group_by
#
# 			THe failure occurs because address is a nonaggregated column that is
# 			neither named among GROUP BY columns nor functionally dependent on them.
#
# 			As a result, the address value for rows within each name group is nondeterminsitic.
#
# 			There are multiple ways to cause MySQL to accept the query:
#
# 				) Alter the table to make name a primary key or a unique NOT NULL column.
#
# 					This enables MySQL to determine that address is functionally dependent
# 					on name;
#
# 					That is, address is uniquely determined by name. (This technique is inapplicable if NULL
# 					must be permitted as a valid name value)
#
# 				) Use ANY_VALUE() to refer to address:
#
# 					SELECT name, ANY_VALUE(address), MAX(age) FROM t GROUP BY name;
#
# 					In this case, MySQL ignores teh nondeterminism of address values within
# 					each name group and accepts the query.
#
# 					This may be useful if you simply do not care which value of a nonaggregated
# 					column is chosen for each group.
#
# 					ANY_VALUE() is not an aggregate function, unlike functions such as SUM()
# 					or COUNT()
#
# 					It simply acts to suppress the test for nondeterminism
#
# 				) Disable ONLY_FULL_GROUP_BY.
#
# 					This is equivalent to using ANY_VALUE() with ONLY_FULL_GROUP_BY enabled,
# 					as described in previous time.
#
# 			ANY_VALUE() is also useful if funcitonal dependence exists between columns but
# 			MySQL cannot determine it.
#
# 			The following query is valid because age is functionally dependent
# 			on the grouping column age-1, but MySQL cannot tell that and rejects
# 			the query with ONLY_FULL_GROUP_BY enabled:
#
# 				SELECT age FROM t GROUP BY age-1;
#
# 			To cause MySQL to accept the query, use ANY_VALUE():
#
# 				SELECT ANY_VALUE(age) FROM t GROUP BY age-1;
#
# 			ANY_VALUE() can be used for queries that refer to aggregate functions
# 			in the absence of a GROUP BY clause:
#
# 				SELECT name, MAX(age) FROM t;
# 				ERROR 1140 (42000): In aggregated query without GROUP BY, expression
# 				#1 of SELECT list contains nonaggregated column 'mydb.t.name'; this
# 				is incompatible with sql_mode=only_full_group_by
#
# 			Without GROUP BY, there is a single group and it is nondeterminsitic which name value
# 			to choose for the group.
#
# 			ANY_VALUE() tells MySQL to accept the query:
#
# 				SELECT ANY_VALUE(name), MAX(age) FROM t;
#
# 			It may be that, due to some property of a given data set, you know that a selected
# 			nonaggregated column is effectively functionally dependent on a GROUP BY column.
#
# 			For example, an application may enforce uniqueness of one column with respect
# 			to another.
#
# 			In this case, using ANY_VALUE() for hte effectively functioanlly dependent
# 			column may make sense.
#
# 			For additional discussion, see SECTION 12.20.3, "MySQL HANDLING OF GROUP BY"
#
# 		) BIN_TO_UUID(binary uuid), BIN_TO_UUID(binary uuid, swap flag)
#
# 			BIN_TO_UUID() is the inverse of UUID_TO_BIN()
#
# 			It converts a binary UUID to a string UUID and returns the result.
#
# 			The binary value should be a UUID as a VARBINARY(16) value
#
# 			The return value is a utf8 string of five hexadecimal numbers separated
# 			by dashes.
#
# 			(For details about this format, see the UUID() function description)
#
# 			If the UUID argument is NULL, the return value is NULL.
#
# 			If any argument is invalid, an error occurs.
#
# 			BIN_TO_UUID() takes one orw two arguments:
#
# 				) The one-argument form takes a binary UUID value.
#
# 					the UUID value is assumed not to have its time-low and time-high
# 					parts swapped.
#
# 					The string result is in the same order as the binary argument.
#
# 				) The two argument form takes a binary UUID value and a swap-flag value:
#
# 					) If swap_flag is 0, the two-argument form is equivalent to the one-argument form.
#
# 						The string result is in the same order as the binary argument.
#
# 					) If swap_flag is 1, the UUID value is assumed to have its time-low and time-high parts
# 						swapped.
#
# 						These parts are swapped back to their original position in the result value.
#
# 				For usage examples and information about time-part swapping, see the UUID_TO_BIN() function description.
#
# 		) DEFAULT(col name)
#
# 			Returns the default value for a table column. An error results if the column has no default value.
#
# 			The use of DEFAULT(col name) to specify the default value for a named column is permitted
# 			only for columns that have a literal default value, not for columns that have an expression
# 			default value.
#
# 				UPDATE t SET i = DEFAULT(i)+1 WHERE id < 100;
#
# 		) FORMAT(X,D)
#
# 			Formats the number X to a format like '#,###,###.##', rounded to D decimal places,
# 			and returns the result as a string.
#
# 			For details, see SECTION 12.5, "STRING FUNCTIONS"
#
# 		) GROUPING(expr [, expr] ---)
#
# 			For GROUP BY queries that include a WITH ROLLUP modifier, the ROLLUP operation
# 			produces super-aggregate output rows where NULL represents the set of all values.
#
# 			The GROUPING() function enables you to distinguish NULL values for super-aggregate rows
# 			from NULL values in regular grouped rows.
#
# 			GROUPING() is permitted only in the select list or HAVING clause.
#
# 			Each argument to GROUPING() must be an expression that exactly matches an expression
# 			in the GROUP BY clause.
#
# 			The expression cannot be a positional specifier.
#
# 			For each expression, GROUPING() produces 1 if the expression value in the
# 			current row is a NULL representing a super-aggregate value.
#
# 			Otherwise, GROUPING() produces 0, indicating that the expression value
# 			is a NULL for a regular result row or is not NULL.
#
# 			Suppose that table t1 contains these rows, where NULL indicates something
# 			like "other" or "unknown"
#
# 				SELECT * FROM t1;
# 				+--------+------------+-----------------+
# 				| name   | size 		 | quantity 		 |
# 				+--------+------------+-----------------+
# 				| ball   | small 		 | 10 				 |
# 				| ball   | large 		 | 20 				 |
# 				| ball   | NULL 		 | 5 					 |
# 				| hoop   | small 		 | 15 				 |
# 				| hoop   | large 		 | 5 					 |
# 				| hoop   | NULL 		 | 3 					 |
# 				+--------+------------+-----------------+
#
# 			A summary of the table without WITH ROLLUP looks like this:
#
# 				SELECT name, size, SUM(quantity) AS quantity
# 				FROM t1
# 				GROUP BY name, size;
# 				+--------+---------+-----------+
# 				| name   | size 	 | quantity  |
# 				+--------+---------+-----------+
# 				| ball   | small   | 10 		 |
# 				| ball   | large   | 20 		 |
# 				| ball   | NULL    | 5 			 |
# 				| hoop   | small   | 15 		 |
# 				| hoop   | large   | 5 			 |
# 				| hoop   | NULL 	 | 3 			 |
# 				+--------+---------+-----------+
#
# 			The result contains NULL values, but those do not represent super-aggregate rows because the
# 			query does not include WITH ROLLUP.
#
# 			adding WITH ROLLUP produces super-aggregate summary rows containing additional NULL values.
#
# 			However, without comparing this result to the previous one, it is not easy to see
# 			which NULL values occur in super-aggregate rows and which occur in regular grouped rows:
#
# 				SELECT name, size, SUM(quantity) AS quantity
# 				FROM t1
# 				GROUP BY name, size WITH ROLLUP;
# 				+--------+--------+----------------+
# 				| name   | size 	| quantity 		  |
# 				+--------+--------+----------------+
# 				| ball   | NULL   | 	5 				  |
# 				| ball   | large  |  20 			  |
# 				| ball   | small  |  10 			  |
# 				| ball   | NULL   | 	35 			  |
# 				| hoop   | NULL 	| 	3 				  |
# 				| hoop   | large  |  5 				  |
# 				| hoop   | small  |  15 			  |
# 				| hoop   | NULL   | 	23 			  |
# 				| NULL   | NULL   | 	58 			  |
# 				+--------+--------+----------------+
#
# 			To distinguish NULL values in super-aggregate rows from those in regular grouped rows,
# 			use GROUPING(), which returns 1 only for super-aggregate NULL values:
#
# 				SELECT
# 					name, size, SUM(quantity) AS quantity,
# 					GROUPING(name) AS grp_name,
# 					GROUPING(size) AS grp_size
# 				FROM t1
# 				GROUP BY name, size WITH ROLLUP;
# 				+-------+--------+------------------+-----------------+--------------------+
# 				| name  | size   | quantity 			| grp_name 			| grp_size 				|
# 				+-------+--------+------------------+-----------------+--------------------+
# 				| ball  | NULL   | 		5 				| 			0 			| 		0 					|
# 				| ball  | large  | 		20 			| 			0 			| 		0 					|
# 				| ball  | small  | 		10 			| 			0 			| 		0 					|
# 				| ball  | NULL   | 		35 			| 			0 			| 		1 					|
# 				| hoop  | NULL   | 		3 				| 			0 			| 		0 					|
# 				| hoop  | large  | 		5 				| 			0 			| 		0 					|
# 				| hoop  | small  | 		15 			| 			0 			| 		0 					|
# 				| hoop  | NULL   | 		23 			| 			0 			| 		1 					|
# 				| NULL  | NULL   | 		58 			| 			1 			| 		1 					|
# 				+-------+--------+------------------+-----------------+--------------------+
#
# 			Common uses for GROUPING():
#
# 				) Substitute a label for super-aggregate NULL values:
#
# 					SELECT
# 						IF(GROUPING(name) = 1, 'All items', name) AS name,
# 						IF(GROUPING(size) = 1, 'All sizes', size) AS size,
# 						SUM(quantity) AS quantity
# 					FROM t1
# 					GROUP BY name, size WITH ROLLUP;
# 					+-----------------+-------------------+---------------+
# 					| name 				| size 				  | quantity 		|
# 					+-----------------+-------------------+---------------+
# 					| ball 				| NULL 				  | 5 				|
# 					| ball 				| large 				  | 20 				|
# 					| ball 				| small 				  | 10 			   |
# 					| ball 				| All sizes 		  | 35 				|
# 					| hoop 				| NULL 				  | 3 				|
# 					| hoop 				| large 				  | 5 				|
# 					| hoop 				| small 				  | 15 			 	|
# 					| hoop 				| All sizes 		  | 23 				|
# 					| All items 		| All sizes 		  | 58 				|
# 					+-----------------+-------------------+---------------+
#
# 				) Return only super-aggregate lines by filtering out the regular grouped lines:
#
# 					SELECT name, size, SUM(quantity) AS quantity
# 					FROM t1
# 					GROUP BY name, size WITH ROLLUP
# 					HAVING GROUPING(name) = 1 OR GROUPING(size) = 1;
# 					+-----------+-----------+-----------------+
# 					| name 		| size 		| quantity 			|
# 					+-----------+-----------+-----------------+
# 					| ball 		| NULL 		| 35 					|
# 					| hoop      | NULL 		| 23 					|
# 					| NULL 		| NULL 		| 58 					|
# 					+-----------+-----------+-----------------+
#
# 			GROUPING() permits multiple expression arguments. In this case, the GROUPING()
# 			return value represents a bitmask combined from the results for each expression,
# 			where the lowest-order bit corresponds to the result for the rightmost expression.
#
# 			For example, with three expression arguments, GROUPING(expr1, expr2, expr3) is evaluated
# 			like this:
#
# 				result for GROUPING(expr3)
# 			 + result for GROUPING(expr2) << 1
# 			 + result for GROUPING(expr1) << 2
#
# 			The following query shows how GROUPING() results for single arguments combine for 
# 			a multiple-argument call to produce a bitmask value:
#
# 				SELECT 
# 					name, size, SUM(quantity) AS quantity,
# 					GROUPING(name) AS grp_name,
# 					GROUPING(size) AS grp_size,
# 				GROUPING(name, size) AS grp_all
# 				FROM t1
# 				GROUP BY name, size WITH ROLLUP;
# 				+--------+------------+------------------+-------------+----------+--------------+
# 				| name   | size 		 | quantity 		  | grp_name    | grp_size | grp_all 		|
# 				+--------+------------+------------------+-------------+----------+--------------+
# 				| ball   | NULL 		 | 5 					  | 0 			 | 	0 		| 	0 			   |
# 				| ball   | large 		 | 20 				  | 0 			 | 	0 		|  0 				|
# 				| ball   | small 		 | 10 				  | 0 			 | 	0 		|  0 			   |
# 				| ball   | NULL 		 | 35 				  | 0 			 | 	1 		| 	1 				|
# 				| hoop   | NULL 		 | 3 					  | 0 			 | 	0 		|  0 				|
# 				| hoop   | large 		 | 5 					  | 0 			 | 	0 		| 	0 				|
# 				| hoop 	| small 		 | 15 				  | 0 			 | 	0 		|  0 				|
# 				| hoop   | NULL 		 | 23 				  | 0 			 | 	1 		| 	1 				|
# 				| NULL 	| NULL 		 | 58 				  | 1 			 | 	1 		|  3 				|
# 				+--------+------------+------------------+-------------+----------+--------------+
#
# 			With multiple expression arguments, the GROUPING() return value is nonzero if any expression
# 			represents a super-aggregate value.
#
# 			Multiple-argument GROUPING() syntax thus provides a simpler way to write the earlier query
# 			that returned only super-aggregate rows, by using a single multiple-argument GROUPING()
# 			call rather than multiple single-argument calls:
#
# 				SELECT name, size, SUM(quantity) AS quantity
# 				FROM t1
# 				GROUP BY name, size WITH ROLLUP
# 				HAVING GROUPING(name, size) <> 0;
# 				+--------+--------+--------------+
# 				| name   | size   | quantity 		|
# 				+--------+--------+--------------+
# 				| ball   | NULL   | 35 				|
# 				| hoop   | NULL   | 23 				|
# 				| NULL   | NULL   | 58 				|
# 				+--------+--------+--------------+
#
# 			Use of GROUPING() is subject to these limitations:
#
# 				) Do not use subquery GROUP BY expressions as GROUPING() arguments because
# 					matching might fail.
#
# 					For example, matching fails for this query:
#
# 						SELECT GROUPING((SELECT MAX(name) FROM t1))
# 						FROM t1
# 						GROUP BY (SELECT MAX(name) FROM t1) WITH ROLLUP;
# 						ERROR 3580 (HY000): Argument #1 of GROUPING function is not in GROUP BY
#
# 				) GROUP BY literal expressions should not be used within a HAVING clause as
# 					GROUPING() arguments.
#
# 					Due to differences between when the optimizer evaluates GROUP BY and HAVING,
# 					matching may succeed but GROUPING() evaluation does not produce the expected
# 					result.
#
# 					Consider this query:
#
# 						SELECT a AS f1, 'w' AS f2
# 						FROM t
# 						GROUP BY f1, f2 WITH ROLLUP
# 						HAVING GROUPING(f2) = 1;
#
# 					GROUPING() is evaluated earlier for the literal constant expression than for the
# 					HAVING clause as a whole and returns 0.
#
# 					To check whether a query such as this is affected, use EXPLAIN and look for
# 					Impossible having in the Extra column.
#
# 					For more information about WITH ROLLUP and GROUPING(), see SECTION 12.20.2, "GROUP BY MODIFIERS"
#
# 		) INET_ATON(expr)
#
# 			Given the dotted-quad representation of an IPv4 network address as a string, returns an integer that
# 			represents the numeric value of the address in network byte order (big endian) 
#
# 			INET_ATON() returns NULL if it does not understand its argument.
#
# 				SELECT INET_ATON('10.0.5.9');
# 					-> 167773449
#
# 			For this example, the return value is calculated as 10x256^3 + 0x256^2+5x256+9
#
# 			INET_ATON() may or may not return a non-NULL result for short-form IP addresses (such as '127.1'
# 			as a representation of '127.0.0.1')
#
# 			Because of this, INET_ATON() a should not be used for such addresses.
#
# 				NOTE:
#
# 					To store values generated by INET_ATON(), use an INT UNSIGNED column rather than
# 					INT, which is signed.
#
# 					If you use a signed column, values corresponding to IP addresses for which the
# 					first octet is greater than 127 cannot be stored correctly.
#
# 					See SECTION 11.2.6, "OUT-OF-RANGE AND OVERFLOW HANDLING"
#
# 		) INET_NTOA(expr)
#
# 			Given a numeric IPv4 network address in network byte order, returns the dotted-quad string
# 			representation of the address as a string in the connection character set.
#
# 			INET_NTOA() returns NULL if it does not understand its argument.
#
# 				SELECT INET_NTOA(16777349);
# 					-> '10.0.5.9'
#
# 		) INET6_ATON(expr)
#
# 			Given an IPv6 or IPv4 network address as a string, returns a binary string
# 			that represents the numeric value of the address in network byte order
# 			(big endian)
#
# 			Because numeric-format IPv6 addresses require more bytes than the largest
# 			integer type, the representation returned by this function has the VARBINARY
# 			data type:
#
# 				VARBINARY(16) for IPv6 addresses and VARBINARY(4) for IPv4 addresses.
#
# 			If the argument is not a valid address, INET6_ATON() returns NULL
#
# 			The following examples use HEX() to display the INET6_ATON() result in
# 			printable form:
#
# 				SELECT HEX(INET6_ATON('fde::5a55:caff:fefa:9089'));
# 					-> 'FDFE000000000000005A55CAFFFEFA9089'
# 				SELECT HEX(INET6_ATON('10.0.5.9'));
# 					-> '0A000509'
#
# 			INET6_ATON() observes several constraints on valid arguments.
#
# 			These are given in the following list along with examples.
#
# 				) A trailing zone ID is not permitted, as in fe80::3%1 or fe80::3%eth0
#
# 				) A trailing network mask is not permitted, as in 2001:45f:3:ba::/64 or 198.51.100.0/24
#
# 				) For values representing IPv4 addresses, only classless addresses are supported.
#
# 					Classful addresses such as 198.51.1 are rejected
#
# 					A trailing port number is not permitted, as in 198.51.100.2:8080
#
# 					Hexadecimal numbers in address components are not permitted, as in 198.0xa0.1.2
#
# 					Octal numbers are not supported:
#
# 						198.51.010.1 is treated as 198.51.10.1, not 198.51.8.1
#
# 					These IPv4 constraints also apply to IPv6 addresses that have IPv4 address
# 					parts, such as IPv4-compatible or IPv4-mapped addresses.
#
# 			To convert an IPv4 address expr represented in numeric form as an INT value to an
# 			IPv6 address represented in numeric form as a VARBINARY value, use this expression:
#
# 				INET6_ATON(INET_NTOA(expr))
#
# 			For example:
#
# 				SELECT HEX(INET6_ATON(INET_NTOA(167773449)));
# 					-> '0A000509'
#
# 		) INET6_NTOA(expr)
#
# 			Given an IPv6 or IPv4 network address represented in numeric form as a binary string,
# 			returns the string representation of the address as a string in the connection char set.
#
# 			If the argument is not a valid address, INET6_NTOA() returns NULL
#
# 			INET6_NTOA() has these properties:
#
# 				) It does not use operating system functions to perform conversions, thus the output string is platform independent.
#
# 				) The return string has a maximum length of 39(4x8 + 7)
#
# 					Given this statement:
#
# 						CREATE TABLE t AS SELECT INET6_NTOA(expr) AS c1;
#
# 					The resulting table would have this definition:
#
# 						CREATE TABLE t (c1 VARCHAR(39) CHARACTER SET utf8 DEFAULT NULL);
#
# 				) The return string uses lowercase letters for IPv6 addresses.
#
# 					SELECT INET6_NTOA(INET6_ATON('fdfe::5a55:caff:fefa:9089'));
# 						-> 'fdfe::5a55:caff:fefa:9089'
#
# 					SELECT INET6_NTOA(INET6_ATON('10.0.5.9'));
# 						-> '10.0.5.9'
#
# 					SELECT INET6_NTOA(UNHEX('FDFE0000000000000000000005A55CAFFFEFA9089'));
# 						-> 'fdfe::5a55:caff:fefa:9089'
#
# 					SELECT INET6_NTOA(UNHEX('0A000509'));
# 						-> '10.0.5.9'
#
# 			) IS_IPV4(expr)
#
# 				Returns 1 if the argument is a valid IPv4 address specified as a string. Otherwise 0
#
# 					SELECT IS_IPV4('10.0.5.9'), IS_IPV4('10.0.5.256');
# 						-> 1, 0
#
# 				For a given argument, if IS_IPV4() returns 1, INET_ATON() (and INET6_ATON()) will return
# 				non-NULL
#
# 				THe converse statement is not true: In some cases, INET_ATON() returns non-NULL
# 				when IS_IPV4() returns 0
#
# 				As implied by the preceding remarks, IS_IPV4() is more strict than INET_ATON() about what
# 				constitutes a valid IPV4 address, so it may be useful for applications that need to
# 				perform strong checks against invalid values.
#
# 				Alternatively, use INET6_ATON() to convert IPv4 addresses to internal form and check for
# 				a NULL result (which indicates an invalid address)
#
# 				INET6_ATON() is equally strong as IS_IPV4() about checking IPv4 addresses.
#
# 			) IS_IPV4_COMPAT(expr)
#
# 				This function takes an IPv6 address represented in numeric form as a binary string,
# 				as returned by INET6_ATON()
#
# 				It returns 1 if the argument is a valid IPv4-compatible IPv6 address, 0 otherwise.
#
# 				IPv4-compatible addresses have the form ::ipv4_address
#
# 					SELECT IS_IPV4_COMPAT(INET6_ATON('::10.0.5.9'));
# 						-> 1
# 					SELECT IS_IPV4_COMPAT(INET6_ATON('::ffff:10.0.5.9'));
# 						-> 0
#
# 				The IPv4 part of an IPv4-compatible address can also be represented using hexadecimal notation.
#
# 				For example, 198.51.100.1, has this raw hexadecimal value:
#
# 					SELECT HEX(INET6_ATON('198.51.100.1'));
# 						-> 'C6336401'
#
# 				Expressed in IPv4-compatible form, ::198.51.100.1 is equivalent to
# 				::c0a8:0001 or (without leading zeros) ::c0a8:1
#
# 					SELECT
# 						IS_IPV4_COMPAT(INET6_ATON('::198.51.100.1')),
# 						IS_IPV4_COMPAT(INET6_ATON('::c0a8:0001')),
# 						IS_IPV4_COMPAT(INET6_ATON('::c0a8:1'));
# 							-> 1, 1, 1
#
# 			) IS_IPV4_MAPPED(expr)
#
# 				This function takes an IPv6 address represented in numeric form as a binary string,
# 				as returned by INET6_ATON()
#
# 				It returns 1 if the argument is a valid IPV4-mapped IPV6 address, 0 otherwise.
#
# 				IPv4-mapped addresses have the form ::ffff:ipv4_address
#
# 					SELECT IS_IPV4_MAPPED(INET6_ATON('::10.0.5.9'));
# 						-> 0
# 					SELECT IS_IPV4_MAPPED(INET6_ATON('::ffff:10.0.5.9'));
# 						-> 1
#
# 				As with IS_IPV4_COMPAT() the IPv4 part of an IPv4-mapped address can
# 				also be represented using hexadecimal notation:
#
# 					SELECT
# 						IS_IPV4_MAPPED(INET6_ATON('::ffff:198.51.100.1')),
# 						IS_IPV4_MAPPED(INET6_ATON('::ffff:c0a8:0001')),
# 						IS_IPV4_MAPPED(INET6_ATON('::ffff:c0a8:1'));
# 							-> 1, 1, 1
#
# 			) IS_IPV6(expr)
#
# 				Returns 1 if the argument is a valid IPv6 address specified as a string, 0 otherwise.
#
# 				This function does not consider IPv4 addresses to be valid IPv6 addresses.
#
# 					SELECT IS_IPV6('10.0.5.9'), IS_IPV6('::1');
# 						-> 0, 1
#
# 				For a given argument, if IS_IPV6() returns 1, INET6_ATON() will return non-NULL
#
# 			) IS_UUID(string uuid)
#
# 				Returns 1 if the argument is a valid string-format UUID, 0 if the argument is not a valid
# 				UUID, and NULL if the argument is NULL
#
# 				"Valid" means that the value is in a format that can be parsed.
#
# 				That is, has the correct length and contains only the permitted characters
# 				(hexadecimal digits in any lettercase and optionally, dashes and curly braces)
#
# 				This format is most common:
#
# 					aaaaaaaaaa-bbbb-cccc-dddd-eeeeeeeeee
#
# 				These other formats are also permitted:
#
# 					aaaaaaaabbbbccccddddeeeeeeeeee
# 					{aaaaaaaaaa-bbbb-cccc-dddd-eeeeeeeeee}
#
# 				For the meanings of fields within the value, see the UUID() function description.
#
# 					SELECT IS_UUID('6ccd780c-baba-1026-9564-5b8c656024db');
# 					+-------------------------------------------------------+
# 					| IS_UUID('6ccd780c-baba-1026-9564-5b8c656024db') 		  |
# 					+-------------------------------------------------------+
# 					| 									1 									  |
# 					+-------------------------------------------------------+
#
# 					SELECT IS_UUID('6CCD780C-BABA-1026-9564-5B8C656024DB');
# 					+-------------------------------------------------------+
# 					| IS_UUID('6ccd780cbaba102695645b8c656024db') 			  |
# 					+-------------------------------------------------------+
# 					| 									1 									  |
# 					+-------------------------------------------------------+
#
# 					SELECT IS_UUID('6ccd780cbaba102695645b8c656024db');
# 					+-------------------------------------------------------+
# 					| IS_UUID('6ccd780cbaba102695645b8c656024db') 			  |
# 					+-------------------------------------------------------+
# 					| 									1 									  |
# 					+-------------------------------------------------------+
#
# 					SELECT IS_UUID('{6ccd780c-baba-1026-9564-5b8c656024db}');
# 					+----------------------------------------------------+
# 					| IS_UUID('{6ccd780c-baba-1026-9564-5b8c656024db}')  |
# 					+----------------------------------------------------+
# 					| 							1 										  |
# 					+----------------------------------------------------+
#
# 					SELECT IS_UUID('6ccd780c-baba-1026-9564-5b8c6560');
# 					+------------------------------------------------+
# 					| IS_UUID('6ccd780c-baba-1026-9564-5b8c6560') 	 |
# 					+------------------------------------------------+
# 					| 							0 									 |
# 					+------------------------------------------------+
#
# 					SELECT IS_UUID(RAND());
# 					+----------------------+
# 					| IS_UUID(RAND()) 	  |
# 					+----------------------+
# 					| 				0 			  |
# 					+----------------------+
#
# 		) MASTER_POS_WAIT(log name, log pos [, timeout][, channel])
#
# 			This function is useful for control of master/slave synchronization.
#
# 			It blocks until the slave has read and applied all updates up to the specified
# 			position in the master log.
#
# 			The return value is the number of log events the slave had to wait for advance
# 			to the specified position.
#
# 			The function returns NULL if the slave SQL thread is not started, the slave's
# 			master information is not initialized, the arguments are incorrect, or an error
# 			occurs.
#
# 			It returns -1 if the timeout has been exceeded.
#
# 			If the slave SQL thread stops while MASTER_POS_WAIT() is waiting, the function
# 			returns NULL.
#
# 			If the slave is past the specified position, the function returns immediately.
#
# 			On a multithreaded slave, the function waits until expiry of the limit set by the
# 			slave_checkpoint_group or slave_checkpoint_period system variable, when the checkpoint
# 			operation is called to update the status of the slave.
#
# 			Depending on the setting for the system variables, the function might therefore
# 			return some time after the specified position was reached.
#
# 			If a timeout value is specified, MASTER_POS_WAIT() stops waiting when timeout
# 			seconds have elapsed.
#
# 			timeout must be greater than 0; a zero or negative timeout means no timeout.
#
# 			The optional channel value enables you to name which replication channel the function
# 			applies to.
#
# 			See SECTION 17.2.3, "REPLICATION CHANNELS" for more information.
#
# 			This function is unsafe for statement-based replication. A warning is logged if you
# 			use this function when binlog_format is set to STATEMENT.
#
# 		) NAME_CONST(name, value)
#
# 			Returns the given value. When used to produce a result set column, NAME_CONST() causes
# 			the column to have the given name.
#
# 			The arguments should be constants.
#
# 				SELECT NAME_CONST('myname', 14);
# 				+----------+
# 				| myname   |
# 				+----------+
# 				| 14 		  |
# 				+----------+
#
# 			This function is for internal use only.
#
# 			THe server uses it when writing statements from stored programs that contain
# 			references to local program variables, as described in SECTION 24.7, "BINARY LOGGING OF STORED PROGRAMS"
#
# 			You might see this function in the output from mysqlbinlog
#
# 			For your applications, you can obtain exactly the same result as in the example just shown
# 			by using simple aliasing, like this:
#
# 				SELECT 14 AS myname;
# 				+-------------------+
# 				| myname 			  |
# 				+-------------------+
# 				| 		14 			  |
# 				+-------------------+
# 				1 row in set (0.00 sec)
#
# 			See SECTION 13.2.10, "SELECT SYNTAX" for more information about column aliases.
#
# 		) SLEEP(duration)
#
# 			SLeeps (pauses) for the number of seconds given by the duration argument, then returns 0.
#
# 			The duration may have a fractional part.
#
# 			If the argument is NULL or negative, SLEEP() produces a warning, or an error
# 			in strict SQL mode.
#
# 			When sleep returns normally (without interupption), it returns 0:
#
# 				SELECT SLEEP(1000);
# 				+-----------------------+
# 				| SLEEP(1000) 				|
# 				+-----------------------+
# 				| 			0 					|
# 				+-----------------------+
#
# 			When SLEEP() is the only thing invoked by a query that is interuppted, it returns
# 			1 and the query itself returns no error.
#
# 			This is true whether the query is killed or times out:
#
# 				) This statement is interrupted using KILL_QUERY from another session:
#
# 					SELECT SLEEP(1000);
# 					+------------------+
# 					| SLEEP(1000) 		 |
# 					+------------------+
# 					| 			1 			 |
# 					+------------------+
#
# 				) This statement is interrupted by timing out:
#
# 					SELECT /*+ MAX_EXECUTION_TIME(1) */ SLEEP(1000);
# 					+-------------------+
# 					| SLEEP(1000) 		  |
# 					+-------------------+
# 					| 			1 			  |
# 					+-------------------+
#
# 			When SLEEP() is only part of a query that is interrupted, the query returns an error:
#
# 				) This statement is interrupted using KILL_QUERY from another session:
#
# 					SELECT 1 FROM t1 WHERE SLEEP(1000);
# 					ERROR 1317 (70100): Query execution was interrupted
#
# 				) This statement is interrupted by timing out:
#
# 					SELECT /*+ MAX_EXECUTION_TIME(1000) */ 1 FROM t1 WHERE SLEEP(1000);
# 					ERROR 3024 (HY000): Query execution was interrupted, maximum statement
# 					execution time exceeded
#
# 			This function is unsafe for statement-based replication.
#
# 			A warning is logged if you use this function when binlog_format is set
# 			to STATEMENT.
#
# 		) UUID()
#
# 			Returns a Universal Unique Identifier (UUID) generated according to RFC 4122,
# 			"A Universally Unique Identifier (UUID) URN Namespace" (<link>)
#
# 			A UUID is designed as a number that is globally unique in space and time.
#
# 			Two calls to UUID() are expected to generate two different values, even if these
# 			calls are performed on two separate devices not connected to each other.
#
# 				WARNING
#
# 					Although UUID() values are intended to be unique, they are not necessarily unguessable
# 					or unpredictable.
#
# 					If unpreidctability is required, UUID() values should be generated some other way.
#
# 			UUID() returns a value that conforms to UUID version 1 as described in RFC 4122.
#
# 			The value is a 128-bit number represented as a utf8 string of five hexadecimal numbers in
# 			aaaaaaaa-bbbb-cccc-dddd-eeeeeeee format:
#
# 				) The first three numbers are generated from the low, middle and high parts of a timestamp.
#
# 					The high part also includes the UUID version number.
#
# 				) The fourth number preserves temporal uniqueness in case the timestamp value loses monotonicity
# 					(for example, due to daylight saving time)
#
# 				) The fifth number is an IEEE 802 node number that provides spatial uniqueness.
#
# 				A random number is substituted if the latter is not available (for example, because the host device
# 				has no Ethernet card, or it is unknown how to find the hardware address of an interface on the host
# 				operating system)
#
# 				In this case, spatial uniqueness cannot be guaranteed.
#
# 				Nevertheless, a collision should have very low probability.
#
# 				The MAC address of an interface is taken into account only on FreeBSD and Linux
#
# 				On other operating systems, MySQL uses a randomly generated 48-bit number.
#
# 					SELECT UUID();
# 						-> '6ccd780c-baba-1026-9564-5b8c656024db'
#
# 			To convert between string and binary UUID values, use the UUID_TO_BIN() and
# 			BIN_TO_UUID() functions.
#
# 			TO check whether a string is a valid UUID value, use the IS_UUID() function.
#
# 			NOTE:
#
# 				UUID() does not work with statement-based replication
#
# 		) UUID_SHORT()
#
# 			Returns a "short" universal identifier as a 64-bit unsigned integer.
#
# 			Values returned by UUID_SHORT() differ from the string-format 128-bit
# 			identifiers returned by the UUID() function and have different uniqueness
# 			properties.
#
# 			The value of UUID_SHORT() is guaranteed to be unique if the following conditions hold:
#
# 				) The server_id value of the current server is between 0 and 255 and is unique among your
# 					set of master and slave servers
#
# 				) You do not set back the system time for your server host between mysqld restarts
#
# 				) You invoke UUID_SHORT() on average fewer than 16 million times per second between mysqld restarts
#
# 			The UUID_SHORT() return value is constructed this way:
#
# 				(server_id & 255) << 56
# 			 + (server_startup_time_in_seconds << 24)
# 			 + incremented_variable++;
#
# 				SELECT UUID_SHORT();
# 					-> 92395783831158784
#
# 			NOTE:
#
# 				UUID_SHORT() does not work with statement-based replication
#
# 		) UUID_TO_BIN(string uuid), UUID_TO_BIN(string uuid, swap flag)
#
# 			Converts a string UUID to a binary UUID and returns the result.
#
# 			(The IS_UUID() function description lists the permitted string UUID formats)
#
# 			THe return binary UUID is a VARBINARY(16) value
#
# 			If the UUID argument is NULL, the return value is NULL.
#
# 			If any argument is invalid, an error occurs.
#
# 			UUID_TO_BIN() takes one or two arguments:
#
# 				) The one-argument form takes a string UUID value. The binary result is in the same
# 					order as the string argument.
#
# 				) The two-argument form takes a string UUID value and a flag value:
#
# 					) If swap_flag is 0, the two-argument form is equivalent to the one-argument form.
#
# 						The binary result is in the same order as the string argument.
#
# 					) If swap_flag is 1, the format of the return value differs:
#
# 						The time-low and time-high parts (the first and third groups of hexadecimal digits,
# 						respectively) are swapped.
#
# 						This moves the more rapidly varying part to the right and can improve indexing efficiency
# 						if the result is stored in an indexed column.
#
# 			Time-part swapping assumes the use of UUID version 1 values, such as are generated by the UUID()
# 			function.
#
# 			For UUID values produced by other means that do not follow version 1 format, time-part swapping
# 			provides no benefit.
#
# 			For details about version 1 format, see the UUID() function description.
#
# 			Suppose that you have the following string UUID value:
#
# 				SET @uuid = '6ccd780c-baba-1026-9564-5b8c656024db';
#
# 			To convert the string UUID to binary with or without time-part swapping,
# 			use UUID_TO_BIN():
#
# 				SELECT HEX(UUID_TO_BIN(@uuid));
# 				+-------------------------------------+
# 				| HEX(UUID_TO_BIN(@uuid)) 				  |
# 				+-------------------------------------+
# 				| 6CCD780CBABA102695645B8C656024DB 	  |
# 				+-------------------------------------+
#
# 				SELECT HEX(UUID_TO_BIN(@uuid, 0));
# 				+-------------------------------------+
# 				| HEX(UUID_TO_BIN(@uuid, 0)) 			  |
# 				+-------------------------------------+
# 				| 6CCD780CBABA102695-> ETC 			  |
# 				+-------------------------------------+
#
# 				SELECT HEX(UUID_TO_BIN(@uuid, 1));
# 				+-------------------------------------+
# 				| HEX(UUID_TO_BIN(@uuid, 1)) 			  |
# 				+-------------------------------------+
# 				| 1026BABA6CCD780C95645B8C656024DB 	  |
# 				+-------------------------------------+
#
# 			To convert a binary UUID returned by UUID_TO_BIN() to a string UUID,
# 			use BIN_TO_UUID() 
#
# 			If you produce a binary UUID by calling UUID_TO_BIN() with a second
# 			argument of 1 to swap time parts, you should also pass a second argument
# 			of 1 to BIN_TO_UUID() to unswap the time parts when converting the binary
# 			UUID back to a string UUID:
#
# 				SELECT BIN_TO_UUID(UUID_TO_BIN(@uuid));
# 				+---------------------------------------+
# 				| BIN_TO_UUID(UUID_TO_BIN(@uuid)) 		 |
# 				+---------------------------------------+
# 				| 6ccd780c-baba-1026-9564-5b8c656024db  |
# 				+---------------------------------------+
#
# 				SELECT BIN_TO_UUID(UUID_TO_BIN(@uuid,0),0);
# 				+---------------------------------------+
# 				| BIN_TO_UUID(UUID_TO_BIN(@uuid,0),0) 	 |
# 				+---------------------------------------+
# 				| 6ccd780c-baba-1026-9564-5b8c656024db  |
# 				+---------------------------------------+
#
# 				SELECT BIN_TO_UUID(UUID_TO_BIN(@uuid,1),1);
# 				+---------------------------------------+
# 				| BIN_TO_UUID(UUID_TO_BIN(@uuid,1),1) 	 |
# 				+---------------------------------------+
# 				| 6ccd780c-baba-1026-9564-5b8c656024db  |
# 				+---------------------------------------+
#
# 			If the use of time-part swapping is not the same for the conversion
# 			in both directions, the original UUID will not be recovered properly:
#
# 				SELECT BIN_TO_UUID(UUID_TO_BIN(@uuid,0),1);
# 				+---------------------------------------+
# 				| BIN_TO_UUID(UUID_TO_BIN(@uuid,0),1)   |
# 				+---------------------------------------+
# 				| baba1026-780c-6ccd-9564-5b8c656024db  |
# 				+---------------------------------------+
#
# 				SELECT BIN_TO_UUID(UUID_TO_BIN(@uuid,1),0);
# 				+---------------------------------------+
# 				| BIN_TO_UUID(UUID_TO_BIN(@uuid,1),0)   |
# 				+---------------------------------------+
# 				| 1026baba-6ccd-780c-9564-5b8c656024db  |
# 				+---------------------------------------+
#
# 		) VALUES(col name)
#
# 			In an INSERT_---_ON_DUPLICATE_KEY_UPDATE statement, you can use the VALUES(col_name)
# 			function in the UPDATE clause to refer to column values from the INSERT portion of the
# 			statement.
#
# 			In other words, VALUES(col_name) in the UPDATE clause refers to the value of col_name
# 			that would be inserted, had no duplicate-key conflict occurred.
#
# 			This function is especially useful in multiple-row inserts
#
# 			The VALUES() function is meaningful only in the ON DUPLICATE KEY UPDATE clause of
# 			INSERT statements and returns NULL otherwise.
#
# 			See SECTION 13.2.6.2, "INSERT --- ON DUPLICATE KEY UPDATE SYNTAX"
#
# 				INSERT INTO table (a,b,c) VALUES (1,2,3),(4,5,6)
# 					-> ON DUPLICATE KEY UPDATE c=VALUES(a)+VALUES(b);
#
# 12.24 PRECISION MATH
#
# 12.24.1 TYPES OF NUMERIC VALUES
# 12.24.2 DECIMAL DATA TYPE CHARACTERISTICS
# 12.24.3 EXPRESSION HANDLING
# 12.24.4 ROUNDING BEHAVIOR
# 12.24.5 PRECISION MATH EXAMPLES
#
# MySQL provides support for precision math: numeric value handling that results in extremely
# accurate results and a high degree control over invalid values.
#
# Precision math is based on these two features:
#
# 		) SQL modes that control how strict the server is about accepting or rejecting invalid data.
#
# 		) The MySQL library for fixed-point arithmetic
#
# These features have several implications for numeric operations and provide a high degree of
# compliance with standard SQL:
#
# 		) Precise calculations: For exact-value numbers, calculations do not introduce floating-point errors.
#
# 			Instead, exact precision is used.
#
# 			For example, MySQL treats a number such as .0001 as an exact value rather than as an approximation,
# 			and summing it 10,000 times produces a result of exactly 1, not a value that is merely "close" to 1.
#
# 		) Well-defined rounding behavior. For exact-value numbers, the result of ROUND() depends on its argument,
# 			not on environmental factors such as how the underlying C library works.
#
# 		) Platform independence: Operations on exact numeric values are the same across different platforms such as Windows and Unix.
#
# 		) Control over handling of invalid values: Overflow and division by zero are detectable and can be treated as errors.
#
# 			For example, you can treat a value that is too large for a column as an error rather than having the value
# 			truncated to lie within the range of the columns data type.
#
# 			SImilarly, you can treat division by zero as an error rather than as an operation that produces a result
# 			of NULL.
#
# 			The choice of which approach to take is determined by the setting of the server SQL mode.
#
# The following discussion covers several aspects of how precision math works, including possible incomatibilities
# with older applications.
#
# At the end, some examples are given that demonstrate how MySQL handles numeric operations precisely.
#
# For information about controlling the SQL mode, see SECTION 5.1.11, "SERVER SQL MODES"
#
# 12.24.1 TYPES OF NUMERIC VALUES
#
# The scope of precision math for exact-value operations includes the exact-value data types
# (integer and DECIMAL types) and exact-value numeric literals.
#
# Approximate-value data types and numeric literals are handled as floating-point numbers.
#
# Exact-value numeric literals have an integer part or fractional part, or both.
#
# They may be signed. Examples: 1, .2, 3.4, -5, -6.78, +9.10
#
# Approximate-value numeric literals are represented in scientific notation with a mantissa
# and exponent.
#
# Either or both parts may be signed. Examples: 1.2E3, 1.2E-3, -1.2E3, -1.2E-3
#
# Two numbers that look similar may be treated differently.
#
# For example, 2.34 is an exact-value (fixed-point) number, whereas 2.34E0 is an
# approximate value (floating-point) number
#
# The DECIMAL data type is a fixed-point type and calculations are exact.
#
# In MySQL, the DECIMAL type has several synonyms: NUMERIC, DEC, FIXED.
#
# The integer types also are exact-value types.
#
# The FLOAT and DOUBLE data types are floating-point types and calculations
# are approximate.
#
# In MySQL, types that are synonymous with FLOAT or DOUBLE are DOUBLE_PRECISION
# and REAL.
#
# 12.24.2 DECIMAL DATA TYPE CHARACTERISTICS
#
# This section discusses the characteristics of the DECIMAL data type (and its synonyms),
# with particular regard to the following topics:
#
# 		) Maximum number of digits
#
# 		) Storage format
#
# 		) Storage requirements
#
# 		) The nonstandard MySQL extension to the upper range of DECIMAL columns
#
# The declaration syntax for a DECIMAL column is DECIMAL(M,D)
#
# The ranges of values for the arguments are as follows:
#
# 		) M is the maximum number of digits (the precision). Has a range of 1 to 65
#
# 		) D is the number of digits to the right of the decimal point (the scale). Range of 0 to 30, must be no larger than M.
#
# If D is omitted, the default is 0. If M is omitted, the default is 10.
#
# The maximum value of 65 for M means that calculations on DECIMAL values are accurate up to
# 65 digits.
#
# This limit of 65 digits of precision also applies to exact-value numeric literals,
# so the maximum range of such literals differs from before.
#
# Values for DECIMAL columns are stored using a binary format that packs nine decimal
# digits into 4 bytes.
#
# The storage requirements for the integer and fractional parts of each value are determined
# separately.
#
# Each multiple of nine digits requires 4 bytes, and any remaining digits left over require some
# fraction of 4 bytes.
#
# The storage required for remaining digits is given by the following table.
#
# LEFTOVER DIGITS 				NUMBER OF BYTES
#
# 0 									0
#
# 1-2 								1
#
# 3-4 								2
#
# 5-6 								3
#
# 7-9 								4
#
# For example, a DECIMAL (18,9) column has nine digits on either side of the decimal point,
# so the integer part and the fractional part each require 4 bytes.
#
# A DECIMAL(20,6) column has fourteen integer digits and six fractional digits.
#
# The integer digits require four bytes for nine of the digits and 3 bytes for the remaining
# five digits.
#
# THe six fractional digits require 3 bytes.
#
# DECIMAL columns do not store a leading + character or - character or leading 0 digits.
#
# If you insert +0003.1 into a DECIMAL(5,1) column, it is stored as 3.1
#
# For negative numbers, a literal - character is not stored.
#
# DECIMAL columns do not permit values larger than the range implied by the column definition.
#
# For example, a DECIMAL(3,0) column supports a range of -999 to 999
#
# A DECIMAL(M,D) column permits up to M - D digits to the left of the decimal point.
#
# The SQL standard requires that the precision of NUMERIC(M,D) be exactly M digits.
#
# For DECIMAL(M,D), the standard requires a precision of at least M digits but permits
# more.
#
# In MySQL, DECIMAL(M,D) and NUMERIC(M,D) are the same, and both have a precision
# of exactly M digits.
#
# For a full explanation of the internal format of DECIMAL values, see the file
# strings/decimal.c in a MySQL source distrib.
#
# The format is explained (with an example) in the decimal2bin() function.
#
# 12.24.3 EXPRESSION HANDLING
#
# With precision math, exact-value numbers are used as given whenever possible.
#
# For example, numbers in comparisons are used exactly as given without a change in
# value.
#
# In strict SQL mode, for INSERT into a column with an exact data type (DECIMAL or integer),
# a number is inserted with its exact value if it is within the column range.
#
# When retrieved, the value should be the same as what was inserted.
#
# (If strict SQL mode is not enabled, truncation for INSERT is permissible)
#
# Handling of a numeric expression depends on what kind of values the expression contains:
#
# 		) If any approximate values are present, the expression is approximate and is evaluated using floating-point arithmetic
#
# 		) If no approximate value are present, the expression contains only exact values.
#
# 			If any exact value contains a fractional part (a value following the decimal point),
# 			the expression is evaluated using DECIMAL exact arithmetic and has a precision of 65 digits.
#
# 			The term "exact" is subject to the limits of what can be represented in binary.
#
# 			For example, 1.0/3.0 can be approximated in decimal notation as .333---, but not written
# 			as an exact number, so (1.0/3.0)*3.0 does not evaluate to exactly 1.0
#
# 		) Otherwise, the expression contains only integer values.
#
# 			The expression is exact and is evaluated using integer arithmetic and has a precision
# 			the same as BIGINT(64 bits)
#
# If a numeric expression contains any strings, they are converted to double-precision floating-point
# values and the expression is approximate.
#
# Inserts into numeric columns are affected by the SQL mode, which is controlled by the sql_mode system
# variable.
#
# (See SECTION 5.1.11, "SERVER SQL MODES")
#
# The following discussion mentions strict mode (selected by the STRICT_ALL_TABLES or STRICT_TRANS_TABLES
# mode values) and ERROR_FOR_DIVISION_BY_ZERO
#
# To turn on all restrictions, you can simply use TRADITIONAL mode, which includes both strict mode values
# and ERROR_FOR_DIVISION_BY_ZERO:
#
# 		SET sql_mode='TRADITIONAL';
#
# If a number is inserted inot an exact type column (DECIMAL or integer), it is inserted with its exact
# value if it is within the column range and precision.
#
# If the value has too many digits in the fractional part, rounding occurs and a note is generated.
#
# Rounding is done as described in SECTION 12.24.4, "ROUNDING BEHAVIOR"
#
# Truncation due to rounding of the fractional part is not an error, even in strict mode.
#
# If te value has too many digits in the integer part, it is too large (out of range) and is
# handled as follows:
#
# 		) If strict mode is not enabled, the value is truncated to the nearest legal value and a warning is generated.
#
# 		) If strict mode is enabled, an overflow error occurs.
#
# Underflow is not detected, so underflow handling is undefined.
#
# For inserts of strings into numeric columns, conversion from string to number is handled as follows
# if the string has nonnumeric contents:
#
# 		) A string that does not begin with a number cannot be used as a number and pproduces an error in strict mode,
# 			or a warning otherwise.
#
# 			This includes the empty string.
#
# 		) A string that begins with a number can be converted, but the trailing nonnumeric portion is truncated.
#
# 		If the truncated portion contains anything other than spaces, this produces an error in strict mode,
# 		or a warning otherwise.
#
# By default, division by zero produces a result of NULL and no warning.
#
# By setting the SQL mode appropriately, division by zero can be restricted.
#
# With the ERROR_FOR_DIVISION_BY_ZERO SQL mode enabled, MySQL handles division by zero differently:
#
# 		) if strict mode is not enabled, a warning occurs
#
# 		) If strict mode is enabled, inserts and updates involving division by zero are prohibited, and an error occurs.
#
# In other words, inserts and updates involving expressions that perform division by zero can be treated as errors,
# but this requires ERROR_FOR_DIVISION_BY_ZERO in addition to strict mode.
#
# Suppose that we have this statement:
#
# 		INSERT INTO t SET i = 1/0;
#
# This is what happens for combinations of strict and ERROR_FOR_DIVISION_BY_ZERO modes.
#
# 		sql_mode VALUE 				RESULT
#
# ''(Default) 							No warning, no error; i is set to NULL
#
# strict 								No warning, no error; i is set to NULL
#
# ERROR_FOR_DIVISION_BY_ZERO 		Warning, no error; i is set to NULL
#
# strict, ERROR_FOR_DIVISION_BY_ZERO Error condition; no row is inserted.
#
# 12.24.4 ROUNDING BEHAVIOR
#
# This section discusses precision math rounding for the ROUND() function and for
# inserts into columns with exact-value types (DECIMAL and integer)
#
# The ROUND() function rounds differently depending on whether its argument is exact
# or approximate:
#
# 		) For exact-value numbers, ROUND() uses the "round half up" rule:
#
# 			A value with a fractional part of .5 or greater is rounded up to the next
# 			integer if positive or down to the next integer if negative.
#
# 			(IN other words, it is rounded away from zero)
#
# 			A value with a fractional part less than .5 is rounded down to the next
# 			integer if positive or up to the next integer if negative.
#
# 			(In other words, it is rounded toward zero)
#
# 		) For approximate-value numbers, the result depends on the C library.
#
# 			On many systems, this means that ROUND() uses the "round to nearest even" rule:
#
# 				A value with a fractional part exactly half way between two integers is rounded
# 				to the nearest even integer.
#
# The following example shows how rounding differs for exact and approximate values:
#
# 		SELECT ROUND(2.5), ROUND(25E-1);
# 		+------------+------------------+
# 		| ROUND(2.5) | ROUND(25E-1) 	  |
# 		+------------+------------------+
# 		| 3 			 | 	2 				  |
# 		+------------+------------------+
#
# For inserts into a DECIMAL or integer column, the target is an exact data type, so rounding
# uses "round half away from zero", regardless of whether the value to be inserted is exact
# or approximate:
#
# 		CREATE TABLE t (d DECIMAL(10,0));
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		INSERT INTO t VALUES(2.5),(2.5E0);
# 		Query OK, 2 rows affected, 2 warnings (0.00 sec)
# 		Records: 2 Duplicates: 0 Warnings: 2
#
# 		SHOW WARNINGS;
# 		+---------+----------+------------------------------------------------+
# 		| Level   | Code     | Message 													 |
# 		+---------+----------+------------------------------------------------+
# 		| Note 	 | 1265 		| Data truncated for column 'd' at row 1 			 |
# 		| Note 	 | 1265 		| Data truncated for column 'd' at row 2 			 |
# 		+---------+----------+------------------------------------------------+
# 		2 rows in set (0.00 sec)
#
# 		SELECT d FROM t;
# 		+-----------+
# 		| d 			|
# 		+-----------+
# 		| 3 			|
# 		| 3 			|
# 		+-----------+
# 		2 rows in set (0.00 sec)
#
# The SHOW_WARNINGS statement displays the notes that are generated by truncation due to rounding
# of the fractional part.
#
# Such truncation is not an error, even in strict SQL mode (see SECTION 12.24.3, "EXPRESSION HANDLING")
#
# 12.24.5 PRECISION MATH EXAMPLES
#
# This section provides some examples that show precision math query results in MySQL.
#
# These examples demonstrates the principles described in SECTION 12.24.3, "EXPRESSION HANDLING",
# and SECTION 12.24.4, "ROUNDING BEHAVIOR"
#
# EXAMPLE 1.
#
# Numbers are used with their exact values as given when possible:
#
# 		SELECT (.1 + .2) = 3;
# 		+---------------------+
# 		| (.1 + .2) = .3      |
# 		+---------------------+
# 		| 				1 			 |
# 		+---------------------+
#
# For floating-point values, results are inexact:
#
# 		SELECT (.1E0 + .2E0) = .3E0;
# 		+-----------------------------+
# 		| (.1E0 + .2E0) = .3E0 			|
# 		+-----------------------------+
# 		| 					0 					|
# 		+-----------------------------+
#
# ANother way to see the difference in exact and approximate value handling is to add
# a small number to a sum many times.
#
# Consider the following stored procedure, which adds .0001 to a variable 1.000 times
#
# CREATE PROCEDURE p ()
# BEGIN
# 		DECLARE i INT DEFAULT 0;
# 		DECLARE d DECIMAL(10,4) DEFAULT 0;
# 		DECLARE f FLOAT DEFAULT 0;
# 		WHILE i < 10000 DO
# 			SET d = d + .0001;
# 			SET f = f + .0001E0;
# 			SET i = i + 1;
# 		END WHILE;
# 		SELECT d, f;
# END;
#
# The sum for both d and f logically should be 1, but that is true only for decimal calculation.
#
# The floating-point calculation introduces small errors:
#
# 		+-------------+-------------------------------+
# 		| d 			  | 	f 									 |
# 		+-------------+-------------------------------+
# 		| 1.0000      | 0.99999999999991 				 |
# 		+-------------+-------------------------------+
#
# Example 2
#
# Multiplication is performed with the scale required by standard SQL.
#
# That is, for two numbers X1 and X2 that have scale S1 and S2, the scale
# of the result is S1 + S2:
#
# 		SELECT .01 * .01;
# 		+---------------+
# 		| .01 * .01 	 |
# 		+---------------+
# 		| 0.0001 		 |
# 		+---------------+
#
# Example 3
#
# Rounding behavior for exact-value numbers is well-defined:
#
# 		Rounding behavior (for example, with the ROUND() function) is independent of the implementation
# 		of the underlying C library, which means that results are consistent from platform to platform.
#
# 			) Rounding for exact-value columns (DECIMAL and integer) and exact-valued numbers uses the "round half away from zero" rule.
#
# 				A value with a fractional part of .5 or greater is rounded away from zero to the nearest
# 				integer, as shown here:
#
# 					SELECT ROUND(2.5), ROUND(-2.5);
# 					+---------------+------------------+
# 					| ROUND(2.5)    | ROUND(-2.5) 	  |
# 					+---------------+------------------+
# 					| 3 				 | -3 				  |
# 					+---------------+------------------+
#
# 			) Rounding for floating-point values uses the C library, which on many systems uses the
# 				"round to nearest even" rule.
#
# 				A value with a fractional part exactly half way between two integers is rounded to
# 				the nearest even integer:
#
# 					SELECT ROUND(2.5E0), ROUND(-2.5E0);
# 					+-------------+-------------------+
# 					| ROUND(2.5E0)| ROUND(-2.5E0) 	 |
# 					+-------------+-------------------+
# 					| 		2 		  | 		-2 			 |
# 					+-------------+-------------------+
#
# Example 4
#
# In strict mode, inserting a value that is out of range for a column causes an error,
# rather than truncation to a legal value.
#
# When MySQL is not running in strict mode, truncation to a legal value occurs:
#
# 		SET sql_mode='';
# 		Query OK,, 0 rows affected (0.00 sec)
#
# 		CREATE TABLE t (i TINYINT);
# 		Query OK, 0 rows affected (0.01 sec)
#
# 		INSERT INTO t SET i = 128;
# 		Query OK, 1 row affected, 1 warning (0.00 sec)
#
# 		SELECT i FROM t;
# 		+----------+
# 		| 	i 		  |
# 		+----------+
# 		| 127 	  |
# 		+----------+
#
# However, an error occurs if strict mode is in effect:
#
# 		SET sql_mode='STRICT_ALL_TABLES';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		CREATE TABLE t (i TINYINT);
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		INSERT INTO t SET i = 128;
# 		ERROR 1264 (22003): Out of range value adjusted for column 'i' at row 1
#
# 		SELECT i FROM t;
# 		Empty set (0.00 sec)
#
# Example 5
#
# In strict mode and with ERROR_FOR_DIVISION_BY_ZERO set, division by zero causes
# an error, not a result of NULL.
#
# In nonstrict mode, division by zero has a result of NULL:
#
# 		SET sql_mode='';
# 		Query OK, 0 rows affected (0.01 sec)
#
# 		CREATE TABLE t (i TINYINT);
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		INSERT INTO t SET i = 1 / 0;
# 		Query OK, 1 row affected (0.00 sec)
#
# 		SELECT i FROM t;
# 		+-----------+
# 		| i 			|
# 		+-----------+
# 		| NULL 		|
# 		+-----------+
# 		1 row in set (0.03 sec)
#
# However, division by zero is an error if the proper SQL modes are in effect:
#
# 		SET sql_mode='STRICT_ALL_TABLES, ERROR_FOR_DIVISION_BY_ZERO';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		CREATE TABLE t (i TINYINT);
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		INSERT INTO t SET = 1 / 0;
# 		ERROR 1365 (22012): Division by 0
#
# 		SELECT i FROM t;
# 		Empty set (0.01 sec)
#
# Example 6
#
# Exact-value literals are evaluted as exact values.
#
# Approximate-value literals are evaluated using floating-point, but exact-value
# literals are handled as DECIMAL:
#
# 		CREATE TABLE t SELECT 2.5 AS a, 25E-1 AS b;
# 		Query OK, 1 row affected (0.01 sec)
# 		Records: 1 Duplicates: 0 Warnings: 0
#
# 		DESCRIBE t;
# 		+---------+--------------------------------------+----------+----------+-----------------------+-----------+
# 		| Field 	 | Type 											 | Null 		| Key 	  | Default 				  | Extra 	  |
# 		+---------+--------------------------------------+----------+----------+-----------------------+-----------+
# 		| a 		 | decimal(2,1) unsigned 					 | NO       | 			  | 0.0 						  | 			  |
# 		| b 		 | double 										 | NO 		| 			  | 0 						  | 			  |
# 		+---------+--------------------------------------+----------+----------+-----------------------+-----------+
#
# Example 7
#
# If the argument to an aggregate function is an exact numeric type, the result is also an exact numeric type,
# with a scale at least that of the argument.
#
# Consider these statements:
#
# 		CREATE TABLE t (i INT, d DECIMAL, f FLOAT);
# 		INSERT INTO t VALUES(1,1,1);
# 		CREATE TABLE y SELECT AVG(i), AVG(d), AVG(f) FROM t;
#
# THe result is a double only for the floating-point argument.
#
# For exact type arguments, the result is also an exact type:
#
# 		DESCRIBE y;
# 		+----------+---------------------------+-------+---------+---------------+--------------+
# 		| Field 	  | Type 							| Null  | Key 	   | Default 		 | Extra 		 |
# 		+----------+---------------------------+-------+---------+---------------+--------------+
# 		| AVG(i)   | decimal(14,4) 				| YES   | 			| NULL 			 | 				 |
# 		| AVG(d)   | decimal(14,4) 				| YES   | 		   | NULL 			 | 				 |
# 		| AVG(f)   | double 							| YES   | 			| NULL 			 | 				 |
# 		+----------+---------------------------+-------+---------+---------------+--------------+
#
# The result is a double only for the floating-point argument.
#
# for exact type arguments, the result is also an exact type.
#
# CHAPTER 13 SQL STATEMENT SYNTAX
#
# TABLE OF CONTENTS
#
# 13.1 DATA DEFINITION STATEMENTS
# 13.2 DATA MANIPULATION STATEMENTS
# 13.3 TRANSACTIONAL AND LOCKING STATEMENTS
# 13.4 REPLICATION STATEMENTS
# 13.5 PREPARED SQL STATEMENT SYNTAX
# 13.6 COMPOUND-STATEMENT SYNTAX
# 13.7 DATABASE ADMINISTRATION STATEMENTS
# 13.8 UTILITY STATEMENTS
#
# This chapter describes the syntax for the SQL statements supported by MySQL.
#
# 13.1 DATA DEFINITION STATEMENTS
#
# 13.1.1 ATOMIC DATA DEFINITION STATEMENT SUPPORT
# 13.1.2 ALTER DATABASE SYNTAX
# 13.1.3 ALTER EVENT SYNTAX
# 13.1.4 ALTER FUNCTION SYNTAX
# 
# 13.1.5 ALTER INSTANCE SYNTAX
# 13.1.6 ALTER LOGFILE GROUP SYNTAX
# 13.1.7 ALTER PROCEDURE SYNTAX
# 13.1.8 ALTER SERVER SYNTAX
#
# 13.1.9 ALTER TABLE SYNTAX
# 13.1.10 ALTER TABLESPACE SYNTAX
# 13.1.11 ALTER VIEW SYNTAX
# 13.1.12 CREATE DATABASE SYNTAX
#
# 13.1.13 CREATE EVENT SYNTAX
# 13.1.14 CREATE FUNCTION SYNTAX
# 13.1.15 CREATE INDEX SYNTAX
# 13.1.16 CREATE LOGFILE GROUP SYNTAX
#
# 13.1.17 CREATE PROCEDURE AND CREATE FUNCTION SYNTAX
# 13.1.18 CREATE SERVER SYNTAX
# 13.1.19 CREATE SPATIAL REFERENCE SYSTEM SYNTAX
# 13.1.20 CREATE TABLE SYNTAX
#
# 13.1.21 CREATE TABLESPACE SYNTAX
# 13.1.22 CREATE TRIGGER SYNTAX
# 13.1.23 CREATE VIEW SYNTAX
# 13.1.24 DROP DATABASE SYNTAX
#
# 13.1.25 DROP EVENT SYNTAX
# 13.1.26 DROP FUNCTION SYNTAX
# 13.1.27 DROP INDEX SYNTAX
# 13.1.28 DROP LOGFILE GROUP SYNTAX
#
# 13.1.29 DROP PROCEDURE AND DROP FUNCTION SYNTAX
# 13.1.30 DROP SERVER SYNTAX
# 13.1.31 DROP SPATIAL REFERENCE SYSTEM SYNTAX
# 13.1.32 DROP TABLE SYNTAX
#
# 13.1.33 DROP TABLESPACE SYNTAX
# 13.1.34 DROP TRIGGER SYNTAX
# 13.1.35 DROP VIEW SYNTAX
# 13.1.36 RENAME TABLE SYNTAX
#
# 13.1.37 TRUNCATE TABLE SYNTAX
#
# 13.1.1 ATOMIC DATA DEFINITION STATEMENT SUPPORT
#
# MySQL 8.0 supports atomic Data Definition Language (DDL) statements.
#
# This feature is referred to as atomic DDL.
#
# AN atomic DDL statement combines the data dictionary updates, storage engine operations,
# and binary log writes associated with a DDL operation into a single, atomic transaction.
#
# The transaction is either committed, with applicable changes persisted to the data dictionary,
# storage engine and binary log, or is rolled back, even if the server halts during the operation.
#
# Atomic DDL is made possible by the introduction of the MySQL data dictionary in MySQL 8.0
#
# In earlier MySQL versions, metadata was stored in metadata files, nontransactional tables
# and storage engine-specific dictionaries, which necessitated intermediate commits.
#
# Centralized, transactional metadata storage provided by the MySQL data dictionary
# removed this barrier, making it possible to restructure DDL statement operations into
# atomic transactions.
#
# The atomic DDL feature is described under the following topics in this section:
#
# 		) Supported DDL statements
#
# 		) Atomic DDL characteristics
#
# 		) Changes in DDL Statement Behavior
#
# 		) Storage Engine Support
#
# 		) Viewing DDL Logs
#
# SUPPORTED DDL STATEMENTS
#
# The atomic DDL feature supports both table and non-table DDL statements.
#
# Table-related DDL operations require storage engine support, whereas non-table
# DDL operations do not.
#
# Currently, only the InnoDB storage engine supports atomic DDL.
#
# 		) Supported table DDL statements include CREATE ALTER, and DROP statements for databases,
# 			tablespaces, tables and indexes, and the TRUNCATE_TABLE statement.
#
# 		) Supported non-table DDL statements include:
#
# 			) CREATE and DROP statements, and, if applicable, ALTER statements for stored programs,
# 				triggers, views and user-defined functions (UDFs)
#
# 			) Account management statements: CREATE, ALTER, DROP and if applicable, RENAME
# 				statements for users and roles, as well as GRANT and REVOKE statements.
#
# The following statements are not supported by the atomic DDL feature:
#
# 		) Table-related DDL statements that involve a storage engine other than InnoDB
#
# 		) INSTALL_PLUGIN and UNINSTALL_PLUGIN statements
#
# 		) INSTALL_COMPONENT and UNINSTALL_COMPONENT statements
#
# 		) CREATE_SERVER, ALTER_SERVER and DROP_SERVER statements
#
# ATOMIC DDL CHARACTERISTICS
#
# The characteristics of atomic DDL statements include the following:
#
# 		) Metadata updates, binary log writes, and storage engine operations, where applicable, are combined into a single transaction.
#
# 		) There are no intermediate commits at the SQL layer during the DDL operation
#
# 		) Where applicable:
#
# 			) The state of data dictionary, routine, event and UDF caches is consistent with the status
# 				of the DDL operation, meaning that caches are updated to reflect whether or not the
# 				DDL operation was completed successfully or rolled back.
#
# 			) The storage engine method involved in a DDL operation do not perform intermediate commits,
# 				and the storage engine registers itself as part of the DDL transaction.
#
# 			) The storage engine supports redo and rollback of DDL operations, which is performed in the
# 				Post-DDL phase of the DDL operation.
#
# 		) The visible behavior of DDL operations is atomic, which changes the behavior of some DDL statements.
#
# 			See CHANGES IN DDL STATEMENT BEHAVIOR
#
# NOTE:
#
# 		DDL statements, atomic or otherwise, implicitly end any transaction that is active in the current session,
# 		as if you had done a COMMIT before executing the statement.
#
# 		This means that DDL statements cannot be performed within another transaction, within transaction control
# 		statements such as START TRANSACTION --- COMMIT, or combined with other statements within the same transaction.
#
# CHANGES IN DDL STATEMENT BEHAVIOR
#
# This section describes changes in DDL statement behavior due to the introduction of atomic DDL support.
#
# 		) DROP TABLE operations are fully atomic if all named tables use an atomic DDL-supported storage engine.
#
# 			The statement either drops all tables successfully or is rolled back.
#
# 			DROP TABLE fails with an error if a named table does not exist, and no changes are made, regardless
# 			of the storage engine.
#
# 			This change in behavior is demonstrated in the following example, where the DROP TABLE statement
# 			fails because a named table does not exist:
#
# 				CREATE TABLE t1 (c1 INT);
# 				DROP TABLE t1, t2;
# 				ERROR 1051 (42S02): Unknown table 'test.2'
# 				SHOW TABLES;
# 				+--------------------+
# 				| Tables_in_test 		|
# 				+--------------------+
# 				| t1 					   |
# 				+--------------------+
#
# 			Prior to the introduction of atomic DDL, DROP TABLE reports an error for the named table
# 			that does not exist but succeeds for the named table that does exist:
#
# 				CREATE TABLE t1 (c1 INT);
# 				DROP TABLE t1, t2;
# 				ERROR 1051 (42S02): Unknown table 'test.t2'
# 				SHOW TABLES;
# 				Empty set (0.00 sec)
#
# 			NOTE:
#
# 				Due to this change in behavior, a partially completed DROP TABLE statement on a MySQL 5.7
# 				master fails when replicated on a MySQL 8.0 slave
#
# 				To avoid this failure scenario, use IF EXISTS syntax in DROP TABLE statements to prevent errors
# 				from occurring for tables that do not exist.
#
# 		) DROP_DATABASE is atomic if all tables use an atomic DDL-supported storage engine.
#
# 			The statement either drops all objects successfully or is rolled back.
#
# 			However, removal of the database directory from the file system occurs last
# 			and is not part of the atomic transaction.
#
# 			If removal of the database directory fails due to a file system error
# 			or server halt, the DROP DATABASE transaction is not rolled back.
#
# 		) For tables that do not use an atomic DDL-supported storage engine, table deletion
# 			occur outside of the atomic DROP_TABLE or DROP_DATABASE transaction.
#
# 			Such table deletions are written to the binary log individually, which limits the
# 			discrepancy between the storage engine, data dictionary, and binary log to one table
# 			at most in the case of an interrupted DROP_TABLE or DROP_DATABASE operation.
#
# 			For operations that drop multiple tables, the tables that do not use an atomic
# 			DDL-supported storage engine are dropped before tables that do.
#
# 		) CREATE_TABLE, ALTER_TABLE, RENAME_TABLE, TRUNCATE_TABLE, CREATE_TABLESPACE,
# 			and DROP_TABLESPACE operations for tables that use an atomic DDL-supported
# 			storage engine are either fully committed or rolled back if the server halts
# 			during their operation.
#
# 			In earlier MySQL releases, interruption of these operations could cause discrepancies
# 			between the storage engine, data dictionary and binary log, or leave behind
# 			orphan files.
#
# 			RENAME_TABLE operations are only atomic if all named tables use an atomic
# 			DDL-supported storage engine.
#
# 		) DROP_VIEW fails if a named view does not exist, and no changes are made.
#
# 			The change in behavior is demonstrated in this example, where the
# 			DROP_VIEW statement fails because a named view does not exist:
#
# 				CREATE VIEW test.viewA AS SELECT * FROM t;
# 				DROP VIEW test.viewA, test.viewB;
# 				ERROR 1051 (42S02): Unknown table 'test.viewB'
# 				SHOW FULL TABLES IN test WHERE TABLE_TYPE LIKE 'VIEW';
# 				+-----------------+-------------------+
# 				| Tables_in_test  | Table_type 		  |
# 				+-----------------+-------------------+
# 				| viewA 				| VIEW 				  |
# 				+-----------------+-------------------+
#
# 			Prior to the introduction of atomic DDL, DROP_VIEW returns an error for
# 			the named view that does not exist but succeeds for the named view that
# 			does exist:
#
# 				CREATE VIEW test.viewA AS SELECT * FROM t;
# 				DROP VIEW test.viewA, test.viewB;
# 				ERROR 1051 (42S02): Unknown table 'test.viewB'
# 				SHOW FULL TABLES IN test WHERE TABLE_TYPE LIKE 'VIEW';
# 				Empty set (0.00 sec)
#
# 			NOTE:
#
# 				Due to this change in behavior, a partially completed DROP_VIEW
# 				on a MySQL 5.7 master fails when replicated on a MySQL 8.0 slave.
#
# 				To avoid this failure scenario, use IF EXISTS syntax in DROP_VIEW
# 				statements to prevent an error from occurring for views that do not
# 				exist.
#
# 		) Partial execution of account management statements is no longer permitted.
#
# 			Account management statements either succeed for all named users or roll back
# 			and have no effect if an error occurs.
#
# 			In earlier MySQL versions, account management statements that name multiple
# 			users could succeed for some users and fail for others.
#
# 			The change in behavior is demonstrated in this example, where the second
# 			CREATE_USER statement returns an error but fails because it cannot succeed
# 			for all named users:
#
# 				CREATE USER userA;
# 				CREATE USER userA, userB;
# 				ERROR 1396 (HY000): Operation CREATE USER failed for 'userA'@'%'
# 				SELECT User FROM mysql.user WHERE User LIKE 'user%';
# 				+-------------+
# 				| User 		  |
# 				+-------------+
# 				| userA 		  |
# 				+-------------+
#
# 			Prior to the introduction of atomic DDL, the second CREATE USER statement
# 			returns an error for the named user that does not exist but succeeds
# 			for the named user that does exist:
#
# 				CREATE USER userA;
# 				CREATE USER userA, userB;
# 				ERROR 1396 (HY000): Operation CREATE USER failed for 'userA'@'%'
# 				SELECT User FROM mysql.user WHERE User LIKE 'user%';
# 				+----------+
# 				| User 	  |
# 				+----------+
# 				| userA 	  |
# 				| userB    |
# 				+----------+
#
# 			NOTE:
#
# 				Due to this change in behavior, partially completed account management
# 				statements on a MySQL 5.7 master fail when replicated on a MySQL 8.0 Slave.
#
# 				To avoid this failure scenario, use IF EXISTS or IF NOT EXISTS syntax,
# 				as appropriate, in account management statements to prevent errors related
# 				to named users.
#
# STORAGE ENGINE SUPPORT
#
# Currently, only the InnoDB storage engine supports atomic DDL.
#
# Storage engines that do not support atomic DDL are exempted from DDL
# atomicity.
#
# DDL operations involving exempted storage engines remain capable
# of introducing inconsistencies that can occur when operations are interuppted
# or only partially completed.
#
# To support redo and rollback of DDL operations, InnoDB writes DDL logs to
# the mysql.innodb_ddl_log table, which is a hidden data dictionary table that
# resides in the mysql.ibd data dictionary tablespace.
#
# To view DDL logs that are written to the mysql.innodb_ddl_log table during
# a DDL operation, enable the innodb_print_ddl_logs configuration option.
#
# For more information, see VIEWING DDL LOGS.
#
# NOTE:
#
# 		THe redo logs for changes to the mysql.innodb_ddl_log table are flushes to disk
# 		immediately regardless of the innodb_flush_log_at_trx_commit setting.
#
# 		Flushing the redo logs immediately avoids situations where data files are modified
# 		by DDL operations but the redo logs for changes to the mysql.innodb_ddl_log
# 		table resulting from those operations are not persisted to disk.
#
# 		SUch a situation could cause errors during rollback or recovery.
#
# The InnoDB storage engine executes DDL operations in phases.
#
# DDL operations such as ALTER_TABLE may perform the Prepare and Perform
# phases multiple times prior to the Commit phase.
#
# 		1. Prepare: Create hte required objects and write the DDL logs to the
# 			mysql.innodb_ddl_log table
#
# 			The DDL logs define how to roll forward and roll back the DDL
# 			operation
#
# 		2. Perform: Perform the DDL operation. For example, perform a create routine for a CREATE TABLE operation.
#
# 		3. Commit: Update the data dictionary and commit the data dictionary transaction
#
# 		4. Post-DDL: Replay and remove DDL logs from the mysql.innodb_ddl_log table.
#
# 			To ensure that rollback can be performed safely without introducing inconsistencies,
# 			file operations such as renaming or removing data files are performed in
# 			this final phase.
#
# 			This phase also removes dynamic metadata from the mysql.innodb_dynamic_metadata
# 			data dictionary table for DROP_TABLE, TRUNCATE_TABLE and other DDL operations
# 			that rebuild the table.
#
# DDL logs are replayed and removed from the mysql.innodb_ddl_log table during the
# Post-DDL phase, regardless of whether the transaction is committed or rolled back.
#
# DDL logs should only remain in the mysql.innodb_ddl_log table if the server is halted
# during a DDL operation.
#
# In this case, the DDL logs are replayed and removed after recovery.
#
# In a recovery situation, a DDL transaction may be committed or rolled back when
# the server is restarted.
#
# If the data dictionary transaction that was performed during the Commit phase of a
# DDL operation is present in the redo log and binary log, the operation is considered
# successful and is rolled forward.
#
# Otherwise, the incomplete data dictionary transaction is rolled back when InnoDB
# replays data dictionary redo logs, and the DDL transaction is rolled back.
#
# VIEWING DDL LOGS
#
# To view DDL logs that are written to the mysql.innodb_ddl_log data dictionary
# table during atomic DDL operations that involve the InnoDB storage engine, enable
# innodb_print_ddl_logs to have MySQL write the DDL logs to stderr.
#
# Depending on the host operating system and MySQL configuration, stderr may be the
# error log, terminal or console window.
#
# See SECTION 5.4.2.2, "DEFAULT ERROR LOG DESTINATION CONFIGURATION"
#
# InnoDB writes DDL logs to the mysql.innodb_ddl_log table to support redo and
# rollback of DDL operations.
#
# The mysql.innodb_ddl_log table is a hidden data dictionary table that resides
# in the mysql.ibd data dictionary tablespace.
#
# Like other hidden data dictionary tables, the mysql.innodb_ddl_log table cannot
# be accessed directly in non-debug versions of MySQL.
#
# (See SECTION 14.1, "DATA DICTIONARY SCHEMA")
#
# The structure of the mysql.innodb_ddl_log table corresponds to this definition:
#
# 		CREATE TABLE mysql.innodb_ddl_log (
# 			id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 			thread_id BIGINT UNSIGNED NOT NULL,
# 			type INT UNSIGNED NOT NULL,
# 			space_id INT UNSIGNED,
# 			page_no INT UNSIGNED,
# 			index_id BIGINT UNSIGNED,
# 			table_id BIGINT UNSIGNED,
# 			old_file_path VARCHAR(512) COLLATE UTF8_BIN,
# 			new_file_path VARCHAR(512) COLLATE UTF8_BIN,
# 			KEY(thread_id)
# 		);
#
# 		) id: A unique identifier for a DDL log record
#
# 		) thread_id: Each DDL log record is assigned a thread_id which is used to replay and remove
# 			DDL logs that belong to a particular DDL transaction.
#
# 			DDL transactions that involve multiple data file operations generate multiple DDL log records.
#
# 		) type: The DDL operation type. Types include FREE (drop an index tree), DELETE (delete a file),
# 			RENAME (rename a file), or DROP (drop metadata from the mysql.innodb_dynamic_metadata data dictionary
# 			table)
#
# 		) space_id: The tablespace ID
#
# 		) page_no: A page that contains allocation information; an index tree root page, for example.
#
# 		) index_id: The index ID
#
# 		) table_id: The table ID
#
# 		) old_file_path: The old tablespace file path. Used by DDL operations that create or drop tablespace
# 			files; also used by DDL operations that rename a tablespace.
#
# 		) new_file_path: The new tablespace file path. Used by DDL operations that rename tablespace files.
#
# THis example demonstrates enabling innodb_print_ddl_logs to view DDL logs written to stderr for
# a CREATE TABLE operation.
#
# 		SET GLOBAL innodb_print_ddl_logs=1;
# 		CREATE TABLE t1 (c1 INT) ENGINE = InnoDB;
#
# 		[Note] [000000] InnoDB: DDL log insert : [DDL record: DELETE SPACE, id=18, thread_id=7,
# 		space_id=5, old_file_path=./test/t1.ibd]
# 		[Note] [000000] InnoDB: DDL log delete : by id 18
#
# 		[Note] [000000] InnoDB: DDL log insert : [DDL record: REMOVE CACHE, id=19, thread_id=7,
# 		table_id=1058, new_file_path=test/t1]
# 		[Note] [000000] InnoDB: DDL log delete : by id 19
#
# 		[Note] [000000] InnoDB: DDL log insert : [DDL record: FREE, id=20, thread_id=7,
# 		space_id=5, index_id=132, page_no=4]
# 		[Note] [000000] InnoDB: DDL log delete : by id 20
#
# 		[Note] [000000] InnoDB: DDL log post ddl : begin for thread id : 7
# 		[Note] [000000] InnoDB: DDL log post ddl : end for thread id : 7
#
# 13.1.2 ALTER DATABASE SYNTAX
#
# ALTER {DATABASE | SCHEMA} [db_name]
# 		alter_specification ---
#
# alter_specification:
# 		[DEFAULT] CHARACTER SET [=] charset_name
# 	 | [DEFAULT] COLLATE [=] collation_name
#
# ALTER_DATABASE enables you to change the overall characteristics of a database.
#
# These characteristics are stored in the data dictionary.
#
# To use ALTER_DATABASE, you need the ALTER privilege on the database.
#
# ALTER_SCHEMA is a synonym for ALTER_DATABASE
#
# The database name can be omitted from the first syntax, in which case the statement
# applies to the default database.
#
# NATIONAL LANGUAGE CHARACTERISTICS
#
# The CHARACTER SET clause changes the default database character set.
#
# The COLLATE clause changes the default database collation. CHAPTER 10, CHARACTER SETS,
# COLLATIONS,, UNICODE discusses char sets and collation names.
#
# You can see what character sets and collations are available using, respectively,
# the SHOW_CHARACTER_SET and SHOW_COLLATION statements.
#
# See SECTION 13.7.6.3, "SHOW CHARACTER SET SYNTAX", and SECTION 13.7.6.4, "SHOW COLLATION SYNTAX"
# for more information
#
# If you change the default character set or collation for a database, stored routines that use the
# database defaults must be dropped and recreated so that they use the new defaults.
#
# (in a stored routine, variables with character data types use the database defaults if
# the character set or collation are not specified explicitly.
#
# See SECTION 13.1.17, "CREATE PROCEDURE AND CREATE FUNCTION SYNTAX")
#
# 13.1.3 ALTER EVENT SYNTAX
#
# ALTER
# 		[DEFINER = { user | CURRENT_USER }]
# 		EVENT event_name
# 		[ON SCHEDULE schedule]
# 		[ON COMPLETION [NOT] PRESERVE]
# 		[RENAME TO new_event_name]
# 		[ENABLE | DISABLE | DISABLE ON SLAVE]
# 		[COMMENT 'string']
# 		[DO event_body]
#
# The ALTER_EVENT statement changes one or more of the characteristics of an existing event
# without the need to drop and recreate it.
#
# THe syntax for each of the DEFINER, ON SCHEDULE, ON COMPLETION, ENABLE / DISABLE and DO clauses
# is exactly the same as when used with CREATE_EVENT
#
# (See SECTION 13.1.13, "CREATE EVENT SYNTAX")
#
# Any user can alter an event defined on a database for which that user has the EVENT privilege.
#
# When a user executes a successful ALTER_EVENT statement, that user becomes the definer
# for the affected event.
#
# ALTER_EVENT works only with an existing event:
#
# 		ALTER EVENT no_such_event
# 			ON SCHEDULE
# 				EVERY '2:3' DAY_HOUR;
# 		ERROR 1517 (HY000): Unknown event 'no_such_event'
#
# In each of the following examples, assume that hte event named myevent is defined
# as shown here:
#
# 		CREATE EVENT myevent
# 			ON SCHEDULE
# 				EVERY 6 HOUR
# 			COMMENT 'A sample comment.'
# 			DO
# 				UPDATE myschema.mytable SET mycol = mycol + 1;
#
# The following statement changes the schedule for myevent from once every six hours
# starting immediately to once every twelve hours, starting four hours from the time
# the statement is run:
#
# 		ALTER EVENT myevent
# 			ON SCHEDULE
# 				EVERY 12 HOUR
# 			STARTS CURRENT_TIMESTAMP + INTERVAL 4 HOUR;
#
# It is possible to change multiple characteristics of an event in a single statement.
#
# This example changes the SQL statement executed by myevent to one that deletes all
# records from mytable;
#
# It also changes the schedule for the event such that it executes once, one day
# after this ALTER_EVENT statement is run.
#
# 		ALTER EVENT myevent
# 			ON SCHEDULE
# 				AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
# 			DO
# 				TRUNCATE TABLE myschema.mytable;
#
# Specify the options in an ALTER_EVENT statement only for those characteristics
# that you want to change;
#
# Omitted options keep their existing values.
#
# This includes any default values for CREATE_EVENT such as ENABLE.
#
# To disable myevent, use this ALTER_EVENT statement:
#
# 		ALTER EVENT myevent
# 			DISABLE;
#
# The ON SCHEDULE clause may use expressions involving built-in MySQL functions and user variables
# to obtain any of the timestamp or interval values which it contains.
#
# You cannot use stored routines or user-defined functions in such expressions, and you cannot
# use any table references;
#
# However, you can use SELECT FROM DUAL. This is true for both ALTER_EVENT and CREATE_EVENT
# statements.
#
# References to stored routines, user-defined functions, and tables in such cases are specifically
# not permitted, and fail with an error (see Bug #22830)
#
# Although an ALTER_EVENT statement that contains another ALTER_EVENT statement in its DO clause
# appears to succeed, when the server attempts to execute the resulting scheduled event, the execution
# fails with an error.
#
# To rename an event, use the ALTER_EVENT statement's RENAME TO clause.
#
# This statement renames the event myevent to yourevent:
#
# 		ALTER EVENT myevent
# 			RENAME TO yourevent;
#
# You can also move an event to a different database using ALTER EVENT --- RENAME TO ---
# and db_name.event_name notation, as shown here:
#
# 		ALTER EVENT olddb.myevent
# 			RENAME TO newdb.myevent;
#
# To execute the previous statement, the user executing it must have the EVENT privilege
# on both the olddb and newdb databases.
#
# NOTE:
#
# 		There is no RENAME EVENT statement
#
# The value DISABLE ON SLAVE is used on a replication slave instead of ENABLE or DISABLE
# to indicate an event that was created on the master and replicated to the slave, but that
# is not executed on the slave.
#
# Normally, DISABLE ON SLAVE is set automatically as required; however, there are some circumstances
# under which you may want or need to change it manually.
#
# See SECTION 17.4.1.16, "REPLICATION OF INVOKED FEATURES", for more information.
#
# 13.1.4 ALTER FUNCTION SYNTAX
#
# ALTER FUNCTION func_name [characteristic ...]
#
# characteristic:
# 		COMMENT 'string'
# 	 | LANGUAGE SQL
# 	 | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
# 	 | SQL SECURITY { DEFINER | INVOKER }
#
# This statement can be used to change the characteristics of a stored function.
#
# More than one change may be specified in an ALTER_FUNCTION statement.
#
# However, you cannot change the parameters or body of a stored function
# using this statement; to make such changes, you must drop and re-create
# the function using DROP_FUNCTION and CREATE_FUNCTION
#
# You must have the ALTER_ROUTINE privilege for the function.
#
# (That privilege is granted automatically to the function creator)
#
# If binary logging is enabled, the ALTER_FUNCTION statement might also require
# the SUPER privilege, as described in SECTION 24.7, "BINARY LOGGING OF STORED PROGRAMS"
#
# 13.1.5 ALTER INSTANCE SYNTAX
#
# ALTER INSTANCE ROTATE INNODB MASTER KEY
#
# ALTER INSTANCE defines actions applicable to a MySQL server instance.
#
# The ALTER INSTANCE ROTATE INNODB MASTER KEY statement is used to rotate the master encryption
# key used for InnoDB tablespace encryption.
#
# A keyring plugin must be installed and configured to use this statement.
#
# By default, the MySQL server loads the keyring_file plugin.
#
# Key rotation requires the ENCRYPTION_KEY_ADMIN or SUPER privilege
#
# ALTER INSTANCE ROTATE INNODB MASTER KEY supports concurrent DML.
#
# However, it cannot be run concurrently with CREATE_TABLE_---_ENCRYPTION
# or ALTER_TABLE_---_ENCRYPTION operations, and locks are taken to prevent
# conflicts that could arise from concurrent execution of these statements.
#
# If one of the conflicting statements is running, it must complete before 
# another can proceed.
#
# ALTER INSTANCE actions are written to the binary log so that they can be 
# executed on replicated servers.
#
# For additional ALTER INSTANCE ROTATE INNODB MASTER KEY usage information,
# see SECTION 15.6.3.9, "TABLESPACE ENCRYPTION"
#
# For information about the keyring_file plugin, see SECTION 6.5.4, "THE MYSQL KEYRING"
#
# 13.1.6 ALTER LOGFILE GROUP SYNTAX
#
# ALTER LOGFILE GROUP logfile_group
# 		ADD UNDOFILE 'file_name'
# 		[INITIAL_SIZE [=] size]
# 		[WAIT]
# 		ENGINE [=] engine_name
#
# This statement adds an UNDO file named 'file_name' to an existing log file group
# logfile_group.
#
# An ALTER_LOGFILE_GROUP statement has one and only one ADD UNDOFILE clause.
#
# No DROP UNDOFILE clause is currently supported.
#
# NOTE:
#
# 		All NDB Cluster Disk Data objects share the same namespace.
#
# 		This means that each Disk Data object must be uniquely named
# 		(and not merely each Disk Data object of a given type)
#
# 		For example, you cannot have a tablespace and an undo log file
# 		with the same name, or an undo log file and a data file with the
# 		same name.
#
# The optional INITIAL_SIZE parameter sets the UNDO file's initial size in bytes;
# if not specified, the initial size defaults to 134217728 (128 MB)
#
# You may optionally follow size with a one-letter abbreviation for an order
# of magnitude, similar to those used in my.cnf 
#
# Generally, this is one of the letters M (megabytes) or G (gigabytes)
#
# (Bug #13116514, Bug #16104705, Bug #62858)
#
# On 32-bit systems, the maximum supported value for INITIAL_SIZE is
# 4294967296 (4 GB) (Bug #29186)
#
# The minimum allowed value for INITIAL_SIZE is 1048576 (1 MB) (Bug #29574)
#
# NOTE:
#
# 		WAIT is parsed but otherwise ignored. 
# 		This keyword currently has no effect, and is intended for future expansion.
#
# The ENGINE parameter (required) determines the storage engine which is used by this
# log file group, with engine_name being the name of the storage engine.
#
# Currently, the only accepted values for engine_name are "NDBCLUSTER" and "NDB"
#
# The two values are equivalent
#
# Here is an example, which assumes that the log file group lg_3 has already been
# created using CREATE_LOGFILE_GROUP (see SECTION 13.1.16, "CREATE LOGFILE GROUP SYNTAX"):
#
# 		ALTER LOGFILE GROUP lg_3
# 			ADD UNDOFILE 'undo_10.dat'
# 			INITIAL_SIZE=32M
# 			ENGINE=NDBCLUSTER;
#
# When ALTER_LOGFILE_GROUP is used with ENGINE = NDBCLUSTER (alternatively, ENGINE = NDB), an UNDO log file
# is created on each NDB Cluster data node.
#
# You can verify that the UNDO files were created and obtain information about them by querying
# the INFORMATION_SCHEMA.FILES table.
#
# For example:
#
# 		SELECT FILE_NAME, LOGFILE_GROUP_NUMBER, EXTRA
# 		FROM INFORMATION_SCHEMA.FILES
# 		WHERE LOGFILE_GROUP_NAME = 'lg_3';
# 		+-------------+------------------------------+-------------------+
# 		| FILE_NAME   | LOGFILE_GROUP_NUMBER 			| EXTRA 				  |
# 		+-------------+------------------------------+-------------------+
# 		| newdata.dat | 	0 									| CLUSTER_NODE=3    |
# 		| newdata.dat | 	0 									| CLUSTER_NODE=4 	  |
# 		| undo_10.dat | 	11 								| CLUSTER_NODE=3    |
# 		| undo_10.dat | 	11 								| CLUSTER_NODE=4	  |
# 		+-------------+------------------------------+-------------------+
#
# (See SECTION 25.10, "THE INFORMATION_SCHEMA FILES TABLE")
#
# Memory used for UNDO_BUFFER_SIZE comes from the global pool whose size is determined
# by the value of the SharedGlobalMemory data node configuration parameter.
#
# This includes any default value implied for this option by the setting of the
# InitialLogFileGroup data node configuration parameter.
#
# ALTER_LOGFILE_GROUP is useful only with Disk Data storage for NDB Cluster.
# For more information, see SECTION 22.5.13, "NDB CLUSTER DISK DATA TABLES"
#
# 13.1.7 ALTER PROCEDURE SYNTAX
#
# ALTER PROCEDURE proc_name [characteristic ---]
#
# characteristic:
# 		COMMENT 'string'
# 	 | LANGUAGE SQL
# 	 | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
# 	 | SQL SECURITY { DEFINER | INVOKER }
#
# This statement can be used to change the characteristics of a stored procedure.
#
# More than one change may be specified in an ALTER_PROCEDURE statement.
#
# However, you cannot change the parameters or body of a stored procedure
# using this statement; to make such changes, you must drop and re-create
# the procedure using DROP_PROCEDURE and CREATE_PROCEDURE.
#
# You must have the ALTER_ROUTINE privilege for the procedure.
#
# By default, that privilege is granted automatically to the procedure creator.
#
# This behavior can be changed by disabling the automatic_sp_privileges system 
# variable.				
#
# See SECTION 24.2.2, "STORED ROUTINES AND MYSQL PRIVILEGES"
#
# 13.1.8 ALTER SERVER SYNTAX
#
# ALTER SERVER server_name
# 		OPTIONS (option [, option] ---)
#
# Alters the server information for server_name, adjusting any of the options
# permitted in the CREATE_SERVER statement.
#
# The corresponding fields in the mysql.servers table are updated accordingly.
#
# This statement requires the SUPER privilege.
#
# For example, to update the USER option:
#
# 		ALTER SERVER s OPTIONS (USER 'sally');
#
# ALTER SERVER causes an implicit commit. See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# ALTER SERVER is not written to the binary log, regardless of the logging format that
# is in use.
#
# 13.1.9 ALTER TABLE SYNTAX
#
# 13.1.9.1 ALTER TABLE PARTITION OPERATIONS
# 13.1.9.2 ALTER TABLE AND GENERATED COLUMNS
# 13.1.9.3 ALTER TABLE EXAMPLES
#
# 		ALTER TABLE tbl_name
# 			[alter_specification [, alter_specification] ---]
# 			[partition_options]
#
# 		alter_specification:
# 			table_options
# 		 | ADD [COLUMN] col_name column_definition
# 				 [FIRST | AFTER col_name]
# 		 | ADD [COLUMN] (col_name column_definition ---)
# 		 | ADD {INDEX|KEY} [index_name]
# 				 [index_type] (key_part, ---) [index_option] ---
# 		 | ADD [CONSTRAINT [symbol]] PRIMARY KEY
# 				 [index_type] (key_part, ---) [index_option] ---
# 		 | ADD [CONSTRAINT [symbol]]
# 				 UNIQUE [INDEX|KEY] [index_name]
# 				 [index_type] (key_part, ---) [index_option] ---
# 		 | ADD FULLTEXT [INDEX|KEY] [index_name]
# 				(key_part,---) [index_option] ---
# 		 | ADD SPATIAL [INDEX|KEY] [index_name]
# 				(key_part,---) [index_option] ---
# 		 | ADD [CONSTRAINT [symbol]]
# 				FOREIGN KEY [index_name] (col_name, ---)
# 				reference_definition
# 		 | ALGORITHM [=] {DEFAULT|INSTANT|INPLACE|COPY}
# 		 | ALTER [COLUMN] col_name {SET DEFAULT literal | DROP DEFAULT}
# 		 | ALTER INDEX index_name {VISIBLE | INVISIBLE}
# 		 | CHANGE [COLUMN] old_col_name new_col_name column_definition
# 				[FIRST|AFTER col_name]
# 		 | [DEFAULT] CHARACTER SET [=] charset_name [COLLATE [=] collation_name]
# 		 | CONVERT TO CHARACTER SET charset_name [COLLATE collation_name]
# 		 | {DISABLE|ENABLE} KEYS
# 		 | {DISCARD|IMPORT} TABLESPACE
# 		 | DROP [COLUMN] col_name
# 		 | DROP {INDEX|KEY} index_name
# 		 | DROP PRIMARY KEY
# 		 | DROP FOREIGN KEY fk_symbol
# 		 | FORCE
# 		 | LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}
# 		 | MODIFY [COLUMN] col_name column_definition
# 				[FIRST | AFTER col_name]
# 		 | ORDER BY col_name [, col_name] ---
# 		 | RENAME COLUMN old_col_name TO new_col_name
# 		 | RENAME {INDEX|KEY} old_index_name TO new_index_name
# 		 | RENAME [TO|AS] new_tbl_name
# 		 | {WITHOUT|WITH} VALIDATION
# 		 | ADD PARTITION (partition_definition)
# 		 | DROP PARTITION partition_names
# 		 | DISCARD PARTITION {partition_names | ALL} TABLESPACE
# 		 | IMPORT PARTITION {partition_names | ALL} TABLESPACE
# 		 | TRUNCATE PARTITION {partition_names | ALL}
# 		 | COALESCE PARTITION number
# 		 | REORGANIZE PARTITION partition_names INTO (partition_definitions)
# 		 | EXCHANGE PARTITION partition_name WITH TABLE tbl_name [{WITH|WITHOUT} VALIDATION]
# 		 | ANALYZE PARTITION {partition_names | ALL}
# 		 | CHECK PARTITION {partition_names | ALL}
# 		 | OPTIMIZE PARTITION {partition_names | ALL}
# 		 | REBUILD PARTITION {partition_names | ALL}
# 		 | REPAIR PARTITION {partition_names | ALL}
# 		 | REMOVE PARTITIONING
# 		 | UPGRADE PARTITIONING
#
# 		key_part: {col_name [(length)] | (expr)} [ASC | DESC]
#
# 		index_type:
# 			USING {BTREE | HASH}
#
# 		index_option:
# 			KEY_BLOCK_SIZE [=] value
# 		 | index_type
# 		 | WITH PARSER parser_name
# 		 | COMMENT 'string'
# 		 | {VISIBILE | INVISIBLE}
#
# 		table_options:
# 			table_option [[,] table_option] ---
#
# 		table_option:
# 			AUTO_INCREMENT [=] value
# 		 | AVG_ROW_LENGTH [=] value
# 		 | [DEFAULT] CHARACTER SET [=] charset_name
# 		 | CHECKSUM [=] {0 | 1}
# 		 | [DEFAULT] COLLATE [=] collation_name
# 		 | COMMENT [=] 'string'
# 		 | COMPRESSION [=] {'ZLIB'|'LZ4'|'NONE'}
# 		 | CONNECTION [=] 'connect_string'
# 		 | {DATA|INDEX} DIRECTORY [=] 'absolute path to directory'
# 		 | DELAY_KEY_WRITE [=] {0 | 1}
# 		 | ENCRYPTION [=] {'Y' | 'N'}
# 		 | ENGINE [=] engine_name
# 		 | INSERT_METHOD [=] { NO | FIRST | LAST }
# 		 | KEY_BLOCK_SIZE [=] value
# 		 | MAX_ROWS [=] value
# 		 | MIN_ROWS [=] value
# 		 | PACK_KEYS [=] {0 | 1 | DEFAULT}
# 		 | PASSWORD [=] 'string'
# 		 | ROW_FORMAT [=] {DEFAULT|DYNAMIC|FIXED|COMPRESSED|REDUNDANT|COMPACT}
# 		 | STATS_AUTO_RECALC [=] {DEFAULT|0|1}
# 		 | STATS_PERSISTENT [=] {DEFAULT|0|1}
# 		 | STATS_SAMPLE_PAGES [=] value
# 		 | TABLESPACE tablespace_name [STORAGE {DISK|MEMORY|DEFAULT}]
# 		 | UNION [=] (tbl_name[,tbl_name] ---)
#
# 		partition_options:
# 			(see CREATE TABLE options)
#
# ALTER_TABLE changes the structure of a table. For example, you can add or delete columns,
# create or destroy indexes, change the type of existing columns, or rename columns
# or the table itself.
#
# You can also change characteristics such as the storage engine used for the table or the
# table comment.
#
# 		) To use ALTER_TABLE, you need ALTER, CREATE and INSERT privileges for the table.
#
# 			Renaming a table requires ALTER and DROP on the old table, ALTER, CREATE, and
# 			INSERT on the new table.
#
# 		) Following the table name, specify the alterations to be made. If none are given, ALTER_TABLE does nothing.
#
# 		) The syntax for many of the permissible alterations is similar to clauses of the CREATE_TABLE statement.
#
# 			column_definition clauses use the same syntax for ADD and CHANGE as for CREATE_TABLE 
#
# 			For more information, see SECTION 13.1.20, "CREATE TABLE SYNTAX"
#
# 		) The word COLUMN is optional and can be omitted, except for RENAME COLUMN (to distinguish a column-renaming
# 			operation from the RENAME table-renaming operation)
#
# 		) Multiple ADD, ALTER, DROP, and CHANGE clauses are permitted in a single ALTER_TABLE statement,
# 			separated by commas.
#
# 			This is a MySQL extension to standard SQL, which permits only one of each clause per ALTER_TABLE
# 			statement.
#
# 			For example, to drop multiple columns in a single statement, do this:
#
# 				ALTER TABLE t2 DROP COLUMN c, DROP COLUMN d;
#
# 		) If a storage engine does not support an attempted ALTER_TABLE operation, a warning may result.
#
# 		Such warnings can be displayed with SHOW_WARNINGS.
#
# 		See SECTION 13.7.6.40, "SHOW WARNINGS SYNTAX"
#
# 		For information on troubleshooting ALTER_TABLE, see SECTION B.6.6.1, "PROBLEMS WITH ALTER TABLE"
#
# 		) For information about generated columns, see SECTION 13.1.9.2, "ALTER TABLE AND GENERATED COLUMNS"
#
# 		) For usage examples, see SECTION 13.1.9.3, "ALTER TABLE EXAMPLES"
#
# 		) With the mysql_info() C API function, you can find out how many rows were copied by ALTER_TABLE.
#
# 			See SECTION 28.7.7.36, "MYSQL_INFO()"
#
# There are several additional aspects to the ALTER TABLE statement, described under the following
# topics in this section:
#
# 		) TABLE OPTIONS
#
# 		) PERFORMANCE AND SPACE REQUIREMENTS
#
# 		) CONCURRENCY CONTROL
#
# 		) ADDING AND DROPPING COLUMNS
#
# 		) RENAMING, REDEFINING, AND REORDERING COLUMNS
#
# 		) PRIMARY KEYS AND INDEXES
#
# 		) FOREIGN KEYS
#
# 		) CHANGING THE CHARACTER SET
#
# 		) DISCARDING AND IMPORTING INNODB TABLESPACES
#
# 		) ROW ORDER FOR MYISAM TABLES
#
# 		) PARTITIONING OPTIONS
#
# TABLE OPTIONS
#
# table_options signifies table options of the kind that can be used in the CREATE_TABLE
# statement, such as ENGINE, AUTO_INCREMENT, AVG_ROW_LENGTH, MAX_ROWS, ROW_FORMAT or TABLESPACE.
#
# For descriptions of all table options, see SECTION 13.1.20, "CREATE TABLE SYNTAX"
#
# However, ALTER_TABLE ignores DATA DIRECTORY and INDEX DIRECTORY when given as table options.
#
# ALTER_TABLE permits them only as partitioning options, and requires that you have the FILE privilege.
#
# Use of table options with ALTER_TABLE provides a convenient way of altering single table characteristics.
#
# For example:
#
# 		) If t1 is currently not an InnoDB table, this statement changes its storage engine to InnoDB:
#
# 			ALTER TABLE t1 ENGINE = InnoDB;
#
# 			) See SECTION 15.6.1.3, "CONVERTING TABLES FROM MYISAM TO INNODB" for considerations when switching
# 				tables to the InnoDB storage engine.
#
# 			) When you specify an ENGINE clause, ALTER_TABLE rebuilds the table.
#
# 				This is true even if the table already has the specified storage engine.
#
# 			) Running ALTER_TABLE_tbl_name_ENGINE=INNODB on an existing InnoDB table performs
# 				a "null" ALTER_TABLE operation, which can be used to defragment an InnoDB table,
# 				as described in SECTION 15.11.4, "DEFRAGMENTING A TABLE"
#
# 				Running ALTER_TABLE_tbl_name_FORCE on an InnoDB table performs the same function
#
# 			) ALTER_TABLE_tbl_name_ENGINE=INNODB and ALTER_TABLE_tbl_name_FORCE use online DDL.
#
# 				For more information, see SECTION 15.12, "INNODB AND ONLINE DDL"
#
# 			) The outcome of attempting to change the storage engine of a table is affected
# 				by whether the desired storage engine is available and the setting of the
# 				NO_ENGINE_SUBSTITUTION SQL mode, as described in SECTION 5.1.11, "SERVER SQL MODES"
#
# 			) To prevent inadvertent loss of data, ALTER_TABLE cannot be used to change the storage
# 				engine of a table to MERGE or BLACKHOLE
#
# 		) To change the InnoDB table to use compressed row-storage format:
#
# 			ALTER TABLE t1 ROW_FORMAT = COMPRESSED;
#
# 		) To enable or disable encryption for an InnoDB table in a file-per-table tablespace:
#
# 			ALTER TABLE t1 ENCRYPTION='Y';
# 			ALTER TABLE t1 ENCRYPTION='N';
#
# 			A keyring plugin must be installed and configured to use the ENCRYPTION option.
#
# 			For more information, see SECTION 15.6.3.9, "TABLESPACE ENCRYPTION"
#
# 		) To reset the current auto-increment value:
#
# 			ALTER TABLE t1 AUTO_INCREMENT = 13;
#
# 			You cannot reset the counter to a value less than or equal to the value that is
# 			currently in use.
#
# 			For both InnoDB and MyISAM, if the value is less than or equal to the maximum value
# 			currently in the AUTO_INCREMENT column, the value is reset to the current maximum
# 			AUTO_INCREMENT column value plus one.
#
# 		) To change the default table character set:
#
# 			ALTER TABLE t1 CHARACTER SET = utf8;
#
# 			See also CHANGING THE CHARACTER SET
#
# 		) To add(or change) a table comment:
#
# 			ALTER TABLE t1 COMMENT = 'New table comment';
#
# 		) Use ALTER TABLE with the TABLESPACE option to move InnoDB tables between existing
# 			general tablespaces, file-per-table tablespaces, and the system tablespace.
#
# 			See MOVING TABLES BETWEEN TABLESPACES USING ALTER TABLE
#
# 			) ALTER TABLE --- TABLESPACE operations always cause a full table rebuild, even if
# 				the TABLESPACE attribute has not changed from its previous value.
#
# 			) ALTER TABLE --- TABLESPACE syntax does not support moving a table from a temporary
# 				tablespace to a persistent tablespace.
#
# 			) The DATA DIRECTORY clause, which is supported with CREATE_TABLE_---_TABLESPACE,
# 				is not supported with ALTER TABLE --- TABLESPACE, and is ignored if specified.
#
# 			) For more information about the capabilities and limitations of the TABLESPACE option, see CREATE_TABLE
#
# 		) MySQL NDB Cluster 8.0 supports setting NDB_TABLE options for controlling a table's partition balance
# 			(fragment count type), read-from-any-replica capability, full replication, or any combination of these,
# 			as part of the table comment for an ALTER TABLE statement in the same manner as for CREATE_TABLE,
# 			as shown in this example:
#
# 				ALTER TABLE t1 COMMENT = "NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RA_BY_NODE";
#
# 			Bear in mind that ALTER TABLE --- COMMENT --- discards any existing comment for the table.
#
# 			See SETTING NDB_TABLE OPTIONS, for additional information and examples.
#
# To verify that the table options were changed as intended, use SHOW_CREATE_TABLE,
# or query the INFORMATION_SCHEMA.TABLES table.
#
# PERFORMANCE AND SPACE REQUIREMENTS
#
# ALTER_TABLE operations are processed using one of the following algorithms:
#
# 		) COPY: Operations are performed on a copy of the original table, and table data is copied
# 			from the original table to the new table row by row.
#
# 			Concurrent DML is not permitted.
#
# 		) INPLACE: Operations avoid copying table data but may rebuild the table in place.
#
# 			An exclusive metadata lock on the table may be taken briefly during preparation and
# 			execution phases of the operation.
#
# 			Typically, concurrent DML is supported.
#
# 		) INSTANT: Operations only modify metadata in the data dictionary.
#
# 			No exclusive metadata locks are taken on the table during preparation and execution,
# 			and table data is unaffected, making operations instantaneous.
#
# 			Concurrent DML is permitted. (Introduced in MySQL 8.0.12)
#
# The ALGORITHM clause is optional. If the ALGORITHM clause is omitted, MySQL uses ALGORITHM=INSTANT
# for storage engines and ALTER_TABLE clauses that support it.
#
# Otherwise, ALGORITHM=INPLACE is used. If ALGORITHM=INPLACE is not supported,
# ALGORITHM=COPY is used.
#
# Specifying an ALGORITHM clause requires the operation to use the specified algorithm for clauses
# and storage engines that support it, or fail with an error otherwise.
#
# Specifying ALGORITHM=DEFAULT is the same as omitting the ALGORITHM clause.
#
# ALTER_TABLE operations that use the COPY algorithm wait for other operations that
# are modifying the table to complete.
#
# After alterations are applied to the table copy, data is copied over, the original
# table is deleted, and the table copy is renamed to the name of the original table.
#
# While the ALTER_TABLE operation executes, the original table is readable by other
# sessions (with the exception noted shortly)
#
# Updates and writes to the table started after the ALTER_TABLE operation begins are
# stalled until the new table is ready, then are automatically redirected to the new table.
#
# The temporary copy of the table is created in the database directory of the original
# table unless it is a RENAME TO operation that moves the table to a database that 
# resides in a different directory.
#
# The exception referred to earlier is that ALTER_TABLE blocks reads (not just writes)
# at the point where it is ready to clear outdated table structures from the table and
# table definition caches.
#
# At this point, it must acquire an exclusive lock.
#
# To do so, it waits for the current readers to finish, and blocks new reads and writes.
#
# An ALTER_TABLE operation that uses the COPY algorithm prevents concurrent DML operations.
#
# Concurrent queries are still allowed. That is, a table-copying operationg always includes
# at least the concurrency restrictions of LOCK=SHARED (allow queries but not DML)
#
# You can further restrict concurrency for operations that support the LOCK clause
# by specifying LOCK=EXCLUSIVE, which prevents DML and queries.
#
# For more information, see CONCURRENCY CONTROL
#
# To force use of the COPY algorithm for an ALTER_TABLE operation that would otherwise
# not use it, specify ALGORITHM=COPY or enable the old_alter_table system variable.
#
# If there is a conflict between the old_alter_table setting and an ALGORITHM
# clause with a value other than DEFAULT, the ALGORITHM clause takes precedence.
#
# For InnnoDB tables, an ALTER_TABLE operation that uses the COPY algorithm on a table
# that resides in a shared tablespace can increase the amount of space used by the tablespace.
#
# Such operations require as much additional space as the data in the table plus indexes.
#
# For a table residing in a shared tablespace, the additional space used during the operation
# is not released back to the operating system as it is for a table that resides in a file-per-table
# tablespace.
#
# For information about space requirements for online DDL operations, see SECTION 15.12.3, "ONLINE DDL SPACE REQUIREMENTS"
#
# ALTER_TABLE operations that support the INPLACE algorithm include:
#
# 		) ALTER TABLE operations supported by the InnoDB online DDL feature. See SECTION 15.12.1, "ONLINE DDL OPERATIONS"
#
# 		) Renaming a table. MySQL renames files that correspond to the table tbl_name without making a copy.
#
# 			(You can also use the RENAME_TABLE statement to rename tables. See SECTION 13.1.36, "RENAME TABLE SYNTAX")
#
# 			Privileges granted specifically for the renamed table are not migrated to the new name.
#
# 			They must be changed manually.
#
# 		) Operations that only modify table metadata. These operations are immediate because the server does
# 			not touch table contents.
#
# 			Metadata-only operations include:
#
# 			) Renaming a column
#
# 			) Changing the default value of a column (except for NDB tables)
#
# 			) Modifying the definition of an ENUM or SET column by adding new enumeration or set members
# 				to the end of the list of valid member values, as long as the storage size of the data
# 				type does not change.
#
# 				For example, adding a member to a SET column that has 8 members changes the required
# 				storage per value from 1 byte to 2 bytes; this requires a table copy.
#
# 				Adding members in the middle of the list causes renumbering of existing members,
# 				which requires a table copy.
#
# 			) Changing the definition of a spatial column to remove the SRID attribute.
#
# 				(Adding or changing an SRID attribute does require a rebuild and cannot be done
# 				in place because the server must verify that all values have the specified SRID value)
#
# 			) As of MySQL 8.0.14, changing a column character set, when these conditions apply:
#
# 				) The column data type is CHAR, VARCHAR, a TEXT type or ENUM
#
# 				) The character set change is from utf8mb3 to utf8mb4, or any character set to binary.
#
# 				) There is no index on the column.
#
# 			) As of MySQL 8.0.14, changing a generated column, when these conditions apply:
#
# 				) For InnoDB tables, statements that modify generated stored columns but do not change
# 					their type, expression, or nullability.
#
# 				) For non-InnoDB tables, statements that modify generated stored or virtual columns but do not
# 					change their type, expression or nullability.
#
# 				An example of such a change is a change to the column comment.
#	
# 			) Renaming an index
#
# 			) Adding or dropping a secondary index, for InnoDB and NDB tables. See SECTION 15.12.1, "ONLINE DDL OPERATIONS"
#
# 			) For NDB tables, operations that add and drop indexes on variable-width columns.
#
# 				These operations occur online, without table copying and without blocking concurrent
# 				DML actions for most of their duration.
#
# 				See SECTION 22.5.14, "ONLINE OPERATIONS WITH ALTER TABLE IN NDB CLUSTER"
#
# 			) Modifying index visibility with an ALTER INDEX operation
#
# 			) Column modifications of tables containing generated columns that depend on columns with a DEFAULT
# 				value if the modified columns are not involved in the generated column expressions.
#
# 				For example, changing the NULL property of a separate column can be done in place without a table rebuild.
#
# 		ALTER TABLE operations that support the INSTANT algorithm include:
#
# 			) Adding a column. This feature is referred to as "INSTANT ADD COLUMN"
#
# 				Limitations apply. See SECTION 15.12.1, "ONLINE DDL OPERATIONS"
#
# 			) Adding or dropping a virtual column
#
# 			) Adding or dropping a column default value
#
# 			) Modifying the definition of an ENUM or SET column. 
#
# 				The same restrictions apply as described above for ALGORITHM=INSTANT
#
# 			) Changing the index type
#
# 			) Renaming a table. The same restrictions apply as described above for ALGORITHM=INSTANT
#
# For more information about operations that support ALGORITHM=INSTANT, see SECTION 15.12.1, "ONLINE DDL OPERATIONS"
#
# ALTER_TABLE upgrades MySQL 5.5 temporal columns to 5.6 format for ADD COLUMN, CHANGE COLUMN, MODIFY COLUMN,
# ADD INDEX and FORCE operations.
#
# This conversion cannot be done using the INPLACE algorithm because the table must be rebuilt,
# so specifying ALGORITHM=INPLACE in these cases results in an error.
#
# Specify ALGORITHM=COPY if necessary.
#
# If an ALTER TABLE operation on a multicolumn index used to partition a table by KEY changes
# the order of the columns, it can only be performed using ALGORITHM=COPY
#
# The WITHOUT VALIDATION and WITH VALIDATION clauses affect whether ALTER_TABLE performs an
# in-place operation for virtual generated column modifications.
#
# See SECTION 13.1.9.2, "ALTER TABLE AND GENERATED COLUMNS"
#
# NDB Cluster 8.0 supports online operations using the same ALGORITHM=INPLACE syntax used with
# the standard MySQL server.
#
# See SECTION 22.5.14, "ONLINE OPERATIONS WITH ALTER TABLE IN NDB CLUSTER", for more information.
#
# ALTER TABLE with DISCARD --- PARTITION --- TABLESPACE or IMPORT --- PARTITION --- TABLESPACE
# does not create any temporary tables or temporary partition files.
#
# ALTER TABLE with ADD PARTITION, DROP PARTITION, COALESCE PARTITION, REBUILD PARTITION,
# or REORGANIZE PARTITION does not create temporary tables (except when used with NDB tables);
#
# However, these operations can and do create temporary partition files.
#
# ADD or DROP operations for RANGE or LIST partitions are immediate operations or nearly so.
#
# ADD or COALESCE operations for HASH or KEY partitions copy data between all partitions;
# unless LINEAR HASH or LINEAR KEY was used; this is effectively the same as creating
# a new table, although the ADD or COALESCE operation is performed partition by partition.
#
# REORGANIZE operations copy only changed partitions and do not touch unchanged ones.
#
# For MyISAM tables, you can speed up index re-creation (the slowest part of the alteration
# process) by setting the myisam_sort_buffer_size system variable to a high value.
#
# CONCURRENCY CONTROL
#
# For ALTER_TABLE operations that support it, you can use the LOCK clause to control
# the level of concurrent reads and writes on a table while it is being altered.
#
# Specifying a non-default value for this clause enables you to require a certain amount
# of concurrent access or exclusivity during the alter operation, and halts the operation
# if the requested degree of locking is not available.
#
# Only LOCK = DEFAULT is permitted for operations that use ALGORITHM=INSTANT
#
# The other LOCK clause parameters are not applicable.
#
# The parameters for the LOCK clause are:
#
# 		) LOCK = DEFAULT
#
# 			Maximum level of concurrency for the given ALGORITHM clause (if any) and ALTER TABLE
# 			operation:
#
# 				Permit concurrent reads and writes if supported.
#
# 			If not, permit concurrent reads if supported.
#
# 			If not, enforce exclusive access.
#
# 		) LOCK = NONE
#
# 			If supported, permit concurrent reads and writes.
#
# 			Otherwise, an error occurs.
#
# 		) LOCK = SHARED
#
# 			If supported, permit concurrent reads but block writes.
#
# 			Writes are blocked even if concurrent writes are supported by the storage engine
# 			for the given ALGORITHM clause (if any) and ALTER TABLE operation.
#
# 			If concurrent reads are not supported, an error occurs.
#
# 		) LOCK = EXCLUSIVE
#
# 			Enforce exclusive access.
#
# 			This is done even if concurrent reads/writes are supported by the storage engine
# 			for the given ALGORITHM clause (if any) and ALTER TABLE operation.
#
# ADDING AND DROPPING COLUMNS
#
# Use ADD to add new columns to a table, and DROP to remove existing columns.
#
# DROP col_name is a MySQL extension to standard SQL.
#
# To add a column at a specific position within a table row, use FIRST or AFTER
# col_name.
#
# The default is to add the column last.
#
# If a table contains only one column, that column cannot be dropped.
#
# If what you intend is to remove the table, use the DROP_TABLE statement instead.
#
# If columns are dropped from a table, the columns are also removed from any index of
# which they are a part.
#
# If all columns that make up an index are dropped, the index is dropped as well.
#
# If you use CHANGE or MODIFY to shorten a column for which an index exists on the
# column, and the resulting column length is less than the index length, MySQL shortens
# the index automatically.
#
# For ALTER TABLE --- ADD, if the column has an expression default value that uses a 
# nondeterministic function, the statement may produce a warning or error.
#
# For details, see SECTION 17.1.3.6, "RESTRICTIONS ON REPLICATION WITH GTIDS"
#
# RENAMING, REDEFINING, AND REORDERING COLUMNS
#
# The CHANGE, MODIFY, RENAME COLUMN and ALTER clauses enable the names and definitions of
# existing columns to be altered.
#
# They have these comparative characteristics:
#
# 		) CHANGE:
#
# 			) Can rename a column and change its definition, or both
#
# 			) Has more capability than MODIFY or RENAME COLUMN, but at the expense of
# 				convenience for some operations.
#
# 				CHANGE requires naming the column twice if not renaming it, and requires
# 				respecifying the column definition if only renaming it.
#
# 			) With FIRST or AFTER, can reorder columns
#
# 		) MODIFY:
#
# 			) Can change a column definition but not its name.
#
# 			) More convenient than CHANGE to change a column definition without renaming it
#
# 			) With FIRST or AFTER, can reorder columns
#
# 		) RENAME COLUMN:
#
# 			) Can change a column name but not its definition
#
# 			) More convenient than CHANGE to rename a column without changing its definition
#
# 		) ALTER: Used only to change a column default value
#
# CHANGE is a MySQL extension to standard SQL. MODIFY and RENAME COLUMN are MySQL
# extensions for Oracle compatibility.
#
# To alter a column to change both its name and definition, use CHANGE, specifying
# the old and new names and the new definition.
#
# For example, to rename an INT NOT NULL column from a to b and change its definition
# to use the BIGINT data type while retaining the NOT NULL attribute, do this:
#
# 		ALTER TABLE t1 CHANGE a b BIGINT NOT NULL;
#
# To change a column definition but not its name, use CHANGE or MODIFY.
#
# With CHANGE, the syntax requires two column names, so you must specify
# the same name twice to leave the name unchanged.
#
# For example, to change the definition of column b, do this:
#
# 		ALTER TABLE t1 CHANGE b b INT NOT NULL;
#
# MODIFY is more convenient to change the definition without changing the name
# because it requires the column name only once:
#
# 		ALTER TABLE t1 MODIFY b INT NOT NULL;
#
# To change a column name but not its definition, use CHANGE or RENAME COLUMN.
#
# With CHANGE, the syntax requires a column definition, so to leave the definition
# unchanged, you must respecify the definition the column currently has.
#
# For example, to rename an INT NOT NULL column from b to a, do this:
#
# 		ALTER TABLE t1 CHANGE b a INT NOT NULL;
#
# RENAME COLUMN is more convenient to change the name without changing the definition
# because it requires only the old and new names:
#
# 		ALTER TABLE t1 RENAME COLUMN b TO a;
#
# In general, you cannot rename a column to a name that already exists in the table.
#
# However, this is sometimes not the case, such as when you swap names or move them
# through a cycle.
#
# If a table has columns named a,b and c, these are valid operations:
#
# 		-- swap a and b
# 		ALTER TABLE t1 RENAME COLUMN a TO b,
# 						   RENAME COLUMN b TO a;
# 		-- "rotate" a, b, c through a cycle
# 		ALTER TABLE t1 RENAME COLUMN a TO b,
# 							RENAME COLUMN b TO c,
# 							RENAME COLUMN c TO a;
#
# For column definition changes using CHANGE or MODIFY, the definition must include
# the data type and all attributes that should apply to the new column, other than
# index attributes such as PRIMARY KEY or UNIQUE.
#
# Attributes present in the original definition but not specified for the new definition
# are not carried forward.
#
# Suppose that a column col1 is defined as INT UNSIGNED DEFAULT 1 COMMENT 'my column'
# and you modify the column as follows, intending to change only INT to BIGINT:
#
# 		ALTER TABLE t1 MODIFY col1 BIGINT;
#
# That statement changes the data type from INT to BIGINT, but it also drops the UNSIGNED,
# DEFAULT and COMMENT attributes.
#
# To retain them, the statement must include them explicitly:
#
# 		ALTER TABLE t1 MODIFY col1 BIGINT UNSIGNED DEFAULT 1 COMMENT 'my column';
#
# For data type changes using CHANGE or MODIFY, MySQL tries to convert existing columns
# values to the new type as well as possible.
#
# WARNING:
#
# 		This conversion may result in alteration of data.
#
# 		For example, if you shorten a string column, values may be truncated.
#
# 		To prevent the operation from succeeding if conversions to the new data type
# 		would result in loss of data, enable strict SQL mode before using ALTER_TABLE
#
# 		(see SECTION 5.1.11, "SERVER SQL MODES")
#
# If you use CHANGE or MODIFY to shorten a column for which an index exists on the
# column, and the resulting column length is less than the index length, MySQL shortens
# the index automatically.
#
# For columns renamed by CHANGE or RENAME COLUMN, MySQL automatically renames these
# references to the renamed column:
#
# 		) Indexes that refer to the old column, including invisible indexes and disabled by MyISAM indexes.
#
# 		) Foreign keys that refer to the old column
#
# For columns renamed by CHANGE or RENAME COLUMN, MySQL does not automatically rename these references
# to the renamed column:
#
# 		) Generated column and partition expressions that refer to the renamed column.
#
# 			You must use CHANGE to redefine such expressions in the same ALTER_TABLE statement
# 			as the one that renames the column.
#
# 		) Views and stored programs that refer to the renamed column. 
#
# 			You must manually alter the definition of these objects to refer to the 
# 			new column name.
#
# To reorder columns within a table, use FIRST and AFTER in CHANGE or MODIFY operations.
#
# ALTER --- SET DEFAULT or ALTER --- DROP DEFAULT specify a new default value for a column
# or remove the old default value, respectively.
#
# If the old default is removed and the column can be NULL, the new default is NULL.
#
# If the column cannot be NULL, MySQL assigns a default value as described in SECTION 11.7,
# "DATA TYPE DEFAULT VALUES"
#
# PRIMARY KEYS AND INDEXES
#
# DROP PRIMARY KEY drops the primary key.
#
# If there is no primary key, an error occurs.
#
# For information about the performance characteristics of primary keys, especially
# for InnoDB tables, see SECTION 8.3.2, "PRIMARY KEY OPTIMIZATION"
#
# If you add a UNIQUE INDEX or PRIMARY KEY to a table, MySQL stores it before any
# nonunique index to permit detection of duplicate keys as early as possible.
#
# DROP_INDEX removes an index. This is a MySQL extension to standard SQL.
#
# See SECTION 13.1.27, "DROP INDEX SYNTAX"
#
# To determine index names, use SHOW INDEX FROM tbl_name
#
# Some storage engines permit you to specify an index type when creating an index.
#
# The syntax for the index_type specifier is USING type_name.
#
# For details about USING, see SECTION 13.1.15, "CREATE INDEX SYNTAX"
#
# The preferred position is after the column list. Support for use of the
# option before the column list will be removed in a future MySQL release.
#
# index_option values specify additional options for an index. USING is one such option.
#
# For details about permissible index_option values, see SECTION 13.1.15, "CREATE INDEX SYNTAX"
#
# RENAME INDEX old_index_name TO new_index_name renames an index.
#
# This is a MySQL extension to standard SQL. The content of the table remains unchanged.
#
# old_index_name must be the name of an existing index in the table that is not dropped
# by the same ALTER_TABLE statement.
#
# new_index_name is the new index name, which cannot duplicate the name of an index
# in the resulting table after changes have been applied.
#
# Neither index name can be PRIMARY.
#
# If you use ALTER_TABLE on a MyISAM table, all nonunique indexes are created in a 
# separate batch (as for REPAIR_TABLE)
#
# This should make ALTER_TABLE much faster when you have many indexes.
#
# For MyISAM tables, key updating can be controlled explicitly. Use ALTER TABLE --- DISABLE KEYS
# to tell MySQL to stop updating nonunique indexes.
#
# Then use ALTER TABLE --- ENABLE KEYS to re-create missing indexes.
#
# MyISAM does this with a special algorithm that is much faster than inserting keys
# one by one, so disabling keys before performing bulk insert operations should give a 
# considerable speedup.
#
# Using ALTER TABLE --- DISABLE KEYS requires the INDEX privilege in addition to the
# privileges mentioned earlier.
#
# While the nonunique indexes are disabled, they are ignored for statements such as
# SELECT and EXPLAIN that otherwise would use them.
#
# After an ALTER_TABLE statement, it may be necessary to run ANALYZE_TABLE to update
# index cardinality information.
#
# See SECTION 13.7.6.22, "SHOW INDEX SYNTAX"
#
# The ALTER INDEX operation permits an index to be made visible or invisible.
#
# An invisible index is not used by the optimizer.
#
# Modification of index visibility applies to indexes other than primary keys
# (either explicit or implicit)
#
# This feature is storage engine neutral (supported for any engine)
#
# FOr more information, see SECTION 8.3.12, "INVISIBLE INDEXES"
#
# FOREIGN KEYS
#
# The FOREIGN KEY and REFERENCES clauses are suppported by the InnoDB and NDB
# storage engines, which implement ADD [CONSTRAINT [symbol]] FOREIGN KEY [index_name] (---) REFERENCES --- (---)
#
# See SECTION 15.6.1.5, "InnoDB AND FOREIGN KEY CONSTRAINTS"
#
# For other storage engines, the clauses are parsed but ignored.
#
# The CHECK clause is parsed but ignored by all storage engines.
#
# See SECTION 13.1.20, "CREATE TABLE SYNTAX"
#
# The reason for accepting but ignoring syntax clauses is for compatibility,
# to make it easier to port code from other SQL servers, and to run applications
# that create tables with references.
#
# See SECTION 1.8.2, "MYSQL DIFFERENCES FROM STANDARD SQL"
#
# For ALTER_TABLE, unlike CREATE_TABLE, ADD FOREIGN KEY ignores index_name if given
# and uses an automatically generated foreign key name.
#
# As a workaround, include the CONSTRAINT clause to specify the foreign key name:
#
# 		ADD CONSTRAINT name FOREIGN KEY (---) ---
#
# IMPORTANT:
#
# 		MySQL silently ignores inline REFERENCES specifications, where the references
# 		are defined as part of the column specification.
#
# 		MySQL accepts only REFERENCES clauses defined as part of a separate FOREIGN KEY specification.
#
# NOTE:
#
# 		Partitioned InnoDB tables do not support foreign keys.
#
# 		This restriction does not apply to NDB tables, including those explicitly partitioned
# 		by [LINEAR] KEY
#
# 		For more information, see SECTION 23.6.2, "PARTITIONING LIMITATIONS RELATING TO STORAGE ENGINES"
#
# MySQL Server and NDB Cluster both support the use of ALTER_TABLE to drop foreign keys:
#
# 		ALTER TABLE tbl_name DROP FOREIGN KEY fk_symbol;
#
# Adding and dropping a foreign key in the same ALTER_TABLE statement is supported for ALTER_TABLE_---_ALGORITHM=INPLACE
# but not for ALTER_TABLE_---_ALGORITHM=COPY
#
# The server prohibits changes to foreign key columns that have the potential to cause loss of referential
# integrity.
#
# It also prohibits changes to the data type of such columns that may be unsafe.
#
# For example, changing VARCHAR(20) to VARCHAR(30) is permitted, but changing it to
# VARCHAR(1024) is not - because that alters hte number of length bytes required to store
# individual values.
#
# A workaround is to use ALTER_TABLE_---_DROP_FOREIGN_KEY before changing the column
# definition and ALTER_TABLE_---_ADD_FOREIGN_KEY afterward.
#
# ALTER TABLE tbl_name RENAME new_tbl_name changes internally generated foreign key
# constraint names and user-defined foreign key constraint names that contain the string
# "tbl_name_ibfk_" to reflect the new table name.
#
# InnoDB interprets foreign key constraint names that contain the string "tbl_name_ibfk_"
# as internally generated names.
#
# CHANGING THE CHARACTER SET
#
# To change the table default character set and all character columns (CHAR, VARCHAR, TEXT)
# to a new character set, use a statement like this:
#
# 		ALTER TABLE tbl_name CONVERT TO CHARACTER SET charset_name;
#
# The statement also changes the collation of all character columns.
#
# If you specify no COLLATE clause to indicate which collation to use, the statement
# uses default collation for the character set.
#
# If this collation is inappropriate for the intended table use (for example, if it would
# change from a case-sensitive collation to a case-insensitive collation), specify
# a collation explicitly.
#
# For a column that has a data type of VARCHAR or one of the TEXT types, CONVERT TO CHARACTER SET
# changes the data type as necessary to ensure that the new column is long
# enough to store as many chars as the original column.
#
# For example, a TEXT column has two length bytes, which stores the byte-length of values in the
# column, up to a maximum of 65,535
#
# For a latin1 TEXT column, each character requires a single byte, so the column can store up to
# 65,535 characters
#
# If the column is converted to utf8, each char might require up to three bytes, for a maximum
# possible length of 3 x 65,535 = 196,605 bytes.
#
# That length does not fit in a TEXT column's length bytes, so MySQL converts
# the data type to MEDIUMTEXT, which is the smallest string type for which the length
# bytes can record a value of 196,605.
#
# Similarly, a VARCHAR column might be converted to MEDIUMTEXT
#
# To avoid data type changes of the type just described, do not use CONVERT TO CHARACTER SET
# 
# Instead, use MODIFY to change individual columns. for example:
#
# 		ALTER TABLE t MODIFY latin1_text_col TEXT CHARACTER SET utf8;
# 		ALTER TABLE t MODIFY latin1_varchar_col VARCHAR(M) CHARACTER SET utf8;
#
# If you specify CONVERT TO CHARACTER SET binary, the CHAR, VARCHAR and TEXT columns are converted
# to their corresponding binary string types (BINARY, VARBINARY, BLOB)
#
# This means that the columns no longer will have a character set and a subsequent CONVERT TO
# operation will not apply to them.
#
# If charset_name is DEFAULT in a CONVERT TO CHARACTER SET operation, the character set named
# by the character_set_database system variable is used.
#
# WARNING:
#
# 		The CONVERT TO operation converts column values between the original and named character sets.
#
# 		This is not what  you want, if you have a column in one character set (like latin1) but the
# 		stored values actually use some other, incompatible character set (like utf8).
#
# 		In this case, you have to do the following for each such column:
#
# 			ALTER TABLE t1 CHANGE c1 c1 BLOB;
# 			ALTER TABLE t1 CHANGE c1 c1 TEXT CHARACTER SET utf8;
#
# 		The reason this works, is that there is no conversion when you convert to or from BLOB columns.
#
# To change only the default character set for a table, use this statement:
#
# 		ALTER TABLE tbl_name DEFAULT CHARACTER SET charset_name;
#
# THe word DEFAULT is optional. The default character set is the character set that is
# used if you do not specify the char set for columns that you add to a table later 
# (for example, with ALTER TABLE --- ADD column)
#
# When the foreign_key_checks system variable is enabled, which is the default string, character set
# conversion is not permitted on tables that include a character string column used in a
# foreign key constraint.
#
# The workaround is to disable foreign_key_checks before performing the character set conversion.
#
# You must perform the conversion on both tables involved in the foreign key constraint
# before re-enabling foreign_key_checks
#
# If you re-enable foreign_key_checks after converting only one of the tables, an ON DELETE
# CASCADE or ON UPDATE CASCADE operation could corrupt data in the referencing table due to
# implicit conversion that occurs during these operations.
#
# (Bug #45290, Bug #74816)
#
# DISCARDING AND IMPORTING INNODB TABLESPACES
#
# An InnoDB table created in its own file-per-table tablespace can be discarded and imported
# using the DISCARD TABLESPACE and IMPORT TABLESPACE options
#
# These options can be used to import a file-per-table tablespace from a backup or to copy
# a file-per-table tablespace from one database server to another.
#
# See SECTION 15.6.3.7, "COPYING TABLESPACES TO ANOTHER INSTANCE"
#
# ROW ORDER FOR MYISAM TABLES
#
# ORDER BY enables you to create the new table with the rows in a specific order.
#
# This option is useful primarily when you know that you query the rows in a certain
# order most of the time.
#
# By using this option after major changes to the table, you might be able to get higher
# performance.
#
# In some cases, it might make sorting easier for MySQL if the table is in order by the
# column that you want to order it by later.
#
# NOTE:
#
# 		The table does not remain in the specified order after inserts and deletes
#
# ORDER BY syntax permits one or more column names to be specified for sorting, each of which
# optionally can be followed by ASC or DESC to indicate ascending or descending sort order,
# respectively.
#
# The default is ascending order. 
#
# Only column names are permitted as sort criteria; 
# arbitrary expressions are not permitted.
#
# This clause should be given last after any other clauses.
#
# ORDER BY does not make sense for InnoDB tables because InnoDB always
# orders table rows according to the clustered index.
#
# When used on a partitioned table, ALTER TABLE --- ORDER BY orders
# rows within each partition only.
#
# PARTITIONING OPTIONS
#
# partition_options signifies options that can be used with partitioned tables 
# for reparatitioning, to add, drop, discard, import, merge, and split partitions,
# and to perform partitioning maintenance.
#
# It is possible for an ALTER_TABLE statement to contain a PARTITION BY or 
# REMOVE PARTITIONING clause in an addition to other alter specifications,
# but the PARTITION BY or REMOVE PARTITIONING clause must be specified last
# after any other specifications.
#
# The ADD PARTITION, DROP PARTITION, DISCARD PARTITION, IMPORT PARTITION,
# COALESCE PARTITION, REORGANIZE PARTITION, EXCHANGE PARTITION, ANALYZE PARTITION,
# CHECK PARTITION and REPAIR PARTITION options cannot be combined with other
# alter specifications in a single ALTER TABLE, since the options just listed
# act on individual partitions.
#
# For more information about partition options, see SECTION 13.1.20, "CREATE TABLE SYNTAX"
# and SECTION 13.1.9.1, "ALTER TABLE PARTITION OPERATIONS"
#
# For information about and examples of ALTER TABLE --- EXCHANGE PARTITION statements,
# see SECTION 23.3.3, "EXCHANGING PARTITIONS AND SUBPARTITIONS WITH TABLES"
#
# 13.1.9.1 ALTER TABLE PARTITION OPERATIONS
#
# Partitioning-related clauses for ALTER_TABLE can be used with partitioned tables for
# reparationing, to add, drop, discard, import, merge, and split partitions,
# and to perform partitioning maintenance.
#
# 		) Simply using a partition_options clause with ALTER_TABLE on a partitioned table
# 			repartitions the table according to the partitioning scheme defined by the
# 			partition_options.
#
# 			This clause always begins with PARTITION BY, and follows the same syntax and other
# 			rules as apply to the partition_options clause for CREATE_TABLE (for more detailed information,
# 			see SECTION 13.1.20, "CREATE TABLE SYNTAX"), and can also be used to partition
# 			an existing table that is not already partitioned.
#
# 			For example, consider a (nonpartitioned) table defined as shown here:
#
# 				CREATE TABLE t1 (
# 					id INT,
# 					year_col INT
# 				);
#
# 			This table can be partitioned by HASH, using the id column as the partitioning key,
# 			into 8 partitions by means of this statement:
#
# 				ALTER TABLE t1
# 					PARTITION BY HASH(id)
# 					PARTITIONS 8;
#
# 			MySQL supports an ALGORITHM option with [SUB]PARTITION BY [LINEAR] KEY.ALGORITHM=1 causes
# 			the server to use the same key-hashing functions as MySQL 5.1 when comptuing
# 			the placement of rows in partitions;
#
# 			ALGORITHM=2 means that the server employs the key-hashing functions implemented
# 			and used by default for new KEY partitioned tables in MySQL 5.5 and later.
#
# 			(Partitioned tables created with the key-hashing functions employed in MySQL 5.5
# 			and later cannot be used by a MySQL 5.1 server)
#
# 			Not specifying the option has the same effect as using ALGORITHM=2
#
# 			This option is intended for use chiefly when upgrading or downgrading [LINEAR]
# 			KEY partitioned tables between 5.1 and later MySQL versions, or for creating
# 			tables partitioned by KEY or LINEAR KEY on a MySQL 5.5 or later server which
# 			can be used on a MySQL 5.1 server
#
# 			The table that results from using an ALTER TABLE --- PARTITION BY statement must
# 			follow the same rules as one created using CREATE TABLE --- PARTITION BY
#
# 			This includes the rules governing the relationship between any unique keys
# 			(including any primary key) that the table might have, and the column
# 			or columns used in the partitioning expression, as discussed in SECTION 23.6.1,
# 			"PARTITIONING KEYS, PRIMARY KEYS, AND UNIQUE KEYS"
#
# 			The CREATE TABLE --- PARTITION BY rules for specifying the number of partitions
# 			also apply to ALTER TABLE --- PARTITION BY
#
# 			The partition_definition clause for ALTER TABLE ADD PARTITION supports
# 			the same options as the clause of the same name for the CREATE_TABLE
# 			statement.
#
# 			(See SECTION 13.1.20, "CREATE TABLE SYNTAX", for the syntax and descriptions)
#
# 			Suppose that you have the partitioned table created as shown here:
#
# 				CREATE TABLE t1 (
# 					id INT,
# 					year_col INT
# 				)
# 				PARTITION BY RANGE (year_col) (
# 					PARTITION p0 VALUES LESS THAN (1991),
# 					PARTITION p1 VALUES LESS THAN (1995),
# 					PARTITION p2 VALUES LESS THAN (1999)
# 				);
#
# 			You can add a new partition p3 to this table for storing values
# 			less than 2002 as follows:
#
# 				ALTER TABLE t1 ADD PARTITION (PARTITION p3 VALUES LESS THAN (2002));
#
# 			DROP PARTITION can be used to drop one or more RANGE or LIST partitions.
#
# 			This statement cannot be used with HASH or KEY partitions; instead, use
# 			COALESCE PARTITION (see later in this section)
#
# 			Any data that was stored in the dropped partitions named in the
# 			partition_names list is discarded.
#
# 			For example, given the table t1 defined previously, you can drop
# 			the partitions named p0 and p1 as shown here:
#
# 				ALTER TABLE t1 DROP PARTITION p0, p1;
#
# 			NOTE:
#
#   			DROP PARTITION does not work with tables that use the NDB storage engine.
#
# 				See SECTION 23.3.1, "MANAGEMENT OF RANGE AND LIST PARTITIONS", and
# 				SECTION 22.1.7, "KNOWN LIMITATIONS OF NDB CLUSTER"
#
# 			ADD PARTITION and DROP PARTITION do not currently support IF [NOT] EXISTS
#
# 			The DISCARD_PARTITION_---_TABLESPACE and IMPORT_PARTITION_---_TABLESPACE options
# 			extend the Transportable Tablespace feature to individual InnoDB table partitions.
#
# 			Each InnoDB table partition has its own tablespace file (.idb file)
#
# 			The Transportable Tablespace feature makes it easy to copy the tablespaces
# 			from a running MySQL server instance to another running instance, or to
# 			perform a restore on the same instance.
#
# 			Both options take a comma-separated list of one or more partition names.
#
# 			For example:
#
# 				ALTER TABLE t1 DISCARD PARTITION p2, p3 TABLESPACE;
#
# 				ALTER TABLE t1 IMPORT PARTITION p2, p3 TABLESPACE;
#
# 			When running DISCARD_PARTITION_---_TABLESPACE and IMPORT_PARTITION_---_TABLESPACE
# 			on subpartitioned tables, both partition and subpartition names are
# 			allowed.
#
# 			When a partition name is specified, subpartitions of that partition are included.
#
# 			The Transportable Tablespace feature also supports copying or restoring partitioned
# 			InnoDB tables (all partitions at once)
#
# 			For additional information, see SECTION 15.6.3.7, "COPYING TABLESPACE TO ANOTHER INSTANCE",
# 			as well as, SECTION 15.6.3.7.1, "TRANSPORTABLE TABLESPACE EXAMPLES"
#
# 			Renames of partitioned tables are supported.
#
# 			You can rename individual partitions indirectly using ALTER TABLE --- REORGANIZE PARTITION;
# 			however, this operation copies the partition's data
#
# 			To delete rows from selected partitions, use the TRUNCATE PARTITION option.
#
# 			This option takes a list of one or more comma-separated partition names.
#
# 			Consider the table t1 created by this statement:
#
# 				CREATE TABLE t1 (
# 					id INT,
# 					year_col INT
# 				)
# 				PARTITION BY RANGE (year_col) (
# 					PARTITION p0 VALUES LESS THAN (1991),
# 					PARTITION p1 VALUES LESS THAN (1995),
# 					PARTITION p2 VALUES LESS THAN (1999),
# 					PARTITION p3 VALUES LESS THAN (2003),
# 					PARTITION p4 VALUES LESS THAN (2007)
# 				);
#
# 			To delete all rows from partition p0, use the following statement:
#
# 				ALTER TABLE t1 TRUNCATE PARTITION p0;
#
# 			The statement just shown has the same effect as the following DELETE statement:
#
# 				DELETE FROM t1 WHERE year_col < 1991;
#
# 			When truncating multiple partitions, the partitions do not have to be contiguous:
#
# 				This can greatly simplify delete operations on partitioned tables that would
# 				otherwise require very complex WHERE Conditions if done with DELETE statements.
#
# 				For example, this statement deletes all rows from partitions p1 and p3:
#
# 					ALTER TABLE t1 TRUNCATE PARTITION p1, p3;
#
# 				An equivalent DELETE statement is shown here:
#
# 					DELETE FROM t1 WHERE
# 						(year_col >= 1991 AND year_col < 1995)
# 						OR
# 						(year_col >= 2003 AND year_col < 2007);
#
# 				If you use the ALL keyword in place of the list of partition names,
# 				the statement acts on all table partitions.
#
# 				TRUNCATE PARTITION merely deletes rows; it does not alter the definition
# 				of the table itself, or of any of its partitions.
#
# 				To verify that the rows were dropped, check the INFORMATION_SCHEMA.PARTITIONS
# 				table, using a query such as this one:
#
# 					SELECT PARTITION_NAME, TABLE_ROWS
# 						FROM INFORMATION_SCHEMA.PARTITIONS
# 						WHERE TABLE_NAME = 't1';
#
# 				COALESCE PARTITION can be used with a table that is partitioned by HASH or KEY
# 				to reduce the number of partitions by number.
#
# 				Suppose that you have created table t2 as follows:
#
# 					CREATE TABLE t2 (
# 						name VARCHAR(30),
# 						started DATE
# 					)
# 					PARTITION BY HASH( YEAR(started) )
# 					PARTITIONS 6;
#
# 				To reduce the number of partitions used by t2 from 6 to 4, use hte following statement:
#
# 					ALTER TABLE t2 COALESCE PARTITION 2;
#
# 				The data contained in the last number partitions will be merged into the remaining partitions.
#
# 				In this case, partitions 4 and 5 will be merged into the first 4 partitions (0, 1, 2, 3)
#
# 				To change some but not all the partitions used by a partitioned table, you can use
# 				REORGANIZE PARTITIOn.
#
# 				This statement can be used in severel ways:
#
# 					) TO merge a set of partitions into a single partition.
#
# 						This is done by naming several partitions in the partition_names list
# 						and supplying a single definition for partition_definition
#
# 					) To split an existing partition into several partitions.
#
# 						Accomplish this by naming a single partition for partition_names
# 						and providing multiple partition_definitions.
#
# 					) To change the ranges for a subset of partitions defined using VALUES LESS THAN
# 						or the values lists for a subset of partitions defined using VALUES IN.
#
# 						NOTE:
#
# 							For partitions that have not been explicitly named, MySQL automatically provides
# 							the default names p0, p1, p2 and so on.
#
# 							The same is true in regards to subpartitions
#
# 						For more detailed information about and examples of ALTER TABLE --- REORGANIZE PARTITION statements,
# 						see SECTION 23.3.1, "MANAGEMENT OF RANGE AND LIST PARTITIONS"
#
# 					) To exchange a table partition or subpartition with a table, use the ALTER_TABLE_---_EXCHANGE_PARTITION
# 						statement - that is, to move any existing rows in the partition or subpartition to the nonpartitioned
# 						table, and any existing rows in the nonpartitioned table to the table partition or subpartition.
#
# 						For usage information and examples, see SECTION 23.3.3, "EXCHANGING PARTITIONS AND SUBPARTITIONS WITH TABLES"
#
# 					) Several options provide partition maintenance and repair functionality analogous to that implemented for
# 						nonpartitioned tables by statements such as CHECK_TABLE and REPAIR_TABLE
#
# 						(which are also supported for partitioned tables; for more information, see
# 						see SECTION 13.7.3, "TABLE MAINTENANCE STATEMENTS")
#
# 						These include ANALYZE PARTITION, CHECK PARTITION, OPTIMIZE PARTITION, REBUILD PARTITION
# 						and REPAIR PARTITION.
#
# 						Each of these options takes a partition_names clause consisting of one or more
# 						names of partitions, separated by commas.
#
# 						The partitions must already exist in the target table.
#
# 						You can also use the ALL keyword in place of partition_names, in which case
# 						the statement acts on all table partitions.
#
# 						For more information and examples, see SECTION 23.3.4, "MAINTENANCE OF PARTITIONS"
#
# 						InnoDB does not currently support per-partition optimization; ALTER TABLE --- OPTIMIZE PARTITION
# 						causes the entire table to rebuilt and analyzed, and an appropriate warning to be issued.
#
# 						(BUG #11751825, BUG #42822)
#
# 						To work around this problem, use ALTER TABLE --- REBUILD PARTITION and ALTER TABLE --- ANALYZE PARTITION instead
#
# 						The ANALYZE PARTITION, CHECK PARTITION, OPTIMIZE PARTITION and REPAIR PARTITION options are not
# 						supported for tables which are not partitioned.
#
# 					) REMOVE PARTITIONING enables you to remove a table's partitioning without otherwise affecting the table or its data.
#
# 						This option can be combined with other ALTER_TABLE options such as those used to add, drop or rename columns or indexes.
#
# 					) Using the ENGINE option with ALTER_TABLE changes the storage engine used by the table without affecting
# 						the partitioning.
#
# 						The target storage engine must provide its own partitioning handler.
#
# 						Only the InnoDB and NDB storage engines have native partitioning handlers;
#
# 						NDB is currently not currently supported in MySQL 8.0
#
# It is possible for an ALTER_TABLE statement to contain a PARTITION BY or REMOVE PARTITIONING
# clause in an addition to other alter specifications, but the PARTITION BY or REMOVE PARTITIONING
# clause must be specified last after any other specifications.
#
# The ADD PARTITION, DROP PARTITION, COALESCE PARTITION, REORGANIZE PARTITION, ANALYZE PARTITION,
# CHECK PARTITION and REPAIR PARTITION options cannot be combined with other alter specifications
# in a single ALTER TABLE, since the options just listed act on individual partitions.
#
# For more information, see SECTION 13.1.9.1, "ALTER TABLE PARTITION OPERATIONS"
#
# Only a single instance of any one of the following options can be used in a given ALTER_TABLE
# statement:
#
# 		PARTITION BY, ADD PARTITION, DROP PARTITION, TRUNCATE PARTITION, EXCHANGE PARTITION,
# 		REORGANIZE PARTITION, or 
#
# 		COALESCE PARTITION, ANALYZE PARTITION, CHECK PARTITION, OPTIMIZE PARTITION,
# 		REBUILD PARTITION, REMOVE PARTITIONING
#
# 		For example, the following two statements are invalid:
#
# 			ALTER TABLE t1 ANALYZE PARTITION p1, ANALYZE PARTITION p2;
#
# 			ALTER TABLE t1 ANALYZE PARTITION p1, CHECK PARTITION p2;
#
# 		In the first case, you can analyze partitions p1 and p2 of table t1 concurrently
# 		using a single statement with a single ANALYZE PARTITION option that lists both
# 		of the partitions to be analyzed, like this:
#
# 			ALTER TABLE t1 ANALYZE PARTITION p1, p2;
#
# 		In the second case, it is not possible to perform ANALYZE and CHECK operations
# 		on different partitions of the same table concurrently.
#
# 		Instead, you must issue two seperate statements, like this:
#
# 			ALTER TABLE t1 ANALYZE PARTITION p1;
# 			ALTER TABLE t1 CHECK PARTITION p2;
#
# 		REBUILD operations are currently unsupported for subpartitions.
#
# 		The REBUILD keyword is expressly disallowed with subpartitions, and causes
# 		ALTER TABLE to fail with an error if so used.
#
# 		CHECK PARTITION and REPAIR PARTITION operations fail when the partition to be checked or repaired
# 		contains any duplicate key errors.
#
# 		For more information, see SECTION 23.3.4, "MAINTENANCE OF PARTITIONS"
#
# 13.1.9.2 ALTER TABLE AND GENERATED COLUMNS
#
# ALTER TABLE operations permitted for generated columns are ADD, MODIFY and CHANGE.
#
# 		) Generated columns can be added.
#
# 			CREATE TABLE t1 (c1 INT);
# 			ALTER TABLE t1 ADD COLUMN c2 INT GENERATED ALWAYS AS (c1 + 1) STORED;
#
# 		) The data type and expression of generated columns can be modified.
#
# 			CREATE TABLE t1 (c1 INT, c2 INT GENERATED ALWAYSA AS (c1 + 1) STORED);
# 			ALTER TABLE t1 MODIFY COLUMN c2 TINYINT GENERATED ALWAYS AS (c1 + 5) STORED;
#
# 		) Generated columns can be renamed or dropped, if no other column refers to them.
#
# 			CREATE TABLE t1 (c1 INT, c2 INT GENERATED ALWAYS AS (c1 + 1) STORED);
# 			ALTER TABLE t1 CHANGE c2 c3 INT GENERATED ALWAYS AS (c1 + 1) STORED;
# 			ALTER TABLE t1 DROP COLUMN c3;
#
# 		) Virtual generated columns cannot be altered to store generated columns, or vice versa.
#
# 			To work around this, drop the column, then add it with the new definition.
#
# 				CREATE TABLE t1 (c1 INT, c2 INT GENERATED ALWAYS AS (c1 + 1) VIRTUAL);
# 				ALTER TABLE t1 DROP COLUMN c2;
# 				ALTER TABLE t1 ADD COLUMN c2 INT GENERATED ALWAYS AS (c1 + 1) STORED;
#
# 		) Nongenerated columns can be altered to store but not virtual generated columns:
#
# 			CREATE TABLE t1 (c1 INT, c2 INT);
# 			ALTER TABLE t1 MODIFY COLUMN c2 INT GENERATED ALWAYS AS (c1 + 1) STORED;
#
# 		) Stored but not virtual generated columns can be altered to nongenerated columns.
#
# 			The stored generated values become the values of the nongenerated column.
#
# 				CREATE TABLE t1 (c1 INT, c2 INT GENERATED ALWAYS AS (c1 + 1) STORED);
# 				ALTER TABLE t1 MODIFY COLUMN c2 INT;
#
# 		) ADD COLUMN is not an in-place operation for stored columns (done without using a temp table)
# 			because the expression must be evaluated by the server.
#
# 			For stored columns, indexing changes are done in place, and expression changes
# 			are not done in place.
#
# 			Changes to column comments are done in place.
#
# 		) For non-partitioned tables, ADD COLUMN and DROP COLUMN are in-place operations
# 			for virtual columns.
#
# 			However, adding or dropping a virtual column cannot be performed in place in combination
# 			with other ALTER_TABLE operations.
#
# 			For partitioned tables, ADD COLUMN and DROP COLUMN are not in-place operations
# 			for virtual columns.
#
# 		) InnoDB supports secondary indexes on virtual generated columns.
#
# 			Adding or dropping a secondary index on a virtual generated column
# 			is an in-place operation.
#
# 			For more information, see SECTION 13.1.20.9, "SECONDARY INDEXES AND GENERATED COLUMNS"
#
# 		) When a VIRTUAL generated column is added to a table or modified, it is not ensured that
# 			data being calculated by the generated column expression will not be out of range for the column.
#
# 			This can lead to inconsistent data being returned and unexpectedly failed statements.
#
# 			To permit control over whether validation occurs for such columns, ALTER TABLE
# 			supports WITHOUT VALIDATION and WITH VALIDATION clauses:
#
# 				) With WITHOUT VALIDATION (the default if neither clause is specified), an in-place operation
# 					is performed (if possible), data integrity is not checked, and the statement finishes more quickly.
#
# 					However, later reads from the table might report warnings or errors for the column if values are out of range.
#
# 				) With WITH VALIDATION, ALTER TABLE copies the table.
#
# 					If an out-of-range or any other error occurs, the statement fails.
#
# 					Because a table copy is performed, the statement takes longer.
#
# 			WITHOUT VALIDATION and WITH VALIDATION are permitted only with ADD COLUMN,
# 			CHANGE COLUMN, and MODIFY COLUMN operations.
#
# 			Otherwise, an ER_WRONG_USAGE error occurs.
#
# 		) If expression evaluation causes truncation or provides incorrect input to a function,
# 			the ALTER_TABLE statement terminates with an error and the DDL operation is rejected.
#
# 		) An ALTER_TABLE statement that changes the default value of a column col_name may also
# 			change the value of a generated column expression that refers to the column using
# 			col_name, which may change the value of a generated column expression that refers
# 			to the column using DEFAULT(col name)
#
# 			For htis reason, ALTER_TABLE operations that change the definition of a column
# 			cause a table rebuild if any generated column expression uses DEFAULT()
#
# 13.1.9.3 ALTER TABLE EXAMPLES
#
# Begin with a table t1 created as shown here:
#
# 		CREATE TABLE t1 (a INTEGER, b CHAR(10));
#
# To rename teh table from t1 to t2:
#
# 		ALTER TABLE t1 RENAME t2;
#
# To change column a from INTEGER to TINYINT NOT NULL (leaving the name the same),
# and to change column b from CHAR(10) to CHAR(20) as well as renaming it from b
# to c:
#
# 		ALTER TABLE t2 MODIFY a TINYINT NOT NULL, CHANGE b c CHAR(20);
#
# To add a new TIMESTAMP column named d:
#
# 		ALTER  TABLE t2 ADD d TIMESTAMP;
#
# To add an index on column d and a UNIQUE index on column a:
#
# 		ALTER TABLE t2 ADD INDEX (d), ADD UNIQUE (a);
#
# To remove column c:
#
# 		ALTER TABLE t2 DROP COLUMN c;
#
# To add a new AUTO_INCREMENT integer column named c:
#
# 		ALTER TABLE t2 ADD c INT UNSIGNED NOT NULL AUTO_INCREMENT,
# 			ADD PRIMARY KEY (c);
#
# We indexed (c) as a PRIMARY KEY, because AUTO_INCREMENT columns must be
# indexed, and we declare c as NOT NULL because primary key columns cannot be NULL.
#
# For NDB tables, it is also possible to change the storage type used for a 
# table or column.
#
# For example, consider an NDB table created as shown here:
#
# 		CREATE TABLE t1 (c1 INT) TABLESPACE ts_1 ENGINE NDB;
# 		Query OK, 0 rows affected (1.27 sec)
#
# To convert this table to disk-based storage, you can use the following
# ALTER_TABLE statement:
#
# 		ALTER TABLE t1 TABLESPACE ts_1 STORAGE DISK;
# 		Query OK, 0 rows affected (2.99 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
# 		SHOW CREATE TABLE t1\G
# 		******************************* 1. row *********************************
# 						Table: t1
# 			  Create Table: CREATE TABLE `t1` (
# 					`c1` int(11) DEFAULT NULL
# 			  ) /*!50100 TABLESPACE ts_1 STORAGE DISK */
# 			  ENGINE=ndbcluster DEFAULT CHARSET=latin1
# 			  1 row in set (0.01 sec)
#
# It is not necessary that the tablespace was referenced when the table was originally
# created;
#
# However, the tablespace must be referenced by the ALTER_TABLE:
#
# 		CREATE TABLE t2 (c1 INT) ts_1 ENGINE NDB;
# 		Query OK, 0 rows affected (1.00 sec)
#
# 		ALTER TABLE t2 STORAGE DISK;
# 		ERROR 1005 (HY000): Can't create table 'c.#sql-1750_3' (errno: 140)
# 		ALTER TABLE t2 TABLESPACE ts_1 STORAGE DISK;
# 		Query OK, 0 rows affected (3.42 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
#  	SHOW CREATE TABLE t2\G
# 		*********************** 1. row *******************************
#  				Table: t1
# 			Create Table: CREATE TABLE `t2` (
# 				`c1` int(11) DEFAULT NULL
# 			) /*!50100 TABLESPACE ts_1 STORAGE DISK */
# 			ENGINE=ndbcluster DEFAULT CHARSET=latin1
# 			1 row in set (0.01 sec)
#
# To change the storage type of an individual column, you can use ALTER TABLE --- MODIFY [COLUMN]
#
# For example, suppose you create an NDB Cluster Disk Data table with two columns,
# using this CREATE_TABLE statement:
#
# 		CREATE TABLE t3 (c1 INT, c2 INT)
# 			TABLESPACE ts_1 STORAGE DISK ENGINE NDB;
# 		Query OK, 0 rows affected (1.34 sec)
#
# To change column c2 from disk-based to in-memory storage, include a STORAGE MEMORY
# clause in the column definition used by the ALTER TABLE statement, as shown
# here:
#
# 		ALTER TABLE t3 MODIFY c2 INT STORAGE MEMORY;
# 		Query OK, 0 rows affected (3.14 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
# You can make in-memory columns into a disk-based column by using STORAGE DISK
# in a similar fashion.
#
# Column c1 uses disk-based storage, since this is hte default for the table
# (determined by the table-level STORAGE DISK clause in the CREATE_TABLE statement)
#
# However, column c2 uses in-memory storage, as can be seen here in the output
# of SHOW CREATE_TABLE:
#
# 		SHOW CREATE TABLE t3\G
# 		******************** 1. row ************************************
# 				Table: t3
# 		Create Table: CREATE TABLE `t3` (
# 			`c1` int(11) DEFAULT NULL,
# 			`c2` int(11) /*!50120 STORAGE MEMORY */ DEFAULT NULL
# 		) /*!50100 TABLESPACE ts_1 STORAGE DISK */ ENGINE=ndbcluster
# 		DEFAULT CHARSET=latin1
# 		1 row in set (0.02 sec)
#
# When you add an AUTO_INCREMENT column, column values are filled in with sequence
# numbers automatically.
#
# For MyISAM tables, you can set the first sequence number by executing SET INSERT_ID=value
# before ALTER_TABLE or by using the AUTO_INCREMENT=value table option.
#
# With MyISAM tables, if you do not change the AUTO_INCREMENT column, the sequence number
# is not affected.
#
# If you drop an AUTO_INCREMENT column and then add another AUTO_INCREMENT column
# , the numbers are resequenced beginning with 1
#
# When replication is used, adding an AUTO_INCREMENT column to a table might not produce
# the same ordering of the rows on the slave and the master.
#
# This occurs because the orders in which the rows are numbered depends on the specific
# storage engine used for the table and the order in which the rows were inserted.
#
# It is important to have the same order on the master and slave, the rows must be
# ordered before assigning an AUTO_INCREMENT number
#
# Assuming that you want to add an AUTO_INCREMENT column to the table t1, the following
# statements produce a new table t2 identical to t1 but with an AUTO_INCREMENT column:
#
# 		CREATE TABLE t2 (id INT AUTO_INCREMENT PRIMARY KEY)
# 		SELECT * FROM t1 ORDER BY col1, col2;
#
# This assumes that the table t1 has columns col1 and col2
#
# This set of statements will also produce a new table t2 identical to t1,
# with the addition of an AUTO_INCREMENT column:
#
# 		CREATE TABLE t2 LIKE t1;
# 		ALTER TABLE t2 ADD id INT AUTO_INCREMENT PRIMARY KEY;
# 		INSERT INTO t2 SELECT * FROM t1 ORDER BY col1, col2;
#
# IMPORTANT:
#
# 		To guarantee the same ordering on both master and slave, all columns
# 		of t1 must be referenced in the ORDER BY clause
#
# Regardless of the method used to create and populate the copy having the
# AUTO_INCREMENT column , the final step is to drop the original table
# and then rename the copy:
#
# 		DROP TABLE t1;
# 		ALTER TABLE t2 RENAME t1;
#
# 13.1.10 ALTER TABLESPACE SYNTAX
#
# ALTER [UNDO] TABLESPACE tablespace_name
# 		NDB only:
# 			{ADD|DROP} DATAFILE 'file_name'
# 			[INTIIAL_SIZE [=] size]
# 			[WAIT]
# 		InnoDB and NDB:
# 			[RENAME TO tablespace_name]
# 		InnoDB only:
# 			[SET {ACTIVE|INACTIVE}]
# 			[ENCRYPTION [=] {'Y' | 'N'}]
# 		InnoDB and NDB:
# 			[ENGINE [=] engine_name]
#
# This statement is used with NDB and InnoDB tablespaces.
#
# It can be used to add a new data file to, or to drop a data file from
# an NDB tablespace.
#
# It can also be used to rename an NDB Cluster Disk Data tablespace,
# rename an InnoDB general tablespace, encrypt an InnoDB general tablespace,
# or mark an InnoDB undo tablespace as active or inactive.
#
# The UNDO keyword, introduced in MySQL 8.0.14, is used with the SET {ACTIVE|INACTIVE}
# clause to mark an InnoDB undo tablespace as active or inactive.
#
# For more information, See SECTION 15.6.3.4, "UNDO TABLESPACES"
#
# The ADD DATAFILE variant enables you to specify an initial size for an NDB Disk Data
# tablespace using an INITIAL_SIZE clause, where size is measured in bytes; the default
# value is 134217728 (128 mb)
#
# You may optionally follow size with a one-letter abbreviation for an order of
# magnitude, similar to those used in my.cnf
#
# Generally, this is one of the letters M (megabytes) or G (gigabytes)
#
# On 32-bit systems, the maximum supported value for INTIIAL_SIZE is 4 GB. (Bug #29186)
#
# INITIAL_SIZE is rounded, explicitly, as for CREATE_TABLESPACE
#
# Once a data file has been created, its size cannot be changed; however, you can
# add more data files to an NDB tablespace using additional ALTER TABLESPACE --- ADD DATAFILE
# statements.
#
# When ALTER TABLESPACE --- ADD DATAFILE is used with ENGINE = NDB, a data file is created
# on each Cluster data node, but only one row is generated in the INFORMATION_SCHEMA.FILES
# table.
#
# See the description of this table, as well as SECTION 22.5.13.1, "NDB CLUSTER DISK DATA OBJECTS",
# for more information.
#
# ADD DATAFILE is not supported with InnoDB tablespaces.
#
# Using DROP DATAFILE with ALTER_TABLESPACE drops the data file 'file_name' from an NDB tablespace.
#
# You cannot drop a data file from a tablespace which is in use by any table; in other words,
# the data file must be empty (no extents used)
#
# See SECTION 22.5.13.1, "NDB CLUSTER DISK DATA OBJECTS"
#
# In addition, any data file to be dropped must previously have been added to the tablespace
# with CREATE_TABLESPACE or ALTER_TABLESPACE
#
# DROP DATAFILE is not supported with InnoDB tablespaces.
#
# WAIT is parsed but otherwise ignored. It is intended for future expansion.
#
# The ENGINE clause, which specifies the storage engine used by the tablespace, is deprecated
# and will be removed.
#
# The tablespace storage engine is known by the data dictionary, making the ENGINE
# clause obsolete.
#
# If the storage engine is specified, it must match the tablespace storage engine
# defined in the data dictionary.
#
# The only values for engine_name compatible with NDB tablespaces are NDB and NDBCLUSTER.
#
# RENAME TO operations are implicitly performed in autocommit mode, regardless of the autocommit setting.
#
# A RENAME TO operation cannot be performed while LOCK_TABLES or FLUSH_TABLES_WITH_READ_LOCK is in effect
# for tables that reside in the tablespace.
#
# Exclusive metadata locks are taken on tables that reside in a general tablespace while the tablespace
# is renamed, which prevents concurrent DDL.
#
# Concurrent DML is supported.
#
# The CREATE_TABLESPACE privilege is required to rename an InnoDB general tablespace.
#
# The ENCRYPTION option is used to enable or disable page-level data encryption for an
# InnoDB general tablespace.
#
# Option values are not case-sensitive.
#
# Encryption support for general tablespaces was introduced in MySQL 8.0.13.
#
# A keyring plugin must be installed and configured to encrypt a tablespace using
# the ENCRYPTION option.
#
# When a general tablespace is encrypted, all tables residing in the tablespace are encrypted.
# Likewise, a table created in an encrypted general tablespace is encrypted.
#
# The INPLACE algorithm is used when altering the ENCRYPTION attribute of a general
# tablespace.
#
# The INPLACE algorithm permits concurrent DML on tables that reside in the general
# tablespace.
#
# Concurrent DDL is blocked.
#
# For more information, see SECTION 15.6.3.9, "TABLESPACE ENCRYPTION"
#
# 13.1.11 ALTER VIEW SYNTAX
#
# ALTER
# 		[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
# 		[DEFINER = { user | CURRENT_USER }]
# 		[SQL SECURITY { DEFINER | INVOKER }]
# 		VIEW view_name [(column_list)]
# 		AS select_statement
# 		[WITH [CASCADED | LOCAL] CHECK OPTION]
#
# This statement changes the definition of a view, which must exist.
#
# The syntax is similar to that for CREATE_VIEW (see SECTION 13.1.23, "CREATE VIEW SYNTAX")
#
# This statement requires the CREATE_VIEW and DROP privileges for the view, and some
# privilege for each column referred to in the SELECT statement.
#
# ALTER_VIEW is permitted only to the definer or users with the SET_USER_ID or SUPER privilege.
#
# 13.1.12 CREATE DATABASE SYNTAX
#
# CREATE {DATABASE | SCHEMA} [IF NOT EXISTS] db_name
# 		[create_specification] ---
#
# create_specification:
# 		[DEFAULT] CHARACTER SET [=] charset_name
# 	 | [DEFAULT] COLLATE [=] collation_name
#
# CREATE_DATABASE creates a database with the given name. 
#
# To use this statement, you need the CREATE privilege for the database.
#
# CREATE_SCHEMA is a synonym for CREATE_DATABASE
#
# An error occurs if the database exists and you did not specify IF NOT EXISTS
#
# CREATE_DATABASE is not permitted within a session that has an active LOCK_TABLES statement
#
# create_specification options specify database characteristics. Database characteristics
# are stored in the data dictionary.
#
# The CHARACTER SET clause specifies the default database character set. The COLLATE
# clause specifies the default database collation.
#
# CHAPTER 10, CHARACTER SETS, COLLATIONS, UNICODE, discusses character set and collation
# names.
#
# A database in MySQL is implemented as a directory containing files that correspond to tables
# in the database.
#
# Because there are no tables in a database when it is initially created, the CREATE_DATABASE
# statement creates only a directory under the MySQL data directory.
#
# Rules for permissible database names are given in SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# If a database name contains special characters, the name for the database directory
# contains encoded versions of those characters as described in SECTION 9.2.3, "MAPPING OF IDENTIFIERS TO FILE NAMES"
#
# Creating a database directory by manually creating a directory under the data directory
# (for example, with mkdir) is temporarily unsupported in MySQL 8.0.0
#
# You can also use the mysqladmin program to create databases.
#
# See SECTION 4.5.2, "MYSQLADMIN -- CLIENT FOR ADMINISTERING A MYSQL SERVER"
#
# 13.1.13 CREATE EVENT SYNTAX
#
# CREATE
# 		[DEFINER = { user | CURRENT_USER }]
# 		EVENT
# 		[IF NOT EXISTS]
# 		event_name
# 		ON SCHEDULE schedule
# 		[ON COMPLETION [NOT] PRESERVE]
# 		[ENABLE | DISABLE | DISABLE ON SLAVE]
# 		[COMMENT 'string']
# 		DO event_body;
#
# schedule:
# 		AT timestamp [+ INTERVAL interval] ---
#   | EVERY interval
# 		[STARTS timestamp [+ INTERVAL interval] ---]
# 		[ENDS timestamp [+ INTERVAL interval] ---]
#
# interval:
# 		quantity {YEAR | QUARTER | MONTH | DAY | HOUR | MINUTE |
# 					 WEEK | SECOND  | YEAR_MONTH | DAY_HOUR | DAY_MINUTE |
# 					 DAY_SECOND | HOUR_MINUTE | HOUR_SECOND | MINUTE_SECOND}
#
# This statement creates and schedules a new event.
#
# The event will not run unless the Event Scheduler is enabled.
#
# For information about checking Event Scheduler status and enabling it if
# necessary, see SECTION 24.4.2, "EVENT SCHEDULER CONFIGURATION"
#
# CREATE_EVENT requires the EVENT privilege for the schema in which the event
# is to be created.
#
# It might also require the SET_USER_ID or SUPER privilege, depending on the
# DEFINER value, as described later in this section.
#
# The minimum requirements for a valid CREATE_EVENT statement are as follows:
#
# 		) The keywords CREATE_EVENT plus an event name, which uniquely identifies the event in a database schema.
#
# 		) An ON SCHEDULE clause, which determines when and how often the event executes
#
# 		) A DO clause, which contains the SQL statement to be executed by an event
#
# This is an example of a minimal CREATE_EVENT statement:
#
# 		CREATE EVENT myevent
# 			ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR
# 			DO
# 				UPDATE myschema.mytable SET mycol = mycol + 1;
#
# The previous statement creates an event named myevent.
#
# This event executes once - one hour following its creation - by running an 
# SQL statement that increments the value of the myschema.mytable table's
# mycol column by 1.
#
# The event_name must be a valid MySQL identifier with a maximum length of 64 characters.
#
# Event names are not case-sensitive, so you cannot have two events named myevent
# and MyEvent in the same schema.
#
# In general, the rules governing event names are the same as those for names
# of stored routines.
#
# See SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# An event is associated with a schema. If no schema is indicated as part of event_name,
# the default (current) schema is assumed.
#
# To create an event in a specific schema, qualify the event name with a schema using
# schema_name.event_name syntax
#
# The DEFINER clause specifies the MySQL account to be used when checking access privileges
# at event execution time.
#
# If a user value is given, it should be a MySQL account specified as 'user_name'@'host_name',
# CURRENT_USER or CURRENT_USER()
#
# The default DEFINER value is the user who executes the CREATE_EVENT statement.
#
# This is the same as specifying DEFINER = CURRENT_USER explicitly
#
# If you specify the DEFINER clause, these rules determine the valid DEFINER user values:
#
# 		) If you do not have the SET_USER_ID or SUPER privilege, the only permitted user value is
# 			your own account, either specified literally or by using CURRENT_USER
#
# 			You cannot set the definer to some other account
#
# 		) If you have the SET_USER_ID or SUPER privilege, you can specify any syntactically valid account name.
#
# 			If the account does not exist, a warning is generated.
#
# 		) Although it is possible to create an event with a nonexistent DEFINER account, an error occurs
# 			at event execution time if the account does not exist.
#
# For more information about event security, see SECTION 24.6, "ACCESS CONTROL FOR STORED PROGRAMS AND VIEWS"
#
# Within an event, the CURRENT_USER() function returns the account used to check privileges at event
# execution time, which is the DEFINER user.
#
# For information about user auditing within events, see SECTION 6.3.13, "SQL-BASED MYSQL ACCOUNT ACTIVITY AUDITING"
#
# IF NOT EXISTS has the same meaning for CREATE_EVENT as for CREATE_TABLE:
#
# 		If an event named event_name already exists in the same schema, no action is taken,
# 		and no error results.
#
# 		(However, a warning is generated in such cases)
#
# The ON SCHEDULE clause determines when, how often, and for how long the event_body
# defined for the event repeats.
#
# This clause takes one of two forms:
#
# 		) AT timestamp is used for a one-time event.
#
# 		It specifies that the event executes one time only at the date and time given by
# 		timestamp, which must include both the date and time, or must be an expression that
# 		resolves to a datetime value.
#
# 		You may use a value of either the DATETIME or TIMESTAMP type for this purpose.
#
# 		If the date is in the past, a warning occurs, as shown here:
#
# 			SELECT NOW();
# 			+--------------------------------+
# 			| NOW() 								   |
# 			+--------------------------------+
# 			| 2006-02-10 23:59:01 			   |
# 			+--------------------------------+
# 			1 row in set (0.04 sec) 	
#
# 			CREATE EVENT e_totals
# 				ON SCHEDULE AT '2006-02-10 23:59:00'
# 				DO INSERT INTO test.totals VALUES (NOW());
# 			Query OK, 0 rows affected, 1 warning (0.00 sec)
#
# 			SHOW WARNINGS\G
# 			********************** 1. row *******************************
# 				Level: Note
# 				 Code: 1588
# 			 Message: Event execution time is in the past and ON COMPLETION NOT
# 						 PRESERVE is set.
#
# 						 The event was dropped immediately after creation.
#
# CREATE_EVENT statements which are themselves invalid - for whatever reason - fail with an error.
#
# You may use CURRENT_TIMESTAMP to specify the current date and time. 
#
# In such a case, the event acts as soon as it is created.
#
# To create an event which occurs at some point in the future relative to the current date
# and time - such as the expressed by the phrase "three weeks from now" - you can use
# the optional clause + INTERVAL interval.
#
# The interval portion consists of two parts, a quantity and a unit of time, and follows
# the syntax rules described in Temporal Intervals, except that you cannot use any units
# keywords that involve microseconds when defining an event.
#
# With some interval types, complex time units may be used.
#
# For example, "two minutes and ten seconds" can be expressed as + INTERVAL '2:10' MINUTE_SECOND
#
# You can also combine intervals.
#
# For example, AT CURRENT_TIMESTAMP + INTERVAL 3 WEEK + INTERVAL 2 DAY is equivalent
# to "three weeks and two days from now"
#
# Each portion of such a clause must begin with + INTERVAL.
#
# ) 	To repeat actions at a regular interval, use an EVERY clause.
#
	# 	The EVERY keyword is followed by an interval as described in the previous discussion
	# of the AT keyword.
	# (+ INTERVAL is not used with EVERY)
	#
	# For example, EVERY 6 WEEK means "every six weeks"
	#
	# Although + INTERVAL clauses are not permitted in an EVERY clause, you can use
	# the same complex time units permitted in a + INTERVAL
	#
	# An EVERY clause may contain an optional STARTS clause.
	#
	# STARTS is followed by a timestamp value that indicates when the action should
	# begin repeating, and may also use + INTERVAL interval to specify an amount of time
	# "from now"
	#
	# For example, EVERY 3 MONTH STARTS CURRENT_TIMESTAMP + INTERVAL 1 WEEK means
	# "every three months, beginning one week from now"
	#
	# Similarly, you can express "every two weeks, beginning six hours and fiften
	# minutes from now" as EVERY 2 WEEK STARTS CURRENT_TIMESTAMP + INTERVAL '6:15' HOUR_MINUTE
	#
	# Not specifying STARTS is the same as using STARTS CURRENT_TIMESTAMP - that is, the action
	# specified for the event begins repeating immediately upon creation of the event.
	#
	# An EVERY clause may contain an optional ENDS clause.
	#
	# The ENDS keyword is followed by a timestamp value that tells MySQL when the event
	# should stop repeating.
	#
	# You may also use + INTERVAL interval with ENDS; for instance, EVERY 12 HOUR
	# STARTS CURRENT_TIMESTAMP + INTERVAL 30 MINUTE ENDS CURRENT_TIMESTAMP + INTERVAL 4 WEEK
	# is equivalent to "every twelve hours, beginning thirty minutes from now, and ending
	# four weeks from now".
	#
	# Not using ENDS means that the event continues executing indefinitly.
	#
	# ENDS supports the same syntax for complex time units as STARTS does.
	#
	# You may use STARTS, ENDS, both or neither in an EVERY clause.
	#
	# If a repeating event does not terminate within its scheduling interval,
	# the result may be multiple instances of the event executing simultaneously.
	#
	# If this is undesirable, you should institute a mechanism to prevent simultaneous
	# instances.
	#
	# For example, you could use the GET_LOCK() function, or row or table locking.
#
# The ON SCHEDULE clause may use expressions involving built-in MySQL functions
# and user variables to obtain any of the timestamp or interval values which it contains.
#
# You may not use stored functions or user-defined functions in such expressions, nor
# may you use any table references; however, you may use SELECT FROM DUAL.
#
# This is true for both CREATE_EVENT and ALTER_EVENT statements.
#
# References to stored functions, user-defined functions, and tables in such cases
# are specifically not permitted, and fail with an error (see Bug #22830)
#
# Times in the ON SCHEDULE clause are interpreted using the current session time_zone
# value.
#
# This becomes the event time zone; that is, the time zone that is used for event scheduling
# and is in effect within the event as it executes.
#
# These times are converted to UTC and stored along with the event time zone in the
# mysql.event table.
#
# This enables event execution to proceed as defined regardless of any subsequent
# changes to the server time zone or daylight saving time effects.
#
# For additional information about representation of event times, see SECTION 24.4.4, "EVENT METADATA"
#
# See also SECTION 13.7.6.18, "SHOW EVENTS SYNTAX", and SECTION 25.9, "THE INFORMATION_SCHEMA EVENTS TABLE"
#
# Normally, once an event has expired, it is immediately dropped.
#
# You can override this behavior by specifying ON COMPLETION PRESERVE.
#
# Using ON COMPLETION NOT PRESERVE merely makes the default nonpersistent behavior explicit.
#
# You can create an event but prevent it from being active using the DISABLE keyword.
#
# Alternatively, you can use ENABLE to make explicit the default status, which is active.
#
# This is most useful in conjunction with ALTER_EVENT (see SECTION 13.1.3, "ALTER EVENT SYNTAX")
#
# A third value may also appear in place of ENABLE or DISABLE; DISABLE ON SLAVE is set for
# the status of an event on a replication slave to indicate that the event was created on
# the master and replicated to the slave, but is not executed on the slave.
#
# See SECTION 17.4.1.16, "REPLICATION OF INVOKED FEATURES"
#
# You may supply a comment for an event using a COMMENT clause. Comment may be any string
# of up to 64 chars that you wish to use for describing the event.
#
# The comment text, being a string literal, must be surrounded by quotation marks.
#
# The DO clause specifies an action carried by the event, and consists of an SQL
# statement.
#
# Nearly any valid MySQL statement that can be used in a stored routine can also
# be used as the action statement for a scheduled event.
#
# (See SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS")
#
# For example, the following event e_hourly deletes all rows from the
# sessions table once per hour, where this table is part of the site_activity schema:
#
# 		CREATE EVENT e_hourly
# 			ON SCHEDULE
# 				EVERY 1 HOUR
# 			COMMENT 'Clears out sessions table each hour.'
# 			DO
# 				DELETE FROM site_activity.sessions;
#
# MySQL stores the sql_mode system variable setting in effect when an event is created
# or altered, and always executes the event with this setting in force, regardless of the
# current server SQL mode when the event begins executing.
#
# A CREATE_EVENT statement that contains an ALTER_EVENT statement in its DO clause appears
# to succeed; however, when the server attempts to execute the resulting scheduled event,
# the execution fails with an error.
#
# 		NOTE:
#
# 			Statements such as SELECT or SHOW that merely return a result set have no effect
# 			when used in an event; the output from these is not sent to the MySQL Monitor,
# 			nor is it stored anywhere.
#
# 			However, you can use statements such as SELECT_---_INTO and INSERT_INTO_---_SELECT
# 			that store a result.
#
# 			(See the next example in this section for an instance of the latter)
#
# The schema to which an event belongs is the default schema for table references in the DO clause.
#
# Any references to tables in other schemas must be qualified with the proper schema name.
#
# As with stored routines, you can use compound-statement syntax in the DO clause by using the
# BEGIN and END keywords, as shown here:
#
# 		delimiter |
#
# 		CREATE EVENT e_daily
# 			ON SCHEDULE
# 				EVERY 1 DAY
# 			COMMENT 'Saves total number of sessions then clears the table each day'
# 			DO
# 				BEGIN
# 					INSERT INTO site_activity.totals (time, total)
# 						SELECT CURRENT_TIMESTAMP, COUNT(*)
# 							FROM site_activity.sessions;
# 					DELETE FROM site_activity.sessions;
# 				END |
#
# 		delimiter ;
#
# This example uses the delimiter command to change the statement delimiter.
#
# See SECTION 24.1, "DEFINING STORED PROGRAMS"
#
# More complex compound statements, such as those used in stored routines, are possible
# in an event.
#
# This example uses local variables, an error handler, and a flow control construct:
#
# 		delimiter |
#
# 		CREATE EVENT e
# 			ON SCHEDULE
# 				EVERY 5 SECOND
# 			DO
# 				BEGIN
# 					DECLARE v INTEGER;
# 					DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
#
# 					SET v = 0;
#
# 					WHILE v < 5 DO
# 						INSERT INTO t1 VALUES (0);
# 						UPDATE t2 SET s1 = s1 + 1;
# 						SET v = v + 1;
# 					END WHILE;
# 			END |
#
# 		delimiter ;
#
# There is no way to pass parameters directly to or from events; however, it is
# possible to invoke a stored routine with parameters within an event:
#
# 		CREATE EVENT e_call_myproc
# 			ON SCHEDULE
# 				AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
# 			DO CALL myproc(5, 27);
#
# If an event's definer has privileges sufficient to set global system variables
# (see SECTION 5.1.9.1, "SYSTEM VARIABLE PRIVILEGES"), the event can read and write
# global variables.
#
# As granting such privileges entails a potential for abuse, extreme care must be
# taken in doing so.
#
# Generally, any statements that are valid in stored routines may be used for action
# statements executed by events.
#
# For more information about statements permissible within stored routines, see 
# SECTION 24.2.1, "STORED ROUTINE SYNTAX"
#
# You can create an event as part of a stored routine, but an event cannot be 
# created by another event.
#
# 13.1.14 CREATE FUNCTION SYNTAX
#
# The CREATE_FUNCTION statement is used to create stored functions and user-defined
# functions (UDFs):
#
# 		) For information about creating stored functions, see SECTION 13.1.17, "CREATE PROCEDURE AND CREATE FUNCTION SYNTAX"
#
# 		) For information about creating user-defined functions, see SECTION 13.7.4.1, "CREATE FUNCTION SYNTAX FOR USER-DEFINED FUNCTIONS"
#
# 13.1.15 CREATE INDEX SYNTAX
#
# CREATE [UNIQUE | FULLTEXT | SPATIAL] INDEX index_name
# 		[index_type]
# 		ON tbl_name (key_part, ---)
# 		[index_option]
# 		[algorithm_option | lock_option] ---
#
# key_part: {col_name [(length)] | (expr)} [ASC | DESC]
#
# index_option:
# 		KEY_BLOCK_SIZE [=] value
# 	 | index_type
# 	 | WITH PARSER parser_name
#   | COMMENT 'string'
#   | {VISIBILE | INVISIBILE}
#
# index_type:
# 		USING {BTREE | HASH}
#
# algorithm_option:
# 		ALGORITHM [=] {DEFAULT | INPLACE | COPY}
#
# lock_option:
# 		LOCK [=] {DEFAULT | NONE | SHARED | EXCLUSIVE}
#
# Normally, you create all indexes on a table at the time the table itself is created
# with CREATE_TABLE.
#
# See SECTION 13.1.20, "CREATE TABLE SYNTAX"
#
# This guideline is especially important for InnoDB tables, where the primary key
# determines the physical layout of rows in the data file.
#
# CREATE_INDEX enables you to add indexes to existing tables.
#
# CREATE_INDEX is mapped to an ALTER_TABLE statement to create indexes.
#
# See SECTION 13.1.9, "ALTER TABLE SYNTAX". CREATE_INDEX cannot be used to
# create a PRIMARY KEY; use ALTER_TABLE instead.
#
# For more information about indexes, see SECTION 8.3.1, "HOW MYSQL USES INDEXES"
#
# InnoDB supports secondary indexes on virtual columns. For more information,
# see SECTION 13.1.20.9, "SECONDARY INDEXES AND GENERATED COLUMNS"
#
# When the innodb_stats_persistent setting is enabled, run the ANALYZE_TABLE
# statement for an InnoDB table after creating an index on that table.
#
# An index specification of the form (key_part1, key_part2, ---) creates an index
# with multiple key parts.
#
# Index key values are formed by concatenating the values of the
# given key parts.
#
# For example (col1, col2, col3) specifies a multiple-column index with index
# keys consisting of values from col1, col2 and col3.
#
# A key_part specificaiton can end with ASC or DESC to specify whether index values 
# are stored in ascending or descending order.
#
# The default is ascending if no order specifier is given.
#
# ASC and DESC are not permitted for HASH indexes.
#
# As of MySQL 8.0.12, ASC and DESC are not permitted for SPATIAL indexes.
#
# The following sections describe different aspects of the CREATE_INDEX statement:
#
# 		) Column Prefix Key Parts
#
# 		) Functional Key parts
#
# 		) Unique Indexes
#
# 		) Full-Text Indexes
#
# 		) Spatial indexes
#
# 		) Index Options
#
# 		) Table Copying and Locking Options
#
# COLUMN PREFIX KEY PARTS
#
# For string columns, indexes can be created that use only the leading part of column values,
# using col_name(length) syntax to specify an index prefix length:
#
# 		) Prefixes can be specified for CHAR, VARCHAR, BINARY, and VARBINARY key parts
#
# 		) Prefixes must be specified for BLOB and TEXT key parts. Additionally, BLOB and TEXT columns
# 			can be indexed only for InnoDB, MyISAM, and BLACKHOLE tables.
#
# 		) Prefix limits are measured in bytes. However, prefix lengths for index specifications
# 			in CREATE_TABLE, ALTER_TABLE and CREATE_INDEX statements are interpreted as number
# 			of characters for nonbinary string types (CHAR, VARCHAR, TEXT) and number of bytes
# 			for binary string types (BINARY, VARBINARY, BLOB)
#
# 			Take this into account when specifying a prefix length for a nonbinary string column
# 			that uses a multibyte character set.
#
# 			Prefix support and lengths of prefixes (where supported) are storage engine dependent.
#
# 			For example, a prefix can be up to 767 bytes long for InnoDB tables that use the
# 			REDUNDANT or COMPACT row format.
#
# 			The prefix length limit is 3072 bytes for InnoDB tables that use the DYNAMIC
# 			or COMPRESSED row format.
#
# 			For MyISAM tables, the prefix length is 1000 bytes.
#
# 			The NDB storage engine does not support prefixes (see SECTION 22.1.7.6, "UNSUPPORTED OR MISSING FEATURES IN NDB CLUSTER")
#
# If a specified index prefix exceeds the maximum column data type size, CREATE_INDEX handles
# the index as follows:
#
# 		) For a nonunique index, either an error occurs (if strict SQL mode is enabled), or the index length is
# 			reduced to lie within the maximum column data type size and a warning is produced
# 			(if strict SQL mode is not enabled)
#
# 		) For a unique index, an error occurs regardless of SQL mode because reducing the index length
# 			might enable insertion of nonunique entries that do not meet the specified uniqueness requirement.
#
# The statement shown here creates an index using the first 10 characters of the name column
# (assuming that name has a nonbinary string type):
#
# 		CREATE INDEX part_of_name ON customer (name(10));
#
# If names in the column usually differ in the first 10 characters, lookups performed using
# this index should not be much slower than using an index created from the entire
# name column.
#
# Also, using column prefixes for indexes can make the index file much smaller, which could
# save a lot of disk space and might also speed up INSERT operations.
#
# FUNCTIONAL KEY PARTS
#
# A "normal" index indexes column values or prefixes of column values.
#
# For example, in teh following table, the index entry for a given t1 row includes
# the full col1 value and a prefix of the col2 value consisting of its first 10 bytes:
#
# 		CREATE TABLE t1 (
# 			col1 VARCHAR(10),
# 			col2 VARCHAR(20),
# 			INDEX (col1, col2(10))
# 		);
#
# MySQL 8.0.13 and higher supports functional key parts that index expression
# values rather than column or column prefix values.
#
# Use of functional key parts enables indexing of values not stored directly
# in the table. 
#
# Examples:
#
# 		CREATE TABLE t1 (col1 INT, col2 INT, INDEX func_index ((ABS(col1))));
# 		CREATE INDEX idx1 ON t1 ((col1 + col2));
# 		CREATE INDEX idx2 ON t1 ((col1 + col2), (col1 - col2), col1);
# 		ALTER TABLE t1 ADD INDEX ((col1 * 40) DESC);
#
# An index with multiple key parts can mix nonfunctional and functional key parts.
#
# ASC and DESC are supported for functional key parts.
#
# Functional key parts must adhere to the following rules. An error occurs if a key
# part definition contains disallowed constructs.
#
# 		) In index definitions, enclose expressions within parentheses to distinguish them from 
# 			columns or column prefixes.
#
# 			For example, this is permitted; the expressions are enclosed within parentheses:
#
# 				INDEX ((col1 + col2), (col3 - col4))
#
# 			This produces an error, the expressions are not enclosed within parentheses:
#
# 				INDEX (col1 + col2, col3 - col4)
#
# 		) A functional key part cannot consist solely of a column name. 
#
# 			For example, this is not permitted:
#
# 				INDEX ((col1), (col2))
#
# 			Instead, write the key parts as nonfunctional key parts, without parentheses:
#
# 				INDEX (col1, col2)
#
# 		) A functional key part expression cannot refer to column prefixes.
#
# 			For a workaround, see the discussion of SUBSTRING() and CAST() later in this section.
#
# 		) Functional key parts are not permitted in foreign key specifications.
#
# For CREATE_TABLE_---_LIKE, the destination table preserves functional key parts from the 
# original table.
#
# Functional indexes are implemented as hidden virtual generated columns, which has these implications:
#
# 		) Each functional key part counts against the limit on total number of table columns; See SECTION C.10.4, "LIMITS ON TABLE COLUMN COUNT AND ROW SIZE"
#
# 		) Functional key parts inherit all restrictions that apply to generated columns. Examples:
#
# 			) Only functions permitted for generated columns are permitted for functional key parts
#
# 			) Subqueries, parameters, variables, stored functions, and user-defined functions are not permitted.
#
# 			For more information about applicable restrictions, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
# 			and SECTION 13.1.9.2, "ALTER TABLE AND GENERATED COLUMNS"
#
# 		) The virtual generated column itself requires no storage.
#
# 			The index itself takes up storage space as any other index.
#
# UNIQUE is supported for indexes that include functional key parts. However, primary keys cannot
# include functional key parts.
#
# A primary key requires the generated column to be stored, but functional key parts are implemented
# as virtual generated columns, not stored generated columns.
#
# SPATIAL and FULLTEXT indexes cannot have functional key parts.
#
# If a table contains no primary key, InnoDB automatically promotes the first UNIQUE NOT FULL
# index to the primary key.
#
# This is not supported for UNIQUE NOT NULL indexes that have functional key parts.
#
# Nonfunctional indexes raise a warning if there are duplicate indexes.
#
# Indexes that contain functional key parts do not have this feature.
#
# To remove a column that is referenced by a functional key part, the index
# must be removed first.
#
# Otherwise, an error occurs.
#
# Although nonfunctional key parts support a prefix length specification, this
# is not possible for functional key parts.
#
# The solution is to use SUBSTRING() (or CAST(), as described later in this section)
#
# For a functional key part containing the SUBSTRING() function to be used in a query,
# the WHERE clause must contain SUBSTRING() with the same arguments.
#
# In the following example, only the second SELECT is able to use the index because
# that is the only query in which the arguments to SUBSTRING() match the index
# specification:
#
# 		CREATE TABLE tbl (
# 			col1 LONGTEXT,
# 			INDEX idx1 ((SUBSTRING(col1, 1, 10)))
# 		);
# 		SELECT * FROM tbl WHERE SUBSTRING(col1, 1, 9) = '123456789';
# 		SELECT * FROM tbl WHERE SUBSTRING(col1, 1, 10) = '1234567890';
#
# Functional key parts enable indexing of values that cannot be indexed otherwise,
# such as JSON values.
#
# However, this must be done correctly to achieve the desired effect.
#
# For example, this syntax does not work:
#
# 		CREATE TABLE employees (
# 			data JSON,
# 			INDEX ((data->>'$.name'))
# 		);
#
# This syntax fails because:
#
# 		) The ->> operator translates into JSON_UNQUOTE(JSON_EXTRACT(---))
#
# 		) JSON_UNQUOTE() returns a value with a data type of LONGTEXT, and the hidden generated
# 			column thus is assigned the same data type.
#
# 		) MySQL cannot index LONGTEXT columns specified without a prefix length on the key part,
# 			and prefix lengths are not permitted in functional key parts.
#
# To index the JSON column, you could try using the CAST() function as follows:
#
# 		CREATE TABLE employees (
# 			data JSON,
# 			INDEX ((CAST(data->>'$.name' AS CHAR(30))))
# 		);
#
# The hidden generated column is assigned the VARCHAR(30) data type, which can be indexed.
#
# But this approach produces a new issue when trying to use theh index:
#
# 		) CAST() returns a string with the collation utf8mb4_0900_ai_ci (the server default collation)
#
# 		) JSON_UNQUOTE() returns a string with the collation utf8mb4_bin (hard coded)
#
# As a result, there is a collation mismatch between the indexed expression in the preceding
# table definition and the WHERE clause expression in the following query:
#
# 		SELECT * FROM employees WHERE data->>'$.name' = 'James';
#
# The index is not used because the expression in the query and the index differ.
#
# To support this kind of scenario for functional key parts, the optimizer automatically
# strips CAST() when looking for an index to use, but only if the collation of the indexed
# expression matches that of the query expression.
#
# For an index with a functional key part to be used, either of the following two solutions
# work (although they differ somewhat in effect):
#
# 		) Solution 1.  Assign the indexed expression the same collation as JSON_UNQUOTE():
#
	# 			CREATE TABLE employees (
	# 				data JSON,
	# 				INDEX idx ((CAST(data->>"$.name" AS CHAR(30)) COLLATE utf8mb4_bin))
	# 			);
	# 			INSERT INTO employees VALUES
	# 				('{ "name": "james", "salary": 9000 }'),
	# 				('{ "name": "James", "salary": 10000 }'),
	# 				('{ "name": "Mary", "salary": 12000 }'),
	# 				('{ "name": "Peter", "salary": 8000 }');
	# 			SELECT * FROM employees WHERE data->>'$.name' = 'James';
#
# 			The ->> operator is the same as JSON_UNQUOTE(JSON_EXTRACT(---)), and JSON_UNQUOTE()
# 			returns a string with collation utf8mb4_bin
#
# 			The comparison is thus case sensitive, and only one row matches:
#
# 				+--------------------------------------------+
# 				| data 													|
# 				+--------------------------------------------+
# 				| {"name": "James", "salary": 10000} 		   |
# 				+--------------------------------------------+
#
# 		) Solution 2. Specify the full expression in the query:
#
	# 			CREATE TABLE employees (
	# 				data JSON,
	# 				INDEX idx ((CAST(data->>"$.name" AS CHAR(30))))
	# 			);
	# 			INSERT INTO employees VALUES
	# 				('{ "name": "james", "salary": 9000 }'),
	# 				('{ "name": "James", "salary": 10000 }'),
	# 				('{ "name": "Mary", "salary": 12000 }'),
	# 				('{ "name": "Peter", "salary": 8000 }');
	# 			SELECT * FROM employees WHERE CAST(data->>'$.name' AS CHAR(30)) = 'James';
#
# 		
# 			CAST() returns a string with collation utf8mb4_0900_ai_ci, so the comparison case
# 			insensitive and two rows match:
#
# 				+----------------------------------------------+
# 				| data 													  |
# 				+----------------------------------------------+
# 				| {"name": "james", "salary": 9000} 			  |
# 				| {"name": "James", "salary": 10000} 			  |
# 				+----------------------------------------------+
#
# 			Be aware that although the optimizer supports automatically stripping CAST() with indexed
# 			generated columns, the following approach does not work because it produces a different
# 			result with and without an index (Bug#27337092):
#
# 				CREATE TABLE employees (
# 					data JSON,
# 					generated_col VARCHAR(30) AS (CAST(data->>'$.name' AS CHAR(30)))
# 				);
# 				Query OK, 0 rows affected, 1 warning (0.03 sec)
#
# 				INSERT INTO employees (data)
# 				VALUES ('{"name": "james"}'), ('{"name": "James"}');
# 				Query OK, 2 rows affected, 1 warning (0.01 sec)
# 				Records: 2 Duplicates: 0 Warnings: 1
#
# 				SELECT * FROM employees WHERE data->>'$.name' = 'James';
# 				+------------------------------+----------------------+
# 				| data 								 | generated_col 			|
# 				+------------------------------+----------------------+
# 				| {"name": "James"} 				 | James 					|
# 				+------------------------------+----------------------+
# 				1 row in set (0.00 sec)
#
# 				ALTER TABLE employees ADD INDEX idx (generated_col);
# 				Query OK, 0 rows affected, 1 warning (0.03 sec)
# 				Records: 0 Duplicates: 0 Warnings: 1
#
# 				SELECT * FROM employees WHERE data->>'$.name' = 'James';
# 				+------------------------------+----------------------+
# 				| data 								 | generated_col 		   |
# 				+------------------------------+----------------------+
# 				| {"name": "james"} 				 | james 					|
# 				| {"name": "James"} 				 | James 					|
# 				+------------------------------+----------------------+
# 				2 rows in set (0.01 sec)
#
# UNIQUE INDEXES
#
# A UNIQUE index creates a constraint such that all values in the index must be
# distinct.
#
# An error occurs if you try to add a new row with a key value that matches an
# existing row.
#
# If you specify a prefix value for a column in a UNIQUE index, the column values
# must be unique within the prefix length.
#
# A UNIQUE index permits multiple NULL values for columns that can contain NULL
#
# If a table has a PRIMARY KEY or UNIQUE NOT NULL index that consists of a single
# column that has an integer type, you can use _rowid to refer to the indexed
# column in SELECT statements, as follows:
#
# 		) _rowid refers to the PRIMARY KEY column if there is a PRIMARY KEY consisting
# 			of a single integer column.
#
# 			If there is a PRIMARY KEY but it does not consist of a single integer column,
# 			_rowid cannot be used.
#
# 		) Otherwise, _rowid refers to the column in the first UNIQUE NOT NULL index if that
# 			index consists of a single integer column.
#
# 			If the first UNIQUE NOT NULL index does not consist of a single integer column,
# 			_rowid cannot be used.
#
# FULL-TEXT INDEXES
#
# FULLTEXT indexes are supported only for InnoDB and MyISAM tables and can include only
# CHAR, VARCHAR and TEXT columns.
#
# Indexing always happens over the entire column; column prefix indexing is not
# supported and any prefix length is ignored if specified.
#
# See SECTION 12.9, "FULL-TEXT SEARCH FUNCTIONS", for details of operation.
#
# SPATIAL INDEXES
#
# The MyISAM, InnoDB, NDB and ARCHIVE storage engines support spatial columns such as
# POINT and GEOMETRY.
#
# (SECTION 11.5, "SPATIAL DATA TYPES", describes the spatial data types)
#
# However, support for spatial column indexing varies among engines.
#
# Spatial and nonspatial indexes on spatial columns are available according to
# the following rules.
#
# Spatial indexes on spatial columns have these characteristics:
#
# 		) Available only for InnoDB and MyISAM tables. Specifying SPATIAL INDEX for other storage engines results in an error.
#
# 		) As of MySQL 8.0.12, an index on a spatial column MUST be a SPATIAL index.
#
# 			The SPATIAL keyword is thus optional but implicit for creating an index on a spatial column.
#
# 		) Available for single spatial columns only. A spatial index cannot be created over multiple spatial columns.
#
# 		) Indexed columns must be NOT NULL
#
# 		) Column prefix lengths are prohibited. The full width of each column is indexed.
#
# 		) Not permitted for a primary key or unique index
#
# Nonspatial indexes on spatial columns (created with INDEX, UNIQUE, or PRIMARY KEY) have these
# characteristics:
#
# 		) Permitted for any storage engine that supports spatial columns except ARCHIVE
#
# 		) Columns can be NULL unless the index is a primary key
#
# 		) The index type for a non-SPATIAL index depends on the storage engine. Currently, B-tree is used.
#
# 		) Permitted for a column that can have NULL values only for InnoDB, MyISAM, and MEMORY tables
#
# INDEX OPTIONS
#
# Following the key part list, index options can be given.
#
# An index_option value can be any of the following:
#
# 		) KEY_BLOCK_SIZE [=] value
#
# 			For MyISAM tables, KEY_BLOCK_SIZE optionally specifies the size in bytes to use
# 			for index key blocks.
#
# 			The value is treated as a hint; a different size could be used if necessary.
#
# 			A KEY_BLOCK_SIZE value specified for an individual index definition overrides
# 			a table-level KEY_BLOCK_SIZE value.
#
# 			KEY_BLOCK_SIZE is not supported at the index level for InnoDB tables.
#
# 			See SECTION 13.1.20, "CREATE TABLE SYNTAX"
#
# 		) index_type
#
# 			Some storage engines permit you to specify an index type when creating an index.
#
# 			For example:
#
# 				CREATE TABLE lookup (id INT) ENGINE = MEMORY;
# 				CREATE INDEX id_index ON lookup (id) USING BTREE;
#
# 			TABLE 13.1, "INDEX TYPES PER STORAGE ENGINE" shows the permissible index type values
# 			supported by different storage engines.
#
# 			Where multiple index types are listed, the first one is the default when no
# 			index type specifier is given.
#
# 			Storage engines not listed in the table do not support an index_type clause
# 			in index definitions.
#
	# 			TABLE 13.1 INDEX TYPES PER STORAGE ENGINE
	#
	# 			STORAGE ENGINE 			PERMISSIBILE INDEX TYPES
	#
	# 			InnoDB 						BTREE
	#
	# 			MyISAM 						BTREE
	#
	# 			MEMORY/HEAP 				HASH, BTREE
	#
	# 			NDB 							HASH, BTREE (see note in text)
#
# 			The index_type clause cannot be used for FULLTEXT INDEX or (prior to MySQL 8.0.12)
# 			SPATIAL INDEX specifications.
#
# 			Full-text index implementation is storage engine dependent.
#
# 			Spatial indexes are implemented as R-tree indexes.
#
# 			If you specify an index type that is not valid for a given storage engine,
# 			but another index type is available that the engine can use without affecting
# 			query results, the engine uses the available type.
#
# 			The parser recognizes RTREE as a type name. AS of MySQL 8.0.12, this is permitted
# 			only for SPATIAL indexes.
#
# 			Prior to 8.0.12, RTREE cannot be specified for any storage engine.
#
# 			BTREE indexes are implemented by the NDB storage engine as T-tree indexes.
#
# 				NOTE:
#
# 					For indexes on NDB table columns, the USING option can be specified only
# 					for a unique index or primary key.
#
# 					USING HASH prevents the creation of an ordered index; otherwise,
# 					creating a unique index or primary key on an NDB table automatically
# 					results in the creation of both an ordered index and a hash index,
# 					each of which indexes the same set of columns.
#
# 					For unique indexes that include one or more NULL columns of an NDB
# 					table, the hash index can be used only to look up literal values,
# 					which means that IS [NOT] NULL conditions require a full scan of the table.
#
# 					One workaround is to make sure that a unique index using one or more NULL
# 					columns on such a table is always created in such a way that it includes
# 					the ordered index; that is, avoid employing USING HASH when creating the
# 					index.
#
# 			If you specify an index type that is not valid for a given storage engine, but another
# 			index type is available that the engine can use without affecting query results,
# 			the engine uses the available type.
#
# 			The parser recognizes RTREE as a type name, but currently this cannot be specified
# 			for any storage engine.
#
# 				NOTE:
#
# 					Use of the index_type option before the ON tbl_name clause is deprecated;
# 					support for use of the option in this position will be removed in a 
# 					future MySQL release.
#
# 					If an index_type option is given in both the earlier and later positions,
# 					the final option applies.
#
# 			TYPE type_name is recognized as a synonym for USING type_name.
#
# 			However, USING is the preferred form.
#
# 			The following tables show index characteristics for the storage engines that
# 			support the index_type option.
#
# 				TABLE 13.2 InnoDB STORAGE ENGINE INDEX CHARACTERISTICS
#
# 					INDEX CLASS 		INDEX TYPE 		STORES NULL VALUES 		PERMITS MULTIPLE NULL VALUES 	IS NULL SCAN TYPE 		IS NOT NULL SCAN TYPE
#
# 					Primary key 		BTREE 			No 							No 									N/A 							N/A
# 					Unique 				BTREE 			Yes 							Yes 									Index 						Index
# 					Key 					BTREE 			Yes 							Yes 									Index 						Index
# 					FULLTEXT 			N/A 				Yes 							Yes 									Table 						Table
# 					SPATIAL 				N/A 				No 							No 									N/A 							N/A
#
# 				Table 13.3 MyISAM Storage Engine Index Characteristics
#
# 					INDEX CLASS 		INDEX TYPE 		STORES NULL VALUES 		PERMITS MULTIPLE NULL VALUES 	IS NULL SCAN TYPE 		IS NOT NULL SCAN TYPE
#
# 					Primary key 		BTREE 			No 							No 									N/A 							N/A
# 					Unique 				BTREE 			Yes 							Yes 									Index 						Index
# 					Key 					BTREE 			Yes 							Yes 									Index 						Index
# 					FULLTEXT 			N/A 				Yes 							Yes 									Table 						Table
# 					SPATIAL 				N/A 				No 							No 									N/A 							N/A
#
# 				Table 13.4 MEMORY Storage Engine Index Characteristics
#
# 					INDEX CLASS 		INDEX TYPE 		STORES NULL VALUES 		PERMITS MULTIPLE NULL VALUES 	IS NULL SCAN TYPE 		IS NOT NULL SCAN TYPE
#
# 					Primary key 		BTREE 			No 							No 									N/A 							N/A
# 					Unique 				BTREE 			Yes 							Yes 									Index 						Index
# 					Key 					BTREE 			Yes 							Yes 									Index 						Index
# 					Primary key 		HASH 				No 							No 									N/A 							N/A
# 					Unique 				HASH 				Yes 							Yes 									Index 						Index
# 					Key 					HASH 				Yes 							Yes 									Index 						Index
#
# 				Table 13.5 NDB Storage Engine Index Characteristics
#
# 					INDEX CLASS 		INDEX TYPE 		STORES NULL VALUES 		PERMITS MULTIPLE NULL VALUES 	IS NULL SCAN TYPE 		IS NOT NULL SCAN TYPE
#
# 					Primary key 		BTREE 			No 							No 									Index 						Index
# 					Unique 				BTREE 			Yes 							Yes 									Index 						Index
# 					Key 					BTREE 			Yes 							Yes 									Index 						Index
# 					Primary key 		HASH 				No 							No 									Table (see note 1) 		Table (see note 1)
# 					Unique 				HASH 				Yes 							Yes 									Table (see note 1) 		Table (see note 1)
# 					Key 					HASH 				Yes 							Yes 									Table (see note 1) 		Table (see note 1)
#
# 			Table note:
#
# 				1. USING HASH prevents creation of an implicit ordered index
#
# 		) WITH PARSER parser_name
#
# 			This option can be used only with FULLTEXT indexes.
#
# 			It associates a parser plugin with the index if full-text indexing and searching
# 			operations need special handling.
#
# 			InnoDB and MyISAM support full-text parser plugins
#
# 			See FULL-TEXT PARSER PLUGINS and SECTION 29.2.4.4, "WRITING FULL-TEXT PARSER PLUGINS"
# 			for more information.
#
# 		) COMMENT 'string'
#
# 			Index definitions can include an optional comment of up to 1024 characters
#
# 			The MERGE_THRESHOLD for index pages can be configured for individual indexes using the
# 			index_option COMMENT clause of the CREATE_INDEX statement.
#
# 			For example:
#
# 				CREATE TABLE t1 (id INT);
# 				CREATE INDEX id_index ON t1 (id) COMMENT 'MERGE_THRESHOLD=40';
#
# 			If the page-full percentage for an index page falls below the MERGE_THRESOLD value
# 			when a row is deleted or when a row is shortened by an update operation, InnoDB
# 			attempts to merge the index page with a neighboring index page.
#
# 			The default MERGE_THRESHOLD value is 50, which is the previously hardcoded value.
#
# 			MERGE_THRESHOLD can also be defined at the index level using CREATE_TABLE and ALTER_TABLE statements.
#
# 			For more information, see SECTION 15.8.11, "CONFIGURING THE MERGE THRESHOLD FOR INDEX PAGES"
#
# 		) VISIBLE, INVISIBLE
#
# 			Specify index visibility.
#
# 			Indexes are visible by default. An invisible index is not used by the optimizer.
#
# 			Specification of index visibility applies to indexes other than primary keys
# 			(either explicit or implicit)
#
# 			For more information, see SECTION 8.3.12, "INVISIBLE INDEXES"
#
# TABLE COPYING AND LOCKING OPTIONS
#
# ALGORITHM and LOCK clauses may be given to influence the table copying method and
# level of concurrency for reading and writing the table while its indexes are being modified.
#
# They have the same meanings as for the ALTER_TABLE statement.
#
# For more information, see SECTION 13.1.9, "ALTER TABLE SYNTAX"
#
# NDB Cluster supports online operations using the same ALGORITHM=INPLACE syntax used
# with the standard MySQL server.
#
# See SECTION 22.5.14, "ONLINE OPERATIONS WITH ALTER TABLE IN NDB CLUSTER", for more information.
#
# 13.1.16 CREATE LOGFILE GROUP SYNTAX
#
# CREATE LOGFILE GROUP logfile_group
# 		ADD UNDOFILE 'undo_file'
# 		[INITIAL_SIZE [=] initial_size]
# 		[UNDO_BUFFER_SIZE [=] undo_buffer_size]
# 		[REDO_BUFFER_SIZE [=] redo_buffer_size]
# 		[NODEGROUP [=] nodegroup_id]
# 		[WAIT]
# 		[COMMENT [=] 'string']
# 		ENGINE [=] engine_name
#
# This statement creates a new log file group named logfile_group having a single
# UNDO file named 'undo_file'
#
# A CREATE_LOGFILE_GROUP statement has one and only one ADD UNDOFILE clause
#
# For rules covering the naming of log file groups, see SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# NOTE:
#
# 		All NDB Cluster Disk Data objects share the same namespace.
#
# 		This means that each Disk Data Object must be uniquely named
# 		(and not merely each Disk Data object of a given type)
#
# 		For example, you cannot have a tablespace and a log file group
# 		with the same name, or a tablespace and a data file with the same name.
#
# There can be only one log file group per NDB Cluster instance at any given time.
#
# The optional INITIAL_SIZE parameter sets the UNDO file's initial size; if not specified,
# it defaults to 128M (128 megabytes)
#
# The optional UNDO_BUFFER_SIZE parameter sets the size used by the UNDO buffer
# for the log file group; The default value for UNDO_BUFFER_SIZE is 8M (eight MB);
# This value cannot exceed the amount of system memory available.
#
# Both of these parameters are specified in bytes.
#
# You may optionally follow either or both of these with a one-letter
# abbreviation for an order of magnitude, similar to those used in my.cnf
#
# Generally, this is one of the letters M (for megabytes) or G (for gigabytes)
#
# Memory used for UNDO_BUFFER_SIZE comes from the global pool whose size is
# determined by the value of the SharedGlobalMemory data node configuration
# parameter.
#
# This includes any default value implied for this option by the setting
# of the InitialLogFileGroup data node configuration parameter.
#
# The maximum permitted for UNDO_BUFFER_SIZE is 629145600 (600 MB)
#
# On 32-bit systems, the maximum supported value for INITIAL_SIZE 
# is 4294967296 (4 GB) (Bug #29186)
#
# The minimum allowed value for INITIAL_SIZE is 1048576 (1 MB)
#
# The ENGINE option determines the storage engine to be used by this log file group,
# with engine_name being the name of the storage engine.
#
# In MySQL 8.0, this must be NDB (or NDBCLUSTER)
#
# If ENGINE is not set, MySQL tries to use the engine specified by the default_storage_engine
# server system variable (formerly storage engine)
#
# In any case, if the engine is not specified as NDB or NDBCLUSTER, the CREATE LOGFILE GROUP
# statement appears to succeed but actually fails to create the log file group, as shown
# here:
#
# 		CREATE LOGFILE GROUP lg1
# 			ADD UNDOFILE 'undo.dat' INITIAL_SIZE = 10M;
# 		Query OK, 0 rows affected, 1 warning (0.00 sec)
#
# 		SHOW WARNINGS;
# 		+-----------+-----------+------------------------------------------------------------------------------------------------+
# 		| Level 		| Code 		| Message 																								 					 |
# 		+-----------+-----------+------------------------------------------------------------------------------------------------+
# 		| Error 		| 1478 	   | Table storage engine 'InnoDB' does not support the create option 'TABLESPACE or LOGFILE GROUP' |
# 		+-----------+-----------+------------------------------------------------------------------------------------------------+
# 		1 row in set (0.00 sec)
#
# 		DROP LOGFILE GROUP lg1 ENGINE = NDB;
# 		ERROR 1529 (HY000): Failed to drop LOGFILE GROUP
#
# 		CREATE LOGFILE GROUP lg1
# 			ADD UNDOFILE 'undo.dat' INITIAL_SIZE = 10M
# 			ENGINE = NDB;
# 		Query OK, 0 rows affected (2.97 sec)
#
# The fact that the CREATE LOGFILE GROUP statement does not actually return an error when a non-NDB storage
# engine is named, but rather appears to succeed, is a known issue which we hope to address in a future
# release of NDB Cluster.
#
# REDO_BUFFER_SIZE, NODEGROUP, WAIT and COMMENT are parsed but ignored, and so have no effect in MySQL 8.0
#
# These options are intended for future expansion
#
# When used with ENGINE [=] NDB, a log file group and associated UNDO log file are created on each Cluster
# data node.
#
# You can verify that the UNDO files were created and obtain information about them by querying the
# INFORMATION_SCHEMA.FILES table.
#
# For example:
#
# 		SELECT LOGFILE_GROUP_NAME, LOGFILE_GROUP_NUMBER, EXTRA
# 			FROM INFORMATION_SCHEMA.FILES
# 			WHERE FILE_NAME = 'undo_10.dat';
# 		+-------------------------+------------------------------+--------------------+
# 		| LOGFILE_GROUP_NAME 	  | LOGFILE_GROUP_NUMBER 		   | EXTRA 					|
# 		+-------------------------+------------------------------+--------------------+
# 		| lg_3 						  | 11 								   | CLUSTER_NODE=3 	   |
# 		| lg_3 						  | 11 									| CLUSTER_NODE=4 		|
# 		+-------------------------+------------------------------+--------------------+
#
# CREATE_LOGFILE_GROUP is useful only with Disk Data storage for NDB Cluster.
#
# See SECTION 22.5.13, "NDB CLUSTER DISK DATA TABLES"
#
# 13.1.17 CREATE PROCEDURE AND CREATE FUNCTION SYNTAX
#
# 		CREATE
# 			[DEFINER = { user | CURRENT_USER }]
# 			PROCEDURE sp_name ([proc_parameter[,---]])
# 			[characteristic ---] routine_body
#
# 		CREATE
# 			[DEFINER = { user | CURRENT_USER }]
# 			FUNCTION sp_name ([func_parameter[,---]])
# 			RETURNS type
# 			[characteristic ---] routine_body
#
# 		proc_parameter:
# 			[ IN | OUT | INOUT ] param_name type
#
# 		func_parameter:
# 			param_name type
#
# 		type:
# 			Any valid MySQL data type
#
# 		characteristic:
# 			COMMENT 'string'
# 		 | LANGUAGE SQL
# 		 | [NOT] DETERMINISTIC
# 		 | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
# 		 | SQL SECURITY { DEFINER | INVOKER }
#
# 		routine_body:
# 			Valid SQL routine statement
#
# These statements create stored routines.
#
# By default, a routine is associated with the default database.
#
# To associate the routine explicitly with a given database, specify the
# name as db_name.sp_name when you create it.
#
# The CREATE_FUNCTION statement is also used in MySQL to support UDFs (user-defined functions)
#
# See SECTION 29.4, "ADDING NEW FUNCTIONS TO MYSQL"
#
# A UDF can be regarded as an external stored function. Stored functions share their namespace with
# UDFs.
#
# See SECTION 9.2.4, "FUNCTION NAME PARSING AND RESOLUTION", for the rules describing how the server
# interprets references to different kinds of functions.
#
# To invoke a stored procedure, use the CALL statement (see SECTION 13.2.1, "CALL SYNTAX")
#
# To invoke a stored function, refer to it in an expression. The function returns a
# value during expression evaluation.
#
# CREATE_PROCEDURE and CREATE_FUNCTION require the CREATE_ROUTINE privilege.
#
# They might also require the SET_USER_ID or SUPER privilege, depending on the
# DEFINER value, as described later in this section.
#
# If binary logging is enabled, CREATE_FUNCTION might require the SUPER privilege,
# as described in SECTION 24.7, "BINARY LOGGING OF STORED PROGRAMS"
#
# By default, MySQL automatically grants the ALTER_ROUTINE and EXECUTE privileges
# to the routine creator.
#
# This behavior can be changed by disabling the automatic_sp_privileges system variable.
#
# See SECTION 24.2.2, "STORED ROUTINES AND MYSQL PRIVILEGES"
#
# The DEFINER and SQL SECURITY clauses specify the security context to be used when
# checking access privileges at routine execution time, as described later in this section.
#
# If the routine name is the same as the name of a built-in SQL function, a syntax error occurs
# unless you use a space between the name and the following parenthesis when defining
# the routine or invoking it later.
#
# For this reason, avoid using the names of existing SQL functions for your own stored routines.
#
# The IGNORE_SPACE SQL mode applies to built in functions, not to stored routines.
#
# IT is always permissibile to have spaces after a stored routine name, regardless
# of whether IGNORE_SPACE is enabled.
#
# The parameter list enclosed within parentheses must always be present.
#
# If there are no parameters, an empty parameter list of () should be used.
#
# Parameter names are not case sensitive.
#
# Each parameter is an IN parameter by default. To specify otherwise for a parameter,
# use the keyword OUT or INOUT before the parameter name.
#
# NOTE:
#
# 		Specifying a parameter as IN, OUT, or INOUT is valid only for a PROCEDURE.
#
# 		For a FUNCTION, parameters are always regarded as IN parameters.
#
# An IN parameter passes a value into a procedure.
#
# The procedure might modify the value, but the modification is not visible
# to the caller when the procedure returns.
#
# An OUT parameter passes a value from the procedure back to the caller.
#
# Its initial value is NULL within the procedure, and its value is visible
# to the caller when the procedure returns.
#
# An INOUT parameter is initialized by the caller, can be modified by the
# procedure, and any change made by the procedure is visible to the caller
# when the procedure returns.
#
# For each OUT or INOUT parameter, pass a user-defined variable in the CALL
# statement that invokes the procedure so that you can obtain its value
# when the procedure returns.
#
# If you are calling the procedure from within another stored procedure or
# function, you can also pass a routine parameter or local routine variable
# as an OUT or INOUT parameter.
#
# If you are calling the procedure from within a trigger, you can also pass
# NEW.col_name as an OUT or INOUT parameter.
#
# For information about the effect of unhandled conditions on procedure params,
# see SECTION 13.6.7.8, "CONDITION HANDLING AND OUT OR INOUT PARAMETERS"
#
# Routine parameters cannot be referenced in statements prepared within the
# routine; see SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS"
#
# The following example shows a simple stored procedure that uses an OUT parameter:
#
# 		delimiter //
#
# 		CREATE PROCEDURE simpleproc (OUT param1 INT)
# 		BEGIN
# 			SELECT COUNT(*) INTO param1 FROM t;
# 		END//
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		delimiter ;
#
# 		CALL simpleproc(@a);
# 		Query OK, 0 rows affected (0.00 sec)
# 
# 		SELECT @a;
# 		+---------+
# 		| @a 		 |
# 		+---------+
# 		| 3 		 |
# 		+---------+
# 		1 row in set (0.00 sec)
#
# The example uses the mysql client delimiter command to change the statement
# delimiter from ; to // while the procedure is being defined.
#
# This enables the ; delimiter used in the procedure body to be passed through
# to the server rather than being interpreted by mysql itself.
#
# See SECTION 24.1, "DEFINING STORED PROGRAMS"
#
# The RETURNS clause may be specified only for a FUNCTION, for which it is mandatory.
#
# It indicates the return type of the function, and the function body must contain
# a RETURN value statement.
#
# If the RETURN statement returns a value of a different type, the value is coerced
# to the proper type.
#
# For example, if a function specifies an ENUM or SET value in the RETURNS clause,
# but the RETURN statement returns an integer, the value returned from the function
# is the string for the corresponding ENUM member of set of SET members.
#
# The following example function takes a parameter, performs an operation using an
# SQL function, and returns the result.
#
# In this case, it is unnecessary to use delimiter because the function definition
# contains no internal ; statement delimiters:
#
# 			CREATE FUNCTION hello (s CHAR(20))
# 			RETURNS CHAR(50) DETERMINISTIC
# 			RETURN CONCAT('Hello, ',s,'!');
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT hello('world');
# 		+--------------------+
# 		| hello('world') 		|
# 		+--------------------+
# 		| Hello, world! 		|
# 		+--------------------+
# 		1 row in set (0.00 sec)
#
# Parameter types and function return types can be declared to use any valid data type.
#
# The COLLATE attribute can be used if preceded by a CHARACTER SET specification.
#
# The routine_body consists of a valid SQL routine statement.
#
# This can be a simple statement such as SELECT or INSERT, or a compound statement
# written using BEGIN and END.
#
# Compound statements can contain declarations, loops, and other control structure
# statements.
#
# The syntax for these statements is described in SECTION 13.6, "COMPOUND-STATEMENT SYNTAX"
#
# MySQL permits routines to contain DDL statements, such as CREATE and DROP.
#
# MySQL also permits stored procedures (but not stored functions) to contain
# SQL transaction statements such as COMMIT.
#
# Stored functions may not contain statements that perform explicit or implicit
# commit or rollback.
#
# Support for these statements is not required by the SQL standard, which states
# that  each DBMS vendor may decide whether to permit them.
#
# Statements that return a result can be used within a stored procedure but not
# within a stored function.
#
# This prohibition includes SELECT statements that do not have an INTO var_list clause
# and other statements such as SHOW, EXPLAIN and CHECK_TABLE
#
# FOr statements that cna be determined at function definition time to return a result
# set, a Not allowed to return a result set from a function error occurs (ER_SP_NO_RETSET)
#
# For statements that can be determined only at runtime to return a result set, a 
# PROCEDURE %s can't return a result set in the given context error occurs (ER_SP_BADSELECT)
#
# USE statements within stored routines are not permitted.
#
# When a routine is invoked, an implicit USE db_name is performed (and undone when the
# routine terminates)
#
# The causes the routine to have the given default database while it executes.
#
# References to objects in databases other than the routine default database
# should be qualified with the appropriate database name.
#
# For additional information about statements that are not permitted in stored routines,
# see SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS"
#
# For information about invoking stored procedures from within programs written in a language
# that has a MySQL interface, see SECTION 13.2.1, "CALL SYNTAX"
#
# MySQL stores the sql_mode system variable setting in effect when a routine is created or
# altered, and always executes the routine with this setting in force, regardless of the
# current server SQL mode when the routine begins executing.
#
# The switch from the SQL mode of the invoker to that of the routine occurs after evaluation
# of arguments and assignment of the resulting values to routine parameters.
#
# If you define a routine in strict SQL mode but invoke it in nonstrict mode, assignment
# of arguments to routine parameters does not take place in strict mode.
#
# If you require that expressions passed to a routine be assigned in strict SQL mode, you
# should invoke the routine with strict mode in effect.
#
# The COMMENT characteristic is a MySQL extension, and may be used to describe the stored
# routine.
#
# This information is displayed by the SHOW_CREATE_PROCEDURE and SHOW_CREATE_FUNCTION statements.
#
# The LANGUAGE characteristic indicates the language in which the routine is written.
#
# The server ignores the characteristic; only SQL routines are supported.
#
# A routine is considered "determinsitic" if it always produces the same result for the
# same input params, and "not deterministic" otherwise.
#
# If neither DETERMINISTIC nor NOT DETERMINISTIC is given in the routine definition, the default
# is NOT DETERMINSITIC.
#
# To declare that a function is deterministic, you must specify DETERMINISTIC explicitly.
#
# ASsessment of the nature of a routine is based on the "honesty" of the creator:
#
# MySQL does not  check that a routien declared DETERMINSITIC is free of statements that produce
# RNG results.
#
# However, misdeclaring a routine might affect results or affect performance.
#
# Declaring a nondeterministic routine as DETERMINISTIC might lead to unexpected
# results by causing the optimizer to make incorrect execution plan choices.
#
# Declaring a deterministic routine as NONDETERMINISTIC might diminish performance
# by causing available optimizations not ot be used.
#
# If binary logging is enabled, the DETERMINISTIC characteristic affects which routine
# definitions MySQL accepts.
#
# See SECTION 24.7, "BINARY LOGGING OF STORED PROGRAMS"
#
# A routine that contains the NOW() function (or its synonyms) or RAND()
# is RNG, but it might still be replication-safe.
#
# For NOW(), the binary log includes the timestamp and replicates correctly.
#
# RAND() also replicates correctly as long as it is called only a single
# time during the execution of a routine.
#
# (You can consider the routine execution timestamp and random number seed as implicit
# inputs that are identical on the master and slave)
#
# Several characteristics provide information about the nature of data use by the routine.
#
# In MySQL, these characteristics are advisory only.
#
# THe server does not use them to constrain what kinds of statements a routine will be
# permitted to execute.
#
# 		) CONTAINS SQL indicates that the routine does not contain statements that read or write data.
#
# 			This is the default if none of these characteristics is given explicitly.
#
# 			Examples of such statements are SET @x = 1 or DO RELEASE_LOCK('abc'), which execute
# 			but neither read nor write data.
#
# 		) NO SQL indicates that the routine contains no SQL statements.
#
# 		) READS SQL DATA indicates that the routine contains statements that read data (for example, SELECT),
# 			but not statements that write data.
#
# 		) MODIFIES SQL DATA indicates that the routine contains statements that may write data (for example, INSERT or DELETE)
#
# The SQL SECURITY characteristic can be DEFINER or INVOKER to specify the security context; that is, whether the
# routine executes using the privileges of the account named in the routine DEFINER clause or the user who
# invokes it.
#
# This account must have permission to access the database with which the routine is associated.
#
# The default value is DEFINER.
#
# The user who invokes the routine must have the EXECUTE privilege for it, as must the DEFINER account
# if the routine executes in definer security context.
#
# The DEFINER clause specifies the MySQL account to be used when checking access privileges at routine
# execution time for routines that have the SQL SECURITY DEFINER characteristic.
#
# If a user value is given for the DEFINER clause, it should be a MySQL account specified as 
# 'user_name'@'host_name', CURRENT_USER or CURRENT_USER()
#
# THe default DEFINER value is the user who executes the CREATE_PROCEDURE or CREATE_FUNCTION
# statement.
#
# This is the same as specifying DEFINER = CURRENT_USER explicitly.
#
# If you specify the DEFINER clause, these rules determine the valid DEFINER user values:
#
# 		) If you do not have the SET_USER_ID or SUPER privilege, the only permitted user value is
# 			your own account, either specified literally or by using CURRENT_USER.
#
# 			You cannot set the definer to some other account.
#
# 		) If you have the SET_USER_ID or SUPER privilege, you can specify any syntactically
# 		valid account name.
#
# 		If the account does not exist, a warning is generated.
#
# 		) ALthough it is possible to create a routine with a nonexistent DEFINER account,
# 			an error occurs at routine execution time if the SQL SECURITY value is DEFINER
# 			but the definer account does not exist.
#
# For more information about stored routine security, see SECTION 24.6, "ACCESS CONTROL FOR STORED PROGRAMS AND VIEWS"
#
# Within a stored routine that is defined with the SQL SECURITY DEFINER characteristic, CURRENT_USER
# returns the routine's DEFINER value.
#
# For information about user auditing within stored routines, see SECTION 6.3.13, "SQL-BASED MYSQL ACCOUNT ACTIVITY AUDITING"
#
# Consider the following procedure, which displays a count of the number of MySQL accounts listed in
# the mysql.user system table:
#
# 		CREATE DEFINER = 'admin'@'localhost' PROCEDURE account_count()
# 		BEGIN
# 			SELECT 'Number of accounts:', COUNT(*) FROM mysql.user;
# 		END;
#
# The procedure is assigned a DEFINER account of 'admin'@'localhost' no matter which user defines it.
#
# It executes with the privileges of that account no matter which user invokes it
# (because the default security characteristic is DEFINER)
#
# THe procedure succeeds or fails depending on whether invoker has the EXECUTE
# privilege for it and 'admin'@'localhost' has the SELECT privilege for the mysql.user table
#
# Now suppose that the procedure is defined with the SQL SECURITY INVOKER characteristic:
#
# 		CREATE DEFINER = 'admin'@'localhost' PROCEDURE account_count()
# 		SQL SECURITY INVOKER
# 		BEGIN
# 			SELECT 'Number of accounts:', COUNT(*) FROM mysql.user;
# 		END;
#
# The procedure still has a DEFINER of 'admin'@'localhost', but in this case, it executes
# with the privileges of the invoking user.
#
# Thus, the procedure succeeds or fails depending on whether the invoker has the EXECUTE
# privilege for it and the SELECT privilege for the mysql.user table
#
# THe server handles the data type of a routine parameter, local routine variable created
# with DECLARE, or function return value as follows:
#
# 		) Assignments are checked for data type mismatches and overflow.
#
# 			Conversion and overflow problems result in warnings, or errors in strict SQL mode.
#
# 		) Only scalar values can be assigned. For example, a statement such as SET x = (SELECT 1, 2) is invalid
#
# 		) For character data types, if CHARACTER SET is included in the declaration, the specified character set
# 			and its default collation is used.
#
# 			IF the COLLATE attribute is also present, that collation is used rather than the default collation.
#
# 			If CHARACTER SET and COLLATE are not present, the database character set and collation in effect
# 			at routine creation time are used.
#
# 			To avoid having the server use the database character set and collation, provide an explicit
# 			CHARACTER SET and a COLLATE attribute for character data parameters.
#
# 			If you change the database default character set or collation, stored routines that use
# 			the database defaults must be dropped and recreated so that they use the new defaults.
#
# 			The database character set and collation are given by the value of the character_set_database
# 			and collation_database system variables.
#
# 			For more information, see SECTION 10.3.3, "DATABASE CHARACTER SET AND COLLATION"
#
# 13.1.18 CREATE SERVER SYNTAX
#
# CREATE SERVER server_name
# 		FOREIGN DATA WRAPPER wrapper_name
# 		OPTIONS (option [, option] ---)
#
# option:
# 		{ HOST character-literal
# 		| DATABASE character-literal
#		| USER character-literal
# 		| PASSWORD character-literal
# 		| SOCKET character-literal
# 		| OWNER character-literal
# 		| PORT numeric-literal }
#
# This statement creates the definition of a server for use with the FEDERATED storage engine.
#
# The CREATE SERVER statement creates a new row in the servers table in the mysql database.
#
# This statement requires the SUPER privilege.
#
# The server_name should be a unique reference to the server. Server definitions are global
# within the scope of the server, it is not possible to qualify the server definition to
# a specific database.
#
# server_name has a maximum length of 64 characters (names longer than 64 chars are silently
# truncated), and is case insensitive.
#
# You may specify the name as a quoted string.
#
# The wrapper_name is an identifier and may be quoted with single quotation marks.
#
# For each option you must specify either a character literal or numeric literal
#
# Character literals are UTF-8, support a max length of 64 chars and default to a
# blank (empty) string.
#
# String literals are silently truncated to 64 chars.
#
# Numeric literals must be a number between 0 and 9999, default value is 0.
#
# NOTE:
#
# 		The OWNER option is currently not applied, and has no effect on the ownership or operation
# 		of the server connection that is created.
#
# The CREATE SERVER statement creates an entry in the mysql.servers table that can later
# be used with the CREATE_TABLE statement when creating a FEDERATED table.
#
# The options that you specify will be used to populate the columns in the mysql.servers table.
#
# The table columns are Server_name, Host, Db, Username, Password, Port and Socket.
#
# For example:
#
# 		CREATE SERVER s
# 		FOREIGN DATA WRAPPER mysql
# 		OPTIONS (USER 'Remote', HOST '198.51.100.106', DATABASE 'test');
#
# Be sure to specify all options necessary to establish a connection to the server.
#
# The user name, host name, and DB name are mandatory.
#
# oTher options might be required as well, such as Password.
#
# The data stored in teh table can be used when creating a connection to a FEDERATED table:
#
# 		CREATE TABLE t (s1 INT) ENGINE=FEDERATED CONNECTION='s';
#
# For more information, see SECTION 16.8, "THE FEDERATED STORAGE ENGINE"
#
# CREATE SERVER causes an implicit commit. See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# CREATE SERVER is not written to the binary log, regardless of the logging format that is in use.
#
# 13.1.19 CREATE SPATIAL REFERENCE SYSTEM SYNTAX
#
# CREATE OR REPLACE SPATIAL REFERENCE SYSTEM
# 		srid srs_attribute
#
# CREATE SPATIAL REFERENCE SYSTEM
# 		[IF NOT EXISTS]
# 		srid srs_attribute ---
#
# srs_attribute: {
# 		NAME 'srs_name'
# 	 | DEFINITION 'definition'
# 	 | ORGANIZATION 'org_name' IDENTIFIED BY org_id
# 	 | DESCRIPTION 'description'
# }
#
# srid, org_id: 32-bit unsigned integer
#
# This statement creates a spatial reference system (SRS) definition and stores it in the data dictionary.
#
# THe definition can be inspected using the INFORMATION_SCHEMA ST_SPATIAL_REFERENCE_SYSTEMS table.
#
# This statement requires the SUPER privilege.
#
# If neither OR REPLACE nor IF NOT EXISTS is specified, an error occurs if an SRS definition with the 
# SRID value already exists.
#
# With CREATE OR REPLACE syntax, any existing SRS Definition with the same SRID value is replaced,
# unless the SRID value is used by some column in an existing table.
#
# In taht case, an error occurs.
#
# For example:
#
# 		CREATE OR REPLACE SPATIAL REFERENCE SYSTEM 4326 ---;
# 		ERROR 3716 (SR005): Can't modify SRID 4326.
#
# 		There is at least one column depending on it.
#
# To identify which column or columns use the SRID, use this query:
#
# 		SELECT * FROM INFORMATION_SCHEMA.ST_GEOMETRY_COLUMNS WHERE SRS_ID=4326;
#
# With CREATE_---_IF NOT EXISTS syntax, any existing SRS definition with the same SRID value
# causes the new definition to be ignored and a warning occurs.
#
# SRID values must be in the range of 32-bit unsigned integers, with these restrictions:
#
# 		) SRID 0 is a valid SRID but cannot be used with CREATE_SPATIAL_REFERENCE_SYSTEM
#
# 		) If the value is in a reserved SRID range, a warning occurs.
#
# 			Reserved ranges are [0, 32767] (reserved by EPSG), [60,000,000,69,999,999,999] (reserved by EPSG),
# 			and [2,000,000,000, 2,147,483,647] (reserved by MySQL)
#
# 		) Uses should not create SRSs with SRIDs in the reserved ranges.
#
# 			Doing so runs the risk that the SRIDs will conflict with future SRS
# 			definitions distributed with MySQL, with the reuslt that hte new system-provided
# 			SRS are not installed for MySQL upgrades or that hte user-defined SRSs are overwritten.
#
# Attributes for the statement must satisfy these conditions:
#
# 		) Attributes can be given in any order, but not attribute can be given more than once
#
# 		) The NAME and DEFINITION attributes are mandatory
#
# 		) The NAME srs_name attribute value must be unique. The combination of the ORGANIZATION
# 			org_name and org_id attribute values must be unique.
#
# 		) The NAME srs_name attribute value and ORGANIZATION org_name attribute value cannot be
# 			empty or begin or end with whitespace.
#
# 		) String values in attribute specifications cannot contain control chars, including newline
#
# 		) The following table shows hte max lengths for string attrib values
#
# 			TABLE 13.6 CREATE SPATIAL REFERENCE SYSTEM ATTRIBUTE LENGTHS
#
# 			Attribute 			Max length (chars)
#
# 			NAME 					80
#
# 			DEFINITION 			4096
#
# 			ORGANIZATION 		256
#
# 			DESCRIPTION 		2048
#
# Here is an example CREATE_SPATIAL_REFERENCE_SYSTEM statement.
#
# The DEFINITION value is reformatted across multiple lines for readability.
#
# (For the statement to be legal, the value actually must be given on a single line)
#
# 		CREATE SPATIAL REFERENCE SYSTEM 4120
# 		NAME 'Greek'
# 		ORGANIZATION 'EPSG' IDENTIFIED BY 4120
# 		DEFINITION
# 			'GEOGCS["Greek",DATUM["Greek",SPHEROID["Bessel 1841",
# 			<numbers>, etc.';
#
# The grammar for SRS definition is based on teh grammar defined in OpenGIS Implementation Spec: Coordinate tarnsformation services.
#
# Revision 1.00, OGC 01-009, January 12, 2001, Section 7.2
#
# This specification exists at <link>
#
# MySQL incorporates these changes to the spec:
#
# 		) Only the <horz cs> production rule is implemented (that is, geographic and projected SRSs)
#
# 		) There is an optional, nonstandard <authority> clause for <parameter>
#
# 			This makes it possible to recognize projection parameters by authority instead of name
#
# 		) SRS definitions may not contain newlines
#
# 13.1.20 CREATE TABLE SYNTAX
#
# 13.1.20.1 CREATE TABLE STATEMENT RETENTION
# 13.1.20.2 FILES CREATED BY CREATE TABLE
# 13.1.20.3 CREATE TEMPORARY TABLE SYNTAX
# 13.1.20.4 CREATE TABLE --- LIKE SYNTAX
# 13.1.20.5 CREATE TABLE --- SELECT SYNTAX
#
# 13.1.20.6 USING FOREIGN KEY CONSTRAINTS
# 13.1.20.7 SILENT COLUMN SPECIFICATION CHANGES
# 13.1.20.8 CREATE TABLE AND GENERATED COLUMNS
# 13.1.20.9 SECONDARY INDEXES AND GENERATED COLUMNS
# 
# 13.1.20.10 SETTING NDB_TABLE OPTIONS
#
# CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
# 		(create_definition, ---)
# 		[table_options]
# 		[partition_options]
#
# CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
# 		[(create_definition,---)]
# 		[table_options]
# 		[partition_options]
# 		[IGNORE | REPLACE]
# 		[AS] query_expression
#
# CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
# 		{ LIKE old_tbl_name | (LIKE old_tbl_name) }
#
# create_definition:
# 		col_name column_definition
# 	 | [CONSTRAINT [symbol]] PRIMARY KEY [index_type] (key_part,---)
# 		[index_option] ---
# 	 | {INDEX|KEY} [index_name] [index_type] (key_part,---)
# 		[index_option] ---
#
# 	 | [CONSTRAINT [symbol]] UNIQUE [INDEX|KEY]
# 			[index_name] [index_type] (key_part,---)
# 			[index_option] ---
# 	 | {FULLTEXT|SPATIAL} [INDEX|KEY] [index_name] (key_part,---)
# 			[index_option] ---
# 	 | [CONSTRAINT [symbol]] FOREIGN KEY
# 			[index_name] (col_name, ---) reference_definition
#   | CHECK (expr)
#
# column_definition:
# 		data_type [NOT NULL | NULL] [DEFAULT {literal | (expr)} ]
# 			[AUTO_INCREMENT] [UNIQUE [KEY]] [[PRIMARY] KEY]
# 			[COMMENT 'string']
# 			[COLLATE collation_name]
# 			[COLUMN_FORMAT {FIXED|DYNAMIC|DEFAULT}]
# 			[STORAGE {DISK|MEMORY|DEFAULT}]
# 			[reference_definition]
# 		| data_type
# 			[GENERATED ALWAYS] AS (expression)
# 			[VIRTUAL | STORED] [NOT NULL | NULL]
# 			[UNIQUE [KEY]] [[PRIMARY] KEY]
# 			[COMMENT 'string']
#
# data_Type:
# 		(see Chapter 11, Data types)
#
# key_part: {col_name [(length)] | (expr)} [ASC | DESC]
#
# index_type:
# 		USING {BTREE | HASH}
#
# index_option:
# 		KEY_BLOCK_SIZE [=] value
# 	 | index_type
# 	 | WITH PARSER parser_name
#   | COMMENT 'string'
# 	 | {VISIBLE | INVISIBLE}
#
# reference_definition:
# 		REFERENCES tbl_name (key_part, ---)
# 			[MATCH FULL | MATCH PARTIAL | MATCH SIMPLE]
# 			[ON DELETE reference_option]
# 			[ON UPDATE reference_option]
#
# reference_option:
# 		RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
#
# table_options:
# 		table_option [[,] table_option] ---
#
# table_option:
# 		AUTO_INCREMENT [=] value
# 	 | AVG_ROW_LENGTH [=] value
#   | [DEFAULT] CHARACTER SET [=] charset_name
# 	 | CHECKSUM [=] {0 | 1}
#   | [DEFAULT] COLLATE [=] collation_name
# 	 | COMMENT [=] 'string'
# 	 | COMPRESSION [=] {'ZLIB'|'LZ4'|'NONE'}
# 	 | CONNECTION [=] 'connect_string'
#   | {DATA|INDEX} DIRECTORY [=] 'absolute path to directory'
# 	 | DELAY_KEY_WRITE [=] {0 | 1}
# 	 | ENCRYPTION [=] {'Y' | 'N'}
# 	 | ENGINE [=] engine_name
#   | INSERT_METHOD [=] { NO | FIRST | LAST }
#   | KEY_BLOCK_SIZE [=] value
#   | MAX_ROWS [=] value
#   | MIN_ROWS [=] value
#   | PACK_KEYS [=] {0 | 1 | DEFAULT}
#   | PASSWORD [=] 'string'
#   | ROW_FORMAT [=] {DEFAULT|DYNAMIC|FIXED|COMPRESSED|REDUNDANT|COMPACT}
#   | STATS_AUTO_RECALC [=] {DEFAULT|0|1}
#   | STATS_PERSISTENT [=] {DEFAULT|0|1}
#   | STATS_SAMPLE_PAGES [=] value
#   | TABLESPACE tablespace_name [STORAGE {DISK|MEMORY|DEFAULT}]
#   | UNION [=] (tbl_name[,tbl_name]---)
#
# partition_options:
# 		PARTITION BY
# 			{ [LINEAR] HASH(expr)
# 			| [LINEAR] KEY [ALGORITHM={1|2}] (column_list)
# 			| RANGE{(expr) | COLUMNS(column_list)}
# 			| LIST{(expr) | COLUMNS(column_list)} }
# 		[PARTITIONS num]
# 		[SUBPARTITION BY
# 			{ [LINEAR] HASH(expr)
# 			| [LINEAR] KEY [ALGORITHM={1|2}] (column_list) }
# 		 [SUBPARTITIONS num]
# 		]
# 		[(partition_definition [, partition_definition] ---)]
#
# partition_definition:
# 		PARTITION partition_name
# 			[VALUES
# 				{LESS THAN {(expr | value_list) | MAXVALUE}
# 				|
# 				IN (value_list)}]
# 			[[STORAGE] ENGINE [=] engine_name]
# 			[COMMENT [=] 'string' ]
# 			[DATA DIRECTORY [=] 'data_dir']
# 			[INDEX DIRECTORY [=] 'index_dir']
# 			[MAX_ROWS [=] max_number_of_rows]
# 			[MIN_ROWS [=] min_number_of_rows]
# 			[TABLESPACE [=] tablespace_name]
# 			[(subpartition_definition [, subpartition_definition] ---)]
#
# subpartition_definition:
# 		SUBPARTITION logical_name
# 			[[STORAGE] ENGINE [=] engine_name]
# 			[COMMENT [=] 'string' ]
# 			[DATA DIRECTORY [=] 'data_dir']
# 			[INDEX DIRECTORY [=] 'index_dir']
# 			[MAX_ROWS [=] max_number_of_rows]
# 			[MIN_ROWS [=] min_number_of_rows]
# 			[TABLESPACE [=] tablespace_name]
#
# query_expression:
# 		SELECT --- (Some valid select or union statement)
#
# CREATE_TABLE creates a table with the given name. You must have the CREATE privilege for the table.
#
# By default, tables are created in the default database, using the InnoDB storage engine.
#
# An error occurs if the table exists, if there is no default database, or if the database
# does not exist.
#
# For information about the physical representation of a table, see SECTION 13.1.20.2, "FILES CREATED BY CREATE TABLE"
#
# The original CREATE_TABLE statement, including all specifications and table options are stored
# by MySQL when the table is created.
#
# For more information, see SECTION 13.1.20.1, "CREATE TABLE STATEMENT RETENTION"
#
# There are several aspects to the CREATE_TABLE statement, described under the following topics
# in this section:
#
# 		) TABLE NAME
#
# 		) TEMPORARY TABLES
#
# 		) CLONING OR COPYING A TABLE
#
# 		) COLUMN DATA TYPE AND ATTRIBUTES
#
# 		) INDEXES AND FOREIGN KEYS
#
# 		) TABLE OPTIONS
#
# 		) CREATING PARTITIONED TABLES
#
# TABLE NAME
#
# 		) tbl_name
#
# 			The table name can be specified as db_name.tbl_name to create the table in a specific database.
#
# 			This works regardless of whether there is a default database, assuming that the database exists.
#
# 			If you use quoted identifiers, quote the database and table names separately.
#
# 			For example, write `mydb`.`mytbl`, not `mydb.mytbl`
#
# 			Rules for permissible table names are given in SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# 		) IF NOT EXISTS
#
# 			Prevents an error from occurring if the table exists.
#
# 			However, there is no verification that the existing table has a structure identical
# 			to that indicated by the CREATE_TABLE statement.
#
# TEMPORARY TABLES
#
# You can use the TEMPORARY keyword when creating a table.
#
# A TEMPORARY table is visible only within the current session, and is dropped automatically
# when the session is closed.
#
# For more information, see SECTION 13.1.20.3, "CREATE TEMPORARY TABLE SYNTAX"
#
# CLONING OR COPYING A TABLE
#
# 		) LIKE
#
# 			Use CREATE TABLE --- LIKE to create an empty table based on the defininition of another
# 			table, including any column attributes and indexes defined in the original table:
#
# 				CREATE TABLE new_tbl LIKE orig_tbl;
#
# 			For more information, see SECTION 13.1.20.4, "CREATE TABLE --- LIKE SYNTAX"
#
# 		) [AS] query_expression
#
# 			To create one table from another, add a SELECT statement at the end of the
# 			CREATE TABLE statement:
#
# 				CREATE TABLE new_tbl AS SELECT * FROM orig_tbl;
#
# 			For more information, see SECTION 13.1.20.5, "CREATE TABLE --- SELECT SYNTAX"
#
# 		) IGNORE|REPLACE
#
# 			The IGNORE and REPLACE options indicate how to handle rows that duplicate unique key
# 			values when copying a table using a SELECT statement.
#
# 			For more information, see SECTION 13.1.20.5, "CREATE TABLE --- SELECT SYNTAX"
#
# COLUMN DATA TYPES AND ATTRIBUTES
#
# There is a hard limit of 4096 columns per table, but the effective maximum may be less
# for a given table and depends on the factors discussed in SECTION C.10.4, "LIMITS ON TABLE COLUMN COUNT AND ROW SIZE"
#
# 		) data_type
#
# 			data_type represents the data type in a column definition.
#
# 			For a full description of the syntax available for specifying column data types,
# 			as well as information about the properties of each type, see CHAPTER 11, DATA TYPES
#
# 				) Some attributes do not apply to all data types.
#
# 					AUTO_INCREMENT applies only to integer and floating-point types.
#
# 					Prior to MySQL 8.0.13, DEFAULT does not apply to the BLOB, TEXT, GEOMETRY
# 					and JSON types.
#
# 				) Character data types (CHAR, VARCHAR, the TEXT types, ENUM, SET and any synonyms) synonyms) can include
# 					CHARACTER SET to specify the character set for the column.
#
# 					CHARSET is a synonym for CHARACTER SET.
#
# 					A collation for the character set can be specified with the COLLATE attribute,
# 					along with any other attributes.
#
# 					For details, see CHAPTER 10, CHARACTER SETS, COLLATIONS, UNICODE. Example:
#
# 						CREATE TABLE t (c CHAR(20) CHARACTER SET utf8 COLLATE utf8_bin);
#
# 					MySQL 8.0 interprets length specifications in character column definitions in characters.
#
# 					Lengths for BINARY and VARBINARY are in bytes.
#
# 				) For CHAR, VARCHAR, BINARY and VARBINARY columns, indexes can be created that use only
# 					the leading part of column values, using col_name(length) syntax to specify an index
# 					prefix length.
#
# 					BLOB and TEXT columns also can be indexed, but a prefix length must be given.
#
# 					Prefix lengths are given in characters for nonbinary string types and in bytes
# 					for binary string types.
#
# 					That is, index entries consist of the first length characters of each column value
# 					for CHAR, VARCHAR, and TEXT columns, and the first length bytes of each column value
# 					for BINARY, VARBINARY, and BLOB columns.
#
# 					Indexing only a prefix of column values like this can make the index file much smaller.
#
# 					For additional information about index prefixes, see SECTION 13.1.15, "CREATE INDEX SYNTAX"
#
# 					Only the InnoDB and MyISAM storage engines support indexing on BLOB and TEXT columns.
#
# 					For example:
#
# 						CREATE TABLE test (blob_col BLOB, INDEX(blob_col(10)));
#
# 					If a specified index prefix exceeds the maximum column data type size, CREATE_TABLE
# 					handles the index as follows:
#
# 						) For a nonunique index, either an error occurs (if strict SQL mode is enabled),
# 							or the index length is reduced to lie within the maximum column data type size
# 							and a warning is produed (if strict SQL mode is not enabled)
#
# 						) For a unique index, an error occurs regardless of SQL mode because reducing the index
# 							length might enable insertion of nonunique entries that do not meet the specified
# 							uniqueness requirement.
#
# 			) JSON columns cannot be indexed.
#
# 				You can work around this restriction by creating an index on a generated column
# 				that extracts a scalar value from the JSON column.
#
# 				See INDEXING A GENERATED COLUMN TO PROVIDE A JSON COLUMN INDEX, for a detailed example.
#
# 		) NOT NULL | NULL
#
# 			If neither NULL nor NOT NULL is specified, the column is treated as though NULL had been specified.
#
# 			In MySQL 8.0, only the InnoDB, MyISAM, and MEMORY storage engines support indexes on columns
# 			that can have NULL values.
#
# 			In other cases, you must declare indexed columns as NOT NULL or an error results
#
# 		) DEFAULT
#
# 			Specifies a default value for a column.
#
# 			For more information about default value handling, including the case that
# 			a column definition includes no explicit DEFAULT value, see SECTION 11.7, "DATA TYPE DEFAULT VALUES"
#
# 			If the NO_ZERO_DATE or NO_ZERO_IN_DATE SQL mode is enabled and a date-valued default is not correct
# 			according to that mode, CREATE_TABLE produces a warning if strict SQL mode is not enabled and an
# 			error if strict mode is enabled.
#
# 			For example, with NO_ZERO_IN_DATE enabled, c1 DATE DEFAULT '2010-00-00' produces a warning.
#
# 		) AUTO_INCREMENT
#
# 			An integer or floating-point column can have the additional attribute AUTO_INCREMENT.
#
# 			When you insert a value of NULL (recommended) or 0 into an indexed AUTO_INCREMENT column,
# 			the column is set to the next sequence value.
#
# 			Typically this is value+1, where value is the largest value for the column currently
# 			in the table.
#
# 			AUTO_INCREMENT sequences begin with 1.
#
# 			To retrieve an AUTO_INCREMENT value after inserting a row, use the LAST_INSERT_ID()
# 			SQL function or the mysql_insert_id() C API function
#
# 			See SECTION 12.15, "INFORMATION FUNCTIONS" and SECTION 28.7.7.38, "mysql_insert_id()"
#
# 			If the NO_AUTO_VALUES_ON_ZERO SQL mode is enabled, you can store 0 in AUTO_INCREMENT
# 			columns as 0 without generating a new sequence value.
#
# 			See SECTION 5.1.11, "SERVER SQL MODES"
#
# 			There can be only one AUTO_INCREMENT column per table, it must be indexed, and it cannot
# 			have a DEFAULT value.
#
# 			An AUTO_INCREMENT column works properly only if it contains only positive values.
#
# 			Inserting a negative number is regarded as inserting a very large positive number.
#
# 			This is done to avoid precision problems when numbers "wrap" over from positive to
# 			negative and also to ensure that you do not accidentally get an AUTO_INCREMENT
# 			column that contains 0.
#
# 			For MyISAM tables, you can specify an AUTO_INCREMENT secondary column in a multiple-column
# 			key.
#
# 			See SECTION 3.6.9, "USING AUTO_INCREMENT"
#
# 			To make MySQL compatible with some ODBC applications, you can find the AUTO_INCREMENT
# 			value for the last inserted row with the following query:
#
# 				SELECT * FROM tbl_name WHERE auto_col IS NULL
#
# 			This method requires that sql_auto_is_null variable is not set to 0.
#
# 			See SECTION 5.1.8, "SERVER SYSTEM VARIABLES"
#
# 			For information about InnoDB and AUTO_INCREMENT, see SECTION 15.6.1.4,
# 			"AUTO_INCREMENT HANDLING IN INNODB"
#
# 			For information about AUTO_INCREMENT and MySQL Replication, see 
# 			SECTION 17.4.1.1, "REPLICATION AND AUTO_INCREMENT"
#
# 		) COMMENT
#
# 			A comment for a column can be specified with the COMMENT option, up to
# 			1024 characters long.
#
# 			The comment is displayed by the SHOW_CREATE_TABLE and SHOW_FULL_COLUMNS
# 			statements.
#
# 		) COLUMN_FORMAT
#
# 			In NDB Cluster, it is also possible to specify a data storage format for
# 			individual columns of NDB tables using COLUMN_FORMAT.
#
# 			Permissible column formats are FIXED, DYNAMIC and DEFAULT.
#
# 			FIXED is used to specify fixed-width storage, DYNAMIC permits the column
# 			to be variable-width, and DEFAULT causes the column to use fixed-width
# 			or variable-width storage as determined by the column's data type
# 			(possibly overridden by a ROW_FORMAT specifier)
#
# 			For NDB tables, the default value for COLUMN_FORMAT is FIXED.
#
# 			COLUMN_FORMAT currently has no effect on columns of tables using storage engines
# 			other than NDB.
#
# 			MySQL 8.0 silently ignores COLUMN_FORMAT
#
# 		) STORAGE
#
# 			For NDB tables, it is possible to specify whether the column is stored on disk or
# 			in memory by using a STORAGE clause.
#
# 			STORAGE DISK causes the column to be stored on disk, and STORAGE MEMORY causes
# 			in-memory storage to be used.
#
# 			The CREATE_TABLE statement used must still include a TABLESPACE clause:
#
# 				CREATE TABLE t1 (
# 					c1 INT STORAGE DISK,
# 					c2 INT STORAGE MEMORY
# 				) ENGINE NDB;
# 				ERROR 1005 (HY000): Can't create table 'c.t1' (errno: 140)
#
# 				CREATE TABLE t1 (
# 					c1 INT STORAGE DISK,
# 					c2 INT STORAGE MEMORY
# 				) TABLESPACE ts_1 ENGINE NDB;
# 				Query OK, 0 rows affected (1.06 sec)
#
# 			For NDB tables, STORAGE DEFAULT is equivalent to STORAGE MEMORY.
#
# 			The STORAGE clause has no effect on tables using storage engines other than
# 			NDB.
#
# 			The STORAGE keyword is supported only in the build of mysqld that is supplied
# 			with NDB Cluster; it is not recognized in any other version of MySQL, where
# 			any attempt to use the STORAGE keyword cause a syntax error.
#
# 		) GENERATED ALWAYS
#
# 			Used to specify a generated column expression.
#
# 			For information about generated columns, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
#
# 			Stored generated columns can be indexed.
#
# 			InnoDB supports secondary indexes on virtual generated columns.
# 			See SECTION 13.1.20.9, "SECONDARY INDEXES AND GENERATED COLUMNS"
#
# INDEXES AND FOREIGN KEYS
#
# Several keywords apply to creation of indexes and foreign keys.
#
# For general background in addition to the following descriptions, see
# SECTION 13.1.15, "CREATE INDEX SYNTAX" and SECTION 13.1.20.6, "USING FOREIGN KEY CONSTRAINTS"
#
# 		) CONSTRAINT <SYMBOL>
#
# 			If the CONSTRAINT symbol clause is given, the symbol value, if used, must be unique
# 			in the database.
#
# 			A duplicate symbol results in an error.
#
# 			If the clause is not given, or a symbol is not included following the CONSTRAINT keyword,
# 			a name for the constraint is created automatically.
#
# 		) PRIMARY KEY
#
# 			A unique index where all key columns must be defined as NOT NULL.
#
# 			If they are not explicitly declared as NOT NULL, MySQL declares them so
# 			implicitly (and silently)
#
# 			A table can have only one PRIMARY KEY. 
#
# 			The name of a PRIMARY KEY is always PRIMARY, which thus cannot be used
# 			as the name for any other kind of index.
#
# 			If you do not have a PRIMARY KEY and an application asks for the PRIMARY KEY
# 			in your tables, MySQL returns the first UNIQUE index that has no NULL
# 			columns as the PRIMARY KEY.
#
# 			In InnoDB tables, keep the PRIMARY KEY short to minimize storage overhead
# 			for secondary indexes.
#
# 			Each secondary index entry contains a copy of the primary key columns
# 			for the corresponding row. (See SECTION 15.6.2.1, "CLUSTERED AND SECONDARY INDEXES")
#
# 			In the created table, a PRIMARY KEY is placed first, followed by all UNIQUE indexes,
# 			and then the nonunique indexes.
#
# 			This helps the MySQL optimizer to prioritize which index to use and also
# 			more quickly to detect duplicated UNIQUE keys.
#
# 			A PRIMARY KEY can be a multiple-column index.
#
# 			However, you cannot create a multiple-column index using the PRIMARY KEY
# 			attribute in a column specification.
#
# 			Doing so only marks that single column as primary.
#
# 			You must use a separate PRIMARY KEY(key_part, ---) clause
#
# 			If a table has a PRIMARY KEY or UNIQUE NOT NULL index that consists
# 			of a single column that has an integer type, you can use _rowid
# 			to refer to the indexed column in SELECT statements, as described
# 			in Unique Indexes.
#
# 			In MySQL, the name of a PRIMARY KEY is PRIMARY.
#
# 			Foro ther indexes, if you do not assign a name, the index is assigned
# 			the same name as the first indexed column, with an optional suffix
# 			(_2,_3,---) to make it unique.
#
# 			You can see index names for a table using SHOW INDEX FROM tbl_name.
#
# 			See SECTION 13.7.6.22, "SHOW INDEX SYNTAX"
#
# 		) KEY | INDEX
#
# 			KEY is normally a synonym for INDEX.
#
# 			The key attribute PRIMARY KEY can also be specified as just KEY when given
# 			in a column definition.
#
# 			This was implemented for compatibility with other database systems.
#
# 		) UNIQUE
#
# 			A UNIQUE index creates a constraint such that all values in the index must be distinct.
#
# 			An error occurs if you try to add a new row with a key value that matches an
# 			existing row.
#
# 			For all engines, a UNIQUE index permits multiple NULL values for columns that
# 			can contain NULL.
#
# 			If you specify a prefix value for a column in a UNIQUE index, the column values
# 			must be unique within the prefix length.
#
# 			If a table has a PRIMARY KEY or UNIQUE NOT NULL index that consists of a single
# 			column that has an integer type, you can use _rowid to refer to the indexed
# 			column in SELECT statements, as described in UNIQUE INDEXES.
#
# 		) FULLTEXT
#
# 			A FULLTEXT index is a special type of index used for full-text searches.
#
# 			Only the InnoDB and MyISAM storage engines support FULLTEXT indexes.
#
# 			They can be created only from CHAR, VARCHAR, and TEXT columns.
#
# 			Indexing always happens over the entire column; column prefix indexing
# 			is not supported and any prefix length is ignored if specified.
#
# 			See SECTION 12.9, "FULL-TEXT SEARCH FUNCTIONS", for details of operation.
#
# 			A WITH PARSER clause can be specified as an index_option value to associate
# 			a parser plugin with the index if full-text indexing and searching operations
# 			need special handling.
#
# 			This clause is valid only for FULLTEXT indexes.
#
# 			InnoDB and MyISAM support full-text parser plugins.
#
# 			See FULL-TEXT PARSER PLUGINS and SECTION 29.2.4.4, "WRITING FULL-TEXT PARSER PLUGINS"
# 			for more information.
#
# 		) SPATIAL
#
# 			You can create SPATIAL indexes on spatial data types.
#
# 			Spatial types are supported only for InnoDB and MyISAM tables, and indexed
# 			columns must be declared as NOT NULL.
#
# 			See SECTION 11.5, "SPATIAL DATA TYPES"
#
# 		) FOREIGN KEY
#
# 			MySQL supports foreign keys, which let you cross-reference related data
# 			across tables, and foreign key constraints, which help keep this spread-out
# 			data consistent.
#
# 			For definition and option information, see REFERENCE_DEFINITION and REFERENCE_OPTION
#
# 			Partitioned tables employing the InnoDB storage engine do not support foreign keys.
#
# 			See SECTION 23.6, "RESTRICTIONS AND LIMITATIONS ON PARTITIONING", for more information.
#
# 		) CHECK
#
# 			The CHECK clause is parsed but ignored by all storage engines.
#
# 			See SECTION 1.8.2.3, "FOREIGN KEY DIFFERENCES"
#
# 		) key_part
#
# 			) A key_part specification can end with ASC or DESC to specify whether index values
# 				are stored in ascending or descending order.
#
# 				The default is ascending if no order specifier is given.
#
# 			) Prefixes, defined by the length attribute, can be up to 767 bytes long for InnoDB tables
# 				that use the REDUNDANT or COMPACT row format.
#
# 				The prefix length limit is 3072 bytes for InnoDB tables that use the DYNAMIC
# 				or COMPRESSED row format.
#
# 				For MyISAM tables, the prefix length limit is 1000 bytes.
#
# 				Prefix limits are measured in bytes.
#
# 				However, prefix lengths for index specifications in CREATE_TABLE,
# 				ALTER_TABLE and CREATE_INDEX statements are interpreted as number of
# 				characters for nonbinary string types (CHAR, VARCHAR, TEXT) and number of
# 				bytes for binary string types (BINARY, VARBINARY, BLOB)
#
# 				Take this into account when specifying a prefix length for a nonbinary
# 				string column that uses a multibyte character set.
#
# 		) index_type
#
# 			Some storage engine permit you to specify an index type when creating an index.
#
# 			The syntax for the index_type specifier is USING type_name
#
# 			Example:
#
# 				CREATE TABLE lookup
# 					(id INT, INDEX USING BTREE (id))
# 					ENGINE = MEMORY;
#
# 			The preferred position for USING is after the index column list.
#
# 			It can be given before the column list, but support for use of the option
# 			in that position is deprecated and will be removed in a future release.
#
# 		) index_option
#
# 			index_option values specify additional options for an index
#
# 				) KEY_BLOCK_SIZE
#
# 					For MyISAM tables, KEY_BLOCK_SIZE optionally specifies the size in bytes to use
# 					for index key blocks.
#
# 					The value is treated as a hint; a different size could be used if necessary.
#
# 					A KEY_BLOCK_SIZE value specified for an individual index definition overrides
# 					the table-level KEY_BLOCK_SIZE value.
#
# 					For information about the table-level KEY_BLOCK_SIZE attribute, see TABLE OPTIONS
#
# 				) WITH PARSER
#
# 					The WITH PARSER option can only be used with FULLTEXT indexes.
#
# 					It associates a parser plugin with the index if full-text indexing
# 					and searching operations need special handling.
#
# 					InnoDB and MyISAM support full-text parser plugins.
#
# 					If you have a MyISAM table with an associated full-text parser
# 					plugin, you can convert the table to InnoDB using ALTER TABLE.
#
# 				) COMMENT
#
# 					In MySQL 8.0, index definitions can include an optional comment
# 					of up to 1024 characters.
#
# 					You can set the InnoDB MERGE_THRESHOLD value for an individual index using
# 					the index_option COMMENT clause.
#
# 					See SECTION 15.8.11, "CONFIGURING THE MERGE THRESHOLD FOR INDEX PAGES"
#
# 			For more information about permissible index_option values, see SECTION 13.1.15, "CREATE INDEX SYNTAX"
#
# 			For more information about indexes, see SECTION 8.3.1, "HOW MYSQL USES INDEXES"
#
# 		) reference_definition
#
# 			For reference_definition syntax details and examples, see SECTION 13.1.20.6,
# 			"USING FOREIGN KEY CONSTRAINTS"
#
# 			For information specific to foreign keys in InnoDB, see SECTION 15.6.1.5, "InnoDB AND FOREIGN KEY CONSTRAINTS"
#
# 			InnoDB and NDB tables support checking of foreign key constraints.
#
# 			The  columns of the referenced table must always be explicitly named.
#
# 			Both ON DELETE and ON UPDATE actions on foreign keys are supported.
#
# 			For more detailed information and examples, see SECTION 13.1.20.6,
# 			"USING FOREIGN KEY CONSTRAINTS"
#
# 			For information specific to foreign keys in InnoDB, see SECTION 15.6.1.5,
# 			"InnoDB AND FOREIGN KEY CONSTRAINTS"
#
# 			For other storage engines, MySQL Server parses and ignores the FOREIGN KEY
# 			and REFERENCES syntax in CREATE_TABLE statements.
#
# 			See SECTION 1.8.2.3, "FOREIGN KEY DIFFERENCES"
#
# 				IMPORTANT:
#
# 					For users familiar with the ANSI/ISO SQL Standard, please note that no storage engine,
# 					includin InnoDB, recognizes or enforces the MATCH clause used in referential integrity
# 					constraint definitions.
#
# 					Use of an explicit MATCH clause will not have the specified effect, and also causes
# 					ON DELETE and ON UPDATE clauses to be ignored. For these reasons, specifying
# 					MATCH should be avoided.
#
# 					The MATCH clause in SQL standard controls how NULL values in a composite (multiple-column)
# 					foreign key are handled when comparing to a primary key.
#
# 					InnoDB essentially implements the semantics defined by MATCH SIMPLE, which permit a foreign
# 					key to be all or partially NULL.
#
# 					In that case, the (child table) row containing such a foreign key is permitted to be inserted,
# 					and does not match any row in the referenced (parent) table.
#
# 					It is possible to implement other semantics using triggers.
#
# 					Additionally, MySQL requires that the referenced columns be indexed for performance.
#
# 					However, InnoDB does not enforce any requirement that the referenced columns be declared
# 					UNIQUE or NOT NULL.
#
# 					The handling of foreign key references to nonunique keys or keys that contain NULL values
# 					is not well defined for operations such as UPDATE or DELETE CASCADE.
#
# 					You are advised to use foreign keys that reference only keys that are both UNIQUE 
# 					(or PRIMARY) and NOT NULL.
#
# 					MySQL parses but ignores "inline REFERENCES specifications" (as defined in the SQL standard)
# 					where the references are defined as part of the column specification.
#
# 					MySQL accepts REFERENCES clauses only when specified as part of a separate FOREIGN KEY 
# 					specification.
#
# 		) reference_option
#
# 			For information about the RESTRICT, CASCADE, SET NULL, NO ACTION and SET DEFAULT options, see
# 			SECTION 13.1.20.6, "USING FOREIGN KEY CONSTRAINTS"
#
# TABLE OPPTIONS
#
# Table options are used to optimize the behavior of the table.
#
# In most cases, you do not have to specify any of them. These options apply to all storage engines
# unless otherwise indicated.
#
# Options that do not apply to a given storage engine may be accepted and remembered as part of the
# table definition.
#
# Such options then apply if you later use ALTER_TABLE to convert the table to use a different storage engine.
#
# 		) ENGINE
#
# 			Specifies the storage engine for the table, using one of the names shown in the following table.
#
# 			The engine name can be unquoted or quoted. The quoted name 'DEFAULT' is recognized but ignored.
#
# 			STORAGE ENGINE 			DESC
#
# 			InnoDB 					Transaction-safe tables with row locking and foreign keys.
#
# 										The default storage engine for new tables. 
#
# 										See CHAPTER 15, The InnoDB Storage Engine, and in particular Section 15.1,
# 										"Introduction to InnoDB" if you have MySQL experience but are new to InnoDB.
#  		
# 			MyISAM 					The binary portable storage engine that is primarily used for read-only or read-mostly
# 										workloads.
#
# 										See SECTION 16.2, "THE MYISAM STORAGE ENGINE"
#
# 			MEMORY 					The data for this storage engine is stored only in memory. See SECTION 16.3, "THE MEMORY STORAGE ENGINE"
#
# 			CSV 						Tables that store rows in comma-separated values format. See SECTION 16.4, "THE CSV STORAGE ENGINE"
#
# 			ARCHIVE 					The archiving storage engine. See SECTION 16.5, "THE ARCHIVE STORAGE ENGINE"
#
# 			EXAMPLE 					An example engine. See SECTION 16.9, "THE EXAMPLE STORAGE ENGINE"
#
# 			FEDERATED 				Storage engine that accesses remote tables. See SECTION 16.8, "THE FEDERATED STORAGE ENGINE"
#
# 			HEAP 						This is a synonym for MEMORY
#
# 			MERGE 					A collection of MyISAM tables used as one table.
#
# 										Also known as MRG_MyISAM. See SECTION 16.7, "THE MERGE STORAGE ENGINE"
#
# 			NDB 						Clustered, fault-tolerant, memory-based tables, supporting transactions and foreign
# 										keys.
#
# 										Also known as NDBCLUSTER.
#
# 										See CHAPTER 22, MySQL NDB CLUSTER 8.0
#
# 			By default, if a storage engine is specified that is N/A, the statement fails with an error.
#
# 			You can override this behavior by removing NO_ENGINE_SUBSTITUTION from the server SQL mode
# 			(see SECTION 5.1.11, "SERVER SQL MODES") so that MySQL allows substitution of the specified
# 			engine with the default storage engine instead.
#
# 			Normally, in such cases, this is InnoDB, which is the default value for the default_storage_engine
# 			system variable.
#
# 			When NO_ENGINE_SUBSTIUTTION is disabled, a warning occurs if the storage engine specification is not honored.
#
# 		) AUTO_INCREMENT
#
# 			The initial AUTO_INCREMENT value for the table.
#
# 			In MySQL 8.0, this works for MyISAM, MEMORY, InnoDB and ARCHIVE tables.
#
# 			To set the first auto-increment value for engines that do not support the
# 			AUTO_INCREMENT table option, insert a "dummy" row with a value one less than the
# 			desired value after creating the table, and then delete the dummy row.
#
# 			For engines that support the AUTO_INCREMENT table option in CREATE_TABLE statements,
# 			you can also use ALTER TABLE tbl_name AUTO_INCREMENT = N to reset the AUTO_INCREMENT value.
#
# 			The value cannot be set lower than the maximum value currently in the column.
#
# 		) AVG_ROW_LENGTH
#
# 			An approximation of the average row length for your table. You need to set this only for large
# 			tables with variable-size rows.
#
# 			When you create a MyISAM table, MySQL uses the product of the MAX_ROWS and AVG_ROW_LENGTH options
# 			to decide how big the resulting table is.
#
# 			If you do not specify either option, the max size for MyISAM data and index file is 256TB by default.
#
# 			(If your OS does not support files that large, table sizes are constrained by the file size limit)
#
# 			If you want to keep down the pointer size to make the index smaller and faster and you do not really
# 			need big files, you can decrease the default pointer size by setting the myisam_data_pointer_size
# 			system variable.
#
# 			(See SECTION 5.1.8, "SERVER SYSTEM VARIABLES")
#
# 			If you want all your tables to be able to grow above the default limit and are willing to have your
# 			tables slightly slower and larger than necessary, you can increase the default point size by setting
# 			this variable.
#
# 			Setting this value to 7 permits table sizes up to 65,536TB
#
# 		) [DEFAULT] CHARACTER SET
#
# 			Specifies a default character set for the table.
#
# 			CHARSET is a synonym for CHARACTER SET.
#
# 			If the character set name is DEFAULT, the database character set is used.
#
# 		) CHECKSUM
#
# 			Set this to 1 if you want MySQL to maintain live checksum for all rows (that is,
# 			a checksum that MySQL updates automatically as the table changes)
#
# 			This makes the table a little slower to update, but also makes it easier
# 			to find corrupted tables.
#
# 			The CHECKSUM_TABLE statement reports the checksum. (MyISAM only)
#
# 		) [DEFAULT] COLLATE
#
# 			Specifies a default collation for the table.
#
# 		) COMMENT
#
# 			A comment for the table, up to 2048 characters long.
#
# 			You can set the InnoDB MERGE_THRESHOLD value for a table using the 
# 			table_option COMMENT clause.
#
# 			See SECTION 15.8.11, "CONFIGURING THE MERGE THRESHOLD FOR INDEX PAGES"
#
# 			SETTING NDB_TABLE OPTIONS.
#
# 			The table comment in a CREATE TABLE that creates an NDB table or an
# 			ALTER_TABLE statement which alters one can also be used to specify one
# 			to four of the NDB_TABLE options:
#
# 				NOLOGGING
#
# 				READ_BACKUP
#
# 				PARTITION_BALANCE
#
# 				FULLY_REPLICATED
#
# 			as a set of name-value pairs, separated by commas if need be, immediately
# 			following the string NDB_TABLE= that begins the quoted comment text.
#
# 			An example statement using this syntax is shown here (emphasized text):
#
# 				CREATE TABLE t1 (
# 					c1 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 					c2 VARCHAR(100),
# 					c3 VARCHAR(100) )
# 				ENGINE=NDB
# 				COMMENT="NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RP_BY_NODE";
#
# 			Spaces are not permitted within the quoted string.
#
# 			The string is case-insensitive.
#
# 			The comment is displayed as part of the output of SHOW_CREATE_TABLE
#
# 			The text of the comment is also available as the TABLE_COMMENT column of the
# 			MySQL Information Schema TABLES table.
#
# 			This comment syntax is also supported with ALTER_TABLE statements for NDB tables.
#
# 			Keep in mind that a table comment used with ALTER TABLE replaces any existing
# 			comment which the table might have had previously.
#
# 			Setting the MERGE_THRESHOLD option in table comments is not supported for NDB tables
# 			(it is ignored)
#
# 			For complete syntax information and examples, see SECTION 13.1.20.10, "SETTING NDB_TABLE OPTIONS"
#
# 		) COMPRESSION
#
# 			The compression algorithm used for page level compression for InnoDB tables.
#
# 			Supported values include Zlib, LZ4, and None.
#
# 			The COMPRESSION attribute was introduced with the transparent page compression
# 			feature.
#
# 			Page compression is only supported with InnoDB tables that reside in file-per-table
# 			tablespaces, and is only available on Linux and Windows platforms that support
# 			sparse files and hole punching.
#
# 			For more information, see SECTION 15.9.2, "InnoDB PAGE COMPRESSION"
#
# 		) CONNECTION
#
# 			The connection string for a FEDERATED table
#
# 			NOTE:
#
# 				Older versions of MySQL used a COMMENT option for the connection string
#
# 		) DATA DIRECTORY, INDEX DIRECTORY
#
# 			For InnoDB, the DATA_DIRECTORY='directory' clause permits creating a file-per-table
# 			tablespace outside of the data directory.
#
# 			The tablespace data file is created in the specified directory, inside a subdirectory
# 			with the same name as the schema.
#
# 			The innodb_file_per_table variable must be enabled to use the DATA DIRECTORY
# 			clause.
#
# 			The full directory path must be specified.
#
# 			For more information, see SECTION 15.6.3.6, "CREATING A TABLESPACE OUTSIDE OF THE DATA DIRECTORY"
#
# 			When creating MyISAM tables, you can use the DATA DIRECTORY='directory' clause, the INDEX DIRECTORY='directory'
# 			clause, or both.
#
# 			They specify where to put a MyISAM table's data file and index file, respectively.
#
# 			Unlike InnoDB tables, MySQL does not create subdirectories that correspond to the 
# 			database name when creating a MyISAM table with a DATA DIRECTORY or INDEX DIRECTORY option.
#
# 			Files are created in the directory that is specified.
#
# 			You must have the FILE privilege to use the DATA DIRECTORY or INDEX DIRECTORY table option.
#
# 			IMPORTANT:
#
# 				Table-level DATA DIRECTORY and INDEX DIRECTORY options are ignored for partitioned tables.
# 				(Bug #32091)
#
# 			These options work only when you are not using the --skip-symbolic-links option.
#
# 			Your OS must also have a working, thread-safe realpath() call
#
# 			See SECTION 8.12.2.2, "USING SYMBOLIC LINKS FOR MYISAM TABLES ON UNIX", for more
# 			complete information.
#
# 			If a MyISAM table is created with no DATA DIRECTORY option, the .MYD file is created
# 			in the database directory.
#
# 			By default, if MyISAM finds an existing .MYD file in this case, it overwrites it.
#
# 			The same applies to .MYI files for tables created with no INDEX DIRECTORY option.
#
# 			To suppress this behavior, start the server with the --keep_files_on_create option,
# 			in which case MyISAM will not overwrite existing files and returns an error instead.
#
# 			If a MyISAM table is created with a DATA DIRECTORY or INDEX DIRECTORY option and
# 			an existing .MYD or .MYI file is found, MyISAM always returns an error.
#
# 			It will not overwrite a file in the specified directory.
#
# 				IMPORATNT:
#
# 					You cannot use path names that contain the MySQL data directory with
# 					DATA DIRECTORY or INDEX DIRECTORY.
#
# 					THis includes partitioned tables and individual table partitions.
# 					(See Bug #32167)
#
# 		) DELAY_KEY_WRITE
#
# 			Set this to 1 if you want to delay key updates for the table until the table is closed.
#
# 			See the description of the delay_key_write system variable in SECTION 5.1.8, "SERVER SYSTEM VARIABLES"
# 			(MyISAM only)
#
# 		) ENCRYPTION
#
# 			Set the ENCRYPTION option to 'Y' to enable page-level data encryption for an InnoDB
# 			table created in a file-per-table tablespace.
#
# 			Option values are not case-sensitive.
#
# 			The ENCRYPTION option was introduced with the InnoDB tablespace encryption feature;
# 			see SECTION 15.6.3.9, "TABLESPACE ENCRYPTION"
#
# 			A keyring plugin must be installed and configured to use the ENCRYPTION option.
#
# 		) INSERT_METHOD
#
# 			If you want to insert data into a MERGE table; you must specify with INSERT_METHOD
# 			the table into which the row should be inserted.
#
# 			INSERT_METHOD is an option useful for MERGE tables only.
#
# 			Use a value of FIRST or LAST to have inserts go to the first or last table,
# 			or a value of NO to prevent inserts.
#
# 			See SECTION 16.7, "THE MERGE STORAGE ENGINE"
#
# 		) KEY_BLOCK_SIZE
#
# 			For MyISAM tables, KEY_BLOCK_SIZE optionally specifies the size in bytes to use
# 			for index key blocks.
#
# 			The value is treated as a hint; a different size could be used if necessary.
#
# 			A KEY_BLOCK_SIZE value specified for an individual index definition overrides
# 			the table-level KEY_BLOCK_SIZE value.
#
# 			For InnoDB tables, KEY_BLOCK_SIZE specifies the page size in kilobytes to use
# 			for compressed InnoDB tables.
#
# 			The KEY_BLOCK_SIZE value is treated as a hint; a different size could be used
# 			by InnoDB if necessary.
#
# 			KEY_BLOCK_SIZE can only be less than or equal to the innodb_page_size value.
#
# 			A value of 0 represents the default compressed page size, which is half of the
# 			innodb_page_size value.
#
# 			Depending on innodb_page_size, possible KEY_BLOCK_SIZE values include
# 			0, 1, 2, 4, 8 and 16.
#
# 			See SECTION 15.9.1, "InnoDB TABLE COMPRESSION" for more information
#
# 			Oracle recommends enabling innodb_strict_mode when specifying KEY_BLOCK_SIZE
# 			for InnoDB tables.
#
# 			When innodb_strict_mode is enabled, specifying an invalid KEY_BLOCK_SIZE value
# 			returns an error.
#
# 			If innodb_strict_mode is disabled, an invalid KEY_BLOCK_SIZE value results
# 			in a warning, and the KEY_BLOCK_SIZE option is ignored.
#
# 			The Create_options column in response to SHOW_TABLE_STATUS reports the
# 			actual KEY_BLOCK_SIZE used by the table, as does SHOW_CREATE_TABLE
#
# 			InnoDB only supports KEY_BLOCK_SIZE at the table level
#
# 			KEY_BLOCK_SIZE is not supported with 32KB and 64KB innodb_page_size values.
#
# 			InnoDB table compression does not support these page sizes.
#
# 			InnoDB does not support the KEY_BLOCK_SIZE option when creating temporary tables.
#
# 		) MAX_ROWS
#
# 			The maximum number of rows you plan to store in the table.
#
# 			This is not a hard limit, but rather a hint to the storage engine that
# 			the table must be able to store at least this many rows.
#
# 				IMPORTANT:
#
# 					The use of MAX_ROWS with NDB tables to control the number of table
# 					partitions is deprecated.
#
# 					It remains supported in later versions for backward compatibility,
# 					but is subject to removal in a future release.
#
# 					Use PARTITION_BALANCE instead; see SETTING NDB_TABLE OPTIONS
#
# 			The NDB storage engine treats this value as a maximum.
#
# 			If you plan to create very large NDB Cluster tables (containing millions of rows),
# 			you should use this option to insure that NDB allocates sufficient number of index slots
# 			in the hash table used for storing hashes of the table's primary keys by setting
# 			MAX_ROWS = 2 * rows, where rows is the number of rows that you expect to insert
# 			into the table.
#
# 			The maximum MAX_ROWS value is 4294967295; larger values are truncated to this limit.
#
# 		) MIN_ROWS
#
# 			The minimum number of rows you plan to store in the table.
#
# 			The MEMORY storage engine uses this option as a hint about memory use.
#
# 		) PACK_KEYS
#
# 			Takes effect only with MyISAM tables.
#
# 			Set this option to 1 if you want to have smaller indexes.
#
# 			This usually makes updates slower and reads faster. 
# 			Setting this option to 0 disables all packing of keys.
#
# 			Setting it to DEFAULT tells the storage engine to pack only long
# 			CHAR, VARCHAR, BINARY or VARBINARY columns.
#
# 			If you do not use PACK_KEYS, the default is to pack strings, but not 
# 			numbers.
#
# 			If you use PACK_KEYS=1, numbers are packed as well.
#
# 			When packing binary number keys, MySQL uses prefix compression:
#
# 				) Every key needs one extra byte to indicate how many bytes of the previous key are the same 
# 					for the next key.
#
# 				) The pointer to the row is stored in high-byte-first order directly after the key, to improve compression.
#
# 			This means that if you have many equal keys on two consecutive rows, all following "same" keys
# 			usually only take two bytes (including the pointer ot the row)
#
# 			Compare this to the ordinary case where the following keys takes storage_size_for_key +
# 			pointer_size (where the pointer size is usually 4)
#
# 			Conversely, you get a significant benefit from prefix compression only if you have
# 			many numbers that are the same.
#
# 			If all keys are totally different, you use one byte more per key, if the key is not a key
# 			that can have NULL values.
#
# 			(In this case, the packed key length is stored in the same byte that is used to mark if a key is NULL)
#
# 		) PASSWORD
#
# 			This option is unused
#
# 		) ROW_FORMAT
#
# 			Defines the physical format in which the rows are stored.
#
# 			When executing a CREATE_TABLE statement with strict mode disabled, if you specify
# 			a row format that is not supported by the storage engine that is used
# 			for the table, the table is created using that storage engine's default row format.
#
# 			The actual row format of the table is reported in the Row_format and Create_options
# 			columns in response to SHOW_TABLE_STATUS.
#
# 			SHOW_CREATE_TABLE also reports the actual row format of the table.
#
# 			Row format choices differ depending on the storage engine used for the table.
#
# 			For InnoDB tables:
#
# 				) The default row format is defined by innodb_default_row_format, which has
# 					a default setting of DYNAMIC.
#
# 					The default row format is used when the ROW_FORMAT option is not defined
# 					or when ROW_FORMAT=DEFAULT is used.
#
# 					If the ROW_FORMAT option is not defined, or if ROW_FORMAT=DEFAULT is used,
# 					operations that rebuild a table also silently change the row format
# 					of the table to the default defined by innodb_default_row_format.
#
# 					For more information, see DEFINING THE ROW FORMAT OF A TABLE
#
# 				) For more efficient InnoDB storage of data types, especially BLOB types,
# 					use the DYNAMIC.
#
# 					See DYNAMIC ROW FORMAT for requirements associated with the DYNAMIC
# 					row format.
#
# 				) To enable compression for InnoDB tables, specify ROW_FORMAT=COMPRESSED
#
# 					The ROW_FORMAT=COMPRESSED option is not supported when creating temporary
# 					tables.
#
# 					See SECTION 15.9, "InnoDB TABLE AND PAGE COMPRESSION" for requirements
# 					associated with the COMPRESSED row format.
#
# 				) The row format used in older versions of MySQL can still be requested by specifying the REDUNDANT row format.
#
# 				) When you specify a non-default ROW_FORMAT clause, consider also enabling the innodb_strict_mode configuration option
#
# 				) ROW_FORMAT=FIXED is not supported.
#
# 					If ROW_FORMAT=FIXED is specified while innodb_strict_mode is disabled, InnoDB issues a warning
# 					and assumes ROW_FORMAT=DYNAMIC.
#
# 					If ROW_FORMAT=FIXED is specified while innodb_strict_mode is enabled,
# 					which is the default, InnoDB returns an error.
#
# 				) For additional information about InnoDB row formats, see SECTION 15.10, "InnoDB ROW FORMATS"
#
# 			For MyISAM tables, the option value can be FIXED or DYNAMIC for static or variable-length
# 			row format.
#
# 			myisampack sets the type to COMPRESSED. See SECTION 16.2.3, "MyISAM TABLE STORAGE FORMATS"
#
# 			For NDB tables, the default ROW_FORMAT is DYNAMIC
#
# 		) STATS_AUTO_RECALC
#
# 			Specifies whether to automatically recalculate persistent statistics for an InnoDB table.
#
# 			The value DEFAULT causes the persistent statistics setting for the table to be
# 			determined by the innodb_stats_auto_recalc configuration option.
#
# 			The value 1 causes statistics to be recalculated when 10% of the data in teh table
# 			has changed.
#
# 			The value 0 prevents automatic recalculation for this table; with this setting,
# 			issue an ANALYZE_TABLE statement to recalculate the statistics after making
# 			substansial changes to the table.
#
# 			For more information about the persistent statistics feature, see SECTION 15.8.10.1,
# 			"CONFIGURING PERSISTENT OPTIMIZER STATISTICS PARAMETERS"
#
# 		) STATS_PERSISTENT
#
# 			Specifies whether to enable persistent statistics for an InnoDB table.
#
# 			The value DEFAULT causes the persistent statistics setting for the table to
# 			be determined by the innodb_stats_persistent configuration option.
#
# 			The value 1 enables persistent statistics for the table, while the value 
# 			0 turns off this feature.
#
# 			After enabling persistent statistics through a CREATE TABLE or ALTER TABLE
# 			statement, issue an ANALYZE_TABLE statement to calculate the statistics,
# 			after loading representative data into the table.
#
# 			For more information about the persistent statistics feature,
# 			see SECTION 15.8.10.1, "CONFIGURING PERSISTENT OPTIMIZER STATISTICS PARAMETERS"
#
# 		) STATS_SAMPLE_PAGES
#
# 			The number of index pages to sample when estimating cardinality and other
# 			statistics for an indexed column, such as those calculated by ANALYZE_TABLE.
#
# 			For more information, see SECTION 15.8.10.1, "CONFIGURING PERSISTENT OPTIMIZER STATISTICS PARAMETERS"
#
# 		) TABLESPACE
#
# 			The TABLESPACE clause can be used to create a table in an existing general tablespace,
# 			a file-per-table tablespace, or the system tablespace.
#
# 				CREATE TABLE tbl_name --- TABLESPACE [=] tablespace_name
#
# 			The general tablespace that you specify must exist prior to using the
# 			TABLESPACE clause.
#
# 			For information about general tablespaces, see SECTION 15.6.3.3, "GENERAL TABLESPACES"
#
# 			The tablespace_name is a case-sensitive identifier.
#
# 			It may be quoted or unquoted. The forward slash character ("/") is not permitted.
#
# 			Names beginning with "innodb_" are reserved for special use.
#
# 			To create a table in the system tablespace, specify innodb_system as the tablespace name.
#
# 				CREATE TABLE tbl_name --- TABLESPACE [=] innodb_system
#
# 			Using TABLESPACE [=] innodb_system you can place a table of any uncompressed row
# 			format in the system tablespace regardless of the innodb_file_per_table setting.
#
# 			For example, you can add a table with ROW_FORMAT=DYNAMIC to the system tablespace
# 			using TABLESPACE [=] innodb_system
#
# 			To create a table in a file-per-table tablespace, specify innodb_file_per_table as
# 			the tablespace name.
#
# 				CREATE TABLE tbl_name --- TABLESPACE [=] innodb_file_per_table
#
# 			NOTE:
#
# 				If innodb_file_per_table is enabled, you need not specify TABLESPACE=innodb_file_per_table
# 				to create an InnoDB file-per-table tablespace.
#
# 				InnoDB tables are created in file-per-table tablespaces by default when innodb_file_per_table 
# 				is enabled.
#
# 			The DATA DIRECTORY clause is permitted with CREATE TABLE --- TABLESPACE=innodb_file_per_table but
# 			is otherwise not supported for use in combination with the TABLESPACE clause.
#
# 			NOTE:
#
# 				Support for TABLESPACE = innodb_file_per_table and TABLESPACE = innodb_temporary clauses
# 				with CREATE_TEMPORARY_TABLE is deprecated as of MySQL 8.0.13, and will be removed
# 				in a future version of MySQL.
#
# 		) UNION
#
# 			Used to access a collection of identical MyISAM tables as one.
#
# 			This works only with MERGE tables. See SECTION 16.7, "THE MERGE STORAGE ENGINE"
#
# 			You must have SELECT, UPDATE and DELETE privileges for the tables you map to a MERGE table
#
# 			NOTE:
#
# 				Formerly, all tables used had to be in the same database as the MERGE table itself.
#
# 				This restriction no longer applies.
#
# CREATING PARTITIONED TABLES
#
# partition_options can be used to control partitioning of the table created with CREATE_TABLE
#
# Not all options shown in the syntax for partition_options at the beginning of this section are
# available for all partitioning types.
#
# Please see the listings for the following individual types for information specific to each
# type,  and see CHAPTER 23, PARTITIONING, for more complete information about the workings
# of and uses for partitioning in MySQL, as well as additional examples of table creation
# and other statements relating to MySQL partitioning.
#
# Partitions can be modified, merged, added to tables, and dropped from tables.
#
# For basic information about the MySQL statements to accomplish these tasks, see
# SECTION 13.1.9, "ALTER TABLE SYNTAX"
#
# For more detailed descriptions and examples, see SECTION 23.3, "PARTITION MANAGEMENT"
#
# 		) PARTITION BY
#
# 			If used, a partition_options clause begins with PARTITION BY.
#
# 			This clause contains the function that is used to determine the partition;
# 			the function returns an integer value ranging from 1 to num, where num is
# 			the number of partitions.
#
# 			(The maximum number of user-defined partitions which a table may contain is 
# 			1024; the number of subpartitions - discussed later in this section - 
# 			is included in this maximum)
#
# 			NOTE:
#
# 				The expression (expr) used in a PARTITION BY clause cannot refer to any
# 				columns not in the table being created;
#
# 				Such references are specifically not permitted and cause the statement to fail
# 				with an error (Bug #29444)
#
# 		) HASH(expr)
#
# 			Hashes one or more columns to create a key for placing and locating rows.
#
# 			expr is an expression using one or more table columns.
#
# 			This can be any valid MySQL expression (including MySQL functions) that
# 			yields a single integer value.
#
# 			For example, these are both valid CREATE_TABLE statements using PARTITION BY HASH:
#
# 				CREATE TABLE t1 (col1 INT, col2 CHAR(5))
# 					PARTITION BY HASH(col1);
#
# 				CREATE TABLE t1 (col1 INT, col2 CHAR(5), col3 DATETIME)
# 					PARTITION BY HASH ( YEAR(col3) );
#
# 			You may not use either VALUES LESS THAN or VALUES IN clauses with PARTITION BY HASH
#
# 			PARTITION BY HASH uses the remainder of expr divided by the number of partitions (that is, modulus)
#
# 			For examples and additional information, see SECTION 23.2.4, "HASH PARTITIONING"
#
# 			The LINEAR keyword entails a somewhat different algorithm.
#
# 			In this case, the number of the partition in which a row is stored is calculated
# 			as the result of one or more logical AND operations.
#
# 			For discussion and examples of linear hashing, see SECTION 23.2.4.1, "LINEAR HASH PARTITIONING"
#
# 		) KEY(column_list)
#
# 			This is similar to HASH, except that MySQL supplies the hashing function so as to
# 			guarantee an even data distribution.
#
# 			The column_list argument is simply a list of 1 or more table columns (max: 16)
#
# 			This example shows a simple table partitioned by key, with 4 partitions:
#
# 				CREATE TABLE tk (col1 INT, col2 CHAR(5), col3 DATE)
# 					PARTITION BY KEY(col3)
# 					PARTITIONS 4;
#
# 			For tables that are partitioned by key, you can employ linear partitioning by using
# 			the LINEAR keyword.
#
# 			THis has the same effect as with tables that are partitioned by HASH.
#
# 			That is, the partition number is found using the & operator rather than
# 			the modulus (see SECTION 23.2.4.1, "LINEAR HASH PARTITIONING", and SECTION 23.2.5, "KEY PARTITIONING", for details)
#
# 			This example uses linear partitioning by key to distribute data between 5 partitions:
#
# 				CREATE TABLE tk (col1 INT, col2 CHAR(5), col3 DATE)
# 					PARTITION BY LINEAR KEY(col3)
# 					PARTITIONS 5;
#
# 			The ALGORITHM={1|2} option is supported with [SUB]PARTITION BY [LINEAR] KEY ALGORITHM=1 causes
# 			the server to use the same key-hashing functions as MySQL 5.1
#
# 			ALGORITHM=2 means that hte server employs the key-hashing functions implemented and used
# 			by default for new KEY partitioned tables in MySQL 5.5 and later.
#
# 			(Partitioned tables created with the key-hashing functions employed in MySQL 5.5 and later
# 			cannot be used by a MySQL 5.1 server)
#
# 			Not specifying the option has the same effect as using ALGORITHM=2
#
# 			This option is intended for use chiefly when upgrading or downgrading [LINEAR]
# 			KEY partitioned tables between MySQL 5.1 and later MySQL versions, or for creating
# 			tables partitioned by KEY or LINEAR KEY on a MySQL 5.5 or later server which can be used
# 			on a MySQL 5.1 server
#
# 			For more information, see SECTION 13.1.9.1, "ALTER TABLE PARTITION OPERATIONS"
#
# 			mysqldump in MySQL 5.7 (and later) writes this option encased in versioned comments like this:
#
# 				CREATE TABLE t1 (a INT)
# 				/*!50100 PARTITION BY KEY */ /*!50611 ALGORITHM = 1 */ /*!50100 ()
# 						PARTITIONS 3 */
#
# 			This causes MySQL 5.6.10 and earlier servers to ignore the option, which would otherwise
# 			cause a syntax error in those versions.
#
# 			If you plan to load a dump made on a MySQL 5.7 server where you use tables that are
# 			partitioned or subpartitioned by KEY into a MySQL 5.6 server previous to 5.6.11,
# 			be sure to consult changes in MySQL 5.6
#
# 			(The information found there also applies if you are loading a dump containing KEY
# 			partitioned or subpartitioned tables made from a MySQL 5.7 - actually, 5.6.11
# 			or later - server into a MySQL 5.5.30 or earlier server)
#
# 			Also in MySQL 5.6.11, and later, ALGORITHM=1 is shown when necessary in the output
# 			of SHOW_CREATE_TABLE using versioned comments in teh same manner as mysqldump.
#
# 			ALGORITHM=2 is always omitted from SHOW CREATE TABLE output, even if this option
# 			was speified when creating the original table.
#
# 			You may not use either VALUES LESS THAN or VALUES IN clauses with PARTITION BY KEY
#
# 		) RANGE(expr)
#
# 			In this case, expr shows a range of values using a set of VALUES LESS THAN operators.
#
# 			When using range partitioning, you must define at least one partition using
# 			VALUE LESS THAN
#
# 			You cannot use VALUES IN with range partitioning
#
# 			NOTE:
#
# 				For tables partitioned by RANGE, VALUES LESS THAN must be used with either
# 				an integer literal value or an expression that evaluates to a single integer
# 				value.
#
# 				In MySQL 8.0, you can overcome this limitation in a table that is defined
# 				using PARTITION BY RANGE COLUMNS, as described later in this section.
#
# 			Suppose that you have a table that you wish to partition on a column containing
# 			year values, according to the following scheme.
#
	# 			PARTITION NUMBER: 			YEARS RANGE:
	#
	# 			0 									1990 and earlier
	#
	# 			1 									1991 to 1994
	#
	# 			2 									1995 to 1998
	#
	# 			3 									1999 to 2002
	#
	# 			4 									2003 to 2005
	#
	# 			5 									2006 and later
#
# 			A table implementing such a partitioning scheme can be realized by the 
# 			CREATE_TABLE statement shown here:
#
# 				CREATE TABLE t1 (
# 					year_col INT,
# 					some_data INT
# 				)
# 				PARTITION BY RANGE (year_col) (
# 					PARTITION p0 VALUES LESS THAN (1991),
# 					PARTITION p1 VALUES LESS THAN (1995),
# 					PARTITION p2 VALUES LESS THAN (1999),
# 					PARTITION p3 VALUES LESS THAN (2002),
# 					PARTITION p4 VALUES LESS THAN (2006),
# 					PARTITION p5 VALUES LESS THAN MAXVALUE
# 				);
#
# 			PARTITION --- VALUES LESS THAN --- statements work in a consecutive fashion.
#
# 			VALUES LESS THAN MAXVALUE works to specify "leftover" values that are greater
# 			than the maximum value otherwise specified.
#
# 			VALUES LESS THAN clauses work sequentially in a manner similar to that of hte case
# 			portions of a switch --- case block (as found in many languages)
#
# 			THat is, the clauses must be arranged in such a way that hte upper limit specified
# 			in each successive VALUES LESS THAN is greater than that of the previous one,
# 			with the one referencing MAXVALUE coming last of all in the list.
#
# 		) RANGE COLUMNS (column_list)
#
# 			This variant of RANGE facilitates partition pruning for queries using range conditions
# 			on multiple columns (that is, having conditions such as WHERE a = 1 AND b < 10 or
# 			WHERE a = 1 AND b = 10 AND c < 10)
#
# 			It enables you to specify value ranges in multiple columns by using a list of columns
# 			in the COLUMNS clause and a set of column values in each PARTITION --- VALUES LESS THAN (value_list)
# 			partition definition clause.
#
# 			(In the simplest case, this set consists of a single column)
#
# 			The maximum number of columns that can be referenced in the column_list and
# 			value_list is 16.
#
# 			The column_list used in the COLUMNS clause may contain only names of columns;
# 			each column in the list must be one of the following MySQL data types:
#
# 				The integer types
#
# 				The string types
#
# 				´Time or date column types
#
# 			Columns using BLOB, TEXT, SET, ENUM, BIT or spatial data types
# 			are not permitted;
#
# 			Columns that use floating-point number types are also not permitted.
#
# 			You also may not use functions or arithmetic expressions in the COLUMNS clause.
#
# 			The VALUES LESS THAN clause used in a partition definition must specify a literal value
# 			for each column that appears in the COLUMNS() clause
#
# 			That is, the list of values used for each VALUES LESS THAN clause must contain the 
# 			same number of values as there are columns listed in the COLUMNS clause.
#
# 			AN attempt to use more or fewer values in a VALUES LESS THAN clause than there are
# 			in the COLUMNS clause causes the statements to fail with the:
#
# 			 error Inconsistency in usage of column lists for partitionining 	error
#
# 			You cannot use NULL for any value appearing in VALUES LESS THAN
#
# 			It is possible to use MAXVALUE more than once for a given column
# 			other than the first, as shown in this example:
#
# 				CREATE TABLE rc (
# 					a INT NOT NULL,
# 					b INT NOT NULL
# 				)
# 				PARTITION BY RANGE COLUMNS(a,b) (
# 					PARTITION p0 VALUES LESS THAN (10,5),
# 					PARTITION p1 VALUES LESS THAN (20,10),
# 					PARTITION p2 VALUES LESS THAN (50,MAXVALUE),
# 					PARTITION p3 VALUES LESS THAN (65,MAXVALUE),
# 					PARTITION p4 VALUES LESS THAN (MAXVALUE,MAVALUE)
# 				);
#
# 			Each value in a VALUES LESS THAN value list must match the type of the corresponding
# 			column exactly; no conversion is made.
#
# 			For example, you cannot use the string '1' for a value that matches a column that uses
# 			an integer type (you must use the numeral 1 instead), nor can you use hte numeral 1
# 			for a value that matches a column that uses a string type (in such a case, you must use a quoted string '1')
#
# 			For more information, see SECTION 23.2.1, "RANGE PARTITIONING" and SECTION 23.4, "PARTITION PRUNING"
#
# 		) LIST(expr)
#
# 			THis is useful when assigning partitions based on a table column with a restricted set of possible values,
# 			such as a state or country code.
#
# 			In such a case, all rows pertaining to a certain state or country can be assigned
# 			to a single partition, or a partition can be reserved for a certain set of states
# 			or countries.
#
# 			It is similar to RANGE, except that only VALUES IN may be used to specify permissible
# 			values for each partition.
#
# 			VALUES IN is used with a list of values to be matched.
#
# 			For instance, you could create a partitioning scheme such as
# 			the following:
#
# 				CREATE TABLE client_firms (
# 					id INT,
# 					name VARCHAR(35)
# 				)
# 				PARTITION BY LIST (id) (
# 					PARTITION r0 VALUES IN (1, 5, 9, 13, 17, 21),
# 					PARTITION r1 VALUES IN (2, 6, 10, 14, 18, 22),
# 					PARTITION r2 VALUES IN (3, 7, 11, 15, 19, 23),
# 					PARTITION r3 VALUES IN (4, 8, 12, 16, 20, 24)
# 				);
#
# 			When using list partitioning, you must define at least one partition using VALUES IN.
#
# 			You cannot use VALUES LESS THAN with PARTITION BY LIST.
#
# 			NOTE:
#
# 				For tables partitioned by LIST, the value list used with VALUES IN must consist
# 				of integer values only.
#
# 				In MySQL 8.0, you can overcome this limitation using partitioning by LIST COLUMNS,
# 				which is described later in this section.
#
# 		) LIST COLUMNS(column_list)
#
# 			This variant on LIST facilitates partition pruning for queries using comparison conditions
# 			on multiple columns (that is, having conditions such as WHERE a = 5 AND b = 5 or WHERE a = 1 AND b = 10 AND c = 5)
#
# 			It enables you to specify values in multiple columns by using a list of columns in the
# 			COLUMNS clause and a set of column values in each PARTITION --- VALUES IN (value_list)
# 			partition definition clause.
#
# 			The rules governing regarding data types for the column list used in LIST COLUMNS (column_list)
# 			and the value listed used in VALUES IN (value_list) are the same as those for the column
# 			list used in RANGE COLUMNS (column_list) and the value list used in VALUES LESS THAN (value_list),
# 			respectively, except that in the VALUES IN clause, MAXVALUE is not permitted, and you may use NULL.
#
# 			There is one important difference between the list of values used for VALUES IN with PARTITION BY LIST COLUMNS
# 			as opposed to when it is used with PARTITION BY LIST.
#
# 			When used with PARTITION BY LIST COLUMNS, each element in the VALUES IN clause must be a set of column values;
# 			the number of values in each set must be the same as the number of columns used in the COLUMNS clause, and the
# 			data types of these values must match those of the columns (and occur in the same order)
#
# 			In the simplest case, the set consists of a single column.
#
# 			The maximum number of columns that can be used in the column_list and in the elements
# 			making up the value_list is 16.
#
# 			The table defined by the following CREATE TABLE statement provides an example of a table
# 			using LIST COLUMNS partitioning:
#
# 				CREATE TABLE lc (
# 					a INT NULL,
# 					b INT NULL
# 				)
# 				PARTITION BY LIST COLUMNS(a,b) (
# 					PARTITION p0 VALUES IN( (0,0), (NULL,NULL) ),
# 					PARTITION p1 VALUES IN( (0,1), (0,2), (0,3), (1,1), (1,2) ),
# 					PARTITION p2 VALUES IN( (1,0), (2,0), (2,1), (3,0), (3,1) ),
# 					PARTITION p3 VALUES IN( (1,3), (2,2), (2,3), (3,2), (3,3) )
# 				);
#
# 		) PARTITIONS num
#
# 			The number of partitions may optionally be specified with a PARTITIONS num clause,
# 			where num is the number of partitions.
#
# 			If both this clause and any PARTITION clause are used, num must be equal to the
# 			total number of any partitions that are declared using PARTITION clauses.
#
# 			NOTE:
#
# 				Whether or not you use a PARTITIONS clause in creating a table that is partitioned
# 				by RANGE or LIST, you must still include at least one PARTITION VALUES clause in
# 				the table definition (see below)
#
# 		) SUBPARTITION BY
#
# 			A partition may optionally be divided into a number of subpartitions.
#
# 			This can be indicated by using the optional SUBPARTITION BY clause.
#
# 			Subpartitioning may be done by HASH or KEY.
#
# 			Either of these may be LINEAR. These work in the same way as previously described
# 			for the equivalent partitioning types.
#
# 			(It is not possible to subpartition by LIST or RANGE)
#
# 			The number of subpartitions can be indicated using the SUBPARTITIONS keyword
# 			followed by an integer value.
#
# 		) Rigorous checking of the value used in PARTITIONS or SUBPARTITIONS clauses is applied
# 			and this value must adhere to the following rules:
#
# 				) THe value must be a positive, nonzero integer
#
# 				) No leading zeros are permitted
#
# 				) The value must be an integer literal, and cannot not be an expression.
#
# 					For example, PARTITIONS 0.2E+01 is not permitted, even though 0.2E+01 evaluates
# 					to 2. (Bug #15890)
#
# 		) partition_definition
#
# 			Each partition may be individually defined using a partition_definition clause.
#
# 			The individual parts making up this clause are as follows:
#
# 				) PARTITION partition_name
#
# 					Specifies a logical name for the partition
#
# 				) VALUES
#
# 					For range partitioning, each partition must include a VALUES LESS THAN clause;
# 					for list partitioning, you must specify a VALUES IN clause for each partition.
#
# 					This is used to determine which rows are to be stored in this partition.
#
# 					See the discussion of partitioning types in CHAPTER 23, PARTITIONING, for syntax examples.
#
# 				) [STORAGE] ENGINE
#
# 					MySQL accepts a [STORAGE] ENGINE option for both PARTITION and SUBPARTITION.
#
# 					Currently, the only way in which this option can be used is to set all partitions
# 					or all subpartitions to the same storage engine, and an attempt to set different storage
# 					engines for partitions or subpartitions in the same table will give rise to the error:
#
# 						ERROR 1469 (HY000): The mix of handlers in the partitions is not permitted in this version of MySQL
#
# 				) COMMENT
#
# 					An optional COMMENT clause may be used to specify a string that describes the partition.
#
# 					Example:
#
# 						COMMENT = 'Data for the years previous to 1999'
#
# 					The maximum length for a partition comment is 1024 chars.
#
# 				) DATA DIRECTORY and INDEX DIRECTORY
#
# 					DATA DIRECTORY and INDEX DIRECTORY may be used to indicate the directory where,
# 					respectively, the data and indexes for this partition are to be stored.
#
# 					Both the data_dir and the index_dir must be absolute system path names.
#
# 					You must have the FILE privilege to use the DATA DIRECTORY or INDEX DIRECTORY partition option.
#
# 					Example:
#
# 						CREATE TABLE th (id INT, name VARCHAR(30), adate DATE)
# 						PARTITION BY LIST(YEAR(adate))
# 						(
# 							PARTITION p1999 VALUES IN (1995, 1999, 2003)
# 								DATA DIRECTORY = '/var/appdata/95/data'
# 								INDEX DIRECTORY = '/var/appdata/95/idx',
# 							PARTITION p2000 VALUES IN (1996, 2000, 2004)
# 								DATA DIRECTORY = '/var/appdata/96/data'
# 								INDEX DIRECTORY = '/var/appdata/96/idx',
# 							PARTITION p2001 VALUES IN (1997, 2001, 2005)
# 								DATA DIRECTORY = '/var/appdata/97/data'
# 								INDEX DIRECTORY = '/var/appdata/97/idx',
# 							PARTITION p2002 VALUES IN (1998, 2002, 2006)
# 								DATA DIRECTORY = '/var/appdata/98/data'
# 								INDEX DIRECTORY = '/var/appdata/98/idx'
# 						);
#
# 					DATA DIRECTORY and INDEX DIRECTORY behave in the same way as in the CREATE TABLE statements
# 					table_option clause as used for MyISAM tables.
#
# 					One data directory and one index directory may be specified per partition.
#
# 					If left unspecified, the data and the indexes are stored by default in teh table's database
# 					directory.
#
# 					The DATA DIRECTORY and INDEX DIRECTORY options are ignored for creating partitioned tables if
# 					NO_DIR_IN_CREATE is in effect.
# 				
# 				) MAX_ROWS and MIN_ROWS
#
# 					May be used to specify, respectively, the maximum and the minimum number of rows to be stored
# 					in the partition.
#
# 					The values for max_number_of_rows and min_number_of_rows must be positive integers.
#
# 					As with the table-level options with the same names, these act only as "suggestions"
# 					to the server and are not hard limits.
#
# 				) TABLESPACE
#
# 					May be used to designate an InnoDB file-per-table tablespace for the partition by specifying
# 					TABLESPACE `innodb_file_per_table
#
# 					All partitions must belong to the same storage engine
#
# 					Placing InnoDB table partitions in shared InnoDB tablespaces is not supported.
#
# 					Shared tablespaces include the InnoDB system tablesapce and general tablespaces.
#
# 		) subpartition_definition
#
# 			The partition definition may optionally contain one or more subpartition_definition clauses.
#
# 			Each of these consists at a minimum of the SUBPARTITION name, where name is an identifier
# 			for the subpartition.
#
# 			Except for the replacement of the PARTITION keyword with SUBPARTITION, the syntax for a 
# 			subpartition definintion is identical to that for a partition definition.
#
# 			Subpartitioning must be done by HASH or KEY, and can be done only on RANGE or LIST partitions.
#
# 			See SECTION 23.2.6, "SUBPARTITIONING"
#
# PARTITIONING BY GENERATED COLUMNS
#
# Partitioning by generated columns is permitted.
#
# For example:
#
# 		CREATE TABLE t1 (
# 			s1 INT,
# 			s2 INT AS (EXP(s1)) STORED
# 		)
# 		PARTITION BY LIST (s2) (
# 			PARTITION p1 VALUES IN (1)
# 		);
#
# Partitioning sees a generated column as a regular column, which enables workarounds for limitations
# on functions that are not permitted for partitioning (see SECTION 23.6.3, "PARTITIONING LIMITATIONS RELATING TO FUNCTIONS")
#
# THe preceding example demonstrates this technique:
#
# 		EXP() cannot be used directly in teh PARTITION BY clause, but a generated
# 		column defined using EXP() is permitted.
#
# 13.1.20.1 CREATE TABLE STATEMENT RETENTION
#
# The original CREATE_TABLE statement, including all specifications and table options are stored by
# MySQL when the table is created.
#
# The information is retained so that if you change storage engines, collations or other settings
# using an ALTER_TABLE statement, the original table options specified are retained.
#
# This enables you to change between InnoDB and MyISAM table types even though the row formats
# supported by the two engines are different.
#
# Because the text of the original statement is retained, but due to the way that certain values
# and options may be silently reconfigured, the active table definition (accessible through 
# DESCRIBE or with SHOW_TABLE_STATUS) and the table creation string (accessible through
# SHOW_CREATE_TABLE) may report different values.
#
# For InnoDB tables, SHOW_CREATE_TABLE and the Create_options column reported by SHOW_TABLE_STATUS
# show the actual ROW_FORMAT and KEY_BLOCK_SIZE attributes used by the table.
#
# In previous MySQL releases, the originally specified values for these attributes were reported.
#
# 13.1.20.2 FILES CREATED BY CREATE TABLE
#
# For an InnoDB table created in a file-per-table tablespace or general tablespace, table data
# and associated indexes are stored in an ibd file in the database directory.
#
# When an InnoDB table is created in the system tablespace, table data and indexes are stored
# in the ibdata* files that represent the system tablespace.
#
# The innodb_file_per_table option controls whether tables are created in file-per-table
# tablespaces or the system tablespace, by default.
#
# The TABLESPACE option can be used to place a table in a file-per-table tablespace,
# general tablespace, or the  system tablespace, regardless of the innodb_file_per_table
# setting.
#
# For MyISAM tables, the storage engine creates data and index files.
#
# Thus, for each MyISAM table tbl_name, there are two disk files.
#
# FILE 			PURPOSE
#
# tbl_name.MYD Data file
# tbl_name.MYI Index file
#
# Chapter 16, ALTERNATIVE STORAGE ENGINES describes what files each storage engine
# creates to represent tables.
#
# If a table name contains special characters, the names for the table files 
# contain encoded versions of those characters as described in SECTION 9.2.3, "MAPPING OF IDENTIFIERS TO FILE NAMES"
#
# 13.1.20.3 CREATE TEMPORARY TABLE SYNTAX
#
# You can use the TEMPORARY keyword when creating a table.
#
# A TEMPORARY table is visible only within the current session, and is dropped automatically when
# the session is closed.
#
# THis means that two different sessions can use the same temporary table name without conflicting
# with each other or with an existing non-TEMPORARY table of the same name.
#
# (The existing table is hidden until the temporary table is dropped)
#
# InnoDB does not support compressed temporary tables.
#
# When innodb_strict_mode is enabled (the default), CREATE_TEMPORARY_TABLE returns an error
# if ROW_FORMAT=COMPRESSED or KEY_BLOCK_SIZE is specified.
#
# If innodb_strict_mode is disabled, warnings are issued and the temporary table is created
# using a non-compressed row format.
#
# The innodb_file_per-table option does not affect the creation of InnoDB temporary tables.
#
# CREATE_TABLE causes an implicit commit, except when used with the TEMPORARY keyword.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# TEMPORARY tables have a very loose relationship with databases (schemas)
#
# Dropping a database does not automatically drop any TEMPORARY tables created
# within that database.
#
# ALso, you can create a TEMPORARY table in a nonexistent database if you qualify the
# table name with the database name in the CREATE TABLE statement.
#
# In this case, all subsequent references to the table must be qualified with the database name.
#
# To create a temporary table, you must have the CREATE_TEMPORARY_TABLES privilege.
#
# After a session has created a temporary table, the server performs no further
# privilege checks on the table.
#
# The creating session can perform any operation on the table, such as DROP_TABLE,
# INSERT, UPDATE or SELECT.
#
# One implication of this behavior is that a session can manipulate its temporary table
# even if the current user has no privilege to create them.
#
# Suppose that hte current user does not have the CREATE_TEMPORARY_TABLES privilege
# but is able to execute a definer-context stored procedure that executes with the
# privileges of a user who does have CREATE_TEMPORARY_TABLES and that creates a 
# temporary table.
#
# While the procedure executes, the session uses the privileges of the defining user.
#
# After hte procedure returns, the effective privileges revert to those of the current
# user, which can still see the temporary table and perform any operation on it.
#
# YOu cannot use CREATE TEMPORARY TABLE --- LIKE to create an empty table based on the
# definition of a table that resides in teh mysql tablespace, InnoDB system tablespace
# (innodb_system), or a general tablespace.
#
# The tablespace definition for such a table includes a TABLESPACE attribute that defines
# the tablespace where the table resides, and the aformentioned tablespaces do not support
# temporary tables.
#
# To create a temporary table based on the definition of such a table, use this syntax instead:
#
# 		CREATE TEMPORARY TABLE new_tbl SELECT * FROM orig_tbl LIMIT 0;
#
# NOTE:
#
# 		Support for TABLESPACE = innodb_file_per_table and TABLESPACE = innodb_temporary clauses
# 		with CREATE_TEMPORARY_TABLE is deprecated as of MysQL 8.0.13.
#
# 13.1.20.4 CREATE TABLE --- LIKE SYNTAX
#
# Use CREATE TABLE --- LIKE to create an empty table based on the definition
# of another table, including any column attributes and indexes defined in the
# original table:
#
# 		CREATE TABLE new_tbl LIKE orig_tbl;
#
# The copy is created using the same version of the table storage format as the 
# original table.
#
# The SELECT privilege is required on the original table
#
# LIKE works only for base tables, not for views.
#
# IMPORTANT:
#
# 		You cannot execute CREATE TABLE or CREATE TABLE --- LIKE while a LOCK_TABLES statement is in effect.
#
# 		CREATE_TABLE_---_LIKE makes the same checks as CREATE_TABLE
#
# 		This means that if the current SQL mode is different from the mode in effect when
# 		the original table was created, the table definition might be considered invalid for
# 		the new mode and the statement will fail.
#
# For CREATE TABLE --- LIKE, the destination table preserves generated column information
# from the original table.
#
# For CREATE TABLE --- LIKE, the destination table expression default values from the original table
#
# CREATE TABLE --- LIKE does not preserve any DATA DIRECTORY or INDEX DIRECTORY table options
# that were specified for the original table, or any foreign key defintiions.
#
# If hte original table is a TEMPORARY table, CREATE TABLE --- LIKE does not preserve TEMPORARY
#
# To create a TEMPORARY destination table, use CREATE TEMPORARY TABLE --- LIKE
#
# Tables created in the mysql tablespace, the InnoDB system tablespace (innodb_system),
# or general tablespaces include a TABLESPACE attribute in the table definition, which
# defines the tablespace where the table resides.
#
# Due to a temporary regression, CREATE TABLE --- LIKE preserves the TABLESPACE attribute
# and creates the table in the defined tablespace regardless of the innodb_file_per_table
# setting.
#
# To avoid the TABLESPACE attribute when creating an empty table based on the definition
# of such a table, use this syntax instead:
#
# 		CREATE TABLE new_tbl SELECT * FROM orig_tbl LIMIT 0;
#
# 13.1.20.5 CREATE TABLE --- SELECT SYNTAX
#
# You can create one table from another by adding a SELECT statement at the end
# of the CREATE_TABLE statement:
#
# 		CREATE TABLE new_tbl [AS] SELECT * FROM orig_tbl;
#
# MySQL creates new columns for all elements in the SELECT. For example:
#
# 		CREATE TABLE test (a INT NOT NULL AUTO_INCREMENT,
# 					PRIMARY KEY (a), KEY(b))
# 					ENGINE=MyISAM SELECT b,c FROM test2;
#
# This creates a MyISAM table with three columns, a,b and c.
#
# The ENGINE option is part of the CREATE_TABLE statement, and should
# not be used following the SELECT; This would result in syntax error.
#
# THe same is true for other CREATE_TABLE options such as CHARSET.
#
# Notice that the columns from the SELECT statements are appended to the right
# side of the table, not overlapped onto it.
#
# Take the following example:
#
# 		SELECT * FROM foo;
# 		+----+
# 		| n  |
# 		+----+
# 		| 1  |
# 		+----+
#
# 		CREATE TABLE bar (m INT) SELECT n FROM foo;
# 		Query OK, 1 row affected (0.02 sec)
# 		Records: 1 Duplicates: 0 Warnings: 0
#
# 		SELECT * FROM bar;
# 		+--------+-------+
# 		| m 		| n 	  |
# 		+--------+-------+
# 		| NULL   | 1 	  |
# 		+--------+-------+
# 		1 row in set (0.00 sec)
#
# For each row in table foo, a row is inserted in bar with the value from foo
# and default values for the new columns.
#
# In a table resulting from CREATE_TABLE_---_SELECT, columns named only in the
# CREATE_TABLE part come first.
#
# Columns named in both parts or only in the SELECT part come after that.
#
# The data type of SELECT columns can be overridden by also specifying
# the column in the CREATE_TABLE part
#
# If any errors occur while copying the data to the table, it is automatically
# dropped and not created.
#
# You can precede the SELECT by IGNORE or REPLACE to indicate how to handle rows
# that duplicate unique key values.
#
# With IGNORE, rows that duplicate an existing row on a unqiue key value are discarded.
#
# With REPLACE, new rows replace rows that have the same unique key value.
#
# If neither IGNORE nor REPLACE is specified, duplicate unique key values result
# in an error.
#
# For more information, see COMPARISON OF THE IGNORE KEYWORD AND STRICT SQL MODE.
#
# Because the ordering of the rows in the underlying SELECT statements cannot always
# be determined, CREATE TABLE --- IGNORE SELECT and CREATE TABLE --- REPLACE SELECT
# statements are flagged as unsafe for statement-based replication.
#
# Such statements produce a warning in the error log when using statement-based mode
# and are written to the binary log using the row-based format when using MIXED mode.
#
# See also SECTION 17.2.1.1, "ADVANTAGES AND DISADAVANTAGES OF STATEMENT-BASED AND ROW-BASED REPLICATION"
#
# CREATE_TABLE_---_SELECT does not automatically create any indexes for you.
#
# This is done intentionally to make the statement as flexible as possible.
#
# If you want to have indexes in the created table, you should specify these before
# the SELECT statement:
#
# 		CREATE TABLE bar (UNIQUE (n)) SELECT n FROM foo;
#
# For CREATE TABLE --- SELECT, the destination table does not preserve information about
# whether columns in the selected-from table are generated columns.
#
# The SELECT part of the statement cannot assign values to generated columns in the destination table.
#
# For CREATE TABLE --- SELECT, the destination table does preserve expression default values
# from the original table.
#
# Some conversion of data types might occur. For example, the AUTO_INCREMENT attribute is not
# preserved, and VARCHAR columns can become CHAR columns.
#
# Retrained attributes are NULL (or NOT NULL) and, for those columns that have them,
# CHARACTER SET, COLLATION, COMMENT, and the DEFAULT clause.
#
# When creating a table with CREATE_TABLE_---_SELECT, make sure to alias any function
# calls or expressions in the query.
#
# If you do not, the CREATE statement might fail or result in undesirable column names.
#
# CREATE TABLE artists_and_works
# 		SELECT artist.name, COUNT(work.artist_id) AS number_of_works
# 		FROM artist LEFT JOIN work ON artist.id = work.artist_id
# 		GROUP BY artist.id;
#
# You can also explicitly specify the data type for a column in the created table:
#
# 		CREATE TABLE foo (a TINYINT NOT NULL) SELECT b+1 AS a FROM bar;
#
# For CREATE_TABLE_---_SELECT, if IF NOT EXISTS is given and the target table exists,
# nothing is inserted into the destination table, and the statement is not logged.
#
# To ensure that the binary log can be used to re-create the original tables, MySQL
# does not permit concurrent inserts during CREATE_TABLE_---_SELECT
#
# You cannot use FOR UPDATE as part of the SELECT in a statement such as 
# CREATE_TABLE_new_table_SELECT_---_FROM_old_table_---
#
# Attempting to do so, causes the statement to fail.
#
# 13.1.20.6 USING FOREIGN KEY CONSTRAINTS
#
# MySQL supports foreign keys, which let you cross-reference related data across
# tables, and foreign key constraints, which help keep this spread-out data consistent.
#
# The essential syntax for a foreign key constraint definition in a CREATE_TABLE or
# ALTER_TABLE statement looks like this:
#
# 		[CONSTRAINT [symbol]] FOREIGN KEY
# 			[index_name] (col_name, ---)
# 			REFERENCES tbl_name (col_name, ---)
# 			[ON DELETE reference_option]
# 			[ON UPDATE reference_option]
# 		
# 		reference_option:
# 			RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
#
# index_name represents a foreign key ID.
#
# The index_name value is ignored if there is already an explicitly defined index
# on the child table that  can support the foreign key.
#
# Otherwise, MySQL implicitly creates a foreign key index that is named according
# to the following rules:
#
# 		) If defined, the CONSTRAINT symbol value is used. Otherwise, the FOREIGN KEY index_name value is used
#
# 		) If neither a CONSTRAINT symbol or FOREIGN KEY index_name is defined, the foreign key index name is generated
# 			using the name of the referencing foreign key column.
#
# The FOREIGN KEY index_name value must be unique in the database.
#
# Foreign keys definitions are subject to the following conditions:
#
# 		) Foreign key relationships involve a parent table that holds the central data values,
# 			and a child table with identical values pointing back to its parent.
#
# 			The FOREIGN KEY clause is specified in the child table.
#
# 			The parent and child tables must use the same storage engine.
#
# 			They must not be TEMPORARY tables.
#
# 			In MySQL 8.0, creation of a foreign key constraint requires the REFERENCES privilege
# 			for the parent table
#
# 		) Corresponding columns in the foreign key and the referenced key must have similar data types.
#
# 			The size and sign of integer types must be the same. The length of string types need
# 			not be the same.
#
# 			For nonbinary (character) string columns, the character set and collation must be the same.
#
# 		) When foreign_key_checks is enabled, which is the default setting, character set conversion is not
# 			permitted on tables that include a character string column used in a foreign key constraint.
#
# 			The workaround is described in SECTION 13.1.9, "ALTER TABLE SYNTAX"
#
# 		) MySQL requires indexes on foreign keys and referenced keys so that foreign key checks can be fast
#  		and not require a table scan.
#
# 			In the referencing table, there must be an index where the foreign key columns are listed as
# 			the first columns in the same order.
#
# 			Such an index is created on the referencing table automatically if it does not exist.
#
# 			This index might be silently dropped later, if you create another index that can be used to enforce
# 			the foreign key constraint.
#
# 			index_name, if given, is used as described previously.
#
# 		) InnoDB permits a foreign key to reference any column or group of columns.
#
# 			However, in the reference table, there must be an index where the referenced
# 			columns are listed as the first columns in the same order.
#
# 			NDB requires an explicit unique key (or primary key) on any column referenced as a foreign key.
#
# 		) Index prefixes on foreign key columns are not supported.
#
# 			One consequence of this is that BLOB and TEXT columns cannot be included in a foreign key because
# 			indexes on those columns must always include a prefix length.
#
# 		) If the CONSTRAINT symbol clause is given, the symbol value, if used, must be unique in the database.
#
# 			A duplicate symbol will result in an error similar to: 
#
# 				ERROR 1022 (2300): Can't write; duplicate key in table '#sql- 464_1'
#
# 			If the clause is not given, or a symbol is not included following the CONSTRAINT keyword,
# 			a name for the constraint is created automatically.
#
# 		) InnoDB does not currently support foreign keys for tables with user-defined partitioning.
#
# 			This includes both parent and child tables.
#
# 			This restriction does not apply for NDB tables that are partitioned by KEY or LINEAR KEY
# 			(the only user partitioning types supported by the NDB storage engine);
#
# 			these may have foreign key references or be the targets of such references.
#
# 		) For NDB tables, ON UPDATE CASCADE is not supported where the reference is to be the parent
# 			table's primary key.
#
# Additional aspects of FOREIGN KEY constraint usage are described under the following topics in this section:
#
# 		) REFERENTIAL ACTIONS
#
# 		) EXAMPLES OF FOREIGN KEY CLAUSES
#
# 		) ADDING FOREIGN KEYS
#
# 		) DROPPING FOREIGN KEYS
#
# 		) FOREIGN KEYS AND OTHER MYSQL STATEMENTS
#
# 		) FOREIGN KEYS AND THE ANSI/ISO SQL STANDARD
#
# 		) FOREIGN KEY METADATA 
#
# 		) FOREIGN KEY ERRORS
#
# REFERENTIAL ACTIONS
#
# This section describes how foreign keys help guarantee referential integrity.
#
# For storage engines supporting foreign keys, MySQL rejects any INSERT or UPDATE operation that
# attempts to create a foreign key value in a child  table if there is not a matching candidate
# key value in the parent table.
#
# When an UPDATE or DELETE operation affects a key value in the parent table that has matching
# rows in the child table, the result depends on the referential action specified using
# ON UPDATE and ON DELETE subclauses of the FOREIGN KEY clause.
#
# MySQL supports five options regarding the action to be taken, listed here:
#
# 		) CASCADE: Delete or update the row from the parent table, and automatically delete or update
# 			the matching rows in the child table.
#
# 			Both ON DELETE CASCADE and ON UPDATE CASCADE are supported.
#
# 			Between two tables, do not define several ON UPDATE CASCADE clauses that act
# 			on the same column in the parent table or in the child table.
#
# 			If a FOREIGN KEY clause is defined on both tables in a foreign key relationship,
# 			making both tables a parent and child, an ON UPDATE CASCADE or ON DELETE CASCADE
# 			subclause defined for one FOREIGN KEY clause must be defined for the other in order
# 			for cascading operations to succeed.
#
# 			If an ON UPDATE CASCADE or ON DELETE CASCADE subclause is only defined for one 
# 			FOREIGN KEY clause, cascading operations fail with an error.
#
# 			NOTE:
#
# 				Cascaded foreign key actions do not active triggers
#
# 		) SET NULL:
#
# 			Delete or update the row from the parent table, and set the foreign key column
# 			or columns in the child table to NULL.
#
# 			Both ON DELETE SET NULL and ON UPDATE SET NULL clauses are supported.
#
# 			If you specify a SET NULL action, make sure that you have not declared the columns
# 			in the child table as NOT NULL
#
# 		) RESTRICT:
#
# 			Rejects the delete or update operation for the parent table.
#
# 			Specifying RESTRICT (or NO ACTION) is the same as omitting the ON DELETE
# 			or ON UPDATE clause.
#
# 		) NO ACTION:
#
# 			A keyword from standard SQL. In MySQL, equivalent to RESTRICT.
#
# 			The MySQL Server rejects the delete or update operation for the
# 			parent table if there is a related foreign key value in the referenced table.
#
# 			Some database systems have deferred checks, and NO ACTION is a deferred check.
#
# 			In MySQL, foreign key constraints are checked immediately, so NO ACTION is the same
# 			as RESTRICT.
#
# 		) SET DEFAULT:
#
# 			This action is recognized by the MySQL parser, but both InnoDB and NDB reject table
# 			defintions containing ON DELETE SET DEFAULT or ON UPDATE SET DEFAULT clauses.
#
# For an ON DELETE or ON UPDATE that is not specified, the default action is always RESTRICT.
#
# MySQL supports foreign key references between one column and another within a table.
#
# (A column cannot have a foreign key reference to itself)
#
# In these cases, "child table records" really refers to dependent records within the
# same table.
#
# A foreign key constraint on a stored generated column cannot use ON UPDATE CASCADE,
# ON DELETE SET NULL, ON UPDATE SET NULL, ON DELETE SET DEFAULT or ON UPDATE SET DEFAULT.
#
# A foreign key constraint cannot reference a virtual generated column.
#
# For InnoDB restrictions related to foreign keys and generated columns, see
# SECTION 15.6.1.5, "InnoDB AND FOREIGN KEY CONSTRAINTS"
#
# EXAMPLES OF FOREIGN KEY CLAUSES
#
# Here is a simple example that relates parent and child tables through a single-column
# foreign key:
#
# 		CREATE TABLE parent (
# 			id INT NOT NULL,
# 			PRIMARY KEY (id)
# 		) ENGINE=INNODB;
#
# 		CREATE TABLE child (
# 			id INT,
# 			parent_id INT,
# 			INDEX par_ind (parent_id),
# 			FOREIGN KEY (parent_id)
# 				REFERENCES parent(id)
# 				ON DELETE CASCADE
# 		) ENGINE=INNODB;
#
# A more complex example in which a product_order table has foreign keys for two other tables.
#
# One foreign key references a two-column index in the product table.
#
# The other references a single-column index in the customer table:
#
# 		CREATE TABLE product (
# 			category INT NOT NULL, id INT NOT NULL,
# 			price DECIMAL,
# 			PRIMARY KEY(category, id)
# 		) ENGINE=INNODB;
#
# 		CREATE TABLE customer (
# 			id INT NOT NULL,
# 			PRIMARY KEY (id)
# 		) ENGINE=INNODB;
#
# 		CREATE TABLE product_order (
# 			no INT NOT NULL AUTO_INCREMENT,
# 			product_category INT NOT NULL,
# 			product_id INT NOT NULL,
# 			customer_id INT NOT NULL,
#
# 			PRIMARY KEY(no),
# 			INDEX (product_category, product_id),
# 			INDEX (customer_id),
#
# 			FOREIGN KEY (product_category, product_id)
# 				REFERENCES product(category, id)
# 				ON UPDATE CASCADE ON DELETE RESTRICT,
#
# 			FOREIGN KEY (customer_id)
# 				REFERENCES customer(id)
# 		) 	ENGINE=INNODB;
#
# ADDING FOREIGN KEYS
#
# You can add a new foreign key constraint to an existing table by using
# ALTER_TABLE
#
# The syntax relating to foreign keys for this statement is shown here:
#
# 		ALTER TABLE tbl_name
# 			ADD [CONSTRAINT [symbol]] FOREIGN KEY
# 			[index_name] (col_name, ---)
# 			REFERENCES tbl_name (col_name,---)
# 			[ON DELETE reference_option]
# 			[ON UPDATE reference_option]
#
# The foreign key can be self referential (referring to the same table)
#
# When you add a foreign key constraint to a table using ALTER_TABLE,
# remember to create the required indexes first.
#
# DROPPING FOREIGN KEYS
#
# You can also use ALTER_TABLE to drop foreign keys, using the syntax shown here:
#
# 		ALTER TABLE tbl_name DROP FOREIGN KEY fk_symbol;
#
# If the FOREIGN KEY clause included a CONSTRAINT name when you created the foreign key,
# you can refer to that name to drop the foreign key.
#
# Otherwise, the fk_symbol value is generated internally when the foreign key is created.
#
# To find out the symbol value when you want to drop a foreign key, use a SHOW_CREATE_TABLE
# statement, as shown here:
#
# 		SHOW CREATE TABLE ibtest11c\G
# 		************************** 1. row ******************************
# 						Table: ibtest11c
# 			Create Table  : CREATE TABLE `ibtest11c` (
# 				`A` int(11) NOT NULL auto_increment,
# 				`D` int(11) NOT NULL default '0',
# 				`B` varchar(200) NOT NULL default '',
# 				`C` varchar(175) default NULL,
# 				PRIMARY KEY (`A`, `D`, `B`),
# 				KEY `B` (`B`,`C`),
# 				KEY `C` (`C`),
# 				CONSTRAINT `0_38775` FOREIGN KEY (`A`, `D`)
# 			REFERENCES `ibtest11a` (`A`, `D`)
# 			ON DELETE CASCADE ON UPDATE CASCADE,
# 				CONSTRAINT `0_38776` FOREIGN KEY (`B`, `C`)
# 			REFERENCES `ibtest11a` (`B`, `C`)
# 			ON DELETE CASCADE ON UPDATE CASCADE
# 			) ENGINE=INNODB CHARSET=utf8mb4
# 			1 row in set (0.01 sec)
#
# 			ALTER TABLE ibtest11c DROP FOREIGN KEY `0_38775`;
#
# Adding and dropping a foreign key in the same ALTER_TABLE statement is supported for
# ALTER_TABLE_---_ALGORITHM=INPLACE but is unsupported for ALTER_TABLE_---_ALGORITHM=COPY
#
# In MySQL 8.0, the server prohibits changes to foreign key columns with the potential
# to cause loss of referential integrity.
#
# A workaround is to use ALTER_TABLE_---_DROP_FOREIGN_KEY before changing the column
# defintion and ALTER_TABLE_---_ADD_FOREIGN_KEY afteward
#
# FOREIGN KEYS AND OTHER MYSQL STATEMENTS
#
# Table and column identifiers in a FOREIGN KEY --- REFERENCES --- clause can be quoted
# within backticks (`)
#
# Alternatively, double quotation marks (") can be used if the ANSI_QUOTES SQL mode is enabled.
#
# The setting of the lower_case_table_names system variable is also taken into account.
#
# You can view a child table's foreign key definitions as part of the output of the
# SHOW_CREATE_TABLE statement:
#
# 		SHOW CREATE TABLE tbl_name;
#
# You can also obtain information about foreign keys by querying the INFORMATION_SCHEMA.KEY_COLUMN_USAGE table
#
# You can find information about foreign keys used by InnoDB tables in the INNODB_FOREIGN and
# INNODB_FOREIGN_COLS tables, also in the INFORMATION_SCHEMA database.
#
# mysqldump produces correct defintiions of tables in the dump file, including the foreign keys for child tables.
#
# TO make it easier to reload dump files that have foreign key relationships, mysqldump automatically
# includes a statement in the dump output to set foreign_key_checks to 0
#
# This avoids problems with tables having to be reloaded in a particular order when the dump is
# reloaded.
#
# It is also possible to set this variable manually:
#
# 		SET foreign_key_checks = 0;
# 		SOURCE dump_file_name;
# 		SET foreign_key_checks = 1;
#
# This enables you to import the tables in any order if the dump file contains tables
# that are not correctly ordered for foreign keys.
#
# It also speeds up the import operation.
#
# Setting foreign_key_checks to 0 can also be useful for ignoring foreign key constraints
# during LOAD_DATA and ALTER_TABLE operations.
#
# However, even if foreign_key_checks = 0, MySQL does not permit the creation of a foreign key
# constraint where a column references a nonmatching column type.
#
# ALso, if a table has foreign key constraints, ALTER_TABLE cannot be used to alter the table
# to use another storage engine.
#
# To change the storage engine, you must drop any foreign key constarints first.
#
# You cannot issue DROP_TABLE for a table that is referenced by a FOREIGN KEY constraint,
# unless you do SET foreign_key_checks = 0
#
# When you drop a table, any constraints that were defined in the statement used to create
# that table are also dropped.
#
# If you re-create a table that was dropped, it must have a definition that conforms to
# the foreign key constraints referencing it.
#
# It must have the correct column names and types, and it must have indexes on the referenced
# keys, as stated earlier.
#
# If these are not satisfied, MySQL returns Error 1005 and refers to Error 150 in the error message,
# which means that a foreign key constraint was not correctly formed.
#
# SImilarly, if an ALTER_TABLE fails due to Error 150, this means that a foreign key definition
# would be incorrectly formed for the altered table
#
# For InnoDB tables, you can obtain a detailed explanation of the most recent InnoDB foreign key
# error in the MySQL Server, by checking the output of SHOW_ENGINE_INNODB_STATUS
#
# MySQL extends metadata locks, as necessary, to tables that are related by a foreign key constraint.
#
# Extending metadata locks prevents conflicting DML and DDL operations from executing concurrently
# on related tables.
#
# This feature also enables updates to foreign key metadata when a parent table is modified.
#
# In earlier MysQl releases, foreign key metadata, which is owned by the child table, could not
# be updated safely.
#
# If a table is locked explicitly with LOCK_TABLES, any tables related by a foreign key constraint
# are opened and locked implicitly.
#
# For foreign key checks, a shared read-only lock (LOCK_TABLES_READ) is taken on related tables.
#
# For cascading updates, a shared-nothing write lock (LOCK_TABLES_WRITE) is taken on related
# tables that are involved in the operation
#
# FOREIGN KEYS AND THE ANSI/ISO SQL STANDARD
#
# For users familiar with the ANSI/ISO SQL Standard, please note htat no storage engine, including
# innoDB, recognizes or enforces the MATCH clause used in referential-integrity constraint defintiions.
#
# Use of an explicit MATCH clause will not have the specified effect, and also causes ON DELETE
# and ON UPDATE clauses to be ignored.
#
# For these reasons, specifying MATCH should be avoided
#
# The MATCH clause in the SQL standard controls how NULL values in a composite (multiple-column)
# foreign key are handled when comparing to a primary key
#
# MySQL essentialy implements the semantics defined by MATCH SIMPLE, which permit a foreign key
# to be all or partially NULL
#
# In that case, the (child table) row containing such a foreign key is permitted to be inserted,
# and does not match any row in the referenced (parent) table
#
# It is possible to implement other semantics using triggers.
#
# Additionally, MySQL requires that the referenced columns be indexed for performance reasons.
#
# However, the system does not enforce a requirement that the referenced columns be UNIQUE
# or be declared NOT NULL
#
# The handling of foreign key references to nonunique keys or keys that contain NULL values
# is not well defined for operations such as UPDATE or DELETE CASCADE
#
# You are advised to use foreign keys that reference only UNIQUE (including PRIMARY)
# and NOT NULL keys.
#
# Furthermore, MySQL parses but ignores "inline REFERENCES specifications" (as defined in the
# SQL standard) where the references are defined as part of the column specification.
#
# MySQL accepts REFERENCES clauses only when specified as part of a separate FOREIGN KEY
# specification.
#
# For storage engines that do not support foreign keys (such as MyISAM), MySQL Server
# parses and ignores foreign key specifications.
#
# FOREIGN KEY METADATA
#
# The INFORMATION_SCHEMA.KEY_COLUMN_USAGE table identifies the key columns that have constraints.
#
# Metadata specific to InnoDB foreign keys is found in the INNODB_SYS_FOREIGN and INNODB_SYS_FOREIGN_COLS
# tables
#
# FOREIGN KEY ERRORS
#
# In the event of a foreign key error involving InnoDB tables (usually Error 150 in the MySQL Server),
# information about the most recent InnoDB foreign key error can be obtained by checking
# SHOW_ENGINE_INNODB_STATUS output.
#
# 	WARNING:
#
# 		If a user has table-level privileges for all parent tables, ER_NO_REFERENCED_ROW_2 and
# 		ER_ROW_IS_REFERENCED_2 error messages for foreign key operations expose information
# 		about parent tables.
#
# 		If a user does not have table-level privileges for all parent tables, more generic
# 		eror messages are displayed instead (ER_NO_REFERENCED_ROW and ER_ROW_IS_REFERENCED)
#
# 		An exception is that, for stored programs defiend to execute with DEFINER privileges,
# 		the user against which privileges are assessed is the user in the program DEFINER clause,
# 		not the invoking user.
#
# 		If that user has table-level parent table privileges, parent table informaiton is
# 		still displayed.
#
# 		In this case, it is the responsibility of the stored program creator to hide
# 		information by including appropriate condition handlers.
#
# 13.1.20.7 SILENT COLUMN SPECIFICATION CHANGES
#
# In some cases, MySQL silently changes column specifications from those given in a 
# CREATE_TABLE or ALTER_TABLE statement.
#
# These might be changes to a data type, to attributes associated with a data type,
# or to an index specification.
#
# ALl changes are subject to the internal row-size limit of 65,535 bytes, which may
# cause some attempts at data type changes to fail.
#
# See SECTION C.10.4, "LIMITS ON TABLE COLUMN COUNT AND ROW SIZE"
#
# 		) Columns that are part of a PRIMARY KEY are made NOT NULL even if not declared that way
#
# 		) Trailing spaces are automatically deleted from ENUM and SET member values when the table is created.
#
# 		) MySQL maps certain data types used by other SQL database vendors to MySQL types.
#
# 			See SECTION 11.10, "USING DATA TYPES FROM OTHER DATABASE ENGINES"
#
# 		) If you include a USING clause to specify an index type that is not permitted for a given storage
# 			engine, but there is another index type available that the engine can use without affecting
# 			query results, the engine uses the available type.
#
# 		) If strict SQL mode is not enabled, a VARCHAR column with a length specification greater than
# 			65535 is converted to TEXT, and a VARBINARY column with a length specification greater than
# 			65535 is converted to BLOB.
#
# 			Otherwise, an error occurs in either of these cases
#
# 		) Specifying the CHARACTER SET binary attribute for a character data type causes the column to be
# 			created as the corresponding binary data type:
#
# 				CHAR becomes BINARY, VARCHAR becomes VARBINARY, and TEXT becomes BLOB
#
# 			For the ENUM and SET data types, this does not occur; they are created as declared.
#
# 			Suppose that you specify a table using this definition:
#
# 				CREATE TABLE t
# 				(
# 					c1 VARCHAR(10) CHARACTER SET binary,
# 					c2 TEXT CHARACTER SET binary,
# 					c3 ENUM('a', 'b', 'c') CHARACTER SET binary
# 				);
#
# 			The resulting table has this definition:
#
# 				CREATE TABLE t
# 				(
# 					c1 VARBINARY(10),
# 					c2 BLOB,
# 					c3 ENUM('a', 'b', 'c') CHARACTER SET binary
# 				);
#
# 			To see whether MySQL uses a data type other than the one you specified, issue a DESCRIBE
# 			or SHOW_CREATE_TABLE statement after creating or altering the table.
#
# 			Certain other data type changes can occur if you compress a table using myisampack.
#
# 			See SECTION 16.2.3.3, "COMPRESSED TABLE CHARACTERISTICS"
#
# 13.1.20.8 CREATE TABLE AND GENERATED COLUMNS
#
# CREATE_TABLE supports the specification of generated columns.
#
# Values of a generated column are computed from an expression included in the column definition.
#
# Generated columns are also supported by the NDB storage engine.
#
# The following simple example shows a table that stores the lengths of the sides of right triangles
# in the sidea and sideb columns, and computes hte length of the hypotenuse in sidec
# (the square root of the sums of the squares of the other sides):
#
# 		CREATE TABLE triangle (
# 			sidea DOUBLE,
# 			sideb DOUBLE,
# 			sidec DOUBLE AS (SQRT(sidea * sidea + sideb * sideb))
# 		);
# 		INSERT INTO triangle (sidea, sideb) VALUES(1,1), (3,4), (6,8);
#
# Selecting from the table yields this result:
#
# 		SELECT * FROM triangle;
# 		+-----------+-------------+-----------------------------+
# 		| sidea     | sideb 		  | sidec 							  |
# 		+-----------+-------------+-----------------------------+
# 		| 1 			| 1 			  | 1.4142135623730951 			  |
# 		| 3 		  	| 4 			  | 5 								  |
# 		| 6 			| 8 			  | 10 								  |
# 		+-----------+-------------+-----------------------------+
#
# ANy application that uses the triangle table has access to the hypotenuse values without
# having to specify the expression that calculates them.
#
# Generated column definitions have this syntax:
#
# 		col_name data_type [GENERATED ALWAYS] AS (expression)
# 			[VIRTUAL | STORED] [NOT NULL | NULL]
# 			[UNIQUE [KEY]] [[PRIMARY] KEY]
# 			[COMMENT 'string']
#
# AS (expression) indicates that the column is genrated and defines the expression
# used to compute column values.
#
# AS may be preceded by GENERATED ALWAYS to make the generated nature of the column
# more explicit.
#
# Constructs that are permitted or prohibited in the expression are discussed later.
#
# The VIRTUAL or STORED keyword indicates how column values are stored, which has implications
# for column use:
#
# 		) VIRTUAL: Column values are not stored, but are evaluated when rows are read, immediately
# 			after any BEFORE triggers.
#
# 			A virtual column takes no storage
#
# 			InnoDB supports secondary indexes on virtual columns.
#
# 			See SECTION 13.1.20.9, "SECONDARY INDEXES AND GENERATED COLUMNS"
#
# 		) STORED: Column values are evaluated and stored when rows are inserted or updated.
#
# 			A stored column does require storage space and can be indexed.
#
# The default is VIRTUAL if neither keyword is specified.
#
# It is permitted to mix VIRTUAL and STORED columns within a table.
#
# Other attributes may be given to indicate whether the column is indexed or can be
# NULL or provide a comment.
#
# Genrated column expressions must adhere to hte following rules.
#
# An error occurs if an expression contains disallowed constructs.
#
# 		) Literals, determinsitic built-in functions, and operators are permitted.
#
# 			A function is determinsitic, if given the same data in tables, multiple
# 			invocations produce the same result, independently of the connected user.
#
# 			Examples of functions that fail this definition:
#
# 				CONNECTION_ID(), CURRENT_USER(), NOW()
#
# 		) Subqueries, parameters, variables, stored functions, and user-defined functions are not permitted.
#
# 		) A generated column definition can refer to other generated columns, but only those occurring
# 			earlier in the table definition.
#
# 			A generated column definition can refer to any base (nongenerated) column in the table
# 			whether its definition occurs earlier or later.
#
# 		) The AUTO_INCREMENT attribute cannot be used in a generated column definition
#
# 		) An AUTO_INCREMENT column cannot be used as a base column in a generated column definition
#
# 		) If expression evaluation causes truncation or provides incorrect input to a function,
# 			the CREATE_TABLE statement terminates with an error and the DDL operation is rejected.
#
# If the expression evaluates to a data type that differs from the declared column type,
# Implicit coercion to the declared type occurs according to the usual MySQL type-conversion
# rules.
#
# See SECTION 12.2, "TYPE CONVERSION IN EXPRESSION EVALUATION"
#
# NOTE:
#
# 		If any component of the expression depends on the SQL mode, different results may
# 		occur for different uses of the table unless the SQL mode is the same during
# 		all uses.
#
# For CREATE_TABLE_---_LIKE, the destination table preserves generated column information from the original table
#
# For CREATE_TABLE_---_SELECT, the destination table does not preserve information about whether columns
# in the selected-from table are generated columns.
#
# The SELECT part of the statement cannot assign values to generated columns in teh destination table
#
# Partitioning by generated columns is permitted. See CREATING PARTITIONED TABLES
#
# A foreign key constraint on a stored generated column cannot use:
#
# 		) ON UPDATE CASCADE
#
# 		) ON DELETE SET NULL
#
# 		) ON UPDATE SET NULL
#
# 		) ON DELETE SET DEFAULT
#
# 		) ON UPDATE SET DEFAULT
#
# A foreign key constraint cannot reference a virtual generated column
#
# For InnoDB restrictions related to foreign keys and generated columns, see SECTION 15.6.1.5, "InnoDB AND FOREIGN KEY CONSTRAINTS"
#
# Triggers cannot use NEW.col_name or use OLD.col_name to refer to generated columns
#
# For INSERT, REPLACE, and UPDATE,, if a generated column is inserted into, replaced, or updated explicitly,
# the only permitted value is DEFAULT
#
# A generated column in a view is considered updatable because it is possible to assign to it
#
# However, if such a column is updated explicitly, the only permitted value is DEFAULT
#
# Generated columns have several use cases, such as these:
#
# 		) Virtual generated columns can be used as a way to simplify and unify queries.
#
# 			A complicated condition can be defined as a generated column and referred 
# 			to from multiple queries on the table to ensure that all of them use exactly
# 			the same condition.
#
# 		) Stored generated columns can be used as a materialized cache for complicated conditions that
# 			are costly to calculate on the fly.
#
# 		) Generated columns can simulate functional indexes; Use a generated column to define a functional
# 			expression and index it.
#
# 			This can be useful for working with columns of types that cannot be indexed directly,
# 			such as JSON columns;
#
# 			See INDEXING A GENERATED COLUMN TO PROVIDE A JSON COLUMN INDEX, for a detailed example 
# 
# 			For stored generated columns, the disadvantage of htis approach is that values are stored twice,
# 			once as the value of the generated column and once in the index.
#
# 		) If a generated column is indexed, the optimizer recognizes query expressions that match the column
# 			definition and uses indexes from the column as appropriate during query execution, even if a query
# 			does not refer to the column directly by  name.
#
# 			For details, see SECTION 8.3.11, "OPTIMIZER USE OF GENERATED COLUMN INDEXES"
#
# Example:
#
# 		Suppose that a table t1 contains first_name and last_name columns and that applications
# 		frequently construct the full name using an expression like this:
#
# 			SELECT CONCAT(first_name, ' ',last_name) AS full_name FROM t1;
#
# 		One way to avoid writing out the expression is to create a view v1 on t1, which simplifies
# 		applications by enabling them to select full_name directly without using an expression:
#
# 			CREATE VIEW v1 AS
# 			SELECT *, CONCAT(first_name,' ',last_name) AS full_name FROM t1;
#
# 			SELECT full_name FROM v1;
#
# 		A generated column also enables applications to select full_name directly
# 		without the need to define a view:
#
# 			CREATE TABLE t1 (
# 				first_name VARCHAR(10),
# 				last_name VARCHAR(10),
# 				full_name VARCHAR(255) AS (CONCAT(first_name,' ',last_name))
# 			);
#
# 			SELECT full_name FROM t1;
#
# 13.1.20.9 SECONDARY INDEXES AND GENERATED COLUMNS
#
# InnoDB supports secondary indexes on virtual generated columns.
#
# Other index types are not supported. A secondary index defined on a virtual column
# is sometimes referred to as a "virtual index"
#
# A secondary index may be created on one or more virtual columns or on a combination
# of virtual columns and regular columns or stored generated columns.
#
# Secondary indexes that include virtual columns may be defined as UNIQUE
#
# When a secondary index is created on a virtual generated column, generated column values
# are materialized in the records of the index.
#
# If the index is a covering index (one that includes all the columns retrieved by a query),
# generated column values are retrieved from materialized values in the index structure
# instead of computed "on the fly"
#
# There are additional write costs to consider when using a secondary index on a virtual column
# due to computation performed when materializing virtual column values in secondary
# secondary index records during INSERT and UPDATE operations.
#
# Even with additional write costs, secondary indexes on virtual columns may be preferable
# to generated stored columns, which are materialized in the clustered index, resulting
# in larger tables that require more disk space and memory.
#
# If a secondary index is not defined on a virtual column, there are additional costs for
# reads, as virtual column values must be computed each time the column's row is examined.
#
# Values of an indexed virtual column are MVCC-logged to avoid unnecessary recomputation of
# generated column values during rollback or during a purge operation.
#
# The data length of logged values is limited by the index key limit of 767 bytes for
# COMPACT and REDUNDANT row formats, and 3072 bytes for DYNAMIC and COMPRESSED row formats.
#
# Adding or dropping a secondary index on a virtual column is an in-place operation
#
# INDEXING A GENERATED COLUMN TO PROVIDE A JSON COLUMN INDEX
#
# As noted elsewhere, JSON columns cannot be indexed directly
#
# To create an index that references such a column directly, you can define a generated
# column that extracts the information that hsould be indexed, then create an index
# on the generated column, as shown in this example:
#
# 		CREATE TABLE jemp (
# 			c JSON,
# 			g INT GENERATED ALWAYS AS (c->"$.id")),
# 			INDEX i (g)
# 		);
# 		Query OK, 0 rows affected (0.28 sec)
#
# 		INSERT INTO jemp (c) VALUES
# 			('{"id": "1", "name": "Fred"}'), ('{"id": "2", "name": "Wilma"}'),
# 			('{"id": "3", "name": "Barney"}'), ('{"id": "4", "name": "Betty"}');
# 		Query OK, 4 rows affected (0.04 sec)
# 		Records: 4 Duplicates: 0 Warnings: 0
#
# 		SELECT c->>"$.name" AS name
# 			FROM jemp WHERE g > 2;
# 		+-----------+
# 		| name 		|
# 		+-----------+
# 		| Barney 	|
# 		| Betty 	   |
# 		+-----------+
# 		2 rows in set (0.00 sec)
#
# 		EXPLAIN SELECT c->>"$.name" AS name
# 			FROM jemp WHERE g > 2\G
# 		************************ 1. row *******************************
# 						id: 1
# 				select_type: SIMPLE
# 				table  : jemp
# 			partitions: NULL
# 				type   : range
# 		possible_keys: i
# 				key    : i
# 			key_len   : 5
#
# 				ref    : NULL
# 				rows   : 2
# 			filtered  : 100.00
# 			Extra     : Using where
# 	1 row in set, 1 warning (0.00 sec)
#
# SHOW WARNINGS\G
# ************************ 1. row *******************************
# 		Level: Note
# 	Code    : 1003
#  Message : /* select#1 */ select json_unquote(json_extract(`test`.`jemp`.`c`, '$.name'))
# 	AS `name` from `test`.`jemp` where (`test`.`jemp`.`g` > 2)
#  1 row in set (0.00 sec)
#
# (We have wrapped the output from the last statement in this example to fit the viewing area)
#
# When you use EXPLAIN on a SELECT or other SQL statement containing one or more expressions that use
# the -> or ->> operator, these expressions are translated into their equivalents using JSON_EXTRACT()
# and (if needed) JSON_UNQUOTE() instead, as shown here in the output from SHOW_WARNINGS immediately
# following this EXPLAIN statement:
#
# 		EXPLAIN SELECT c->>"$.name"
# 		FROM jemp WHERE g > 2 ORDER BY c->"$.name"\G
# 		*************************** 1. row ***************************
# 					id: 1
# 		select_type: SIMPLE
# 		table      : jemp
# 		partitions : NULL
# 		type       : range
# 		possible_keys: i
# 		key 		  : i
#
# 		key_len    : 5
# 		ref        : NULL
# 		rows       : 2
# 		filtered   : 100.00
# 		Extra      : Using where; Using filesort
# 		1 row in set, 1 warning (0.00 sec)
#
# 		SHOW WARNINGS\G
# 		************************* 1. row *******************************
# 		Level: Note
# 		Code : 1003
# 	  Message: /* select#1 */ select json_unquote(json_extract(`test`.`jemp`.`c`, '$.name'))
# 		AS `c->>"$.name"` from `test`.`jemp` where (`test`.`jemp`.`g` > 2) order by 
# 		json_extract(`test`.`jemp`.`c`,'$.name')
# 		1 row in set (0.00 sec)
#
# See the descriptions of the -> and ->> operators, as well as those of the JSON_EXTRACT() and
# JSON_UNQUOTE() functions, for additional information and examples.
#
# This technique also can be used to provide indexes that indirectly reference columns of other
# types that cannot be indexed directly, such as GEOMETRY columns.
#
# JSON COLUMNS AND INDIRECT INDEXING IN NDB CLUSTER
#
# It is also possible to use indirect indexing of JSON columns in MySQL NDB cluster, subject to the
# following conditions:
#
# 		1. NDB handles a JSON column value internally as a BLOB.
#
# 			This means that any NDB table having one or more JSON columns must have a primary key,
# 			else it cannot be recorded in the binary log.
#
# 		2. The NDB storage engine does not support indexing of virtual columns.
#
# 			Since the default for generated columns is VIRTUAL, you must specify explicitly
# 			the generated column to which to apply the indirect index as STORED.
#
# The CREATE TABLE statement used to create the table jempn shown here is a version of the
# jemp table shown previously, with modifications making it compatible with NDB:
#
# 		CREATE TABLE jempn (
# 			a BIGINT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 			c JSON DEFAULT NULL,
# 			g INT GENERATED ALWAYS AS (c->"$.name") STORED,
# 			INDEX i (g)
# 		) ENGINE=NDB;
#
# We can populate this table using the following INSERT statement:
#
# 		INSERT INTO jempn (a, c) VALUES
# 			(NULL, '{"id": "1", "name": "Fred"}'),
# 			(NULL, '{"id": "2", "name": "Wilma"}'),
# 			(NULL, '{"id": "3", "name": "Barney"}'),
# 			(NULL, '{"id": "4", "name": "Betty"}');
#
# Now NDB can use index i, as shown here:
#
# 		EXPLAIN SELECT c->>"$.name" AS name
# 			FROM jempn WHERE g > 2\G
# 		******************** 1. row *********************************
# 						id: 1
# 				select_type: SIMPLE
# 					table: jempn
# 			partitions : p0,p1
# 					type : range
# 		possible_keys : i
# 					key  : i
# 				key_len : 5
# 					ref  : NULL
# 				   rows : 3
# 			filtered   : 100.00
# 				Extra   : Using where with pushed condition (`test`.`jempn`.`g` > 2)
# 			1 row in set, 1 warning (0.00 sec)
#
# 		SHOW WARNINGS\G
# 		*********************** 1. row ****************************
# 		 	Level: Note
# 			Code : 1003
# 		Message : /* select#1 */ select
# 		json_unquote(json_extract(`test`.`jempn`.`c`,'$.name')) AS `name` from
# 		`test`.`jempn` where (`test`.`jempn`.`g` > 2)
# 		1 row in set (0.00 sec)
#
# You should keep in mind that a stored generated column uses DataMemory,
# and that an index on such a column uses IndexMemory
#
# 13.1.20.10 SETTING NDB_TABLE OPTIONS
#
# In MySQL NDB Cluster, the table comment in a CREATE TABLE or ALTER_TABLE statement
# can also be used to specify an NDB_TABLE option, which consists of one or more name-value
# pairs, separated by commas if need be, following the string NDB_TABLE= 
#
# Complete syntax for names and values syntax is shown here:
#
# 		COMMENT="NDB_TABLE=ndb_table_option[,ndb_table_option[,---]]"
#
# 		ndb_table_option:
# 			NOLOGGING={1|0}
# 		 | READ_BACKUP={1|0}
# 		 | PARTITION_BALANCE={FOR_RP_BY_NODE|FOR_RA_BY_NODE|FOR_RP_BY_LDM
# 									|FOR_RA_BY_LDM|FOR_RA_BY_LDM_X_2
# 									|FOR_RA_BY_LDM_X_3|FOR_RA_BY_LDM_X_4}
# 		 | FULLY_REPLICATED={1|0}
#
# Spaces are not permitted within the quoted string. The string is case-insensitive.
#
# The four NDB table options that can be set as part of a comment in this way are described
# in more detail in the next few paragraphs.
#
# NOLOGGING: Using 1 corresponds to having ndb_table_no_logging enabled, but has no actual effect.
#
# Provided as a placeholder, mostly for completeness of ALTER_TABLE statements
#
# READ_BACKUP: Setting this option to 1 has the same effect as though ndb_read_backup were enabled;
# enables reading from any replica.
#
# You can set READ_BACKUP for an existing table online, using an ALTER TABLE statement similar to
# one of those shown here:
#
# 		ALTER TABLE --- ALGORITHM=INPLACE, COMMENT="NDB_TABLE=READ_BACKUP=1";
#
# 		ALTER TABLE --- ALGORITHM=INPLACE, COMMENT="NDB_TABLE=READ_BACKUP=0";
#
# For more information about the ALGORITHM option for ALTER TABLE, see
# SECTION 22.5.14, "ONLINE OPERATIONS WITH ALTER TABLE IN NDB CLUSTER"
#
# PARTITION_BALANCE: Provides additional control over assignment and placement of partitions.
#
# The following four schemes are supported:
#
# 		1. FOR_RP_BY_NODE: One partition per node
#
# 			Only one LDM on each node stores a primary partition. Each partition is stored
# 			in the same LDM (same ID) on all nodes
#
# 		2. FOR_RA_BY_NODE: One partition per node group
#
# 			Each node stores a single partition, which can be either a primary replica
# 			or a backup replica.
#
# 			Each partition is stored in the same LDM on all nodes.
#
# 		3. FOR_RP_BY_LDM: One partition for each LDM on each node; the default
#
# 			This is the same behavior as prior to MySQL NDB Cluster 7.5.2, except for a slightly
# 			different mapping of partitions to LDMs, starting with LDM 0 and placing one
# 			partition per node group, then moving on to the next LDM.
#
# 			This is the setting used if READ_BACKUP is set to 1
#
# 		4. FOR_RA_BY_LDM: One partition per LDM in each node group
#
# 			These partitions can be primary or backup partitions
#
# 		5. FOR_RA_BY_LDM_X_2: Two partitions per LDM in each node group.
#
# 			These partitions can be primary or backup partitions.
#
# 		6. FOR_RA_BY_LDM_X_3: Three partitions per LDM in each node group.
#
# 			These partitions can be primary or backup partitions
#
# 		7. FOR_RA_BY_LDM_X_4: Four partitions per LDM in each node group.
#
# 			These partitions can be primary or backup partitions
#
# PARTITION_BALANCE is the preferred interface for setting the number of partitions per table.
#
# Using MAX_ROWS to force the number of partitions is deprecated but continues to be supported
# for backwards compatibility; it is subject to removal in a future release of MySQL NDB Cluster.
# (Bug #81759, Bug #23544301)
#
# FULLY_REPLICATED controls whether the table is fully replicated, that is, whether each data node
# has a complete code of the table.
#
# To enable full replication of the table, use FULLY_REPLICATED=1
#
# This setting can also be controlled using the ndb_fully_replicated system variable.
#
# Setting it to ON enables the option by default for all new NDB tables;
# the default is OFF.
#
# The ndb_data_node_neighbour system variable is also used for fully replicated tables,
# to ensure that when a fully replicated table is accessed, we access the data node
# which is local to this MySQL server.
#
# An example of a CREATE TABLE statement using such a comment when creating an NDB table
# is shown here:
#
# 		CREATE TABLE t1 (
# 			c1 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 			c2 VARCHAR(100),
# 			c3 VARCHAR(100) )
# 		ENGINE=NDB
#
# 		COMMENT="NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RP_BY_NODE";
#
# The comment is displayed as part of the output of SHOW_CREATE_TABLE 
#
# The text of the comment is also available from querying the MySQL Information Schema
# TABLES table, as in this example:
#
# 		SELECT TABLE_NAME, TABLE_SCHEMA, TABLE_COMMENT
# 		FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME="t1";
# 		+--------------+------------------+-----------------------------------------------------------+
# 		| TABLE_NAME   | TABLE_SCHEMA     | TABLE_COMMENT 															 |
# 		+--------------+------------------+-----------------------------------------------------------+
# 		| t1 			   | c 					 | NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RP_BY_NODE  |
# 		| t1 			   | d 					 | 																			 |
# 		+--------------+------------------+-----------------------------------------------------------+
# 		2 rows in set (0.00 sec)
#
# This comment syntax is also supported with ALTER_TABLE statements for NDB tables.
#
# Keep in mind that a table comment used with ALTER TABLE replaces any existing comment which
# the table might have.
#
# 		ALTER TABLE t1 COMMENT="NDB_TABLE=PARTTION_BALANCE=FOR_RA_BY_NODE";
# 		Query OK, 0 rows affected (0.40 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
# 		SELECT TABLE_NAME, TABLE_SCHEMA, TABLE_COMMENT
# 		FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME="t1";
# 		+--------------+-------------------------+------------------------------------------------------+
# 		| TABLE_NAME   | TABLE_SCHEMA 			  | TABLE_COMMENT 													|
# 		+--------------+-------------------------+------------------------------------------------------+
# 		| t1 				| c 							  | NDB_TABLE=PARTITION_BALANCE=FOR_RA_BY_NODE 			   |
# 		| t1 				| d 							  | 																		|
# 		+--------------+-------------------------+------------------------------------------------------+
# 		2 rows in set (0.01 sec)
#
# You can also see the value of the PARTITION_BALANCE option in the output of ndb_desc.ndb_desc also
# shows whether the READ_BACKUP and FULLY_REPLICATED options are set for the table.
#
# See the description of this program for more information.
#
# Because the READ_BACKUP value was not carried over to the new comment set by the ALTER TABLE statement,
# there is no longer a way using SQL to retrieve the value previously set for it.
#
# To keep this from happening, it is suggested that you preserve any such values from the existing comment
# string, like this:
#
# 		SELECT TABLE_NAME, TABLE_SCHEMA, TABLE_COMMENT
# 		FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME="t1";
# 		+---------------+-----------------------+----------------------------------------------------------+
# 		| TABLE_NAME 	 | TABLE_SCHEMA 			 | TABLE_COMMENT 														   |
# 		+---------------+-----------------------+----------------------------------------------------------+
# 		| t1 				 | c 							 | NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RP_BY_NODE |
# 		| t1 				 | d 							 | 																			|
# 		+---------------+-----------------------+----------------------------------------------------------+
# 		2 rows in set (0.00 sec)
#
# 		ALTER TABLE t1 COMMENT="NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RA_BY_NODE";
# 		Query OK, 0 rows affected (1.56 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
# 		SELECT TABLE_NAME, TABLE_SCHEMA, TABLE_COMMENT
# 		FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME="t1";
# 		+----------------+---------------------------+----------------------------------------------------------+
# 		| TABLE_NAME 	  | TABLE_SCHEMA 					| TABLE_COMMENT 														  |
# 		+----------------+---------------------------+----------------------------------------------------------+
# 		| t1 				  | c 								| NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RA_BY_NODE |
# 		| t1 				  | d 								| 																			  |
# 		+----------------+---------------------------+----------------------------------------------------------+
# 		2 rows in set (0.01 sec)
#
# 13.1.21 CREATE TABLESPACE SYNTAX
#
# 		CREATE [UNDO] TABLESPACE tablespace_name
#
# 		InnoDB and NDB:
# 			[ADD DATAFILE 'file_name']
#
# 		InnoDB only:
# 			[FILE_BLOCK_SIZE = value]
# 			[ENCRYPTION [=] {'Y' | 'N'}]
#
# 		NDB only:
# 			USE LOGFILE GROUP logfile_group
# 			[EXTENT_SIZE [=] extent_size]
# 			[INITIAL_SIZE [=] initial_size]
# 			[AUTOEXTEND_SIZE [=] autoextend_size]
# 			[MAX_SIZE [=] max_size]
# 			[NODEGROUP [=] nodegroup_id]
# 			[WAIT]
# 			[COMMENT [=] 'string']
#
# 		InnoDB and NDB:
# 			[ENGINE [=] engine_name]
#
# This statement is used to create a tablespace.
#
# The precise syntax and semantics depend on the storage engine used.
#
# In standard MySQL releases, this is always an InnoDB tablespace.
#
# MySQL NDB Cluster also supports tablespaces using the NDB storage engine.
#
# 		) Considerations for InnoDB
#
# 		) Considerations for NDB Cluster
#
# 		) Options
#
# 		) Notes
#
# 		) InnoDB Examples
#
# 		) NDB Example
#
# CONSIDERATIONS FOR INNODB
#
# CREATE_TABLESPACE syntax is used to create general tablespaces or undo tablespaces.
#
# The UNDO keyword, introduced in MySQL 8.0.14, must be specified to create an undo tablespace.
#
# A general tablespace is a shared tablespace.
#
# It can hold multiple tables, and supports all table row formats.
#
# General tablespaces can be created in a location relative to or independent
# of the data directory.
#
# After creating an InnoDB general tablespace, use CREATE_TABLE_tbl_name_---_TABLESPACE_[=]_tablespace_name
# or ALTER_TABLE_tbl_name_TABLESPACE_[=]_tablespace_name to add tables to the tablespace.
#
# For more information, see SECTION 15.6.3.3, "GENERAL TABLESPACES"
#
# Undo tablespaces contain undo logs.
#
# Undo tablespaces can be created in a chosen location by specifying a fully qualified data file path.
#
# For more information, see SECTION 15.6.3.4, "UNDO TABLESPACES"
#
# CONSIDERATIONS FOR NDB CLUSTER
#
# This statement is used to create a tablespace, which can contain one or more data files, providing
# storage space for NDB Cluster Disk Data tables (see SECTION 22.5.13, "NDB CLUSTER DISK TABLES")
#
# One data file is created and added to the tablespace using this statement.
#
# Additional data files may be added to the tablespace by using the ALTER_TABLESPACE statement
# (see SECTION 13.1.10, "ALTER TABLESPACE SYNTAX")
#
# NOTE:
#
# 		All NDB Cluster Disk Data objects share the same namespace.
#
# 		This means that each Disk Data object must be uniquely named (and not merely each
# 		Disk Data object of a given type)
#
# 		For example, you cannot have a tablespace and a log file group with the same name,
# 		or a tablespace and a data file with the same name.
#
# A log file group of one or more UNDO log files must be assigned to the tablespace to be created
# with the USE LOGFILE GROUP clause.
#
# logfile_group must be an existing log file group created with CREATE_LOGFILE_GROUP
# (see SECTION 13.1.16, "CREATE LOGFILE GROUP SYNTAX")
#
# Multiple tablespaces may use the same log file group for UNDO logging.
#
# When setting EXTENT_SIZE or INITIAL_SIZE, you may optionally follow the number with a 
# one-letter abbreviation for an order of magnitude, similar to those used in my.cnf
#
# Generally, this is one of the letters M (for megabytes) or G (for gigabytes)
#
# INITIAL_SIZE and EXTENT_SIZE qre subject to rounding as follows:
#
# 		) EXTENT_SIZE is rounded up to the nearest whole multiple of 32K
#
# 		) INITIAL_SIZE is rounded down to the nearest whole multiple of 32K; this result is rounded up
# 			to the nearest whole multiple of EXTENT_SIZE (after any rounding)
#
# The rounding just described is done explicitly, and a warning is issued by the MySQL Server
# when any such rounding is performed.
#
# The rounded values are also used by the NDB kernel for calculating INFORMATION_SCHEMA.FILES
# column values and other purposes.
#
# However, to avoid an unexpected result, we suggest that you always use whole multiples of
# 32K in specifying these options.
#
# When CREATE_TABLESPACE is used with ENGINE [=] NDB, a tablespace and associated data file
# are created on each Cluster data node.
#
# You can verify the data files were created and obtain information about them by querying
# the INFORMATION_SCHEMA.FILES table
#
# (See the example later in this section)
#
# (See SECTION 25.10, "THE INFORMATION_SCHEMA FILES TABLE")
#
# OPTIONS
#
# 		) ADD DATAFILE:
#
# 			Defines the name of a tablespace data file.
#
# 			The ADD DATAFILE clause is required when creating undo tablespaces.
# 			Otherwise, it is optional as of MySQL 8.0.14
#
# 			An InnoDB tablespace supports only a single data file, whose name must include
# 			a .ibd extension
#
# 			An NDB Cluster tablespace supports multiple data files which can have any
# 			legal file names; More data files can be added to an NDB Cluster tablespace
# 			following its creation by using an ALTER_TABLESPACE statement.
#
# 			To place a general tablespace data file in a location outside of the data directory,
# 			include a fully qualified path or a path relative to the data directory.
#
# 			Only a fully qualified path is permitted for undo tablespaces.
#
# 			If you do not specify a path, a general tablespace is created in the
# 			data directory.
#
# 			An undo tablespace created without specifying a path is created in the directory
# 			defined by the innodb_undo_directory variable.
#
# 			If the innodb_undo_directory variable is undefined, undo tablespaces are created
# 			in the data directory.
#
# 			Creating a general tablespace in a subdirectory under the data directory is not supported
# 			to avoid conflict with implicitly created file-per-table tablespaces.
#
# 			When creating a general tablespace or undo tablespace outside of the data directory,
# 			the directory must exist and must be known to InnoDB prior to creating the tablespace.
#
# 			To make a directory known to InnoDB, add it to the innodb_directories value or to one
# 			of the variables whose values are appended to the innodb_directories value.
#
# 			innodb_directories is a read-only variable. Configuring it requires restarting the server.
#
# 			The file_name, including any specified path, must be quoted with single or double quotation marks.
#
# 			File names (not counting the file extensions) and directory names must be at least one byte
# 			in length.
#
# 			Zero length file names and dir names are not supported.
#
# 			If the ADD DATAFILE clause is not specified when creating a tablespace, a tablespace data file
# 			with a unique file name is created implicitly.
#
# 			The unique file name is a 128 bit UUID formatted into five groups of hexadecimal numbers
# 			separated by dashes (aaaaaaaa-bbbb-cccc-dddd-eeeeeeee)
#
# 			A file extension is added if required by the storage engine.
#
# 			An .ibd file extension is added for InnoDB general tablespace data files.
#
# 			In a replication environment, the data file name created on the master is not the same
# 			as the data file name created on the slave.
#
# 		) FILE_BLOCK_SIZE:
#
# 			This option - which is specific to InnoDB general tablespaces, and is ignored by NDB -
# 			defines the block size for the tablespace data file.
#
# 			Values can be specified in bytes or kilobytes.
#
# 			For example, an 8 kilobyte file block size can be specified as 8192 or 8K
#
# 			If you do not specify this option, FILE_BLOCK_SIZE defaults to the innodb_page_Size
# 			value.
#
# 			FILE_BLOCK_SIZE is required when you intend to use the tablespace for storing
# 			compressed InnoDB tables (ROW_FORMAT=COMPRESSED)
#
# 			In this case, you must define the tablespace FILE_BLOCK_SIZE when creating the tablespace.
#
#			If FILE_BLOCK_SIZE is equal to the innodb_page_size value, the tablespace can contain only
# 			tables having an uncompressed row format (COMPACT, REDUNDANT and DYNAMIC)
#
# 			Tables with a COMPRESSED row format have a different physical page size than uncompressed tables.
#
# 			Therefore, compressed tables cannot coexist in the same tablespace as uncompressed tables.
#
# 			For a general tablespace to contain compressed tables, FILE_BLOCK_SIZE must be specified,
# 			and the FILE_BLOCK_SIZE value must be a valid compressed page size in relation to the
# 			innodb_page_size value.
#
# 			Also, the physical page size of the compressed table (KEY_BLOCK_SIZE) must be equal
# 			to FILE_BLOCK_SIZE/1024
#
# 			For example, if innodb_page_size=16K, and FILE_BLOCK_SIZE=8K, the KEY_BLOCK_SIZE
# 			of the table must be 8.
#
# 			For more information, see SECTION 15.6.3.3, "GENERAL TABLESPACES"
#
# 		) USE LOGFILE GROUP:
#
# 			Required for NDB, this is the name of a log file group previously created using
# 			CREATE_LOGFILE_GROUP
#
# 			Not supported for InnoDB, where it fails with an error.
#
# 		) EXTENT_SIZE:
#
# 			This option is specific to NDB, and is not supported by InnoDB, where it fails
# 			with an error.
#
# 			EXTENT_SIZE sets the size, in bytes, of the extents used by any files belonging
# 			to the tablespace.
#
# 			The default value is 1M. The minimum size is 32K, and theoretical maximum is
# 			2G, although the practical maximum size depends on a number of factors.
#
# 			In most cases, changing the extent size does not have any measurable effect
# 			on performance, and the default value is recommended for all but the most unusual situations.
#
# 			An extent is a unit of disk space allocation.
#
# 			One extent is filled with as much data as that extent can contain before another extent is used.
#
# 			In theory, up to 65,535 (64K) extents may be used per data file; however, the recommended
# 			maximum is 32,768 (32K)
#
# 			The recommended maximum size for a single data file is 32G - that is, 32K
# 			extents x 1 MB per extent.
#
# 			In addition, once an extent is allocated to a given partition, it cannot be used to store
# 			data from a different partition; an extent cannot store data from more than one partition.
#
# 			This means, for example that a tablespace having a single datafile whose INITIAL_SIZE
# 			(described in the following item) is 256 MB and whose EXTENT_SIZE is 128M has just two extents,
# 			and so can be used to store data from at most two different disk data table partitions.
#
# 			You can see how many extents remain free in a given data file by querying the INFORMATION_SCHEMA.FILES
# 			table, and so derive an estimate for how much space remains free in the file.
#
# 			For further discussion and examples, see SECTION 25.10, "THE INFORMATION_SCHEMA FILES TABLE"
#
# 		) INITIAL_SIZE:
#
# 			This option is specific to NDB, and is not supported by InnoDB, where it fails with an error.
#
# 			The INITIAL_SIZE parameter sets the total size in bytes of the data file that was specific
# 			using ADD DATAFILE.
#
# 			Once this file has been created, its size cannot be changed;
#
# 			However, you can add more data files to the tablespace using ALTER_TABLESPACE_---_ADD_DATAFILE
#
# 			INITIAL_SIZE is optional; its default value is 128MB (134217728)
#
# 			On 32-bit systems, the maximum supported value for INITIAL_SIZE is 4GB (4294967296)
#
# 		) AUTOEXTEND_SIZE:
#
# 			Currently ignored by MySQL; reserved for possible future use.
#
# 			Has no effect in any release of MySQL 8.0 or MySQL NDB Cluster 8.0, regardless
# 			of the storage engine used.
#
# 		) MAX_SIZE:
#
# 			Currently ignored by MySQL;
#
# 			reserved for possible future use. Has no effect in any release of MySQL 8.0 or
# 			MySQL NDB Cluster 8.0, regardless of the storage engine used.
#
# 		) NODEGROUP:
#
# 			Currently ignored by MySQL
#
# 			reserved for possible future use. has no effect in any release of MysQL 8.0 or
# 			MySQL NDB CLuster 8.0, regardless of the storage engine used
#
# 		) WAIT:
#
# 			Currently ignored by MySQL;
#
# 			reserved for possible future use. Has no effect in any release of MySQL 8.0 or
# 			MySQL NDB Cluster 8.0, regardless of the storage engine used.
#
# 		) COMMENT:
#
# 			Currently ignored by MySQL;
#
# 			reserved for possible future use.
#
# 			Has no effect in any release of MySQL 8.0 or MySQL NDB Cluster 8.0, regardless
# 			of the storage engine used.
#
# 		) The ENCRYPTION option is used to enable or disable page-level data encryption for an
# 			InnoDB general tablespace.
#
# 			Option values are not case-sensitive.
#
# 			Encryption support for general tablespaces was introduced in MySQL 8.0.13
#
# 			A keyring plugin must be installed and configured to use the ENCRYPTION option.
#
# 			When a general tablespace is encrypted, all tables residing in the tablespace is
# 			encrypted.
#
# 			For more information, see SECTION 15.6.3.9, "TABLESPACE ENCRYPTION"
#
# 		) ENGINE:
#
# 			Defines the storage engine which uses the tablespace, where engine_name
# 			is the name of the storage engine.
#
# 			Currently, only the InnoDB storage engine is supported by standard MySQL
# 			8.0 releases
#
# 			MySQL NDB Cluster supports both NDB and InnoDB tablespaces.
#
# 			The value of the default_storage_engine system variable is used
# 			for ENGINE if the option is not specified.
#
# NOTES
#
# 		) For the rules covering the naming of MySQL tablespaces, see SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# 		In addition to these rules, the slash character ("/") is not permitted, nor can
# 		you use names beginning with innodb_, as this prefix is reserved for system use.
#
# 		) Creation of temporary general tablespace is not supported
#
# 		) General tablespaces do not support temporary tables
#
# 		) The TABLESPACE option may be used with CREATE_TABLE or ALTER_TABLE to assign
# 			an InnoDB table partition or subpartition to a file-per-table tablespace.
#
# 			All partitions must belong to the same storage engine.
#
# 			Assigning table partitions to shared InnoDB tablespaces is not supported.
#
# 			Shared tablespaces include the InnoDB system tablesapce and general tablespaces.
#
# 		) General tablespaces support the addition of tables of any row format using CREATE_TABLE_---_TABLESPACE,
# 			innodb_file_per_table does not need to be enabled.
#
# 		) innodb_strict_mode is not applicable to general tablespaces.
#
# 			Tablespace management rules are strictly enforced indepdently of
# 			innodb_strict_mode
#
# 			If CREATE TABLESPACE parameters are incorrect or incompatible,
# 			the operation fails regardless of the innodb_strict_mode setting.
#
# 			When a table is added to a general tablespace using CREATE_TABLE_---_TABLESPACE
# 			or ALTER_TABLE_---_TABLESPACE then innodb_strict_mode is ignored but the
# 			statement is evaluated as if innodb_strict_mode is enabled.
#
# 		) Use DROP TABLESPACE to remove a tablespace.
#
# 			ALl tables must be dropped from a tablespace using DROP_TABLE prior to
# 			dropping the tablespace.
#
# 			Before dropping an NDB Cluster tablespace you must also remove all
# 			its data files using one or more ALTER_TABLESPACE_---_DROP_DATAFILE
# 			statements.
#
# 			See SECTION 22.5.13.1, "NDB CLUSTER DISK DATA OBJECTS"
#
# 		) ALl parts of an InnoDB table added to an InnoDB general tablespace reside
# 			in the general tablespace, including indexes and BLOB pages.
#
# 			For an NDB table assigned to a tablespace, only those columns which are not indexed
# 			are stored on disk, and actually use the tablespace data files.
#
# 			Indexes and indexed columns for all NDB tables are always kept in memory.
#
# 		) Similar to the system tablespace, truncating or dropping tables stored in a general
# 			tablespace creates free space internally in the general tablespace
# 			.ibd data file which can only be used for new InnoDB data.
#
# 			Space is not released back to the operating system as it is for
# 			file-per-table tablespaces.
#
# 		) A general tablespace is not associated with any database or schema.
#
# 		) ALTER_TABLE_---_DISCARD_TABLESPACE and ALTER_TABLE_---_IMPORT_TABLESPACE
# 			are not supported for tables that belong to a general tablespace.
#
# 		) The several uses tablespace-level metadata locking for DDL that references
# 			general tablespaces.
#
# 			By comparison, the server uses table-level metadata locking for DDL
# 			that references file-per-table tablespaces.
#
# 		) A generated or existing tablespace cannot be changed to a general tablespace
#
# 		) There is no conflict between general tablespace names and file-per-table tablespace
# 			names.
#
# 			The "/" character, which is present in file-per-table tablespace names,
# 			is not permitted in general tablespace names.
#
# 		) mysqldump and mysqlpump do not dump InnoDB CREATE_TABLESPACE statements
#
# INNODB EXAMPLES
#
# This example demonstrates creating a general tablespace and adding three uncompressed
# tables of different row formats.
#
# 		CREATE TABLESPACE `ts1` ADD DATAFILE 'ts1.ibd' ENGINE=INNODB;
#
# 		CREATE TABLE t1 (c1 INT PRIMARY KEY) TABLESPACE ts1 ROW_FORMAT=REDUNDANT;
#
# 		CREATE TABLE t2 (c1 INT PRIMARY KEY) TABLESPACE ts1 ROW_FORMAT=COMAPCT;
#
# 		CREATE TABLE t3 (c1 INT PRIMARY KEY) TABLESPACE ts1 ROW_FORMAT=DYNAMIC;
#
# This example demonstrates creating a general tablespace and adding a compressed table.
#
# The example assumes a default innodb_page_size value of 16K
#
# The FILE_BLOCK_SIZE of 8192 requires that the compressed table have a KEY_BLOCK_SIZE
# of 8.
#
# 		CREATE TABLESPACE `ts2` ADD DATAFILE 'ts2.ibd' FILE_BLOCK_SIZE = 8192 Engine=InnoDB;
#
# 		CREATE TABLE t4 (c1 INT PRIMARY KEY) TABLESPACE ts2 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;
#
# This example demonstrates creating a general tablespace without specifying the ADD DATAFILE
# clause, which is optional as of MySQL 8.0.14
#
# 		CREATE TABLESPACE `ts3` ENGINE=INNODB;
#
# This example demonstrates creating an undo tablespace.
#
# 		CREATE UNDO TABLESPACE undo_003 ADD DATAFILE 'undo_003.ibu';
#
# NDB EXAMPLE
#
# Suppose that you wish to create an NDB Cluster Disk Data tablespace named
# myts using a datafile named mydata-1.dat 
#
# An NDB tablespace always requires the use of a log file group consisting
# of one or more undo log files.
#
# For htis example, we first create a log file group named mylg that contains
# one undo long file named myundo-1.dat, using the CREATE_LOGFILE_GROUP statement
# shown here:
#
# 		CREATE LOGFILE GROUP myg1
# 			ADD UNDOFILE 'myundo-1.dat'
# 			ENGINE=NDB;
# 		Query OK, 0 rows affected (3.29 sec)
#
# Now you can create the tablespace previously described using the following statement:
#
# 		CREATE TABLESPACE myts
# 			ADD DATAFILE 'mydata-1.dat'
# 			USE LOGFILE GROUP mylg
# 			ENGINE=NDB;
# 		Query OK, 0 rows affected (2.98 sec)
#
# You can now create a Disk Data table using a CREATE_TABLE statement with the
# TABLESPACE and STORAGE DISK options, similar to what is shown here:
#
# 		CREATE TABLE mytable (
# 			id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 			lname VARCHAR(50) NOT NULL,
# 			fname VARCHAR(50) NOT NULL,
# 			dob DATE NOT NULL,
# 			joined DATE NOT NULL,
# 			INDEX(last_name, first_name)
# 		)
# 			TABLESPACE myts STORAGE DISK
# 			ENGINE=NDB;
# 		Query OK, 0 rows affected (1.41 sec)
#
# It is important to note that only the dob and joined columns from mytable are actually
# stored on disk, due to the fact that the id, lname, and fname columns are all indexed.
#
# As mentioned previously, when CREATE TABLESPACE is used with ENGINE [=] NDB, a tablespace
# and associated data file are created on each NDB Cluster data node.
#
# You can verify that the data files were created and obtain all information about them
# by querying the INFORMATION_SCHEMA.FILES table, as shown here:
#
# 		SELECT FILE_NAME, FILE_TYPE, LOGFILE_GROUP_NAME, STATUS, EXTRA
# 			FROM INFORMATION_SCHEMA.FILES
# 			WHERE TABLESPACE_NAME = 'myts';
#  	
# 		+----------------------+-----------------+---------------------------------+--------------+--------------------+
# 		| file_name 			  | file_type 		  | logfile_group_name 					| status 		| extra 					|
# 		+----------------------+-----------------+---------------------------------+--------------+--------------------+
# 		| mydata-1.dat 		  | DATAFILE 		  | mylg 									| NORMAL 		| CLUSTER_NODE=5 	   |
# 		| mydata-1.dat 		  | DATAFILE 		  | mylg 									| NORMAL 		| CLUSTER_NODE=6 	   |
# 		| NULL 					  | TABLESPACE 	  | mylg  									| NORMAL 		| NULL 					|
# 		+----------------------+-----------------+---------------------------------+--------------+--------------------+
# 		3 rows in set (0.01 sec)
#
# For additional information and examples, see SECTION 22.5.13.1, "NDB CLUSTER DISK DATA OBJECTS"
#
# 13.1.22 CREATE TRIGGER SYNTAX
#
# 		CREATE
# 			[DEFINER = { user | CURRENT_USER }]
# 			TRIGGER trigger_name
# 			trigger_name trigger_event
# 			ON tbl_name FOR EACH ROW
# 			[trigger_order]
# 			trigger_body
#
# 		trigger_time: { BEFORE | AFTER }
#
# 		trigger_event: { INSERT | UPDATE | DELETE }
#
# 		trigger_order: { FOLLOWS | PRECEDES } other_trigger_name
#
# This statement creates a new trigger.
#
# A trigger is a named database object that is associated with a table, and that activates
# when a particular event occurs for the table.
#
# The trigger becomes associated with the table named tbl_name, which must refer to a permanent
# table.
#
# You cannot associate a trigger with a TEMPORARY table or a view.
#
# Trigger names exist in the schema namespace, meaning that all triggers must have unique names
# within a schema.
#
# Triggers in different schemas can have the same name.
#
# This section describes CREATE_TRIGGER syntax. For additional discussion, see SECTION 24.3.1, "TRIGGER SYNTAX AND EXAMPLES"
#
# CREATE_TRIGGER requires the TRIGGER privilege for the table associated with the trigger.
#
# The statement might also require the SET_USER_ID or SUPER privilege, depending on
# the DEFINER value, as described later in this section.
#
# If binary logging is enabled, CREATE_TRIGGER might require the SUPER privilege,
# as described in SECTION 24.7, "BINARY LOGGING OF STORED PROGRAMS"
#
# The DEFINER clause determines the security context to be used when checking access
# privileges at trigger activation time, as described later in this section.
#
# trigger_time is the trigger action time.
#
# It can be BEFORE or AFTER to indicate that the trigger activates before or after
# each row to be modified.
#
# Basic column value checks occur prior to trigger activation, so you cannot use BEFORE
# triggers to convert values inappropriate for the column type to valid values.
#
# trigger_event indicates the kind of operation that activates the trigger.
#
# These trigger_event values are permitted:
#
# 		) INSERT: The trigger activates whenever a new row is inserted into the table;
# 			for example, through INSERT, LOAD_DATA and REPLACE statements.
#
# 		) UPDATE: The trigger activates whenever a row is modified; for example, through UPDATE statements.
#
# 		) DELETE: The trigger activates whenever a row is deleted from the table;
#
# 		For example, through DELETE and REPLACE statements. DROP_TABLE and TRUNCATE_TABLE
# 		statements on the table do not activate this trigger, because they do not use DELETE.
#
# 		Dropping a partition does not activate DELETE triggers, either.
#
# The trigger_event does not represent a literal type of SQL statement that activates the trigger so much
# as it represents a type of table operation.
#
# For example, an INSERT trigger activates not only for INSERT statements but also LOAD_DATA statements
# because both statements insert rows into a table.
#
# A potentially confusing example of this is the INSERT INTO --- ON DUPLICATE KEY UPDATE --- syntax:
#
# 		a BEFORE INSERT trigger activates for every row, followed by either an
# 		AFTER INSERT trigger or both the BEFORE UPDATE and AFTER UPDATE triggers,
# 		depending on whether there was a duplicate key for the row.
#
# NOTE:
#
# 		Cascaded foreign key actions do not activate triggers
#
# It is possible to define multiple triggers for a given table that have the same trigger
# event and action time.
#
# For example, you can have two BEFORE UPDATE triggers for a table.
#
# By default, triggers that have the same trigger event and action name activate
# in the order htey were created.
#
# To affect trigger order, specify a trigger_order clause that indicates FOLLOWS
# or PRECEDES and the name of an existing trigger that also has the same trigger
# event and action time.
#
# With FOLLOWS, the new trigger activates after the existing trigger.
#
# With PRECEDES, the new trigger activates before the existing trigger.
#
# trigger_body is the statement to execute when the trigger activates.
#
# To execute multiple statements, use the BEGIN_---_END compound statement
# construct.
#
# This also enables you to use the same statements that are permitted within stored
# routines.
#
# See SECTION 13.6.1, "BEGIN_---_END COMPOUND-STATEMENT SYNTAX"
#
# Some statements are not permitted in triggers, see SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS"
#
# Within the trigger body, you can refer to columns in the subject table (the table associated
# with the trigger) by using the aliases OLD and NEW.
#
# OLD.col_name refers to a column of an existing row before it updated or deleted
#
# NEW.col_name refers to teh column of a new row to be inserted or an existing row after
# it is updated.
#
# Triggers cannot use NEW.col_name or use OLD.col_name to refer to generated columns.
#
# FOr information about generated columns, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
#
# MySQL stores the sql_mode system variable setting in effect ´when a trigger is created, and always
# executes the trigger body with this setting in force, regardless of the current server SQL
# mode when the trigger begins executing.
#
# The DEFINER clause specifies the MySQL account to be used when checking access privileges
# at trigger activation time.
#
# If a user value is given, it should be a MySQL account specified as 'user_name'@'host_name',
# CURRENT_USER or CURRENT_USER()
#
# The default DEFINER value is the user who executes the CREATE_TRIGGER statement.
#
# THis is the same as specifying DEFINER = CURRENT_USER explicitly.
#
# If you specify the DEFINER clause, these rules determine the valid DEFINER user values:
#
# 		) If you do not have the SET_USER_ID or SUPER privilege, the only permitted user value
# 			is your own account, either specified literally or by using CURRENT_USER 
#
# 		You cannot set the definer to some other account
#
# 		) If you have the SET_USER_ID or SUPER privilege, you can specify any syntactically
# 			valid account name.
#
# 			If the account does not exist, a warning is generated.
#
# 		) Although it is possible to create a trigger with a nonexistent DEFINER account,
# 			it is not a good idea for such triggers to be activated until the account
# 			actually does exist.
#
# 			Otherwise, the behavior with respect to privilege checking is undefined.
#
# MySQL takes the DEFINER user into account when checking trigger privileges as follows:
#
# 		) At CREATE_TRIGGER time, the user who issues the statement must have the TRIGGER privilege
#
# 		) At trigger activation time, privileges are checked against the DEFINER user.
#
# 			This user must have these privileges:
#
# 				) The TRIGGER privilege for the subject table
#
# 				) The SELECT privilege for the subject table if references to table columns occur
# 				using OLD.col_name or NEW.col_name in the trigger body.
#	
# 				) The UPDATE privilege for the subject table if table columns are targets of
# 				SET NEW.col_name = value assignments in the trigger body.
#
# 				) Whatever other privileges normally are required for the statements executed by the trigger.
#
# For more information about trigger security, see SECTION 24.6, "ACCESS CONTROL FOR STORED PROGRAMS AND VIEWS"
#
# Within a trigger body, the CURRENT_USER() function returns the account used to check privileges
# at trigger activation time.
#
# This is the DEFINER user, not the user whose actions caused the trigger to be activated.
#
# For information about user auditing within triggers, see SECTION 6.3.13,
# "SQL-BASED MYSQL ACCOUNT ACTIVITY AUDITING"
#
# If you use LOCK_TABLES to lock a table that has triggers, the tables used within the trigger
# are also locked, as described in LOCK TABLES AND TRIGGERS
#
# For additional discussions of trigger use, see SECTION 24.3.1, "TRIGGER SYNTAX AND EXAMPLES"
#
# 13.1.23 CREATE VIEW SYNTAX
#
# CREATE
# 		[OR REPLACE]
# 		[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
# 		[DEFINER = { user | CURRENT_USER }]
# 		[SQL SECURITY { DEFINER | INVOKER }]
# 		VIEW view_name [(column_list)]
# 		AS select_statement
# 		[WITH [CASCADED | LOCAL] CHECK OPTION]
#
# The CREATE_VIEW statement creates a new view, or replaces an existing view if hte
# OR REPLACE clause is given.
#
# If the view does not exist, CREATE_OR_REPLACE_VIEW is the same as CREATE_VIEW
# 
# If the view does exist, CREATE_OR_REPLACE_VIEW replaces it
#
# For information about restrictions on view use, see SECTION C.5, "RESTRICTIONS ON VIEWS"
#
# The select_statement is a SELECT statement that provides the definition of the view.
#
# (Selecting from the view selects, in effect, using the SELECT statement)
#
# The select_statement can select from base tables or other views.
#
# The view definition is "frozen" at creation time and is not affected by subsequent changes
# to the definitions of the underlying tables.
#
# For example, if a view is defined as SELECT * on a table, new columns added to the table
# later do not become part of the view, and columns dropped from the table will result in
# an error when selecting from teh view.
#
# the ALGORITHM clause affects how MySQL processes the view.
#
# The DEFINER and SQL SECURITY clauses specify the security context to be used when
# checking access privileges at view invocation time.
#
# The WITH CHECK OPTION clause can be given to constrain inserts or updates to rows
# in tables referenced by the view.
#
# These clauses are described later in this section.
#
# The CREATE_VIEW statement requires the CREATE_VIEW privilege for the view, and some
# privilege for each column selected by the SELECT statement.
#
# For columns used elsewhere in the SELECT statement, you must have the SELECT privilege.
#
# If the OR REPLACE clause is present, you must also have the DROP privilege for the view.
#
# CREATE VIEW might also require the SET_USER_ID or SUPER privilege, depending on the DEFINER
# value, as described later in this section.
#
# WHen a view is referenced, privilege checking occurs as described later in this section
#
# A view belongs to a database.
#
# By default, a new view is created in the default database. To create the view explicitly
# in a given database, use db_name.view_name syntax to qualify the view name with the
# database name:
#
# 		CREATE VIEW test.v AS SELECT * FROM t;
#
# Unqualified table or view names in the SELECT statement are also interpreted with respect
# to the default database.
#
# A view can refer to tables or views in other databases by qualifying the table or view
# name with the appropriate database name.
#
# Within a database, base tables and views share the same namespace, so a base table and
# a view cannot have the same name.
#
# Columns retrieved by the SELECT statement can be simple references to table columns,
# or expressions that use functions, constant values, operators, and so forth.
#
# A view must have unique columns names with no duplicates, just like a base table.
#
# By default, the names of the columns retrieved by the SELECT statement are used for
# the view column names.
#
# To define explicit names for the view columns, specify the optional column_list
# clause as a list of comma-separated identifiers.
#
# The number of names in column_list must be the same as the number of columns
# retrieved by the SELECT statement.
#
# A view can be created from many kinds of SELECT statements.
#
# It can refer to base tables or other views. It can use joins, UNION and subqueries.
#
# The SELECT need not even refer to any tables:
#
# 		CREATE VIEW v_today (today) AS SELECT CURRENT_DATE;
#
# The following example defines a view that selects two columns from another table as well
# as an expression calculated from those columns:
#
# 		CREATE TABLE t (qty INT, price INT);
# 		INSERT INTO t VALUES(3, 50);
# 		CREATE VIEW v AS SELECT qty, price, qty*price AS value FROM t;
# 		SELECT * FROM v;
# 		+-------+----------+----------+
# 		| qty   | price 	 | value 	|
# 		+-------+----------+----------+
# 		| 3 	  | 50 		 | 150 		|
# 		+-------+----------+----------+
#
# A view definition is subject to the following restrictions:
#
# 		) The SELECT statement cannot refer to system variables or user-defined variables
#
# 		) Within a stored program, the SELECT statement cannot refer to program parameters
# 			or local variables.
#
# 		) The SELECT statement cannot refer to prepared statemnt parameters.
#
# 		) Any table or view referred to in the definition must exist.
#
# 			If, after the view has been created, a table or view that the definition
# 			refers to is dropped, use of the view results in an error.
#
# 			To check a view definition for problems of this kind, use the CHECK_TABLE statement.
#
# 		) The definition cannot refer to a TEMPORARY table, and you cannot create a TEMPORARY view.
#
# 		) You cannot associate a trigger with a view
#
# 		) Aliases for column names in the SELECT statement are checked against the maximum column
# 			length of 64 characters (not the maximum alias length of 256 characters)
#
# ORDER BY is permitted in a view definition, but it is ignored if you select from a view using
# a statement that has its own ORDER BY.
#
# For other options or clauses in the definition, they are added to the options or clauses
# of the statement that references the view, but the effect is undefined.
#
# For example, if a view definition includes a LIMIT clause, and you select from the view
# using a statement that has its own LIMIT clause, it is undefined which limit applies.
#
# This same principle applies to options such as ALL, DISTINCT, or SQL_SMALL_RESULT that follow
# the SELECT keyword, and to clauses such as INTO, FOR UPDATE, FOR SHARE, LOCK IN SHARE MODE,
# and PROCEDURE.
#
# The results obtained from a view may be affected if you change the query processing
# environment by changing system variables:
#
# 		CREATE VIEW v (mycol) AS SELECT 'abc';
# 		Query OK, 0 rows affected (0.01 sec)
#
# 		SET sql_mode = '';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT "mycol" FROM v;
# 		+----------+
# 		| mycol    |
# 		+----------+
# 		| mycol    |
# 		+----------+
# 		1 row in set (0.01 sec)
#
# 		SET sql_mode = 'ANSI_QUOTES';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT "mycol" FROM v;
# 		+----------+
# 		| mycol    |
# 		+----------+
# 		| abc 	  |
# 		+----------+
# 		1 row in set (0.00 sec)
#
# The DEFINER and SQL SECURITY clauses determine which MySQL account to use when
# checking access privileges for the view when a statement is executed that 
# references the view.
#
# The valid SQL SECURITY characteristic values are DEFINER (the default) and INVOKER.
#
# These indicate that the required privileges must be held by the user who defined
# or invoked the view, respectively.
#
# If a user value is given for the DEFINER claus, it should be a MySQL account specified
# as 'user_name'@'host_name', CURRENT_USER or CURRENT_USER() 
#
# The default DEFINER value is the user who executes the CREATE_VIEW statement.
#
# This is the same as specifying DEFINER = CURRENT_USER explicitly.
#
# If the DEFINER clause is present, these rules determine the valid DEFINER user values:
#
# 		) If you do not have the SET_USER_ID or SUPER privilege, the only valid user value is
# 			your own account, either specified literally or by using CURRENT_USER
#
# 			You cannot set the definer to some other account
#
# 		) If you have the SET_USER_ID or SUPER privilege, you can specify any syntactically
# 			valid account name.
#
# 			If the account does not exist, a warning is generated.
#
# 		) Although it is possible to create a view with a nonexistent DEFINER account,
# 			an error occurs when the view is referenced if the SQL SECURITY value is
# 			DEFINER but the definer account does not exist.
#
# For more information about view security, see SECTION 24.6, "ACCESS CONTROL FOR STORED PROGRAMS AND VIEWS"
#
# Within a view definition, CURRENT_USER returns the view's DEFINER value by default.
#
# For views defined with the SQL SECURITY INVOKER characteristic, CURRENT_USER returns
# the account for the view's invoker.
#
# For information about user auditing within views, see SECTION 6.3.13, "SQL-BASED MYSQL
# ACCOUNT ACTIVITY AUDITING"
#
# Within a stored routine that is defined with the SQL SECURITY DEFINER characteristic,
# CURRENT_USER returns the routine's DEFINER value.
#
# THis also affects a view defined within such a routine, if hte view definition 
# contains a DEFINER value of CURRENT_USER
#
# MySQL checks view privileges like this:
#
# 		) At view definition time, the view creator must have the privileges needed to use the
# 			top-level objects accessed by the view.
#
# 			For example, if the view definitions refers to table columns, the creator must have
# 			some privilege for each column in the select list of the definition, and the SELECT
# 			privilege for each column used elsewhere in the definition.
#
# 			If the definition refers to a stored function, only the privileges needed to invoke
# 			the function can be checked.
#
# 			The privileges required at function invocation time  can be checked only as it executes:
#
# 				For different invocations, different execution paths within the function might be taken.
#
# 		) The user who references a view must have appropriate privileges to access it (SELECT to select from it,
# 			INSERT to insert into it and so forth.)
#
# 		) When a view has been referenced, privileges for objects acessed by the view are checked against the
# 			privileges held by the view DEFINER account or invoker, depending on whether the SQL SECURITY
# 			characteristic is DEFINER or INVOKER, respectively.
#
# 		) If reference to a view causes execution of a stored function, privilege checking for statements executed
# 		within the function depend on whether the function SQL SECURITY characteristic is DEFINER or INVOKER.
#
# 		If the security characteristic is DEFINER, the function runs with the privileges of the DEFINER account.
#
# 		If the characteristic is INVOKER, the function runs with the privileges determined by the view's SQL SECURITY
# 		characteristic.
#
# Example: A view might depend on a stored function, and that function might invoke other stored routines.
#
# For example, the following view invokes a stored function f():
#
# 		CREATE VIEW v AS SELECT * FROM t WHERE t.id = f(t.name);
#
# Suppose that f() contains a statement such as this:
#
# 		IF name IS NULL then
# 			CALL p1();
# 		ELSE
# 			CALL p2();
# 		END IF;
#
# The privileges required for executing statements within f() need to be checked when
# f() executes.
#
# This might mean that privileges are needed for p1() or p2(), depending on the execution
# path within f()
#
# Those privileges must be checked at runtime, and the user who must possess the privileges
# is determined by the SQL SECURITY values of the view v and the function f()
#
# The DEFINER and SQL SECURITY clauses for views are extensions to standard SQL.
#
# In standard SQL, views are handled using the rules for SQL SECURITY DEFINER
#
# The standard says that the definer of the view, which is the same as the owner
# of the view's schema, gets applicable privileges on the view (for example, SELECT)
# and may grant them.
#
# MySQL has no concept of a schema "owner", so MySQL adds a clause to identify the definer.
#
# The DEFINER clause is an extension where the intent is to have what the standard
# has; that is, a permanent record of who defined the view.
#
# This is why the default DEFINER value is the account of the view creator.
#
# The optional ALGORITHM clause is a MySQL extension to standard SQL.
#
# It affects how MySQL processes the view. ALGORITHM takes three values:
#
# 		MERGE
#
# 		TEMPTABLE
#
# 		UNDEFINED
#
# For more information, see SECTION 24.5.2, "VIEW PROCESSING ALGORITHMS", as well as
# SECTION 8.2.2.4, "OPTIMIZING DERIVED TABLES, VIEW REFERENCES, AND COMMON TABLE EXPRESSIONS
# WITH MERGING OR MATERIALIZATION"
#
# Some views are updatable.
#
# That is, you can use them in statements such as UPDATE, DELETE or INSERT to update
# the contents of the underlying table.
#
# For a view to be updatable, there must be a one-to-one relationship between the rows
# in the view and the rows in the underlying table.
#
# There are also certain other constructs that make a view nonupdatable.
#
# A generated column in a view is considered updatable because it is possible to assign to it.
#
# However, if such a column is updated explicitly, the only permitted value is
# DEFAULT.
#
# For information about generated columns, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
#
# The WITH CHECK OPTION clause can be given for an updatable view to prevent inserts or updates
# to rows except those for which the WHERE clause in the select_statement is true.
#
# In a WITH CHECK OPTION clause for an updatable view, the LOCAL and CASCADED keywords determine
# the scope of check testing when the view is defined in terms of another view.
#
# The LOCAL keyword restricts the CHECK OPTION only to the view being defined.
#
# CASCADED causes the checks for underlying views to be evaluated as well.
#
# When neither keyword is given, the default is CASCADED.
#
# For more information about updatable views and the WITH CHECK OPTION clause, see
# SECTION 24.5.3, "UPDATABLE AND INSERTABLE VIEWS", and SECTION 24.5.4, "THE VIEW WITH CHECK OPTION CLAUSE"
#
# 13.1.24 DROP DATABASE SYNTAX
#
# 		DROP {DATABASE | SCHEMA} [IF EXISTS] db_name
#
# DROP_DATABASE drops all tables in the database and deletes teh database.
#
# Be very careful with this statement. To use DROP_DATABASE, you need the DROP privilege
# on the database.
#
# DROP_SCHEMA is a synonym for DROP_DATABASE
#
# IMPORTANT:
#
# 		When a database is dropped, privileges granted specifically for the database are not automatically dropped.
#
# 		They must be dropped manually. See SECTION 13.7.1.6, "GRANT SYNTAX"
#
# IF EXISTS is used to prevent an error from occurring if the database does not exist.
#
# If the default database is dropped, the default database is unset (the DATABASE() function returns NULL)
#
# If you use DROP_DATABASE on a symbolically linked database, both the link and the original database are deleted.
#
# DROP_DATABASE returns the number of tables that were removed.
#
# The DROP_DATABASE statement removes from the given database directory those files and directories
# that MySQL itself may create during normal operation.
#
# This includes all files with the extensions shown in the following list:
#
# 		) .BAK
#
# 		) .DAT
#
# 		) .HSH
#
# 		) .MRG
#
# 		) .MYD
#
# 		) .MYI
#
# 		) .cfg
#
# 		) .db
#
# 		) .ibd
#
# 		) .ndb
#
# If other files or directories remain in the database directory after MySQL removes those just listed,
# the database directory cannot be removed.
#
# In this case, you must remove any remaining files or directories manually and issue the
# DROP_DATABASE statement again.
#
# Dropping a database does not remove any TEMPORARY tables that were created in that database.
#
# TEMPORARY tables are automatically removed when the session that created them ends.
# See SECTION 13.1.20.3, "CREATE TEMPORARY TABLE SYNTAX"
#
# You can also drop databases with mysqladmin.
#
# See SECTION 4.5.2, "MYSQLADMIN - CLIENT FOR ADMINSTERING A MYSQL SERVER"
#
# 13.1.25 DROP EVENT SYNTAX
#
# DROP EVENT [IF EXISTS] event_name
#
# This statement drops the event named event_name.
#
# The event immediately ceases being active, and is deleted completely from the server
#
# If the event does not exist, the error ERROR 1517 (HY000): Unknown event 'event_name' results.
#
# You can override this and cause the statement to generate a warning for nonexistent
# events instead using IF EXISTS
#
# This statement requires the EVENT privilege for the schema to which the event
# to be dropped belongs.
#
# 13.1.26 DROP FUNCTION SYNTAX
#
# The DROP_FUNCTION statement is used to drop stored functions and user-defined functions
# (UDFs):
#
# 		) For information about dropping stored functions, see SECTION 13.1.29, "DROP PROCEDURE AND DROP FUNCTION SYNTAX"
#
# 		) For information about dropping user-defined functions, see SECTION 13.7.4.2, "DROP FUNCTION SYNTAX"
#
# 13.1.27 DROP INDEX SYNTAX
#
# DROP INDEX index_name ON tbl_name
# 		[algorithm_option | lock_option] ---
#
# algorithm_option:
# 		ALGORITHM [=] {DEFAULT|INPLACE|COPY}
#
# lock_option:
# 		LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}
#
# DROP_INDEX drops the index named index_name from the table tbl_name
#
# This statement is mapped to an ALTER_TABLE statement to drop the index.
#
# See SECTION 13.1.9, "ALTER TABLE SYNTAX"
#
# To drop a primary key, the index name is always PRIMARY, which must be specified
# as a quoted identifier because PRIMARY is a reserved word:
#
# 		DROP INDEX `PRIMARY` ON t;
#
# Indexes on variable-width columns of NDB tables are dropped online; that is, without
# any table copying.
#
# The table is not locked against access from other NDB Cluster API nodes, although
# it is locked against other operations on the same API node for the duration of the
# operation.
#
# This is done automatically by the server whenever it determines that it is possible
# to do so;
#
# you do not have to use any special SQL syntax or server options to cause it to happen.
#
# ALGORITHM and LOCK clauses may be given to influence the table copying method and level
# of concurrency for reading and writing the table while its indexes are being
# modified.
#
# They have the same meaning as for the ALTER_TABLE statement.
#
# For more information, see SECTION 13.1.9, "ALTER TABLE SYNTAX"
#
# MySQL NDB Cluster supports online operations using the same ALGORITHM=INPLACE
# syntax supported in the standard MySQL server.
#
# See SECTION 22.5.14, "ONLINE OPERATIONS WITH ALTER TABLE IN NDB CLUSTER", for more information.
#
# 13.1.28 DROP LOGFILE GROUP SYNTAX
#
# DROP LOGFILE GROUP logfile_group
# 		ENGINE [=] engine_name
#
# This statement drops the log file group named logfile_group.
#
# The log file group must already exist or an error results.
#
# (For information on creating log file groups, see SECTION 13.1.16, "CREATE LOGFILE GROUP SYNTAX")
#
# IMPORTANT:
#
# 		Before dropping a log file group, you must drop all tablespaces that use that log file
# 		group for UNDO logging.
#
# The required ENGINE clauses provides the name of the storage engine used by the log file group
# to be dropped.
#
# Currently, the only permitted values for engine_name are NDB and NDBCLUSTER
#
# DROP_LOGFILE_GROUP is useful only with Disk Data storage for NDB Cluster.
#
# See SECTION 22.5.13, "NDB CLUSTER DISK DATA TABLES"
#
# 13.1.29 DROP PROCEDURE AND DROP FUNCTION SYNTAX
#
# 	DROP {PROCEDURE | FUNCTION} [IF EXISTS] sp_name
#
# This statement is used to drop a stored procedure or function.
#
# That is, the specified routine is removed from the server. You must have the ALTER_ROUTINE
# privilege for the routine.
#
# (If the automatic_sp_privileges system variable is enabled, that privilege and EXECUTE are granted
# automatically to the routine creator when the routine is created and dropped from the creator
# when the routine is dropped.
#
# See SECTION 24.2.2, "STORED ROUTINES AND MYSQL PRIVILEGES")
#
# The IF EXISTS clause is a MySQL extension.
#
# It prevents an error from occurring if the procedure or function does not exist.
#
# A warning is produced that can be viewed with SHOW_WARNINGS.
#
# DROP_FUNCTION is also used to drop user-defined functions (see SECTION 13.7.4.2, "DROP FUNCTION SYNTAX")
#
# 13.1.30 DROP SERVER SYNTAX
#
# DROP SERVER [ IF EXISTS ] server_name
#
# Drops the server definition for the server named server_name.
#
# The corresponding row in the mysql.servers table is deleted.
#
# This statement requires the SUPER privilege.
#
# Dropping a server for table does not affect any FEDERATED tables that used
# this connection information when they were created.
#
# See SECTION 13.1.18, "CREATE SERVER SYNTAX"
#
# DROP SERVER causes an implicit commit. See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# DROP SERVER is not written to the binary log, regardless of the logging format that is in use.
#
# 13.1.31 DROP SPATIAL REFERENCE SYSTEM SYNTAX
#
# 		DROP SPATIAL REFERENCE SYSTEM
# 			[IF EXISTS]
# 			srid
#
# 		srid: 32-bit unsigned integer
#
# This statement removes a spatial reference system (SRS) definition from the data
# dictionary.
#
# It requires the SUPER privilege.
#
# Example:
#
# 		DROP SPATIAL REFERENCE SYSTEM 4120;
#
# If no SRS definition with the SRID value exists, an error occurs unless IF EXISTS
# is specified.
#
# In that case, a warning occurs rather than an error.
#
# If the SRID value is used by some column in an existing table, an error occurs.
# For example:
#
# 		DROP SPATIAL REFERENCE SYSTEM 4326;
# 		ERROR 3716 (SR005): Can't modify SRID 4326. There is at
# 		least one column depending on it.
#
# To identify which column or columns use the SRID, use this query:
#
# 		SELECT * FROM INFORMATION_SCHEMA.ST_GEOMETRY_COLUMNS WHERE SRS_ID=4326;
#
# SRID values must be in the range of 32-bit unsigned integers, with these restrictions:
#
# 		) SRID 0 is a valid SRID but cannot be used with DROP_SPATIAL_REFERENCE_SYSTEM
#
# 		) If the value is in a reserved SRID range, a warning occurs.
#
# 			Reserved ranges are [0, 32767] (reserved by EPSG), [60,000,000,000,69,999,999] (reserved by EPSG),
# 			and [2,000,000,000,2,147,483,647] (reserved by MySQL)
#
# 			EPSG stands for the European Petroleum Survey Group
#
# 		) Users should not drop SRSs with SRIDs in the reserved ranges.
#
# 			If system-installed SRSs are dropped, the SRS definitions may be recreated
# 			for MySQL upgrades.
#
# 13.1.32 DROP TABLE SYNTAX
#
# 		DROP [TEMPORARY] TABLE [IF EXISTS]
# 			tbl_name [, tbl_name] ---
# 			[RESTRICT | CASCADE]
#
# DROP_TABLE removes one or more tables. You must have the DROP privilege
# for each table.
#
# Be careful with this statement.
#
# It removes the table definition and all table data.
#
# For a partitioned table, it permanently removes the table definition,
# all its partitions and all data stored in those partitions.
#
# It also removes partition definitions associated with the dropped table.
#
# DROP_TABLE causes an implicit commit, except when used with the TEMPORARY
# keyword.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# IMPORTANT:
#
# 		When a table is dropped, privileges granted specifically for the table are NOT
# 		automatically dropped.
#
# 		They must be dropped manually.
#
# 		See SECTION 13.7.1.6, "GRANT SYNTAX"
#
# If any tables named in the argument list do not exist, the statement fails with an
# error indicating by name which nonexisting tables it was unable to drop, and no
# changes are made.
#
# Use IF EXISTS to prevent an error from occurring for tables that do not exist.
#
# Instead of an error, a NOTE is generated for each nonexistent table; these notes
# can be displayed with SHOW_WARNINGS. See SECTION 13.7.6.40, "SHOW WARNINGS SYNTAX"
#
# IF EXISTS can also be useful for dropping tables in unusual circumstances under which
# there is an entry in the data dictionary but no table managed by the storage engine.
#
# (For example, if an abnormal server exit occurs after removal of the table from the
# storage engine but before removal of the data dictionary entry)
#
# The TEMPORARY keyword has the following effects:
#
# 		) The statement drops only TEMPORARY tables
#
# 		) The statement does not cause an implicit commit
#
# 		) No access rights are checked. A TEMPORARY table is visible only with the session
# 			that created it, so no check is necessary.
#
# Using TEMPORARY is a good way to ensure that you do not accidentally drop a 
# non-TEMPORARY table
#
# The RESTRICT and CASCADE keywords do nothing. They are permitted to make porting easier
# from other database systems.
#
# DROP_TABLE is not supported with all innodb_force_recovery settings.
#
# See SECTION 15.20.2, "FORCING INNODB RECOVERY"
#
# 13.1.33 DROP TABLESPACE SYNTAX
#
# 		DROP [UNDO] TABLESPACE tablespace_name
# 			[ENGINE [=] engine_name]
#
# This statement drops a tablespace that was previously created using CREATE_TABLESPACE.
#
# It is supported by the NDB and InnoDB storage engines.
#
# The UNDO keyword, introduced in MySQL 8.0.14, must be specified to drop an undo tablespace.
#
# Only undo tablespaces created using CREATE_UNDO_TABLESPACE syntax can be dropped.
#
# An undo tablespace must be in an empty state before it can be dropped.
# For more information, see SECTION 15.6.3.4, "UNDO TABLESPACES"
#
# ENGINE sets the storage engine that uses the tablespace, where engine_name is the name
# of the storage engine.
#
# Currently, the values InnoDB and NDB are supported.
#
# If not set, the value of default_storage_engine is used
#
# If it is not the same as the storage engine used to create the tablespace,
# the DROP TABLESPACE statement fails.
#
# tablespace_name is a case-sensitive identifier in MySQL.
#
# For an InnoDB general tablespace, all tables must be dropped from the tablespace
# prior to a DROP TABLESPACE operation.
#
# If the tablespace is not empty, DROP TABLESPACE returns an error.
#
# An NDB tablespace to be dropped must not contain any data files; in other words,
# before you can drop an NDB tablespace, you must first drop each of its data
# files using ALTER_TABLESPACE_---_DROP_DATAFILE
#
# NOTES
#
# 		) A general InnoDB tablespace is not deleted automatically when the last table in the
# 			tablespace is dropped.
#
# 			The tablespace must be dropped explicitly using DROP TABLESPACE tablespace_name
#
# 		) A DROP_DATABASE operation can drop tables that belong to a general tablespace but it cannot
# 			drop the tablespace, even if the operation drops all tables that belong to the tablespace.
#
# 			The tablespace must be dropped explicitly using DROP TABLESPACE tablespace_name
#
# 		) Similar to the system tablespace, truncating or dropping tables stored in a general tablespace
# 			creates free space internally in the general tablespace .ibd data file which can only
# 			be used for new InnoDB data.
#
# 			Space is not released back to the operating system as it is for file-per-table tablespaces
#
# InnoDB EXAMPLES
#
# This example demonstrates how to drop an InnoDB general tablespace.
#
# The general tablespace ts1 is created with a single table. 
# Before dropping the tablespace, the table must be dropped.
#
# 		CREATE TABLESPACE `ts1` ADD DATAFILE 'ts1.ibd' Engine=InnoDB;
#
# 		CREATE TABLE t1 (c1 INT PRIMARY KEY) TABLESPACE ts10 Engine=InnoDB;
#
# 		DROP TABLE t1;
#
# 		DROP TABLESPACE ts1;
#
# This example demonstrates dropping an undo tablespace.
#
# An undo tablespace must be in an empty state before it can be dropped.
#
# For more information, see SECTION 15.6.3.4, "UNDO TABLESPACES"
#
# 		DROP UNDO TABLESPACE undo_003;
#
# NDB EXAMPLE
#
# This example shows how to drop an NDB tablespace myts having a data file named mydata-1.dat
# after first creating the tablespace, and assumes the existence of a log file group named
# mylg (see SECTION 13.1.16, "CREATE LOGFILE GROUP SYNTAX")
#
# 		CREATE TABLESPACE myts
# 			ADD DATAFILE 'mydata-1.dat'
# 			USE LOGFILE GROUP mylg
# 			ENGINE=NDB;
#
# You must remove all data files from the tablespace using ALTER_TABLESPACE, as shown here
# , before it can be dropped:
#
# 		ALTER TABLESPACE 
# 			DROP DATAFILE 'mydata-1.dat'
# 			ENGINE=NDB;
#
# 		DROP TABLESPACE myts;
#
# 13.1.34 DROP TRIGGER SYNTAX
#
# 		DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name
#
# This statement drops a trigger. The schema (database) name is optional.
#
# If the schema is omitted, the trigger is dropped from the default schema.
#
# DROP_TRIGGER requires the TRIGGER privilege for the table associated with the trigger.
#
# Use IF EXISTS to prevent an error from occurring for a trigger that does not exist.
#
# A NOTE is generated for a nonexistent trigger when using IF EXISTS.
#
# See SECTION 13.7.6.40, "SHOW WARNINGS SYNTAX"
#
# Triggers for a table are also dropped if you drop the table.
#
# 13.1.35 DROP VIEW SYNTAX
#
# 		DROP VIEW [IF EXISTS]
# 			view_name [, view_name] ---
# 			[RESTRICT | CASCADE]
#
# DROP_VIEW removes one or more views.
#
# You must have the  DROP privilege for each view.
#
# If any views named in the argument list do not exist, the statement fails
# with an error indicating by name which nonexisting views it was unable to
# drop, and no changes are made.
#
# 		NOTE:
#
# 			In MySQL 5.7 and earlier, DROP_VIEW returns an error if any views named in the argument
# 			list do not exist, but also drops all views in the list that do exist.
#
# 			Due to the change in behavior in MySQL 8.0, a partially completed DROP_VIEW operaiton
# 			on a MySQL 5.7 master fails when replicated on a MySQL 8.0 slave
#
# 			To avoid this failure scenario, use IF EXISTS syntax in DROP_VIEW statements to prevent
# 			an error from occurring for views that do not exist.
#
# 			For more information, see SECTION 13.1.1, "ATOMIC DATA DEFINITION STATEMENT SUPPORT"
#
# The IF EXISTS clause prevents an error from occurring for views taht do not exist.
#
# When this clause is given, a NOTE is generated for each nonexistent view.
#
# See SECTION 13.7.6.40, "SHOW WARNINGS SYNTAX"
#
# RESTRICT and CASCADE, if given, are parsed and ignored.
#
# 13.1.36 RENAME TABLE SYNTAX
#
# RENAME TABLE
# 		tbl_name TO new_tbl_name
# 		[, tbl_name2 TO new_tbl_name2] ---
#
# RENAME_TABLE renames one or more tables. You must have ALTER and DROP privileges
# for the original table, and CREATE and INSERT privileges for the new table.
#
# For example, to rename a table named old_table to new_table, use this statement:
#
# 		RENAME TABLE old_table TO new_table;
#
# That statement is equivalent to the following ALTER_TABLE statement:
#
# 		ALTER TABLE old_table RENAME new_table;
#
# RENAME TABLE, unlike ALTER_TABLE, can rename multiple tables within a single statement:
#
# 		RENAME TABLE old_table1 TO new_table1,
# 						 old_table2 TO new_table2,
# 						 old_table3 TO new_table3;
#
# Renaming operations are performed left to right.
#
# Thus, to swap two table names, do this (assuming that a table with the intermediary
# name tmp_table does not already exist):
#
# 		RENAME TABLE old_table TO tmp_table,
# 						 new_table TO old_table,
# 						 tmp_table TO new_table;
#
# Metadata locks on tables are acquired in name order, which in some cases can make a difference
# in operation outcome when multiple transactions execute concurrently.
#
# See SECTION 8.11.4, "METADATA LOCKING"
#
# As of MySQL 8.0.13, you can rename tables locked with a LOCK_TABLES statement, provided
# that they are locked with a WRITE lock or are the product of renaming WRITE-locked
# tables from earlier steps in a multiple-table rename operation.
#
# For example, this is permitted:
#
# 		LOCK TABLE old_table1 WRITE;
# 		RENAME TABLE old_table1 TO new_table1,
# 						 new_table1 TO new_table2;
#
# This is not permitted:
#
# 		LOCK TABLE old_table1 READ;
# 		RENAME TABLE old_table1 TO new_table1,
# 						 new_table1 TO new_table2;
#
# Prior to MySQL 8.0.13, to execute RENAME TABLE, there must be no tables locked with LOCK TABLES.
#
# With the transaction table locking conditions satisfied, the rename operation is done atomically;
# no other session can access any of the tables while the rename is in progress.
#
# If any error occurs during a RENAME TABLE, the statement fails and no changes are made.
#
# You can use RENAME TABLE to move a table from one database to another:
#
# 		RENAME TABLE current_db.tbl_name TO other_db.tbl_name;
#
# Using this method to move all tables from one database to a different one in effect
# renames the database (an operation for which MySQL has no single statement), except
# that the original database continue to exist, albeit with no tables.
#
# Like RENAME TABLE, ALTER TABLE --- RENAME can also be used to move a table to a different
# database.
#
# Regardless of the statement used, if the rename operation would move the table to a database
# located on a different file system, the success of the outcome is platform specific and
# depends on the underlying OS calls used to move table files.
#
# If a table has triggers, attempts to rename the table into a different database fail with a
# Trigger in wrong schema (ER_TRG_IN_WRONG_SCHEMA) error
#
# To rename TEMPORARY tables, RENAME TABLE does not work.
#
# Use ALTER_TABLE instead.
#
# RENAME TABLE works for views, except that views cannot be renamed into a different database.
#
# Any privileges granted specifically for a renamed table or view are not migrated to the new name.
#
# They must be changed manually.
#
# RENAME TABLE changes interally generated foreign key constraint names and user-defined foreign
# key constraint names that contain the string "tbl_name_ibfk_" to reflect the new table name.
#
# InnoDB interprets foreign key constraint names that contain the string "tbl_name_ibfk_"
# as internally generated names.
#
# Foreign key constraint names that point to the renamed table are automatically updated unless
# there is a conflict, in which case the statement fails with an error.
#
# A conflict occurs if the renamed constraint name already exists.
#
# In such cases, you must drop and re-create the foreign keys for them to function properly.
#
# 13.1.37 TRUNCATE TABLE SYNTAX
#
# TRUNCATE [TABLE] tbl_name
#
# TRUNCATE_TABLE empties a table completely. It requires the DROP privilege.
#
# Logically, TRUNCATE_TABLE is similar to DELETE statement that deletes all rows,
# or a sequence of DROP_TABLE and CREATE_TABLE statements.
#
# To achieve a high performance, TRUNCATE_TABLE bypasses the DML method of deleting data.
#
# Thus, it does not cause ON DELETE triggers to fire, it cannot be performed for 
# InnoDB tables with parent-child foreign key relationships, and it cannot be rolled
# back like a DML operation.
#
# However, TRUNCATE TABLE operations on tables that use an atomic DDL-supported storage
# engine are either fully committed or rolled back if the server halts during their operation.
#
# For more information, see SECTION 13.1.1, "ATOMIC DATA DEFINITION STATEMENT SUPPORT"
#
# Although TRUNCATE_TABLE is similar to DELETE, it is classified as a DDL statement rather than
# a DML statement.
#
# It differs from DELETE in the following ways:
#
# 		) Truncate operations drop and re-create the table, which is much faster than deleting rows
# 			one by one, particularly for large tables.
#
# 		) Truncate operations cause an implicit commit, and so cannot be rolled back.
#
# 			See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# 		) Truncation operations cannot be performed if the session holds an active table lock
#
# 		) TRUNCATE_TABLE fails for an InnoDB table or NDB table if there are any FOREIGN KEY constraints
# 			from other tables that reference the table.
#
# 			Foreign key constraints between columns of the same table are permitted.
#
# 		) Truncation operations do not return a meaningful value for the number of deleted rows.
#
# 			The usual result is "0 rows affected", which should be interpreted as "no information"
#
# 		) As long as the table definition is valid, the table can be re-created as an empty table with TRUNCATE_TABLE,
# 			even if the data or index files have become corrupted.
#
# 		) Any AUTO_INCREMENT value is reset to its start value. This is true even for MyISAM and InnoDB, which normally
# 			do not reuse sequence values.
#
# 		) When used with partitioned tables, TRUNCATE_TABLE preserves the partitioning; that is, the data and index
# 			files are dropped and re-created, while the partition definitions are unaffected.
#
# 		) The TRUNCATE_TABLE statement does not invoke ON DELETE triggers
#
# 		) Truncating a corrupted InnoDB table is supported.
#
# TRUNCATE_TABLE for a table closes all handlers for the table that were opened with HANDLER_OPEN
#
# TRUNCATE_TABLE is treated for purposes of binary logging and replication as DROP_TABLE followed by CREATE_TABLE -
# that is, as DDL rather than DML.
#
# This is due to the fact that, when using InnoDB and other transactional storage engines where the transaction
# isolation level does not permit statement-based logging (READ COMMITTED or READ UNCOMMITTED), the statement
# was not logged and replicated when using STATEMENT or MIXED logging mode.
#
# (Bug #36763)
#
# However, it is still applied on replication slaves using InnoDB in the manner described previously.
#
# In MySQL 5.7 and earlier, on a system with a large buffer pool and innodb_adaptive_hash_index
# enabled, a TRUNCATE TABLE operation could cause a temporary drop in system performance due to
# an LRU scan that occurred when removing the table's adaptive hash index entries (Bug #68184)
#
# The remapping of TRUNCATE_TABLE to DROP_TABLE and CREATE_TABLE in MySQL 8.0 avoids the problematic
# LRU scan.
#
# TRUNCATE_TABLE can be used with Performance Schema summary tables, but the effect is to reset the
# summary columns to 0 or NULL, not to remove rows.
#
# See SECTION 26.12.16, "PERFORMANCE SCHEMA SUMMARY TABLES"
#
# 13.2 DATA MANIPULATION STATEMENTS
#
# 13.2.1 CALL SYNTAX
# 13.2.2 DELETE SYNTAX
# 13.2.3 DO SYNTAX
#
# 13.2.4 HANDLER SYNTAX
# 13.2.5 IMPORT TABLE SYNTAX
# 13.2.6 INSERT SYNTAX
#
# 13.2.7 LOAD DATA INFILE SYNTAX
# 13.2.8 LOAD XML SYNTAX
# 13.2.9 REPLACE SYNTAX
# 
# 13.2.10 SELECT SYNTAX
# 13.2.11 SUBQUERY SYNTAX
# 13.2.12 UPDATE SYNTAX
#
# 13.2.13 WITH SYNTAX (COMMON TABLE EXPRESSIONS)
#
# 13.2.1 CALL SYNTAX
#
# CALL sp_name([parameter[,---]])
# CALL sp_name[()]
#
# The CALL statement invokes a stored procedure that was defined previously with CREATE_PROCEDURE
#
# Stored procedures that take no arguments can be invoked without parentheses.
#
# That is, CALL p() and CALL p are equivalent.
#
# CALL can pass back values to its caller using parameters that are declared as OUT or
# INOUT parameters.
#
# When the procedure returns, a client program can also obtain the number of rows
# affected for the final statement executed within the routine:
#
# 		At the SQL level, call the ROW_COUNT() function
#
# 		From the C API, call the mysqL_affected_rows() function
#
# For information about the effect of unhandled conditions on procedure parameters,
# see SECTION 13.6.7.8, "CONDITION HANDLING AND OUT OR INOUT PARAMETERS"
#
# To get back a value from a procedure using an OUT or INOUT parameter, pass the parameter
# by means of a user variable, and then check the value of the variable after the
# procedure returns.
#
# (If you are calling the procedure from within another stored procedure or function,
# you can also pass a routine parameter or local routine variable as an IN or INOUT parameter)
#
# For an INOUT parameter, initialize its value before passing it to the procedure.
#
# The following procedure has an OUT parameter that the procedure sets to
# the current server version, and an INOUT value that the procedure increments by one
# from its current value:
#
# 		CREATE PROCEDURE p (OUT ver_param VARCHAR(25), INOUT incr_param INT)
# 		BEGIN
# 			# Set value of OUT parameter
# 			SELECT VERSION() INTO ver_param;
# 			# Increment value of INOUT parameter
# 			SET incr_param = incr_param + 1;
# 		END;
#
# Before calling the procedure, initialize the variable to be passed as the INOUT parameter.
#
# After calling the procedure, the values of the two variables will have been set or modified:
#
# 		SET @increment = 10;
# 		CALL p(@version, @increment);
# 		SELECT @version, @increment;
# 		+-----------------------------+-------------+
# 		| @version 							| @increment  |
# 		+-----------------------------+-------------+
# 		| 8.0.3-rc-debug-log 			| 11 			  |
# 		+-----------------------------+-------------+
#
# IN prepared CALL statements used with PREPARE and EXECUTE, placeholders
# can be used for IN parameters, OUT, and INOUT parameters.
#
# These types of parameters can be used as follows:
#
# 		SET @increment = 10;
# 		PREPARE s FROM 'CALL p(?, ?)';
# 		EXECUTE s USING @version, @increment;
# 		SELECT @version, @increment;
# 		+----------------------+---------------+
# 		| @version 				  | @increment 	|
# 		+----------------------+---------------+
# 		| 8.0.3-rc-debug-log   | 11 			   |
# 		+----------------------+---------------+
#
# To write C programs that use the CALL SQL statements to execute stored procedures
# that produce result sets, the CLIENT_MULTI_RESULTS flag must be enabled.
#
# THis is because each CALL returns a result to indicate the call status, in addition
# to any result sets that might be returned by statements executed within the procedure.
#
# CLIENT_MULTI_RESULTS must also be enabled if CALL is used to execute any stored procedure
# that contains prepared statements.
#
# It cannot be determined when such a procedure is loaded whether those statements will produce
# result sets, so it is necessary to assume that they will.
#
# CLIENT_MULTI_RESULTS can be enabled when you call mysql_real_connect(), either explicitly
# by passing the CLIENT_MULTI_RESULTS flag itself, or implicitly by passing CLIENT_MULTI_STATEMENTS
# (which also enables CLIENT_MULTI_RESULTS) 
#
# CLIENT_MULTI_RESULTS is enabled by default
#
# To process the result of a CALL statement executed using mysql_query() or mysql_real_query(),
# use a loop that calls mysql_next_result() to determine whether there are more results.
#
# For an example, see SECTION 28.7.19, "C API MULTIPLE STATEMENT EXECUTION SUPPORT"
#
# C programs can use hte prepared-statement interface to execute CALL statements and access
# OUT and INOUT parameters.
#
# This is done by processing the result of a CALL statement using a loop that calls
# mysql_stmt_next_result() to determine whether there are more results.
#
# For an example, see SECTION 28.7.21, "C API PREPARED CALL STATEMENT SUPPORT"
#
# Languages that provide a MySQL interface can use prepared CALL statements to directly
# retrieve OUT and INOUT procedure statements.
#
# Metadata changes to objects referred to by stored programs are detected and cause 
# automatic reparsing of the affected statements when the program is next executed.
#
# For more information, see SECTION 8.10.3, "CACHING OF PREPARED STATEMENTS AND STORED PROGRAMS"
#
# 13.2.2 DELETE SYNTAX
#
# DELETE is a DML statement that removes rows from a table
#
# A DELETE statement can start with a WITH clause to define common table expressions accessible
# within the DELETE.
#
# See SECTION 13.2.13, "WITH SYNTAX (COMMON TABLE EXPRESSIONS)"
#
# SINGLE-TABLE SYNTAX
#
# 		DELETE [LOW_PRIORITY] [QUICK] [IGNORE] FROM tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			[WHERE where_condition]
# 			[ORDER BY ---]
# 			[LIMIT row_count]
#
# The DELETE statement deletes rows from tbl_name and returns the number of deleted rows.
#
# To check the number of deleted rows, call the ROW_COUNT() function described in
# SECTION 12.15, "INFORMATION FUNCTIONS"
#
# MAIN CLAUSES
#
# The conditions in the optional WHERE clause identify which rows to delete.
#
# With no WHERE clause, all rows are deleted.
#
# where_condition is an expression that evaluates to true for each row to be deleted.
# It is specified as described in SECTION 13.2.10, "SELECT SYNTAX"
#
# If the ORDER BY clause is specified, the rows are deleted in the order that is specified.
#
# The LIMIT clause places a limit on the number of rows that can be deleted.
#
# These clauses apply to single-table deletes, but not multi-table deletes
#
# MULTIPLE-TABLE SYNTAX
#
# 		DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
# 			tbl_name[.*] [, tbl_name[.*]] ---
# 			FROM table_references
# 			[WHERE where_condition]
#
# 		DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
# 			FROM tbl_name[.*] [, tbl_name[.*]] ---
# 			USING table_references
# 			[WHERE where_condition]
#
# PRIVILEGES
#
# You need the DELETE privilege on a table to delete rows from it.
#
# You need only the SELECT privilege for any columns that are only read,
# such as those named in the WHERE clause.
#
# PERFORMANCE
#
# When you do not need to know the number of deleted rows, the TRUNCATE_TABLE
# statement is a faster way to empty a table than a DELETE statement with no WHERE clause.
#
# Unlike DELETE, TRUNCATE_TABLE cannot be used within a transaction or if you have a lock
# on the table.
#
# See SECTION 13.1.37, "TRUNCATE TABLE SYNTAX" and SECTION 13.3.6, "LOCK TABLES AND UNLOCK TABLES SYNTAX"
#
# The speed of delete operations may also be affected by factors discussed in SECTION 8.2.5.3,
# "OPTIMIZING DELETE STATEMENTS"
#
# To ensure that a given DELETE statement does not take too much time, the MySQL-specific LIMIT
# row_count clause for DELETE specifies the maximum number of rows to be deleted.
#
# If the number of rows to delete is larger than the limit, repeat the DELETE statement
# until the number of affected rows is less than the LIMIT value.
#
# SUBQUERIES
#
# You cannot delete from a table and select from the same table in a subquery
#
# PARTITIONED TABLE SUPPORT
#
# DELETE supports explicit partition selection using the PARTITION option, which takes a list of the
# comma-separated names of one or more partitions or subpartitions (or both) from which to select
# rows to be dropped.
#
# Partitions not included in the list are ignored.
#
# Given a partitioned table t with a partition named p0, executing the statement
# DELETE FROM t PARTITION (p0) has the same effect on the table as executing ALTER_TABLE_t_TRUNCATE_PARTITION_(p0);
# in both cases, all rows in partition p0 are dropped.
#
# PARTITION can be used along with a WHERE condition, in which case the condition is tested
# only on rows in the listed partitions.
#
# For example, 
#
# 		DELETE FROM t PARTITION (p0) WHERE c < 5 
# 
# deletes rows only from partition p0 for which the condition c < 5 is true;
# rows in any other partitions are not checked and thus not affected by the DELETE
#
# The PARTITION option can also be used in multiple-table DELETE statements.
#  
# You can use up to one such option per table named in the FROM option
#
# For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# AUTO-INCREMENT COLUMNS
#
# If you delete the row containing the maximum value for an AUTO_INCREMENT column,
# the value is not reused for a MyISAM or InnoDB table.
#
# if you delete all rows in the table with DELETE FROM tbl_name (without a WHERE clause)
# in autocommit mode, the sequence starts over for all storage engines except InnoDB
# and MyISAM.
#
# There are some exceptions to this behavior for InnoDB tables, as discussed
# in SECTION 15.6.1.14, "AUTO_INCREMENT HANDLING IN INNODB"
#
# For MyISAM tables, you can specify an AUTO_INCREMENT secondary column in a multiple-column
# key.
#
# In this case, reuse of values deleted from the top of the sequence occurs even for
# MyISAM tables. See SECTION 3.6.9, "USING AUTO_INCREMENT"
#
# MODIFIERS
#
# The DELETE statement supports the following modifiers:
#
# 		) If you specify LOW_PRIORITY, the server delays execution of the DELETE until no other
# 			clients are reading from the table.
#
# 			This affects only storage engines that use only table-level locking
# 			(such as MyISAM, MEMORY and MERGE)
#
# 		) For MyISAM tables, if you use the QUICK modifier, the storage engine does not merge
# 			index leaves during delete, which may speed up some kinds of delete operations.
#
# 		) The IGNORE modifier causes MySQL to ignore errors during the process of deleting rows.
#
# 			(Errors encountered during the parsing stage are processed in the usual manner)
#
# 			Errors that are ignored due to the use of IGNORE are returend as warnings.
#
# 			For more information, see COMPARISON OF THE IGNORE KEYWORD AND STRICT SQL MODE
#
# ORDER OF DELETION
#
# If the DELETE statement includes an ORDER BY clause, rows are deleted in the order specified
# by the clause.
#
# This is useful primarily in conjunction with LIMIT.
#
# For example, the following statement finds rows matching the WHERE clause, sorts them
# by timestamp_column, and deletes the first (oldest) one:
#
# 		DELETE FROM somelog WHERE user = 'jcole'
# 		ORDER BY timestamp_column LIMIT 1;
#
# ORDER BY also helps to delete rows in an order required to avoid referential
# integrity violations.
#
# INNODB TABLES
#
# If you are deleting many rows from a large table, you may exceed the lock table
# size for an InnoDB table.
#
# To avoid this problem, or simply to minimize the time that the table remains locked,
# the following strategy (which does not use DELETE at all) might be helpful:
#
# 		1. Select the rows NOT to be deleted into an empty table that has the same structure as the original table:
#
# 			INSERT INTO t_copy SELECT * FROM t WHERE --- ;
#
# 		2. Use RENAME_TABLE to atomically move the original table out of the way and rename the copy to the original name:
#
# 			RENAME TABLE t TO t_old, t_copy TO t;
#
# 		3. Drop the original table:
#
# 			DROP TABLE t_old;
#
# No other sessions can access the tables involved while RENAME_TABLE executes, so the rename operation
# is not subject to concurrency problems.
#
# See SECTION 13.1.36, "RENAME TABLE SYNTAX"
#
# MYISAM TABLES
#
# In MyISAM tables, deleted rows are maintained in a linked list and subsequent INSERT operations
# reuse old row positions.
#
# To reclaim unused space and reduce file size, use the OPTIMIZE TABLE statement or the
# myisamchk utility to reorganize tables.
#
# OPTIMIZE_TABLE is easier to use, but myisamchk is faster.
#
# See SECTION 13.7.3.4, "OPTIMIZE TABLE SYNTAX", and SECTION 4.6.4, "MYISAMCHK -- MyISAM TABLE-MAINTENANCE UTILITY"
#
# The QUICK modifier affects whether index leaves are merged for delete operations.
#
# DELETE QUICK is most useful for applications where index values for deleted rows are replaced by similar
# index values from rows inserted later.
#
# In this case, the holes left by deleted values are reused.
#
# DELETE QUICK is not useful when deleted values lead to underfilled blocks spanning
# a range of index values for which new inserts occur again.
#
# In this case, use of QUICK can lead to wasted space in the index that remains unreclaimed.
#
# Here is an example of such a scenario:
#
# 		1. Create a table that contains an indexed AUTO_INCREMENT column
#
# 		2. Insert many rows into the table. Each insert results in an index value that is added
# 			to the high end of the index.
#
# 		3. Delete a block of rows at the low end of the column range using DELETE QUICK
#
# In this scenario, the index blocks associated with the deleted index values become underfilled
# but are not merged with other index blocks due to the use of QUICK.
#
# They remain underfilled when new inserts occur, because new rows do not have index values
# in the deleted range.
#
# Furthermore, they remain underfilled even if you later use DELETE without QUICK, unless some
# of the deleted index values happen to lie in index blocks within or adjacent to the
# underfilled blocks.
#
# To reclaimed unused index space under these circumstances, use OPTIMIZE_TABLE
#
# If you are going to delete many rows from a table, it might be faster to use DELETE QUICK
# followed by OPTIMIZE TABLE.
#
# This rebuilds the index rather than performing many index block merge operations.
#
# MULTI-TABLE DELETES
#
# You can specify multiple tables in a DELETE statement to delete rows from one or more
# tables depending on teh condition in teh WHERE clause.
#
# You cannot use ORDER BY or LIMIT in a multiple-table DELETE
#
# The table_references clause lists the tables involved in the join,
# as described in SECTION 13.2.10.2, "JOIN SYNTAX"
#
# For the first multiple-table syntax, only matching rows from tables listed before
# the FROM clause are deleted.
#
# For the second multiple-table syntax, only matching rows from the tables listed
# in the FROM clause (before the USING clause) are deleted.
#
# The effect is that you can delete rows from many tables at the same time and have
# additional tables that are used only for searching:
#
# 		DELETE t1, t2 FROM t1 INNER JOIN t2 INNER JOIN t3
# 		WHERE t1.id=t2.id AND t2.id=t3.id;
#
# OR
#
# 		DELETE FROM t1, t2 USING t1 INNER JOIN t2 INNER JOIN t3
# 		WHERE t1.id=t2.id AND t2.id=t3.id;
#
# These statements use all three tables when searching for rows to delete, but delete
# matching rows only from tables t1 and t2.
#
# The preceding examples use INNER JOIN, but multiple-table DELETE statements cna use
# other types of join permitted in SELECT statements, such as LEFT JOIN
#
# For example, to delete rows that exist in t1 that have no match in t2, use a LEFT JOIN:
#
# 		DELETE t1 FROM t1 LEFT JOIN t2 ON t1.id=t2.id WHERE t2.id IS NULL;
#
# The syntax permits .* after each tbl_name for compatibility with Access.
#
# If you use a multiple-table DELETE statement involving InnoDB tables for which
# there are foreign key constraints, the MySQL optimizer might process tables in
# an order that differs from that of their parent/child relationship.
#
# In this case, the statement fails and rolls back.
#
# Instead, you should delete from a single table and rely on the ON DELETE 
# capabilities that INnoDB provides to cause the other tables ot be modified accordingly.
#
# NOTE:
#
# 		if you declare an alias for a table, you must use the alias when referring to teh table:
#
# 			DELETE t1 FROM test AS t1, test2 WHERE ---
#
# Table aliases in a multiple-table DELETE should be declared only in the table_references
# part of the statement.
#
# Elsewhere, alias references are permitted but not alias declarations.
#
# CORRECT:
#
# 		DELETE a1, a2 FROM t1 AS a1 INNER JOIN t2 AS a2
# 		WHERE a1.id=a2.id;
#
# 		DELETE FROM a1, a2 USING t1 AS a1 INNER JOIN t2 AS a2
# 		WHERE a1.id=a2.id;
#
# INCORRECT:
#
# 		DELETE t1 AS a1, t2 AS a2 FROM t1 INNER JOIN t2
# 		WHERE a1.id=a2.id;
#
# 		DELETE FROM t1 AS a1, t2 AS a2 USING t1 INNER JOIN t2
# 		WHERE a1.id=a2.id;
#
# 13.2.3 DO SYNTAX
#
# 		DO expr [, expr] ---
#
# DO executes the expressions but does not return any results.
#
# In most respects, DO is shorthand for SELECT expr, ---, but has the advantage
# that it is slightly faster when you do not care about the result.
#
# DO is useful primarily with functions that have side effects, such as
# RELEASE_LOCCK()
#
# Example: This SELECT statement pauses, but also produces a result set:
#
# 		SELECT SLEEP(5);
# 		+-------------+
# 		| SLEEP(5) 	  |
# 		+-------------+
# 		| 		0 		  |
# 		+-------------+
# 		1 row in set (5.02 sec)
#
# DO, on the other hand, pauses without producing a result set:
#
# 		DO SLEEP(5);
# 		Query OK, 0 rows affected (4.99 sec)
#
# This could be useful, for example in a stored function or trigger, which prohibit
# statements that produce result sets.
#
# DO only executes expressions.
#
# It cannot be used in all cases where SELECT can be used.
#
# For example, DO id FROM t1 is invalid ebcause it references a table.
#
# 13.2.4 HANDLER SYNTAX
#
# 		HANDLER tbl_name OPEN [ [AS] alias]
#
# 		HANDLER tbl_name READ index_name { = | <= | >= | < | > } (value1, value2, ---)
# 			[ WHERE where_condition ] [LIMIT --- ]
# 		HANDLER tbl_name READ index_name { FIRST | NEXT | PREV | LAST }
# 			[ WHERE where_condition ] [LIMIT --- ]
#
# 		HANDLER tbl_name READ { FIRST | NEXT }
# 			[ WHERE where_condition ] [LIMIT --- ]
# 
# 		HANDLER tbl_name CLOSE
#
# The HANDLER statement provides direct access to table storage engine interfaces.
#
# It is available for InnoDB and MyISAM tables.
#
# The HANDLER --- OPEN statement opens a table, making it accessible using subsequent
# HANDLER --- READ statements.
#
# This table object is not shared by other sessions and is not closed until the
# session calls HANDLER --- CLOSE or the session terminates.
#
# If you open the table using an alias, further references to the open table with
# other HANDLER statements must use the alias rather than the table name.
#
# If you do not use an alias, but open the table using a table name qualified
# by the database name, further references must use the unqualified table name.
#
# For example, for a table opened using mydb.mytable - further references must use mytable
#
# The first HANDLER --- READ syntax fetches a row where the index specified statisfies
# the given values and the WHERE condition is met.
#
# If you have a multiple-column index, specify the index column values as a comma-separated
# list.
#
# Either specify values for all the columns in the index, or specify values for a leftmost
# prefix of the index columns.
#
# Suppose that an index my_idc includes three columns named col_a, col_b and col_c, in taht order.
#
# The HANDLER statement can specify values for all three columns in the index,
# or for the columns in a leftmost prefix. For example:
#
# 		HANDLER --- READ my_idx = (col_a_val, col_b_val, col_c_val) ---
# 		HANDLER --- READ my_idx = (col_a_val, col_b_val) ---
# 		HANDLER --- READ my_idx = (col_a_val) ---
#
# To employ the HANDLER interface to refer to a table's PRIMARY KEY, use the quoted
# identifier `PRIMARY`:
#
# 		HANDLER tbl_name READ `PRIMARY` ---
#
# The second HANDLER --- READ syntax fetches a row from the table in index order that
# matches the WHERE condition.
#
# The third HANDLER --- READ syntax fetches a row from the table in natural row order
# that matches the WHERE condition.
#
# It is faster than HANDLER tbl_name READ index_name when a full table scan is desired.
#
# Natural row order is the order in which rows are stored in a MyISAM table data file.
#
# This statement works for INnoDB tables as well, but there is no such concept because
# there is no separate data file.
#
# Without a LIMIT clause, all forms of HANDLER --- READ fetch a single row if one is 
# available.
#
# To return a specific number of rows, include a LIMIT clause.
#
# It has the same syntax as for the SELECT statement. See SECTION 13.2.10, "SELECT SYNTAX"
#
# HANDLER -- CLOSE closes a table that was opened with HANDLER --- OPEN
#
# There are several reasons to use the HANDLER interface instead of normal
# SELECT statements:
#
# 		) HANDLER is faster than SELECT
#
# 			) A desiganted storage engine handler object is allocated for the HANDLER --- OPEN.
#
# 				THe object is reused for subsequent HANDLER statements for that table;
# 				it need not be reinitialized for each one.
#
# 			) There is less parsing involved
#
# 			) There is no optimizer or query-checking overhead
#
# 			) The handler interface does not have to provide a consistent look of the data (for example,
# 				dirty reads are permitted), so the storage engine can use optimizations that SELECT
# 				does not normally permit.
#
# 		) HANDLER makes it easier to port to MySQL applications that use a low-level ISAM-like interface.
#
# 			(See SECTION 15.19, "INNODB MEMCACHED PLUGIN" for an alternative way to adapt applications
# 			that use the key-value store paradigm)
#
# 		) HANDLER enables you to traverse a database in a manner that is difficult (or even impossible)
# 			to accomplish with SELECT.
#
# 			The HANDLER interface is a more natural way to look at data when working with applications
# 			that provide an interactive user interface to the database.
#
# HANDLER is a somewhat low-level statement.
#
# For example, it does not provide consistency.
#
# That is, HANDLER --- OPEN does NOT take a snapshot of the table, and does NOT 
# lock the table.
#
# THis means that after a HANDLER --- OPEN statement is issued, table data can be modified 
# (by the current session or other sessions) and these modifications might be only
# partially visible to HANDLER --- NEXT or HANDLER --- PREV scans.
#
# An open handler can be closed and marked for reopen, in which case the handler loses
# its position in the table.
#
# This occurs when both of the following circumstances are true:
#
# 		) Any session executes FLUSH_TABLES or DDL statements on the handler's table
#
# 		) The session in which the handler is open executes non-HANDLER statements that use tables
#
# TRUNCATE_TABLE for a table closes all handlers for the table that were opened with HANDLER_OPEN
#
# If a table is flushed with FLUSH_TABLES_tbl_name_WITH_READ_LOCK was opened with HANDLER,
# the handler is implicitly flushed and loses its position.
#
# 13.2.5 IMPORT TABLE SYNTAX
#
# 		IMPORT TABLE FROM sdi_file [, sdi_file] ---
#
# The IMPORT_TABLE statement imports MyISAM tables based on information contained in .sdi
# (Serialized Dictionary Information) metadata files.
#
# IMPORT TABLE requires the FILE privilege to read the .sdi and table content files,
# and the CREATE privilege for the table to be created.
#
# Tables can be exported from one server using mysqldump to write a file of SQL statements
# and imported into another server using mysql to process the dump file.
#
# IMPORT TABLE provides a faster alternative using the "raw" table files
#
# Prior to import, the files that provide the table content must be placed in the 
# appropriate schema directory for the import server, and the .sdi file must be
# located in a directory accessible to the server.
#
# For example, the .sdi file can be placed in the directory named by the secure_file_priv
# system variable, or (if secure_file_priv is empty) in a directory under the server
# data directory.
#
# The following example describes how to export MyISAM tables named employees and
# managers from the hr schema of one server and import them into the hr schema of
# another server.
#
# The examples uses these assumptions (to perform a similar operaiton on your own system,
# modify the path names as called for):
#
# 		) For the export server, export_basedir represents its base directory, and its data directory
# 			is export_basedir/data
#
# 		) For the import server, import_basedir represents its base directory, and its data directory
# 			is import_basedir/data
#
# 		) Table files are exported from the export server into the /tmp/export directory and
# 			this directory is secure (not accessible to other users)
#
# 		) The import server uses /tmp/mysql-files as the directory named by its secure_file_priv
# 			system variable
#
# To export tables from the export server, use this procedure:
#
# 		1. Ensure a consistent snapshot by executing this statement to lock the tables so that they cannot
# 			be modified during export:
#
# 				FLUSH TABLES hr.employees, hr.managers WITH READ LOCK;
#
# 			While the lock is in effect, the tables can still be used, but only for read access.
#
# 		2. At the file system level, copy the .sdi and table content files from the hr schema directory
# 			to the secure export directory:
#
# 				) The .sdi file is located in the hr schema directory, but might not have exactly
# 					the same basename as the table name.
#
# 					For example, the .sdi files for the employees and managers tables might be named
# 					employees_125.sdi and managers_238.sdi
#
# 				) For a MyISAM table, the content files are its .MYD data file and .MYI index file
#
# 			Given those file names, the copy commands are:
#
# 				cd export_basedir/data/hr
# 				cp employees_125.sdi /tmp/export
# 				cp managers_238.sdi /tmp/export
# 				cp employees.{MYD,MYI} /tmp/export
# 				cp managers.{MYD,MYI} /tmp/export
#
# 		3. Unlock the tables:
#
# 			UNLOCK TABLES;
#
# To import tables into hte import server, use this procedure:
#
# 		1. The import schema must exist.
#
# 			If necessary, execute this statement to create it:
#
# 				CREATE SCHEMA hr;
#
# 		2. At the file system level, copy the .sdi files to the import server
# 			secure_file_priv directory, /tmp/mysql-files
#
# 			Also, copy the table content files to the hr schema directory:
#
# 				cd /tmp/export
# 				cp employees_125.sdi /tmp/mysql-files
# 				cp managers_238.sdi /tmp/mysql-files
# 				cp employees.{MYD,MYI} import_basedir/data/hr
# 				cp managers.{MYD,MYI} import_basedir/data/hr
#
# 		3. Import the tables by executing an IMPORT_TABLE statement that names the .sdi files:
#
# 			IMPORT TABLE FROM
# 				'/tmp/mysql-files/employees.sdi',
# 				'/tmp/mysql-files/managers.sdi';
#
# The .sdi file need not be placed in the import server directory named by the secure_file_priv
# system variable if that variable is empty; it can be in any directory accessible to the server,
# including the schema directory for the imported table.
#
# If the .sdi file is placed in that directory, however, it may be rewritten; the import
# operation creates a new .sdi file for hte table, which will overwrite the old .sdi file
# if hte operation uses the same file name for the new file.
#
# Each sdi_file value must be a string literal that names the .sdi file for a table
# or is a pattern that matches .sdi files.
#
# If the string is a pattern, any leading directory path and the .sdi file name
# suffix must be given literally.
#
# Pattern characters are permitted only in the base name part of the file name:
#
# 		) ? matches any single character
#
# 		) * matches any sequence of characters, including no characters
#
# Using a pattern, the previous IMPORT_TABLE statement could have been written like
# this (assuming that the /tmp/mysql-files directory contains no other .sdi files matching
# the pattern):
#
# 		IMPORT TABLE FROM '/tmp/mysql-files/*.sdi';
#
# To interpret the location of .sdi file path names, the server uses the same rules for
# IMPORT_TABLE as the server-side rules for LOAD_DATA (that is, the non-LOCAL rules)
#
# See SECTION 13.2.7, "LOAD DATA INFILE SYNTAX", paying particular attention to the
# rules used to interpret relative path names.
#
# IMPORT_TABLE fails if the .sdi or table files cannot be located.
#
# After importing a table, the server attempts to open it and reports
# as warnings any problems detected.
#
# To attempt a repair to correct any reported issues, use REPAIR_TABLE
#
# IMPORT_TABLE is not written to the binary log
#
# RESTRICTIONS AND LIMITATIONS
#
# IMPORT_TABLE applies only to non-TEMPORARY MyISAM tables.
#
# It does not apply to tables created with a transactional storage engine,
# tables created with CREATE_TEMPORARY_TABLE or views.
#
# The table data and index files must be placed in the schema directory for the
# import server prior to the import operation, unless the table as defined on the
# export server uses the DATA DIRECTORY or INDEX DIRECTORY table options.
#
# In that case, modify the import procedure using one of these alternatives
# before executing the IMPORT_TABLE statement:
#
# 		) Put the data and index files into the same directory on the import server
# 			host as on the export server host, and create symlinks in the import server
# 			schema directory to those files.
#
# 		) Put the data and index files into an import server host directory from that on the export
# 			server host, and create symlinks in the import server schema directory to those files.
#
# 			In addition, modify the .sdi file to reflect the different file locations
#
# 		) Put the data and index files into the schema directory on the import server host,
# 			and modify the .sdi file to remove the data and index directory table options.
#
# Any collation IDs stored in the .sdi file must refer to the same collations on the export
# and import servers.
#
# Trigger information for a table is not serialized into the table .sdi file, so triggers
# are not restored by the import operaiton
#
# Some edits to an .sdi file are permissible prior to executing the IMPORT_TABLE statement,
# whereas others are problematic or may even cause the import operation to fail:
#
# 		) Changing the data directory and index directory table options is required if the locations
# 			of the data and index files differ between the export and import servers.
#
# 		) Changing the schema name is required to import the table into a different schema on the import server
# 			tahn on the export server
#
# 		) Changing schema and table names may be required to accomodate differences between
# 			file system case-sensitivity semantics on the export and import servers or differences
# 			in lower_case_table_names settings.
#
# 			Changing the table names in the .sdi file may require renaming the tbale files as well
#
# 		) In some cases, changes to column definitions are permitted.
#
# 			Changing data types is likely to cause problems.
#
# 13.2.6 INSERT SYNTAX
#
# 13.2.6.1 INSERT --- SELECT SYNTAX
# 13.2.6.2 INSERT --- ON DUPLICATE KEY UPDATE SYNTAX
# 13.2.6.3 INSERT DELAYED SYNTAX
#
# 		INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
# 			[INTO] tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			[(col_name [, col_name] ---)]
# 			{VALUES | VALUE} (value_list) [, (value_list)] ---
# 			[ON DUPLICATE KEY UPDATE assignment_list]
#
# 		INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
# 			[INTO] tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			SET assignment_list
# 			[ON DUPLICATE KEY UPDATE assignment_list]
#
# 		INSERT [LOW_PRIORITY | HIGH_PRIORITY] [IGNORE]
# 			[INTO] tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			[(col_name [, col_name] ---)]
# 			SELECT ---
# 			[ON DUPLICATE KEY UPDATE assignment_list]
#
# 		value:
# 			{expr | DEFAULT}
#
# 		value_list:
# 			value [, value] ---
#
# 		assignment:
# 			col_name = value
#
# 		assignment_list:
# 			assignment [, assignment] ---
#
# INSERT inserts new rows into an existing table.
#
# The INSERT --- VALUES and INSERT --- SET forms of the statement insert rows based
# on explicitly specified values.
#
# The INSERT --- SELECT form inserts rows selected from another table or tables.
#
# INSERT with an ON DUPLICATE KEY UPDATE clause enables existing rows to be updated if
# a row to be inserted would cause a duplicate value in a UNIQUE index or PRIMARY KEY.
#
# For additional information about INSERT_---_SELECT and INSERT_---_ON_DUPLICATE_KEY_UPDATE,
# see SECTION 13.2.6.1, "INSERT --- SELECT SYNTAX", and SECTION 13.2.6.2, "INSERT --- ON DUPLICATE KEY UPDATE SYNTAX"
#
# In MySQL 8.0, the DELAYED keyword is accepted but ignored by the server.
#
# For the reasons for this, see SECTION 13.2.6.3, "INSERT DELAYED SYNTAX"
#
# Inserting into a table requires the INSERT privilege for the table. 
#
# If the ON DUPLICATE KEY UPDATE clause is used and a duplicate key causes an UPDATE to be performed instead, the statement
# requires the UPDATE privilege for the columns to be updated.
#
# For columns that are read but not modified you need only the SELECT privilege (such as for a column referenced only
# on the right hand side of an col_name=expr assignment in an ON DUPLICATE KEY UPDATE clause)
#
# When inserting into a partitioned table, you can control which partitions and subpartitions accept new rows.
#
# The PARTITION option takes a list of the comma-separated names of one or more partitions or subpartitions
# (or both) of the table.
#
# if any of hte rows to be inserted by a given INSERT statement do not match one of the partitions
# listed, the INSERT statement fails with the error:
#
# 		Found a row not matching the given partition set
#
# for more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# You can use REPLACE instead of INSERT to overwrite old rows.
#
# REPLACE is the counterpart to INSERT_IGNORE in teh treatment of new rows that
# contain unique key values that duplicate old rows:
#
# 		The new rows replace the old rows rather than being discarded.
#
# 		see SECTION 13.2.9, "REPLACE SYNTAX"
#
# tbl_name is the table into which rows should be inserted.
#
# Specify the columns for which the statement provides values as follows:
#
# 		) Provide a parenthesized list of comma-separated column names following
# 			the table name.
#
# 			In this case, a value for each named column must be provided by the 
# 			VALUES list or the SELECT statement.
#
# 		) If you do not specify a list of column names for INSERT_---_VALUES or
# 			INSERT_---_SELECT, values for every column in the table must be provided
# 			by the VALUES list or the SELECT statement.
#
# 			If you do not know the order of hte columns in the table, use DESCRIBE
# 			tbl_name to find out.
#
# 		) A SET clause indicates columns explicitly by name, together with the value
# 			to assign each one.
#
# Column values can be given in several ways:
#
# 		) If strict SQL mode is not enabled, any column not explicitly given a value is set
# 			to its default (explicit or implicit) value.
#
# 			For example, if you specify a column list that does not name all the columns
# 			in the table, unnamed columns are set to their default values.
#
# 			Default value assignment is described in SECTION 11.7, "DATA TYPE DEFAULT 
# 			VALUES"
#
# 			See also SECTION 1.8.3.3, "CONSTRAINTS ON INVALID DATA"
#
# 			If strict SQL mode is enabled, an INSERT statement generates an error
# 			if it does not specify an explicit value for every column that has no default
# 			value.
#
# 			See SECTION 5.1.11, "SERVER SQL MODES"
#
# 		) If both the column list and the VALUES list are empty, INSERT creates a row
# 			with each column set to its default value:
#
# 				INSERT INTO tbl_name () VALUES();
#
# 			If strict mode is not enabled, MySQL uses the implicit default value for any
# 			column that has no explicitly defined default.
#
# 			If strict mode is enabled, an error occurs if any column has no default value.
#
# 		) Use the keyword DEFAULT to set a column explicitly to its default value.
#
# 			This makes it easier to write INSERT statements that assign values to all
# 			but a few columns, because it enables you to avoid writing an incomplete VALUES
# 			list taht does not include a value for each column in the table.
#
# 			Otherwise, you must provide the list of column names corresponding to each
# 			value in the VALUES list.
#
# 		) If a generated column is inserted into explicitly, the only permitted value is DEFAULT.
#
# 			For information about generated columns, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
#
# 		) In expressions, you can use DEFAULT(col_name) to produce the default value for column col_name.
#
# 		) Type conversions of an expression expr that provides a column value might occur if the 
# 			expression data type does not match the column data type.
#
# 			Conversion of a given value can result in different inserted values depending on the column
# 			type.
#
# 			For example, inserting the string '1999.0e-2' into an INT, FLOAT, DECIMAL(10,6) or
# 			YEAR column inserts the value 1999, 19.9921, 19.992100, or 1999, respectively.
#
# 			The value stored in the INT and YEAR columns is 1999 because the string-to-number
# 			conversion looks only at as much of the initial part of the string as may be 
# 			considered a valid integer or year.
#
# 			For the FLOAT and DECIMAL columns, the string-to-number conversion considers the
# 			entire string a valid numeric value.
#
# 		) An expression expr can refer to any column that was set earlier in a value list.
#
# 			For example, you can do this because the value for col2 refers to col1, which has
# 			previously been assigned:
#
# 				INSERT INTO tbl_name (col1,col2) VALUES(15,col1*2);
#
# 			But the following is not legal, because the value for col1 refers to col2,
# 			which is assigned after col1:
#
# 				INSERT INTO tbl_name (col1, col2) VALUES(col2*2,15);
#
# 			An exception occurs for columns that contain AUTO_INCREMENT values.
#
# 			Because AUTO_INCREMENT values are generated after other value assignments,
# 			any reference to an AUTO_INCREMENT column in the assignment returns a 0.
#
# INSERT statements that use VALUES syntax can insert multiple rows.
#
# To do this, include multiple lists of comma-separated column values, with lists
# enclosed within parentheses and separated by commas.
#
# Example:
#
# 		INSERT INTO tbl_name (a,b,c) VALUES(1,2,3),(4,5,6),(7,8,9);
#
# Each value list must contain exactly as many values as are to be inserted per row.
#
# The following statement is invalid because it contains one list of nine values,
# rather than three lists of three values each:
#
# 		INSERT INTO tbl_name (a,b,c) VALUES(1,2,3,4,5,6,7,8,9);
#
# VALUE is a synonym for VALUES in this context.
#
# Neither implies anything about hte number of values lists, nor about the number of
# values per list.
#
# Either may be used whether there is a single values list or multiple lists, and
# regardless of the number of values per list.
#
# The affected-rows value for an INSERT can be obtained using the ROW_COUNT() SQL
# function or the mysql_affected_rows() C API function.
#
# See SECTION 12.15, "INFORMATION FUNCTIONS" and SECTION 28.7.7.1, "MYSQL_AFFECTED_ROWS()"
#
# If you use an INSERT_---_VALUES statement with multiple value lists or INSERT_---_SELECT,
# the statement returns an information string in this format:
#
# 		Records: N1 Duplicates: N2 Warnings: N3
#
# If you are using the C API, the information string can be obtained by invoking the
# mysql_info() function.
#
# See SECTION 28.7.7.36, "MYSQL_INFO()"
#
# Records indicate the number of rows processed by the statement.
#
# (This is not necessarily the number of rows actually inserted because 
# Duplicates can be nonzero)
#
# Duplicates indicates the number of rows that could not be inserted because they would
# duplicate some existing unique index value.
#
# Warnings indicate the number of attempts to insert column values that were problematic
# in some way.
#
# Warnings can occur under any of the following conditions:
#
# 		) Inserting NULL into a column that has been declared NOT NULL.
#
# 			For multiple-row INSERT statements or INSERT_INTO_---_SELECT statements,
# 			the column is set to the implicit default value for the column data type.
#
# 			This is 0 for numeric types, the empty string ('') for string types, and the
# 			"zero" value for date and time types.
#
# 			INSERT INTO --- SELECT statements are handled the same way as multiple-row inserts
# 			because the server does not examine the result set from the SELECT to see whether it
# 			returns a single row.
#
# 			(For a single-row INSERT, no warning occurs when NULL is inserted into a NOT NULL column.
#
# 			Instead, the statement fails with an error)
#
# 		) Setting a numeric column to a value that lies outside the column's range.
#
# 			The value is clipped to the closest endpoint of the range.
#
# 		) Assigning a value such as '10.34 a' to a numeric column.
#
# 			The trailing nonnumeric text is stripped off and the remaining numeric part
# 			is inserted.
#
# 			If the string value has no leading numeric part, the column is set to 0.
#
# 		) Inserting a string into a string column (CHAR, VARCHAR, TEXT or BLOB) that exceeds
# 			the column's maximum length.
#
# 			The value is truncated to the column's maximum length
#
# 		) Inserting a value into a date or time column that is illegal for the data type.
#
# 			The column is set to the appropriate zero value for the type.
#
# 		) For INSERT examples involving AUTO_INCREMENT column values, see SECTION 3.6.9, "USING AUTO_INCREMENT"
#
# 			If INSERT inserts a row into a table that has an AUTO_INCREMENT column, you can find
# 			the value used for that column by using the LAST_INSERT_ID() SQL function or the
# 			mysql_insert_id() C API function.
#
# 				NOTE:
#
# 					These two functions do not always behave identically.
#
# 					The behavior of INSERT statements with respect to AUTO_INCREMENT columns is discussed
# 					further in SECTION 12.15, "INFORMATION FUNCTIONS", and SECTION 28.7.7.38, "MYSQL_INSERT_ID()"
#
# The INSERT statement supports the following modifiers:
#
# 		) if you use the LOW_PRIORITY modifier, execution of the INSERT is delayed until no other
# 			clients are reading from the table.
#
# 			This includes other clients that began reading while existing clients are reading;
# 			and while the INSERT LOW_PRIORITY statement is waiting.
#
# 			It is possible, therefore, for a client that issues an INSERT LOW_PRIORITY
# 			statement to wait or a very long time.
#
# 			LOW_PRIORITY affects only storage engines that use only table-level locking 
# 			(such as MyISAM, MEMORY, and MERGE)
#
# 			NOTE:
#
# 				LOW_PRIORITY should normally not be used with MyISAM tables because doing so
# 				disables concurrent inserts.
#
# 				See SECTION 8.11.3, "CONCURRENT INSERTS"
#
# 		) If  you specify HIGH_PRIORITY, it overrides the effect of the --low-priority-updates option if
# 			the server was started with that option.
#
# 			It also causes concurrent inserts not to be used.
#
# 			See SECTION 8.11.3, "CONCURRENT INSERTS"
#
# 			HIGH_PRIORITY affects only storage engines that use only table-level locking
# 			(such as MyISAM, MEMORY, and MERGE)
#
# 		) If you use the IGNORE modifier, errors that occur while executing the INSERT statement
# 			are ignored.
#
# 			For example, without IGNORE, a row that duplicates an existing UNIQUE index or PRIMARY KEY
# 			value in the table causes a duplicate-key error and the statement is aborted.
#
# 			With IGNORE, the row is discarded and no error occurs.
#
# 			Ignored errors generate warnings instead.
#
# 			IGNORE has a similar effect on inserts into partitioned tables where no partition matching
# 			a given value is found.
#
# 			Without IGNORE, such INSERT statements are aborted with an error.
#
# 			When INSERT_IGNORE is used, the insert operation fails silently for rows containing
# 			the unmatched value, but inserts rows that are matched.
#
# 			For an example, see SECTION 23.2.2, "LIST PARTITIONING"
#
# 			Data conversions that would trigger errors abort the statement if IGNORE is not specified.
#
# 			With IGNORE, invalid values are adjusted to the closest values and inserted;
# 			warnings are produced but the statement does not abort.
#
# 			You can determine with the mysql_info() C API function how many rows were actually
# 			inserted into the table.
#
# 			For more information, see COMPARISON OF THE IGNORE KEYWORD AND STRICT SQL MODE
#
# 		) If you specify ON DUPLICATE KEY UPDATE, and a row is inserted that would cause a duplicate value
# 			in a UNIQUE index or PRIMARY KEY, an UPDATE of the old row occurs.
#
# 			The affected-rows value per row is 1 if the row is inserted as a new row, 2 if an existing
# 			row is updated, and 0 if an existing row is set to its current values.
#
# 			If you specify the CLIENT_FOUND_ROWS flag to the mysql_real_connect() C API function
# 			when connecting to mysqld, the affected-rows value is 1 (not 0) if an existing row
# 			is set to its current values.
#
# 			See SECTION 13.2.6.2, "INSERT --- ON DUPLICATE KEY UPDATE SYNTAX"
#
# 		) INSERT_DELAYED was deprecated in MySQL 5.6, and is scheduled for eventual removal.
#
# 			In MySQL 8.0, the DELAYED modifier is accepted but ignored.
#
# 			Use INSERT (without DELAYED) instead. See SECTION 13.2.6.3, "INSERT DELAYED SYNTAX"
#
# An INSERT statement affecting a partitioned table using a storage engine such as MyISAM that
# employs table-level locks locks only those partitions into which rows are actually inserted.
#
# (For storage engines such as InnoDB that employ row-level locking, no locking of partitions takes place)
#
# For more information, see PARTITIONING AND LOCKING.
#
# 13.2.6.1 INSERT --- SELECT SYNTAX
#
# 		INSERT [LOW_PRIORITY | HIGH_PRIORITY] [IGNORE]
# 			[INTO] tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			[(col_name [, col_name] ---)]
# 			SELECT
# 			[ON DUPLICATE KEY UPDATE assignment_list]
#
# 		value:
# 			{expr | DEFAULT}
#
# 		assignment:
# 			col_name = value
#
# 		assignment_list:
# 			assignment [, assignment]
#
# With INSERT_---_SELECT, you can quickly insert many rows into a table from the result
# of a SELECT statement, which can select from one or many tables.
#
# For example:
#
# 		INSERT INTO tbl_temp2 (fld_id)
# 			SELECT tbl_temp1.fld_order_id
# 			FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
#
# The following conditions hold for INSERT_---_SELECT statements:
#
# 		) Specify IGNORE to ignore rows that would cause duplicate-key violations
#
# 		) The target table of the INSERT statement may appear in the FROM clause of the
# 			SELECT part of the query.
#
# 			However, you cannot insert into a table and select from the same table in a
# 			subquery.
#
# 			When selecting from and inserting into the same table, MySQL creates an internal
# 			temporary table to hold the rows from the SELECT and then inserts those rows
# 			into the target table.
#
# 			However, you cannot use INSERT INTO t --- SELECT --- FROM t when t is a TEMPORARY
# 			table, because TEMPORARY tables cannot be referred to twice in the same statement.
#
# 			See SECTION 8.4.4, "INTERNAL TEMPORARY TABLE USE IN MYSQL", and SECTION B.6.6.2,
# 			"TEMPORARY TABLE PROBLEMS"
#
# 		) AUTO_INCREMENT columns work as usual
#
# 		) To ensure that the binary log can be used to re-create the original tables,
# 			MySQL does not permit concurrent inserts for INSERT_---_SELECT statements
# 			(see SECTION 8.11.3, "CONCURRENT INSERTS")
#
# 		) To avoid ambiguous column reference problems when the SELECT and the INSERT
# 			refer to the same table, provide a unique alias for each table used in the 
# 			SELECT part, and qualify column names in that part with the appropriate alias.
#
# You can explicitly select which partitions or subpartitions (or both) of the source or target
# table (or both) are to be used with a PARTITION option following the name of the table.
#
# When PARTITION is used with the name of the source table in the SELECT portion of the statement,
# rows are selected only from the partitions or subpartitions named in its partition list.
#
# When PARTITION is used with the name of the target table for the INSERT portion of the statement,
# it must be possible to insert all rows selected into the partitions or subpartitions named in the
# partition list following the option.
#
# Otherwise, the INSERT --- SELECT statement fails.
#
# For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# For INSERT_---_SELECT statements, see SECTION 13.2.6.2, "INSERT --- ON DUPLICATE KEY UPDATE SYNTAX"
# for conditions under which the SELECT columns can be referred to in an ON DUPLICATE KEY UPDATE clause.
#
# The order in which a SELECT statement with no ORDER BY clause returns rows is nondeterminsitic.
#
# This means that, when using replication, there is no guarantee that such a SELECT returns rows
# in the same order on the master and the slave, which can lead to inconsistencies between them.
#
# To prevent this from occurring, always write INSERT --- SELECT statements that are to be replicated
# using an ORDER BY clause that produces the same row order on the master and the slave.
#
# See also SECTION 17.4.1.18, "REPLICATION AND LIMIT"
#
# Due to this issue, INSERT_---_SELECT_ON_DUPLICATE_KEY_UPDATE and INSERT_IGNORE_---_SELECT
# statements are flagged as unsafe for statement-based replication.
#
# Such statements produce a warning in the error log when using statement-based mode
# and are written to the binary log using the row-based formats when using MIXED
# mode. (Bug #11758262, Bug #50439)
#
# See also SECTION 17.2.1.1, "ADVANTAGES AND DISADVANTAGES OF STATEMENT-BASED AND ROW-BASED REPLICATION"
#
# An INSERT_---_SELECT statement affecting partitioned tables using a storage engine such as
# MyISAM that employs table-level locks locks all partitions of the target table;
# However, only those partitions that are actually read from the source table are locked.
#
# (This does not occur with tables using storage engines such as InnoDB that employ
# row-level locking)
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.6.2 INSERT --- ON DUPLICATE KEY UPDATE SYNTAX
#
# If you specify an ON DUPLICATE KEY UPDATE clause and a row to be inserted would cause a 
# duplicate value in a UNIQUE index or PRIMARY KEY, an UPDATE of the old row occurs.
#
# For example, if column a is declared as UNIQUE and contains the value 1, the following
# two statements have similar effect:
#
# 		INSERT INTO t1 (a,b,c) VALUES (1,2,3)
# 			ON DUPLICATE KEY UPDATE c=c+1;
#
# 		UPDATE t1 SET c=c+1 WHERE a=1;
#
# (The effects are not identical for an InnoDB table where a is an auto-increment column.
#
# With an auto-increment column, an INSERT statement increases the auto-increment
# value but UPDATE does not)
#
# If column b is also unique, the INSERT is equivalent to this UPDATE statement instead:
#
# 		UPDATE t1 SET c=c+1 WHERE a=1 OR b=2 LIMIT 1;
#
# If a=1 OR b=2 matches several rows, only one row is updated.
#
# In general, you should try to avoid using an ON DUPLICATE KEY UPDATE clause
# on tables with multiple unique indexes.
#
# With ON DUPLICATE KEY UPDATE, the affected-rows value per row is 1 if the row
# is inserted as a new row, 2 if an existing row is updated, and 0 if an existing
# row is set to its current values.
#
# If you specify the CLIENT_FOUND_ROWS flag to the mysql_real_connect() C API function
# when connecting to mysqld, the affected-rows value is 1 (not 0) if an existing
# row is set to its current values.
#
# If a table contains an AUTO_INCREMENT column and INSERT_---_ON_DUPLICATE_KEY_UPDATE inserts
# or updates a row, the LAST_INSERT_ID() function returns the AUTO_INCREMENT value.
#
# The ON DUPLICATE KEY UPDATE clause can contain multiple column assignments,
# separated by commas.
#
# In assignment value expressions in the ON DUPLICATE KEY UPDATE clause, you can use
# the VALUES(col name) function to refer to column values from the INSERT portion
# of the INSERT_---_ON_DUPLICATE_KEY_UPDATE statement.
#
# In other words, VALUES(col_name) in the ON DUPLICATE KEY UPDATE clause refers
# to the value of col_name that would be inserted, had no duplicate-key conflict
# occurred.
#
# This function is especially useful in multiple-row inserts.
#
# The VALUES() function is meaningful only in the ON DUPLICATE KEY UPDATE clause
# or INSERT statements and returns NULL otherwise. Example:
#
# 		INSERT INTO t1 (a,b,c) VALUES (1,2,3),(4,5,6)
# 			ON DUPLICATE KEY UPDATE c=VALUES(a)+VALUES(b);
#
# That statement is identical to the following two statements:
#
# 		INSERT INTO t1 (a,b,c) VALUES (1,2,3)
# 			ON DUPLICATE KEY UPDATE c=3;
#
# 		INSERT INTO t1 (a,b,c) VALUES (4,5,6)
# 			ON DUPLICATE KEY UPDATE c=9;
#
# For INSERT_---_SELECT statements, these rules apply regarding acceptable forms
# of SELECT query expressions that you can refer to in an ON DUPLICATE KEY UPDATE
# clause:
#
# 		) References to columns from queries on a single table, which may be a derived table
#
# 		) References to columns from queries on a join over multiple tables
#
# 		) References to columns from DISTINCT queries
#
# 		) References to columns in other tables, as long as the SELECT does not use GROUP BY.
#
# 			One side effect is that you must qualify references to nonunique column names.
#
# References to columns from a UNION are not supported.
#
# To work around this restriction, rewrite the UNION as a derived table so that its rows
# can be treated as a single-table result set.
#
# For example, this statement produces an error:
#
# 		INSERT INTO t1 (a, b)
# 			SELECT c, d FROM t2
# 			UNION
# 			SELECT e, f FROM t3
# 		ON DUPLICATE KEY UPDATE b = b + c;
#
# Instead, use an equivalent statement that rewrites the UNION as a derived table:
#
# 		INSERT INTO t1 (a, b)
# 		SELECT * FROM
# 			(SELECT c, d FROM t2
# 			UNION
# 			SELECT e, f FROM t3) AS dt
# 		ON DUPLICATE KEY UPDATE b = b + c;
#
# The technique of rewriting a query as a derived table also enables references
# to columns from GROUP BY queries.
#
# Because the results of INSERT_---_SELECT statements depend on the ordering of rows
# from the SELECT and this order cannot always be guaranteed, it is possible when
# logging INSERT_---_SELECT_ON_DUPLICATE_KEY_UPDATE statements for the master
# and the slave to diverge.
#
# Thus, INSERT_---_SELECT_ON_DUPLICATE_KEY_UPDATE statements are flagged as unsafe
# for statement-based replication.
#
# Such statements produce a warning in the error log when using statement-based mode
# and are written to the binary log using the row-based format when using MIXED mode.
#
# An INSERT_---_ON_DUPLICATE_KEY_UPDATE statement against a table having more than
# one unique or primary key is also marked as unsafe. (Bug #117655650, Bug #58637)
#
# See also SECTION 17.2.1.1, "ADAVANTAGES AND DISADVANTAGES OF STATEMENT-BASED AND 
# ROW-BASED REPLICATION"
#
# An INSERT --- ON DUPLICATE KEY UPDATE on a partitioned table using a storage engine
# such as MyISAM that employs table-level locks locks any partitions of the table
# in which a partitioning key column is updated.
#
# (This does not occur with tables using storage engines such as InnoDB that employ
# row-level locking)
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.6.3 INSERT DELAYED SYNTAX
#
# INSERT DELAYED ---
#
# The DELAYED option for the INSERT statement is a MySQL extension to standard SQL
#
# In previous versions of MySQL, it can be used for certain kinds of tables (such as
# MyISAM), such that when a client uses INSERT_DELAYED, it gets an okay from the server
# at once, and the row is queued to be inserted when the table is not in use by any
# other thread.
#
# DELAYED inserts and replaces were deprecated in MySQL 5.6
#
# In MySQL 8.0, DELAYED is not supported.
#
# The server recognizes but ignores the DELAYED keyword, handles the insert
# as a nondelayed insert, and generates an ER_WARN_LEGACY_SYNTAX_CONVERTED
# warning ("INSERT DELAYED is no longer supported. The statement was converted to INSERT")
#
# The DELAYED keyword is scheduled for removal in a future release.
#
# 13.2.7 LOAD DATA INFILE SYNTAX
#
# 		LOAD DATA [LOW_PRIORITY | CONCURRENT] [LOCAL] INFILE 'file_name'
# 			[REPLACE | IGNORE]
# 			INTO TABLE tbl_name
# 			[PARTITION (partition_name [, partition_name] ---)]
# 			[CHARACTER SET charset_name]
# 			[{FIELDS | COLUMNS}
# 				[TERMINATED BY 'string']
# 				[[OPTIONALLY] ENCLOSED BY 'char']
# 				[ESCAPED BY 'char']
# 			]
# 			[LINES
# 				[STARTING BY 'string']
# 				[TERMINATED BY 'string']
# 			]
# 			[IGNORE number {LINES | ROWS}]
# 			[(col_name_or_user_var
# 				[,col_name_or_user_var] ---)]
# 			[SET col_name={expr | DEFAULT},
# 				[, col_name={expr | DEFAULT}] ---]
#
# The LOAD_DATA_INFILE statement reads rows from a text file into a table at 
# a very high speed.
#
# LOAD_DATA_INFILE is the complement of SELECT_---_INTO_OUTFILE 
#
# (See SECTION 13.2.10.1, "SELECT --- INTO SYNTAX")
#
# To write data from a table to a file, use SELECT_---_INTO_OUTFILE
#
# To read the file back into a table, use LOAD_DATA_INFILE 
#
# The syntax of the FIELDS and LINES clauses is the same for both statements
#
# You can also load data files by using the mysqlimport utility;
#
# See SECTION 4.5.5, "MYSQLIMPORT -- A DATA IMPORT PROGRAM"
#
# mysqlimport operates by sending a LOAD_DATA_INFILE statement to the server.
#
# The --local option causes mysqlimport to read data files from the client host.
#
# You can specify the --compress option to get better performance over slow
# networks if the client and server support the compressed protocol.
#
# For more information about the efficiency of INSERT versus LOAD_DATA_INFILE and
# speeding up LOAD_DATA_INFILE, see SECTION 8.2.5.1, "OPTIMIZING INSERT STATEMENTS"
#
# 		) PARTITIONED TABLE SUPPORT
#
# 		) INPUT FILE NAME, LOCATION, AND CONTENT INTERPRETATION
#
# 		) CONCURRENCY CONSIDERATIONS
#
# 		) DUPLICATE-KEY HANDLING
#
# 		) INDEX HANDLING
#
# 		) FIELD AND LINE HANDLING
#
# 		) COLUMN LIST SPECIFICATION
#
# 		) INPUT PREPROCESSING
#
# 		) STATEMENT RESULT INFORMATION
#
# 		) MISCELLANEOUS TOPICS
#
# PARTITIONED TABLE SUPPORT
#
# LOAD DATA supports explicit partition selection using the PARTITION option with
# a list of one or more comma-separated names of partitions, subpartitions, or both.
#
# When this option is used, if any rows from the file cannot be inserted into any of
# the partitions or subpartitions named in the list, the statement fails with the
# error:
#
# 		Found a row not matching the given partition set
#
# For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# For partitioned tables using storage engines taht employ table locks, such as
# MyISAM, LOAD DATA cannot prune any partition locks.
#
# This does not apply to tables using storage engines which employ row-level
# locking, such as InnoDB.
#
# For more information, see PARTITIONING AND LOCKING.
#
# INPUT FILE NAME, LOCATION AND CONTENT INTERPRETATION
#
# The file name must be given as a literal string.
#
# On Windows, specify backslashes in path names as forward slashes or doubled
# backslashes.
#
# The character_set_filesystem system variable controls the interpretation of
# the file name character set.
#
# The server uses the character set indicated by the character_set_database system
# variable to interpret the information in the file.
#
# SET_NAMES and the setting of character_set_client do not affect interpretation of
# input.
#
# If the contents of the input file use a character set that differs from teh default,
# it is usually preferable to specify the character set of the files by using the
# CHARACTER SET clause.
#
# A character set of binary specifies "no conversion"
#
# LOAD_DATA_INFILE interprets all fields in the file as having the same character set,
# regardless of hte data types of the columns into which field values are loaded.
#
# For proper interpretation of file contents, you must ensure that it was written
# with the correct character set.
#
# For example, if you write a data file with mysqldump -T or by issuing
# a SELECT_---_INTO_OUTFILE statement in Mysql, be sure to use a --default-character-set
# option so that output is written in the character set to be used when the file
# is loaded with LOAD_DATA_INFILE.
#
# 	NOTE:
#
# 		It is not possible to load data files that use the ucs2, utf16, utf16le, or utf32 character set.
#
# CONCURRENCY CONSIDERATIONS
#
# If you use LOW_PRIORITY, execution of the LOAD_DATA statement is delayed until no other clients
# are reading from the table.
#
# This affects only storage engines that use only table-level locking (such as MyISAM, MEMORY and MERGE)
#
# If you specify CONCURRENT with a MyISAM table that satisfies the condition for the concurrent
# inserts (that is, it contains no free blocks in the middle), other threads can retrieve
# data from the table while LOAD_DATA is executing.
#
# This option affects the performance of LOAD_DATA a bit, even if no other thread
# is using the table at the same time.
#
# With row-based replication, CONCURRENT is replicated regardless of MySQL version.
#
# With statement-based replication CONCURRENT is not replicated prior to MySQL 5.5.1
# (see Bug #34628)
#
# For more information, see SECTION 17.4.1.19,, "REPLICATION AND LOAD DATA INFILE"
#
# The LOCAL keyword affects expected location of the file and error handling, as described
# later.
#
# LOCAL works only if your server and your client both have been configured to permit it.
#
# For example, if mysqld was started with the local_infile system variable disabled,
# LOCAL does not work.
#
# See SECTION 6.1.6, "SECURITY ISSUES WITH LOAD DATA LOCAL"
#
# The LOCAL keyword affects where the file is expected to be found:
#
# 		) If LOCAL is specified, the file is read by the client program on the client
# 			host and sent to the server.
#
# 			The file can be given as a full path name to specify its exact location.
#
# 			If given as a relative path name, the name is interpreted relative to the
# 			directory in which the client program was started.
#
# 			When using LOCAL with LOAD_DATA, a copy of the file is created in the directory
# 			where the MySQL server stores temporary files.
#
# 			See SECTION B.6.3.5, "WHERE MySQL STORES TEMPORARY FILES"
#
# 			Lack of sufficient space for the copy in this directory can cause the LOAD_DATA_LOCAL
# 			statement to fail.
#
# 		) If LOCAL is not specified, the file must be located on the server host and is read directly
# 			by the server.
#
# 			The server uses the following rules to locate the file:
#
# 				) If the file name is an absolute path name, the server uses it as given
#
# 				) If the file name is a relative path name with one or more leading components,
# 					the server searches for the file relative to the server's data directory.
#
# 				) If a file name with no leading components is given, the server looks for the file
# 					in the database directory of the default database.
#
# In the non-LOCAL case, these rules mean that a file named as ./myfile.txt is read from the
# server's data directory, whereas the file named as myfile.txt is read from the database
# directory of the default database.
#
# For example, if db1 is the default database, the following LOAD_DATA statement reads the
# file data.txt from the database directory for db1, even though the statement explicitly
# loads the file into a table in the db2 database:
#
# 		LOAD DATA INFILE 'data.txt' INTO TABLE db2.my_table;
#
# NOTE:
#
# 		The server also uses the non-LOCAL rules to locate .sdi files for the IMPORT_TABLE statement
#
# Non-LOCAL load operations read text files located on the server.
#
# For security reasons, such operations require that you have the FILE privilege.
#
# See SECTION 6.2.1, "PRIVILEGES PROVIDED BY MYSQL"
#
# Also, non-LOCAL load operations are subject to the secure_file_priv system variable
# setting.
#
# If the variable value is a nonempty directory name, the file to be loaded must be located
# in that directory.
#
# If the variable value is empty (which is insecure), the file need only be readable by the server.
#
# Using LOCAL is a bit slower than letting the server access the files directly, because the contents
# of the file must be sent over the connection by the client to the server.
#
# On the other hand, you do not need the FILE privilege to load local files.
#
# LOCAL also affects error handling:
#
# 		) With LOAD_DATA_INFILE, data-interpretation and duplicate-key errors terminate the operation
#
# 		) With LOAD_DATA_LOCAL_INFILE, data-interpretation and duplicate-key errors become warnings and 
# 			the operation continues because the server has no way to stop transmission of the file
# 			in the middle of the operation.
#
# 			For duplicate-key errors, this is the same as if IGNORE is specified.
#
# 			IGNORE is explained further later in this section.
#
# DUPLICATE-KEY HANDLING
#
# The REPLACE and IGNORE keywords control handling of input rows that duplicate existing rows
# on unique key values:
#
# 		) If you specify REPLACE, input rows replace existing rows.
#
# 			In other words, rows that have the same value for a primary key or unique index
# 			as an existing row.
#
# 			See SECTION 13.2.9, "REPLACE SYNTAX"
#
# 		) If you specify IGNORE, rows that duplicate an existing row on a unique key value
# 			are discarded.
#
# 			For more information, see COMPARISON OF THE IGNORE KEYWORD AND STRICT SQL MODE
#
# 		) If you do not specify either option, the behavior depends on whether the LOCAL keyword
# 			is specified.
#
# 			Without LOCAL, an error occurs when a duplicate key value is found, and the rest of
# 			the text file is ignored.
#
# 			With LOCAL, the default behavior is the same as if IGNORE is specified;
#
# 			This is because the server has no way to stop transmission of the file in the
# 			middle of the operation.
#
# INDEX HANDLING
#
# To ignore foreign key constraints during the load operation, issue a SET foreign_key_checks = 0
# statement before executing LOAD_DATA
#
# If you use LOAD_DATA_INFILE on an empty MyISAM table, all nonunique indexes are created
# in a separate batch (as for REPAIR TABLE)
#
# Normally, this makes LOAD_DATA INFILE much faster when you have many indexes.
#
# In some extreme cases, you can create the indexes even faster by turning them
# off with ALTER TABLE --- DISABLE KEYS before loading the file into the table
# and using ALTER TABLE --- ENABLE KEYS to re-create the indexes after loading
# the file.
#
# See SECTION 8.2.5.1, "OPTIMIZING INSERT STATEMENTS"
#
# FILE AND LINE HANDLING
#
# For both the LOAD_DATA_INFILE and SELECT_---_INTO_OUTFILE statements, the syntax
# of the FIELDS and LINES clauses is the same.
#
# Both clauses are optional, but FIELDS must precede LINES if both are specified.
#
# If you specify a FIELDS clause, each of its subclauses (TERMINATED BY, [OPTIONALLY]
# ENCLOSED BY, and ESCAPED BY) is also optional, except that you must specify
# at least one of them. 
# 
# Arguments to these clauses are permitted to contain only ASCII characters.
#
# If you specify no FIELDS or LINES clause, the defaults are the same as if you had
# written this:
#
# 		FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\'
# 		LINES TERMINATED BY '\n' STARTING BY ''
#
# (Backslash is the MySQL escape character within strings in SQL statements, so to specify
# a literal backslash, you must specify two backslashes for the value to be interpreted
# as a single backslash.
#
# The escape sequences '\t' and '\n' specify tab and newline characters, respectively.)
#
# In other words, the default cause LOAD_DATA_INFILE to act as follows when reading input:
#
# 		) Look for line boundaries at newlines
#
# 		) Do not skip over any line prefix
#
# 		) Break lines into fields at tabs
#
# 		) Do not expect fields to be enclosed within any quoting characters
#
# 		) Interpret characters preceded by the escape character \ as escape sequences.
#
# 			For example, \t, \n, and \\ signify tab, newline, and backslash, respectively.
#
# 			See the discussion of FIELDS ESCAPED BY later for the full list of escape sequences.
#
# Conversely, the defaults cause SELECT_---_INTO_OUTFILE to act as follows when writing output:
#
# 		) Write tabs between fields
#
# 		) Do not enclose fields within any quoting characters
#
# 		) Use \ to escape instances of tab, newline, or \ that occur within field values.
#
# 		) Write newlines at the ends of lines.
#
# NOTE:
#
# 		If you have generated the text file on a Windows system, you might have to use LINES TERMINATED
# 		BY '\r\n' to read the file properly because Windows programs typically use two characters
# 		as a line terminator.
#
# 		Some programs, such as WordPad, might use \r as a line terminator when writing files
#
# 		To read such files, use LINES TERMINATED BY '\r'
#
# If all the lines you want to read in have a common prefix that you want to ignore, you can use
# LINES STARTING BY 'prefix_string' to skip over the prefix, and anything before it.
#
# If a line does not include the prefix, the entire line is skipped.
#
# Suppose that you issue the following statement:
#
# 		LOAD DATA INFILE '/tmp/test.txt' INTO TABLE test
# 			FIELDS TERMINATED BY ',' LINES STARTING BY 'xxx';
#
# If the data file looks like this:
#
# 		xxx"abc",1
# 		something xxx"def",2
# 		"ghi",3
#
# The resulting rows will be ("abc",1) and ("def",2)
#
# The third row in the file is skipped because it does not contain the prefix.
#
# The IGNORE number LINES option can be used to ignore lines at the start of the file.
#
# For example, you can use IGNORE 1 LINES to skip over an initial header line containing
# column names:
#
# 		LOAD DATA INFILE '/tmp/test.txt' INTO TABLE test IGNORE 1 LINES;
#
# When you use SELECT_---_INTO_OUTFILE in tandem with LOAD_DATA_INFILE to write data
# from a database into a file and then read the file back into the database later,
# the field- and line-handling options for both statements must match.
#
# Otherwise, LOAD_DATA_INFILE will not interpret the contents of the file properly.
#
# Suppose that you use SELECT_---_INTO_OUTFILE to write a file with fields delimited
# by commas:
#
# 		SELECT * INTO OUTFILE 'data.txt'
# 			FIELDS TERMINATED BY ','
# 			FROM table2;
#
# To read the comma-delimited file back in, the correct statement would be:
#
# 		LOAD DATA INFILE 'data.txt' INTO TABLE table2
# 			FIELDS TERMINATED BY ',';
#
# If instead you tried to read in the file with the statement shown following,
# it would not work because it instructs LOAD_DATA_INFILE to look for tabs
# between fields:
#
# 		LOAD DATA INFILE 'data.txt' INTO TABLE table2
# 			FIELDS TERMINATED BY '\t';
#
# The likely result is that each input line would be interpreted as a single field.
#
# LOAD_DATA_INFILE can be used to read files obtained from external sources.
#
# For example, many programs can export data in comma-separated values (CSV) format,
# such that lines have fields separated by commas and enclosed within double quotation
# marks, with an initial line of column names.
#
# If the lines in such a file are terminated by carriage return/newline pairs,
# the statement shown here illustrates the field- and line-handling options
# you would use to load the file:
#
# 		LOAD DATA INFILE 'data.txt' INTO TABLE tbl_name
# 			FIELDS TERMINATED BY ',' ENCLOSED BY '"'
# 			LINES TERMINATED BY '\r\n'
# 			IGNORE 1 LINES;
#
# If the input values are not necessarily enclosed within quotation marks,
# use OPTIONALLY before the ENCLOSED BY keywords.
#
# Any of the field- or line-handling options can specify an empty string
# ('')
#
# If not empty, the FIELDS [OPTIONALLY] ENCLOSED BY and FIELDS ESCAPED BY
# values must be a single character.
#
# The FIELDS TERMINATED BY, LINES STARTING BY, and LINES TERMINATED BY values
# can be more than one character.
#
# For example, to write lines that are terminated by carriage return/linefeed
# pairs, or to read a file containing such lines, specify a LINES TERMINATED BY '\r\n'
# clause.
#
# To read a file containing jokes that are separated by lines consisting of 
# %%, you can do this:
#
# 		CREATE TABLE jokes
# 			(a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
# 			joke TEXT NOT NULL);
# 		LOAD DATA INFILE '/tmp/jokes.txt' INTO TABLE jokes
# 			FIELDS TERMINATED BY ''
# 			LINES TERMINATED BY '\n%%\n' (joke);
#
# FIELDS [OPTIONALLY] ENCLOSED BY controls quoting of fields.
#
# For output (SELECT --- INTO OUTFILE), if you omit the word OPTIONALLY,
# all fields are enclosed by the ENCLOSED BY character.
#
# An example of such output (using a comma as the field delimiter)
# is shown here:
#
# 		"1","a string","100.20"
# 		"2","a string containing a , comma","102.20"
# 		"3","a string containing a \" quote","102.20"
# 		"4","a string containing a \", quote and comma","102.20"
#
# If you specify OPTIONALLY, the ENCLOSED BY character is used only to enclose values
# from columns that have a string data type (such as CHAR, BINARY, TEXT or ENUM):
#
# 		1,"a string",100.20
# 		2,"a string containing a , comma",102.20
# 		3,"a string containing a \" quote",102.20
# 		4,"a string containing a \", quote and comma",102.20
#
# Occurrences of the ENCLOSED BY character within a field value are escaped by
# prefixing them with the ESCAPED BY character.
#
# Also, if you specify an empty ESCAPED BY value, it is possible to inadvertedly
# generate output that cannot be read properly by LOAD_DATA_INFILE
#
# For example, the preceding output just shown would appear as follows
# if the escape character is empty.
#
# Observe that the second field in the fourth line contains a comma following
# the quote, which (errorneously) appears to terminate the field:
#
# 		1,"a string",100.20
# 		2,"a string containing a , comma",102.20
# 		3,"a string containing a " quote",102.20
# 		4,"a string containing a ", quote and comma",102.20
#
# For input, the ENCLOSED BY character, if present, is stripped from the ends of field values.
#
# (This is true regardless of whether OPTIONALLY is specified; OPTIONALLY has no effect on
# input interpretation)
#
# Occurrences of the ENCLOSED BY character preceded by the ESCAPED BY character
# are interpreted as part of the current field value.
#
# If the field begins with the ENCLOSED BY character, instances of that character
# are recognized as terminating a field value only if followed by the field or
# line TERMINATED BY sequence.
#
# To avoid ambiguity, occurrences of the ENCLOSED BY character within a field value
# can be doubled and are interpreted as a single instance of the character.
#
# For example, if ENCLOSED BY '"' is specified, quotation marks are handled as shown here:
#
# 		"The ""BIG"" boss" 	-> The "BIG" boss
# 		
# 		The "BIG" boss 		-> The "BIG" boss
#
# 		The ""BIG"" boss 		-> The ""BIG"" boss
#
# FIELDS ESCAPED BY controls how to read or write special characters:
#
# 		) For input, if the FIELDS ESCAPED BY character is not empty, occurences
# 			of that character are stripped and the following character is taken
# 			literally as part of a field value.
#
# 			Some two-character sequences that are exceptions, where the first character
# 			is the escape character.
#
# 			These sequences are shown in the following table (using \ for the escape character)
#
# 			The rules for NULL handling are described later in this section.
#
# 				CHARACTER 	ESCAPE SEQUENCE
# 
#  			\0 			An ASCII NUL (X'00') character
#
# 				\b 			a backspace character
#
# 				\n 			A newline (linefeed) character
#
# 				\r 			A carriage return character
#
# 				\t 			A tab character
#
# 				\Z 			ASCII 26 (control+Z)
#
# 				\N 			NULL
#
# 			For more information about \-escape syntax, see SECTION 9.1.1, "STRING LITERALS"
#
# 			If the FIELDS ESCAPED BY character is empty, escape-sequence interpretation does not occur.
#
# 		) For output, if the FIELDS ESCAPED BY character is not empty, it is used to prefix the following
# 			characters on output:
#
# 			) The FIELDS ESCAPED BY character
#
# 			) The FIELDS [OPTIONALLY] ENCLOSED BY character
#
# 			) The first character of the FIELDS TERMINATED BY and LINES TERMINATED BY values,
# 				if the ENCLOSED BY character is empty or unspecified.
#
# 			) ASCII 0 (what is actually written following the escape character is ASCII 0, not a zero-valued byte)
#
# 			If the FIELDS ESCAPED BY character is empty, no characters are escaped and NULL is output as NULL,
# 			not \N
#
# 			It is probably not a good idea to specify an empty escape character, particularly if field values
# 			in your data contain any of the characters in the list just given.
#
# In certain cases, field- and line-handling options interact:
#
# 		) If LINES TERMINATED BY is an empty string and FIELDS TERMINATED BY is nonempty, lines are also
# 			terminated with FIELDS TERMINATED BY
#
# 		) If the FIELDS TERMINATED BY and FIELDS ENCLOSED BY values are both empty (''), a fixed-row
# 			(nondelimited) format is used.
#
# 			With fixed-row format, no delimiters are used between fields (but you can still have a line terminator)
#
# 			Instead, column values are read and written using a field width wide enough to hold all values
# 			in the field.
#
# 			For TINYINT, SMALLINT, MEDIUMINT, INT, and BIGINT, the field widths are 4, 6, 8, 11 and 20, respectively,
# 			no matter what the declared display width is.
#
# 			LINES TERMINATED BY is still used to separate lines.
#
# 			If a line does not contain all fields, the rest of the columns are set to their
# 			default values.
#
# 			If you do not have a line terminator, you should set this to ''
#
# 			In this case, the text file must contain all fields for each row.
#
# 			Fixed row format also affects handling of NULL values, as described later.
#
# 			NOTE:
#
# 				Fixed-size format does not work if you are using a multibyte character set
#
# Handling of NULL values varies according to the FIELDS and LINES options in use:
#
# 		) For the default FIELDS and LINES values, NULL is written as a field value of 
# 			\N for output, and a field value of \N is read as NULL for input
#
# 			(Assuming that the ESCAPED BY character is \)
#
# 		) If FIELDS ENCLOSED BY is not empty, a field containing the literal word NULL
# 			as its value is read as a NULL value.
#
# 			This differs from the word NULL enclosed within FIELDS ENCLOSED BY characters,
# 			which is read as the string 'NULL'
#
# 		) If FIELDS ESCAPED BY is empty, NULL is written as the word NULL
#
# 		) With fixed-row format (which is used when FIELDS TERMINATED BY and FIELDS ENCLOSED BY
# 			are both empty), NULL is written as a empty string.
#
# 			This causes both NULL values and empty strings in the table to be indistinguishable when
# 			written to the file because both are written as empty strings.
#
# 			If you need to be able to tell the two apart when reading the file back in,
# 			you should not use fixed-row format.
#
# An attempt to load NULL into a NOT NULL column causes assignment of the implicit default value
# for the column's data type and a warning, or an error in strict SQL mode.
#
# Implicit default values are discussed in SECTION 11.7, "DATA TYPE DEFAULT VALUES"
#
# Some cases are not supported by LOAD_DATA_INFILE:
#
# 		) Fixed-size rows (FIELDS TERMINATED BY and FIELDS ENCLOSED BY both empty) and BLOB or TEXT columns.
#
# 		) If you specify one separator that is the same as or a prefix of another, LOAD_DATA_INFILE cannot
# 			interpret the input properly.
#
# 			For example, the following FIELDS clause would cause problems:
#
# 				FIELDS TERMINATED BY '"' ENCLOSED BY '"'
#
# 		) If FIELDS ESCAPED BY is empty, a field value that contains an occurrence of FIELDS
# 			ENCLOSED BY or LINES TERMINATED BY followed by the FIELDS TERMINATED BY value
# 			causes LOAD_DATA_INFILE to stop reading a field or line too early.
#
# 			This happens because LOAD_DATA_INFILE cannot properly determine whether the field
# 			or line value ends.
#
# COLUMN LIST SPECIFICATION
#
# The following example loads all columns of the persondata table:
#
# 		LOAD DATA INFILE 'persondata.txt' INTO TABLE persondata;
#
# By default, when no column list is provided at the end of the LOAD_DATA_INFILE
# statement, input lines are expected to contain a field for each table column.
#
# If you want to load only some of a table's columns, specify a column list:
#
# 		LOAD DATA INFILE 'persondata.txt' INTO TABLE persondata
# 		(col_name_or_user_var [, col_name_or_user_var] ---);
#
# You must also specify a column list if the order of the fields in the input file
# differs from the order of the columns in the table.
#
# Otherwise, MySQL cannot tell how to match input fields with table columns.
#
# INPUT PREPROCESSING
#
# Each col_name_or_user_var value is either a column or a user variable.
#
# With user variables, the SET clause enables you to perform preprocessing
# transformations on their values before assigning the result to columns.
#
# User variables in the SET clause can be used in several ways.
#
# The following example uses the first input column directly for the value
# of t1.column1, and assigns the second input column to a user variable
# that is subjected to a division operation beore being used for the
# value of t1.column2:
#
# 		LOAD DATA INFILE 'file.txt'
# 			INTO TABLE t1
# 			(column1, @var1)
# 			SET column2 = @var1/100;
#
# The SET clause can be used to supply values not derived from the input file.
#
# The following statement sets column3 to the current date and time:
#
# 		LOAD DATA INFILE 'file.txt'
# 			INTO TABLE t1
# 			(column1, column2)
# 			SET column3 = CURRENT_TIMESTAMP;
#
# You can also discard an input value by assigning it to a user variable
# and not assigning the variable to a table column:
#
# 		LOAD DATA INFILE 'file.txt'
# 			INTO TABLE t1
# 			(column1, @dummy, column2, @dummy, column3);
#
# Use of the column/variable list and SET clause is subject to the following restrictions:
#
# 		) Assignments in the SET clause should have only column names on the left hand side of assignment operators
#
# 		) You can use subqueries in the right hand side of SET assignments.
#
# 			A subquery that returns a value to be assigned to a column may be a scalar subquery only.
#
# 			ALso, you cannot use a subquery to select from the table that is being loaded.
#
# 		) Lines ignored by an IGNORE clause are not processed for the column/variable list or SET clause
#
# 		) User variables cannot be used when loading data with fixed-row format because user variables do
# 			not have a display width
#
# When processing an input line, LOAD_DATA splits it into fields and uses the values according to
# the column/variable list and the SET clause, if they are present.
#
# Then the resulting row is inserted into the table. If there are BEFORE INSERT or AFTER INSERT
# triggers for the table, they are activated before or after inserting the row, respectively.
#
# If an input line has too many fields, the extra fields are ignored and the number of warnings
# is incremented.
#
# If an input line has too few fields, the table columns for which input fields are missing are set
# to their default values.
#
# Default value assignment is described in SECTION 11.7, "DATA TYPE DEFAULT VALUES"
#
# An empty field value is interpreted different from a missing field:
#
# 		) For string types, the column is set to the empty string
#
# 		) For numeric types, the column is set to 0
#
# 		) For date and time types, the column is set to the appropriate "zero" value for the type.
#
# 			See SECTION 11.3, "DATE AND TIME TYPES"
#
# These are the same values that result if you assign an empty string explicitly to a string,
# numeric, or date or time type explicitly in an INSERT or UPDATE statement.
#
# Treatment of empty or incorrect field values differs from that just described if the SQL
# mode is set to a restrictive value.
#
# For example, if sql_mode is set to TRADITIONAL, conversion of an empty value or a value
# such as 'x' for a numeric column results in an error, not conversion to 0.
#
# (With LOCAL or IGNORE, warnings occur rather than errors, even with a restrictive sql_mode value,
# and the row is inserted using the same closest-value behavior used for nonrestrictive
# SQL modes.
#
# This occurs because the server has no way to stop transmission of the file in the middle of the operation)
#
# TIMESTAMP columns are set to the current date and time only if there is a NULL value for the
# column (that is, \N) and the column is not declared to permit NULL values, or if the TIMESTAMP
# column's default value is the current timestamp and it is omitted from the field list when a 
# field list is specified.
#
# LOAD_DATA_INFILE regards all input as strings, so you cannot use numeric values for ENUM or
# SET columns the way you can with INSERT statements.
#
# All ENUM and SET values must be specified as strings.
#
# BIT values cannot be loaded directly using binary notation (for example, b'011010')
#
# To work around this, use the SET clause to strip off the leading b' and trailing '
# and perform a base-2 to base-10 conversion so that MySQL loads the values into the
# BIT column properly:
#
# 		cat /tmp/bit_test.txt
# 		b'10
# 		b'1111111'
# 		mysql test
# 		LOAD DATA INFILE '/tmp/bit_test.txt'
# 		INTO TABLE bit_test (@var1)
# 		SET b = CAST(CONV(MID(@var1, 3, LENGTH(@var1)-3), 2, 10) AS UNSIGNED);
# 		Query OK, 2 rows affected (0.00 sec)
# 		Records: 2 Deleted: 0 Skipped: 0 Warnings: 0
#
# 		SELECT BIN(b+0) FROM bit_test;
# 		+------------+
# 		| BIN(b+0)   |
# 		+------------+
# 		| 10 		    |
# 		| 1111111    |
# 		+------------+
# 		2 rows in set (0.00 sec)
#
# For BIT values in 0b binary notation (for example, 0b011010), use this SET
# clause instead to strip off the leading 0b:
#
# 		SET b = CAST(CONV(MID(@var1, 3, LENGTH(@var1)-2), 2, 10) AS UNSIGNED)
#
# STATEMENT RESULT INFORMATION
#
# When the LOAD_DATA_INFILE statement finishes, it returns an information string in the
# following format:
#
# 		Records: 1 Deleted: 0 Skipped: 0 Warnings: 0
#
# Warnings occur under the same circumstances as when values are inserted using the INSERT
# statement (see SECTION 13.2.6, "INSERT SYNTAX"), except that LOAD_DATA_INFILE also generates
# warnings when there are too few or too many fields in the input row.
#
# You can use SHOW_WARNINGS to get a list of the first max_error_count warnings as information
# about what went wrong.
#
# See SECTION 13.7.6.40, "SHOW WARNINGS SYNTAX"
#
# If you are using the C API, you can get information about the statement by calling the
# mysql_info() function.
#
# See SECTION 28.7.7.36, "MYSQL_INFO()"
#
# MISCELLANEOUS TOPICS
#
# On Unix, if you need LOAD_DATA to read from a pipe, you can use the following technique 
# (the example loads a listing of the / directory into the table db1.t1):
#
# 		mkfifo /mysql/data/db1/ls.dat
# 		chmod 666 /mysql/data/db1/ls.dat
# 		find / -ls > /mysql/data/db1/ls.dat &
# 		mysql -e "LOAD DATA INFILE 'ls.dat' INTO TABLE t1" db1
#
# Here you must run the command that generates the data to be loaded and the mysql commands
# either on separate terminals, or run the data generation process in the background
# (as shown in the preceding example)
#
# If you do not do this, the pipe will block until data is read by the mysql process
#
# 13.2.8 LOAD XML SYNTAX
#
# 		LOAD XML [LOW_PRIORITY | CONCURRENT] [LOCAL] INFILE 'file_name'
# 			[REPLACE | IGNORE]
# 			INTO TABLE [db_name.]tbl_name
# 			[CHARACTER SET charset_name]
# 			[ROWS IDENTIFIED BY '<tagname>']
# 			[IGNORE number {LINES | ROWS}]
# 			[(field_name_or_user_var
# 				[, field_name_or_user_var] ---)]
# 			[SET col_name={expr | DEFAULT},
# 				[, col_name={expr | DEFAULT}] ---]
#
# The LOAD_XML statement reads data from an XML file into a table.
#
# The file_name must be given as a literal string. The tagname in the optional ROWS IDENTIFIED BY 
# clause must also be given as a literal string, and must be surrounded by angle brackets (< and >)
#
# LOAD_XML acts as the complement of running the mysql client in XML output mode (that is, starting
# the client with the --xml option)
#
# To write data from a table to an XML file, you can invoke the mysql client with the --xml
# and -e options from the system shell, as shown here:
#
# 		mysql --xml -e 'SELECT * FROM mydb.mytable' > file.xml
#
# To read the file back into a table, use LOAD_XML_INFILE
#
# By default, the <row> element is considered to be the equivalent of a database
# table row; this can be changed using the ROWS IDENTIFIED BY clause.
#
# This statement supports three different XML formats:
#
# 		) Column names as attributes and column values as attribute values:
#
# 			<row column1="value1" column2="value2" ---/>
#
# 		) Column names as tags and column values as the content of these tags:
#
# 			<row>
# 				<column1>value1</column1>
# 				<column2>value2</column2>
# 			</row>
#
# 		) Column names are the name attributes of <field> tags, and values are the contents of these tags:
#
# 			<row>
# 				<field name='column1'>value1</field>
# 				<field name='column2'>value2</field>
# 			</row>
#
# 			This is the format used by other MySQL tools, such as mysqldump
#
# All three formats can be used in the same XML file; the import routine automatically
# detects the format for each row and interprets it correctly.
#
# Tags are matched based on the tag or attribute name and the column name.
#
# The following clauses work essentially the same way for LOAD_XML as they do for LOAD_DATA:
#
# 		) LOW_PRIORITY or CONCURRENT
#
# 		) LOCAL
#
# 		) REPLACE or IGNORE
#
# 		) CHARACTER SET
#
# 		) SET
#
# See SECTION 13.2.7, "LOAD DATA INFILE SYNTAX", for more information about these clauses.
#
# (field_name_or_user_var, ---) is a list of one or more comma-separated XML fields or user variables.
#
# The name of a user variable used for this purpose must match the name of a field from the XML file,
# prefixed with @.
#
# You can use field names to select only desired fields.
#
# User variables can be employed to store the corresponding field values for subsequent re-use.
#
# The IGNORE number LINES or IGNORE number ROWS clause causes the first number rows in the
# XML file to be skipped.
#
# It is analogous to the LOAD_DATA statement's IGNORE --- LINES clause.
#
# Suppose that we have a table named person, created as shown here:
#
# 		USE test;
#
# 		CREATE TABLE person (
# 			person_id INT NOT NULL PRIMARY KEY,
# 			fname VARCHAR(40) NULL,
# 			lname VARCHAR(40) NULL,
# 			created TIMESTAMP
# 		);
#
# Suppose further that this table is initially empty.
#
# Now suppose that we have a simple XML file person.xml, whose contents
# are as shown here:
#
# 		<list>
# 			<person person_id="1" fname="Kapek" lname="Sainnouine"/>
# 			<person person_id="2" fname="Sajon" lname="Rondela"/>
# 			<person person_id="3"><fname>Likame</fname><lname>Örrtmons</lname></person>
# 			<person person_id="4"><fname>Slar</fname><lname>Manlanth</lname></person>
# 			<person><field name="person_id">5</field><field name="fname">Stoma</field>
# 				<field name="lname">Milu</field></person>
# 			<person><field name="person_id">6</field><field name="fname">Nirtam</field>
# 				<field name="lname">Sklöd</field></person>
# 			<person person_id="7"><fname>Sungam</fname><lname>Dulbåd</lname></person>
# 			<person person_id="8" fname="Srafef" lname="Encmelt"/>
# 		</list>
#
# Each of the permissible XML formats discussed previously is represented in this example file.
#
# To import the data in person.xml into the person table, you can use this statement:
#
# 		LOAD XML LOCAL INFILE 'person.xml'
# 			INTO TABLE person
# 			ROWS IDENTIFIED BY '<person>';
# 		Query OK, 8 rows affected (0.00 sec)
# 		Records: 8 Deleted: 0 Skipped: 0 Warnings: 0
#
# Here, we assume that person.xml is located in the MySQL data directory.
#
# If the file cannot be found, the following error results:
#
# 		ERROR 2 (HY000): File '/person.xml' not found (Errcode: 2)
#
# The ROWS IDENTIFIED BY '<person>' clause means that each <person> element in the XML
# file is considered equivalent to a row in the table into which the data is to be
# imported.
#
# In this case, this is the person table in the test database.
#
# As can be seen by the response from the server, 8 rows were imported into the test.person
# table.
#
# This can be verified by a simple SELECT statement:
#
# 		SELECT * FROM person;
# 		+-----------------+---------------+----------------+----------------------+
# 		| person_id 		| fname 			 | lname 			| created 				  |
# 		+-----------------+---------------+----------------+----------------------+
# 		| 1 				   | Kapek 			 | Sainnouine 	   | 2007-07-13 16:18:47  |
# 		| 2 					| Sajon 			 | Rondela 			| 2007-07-13 16:18:47  |
# 		| 3 					| Likame 		 | Örrtmons 		| 2007-07-13 16:18:47  |
# 		| 4 					| etc.
# 		etc.
#
# This shows, as stated earlier in this section, that any or all of hte 3 permitted XML
# formats may appear in a single file and be read in using LOAD_XML
#
# The inverse of the import operation just shown - that is, dumping MySQL table data
# into an XML file - can be accomplished using the mysql client from the system shell,
# as shown here:
#
# 		mysql --xml -e "SELECT * FROM test.person" > person-dump.xml
# 		cat person-dump.xml
# 		<?xml version="1.0"?>
#
# 		<resultset statement="SELECT * FROM test.person" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
# 			<row>
# 				<field name="person_id">1</field>
# 				<field name="fname">Kapek</field>
# 				<field name="lname">Sainnouine</field>
# 			</row>
#
# 			<row>
# 				<field name="person_id">2</field>
# 				etc.
# 			etc.
# 		</resultset>
#
# NOTE:
#
# 		The --xml option causes the mysql client to use XML formatting for its output;
#
# 		The -e option causes the client to execute the SQL statement immediately following
# 		the option. See SECTION 4.5.1, "MYSQL -- THE MYSQL COMMAND-LINE CLIENT"
#
# YOu can verify that hte dump is valid by creating a copy of the person table
# and importing the dump file into the new table, like this:
#
# 		USE test;
# 		CREATE TABLE person2 LIKE person;
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		LOAD XML LOCAL INFILE 'person-dump.xml'
# 			INTO TABLE person2;
# 		Query OK, 8 rows affected (0.01 sec)
# 		Records: 8 Deleted: 0 Skipped: 0 Warnings: 0
#
# 		SELECT * FROM person2;
# 		+---------------------+---------------+-----------------------+---------------------+
# 		| person_id 			 | fname 		  | lname 					  | created 				|
# 		+---------------------+---------------+-----------------------+---------------------+
# 		| etc.
# 		8 rows in set (0.00 sec)
#
# There is no requirement that every field in the XML file be matched with a column in the 
# corresponding table.
#
# Fields which have no corresponding columns are skipped.
#
# You can see this by first emptying the person2 table and dropping the created column,
# then using the same LOAD XML statement we just employed previously, like this:
#
# 		TRUNCATE person2;
# 		Query OK, 8 rows affected (0.26 sec)
#
# 		ALTER TABLE person2 DROP COLUMN created;
# 		Query OK, 0 rows affected (0.52 sec)
# 		Records: 0 Duplicates: 0 Warnings: 0
#
# 		SHOW CREATE TABLE person2\G
# 		************************** 1. row *********************************
# 				Table: person2
# 		Create table: CREATE TABLE `person2` (
# 			`person_id` int(11) NOT NULL,
# 			`fname` varchar(40) DEFAULT NULL,
# 			`lname` varchar(40) DEFAULT NULL,
# 			PRIMARY KEY (`person_id`)
# 		) ENGINE=InnoDB DEFAULT CHARSET=utf8
# 		1 row in set (0.00 sec)
#
# 		LOAD XML LOCAL INFILE 'person-dump.xml'
# 			INTO TABLE person2;
# 		Query OK, 8 rows affected (0.01 sec)
# 		Records: 8 Deleted: 0 Skipped: 0 Warnings: 0
#
# 		SELECT * FROM person2;
# 		+--------------+--------------+--------------+
# 		| person_id    | fname 		   | lname 			|
# 		+--------------+--------------+--------------+
# 		| 		etc.
# 		8 rows in set (0.00 sec)
#
# The order in which the fields are given within each row of the XML file does not
# affect the operation of LOAD XML; the field order can vary from row to row,
# and is not required to be in the same order as the corresponding columns in the table.
#
# As mentioned previously, you can use a (field_name_or_user_var, ---) list of one or more
# XML fields (to select desired fields only) or user variables (to store the corresponding
# field values for later use)
#
# User variables can be especially useful when you want to insert data from an XML file
# into table columns whose names do not match those of the XML fields.
#
# To see how this works, we first create a table named individual whose structure
# matches that of the person table, but whose columns are named differently:
#
# 		CREATE TABLE individual (
# 			individual_id INT NOT NULL PRIMARY KEY,
# 			name1 VARCHAR(40) NULL,
# 			name2 VARCHAR(40) NULL,
# 			made TIMESTAMP
# 		);
# 		Query OK, 0 rows affected (0.42 sec)
#
# In this case, you cannot simply load the XML file directly into the table,
# because the field and column names do not match:
#
# 		LOAD XML INFILE '../bin/person-dump.xml' INTO TABLE test.individual;
# 		ERROR 1263 (22004): Column set to default value; NULL supplied to NOT NULL column
# 		'individual_id' at row 1
#
# This happens because the MySQL server looks for field names matching the column names
# of hte target table.
#
# You can work around this problem by selecting the field values into user variables,
# then setting the target table's columns equal to the values of those variables
# using SET.
#
# You can perform both of these operations in a single statement, as shown here:
#
# 		LOAD XML INFILE '../bin/person-dump.xml'
# 				INTO TABLE test.individual (@person_id, @fname, @lname, @created)
# 				SET individual_id=@person_id, name1=@fname, name2=@lname, made=@created;
# 		Query OK, 8 rows affected (0.05 sec)
# 		Records: 8 Deleted: 0 Skipped: 0 Warnings: 0
#
# 		SELECT * FROM individual;;
# 		+-----------------+--------------+-------------------+------------------------+
# 		| individual_id 	| name1 			| name2 				  | made 					   |
# 		+-----------------+--------------+-------------------+------------------------+
# 		| etc.
#
# 		8 rows in set (0.00 sec)
#
# The names of the user variables must match those of the corresponding fields from the
# XML file, with the addition of hte required @ prefix to indicate that they are variables.
#
# THe user variables need not be listed or assigned in the same order as the corresponding fields.
#
# Using a ROWS IDENTIFIED BY '<tagname>' clause, it is possible to import data from the same XML
# file into database tables with different definitions.
#
# For this example, suppose that you have a file named address.xml which contains the following XML:
#
# 		<?xml version="1.0"?>
#
# 		<list>
# 			<person person_id="1">
# 				<fname>Robert</fname>
# 				<lname>Jones</lname>
# 				<address address_id="1" street="Mill Creek Road" zip="45365" city="Sidney"/>
#  			<address address_id="2" street="Main Street" zip="28681" city="Taylorsville"/>
# 			</person>
#
# 			etc.
#
# 		</list>
#
# You can again use the test.person table as defined previously in this section,
# after clearing all the existing records from the table and then showing its
# structure as shown here:
#
# 		mysql< TRUNCATE person;
# 		Query OK, 0 rows affected (0.04 sec)
#
# 		mysql< SHOW CREATE TABLE person\G
# 		******************* 1. row *************************
# 				Table: person
# 		Create Table: CREATE TABLE `person` (
# 			`person_id` int(11) NOT NULL,
# 			`fname` varchar(40) DEFAULT NULL,
# 			`lname` varchar(40) DEFAULT NULL,
# 			`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
# 		  PRIMARY KEY (`person_id`)
# 		) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4
# 		1 row in set (0.00 sec)
#
# Now create an address table in the test database using the following CREATE_TABLE statement:
#
# 		CREATE TABLE address (
# 			address_id INT NOT NULL PRIMARY KEY,
# 			person_id INT NULL,
# 			street VARCHAR(40) NULL,
# 			zip INT NULL,
# 			city VARCHAR(40) NULL,
# 			created TIMESTAMP
# 		);
#
# To import the data from the XML file into the person table, execute the following
# LOAD_XML statement, which specifies that rows are to be specified by the
# <person> element, as shown here:
#
# 		LOAD XML LOCAL INFILE 'address.xml'
# 			INTO TABLE person
# 			ROWS IDENTIFIED BY '<person>';
# 		Query OK, 2 rows affected (0.00 sec)
# 		Records: 2 Deleted: 0 Skipped: 0 Warnings: 0
#
# You can verify that hte records were imported using a SELECT statement:
#
# 		SELECT * FROM person;
# 		+------------------+------------------+-----------+----------------------+
# 		| person_id 		 | fname 			  | lname 	  | created 			    |
# 		+------------------+------------------+-----------+----------------------+
# 		| 1 					 | Robert 			  | Jones 	  | 2007-07-24 17:37:06  |
# 		| 2 					 | Mary 				  | Smith 	  | 2007-07-24 17:37:06  |
# 		+------------------+------------------+-----------+----------------------+
# 		2 rows in set (0.00 sec)
#
# Since the <address> elements in the XML file have no corresponding columns in the
# person table, they are skipped.
#
# To import the data from the <address> elements into the address table, using the
# LOAD_XML statement shown here:
#
# 		LOAD XML LOCAL INFILE 'address.xml'
# 			INTO TABLE address
# 			ROWS IDENTIFIED BY '<address>';
# 		Query OK, 3 rows affected (0.00 sec)
# 		Records: 3 Deleted: 0 Skipped: 0 Warnings: 0
#
# You can see that the data was imported using a SELECT statement such as this one:
#
# 		SELECT * FROM address;
# 		+-------------+---------------+--------------------+---------+---------------+---------------------+
# 		| address_id  | person_id 		| street 				| zip     | city 			  | created 		      |
# 		+-------------+---------------+--------------------+---------+---------------+---------------------+
# 		| 1 			  | 1 				| Mill Creek Road 	| 45365   | Sidney 		  | 2007-07-24 17:37:37 |
# 		 etc.
# 		
# 		3 rows in set (0.00 sec)
#
# The data from the <address> element that is enclosed in XML comments is not imported.
#
# However, since there is a person_id column in the address table, the value of the 
# person_id attribute from the parent <person> element for each <address> is imported
# into the address table.
#
# SECURITY CONSIDERATIONS
#
# AS with the LOAD_DATA statement, the transfer of the XML file from the client
# host to the server host is initiated by the MySQL server.
#
# In theory, a patched server could be built that would tell the client program to
# transfer a file of the server's choosing rather than the file named by the client
# in the LOAD_XML statement.
#
# Such a server could access any file on the client host to which the client
# user has read access.
#
# In a Web environment, clients usually connect to MySQL from a Web server.
#
# A user that can run any command against the MySQL server can use LOAD_XML_LOCAL
# to read any files ot which the Web server process has read access.
#
# In this environment, the client with respect tot the MySQL server is actually
# the Web server, not the remote program being run by the user who connects
# to the Web server.
#
# You can disable loading of XML files from clients by starting the server with
# --local-infile=0 or --local-infile=OFF
#
# This option can also be used when starting the mysql client to disable
# LOAD_XML for the duration of the client session.
#
# To prevent a client from loading XML files from the server, do not grant
# the FILE privilege to the corresponding MySQL user account, to revoke
# this privilege if the client user account already has it.
#
# IMPORTANT:
#
# 		Revoking the FILE privilege (or not granting it in the first place) keeps
# 		hte user only from executing the LOAD_XML_INFILE statement
#
# 		(as well as the LOAD_FILE() function; it does not prevent the user
# 		from executing LOAD_XML_LOCAL_INFILE 
#
# 		To disallow this statement, you must start the server or the client
# 		with --local-infile=OFF
#
# 		In other words, the FILE privilege affects only whether the client
# 		can read files on the server;
#
# 		it has no bearing on whether the client can read files on the local file system.
#
# For partitioned tables using storage engines that employ table locks, such as MyISAM;
# any locks caused by LOAD XML performs locks on all partitions of the table.
#
# This does not apply to tables using storage engines which employ row-level locking,
# such as InnoDB.
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.9 REPLACE SYNTAX
#
# 	REPLACE [LOW_PRIORITY | DELAYED]
# 		[INTO] tbl_name
# 		[PARTITION (partition_name [, partition_name] ---)]
# 		[(col_name [, col_name] ---)]
# 		{VALUES | VALUE} (value_list) [, (value_list)] ---
#
# 	REPLACE [LOW_PRIORITY | DELAYED]
# 		[INTO] tbl_name
# 		[PARTITION (partition_name [, partition_name] ---)]
# 		SET assignment_list
#
# 	REPLACE [LOW_PRIORITY | DELAYED]
# 		[INTO] tbl_name
# 		[PARTITION (partition_name [, partition_name] ---)]
# 		[(col_name [, col_name] ---)]
# 		SELECT ---
#
# 	value:
# 		{expr | DEFAULT}
#
# 	value_list:
# 		value [, value] ---
#
# 	assignment:
# 		col_name = value
#
# 	assignment_list:
# 		assignment [, assignment] ---
#
# REPLACE works exactly like INSERT, except that if an old row in the table has the same value as a new row
# for a PRIMARY KEY or a UNIQUE index, the old row is deleted before hte new row is isnerted.
#
# See SECTION 13.2.6, "INSERT SYNTAX"
#
# REPLACE is a MySQL extension to the SQL standard.
#
# It either inserts, or deletes and inserts.
#
# For another MySQL extension to standard SQL - that either inserts
# or updates - see SECTION 13.2.6.2, "INSERT --- ON DUPLICATE KEY UPDATE SYNTAX"
#
# DELAYED inserts and replaces were deprecated in MySQL 5.6
#
# In MySQL 8.0, DELAYED is not supported. THe server recognizes but ignores the DELAYED
# keyword, handles the replace as a nondelayed replace, and generates an ER_WARN_LEGACY_SYNTAX_CONVERTED
# warning.
#
# ("REPLACE DELAYED is no longer supported. The statement was converted to REPLACE")
#
# The DELAYED keyword will be removed in a future release.
#
# NOTE:
#
# 		REPLACE makes sense only if a table has a PRIMARY KEY or UNIQUE index.
#
# 		Otherwise, it becomes equivalent to INSERT, because there is no index to be
# 		used to determine whether a new row duplicates another.
#
# Values for all columns are taken from the values specified in the REPLACE statement.
#
# Any missing columns are set to their default values, just as happens for INSERT.
#
# You cannot refer to values from the current row and use them in the new row.
#
# If you use an assignment such as SET col_name = col_name + 1, the reference
# to the column name on the right hand side is treated as DEFAULT(col_name),
# so the assignment is equivalent to SET col_name = DEFAULT(col_name) + 1
#
# To use REPLACE, you must have both the INSERT and DELETE privileges for the table.
#
# If a generated column is replaced explicitly, the only permitted value is DEFAULT.
#
# For information about generated columns, see SECTION 13.1.20.8,, "CREATE TABLE AND GENERATED COLUMNS"
#
# REPLACE supports explicit partition selection using the PARTITION keyword with a list
# of comma-separated names of partitions, subpartitions, or both.
#
# As with INSERT, if it is not possible to insert the new row into any of these
# partitions or subpartitions, the REPLACE statement fails with the error:
#
# 		Found a row not matching the given partition set
#
# For more information, and examples - see SECTION 23.5, "PARTITION SELECTION"
#
# The REPLACE statement returns a count to indicate the number of rows affected.
#
# This is the sum of hte rows deleted and inserted. If the count is 1 for a single-row
# REPLACE, a row was inserted and no rows were deleted.
#
# If the count is greater than 1, one or more old rows were deleted before the new row
# was inserted.
#
# It is possible for a single row to replace more than one old row if the table contains
# multiple unique indexes and the new row duplicates values for different old rows
# in different unique indexes.
#
# THe affected-rows count makes it easy to determine whether REPLACE only added a row
# or whether it also replaced any rows:
#
# 		Check whether the count is 1 (added) or greater (replaced)
#
# If you are using the C API, the affected-rows count cna be obtained using the
# mysql_affected_rows() function.
#
# You cannot replace into a table and select from the same table in a subquery.
#
# MySQL uses the following algorithm for REPLACE (and LOAD DATA --- REPLACE):
#
# 		1. Try to insert the new row into the table
#
# 		2. While the insertion fails because a duplicate-key error occurs for a primary key or unique index:
#
# 			a. Delete from the table the conflicting row that has the duplicate key value
#
# 			b. Try again to insert the new row into the table
#
# It is possible that in the case of a duplicate-key error, a storage engine may perform
# the REPLACE as an update rather than a delete plus insert, but the semantics are the
# same.
#
# There are no user-visible effects other than a possible difference in how the storage
# engine increments Handler_xxx status variables.
#
# Because the results of REPLACE --- SELECT statements depend on the ordering of rows
# from the SELECT and this order cannot always be guaranteed, it is possible when
# logging these statements for the master and the slave to diverge.
#
# For this reason, REPLACE --- SELECT statements are flagged as unsafe for statement-based
# replication.
#
# Such statements produce a warning in the error log when using statement-based mode and are
# written to the binary log using the row-based format when using MIXED mode.
#
# See also SECTION 17.2.1.1, "ADVANTAGES AND DISADVANTAGES OF STATEMENT-BASED AND ROW-BASED REPLICATION"
#
# When modifying an existing table that is not partitioned to accomodate partitioning, or, when modifying
# the partitioning of an already partitioned table, you may consider altering the table's primary key
# (see SECTION 23.6.1, "PARTITIONING KEYS, PRIMARY KEYS, AND UNIQUE KEYS")
#
# You should be aware that, if you do this, the results of REPLACE statements may be affected,
# just as they would be if you modified the primary key of a nonpartitioned table.
#
# Consider the table created by the following CREATE_TABLE statement:
#
# 		CREATE TABLE test (
# 			id INT UNSIGNED NOT NULL AUTO_INCREMENT,
# 			data VARCHAR(64) DEFAULT NULL,
# 			ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
# 			PRIMARY KEY (id)
# 		);
#
# When we create this table and run the statements shown in the mysql client, the result
# is as follows:
#
# 		REPLACE INTO test VALUES (1, 'Old', '2014-08-20 18:47:00');
# 		Query OK, 1 row affected (0.04 sec)
#
# 		REPLACE INTO test VALUES (1, 'New', '2014-08-20 18:47:42');
# 		Query OK, 2 rows affected (0.04 sec)
#
# 		SELECT * FROM test;
# 		+----+---------+-----------------------+
# 		| id | data    | ts 							|
# 		+----+---------+-----------------------+
# 		| 1  | New 		| 2014-08-20 18:47:42   |
# 		+----+---------+-----------------------+
# 		1 row in set (0.00 sec)
#
# Now we create a second table almost identical to the first, except that hte primary key
# now covers 2 columns, as shown here (emphasized text):
#
# 		CREATE TABLE test2 (
# 			id INT UNSIGNED NOT NULL AUTO_INCREMENT,
# 			data VARCHAR(64) DEFAULT NULL,
# 			ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
# 			PRIMARY KEY (id, ts)
# 		);
#
# When we run on test2 the same two REPLACE statements, as we did on the original test table,
# we obtain a different result:
#
# 		REPLACE INTO test2 VALUES (1, 'Old', '2014-08-20 18:47:00');
# 		Query OK, 1 row affected (0.05 sec)
#
# 		REPLACE INTO test2 VALUES (1, 'New', '2014-08-20 18:47:42');
# 		Query OK, 1 row affected (0.06 sec)
#
# 		SELECT * FROM test2;
# 		+----+----------+--------------------+
# 		| id | data     | ts 					 |
# 		+----+----------+--------------------+
# 		| 1  | Old 		 | 2014-08-20 18:47:00|
# 		| 1  | New 		 | 2014-08-20 18:47:42|
# 		+----+----------+--------------------+
# 		2 rows in set (0.00 sec)
#
# This is due to the fact that, when run on test2, both the id and ts column values must match
# those of an existing row for hte row to be replaced; otehrwise, a row is inserted.
#
# A REPLACE statement affecting a partitioned table using a storage engine such as MyISAM that
# employs table-level locks locks only those partitions containing rows that match the
# REPLACE statement WHERE clause, as long as none of the table partitioning columns are updated;
# otherwise the entire table is locked.
#
# (For storage engines such as InnoDB that employ row-level locking, no locking of partitions
# takes place)
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.10 SELECT SYNTAX
#
# 13.2.10 SELECT --- INTO SYNTAX
# 13.2.10.2 JOIN SYNTAX
# 13.2.10.3 UNION SYNTAX
#
# 		SELECT
# 			[ALL | DISTINCT | DISTINCTROW ]
# 				[HIGH_PRIORITY]
# 				[STRAIGHT_JOIN]
# 				[SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
# 				SQL_NO_CACHE [SQL_CALC_FOUND_ROWS]
# 			select_expr [, select_expr ---]
# 			[FROM table_references
# 				[PARTITION partition_list]
# 			[WHERE where_condition]
# 			[GROUP BY {col_name | expr | position}, --- [WITH ROLLUP]]
# 			[HAVING where_condition]
# 			[WINDOW window_name AS (window_spec)
# 				[, window_name AS (window_spec)] ---]
# 			[ORDER BY {col_name | expr | position}
# 				[ASC | DESC], --- [WITH ROLLUP]]
# 			[LIMIT {[offset,] row_count | row_count OFFSET offset}]
# 			[INTO OUTFILE 'file_name'
# 				[CHARACTER SET charset_name]
# 				export_options
# 			| INTO DUMPFILE 'file_name'
# 			| INTO var_name [, var_name]]
# 		 [FOR {UPDATE | SHARE} [OF tbl_name [, tbl_name] ---] [NOWAIT | SKIP lOCKED]
# 			| LOCK IN SHARE MODE]]
#
# SELECT is used to retrieve rows selected from one or more tables, and can include
# UNION statements and subqueries.
#
# See SECTION 13.2.10.3, "UNION SYNTAX" and SECTION 13.2.11, "SUBQUERY 	SYNTAX"
#
# A SELECT statement can start with a WITH clause to define common table expressions
# accessible within the SELECT.
#
# See SECTION 13.2.13, "WITH SYNTAX (COMMON TABLE EXPRESSIONS)"
#
# The most commonly used clauses of SELECT statements are these:
#
# 		) Each select_expr indicates a column that you want to retrieve.
#
# 			There must be at least one select_expr
#
# 		) table_references indicates the tables or tables from which to retrieve rows.
#
# 			Its syntax is described in SECTION 13.2.10.2, "JOIN SYNTAX"
#
# 		) SELECT supports explicit partition selection using the PARTITION with a list
# 			of partitions or subpartitions (or both) following the name of hte table
# 			in a table_refrence (see SECTION 13.2.10.2, "JOIN SYNTAX")
#
# 			In this case, rows are selected only from the partitions listed, and any
# 			other partitions of the table are ignored.
#
# 			For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# 			SELECT --- PARTITION from tables using storage engines such as MyISAM that
# 			perform table-level locks (and thus partition locks) lock only the partitions
# 			or subpartitions named by the PARTITION option.
#
# 			For more information, see PARTITIONING AND LOCKING
#
# 		) The WHERE clause, if given, indicates the condition or conditions that rows
# 			must satisfy to be selected.
#
# 			where_condition is an expression that evaluates to true for each row to be selected.
#
# 			The statement selects all rows if there is no WHERE clause.
#
# 			In the WHERE expression, you can use any of the functions and operators taht MySQL
# 			supports, except for aggregate (summary) functions.
#
# 			See SECTION 9.5, "EXPRESSIONS" and CHAPTER 12, FUNCTIONS AND OPERATORS.
#
# SELECT can also be used to retrieve rows computed without reference to any table.
#
# For example:
#
# 		SELECT 1+1;
# 			2
#
# You are permitted to specify DUAL as a dummy table name in situations where
# no tables are referneced:
#
# 		SELECT 1 +1 FROM DUAL;
# 			2
#
# DUAL is purely for the convenience of people who require that all SELECT
# statements should have FROM and possibly other clauses.
#
# MySQL may ignore the clauses.
#
# MySQL does not require FROM DUAL if no tables are referenced.
#
# In general, clauses used must be given in exactly the order shown in the 
# syntax description.
#
# For example, a HAVING clause must come after any GROUP BY clause and
# before any ORDER BY clause.
#
# The exception is that the INTO clause can appear either as shown in the syntax
# description or immediately following the select_expr list.
#
# For more information about INFO, see SECTION 13.2.10.1, "SELECT --- INTO SYNTAX"
#
# The list of select_expr terms comprises the select list that indicates which columns
# to retrieve.
#
# Terms specify a column or expression or can use *-shorthand:
#
# 		) A select list consisting only of a single unqualified * can be used
# 			as shorthand to select all columns from all tables.
#
# 				SELECT * FROM t1 INNER JOIN t2 ---
#
# 		) tbl_name.* can be used as qualified shorthand to select all columns
# 			from the named table:
#
# 				SELECT t1.*, t2.* FROM t1 INNER JOIN t2 ---
#
# 		) Use of an unqualified * with other items in the select list may produce a parse error.
#
# 			To avoid this problem, use a qualified tbl_name.* reference
#
# 				SELECT AVG(score), t1.* FROM t1 ---
#
# The following list provides additional information about other SELECT clauses:
#
# 		) A select_expr can be given an alias using AS alias_name.
#
# 			The alias is used as the expression's column name and can be used in
# 			GROUP BY, ORDER BY, or HAVING clauses.
#
# 			For example:
#
# 				SELECT CONCAT(last_name, ', ', first_name) AS full_name
# 					FROM mytable ORDER BY full_name;
#
# 			The AS keyword is optional when aliasing a select_expr with an identifier.
#
# 			The preceeding example could have been written like this:
#
# 				SELECT CONCAT(last_name, ', ',first_name) full_name
# 					FROM mytable ORDER BY full_name;
#
# 			However, because the AS is optional, a subtle problem can occur if you
# 			forget the comma between two select_expr expressions:
#
# 				MySQL interprets the second as an alias name.
#
# 				For example, in the following statement, columnb is treated
# 				as an alias name:
#
# 					SELECT columna columnb FROM mytable;
#
# 			For this reason, it is good practice to be in the habit of using AS explicitly
# 			when specifying column aliases.
#
# 			It is not permissible to refer to a column alias in a WHERE clause, because the
# 			column value might not yet be determined when the WHERE clause is executed.
#
# 			See SECTION B.6.4.4, "PROBLEMS WITH COLUMN ALIASES"
#
# 		) The FROM table_references caluse indicates the table or tables from which to
# 			retrieve rows.
#
# 			If you name more than one table, you are performing a join.
#
# 			For information on join syntax, see SECTION 13.2.10.2, "JOIN SYNTAX"
#
# 			For each table specified, you can optionally specify an alias.
#
# 				tbl_name [[AS] alias] [index_hint]
#
# 			The use of index hints provides the optimizer with information about how
# 			to choose indexes during query processing.
#
# 			For a description of the syntax for specifying these hints, see SECTION 8.9.4, "INDEX HINTS"
#
# 			You can use SET max_seeks_for_key=value as an alternative way to force MySQL
# 			to prefer key scans instead of table scans.
#
# 			See SECTION 5.1.8, "SERVER SYSTEM VARIABLES"
#
# 		) You can refer to a table within the default database as tbl_name, or as db_name.tbl_name
# 			to specify a database explicitly.
#
# 			You can refer to a column as col_name, tbl_name.col_name or db_name.tbl_name.col_name
#
# 			You need not specify a tbl_name or db_name.tbl_name prefix for a column reference
# 			unless the reference would be ambiguous.
#
# 			See SECTION 9.2.1, "IDENTIFIER QUALIFIERS", for examples of ambiguity that require
# 			the more explicit column reference forms.
#
# 		) A table reference can be aliased using tbl_name AS alias_name or tbl_name alias_name:
#
# 			SELECT t1.name, t2.salary FROM employee AS t1, info AS t2
# 				WHERE t1.name = t2.name;
#
# 			SELECT t1.name, t2.salary FROM employee t1, info t2
# 				WHERE t1.name = t2.name;
#
# 		) Columns selected for output can be referred to in ORDER BY and GROUP BY clauses
# 			using column names, column aliases or column positions.
#
# 			Column positions are integers and begin with 1:
#
# 				SELECT college, region, seed FROM tournament
# 					ORDER BY region, seed;
#
# 				SELECT college, region AS r, seed AS s FROM tournament
# 					ORDER BY r, s;
#
# 				SELECT college, region, seed FROM tournament
# 					ORDER BY 2, 3;
#
# 			To sort in reverse order, add the DESC (descending) keyword to the name of the column
# 			in the ORDER BY clause that you are sorting by.
#
# 			The default is ascending order; This can be specified explicitly using the ASC keyword.
#
# 			If ORDER BY occurs within a subquery and also is applied in the outer query, the outermost
# 			ORDER BY takes precedence.
#
# 			For example, results for the following statement are sorted in descending order,
# 			not ascending order:
#
# 				(SELECT --- ORDER BY a) ORDER BY a DESC;
#
# 			Use of column positions is deprecated because the syntax has been removed from the SQL standard.
#
# 		) Prior to MySQL 8.0.13, MySQL supported a nonstandard syntax extension that permitted explicit
# 			ASC or DESC designators for GROUP BY columns.
#
# 			MySQL 8.0.12 and later supports ORDER BY with grouping functions so that use of this extension
# 			is no longer necessary.
#
# 			(Bug #86312, Bug #26073525)
#
# 			This also means you can sort on an arbitrary column or columns when using GROUP BY, like this:
#
# 				SELECT a, b, COUNT(c) AS t FROM test_table GROUP BY a,b ORDER BY a,t DESC;
#
# 			As of MySQL 8.0.13, the GROUP BY extension is no longer supported:
#
# 				ASC or DESC designators for GROUP BY columns are not permitted.
#
# 		) When you use ORDER BY or GROUP BY to sort a column in a SELECT, the server sorts values
# 			using only the initial number of bytes indicated by the max_sort_length system variable.
#
# 		) MySQL extends the use of GROUP BY to permit selecting fields that are not mentioned in the
# 			GROUP BY clause.
#
# 			If you are not getting the results that you expect from your query, please read the 
# 			description of GROUP BY found in SECTION 12.20, "AGGREGATE (GROUP BY) FUNCTIONS"
#
# 		) GROUP BY permits a WITH ROLLUP modifier. See SECTION 12.20.2, "GROUP BY MODIFIERS"
#
# 			Previously, it was not permitted to use ORDER BY in a query having a WITH ROLLUP modifier.
#
# 			This restriction is lifted as of MySQL 8.0.12
#
# 			See SECTION 12.20.2, "GROUP BY MODIFIERS"
#
# 		) The HAVING clause is applied nearly last, just before items are sent to the client,
# 			with no optimization
#
# 			(LIMIT is applied after HAVING)
#
# 			The SQL standard requires that HAVING must reference only columns in the GROUP BY clause
# 			or columns used in aggregate functions.
#
# 			However, MySQL supports an extension to this behavior, and permits HAVING to refer
# 			to columns in the SELECT list and columns in outer subqueries as well.
#
# 			If the HAVING clause refers to a column that is ambiguous, a warning occurs.
#
# 			In the following statement, col2 is ambiguous because it is used as both an alias
# 			and a column name:
#
# 				SELECT COUNT(col1) AS col2 FROM t GROUP BY col2 HAVING col2 = 2;
#
# 			Preference is given to standard SQL behavior, so if a HAVING column name
# 			is used both in GROUP BY and as an aliased column in the output column list,
# 			preference is given to the column in the GROUP BY column.
#
# 		) Do not use HAVING for items that should be in the WHERE clause.
#
# 			For example, do not write the following:
#
# 				SELECT col_name FROM tbl_name HAVING col_name > 0;
#
# 			Write this instead:
#
# 				SELECT col_name FROM tbl_name WHERE col_name > 0;
#
# 		) The HAVING clause can refer to aggregate functions, which the WHERE clause cannot:
#
# 			SELECT user, MAX(salary) FROM users
# 				GROUP BY users HAVING MAX(salary) > 10;
#
# 			(This did not work in some older versions of MySQL)
#
# 		) MySQL permits duplicate column names.
#
# 			That is, there can be more than one select_expr with the same name.
#
# 			This is an extension to standard SQL. Because MySQL also permits
# 			GROUP BY and HAVING to refer to select_expr values, this can result
# 			in an ambiguity:
#
# 				SELECT 12 AS a, a FROM t GROUP BY a;
#
# 			In that statement, both columns have the name a.
#
# 			To ensure that the correct column is used for grouping, use different
# 			names for each select_expr
#
# 		) The WINDOW clause, if present, defines named windows that can be referred to by window functions.
#
# 			For details, see SECTION 12.21.4, "NAMED WINDOWS"
#
# 		) MySQL resolves unqualified column or alias references in ORDER BY clauses by searching
# 			in the select_expr values, then in the columns of the tables in the FROM clause.
#
# 			For GROUP BY or HAVING clauses, it searches the FROM clause before searching in the
# 			select_expr values.
#
# 			(For GROUP BY and HAVING, this differs from the pre-MySQL 5.0 behavior that used the same
# 			rules as for ORDER BY)
#
# 		) The LIMIT clause can be used to constrain the number of rows returned by the SELECT statement.
#
# 			LIMIT takes one or two numeric arguments, which must both be nonnegative integer constants,
# 			with these exceptions:
#
# 				) Within prepared statements, LIMIT parameters can be specified using ? placeholder markers.
#
# 				) Within stored programs, LIMIT parameters can be specified using integer-valued routine parameters
# 					or local variables.
#
# 			With two arguments, the first argument specifies the offset of the first row to return,
# 			and the second specifies the maximum number of rows to return.
#
# 			The offset of the initial row is 0 (not 1):
#
# 				SELECT * FROM tbl LIMIT 5,10; # Retrieve rows 6-15
#
# 			To retrieve all rows from a certain offset up to the end of the result set,
# 			you can use some large number for the second parameter.
#
# 			This statement retrieves all rows from the 96th row to the last:
#
# 				SELECT * FROM tbl LIMIT 95,<a lot>;
#
# 			With one argument, the value specifies the number of rows to return from the
# 			beginning of the result set:
#
# 				SELECT * FROM tbl LIMIT 5; #Retrieve first 5 rows
#
# 			In other words, LIMIT row_count is equivalent to LIMIT 0, row_count
#
# 			For prepared statements, you can use placeholders. The following statements will return
# 			one row from the tbl table:
#
# 				SET @a=1;
# 				PREPARE STMT FROM 'SELECT * FROM tbl LIMIT ?';
# 				EXECUTE STMT USING @a;
#
# 			The following statements will return the second to sixth row from the tbl table:
#
# 				SET @skip=1; SET @numrows=5;;
# 				PREPARE STMT FROM 'SELECT * FROM tbl LIMIT ?, ?';
# 				EXECUTE STMT USING @skip, @numrows;
#
# 			For compatibility with PostgreSQL, MySQL also supports the LIMIT row_count OFFSET offset syntax
#
# 			If LIMIT occurs within a subquery and also is applied in the outer query, the outermost
# 			LIMIT takes precedence.
#
# 			For example, the following statement produces two rows, not one:
#
# 				(SELECT --- LIMIT 1) LIMIT 2;
#
# 		) The SELECT_---_INTO form of SELECT enables the query result to be written to a file
# 			or stored in variables.
#
# 			For more information, see SECTION 13.2.10.1, "SELECT --- INTO SYNTAX"
#
# 		) If you use FOR UPDATE with a storage engine that uses page or row locks, rows examined
# 			by the query are write-locked until the end of the current transaction.
#
# 			You cannot use FOR UPDATE as part of the SELECT in a statement such as:
#
# 				CREATE_TABLE_new_table_SELECT_---_FROM_old_table_---
#
# 			(If you attempt to do so, the statement is rejected with the error Can't
# 			update table 'old_table' while 'new_table' is being created)
#
# 			FOR SHARE and LOCK IN SHARE MODE set shared locks that permit other transactions
# 			to read the examined rows but not to update or delete them.
#
# 			FOR SHARE and LOCK IN SHARE MODE are equivalent.
#
# 			However, FOR SHARE, like FOR UPDATE, supports NOWAIT, SKIP LOCKED,
# 			and OF tbl_name options.
#
# 			FOR SHARE is a replacement for LOCK IN SHARE MODE, but LOCK IN SHARE MODE
# 			remains available for backward compatibility.
#
# 			NOWAIT causes a FOR UPDATE or FOR SHARE query to execute immediately,
# 			returning an error if a row lock cannot be obtained due to a lock
# 			held by another transaction.
#
# 			SKIP LOCKED causes a FOR UPDATE or FOR SHARE query to execute immediately,
# 			excluding rows from the result set that are locked by another transaction.
#
# 			NOWAIT and SKIP LOCKED options are unsafe for statement-based replication.
#
# 				NOTE:
#
# 					Queries that skip locked rows return an inconsistent view of the data.
#
# 					SKIP LOCKED is therefore not suitable for general transactional work.
#
# 					However, it may be used to avoid lock contention when multiple sessions
# 					access the same queue-like table.
#
# 			OF tbl_name applies FOR UPDATE and FOR SHARE queries to named tables.
#
# 			For example:
#
# 				SELECT * FROM t1, t2 FOR SHARE OF t1 FOR UPDATE OF t2;
#
# 			All tables referenced by the query block are locked when OF tbl_name
# 			is omitted.
#
# 			Consequently, using a locking clause without OF tbl_name in combination
# 			with another locking clause returns an error.
#
# 			Specifying the same table in multiple locking clauses returns an error.
#
# 			If an alias is specified as the table name in the SELECT statement,
# 			a locking clause may only use the alias.
#
# 			If the SELECT statement does not specify an alias explicitly, the locking
# 			clause may only specify the actual table name.
#
# 			For more information about FOR UPDATE and FOR SHARE, see SECTION 15.7.2.4,
# 			"LOCKING READS"
#
# 			For additional information about NOWAIT and SKIP LOCKED options, see
# 			LOCKING READ CONCURRENCY WITH NOWAIT AND SKIP LOCKED.
#
# Following the SELECT keyword, you can use a number of modifiers that affect the
# operation of the statement.
#
# HIGH_PRIORITY, STRAIGHT_JOIN and modifiers beginning with SQL_ are MySQL extensions
# to standard SQL.
#
# 		) The ALL and DISTINCT modifiers specify whether duplicate rows should be returned.
#
# 			ALL (the default) specifies that all matching rows should be returned, including
# 			duplicates.
#
# 			DISTINCT specifies removal of duplicate rows from the result set.
#
# 			It is an error to specify both modifiers. DISTINCTROW is a synonym for
# 			DISTINCT.
#
# 			In MySQL 8.0.12 and later, DISTINCT can be used with a query that also uses
# 			WITH ROLLUP. (Bug #87450, Bug #26640100)
#
# 		) HIGH_PRIORITY gives the SELECT higher priority than a statement that updates a table.
#
# 			You should use this only for queries that are very fast and must be done at once.
#
# 			A SELECT HIGH_PRIORITY query that is issued while the table is locked for reading
# 			runs even if there is an update statement waiting for the table to be free.
#
# 			This affects only storage engines that use only table-level locking (such as MyISAM, MEMORY, and MERGE)
#
# 			HIGH_PRIORITY cannot be used with SELECT statements that are part of a UNION.
#
# 		) STRAIGHT_JOIN forces the optimizer to join the tables in the order in which they are listed
# 			in the FROM clause.
#
# 			You can use this to speed up a query if the optimizer joins the tables in nonoptimal
# 			order.
#
# 			STRAIGHT_JOIN also can be used in the table_references list. See SECTION 13.2.10.2, "JOIN SYNTAX"
#
# 			STRAIGHT_JOIN does not apply to any table that the optimizer treats as a const or system table.
#
# 			Such a table produces a single row, is read during the optimization phase of query execution,
# 			and references to its columns are replaced with the appropriate column values before query
# 			execution proceeds.
#
# 			These tables will appear first in the query plan displayed by EXPLAIN.
#
# 			See SECTION 8.8.1, "OPTIMIZING QUERIES WITH EXPLAIN"
#
# 			This exception may not apply to const or system tables that are
# 			used on the NULL-complemented side of an outer join (that is, the right-side table
# 			of a LEFT JOIN or the left-side table of a RIGHT JOIN)
#
# 		) SQL_BIG_RESULT or SQL_SMALL_RESULT can be used with GROUP BY or DISTINCT to tell
# 			the optimizer that the result set has many rows or is small, respectively.
#
# 			For SQL_BIG_RESULT, MySQL directly uses disk-based temporary tables if they are created,
# 			and prefers sorting to using a temporary table with a key on the GROUP BY elements.
#
# 			For SQL_SMALL_RESULT, MySQL uses in-memory temporary tables to store the resulting table
# 			instead of using sorting.
#
# 			This should not normally be needed.
#
# 		) SQL_BUFFER_RESULT forces the result to be put into a temporary table.
#
# 			This helps MySQL free the table locks early and helps in cases where
# 			it takes a long time to send the result set to the client.
#
# 			This modifier can be used only for top-level SELECT statements,
# 			not for subqueries or following UNION.
#
# 		) SQL_CALC_FOUND_ROWS tells MySQL to calculate how many rows there would be
# 			in the result set, disregarding any LIMIT clause.
#
# 			The number of rows can then be retrieved with SELECT FOUND_ROWS()
#
# 			See SECTION 12.15, "INFORMATION FUNCTIONS"
#
# 		) The SQL_CACHE and SQL_NO_CACHE modifiers were used with the query cache prior to MySQL 8.0
#
# 			The query cache was removed in MySQL 8.0
#
# 			The SQL_CACHE modifier was removed as well.
#
# 			SQL_NO_CACHE is deprecated, has no effect, and will be removed in a future MySQL release.
#
# A SELECT from a partitioned table using a storage engine such as MyISAM that employs
# table-level locks locks only those partitions containing rows that match the SELECT
# statement WHERE clause.
#
# (This does not occur with storage engines such as InnoDB that employ row-level locking)
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.10.1 SELECT --- INTO SYNTAX
#
# The SELECT_---_INTO form of SELECT enables a query result to be stored in variables or 
# written to a file:
#
# 		) SELECT --- INTO var_list selects column values and stores them into variables
#
# 		) SELECT --- INTO OUTFILE writes the selected rows to a file. Column and line terminators can be
# 			specified to produce a specific output format.
#
# 		) SELECT --- INTO DUMPFILE writes a single row to a file without any formatting.
#
# The SELECT syntax description (see SECTION 13.2.10, "SELECT SYNTAX") shows the INTO clause
# near the end of the statement.
#
# It is also possible to use INTO immediately following the select_expr list
#
# An INTO clause should not be used in a nested SELECT because such a SELECT
# must return its result to the outer context.
#
# The INTO clause can name a list of one or more variables, which can be user-defined
# variables, stored procedure or function parameters, or stored program local variables.
#
# (Within a prepared SELECT --- INTO OUTFILE statement, only user-defined variables
# are permitted; see SECTION 13.6.4.2, "LOCAL VARIABLE SCOPE AND RESOLUTION")
#
# The selected values are assigned to the variables.
#
# The number of variables must match the number of columns.
# The query should return a single row.
#
# If the query returns no rows, a warning with error code 1329 occurs
# (No data), and the variable values remain unchanged.
#
# If the query returns multiple rows, error 1172 occurs (Result consisted of more than one row)
#
# If it is possible that the statement may retrieve multiple rows, you can use LIMIT 1 to limit
# the result set to a single row.
#
# 		SELECT id, data INTO @x, @y FROM test.t1 LIMIT 1;
#
# User variable names are not case-sensitive. See SECTION 9.4, "USER-DEFINED VARIABLES"
#
# The SELECT_---_INTO_OUTFILE 'file_name' form of SELECT writes the selected rows to a file.
#
# The file is created on the server host, so you must have the FILE privilege to use this
# syntax.
#
# file_name cannot be an existing file, which among other things prevents files such as
# /etc/passwd and database tables from being destroyed.
#
# The character_set_filesystem system variable controls the interpretation of the file name.
#
# The SELECT_---_INTO_OUTFILE statement is intended primarily to let you very quickly
# dump a table to a text file on the server machine.
#
# If you want to create the resulting file on some other host than the server host,
# you normally cannot use SELECT_---_INTO_OUTFILE since there is no way to write a path
# to the file relative to the server host's file system.
#
# However, if the MySQL client software is installed on the remote machine, you can
# instead use a client command such as mysql -e "SELECT ---" > file_name to generate
# the file on the client host.
#
# It is also possible to create the resulting file on a different host other than the
# server host, if the location of the file on the remote host can be accessed using
# a network-mapped path on the server's file system.
#
# In this case, the presence of mysql (or some other MySQL client program) is not
# required on the target host.
#
# SELECT_---_INTO_OUTFILE is the complement of LOAD_DATA_INFILE.
#
# Columns values are written converted to the character set specified in the
# CHARACTER SET clause.
#
# If no such clause is present, values are dumped using the binary character set.
#
# In effect, there is no character set conversion. 
#
# If a result set contains columns in several character sets, 
# the output data file will as well and you may not be able to reload the file correctly.
#
# The syntax for the export_options part of the statement consists of the same FIELDS
# and LINES clauses that are used with the LOAD_DATA_INFILE statement.
#
# See SECTION 13.2.7, "LOAD DATA INFILE SYNTAX", for information about the FIELDS
# and LINES clauses, including their default values and permissible values.
#
# FIELDS ESCAPED BY controls how to write special characters.
#
# If the FIELDS ESCAPED BY character is not empty, it is used when necessary to avoid
# ambiguity as a prefix that precedes following characters on output:
#
# 		) The FIELDS ESCAPED BY character
#
# 		) The FIELDS [OPTIONALLY] ENCLOSED BY character
#
# 		) The first character of the FIELDS TERMINATED BY and LINES TERMINATED BY values
#
# 		) ASCII NUL (the zero-valued byte; what is actually written following the escape character is ASCII 0,
# 			not a zero-valuted byte)
#
# The FIELDS TERMINATED BY, ENCLOSED BY, ESCAPED BY, or LINES TERMINATED BY characters must be
# escaped so that you can read the file back in reliably.
#
# ASCII NUL is escaped to make it easier to view with some pagers.
#
# The resulting file does not have to conform to SQL syntax, so nothing else need be escaped.
#
# If the FIELDS ESCAPED BY character is empty, no characters are escaped and NULL is output as
# NULL, not \N
#
# It is probably not a good idea to specify an empty escape character, particularly if field values
# in your data contain any of the characters in the list just given.
#
# Here is an example that produces a file in the comma-separated values (CSV) format used
# by many programs:
#
# 		SELECT a,b,a+b INTO OUTFILE '/tmp/result.txt'
# 			FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
# 			LINES TERMINATED BY '\n'
# 			FROM test_table;
#
# If you use INTO DUMPFILE instead of INTO OUTFILE, MySQL writes only one row into the file,
# without any column or line termination and without performing any escape processing.
#
# This is useful if you want to store a BLOB value in a file.
#
# 		NOTE:
#
# 			Any file created by INTO OUTFILE or INTO DUMPFILE is writable by all users on the
# 			server host.
#
# 			The reason for this is that the MySQL server cannot create a file that is owned
# 			by anyone other than the user under whose account it is running.
#
# 			(You should never run mysqld as root for this and other reasons)
#
# 			The file thus must be world-writable so that you can manipulate its contents.
#
# 			If the secure_file_priv system variable is set to a nonempty directory name,
# 			the file to be written must be located in that directory.
#
# In the context of SELECT_---_INTO statements that occur as part of events executed by the
# Event Scheduler, diagnostics messages (not only errors, but also warnings) are written
# to the error log, and, on Windows, to the application event log.
#
# For additional information, see SECTION 24.4.5, "EVENT SCHEDULER STATUS"
#
# 13.2.10.2 JOIN SYNTAX
#
# MySQL supports the following JOIN syntax for the table_references part of SELECT
# statements and multiple-table DELETE and UPDATE statements:
#
# 		table_references:
# 			escaped_table_reference [, escaped_table_reference] ---
#
# 		escaped_table_reference:
# 			table_reference
# 		 | { OJ table_reference }
#
# 		table_reference:
# 			table_factor
# 		 | join_table
#
# 		table_factor:
# 				tbl_name [PARTITION (partition_names)]
# 					[[AS] alias] [index_hint_list]
# 			| table_subquery [AS] alias [(col_list)]
# 			| ( table_references )
#
# 		join_table:
# 			table_reference [INNER | CROSS] JOIN table_factor [join_condition]
# 		 | table_reference STRAIGHT_JOIN table_factor
# 		 | table_reference STRAIGHT_JOIN table_factor ON conditional_expr
# 		 | table_reference {LEFT|RIGHT} [OUTER] JOIN table_reference join_condition
# 		 | table_reference NATURAL [INNER | {LEFT|RIGHT} [OUTER]] JOIN table_factor
#
# 		join_condition:
# 			ON conditional_expr
# 		 | USING (column_list)
#
# 		index_hint_list:
# 			index_hint [, index_hint] ---
#
# 		index_hint:
# 			USE {INDEX|KEY}
# 				[FOR {JOIN|ORDER BY|GROUP BY}] ([index_list])
# 		 | IGNORE {INDEX|KEY}
# 				[FOR {JOIN|ORDER BY|GROUP BY}] (index_list)
# 		 | FORCE {INDEX|KEY}
# 				[FOR {JOIN|ORDER BY|GROUP BY}] (index_list)
#
# 		index_list:
# 			index_name [, index_name] ---
#
# A table reference is also known as a join expression
#
# A table reference (when it refers to a partitioned table) may contain a PARTITION option,
# including a list of comma-separated partitions, subpartitions, or both.
#
# This option follows the name of the table and precedes any alias declaration.
#
# The effect of this option is that rows are selected only from the listed partitions
# or subpartitions.
#
# Any partitions or subpartitions not named in the list are ignored.
#
# For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# The syntax of table_factor is extended in MySQL in comparison with standard SQL.
#
# The standard accepts only table_reference, not a list of them inside a pair of parentheses.
#
# This is a conservative extension if each comma in a list of table_reference items is considered
# as equivalent to an inner join.
#
# For example:
#
# 			SELECT * FROM t1 LEFT JOIN (t2, t3, t4)
# 									ON (t2.a = t1.a AND t3.b = t1.b AND t4.c = t1.c)
#
# 		is equivalent to:
#
# 			SELECT * FROM t1 LEFT JOIN (t2 CROSS JOIN t3 CROSS JOIN t4)
# 									ON (t2.a = t1.a AND t3.b = t1.b AND t4.c = t1.c)
#
# In MySQL, JOIN, CROSS JOIN and INNER JOIN are syntactic equivalents (they can replace each other)
#
# In standard SQL, they are not equivalent. INNER JOIN is used with an ON clause, CROSS JOIN
# is used otherwise.
#
# In general, parentheses can be ignored in join expressions containing only inner join operations.
#
# MySQL also supports nested joins. See SECTION 8.2.1.7, "NESTED JOIN OPTIMIZATION"
#
# Index hints can be specified to affect how the MySQL optimizer makes use of indexes.
# For more information, see SECTION 8.9.4, "INDEX HINTS"
#
# Optimizer hints and the optimizer_switch system variable are other ways to influence
# optimizer use of indexes.
#
# See SECTION 8.9.2, "OPTIMIZER HINTS", and SECTION 8.9.3, "SWITCHABLE OPTIMIZATIONS"
#
# The following list describes general factors to take into account when writing joins:
#
# 		) A table reference can be aliased using tbl_name AS alias_name or tbl_name alias_name:
#
# 			SELECT t1.name, t2.salary
# 				FROM employee AS t1 INNER JOIN info AS t2 ON t1.name = t2.name;
#
# 			SELECT t1.name, t2.salary
# 				FROM employee t1 INNER JOIN info t2 ON t1.name = t2.name;
#
# 		) A table_subquery is also known as a derived table or subquery in the FROM clause.
#
# 			See SECTION 13.2.11.8, "DERIVED TABLES"
#
# 			Such subqueries must include an alias to give the subquery result a table name,
# 			and may optionally include a list of table column names in parentheses.
#
# 			A trivial example follows:
#
# 				SELECT * FROM (SELECT 1, 2, 3) AS t1;
#
# 		) INNER JOIN and , (comma) are semantically equivalent in the absence of a join condition:
#
# 			Both produce a Cartesian product between the specified tables (that is, each and every row
# 			in the first table is joined to each and every row in the second table)
#
# 			However, the precedence of the comma operator is less than that of INNER JOIN, CROSS JOIN,
# 			LEFT JOIN, and so on.
#
# 			If you mix comma joins with the other join types when there is a join condition, an error
# 			of the form:
#
# 				Unknown column 'col_name' in 'on clause' may occur
#
# 			Information about dealing with this problem is given later in this section.
#
# 		) The conditional_expr used with ON is any conditional expression of the form that can be used
# 			in a WHERE clause.
#
# 			Generally, the ON clause serves for conditions that specify how to join tables,
# 			and the WHERE clause restricts which rows to include in the result set
#
# 		) If there is no matching row for the right table in the ON or USING part in a LEFT JOIN,
# 			a row with all columns set to NULL is used for the right table.
#
# 			You can use this fact to find rows in a table that have no counterpart in another table:
#
# 				SELECT left_tbl.*
# 					FROM left_tbl LEFT JOIN right_tbl ON left_tbl.id = right_tbl.id
# 					WHERE right_tbl.id IS NULL;
#
# 			This example finds all rows in left_tbl with an id value that is not present in
# 			right_tbl (that is, all rows in left_tbl with no corresponding row in right_tbl)
#
# 			See SECTION 8.2.1.8, "OUTER JOIN OPTIMIZATION"
#
# 		) The USING(column_list) clause names a list of columns that must exist in both tables.
#
# 			If tables a and b both contain columns c1, c2, and c3, the following join compares
# 			corresponding columns from the two tables:
#
# 				a LEFT JOIN b USING (c1, c2, c3)
#
# 		) The NATURAL [LEFT] JOIN of two tables is defined to be semantically equivalent to an
# 			INNER JOIN or a LEFT JOIN with a USING clause that names all columns that
# 			exist in both tables.
#
# 		) RIGHT JOIN works analogously to LEFT JOIN. To keep code portable across databases,
# 			it is recommended that you use LEFT JOIN instead of RIGHT JOIN.
#
# 		) The { OJ --- } syntax shown in the join syntax description exists only for compatibility
# 			with ODBC.
#
# 			The curly braces in the syntax should be written literally, they are not metasyntax
# 			as used elsewhere in syntax desc.
#
# 				SELECT left_tbl.*
# 					FROM { OJ left_tbl LEFT OUTER JOIN right_tbl ON left_tbl.id = right_tbl.id }
# 					WHERE right_tbl.id IS NULL;
#
# 			You can use other types of joins within { OJ --- }, such as INNER JOIN or RIGHT OUTER JOIN.
#
# 			This helps with compatibility with some third-party apps, but is not official ODBC syntax
#
# 		) STRAIGHT_JOIN is similar to JOIN, except that the left table is always read before the right table.
#
# 			This can be used for those (few) cases for which the join optimizer processes the tables
# 			in a suboptimal order.
#
# 			Some join examples:
#
# 				SELECT * FROM table1, table2;
#
# 				SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id;
#
# 				SELECT * FROM table1 LEFT JOIN table2 ON table1.id = table2.id;
#
# 				SELECT * FROM table1 LEFT JOIN table2 USING (id);
#
# 				SELECT * FROM table1 LEFT JOIN table2 ON table1.id = table2.id
# 					LEFT JOIN table3 ON table2.id = table3.id;
#
# Natural joins and joins with USING, including outer join variants, are processed
# according to the SQL:2003 standard:
#
# 		) Redundant columns of a NATURAL join do not appear.
#
# 			Consider this set of statements:
#
# 				CREATE TABLE t1 (i INT, j INT);
# 				CREATE TABLE t2 (k INT, j INT);
#
# 				INSERT INTO t1 VALUES(1, 1);
# 				INSERT INTO t2 VALUES(1, 1);
#
# 				SELECT * FROM t1 NATURAL JOIN t2;
# 				SELECT * FROM t1 JOIN t2 USING (j);
#
# 			In the first SELECT statement, column j appears in both tables and thus becomes
# 			a join column, so, according to standard SQL, it should appear only once in the output,
# 			not twice.
#
# 			Similarly, in the second SELECT statement, column j is named in the USING clause and
# 			should appear only once in the output, not twice.
#
# 			Thus, the statements produce this output:
#
# 				+--------+--------+----------+
# 				| j 	   | i      | k 		  |
# 				+--------+--------+----------+
# 				| 1 		| 1 		| 1 		  |
# 				+--------+--------+----------+
#
# 				+--------+--------+----------+
# 				| j 		| i 		| k 		  |
# 				+--------+--------+----------+
# 				| 1 		| 1 		| 1 		  |
# 				+--------+--------+----------+
#
# 			Redundant column elimination and column ordering occurs according to standard SQL,
# 			producing this display order:
#
# 				) First, coalesced common columns of the two joined tables, in the order in which they occur in the first table
#
# 				) Second, columns unique to the first table, in order in which they occur in that table
#
# 				) Third, columns unique to the second table, in order in which they occur in that table
#
# 			The single result column that replaces two common columns is defined using the coalesce operation.
#
# 			That is, for two t1.a and t2.a the resulting single join column a is defined as
# 			a = COALESCE(t1.a, t2.a), where:
#
# 				COALESCE(x, y) = (CASE WHEN x IS NOT NULL THEN x ELSE y END)
#
# 			If the join operation is any other join, the result columns of the join consist of the
# 			concatenation of all columns of the joined tables.
#
# 			A consequence of the definition of coalesced columns is that, for outer joins, the coalesced column
# 			contains the value of the non-NULL column if one of the two columns is always NULL.
#
# 			If neither or both columns are NULL, both common columns have the same value, so it does not
# 			matter which one is chosen at the value of the coalesced column.
#
# 			A simple way to interpret this is to consider that a coalesced column of an outer join
# 			is represented by the common column of the inner table of a JOIN.
#
# 			Suppose that the tables t1(a, b) and t2(a, c) have the following contents:
#
# 				t1 	t2
# 				----  ----
# 				1 x   2 z
# 				2 y   3 w
#
# 			Then, for this join, column a contains the values of t1.a
#
# 				SELECT * FROM t1 NATURAL LEFT JOIN t2;
# 				+---------+--------+-----------+
# 				| a       | b 		 | c 			 |
# 				+---------+--------+-----------+
# 				| 1 		 | x 		 | NULL   	 |
# 				| 2 		 | y 		 | z 			 |
# 				+---------+--------+-----------+
#
# 			By contrast, for this join, column a contains the values of t2.a
#
# 				SELECT * FROM t1 NATURAL RIGHT JOIN t2;
# 				+---------+---------+---------+
# 				| a 		 | c 		  | b 		|
# 				+---------+---------+---------+
# 				| 2 		 | z 		  | y 		|
# 				| 3 		 | w 		  | NULL 	|
# 				+---------+---------+---------+
#
# 			Compare those results to the otherwise equivalent queries with JOIN --- ON:
#
# 				SELECT * FROM t1 LEFT JOIN t2 ON (t1.a = t2.a);
# 				+--------+---------+---------+---------+
# 				| a      | b 		 | a 		  | c 		|
# 				+--------+---------+---------+---------+
# 				| 1 		| x 		 | NULL 	  | NULL 	|
# 				| 2 		| y 		 | 2 		  | z 		|
# 				+--------+---------+---------+---------+
#
# 				SELECT * FROM t1 RIGHT JOIN t2 ON (t1.a = t2.a);
# 				+--------+---------+---------+---------+
# 				| a 		| b 		 | a 		  | c 		|
# 				+--------+---------+---------+---------+
# 				| 2 		| y 		 | 2 		  | z 		|
# 				| NULL   | NULL 	 | 3 		  | w 		|
# 				+--------+---------+---------+---------+
#
# 		) A USING clause can be rewritten as an ON clause that compares corresponding columns.
#
# 			However, although USING and ON are similar, they are not quite the same.
#
# 			Consider the following two queries:
#
# 				a LEFT JOIN b USING (c1, c2, c3)
# 				a LEFT JOIN b ON a.c1 = b.c1 AND a.c2 = b.c2 AND a.c3 = b.c3
#
# 			With respect to determining which rows satisfy the join condition, both joins
# 			are semantically identical.
#
# 			With respect to determining which columns to display for SELECT * expansion,
# 			the two joins are not semantically identical.
#
# 			The USING join selects the coalesced value of corresponding columns,
# 			whereas the ON join selects all columns from all tables.
#
# 			For the USING join, SELECT * selects these values:
#
# 				COALESCE(a.c1, b.c1), COALESCE(a.c2, b.c2), COALESCE(a.c3, b.c3)
#
# 			For the ON join, SELECT * selects these values:
#
# 				a.c1, a.c2, a.c3, b.c1, b.c2, b.c3
#
# 			With an inner join, COALESCE(a.c1, b.c1) is the same as either a.c1 or
# 			b.c1 because both columns will have teh same value.
#
# 			With an outer join (such as LEFT JOIN), one of the two columns can be NULL
#
# 			That column is omitted from the result.
#
# 		) An ON clause can refer only to its operands.
#
# 			Example:
#
# 				CREATE TABLE t1 (i1 INT);
# 				CREATE TABLE t2 (i2 INT);
# 				CREATE TABLE t3 (i3 INT);
# 				SELECT * FROM t1 JOIN t2 ON (i1 = i3) JOIN t3;
#
# 			The statement fails with an Unknown column 'i3' in 'on clause' error because
# 			i3 is a column in t3, which is not an operand of the ON clause.
#
# 			To enable the join to be processed, rewrite the statement as follows:
#
# 				SELECT * FROM t1 JOIN t2 JOIN t3 ON (i1 = i3);
#
# 		) JOIN has higher precedence than the comma operator (,), so the join expression
# 			t1, t2 JOIN t3 is interpreted as (t1, (t2 JOIN t3)), not as ((t1, t2) JOIN t3)
#
# 			This affects statements that use an ON clause because that clause can refer only
# 			to columns in the operands of the join, and the precedence affects interpretation
# 			of what those operands are.
#
# 			EXAMPLE:
#
# 				CREATE TABLE t1 (i1 INT, j1 INT);
# 				CREATE TABLE t2 (i2 INT, j2 INT);
# 				CREATE TABLE t3 (i3 INT, j3 INT);
#
# 				INSERT INTO t1 VALUES(1, 1);
# 				INSERT INTO t2 VALUES(1, 1);
# 				INSERT INTO t3 VALUES(1, 1);
#
# 				SELECT * FROM t1, t2 JOIN t3 ON (t1.i1 = t3.i3);
#
# 			The JOIN takes precedence over the comma operator, so the operands for the ON clause
# 			are t2 and t3.
#
# 			Because t1.i1 is not a column in either of the operands, the result is an
# 			Unknown column 't1.i1' in 'on clause' error
#
# 			To enable the join to be processed, use either of these strategies:
#
# 				) Group the first two tables explicitly with parentheses so that the operands
# 					for the ON clause are (t1, t2) and t3:
#
# 					SELECT * FROM (t1, t2) JOIN t3 ON (t1.i1 = t3.i3);
#
# 				) Avoid the use of the comma operator and use JOIN instead:
#
# 					SELECT * FROM t1 JOIN t2 JOIN t3 ON (t1.i1 = t3.i3);
#
# 			The same precedence interpretation also applies to statements that mix
# 			the comma operator with INNER JOIN, CROSS JOIN, LEFT JOIN, and RIGHT JOIN,
# 			all of which have higher precedence than the comma operator.
#
# 		) A MySQL extension compared to the SQL:2003 standard is that MySQL permits you to
# 			qualify the common (coalesced) columns of NATURAL or USING joins, whereas 
# 			the standard disallows that.
#
# 13.2.10.3 UNION SYNTAX
#
# 		SELECT ---
# 		UNION [ALL | DISTINCT] SELECT ---
# 		[UNION [ALL | DISTINCT] SELECT ---]
#
# UNION is used to combine the result from multiple SELECT statements into a single result set.
#
# The column names from the first SELECT statement are used as the column names for the
# results returned.
#
# Selected columns listed in corresponding positions of each SELECT statement should have
# the same data type.
#
# (For example, the first column selected by the first statement should have the same type
# as the first column selected by the other statements)
#
# If the data types of corresponding SELECT columns do not match, the types and lengths of
# the columns in the UNION result take into account the values retrieved by all of
# the SELECT statements.
#
# For example, consider the following:
#
# 		SELECT REPEAT('a',1) UNION SELECT REPEAT('b',10);
# 		+----------------------+
# 		| REPEAT('a',1) 		  |
# 		+----------------------+
# 		| a 						  |
# 		| bbbbbbbbbb 			  |
# 		+----------------------+
#
# The SELECT statements are normal select statements, but with the following restrictions:
#
# 		) Only the last SELECT statement can use INTO OUTFILE (However, the entire UNION result is written to the file)
#
# 		) HIGH_PRIORITY cannot be used with SELECT statements that are part of a UNION.
#
# 			If you specify it for the first SELECT, it has no effect.
#
# 			If you specify it for any subsequent SELECT statements, a syntax error results.
#
# The default behavior for UNION is that duplicate rows are removed from the result.
#
# The optional DISTINCT keyword has no effect other than the default because it also
# specifies duplicate-row removal.
#
# With the optional ALL keyword, duplicate-row removal does not occur and the result includes
# all matching rows from all the SELECT statements.
#
# You can mix UNION_ALL and UNION_DISTINCT in the same query.
#
# Mixed UNION types are treated such that a DISTINCT union overrides any ALL union
# to its left.
#
# A DISTINCT union can be produced explicitly by using UNION_DISTINCT or implicitly
# by using UNION with no following DISTINCT or ALL keyword.
#
# To apply ORDER BY or LIMIT to an individual SELECT, place the clause inside the
# parentheses that enclose the SELECT:
#
# 		(SELECT a FROM t1 WHERE a=10 AND B=1 ORDER BY a LIMIT 10)
# 		UNION
# 		(SELECT a FROM t2 WHERE a=11 AND B=2 ORDER BY a LIMIT 10);
#
# However, use of ORDER BY for individual SELECT statements implies nothing about
# the order in which the rows appear in the final result because UNION
# by default produces an unordered set of rows.
#
# Therefore, the use of ORDER BY in this context is typically in conjunction
# with LIMIT, so that it is used to determine the subset of the selected
# rows to retrieve for the SELECT, even though it does not necessarily affect
# the order of those rows in the final UNION result.
#
# If ORDER BY appears without LIMIT in a SELECT, it is optimized away
# because it will have no effect anyway.
#
# To use an ORDER BY or LIMIT clause to sort or limit the entire UNION result,
# parenthesize the individual SELECT statements and place the ORDER BY or
# LIMIT after the last one.
#
# The following example uses both clauses:
#
# 		(SELECT a FROM t1 WHERE a=10 AND B=1)
# 		UNION
# 		(SELECT a FROM t2 WHERE a=11 AND B=2)
# 		ORDER BY a LIMIT 10;
#
# A statement without parentheses is equivalent ot one parenthesized
# as just shown.
#
# This kind of ORDER BY cannot use column references that include a table
# name (that is, names in tbl_name.col_name format)
#
# Instead, provide a column alias in the first SELECT statement and refer
# to the alias in the ORDER BY.
#
# (Alternatively, refer to the column in the ORDER BY using its column position.
#
# However, use of column positions is deprecated)
#
# Also, if a column to be sorted is aliased, the ORDER BY clause must refer to the
# alias, not the column name.
#
# The first of the following statements will work, but the second will fail
# with an:
#
# 		Unknown column 'a' in 'order clause' error
#
# 		(SELECT a AS b FROM t) UNION (SELECT ---) ORDER BY b;
# 		(SELECT a AS b FROM t) UNION (SELECT ---) ORDER BY a;
#
# To cause rows in a UNION result to consist of the sets of rows retrieved by each
# SELECT one after the other, select an additional column in each SELECT to use
# as a sort column and add an ORDER BY following the last SELECT:
#
# 		(SELECT 1 AS sort_col, col1a, col1b, --- FROM t1)
# 		UNION
# 		(SELECT 2, col2a, col2b, --- FROM t2) ORDER BY sort_col;
#
# To additionally maintain sort order within individual SELECT results,
# add a secondary column to the ORDER BY clause:
#
# 		(SELECT 1 AS sort_col, col1a, col1b, --- FROM t1)
# 		UNION
# 		(SELECT 2, col2a, col2b, --- FROM t2) ORDER BY sort_col, col1a;
#
# Use of an additional column also enables you to determine which SELECT
# each row comes from.
#
# Extra columns can provide other identifying information as well, such as
# a string that indicates a table name.
#
# UNION queries with an aggregate function in an ORDER BY clause are rejected
# with an ER_AGGREGATE_ORDER_FOR_UNION error.
#
# Example:
#
# 		SELECT 1 AS foo UNION SELECT 2 ORDER BY MAX(1);
#
# 13.2.11 SUBQUERY SYNTAX
#
# 13.2.11.1 THE SUBQUERY AS SCALAR OPERAND
# 13.2.11.2 COMPARISONS USING SUBQUERIES
# 13.2.11.3 SUBQUERIES WITH ANY, IN, or SOME
#
# 13.2.11.4 SUBQUERIES WITH ALL
# 13.2.11.5 ROW SUBQUERIES
# 13.2.11.6 SUBQUERIES WITH EXISTS OR NOT EXISTS
#
# 13.2.11.7 CORRELATED SUBQUERIES
# 13.2.11.8 DERIVED TABLES
# 13.2.11.9 SUBQUERY ERRORS
#
# 13.2.11.10 OPTIMIZING SUBQUERIES
# 13.2.11.11 REWRITING SUBQUERIES AS JOINS
#
# A subquery is a SELECT statement within another statement.
#
# All subquery forms and operations that the SQL standard requires are supported,
# as well as a few features that are MySQL-specific.
#
# Here is an example of a subquery:
#
# 		SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);
#
# In this example, SELECT * FROM t1 --- is the outer query (or outer statement), and
# (SELECT column1 FROM t2) is the subquery.
#
# We say that the subquery is nested within the outer query, and in fact it is possible
# to nest subqueries within other subqueries, to a considerable depth.
#
# A subquery must always appear within parentheses.
#
# The main advantages of subqueries are:
#
# 		) They allow queries that are structured so that it is possible to isolate each part of a statement
#
# 		) They provide alternative ways to perform operations that would otherwise reuqire complex joins and unions
#
# 		) Many people find subqueries more readable than complex joins or unions.
#
# Here is an example statement that shows the major points about subquery syntax as specified
# by the SQL standard and supported in MySQL:
#
# 		DELETE FROM t1
# 		WHERE s11 > ANY
# 			(SELECT COUNT(*) /* no hint */ FROM t2
# 				WHERE NOT EXISTS
# 					(SELECT * FROM t3
# 						WHERE ROW(5*t2.s1,77)=
# 						 	(SELECT 50,11*s1 FROM t4 UNION SELECT 50,77 FROM
# 								(SELECT * FROM t5) AS t5)));
#
# A subquery can return a scalar (a single value), a single row, a single column or a table
# (one or more rows of one or more columns)
#
# These are called scalar, column, row, and table subqueries.
#
# Subqueries that return a particular kind of result often can be used only in certain
# contexts, as described in teh following sections.
#
# There are few restrictions on the type of statements in which subqueries can be used.
#
# A subquery can contain many of the keywords or clauses that an ordinary SELECT
# can contain:
#
# 		DISTINCT
#
# 		GROUP BY
#
# 		ORDER BY
#
# 		LIMIT
#
# 		joins
#
# 		index hints
#
# 		UNION constructs
#
# 		comments
#
# 		functions
#
# 		etc.
#
# A subquery's outer statement can be any one of:
#
# 		SELECT
#
# 		INSERT
#
# 		UPDATE
#
# 		DELETE
#
# 		SET
#
# 		DO
#
# In MySQL, you cannot modify a table and select from the same table in a subquery.
#
# This applies to statements such as DELETE, INSERT, REPLACE, UPDATE and LOAD DATA INFILE (because subqueries can be used in the SET clause)
#
# For information about how the optimizer handles subqueries, see SECTION 8.2.2,
# "OPTIMIZING SUBQUERIES, DERIVED TABLES, VIEW REFERENCES, AND COMMON TABLE EXPRESSIONS"
#
# For a discussion of restrictions on subquery use, including performance issues for certain
# forms of subquery syntax, see SECTION C.4, "RESTRICTIONS ON SUBQUERIES"
#
# 13.2.11.1 THE SUBQUERY AS SCALAR OPERAND
#
# In its simplest form, a subquery is a scalar subquery that returns a single value.
#
# A scalar subquery is a simple operand, and you can use it almost anywhere a single
# column value or literal is legal, and you can expect it to have those characteristics
# that all operands have:
#
# 		a data type
#
# 		a length
#
# 		indication taht it can be NULL
#
# 		etc.
#
# For example:
#
# 		CREATE TABLE t1 (s1 INT, s2 CHAR(5) NOT NULL);
# 		INSERT INTO t1 VALUES(100, 'abcde');
# 		SELECT (SELECT s2 FROM t1);
#
# The subquery in this SELECT returns a single value ('abcde') that has a data type
# of CHAR, a length of 5, a character set and collation equal to the defaults in effect
# at CREATE_TABLE time, and an indication that the value in the column can be NULL.
#
# Nullability of the value selected by a scalar subquery is not copied because if the
# subquery result is empty,, the result is NULL.
#
# For the subquery just shown, if t1 were empty, the result would be NULL even though
# s2 is NOT NULL
#
# There are a few contexts in which a scalar subquery cannot be used.
#
# If a statement permits only a literal value, you cannot use a subquery.
#
# For example, LIMIT requires literal integer arguments, and LOAD_DATA_INFILE
# requires a literal string file name.
#
# You cannot use subqueries to supply these values.
#
# When you see examples in the following sections that contain the rather 
# spartan construct (SELECT column1 FROM t1), imagine that your own code contains
# much more diverse and complex stuff.
##
# Suppose that we make two tables:
#
# 		CREATE TABLE t1 (s1 INT);
# 		INSERT INTO t1 VALUES(1);
#
# 		CREATE TABLE t2 (s1 INT);
# 		INSERT INTO t2 VALUES(2);
#
# Then perform a SELECT:
#
# 		SELECT (SELECT s1 FROM t2) FROM t1;
#
# The result is 2 because there is a row in t2 containing a column s1 that
# has a value of 2.
#
# A scalar subquery can be part of an expression, but remember the parentheses,
# even if the subquery is an operand that provides an argument for a function.
#
# For example:
#
# 		SELECT UPPER((SELECT s1 FROM t1)) FROM t2;
#
# 13.2.11.2 COMPARISONS USING SUBQUERIES
#
# The most common use of a subquery is in the form:
#
# 		non_subquery_operand comparison_operator (subquery)
#
# Where comparison_operator is one of these operators:
#
# 		= > < >= <= <> != <=>
#
# For example:
#
# 		--- WHERE 'a' = (SELECT column1 FROM t1)
#
# MySQL also permits this construct:
#
# 		non_subquery_operand LIKE (subquery)
#
# At one time the only legal place for a subquery was on the right side of a comparison,
# and you might still find some old DBMSs that insist on this.
#
# Here is an example of a common-form subquery comparison that you cannot do with a join.
#
# It finds all the rows in table t1 for which the column1 value is equal to
# a maximum value in table t2:
#
# 		SELECT * FROM t1
# 			WHERE column1 = (SELECT MAX(column2) FROM t2);
#
# Here is another example, which again is impossible with a join because it
# involves aggregating for one of the tables.
#
# It finds all rows in table t1 containing a value that occurs twice
# in a given column:
#
# 		SELECT * FROM t1 AS t
# 			WHERE 2 = (SELECT COUNT(*) FROM t1 WHERE t1.id = t.id);
#
# For a comparison of the subquery to a scalar, the subquery must return a scalar.
#
# For a comparison of the subquery to a row constructor, the subquery must be a row
# subquery that returns a row with the same number of values as the row constructor.
#
# See SECTION 13.2.11.5, "ROW SUBQUERIES"
#
# 13.2.11.3 SUBQUERIES WITH ANY, IN, OR SOME
#
# Syntax:
#
# 		operand comparison_operator ANY (subquery)
# 		operand IN (subquery)
# 		operand comparison_operator SOME (subquery)
#
# Where comparison_operator is one of these operators:
#
# 		= > < >= <= <> !=
#
# The ANY keyword, which must follow a comparison operator, means
# "return TRUE if the comparison is TRUE for ANY of the values in teh column that the subquery returns"
#
# For example:
#
# 		SELECT s1 FROM t1 WHERE s1 > ANY (SELECT s1 FROM t2);
#
# Suppose that there is a row in table t1 containing (10)
#
# The expression is TRUE if table t2 contains (21, 14, 7) because there is a value
# 7 in t2 that is less than 10.
#
# The expression is FALSE if table t2 contains (20,10), or if table  t2 is empty
#
# The expression is unknown (that is, NULL) if table t2 contains (NULL, NULL, NULL)
#
# When used with a subquery, the word IN is an alias for = ANY
#
# Thus, these two statements are the same:
#
# 		SELECT s1 FROM t1 WHERE s1 = ANY (SELECT s1 FROM t2);
# 		SELECT s1 FROM t1 WHERE s1 IN 	(SELECT s1 FROM t2);
#
# IN and = ANY are not synonyms when used with an expression list.
#
# IN can take an expression list, but = ANY cannot.
#
# See SECTION 12.3.2, "COMPARISON FUNCTIONS AND OPERATORS"
#
# NOT IN is not an alias for <> ANY, but for <> ALL. See SECTION 13.2.11.4,, "SUBQUERIES WITH ALL"
#
# The word SOME is an alias for ANY. Thus, these two statements are the same:
#
# 		SELECT s1 FROM t1 WHERE s1 <> ANY 	(SELECT s1 FROM t2);
# 		SELECT s1 FROM t1 WHERE s1 <> SOME  (SELECT s1 FROM t2);
#
# Use of the word SOME is rare, but this example shows why it might be useful.
#
# To most people, the enlgish phrase "a is not equal to b" means "there is no b which is equal
# to a", but that is not what is meant by the SQL syntax.
#
# The <> syntax means, not equal to or !=
#
# The syntax means "there is some b to which a is not equal"
#
# Using <> SOME instead helps ensure the meaning
#
# 13.2.11.4 SUBQUERIES WITH ALL
#
# Syntax:
#
# 		operand comparison_operator ALL (subquery)
#
# The word ALL which must follow a comparison operator, means "return TRUE if the comparison is TRUE for ALL of the
# values in the column that the subquery returns"
#
# For example:
#
# 		SELECT s1 FROM t1 WHERE s1 > ALL (SELECT s1 FROM t2);
#
# Suppose that there is a row in table t1 containing (10)
#
# The expression is TRUE if table t2 contains (-5,0,+5) because 10 is greater than all
# three values in t2.
#
# The expression is FALSE if table t2 contains (12,6,NULL,-100) beause there is a single
# value 12 in table t2 that is greater than 10.
#
# The expression is unknown (that is, NULL) if table t2 contains (0,NULL,1)
#
# Finally, the expression is TRUE if table t2 is empty.
#
# So, the following expression is TRUE when table t2 is empty:
#
# 		SELECT * FROM t1 WHERE 1 > ALL (SELECT s1 FROM t2);
#
# But this expression is NULL when table t2 is empty:
#
# 		SELECT * FROM t1 WHERE 1 > (SELECT s1 FROM t2);
#
# In addition, the following expression is NULL when table t2 is empty:
#
# 		SELECT * FROM t1 WHERE 1 > ALL (SELECT MAX(s1) FROM t2);
#
# In general, tables containing NULL values and empty tables are "edge cases"
#
# When writing subqueries, always consider whether you have taken those two
# possibilities in account.
#
# NOT IN is an alias for <> ALL. Thus, these two statements are teh same:
#
# 		SELECT s1 FROM t1 WHERE s1 <> ALL (SELECT s1 FROM t2);
# 		SELECT s1 FROM t1 WHERE s1 NOT IN (SELECT s1 FROM t2);
#
# 13.2.11.5 ROW SUBQUERIES
#
# Scalar or column subqueries return a single value or a column of values.
#
# A row subquery is a subquery variant that returns a single row an can thus
# return more than one column value.
#
# Legal operators for row subquery comparisons are:
#
# 		= > < >= <= <> != <=>
#
# Here are two examples:
#
# 		SELECT * FROM t1
# 			WHERE (col1,col2) = (SELECT col3, col4 FROM t2 WHERE id = 10);
# 		SELECT * FROM t1
# 			WHERE ROW(col1,col2) = (SELECT col3, col4 FROM t2 WHERE id = 10);
#
# For both queries, if the table t2 contains a single row with id = 10, the subquery
# returns a single row.
#
# If this row has col3 and col4 values equal to the col1 and col2 values of any rows
# in t1, the WHERE expression is TRUE and each query returns those t1 rows.
#
# If the t2 row col3 and col4 values are not equal the col1 and col2 values
# of any t1 row, the expression is FALSE and the query returns an empty result set.
#
# The expression is unknown(that is,NULL) if the subquery produces no rows.
#
# An error occurs if the subquery produces multiple rows because a row subquery
# can return at most one row.
#
# For information about how each operator work for row comparisons, see SECTION 12.3.2,
# "COMPARISON FUNCTIONS AND OPERATORS"
#
# The expressions (1,2) and ROW(1,2) are sometimes called row constructors.
#
# The two are equivalent.
#
# The row constructor and the row returned by the subquery must contain the same number of values
#
# A row constructor is used for comparisons with subqueries that return two or more columns.
#
# When a subquery returns a single column, this is regarded as a scalar value and not as
# a row, so a row constructor cannot be used with a subquery that does not return at least
# two columns.
#
# Thus, the following query fails with a syntax error:
#
# 		SELECT * FROM t1 WHERE ROW(1) = (SELECT column1 FROM t2)
#
# Row constructors are legal in other contexts.
#
# For example, the following two statements are semantically equivalent 
# (and are handled in the same way by the optimizer):
#
# 		SELECT * FROM t1 WHERE (column1, column2) = (1,1);
# 		SELECT * FROM t1 WHERE column1 = 1 AND column2 = 1;
#
# The following query answers the request, "find all rows in table t1 that also exist in table t2":
#
# 		SELECT column1, column2, column3
# 			FROM t1
# 			WHERE (column1, column2, column3) IN
# 					 (SELECT column1, column2, column3 FROM t2);
#
# For more information about the optimizer and row constructors, see SECTION 8.2.1.20, "ROW CONSTRUCTOR EXPRESSION OPTIMIZATION"
#
# 13.2.11.6 SUBQUERIES WITH EXISTS OR NOT EXISTS
#
# If a subquery returns any rows at all, EXISTS subquery is TRUE, and NOT EXISTS subquery is FALSE.
#
# For example:
#
# 		SELECT column1 FROM t1 WHERE EXISTS (SELECT * FROM t2);
#
# Traditionally, an EXISTS subquery starts with SELECT *, but it could begin with SELECT 5 or SELECT column1
# or anything at all.
#
# MySQL ignores the SELECT list in such a subquery, so it makes no difference.
#
# For the preceding example, if t2 contains any rows, even rows with nothing but NULL values,
# the EXISTS condition is TRUE.
#
# This is actually an unlikely example because a [NOT] EXISTS subquery almost always
# contains correlations.
#
# Here are some more realistic examples:
#
# 		) What kind of store is present in one or more cities
#
# 			SELECT DISTINCT store_type FROM stores
# 				WHERE EXISTS (SELECT * FROM cities_stores
# 								  WHERE cities_stores.store_type = stores.store_type);
#
# 		) What kind of store is present in no cities?
#
# 			SELECT DISTINCT store_type FROM stores
# 				WHERE NOT EXISTS (SELECT * FROM cities_stores
# 										WHERE cities_stores.store_type = stores.store_type);
#
# 		) What kind of store is present in all cities?
#
# 			SELECT DISTINCT store_type FROM stores s1
# 				WHERE NOT EXISTS (
# 					SELECT * FROM cities WHERE NOT EXISTS (
# 						SELECT * FROM cities_stores
# 							WHERE cities_stores.city = cities.city
# 							AND cities_stores.store_type = stores.store_type));
#
# The last example is a double-nested NOT EXISTS query.
#
# That is, it has a NOT EXISTS clause within a NOT EXISTS clause.
#
# Formally, it answers the question "does a city exist with a store that is not in Stores"?
#
# But it is easier to say that a nested NOT EXISTS answers the question "is x TRUE for all y?"
#
# 13.2.11.7 CORRELATED SUBQUERIES
#
# A correlated subquery is a subquery that contains a reference to a table that also appears
# in the outer query.
#
# For example:
#
# 		SELECT * FROM t1
# 			WHERE column1 = ANY (SELECT column1 FROM t2
# 										WHERE t2.column2 = t1.column2);
#
# Notice that the subquery contains a reference to a column of t1, even though
# the subquery's FROM clause does not mention a table t1
#
# So, MySQL looks outside the subquery, and finds t1 in the outer query
#
# Suppose that table t1 contains a row where column1 = 5 and column2 = 6; meanwhile,
# table t2 contains a row where column1 = 5 and column2 = 7
#
# The simple expression --- WHERE column1 = ANY (SELECT column1 FROM t2) would be TRUE,
# but in this example, the WHERE clause within the subquery is FALSE (because (5,6) is
# not equal to (5,7)), so the expression as a whole is FALSE
#
# SCOPING RULE: MySQL evaluates from inside to outside.
#
# For example:
#
# 		SELECT column1 FROM t1 AS x
# 			WHERE x.column1 = (SELECT column1 FROM t2 AS x
# 				WHERE x.column1 = (SELECT column1 FROM t3
# 					WHERE x.column2 = t3.column1));
#
# In this statement, x.column2 must be a column in table t2 because SELECT column1 FROM t2 AS x ---
# renames t2 
#
# It is not a column in table t1 because SELECT column1 FROM t1 --- is an outer query that is farther out
#
# For subqueries in HAVING or ORDER BY clauses, MySQL also looks for column names
# in the outer select list.
#
# For certain cases, a correlated subquery is optimized.
#
# For example:
#
# 		val IN (SELECT key_val FROM tbl_name WHERE correlated_condition)
#
# Otherwise, they are inefficient and likely to be slow.
#
# Rewriting the query as a join might improve performance.
#
# Aggregate functions in correlated subqueries may contain outer references,
# provided the function contains nothing but outer references, and provided the
# function is not contained in another function or expression.
#
# 13.2.11.8 DERIVED TABLES
#
# A derived table is an expression that generates a table within the scope of a query
# FROM clause.
#
# For example, a subquery in a SELECT statement FROM clause is a derived table:
#
# 		SELECT --- FROM (subquery) [AS] tbl_name ---
#
# The JSON_TABLE() function generates a table and provides another way to create a derived table:
#
# 		SELECT * FROM JSON_TABLE(arg_list) [AS] tbl_name ---
#
# The [AS] tbl_name clause is mandatory because every table in a FROM clause must have
# a name.
#
# Any columns in the derived table must have unique names.
#
# Alternatively, tbl_name may be followed by a parenthesized list of names
# for the derived table columns:
#
# 		SELECT --- FROM (subquery) [AS] tbl_name (col_list) ---
#
# The number of column names must be the same as the number of table columns.
#
# For the sake of illustration, assume that you have this table:
#
# 		CREATE TABLE t1 (s1 INT, s2 CHAR(5), s3 FLOAT);
#
# Here is how to use a subquery in the FROM clause, using the example table:
#
# 		INSERT INTO t1 VALUES (1, '1', 1.0);
# 		INSERT INTO t1 VALUES (2, '2', 2.0);
# 		SELECT sb1,sb2,sb3
# 			FROM (SELECT s1 AS sb1, s2 AS sb2, s3*2 AS sb3 FROM t1) AS sb
# 			WHERE sb1 > 1;
#
# Result:
#
# 		+-------+---------+-----------+
# 		| sb1   | sb2 	   | sb3 		|
# 		+-------+---------+-----------+
# 		| 2 	  | 2 		| 4 			|
# 		+-------+---------+-----------+
#
# Here is another example: Suppose that you want to know the average of a set
# of sums for a grouped table.
#
# This does not work:
#
# 		SELECT AVG(SUM(column1)) FROM t1 GROUP BY column1;
#
# However, this query provides the desired information:
#
# 		SELECT AVG(sum_column1)
# 			FROM (SELECT SUM(column1) AS sum_column1
# 					FROM t1 GROUP BY column1) AS t1;
#
# Notice that the column name used within the subquery (sum_column1) is recognized
# in the outer query.
#
# The column names for a derived table come from its select list:
#
# 		SELECT * FROM (SELECT 1, 2, 3, 4) AS dt;
# 		+----+-----+------+------+
# 		| 1  | 2   | 3    | 4    |
# 		+----+-----+------+------+
# 		| 1  | 2   | 3    | 4 	 |
# 		+----+-----+------+------+
#
# To provide column names explicitly, follow the derived table
# name with a parenthesized list of column names:
#
# 		SELECT * FROM (SELECT 1, 2, 3, 4) AS dt (a, b, c, d);
# 		+----+------+------+---------+
# 		| a  | b    | c 	 | d 		  |
# 		+----+------+------+---------+
# 		| 1  | 2    | 3    | 4 		  |
# 		+----+------+------+---------+
#
# A derived table can return a scalar, column, row or table
#
# Derived tables are subject to these restrictions:
#
# 		) A derived table cannot be a correlated subquery
#
# 		) A derived table cannot contain references to other tables of the same SELECT
#
# 		) Prior to MySQL 8.0.14, a derived table cannot contain outer references.
#
# 			This is a MySQL restriction that is lifted in MySQL 8.0.14, not a restriction
# 			of the SQL standard.
#
# 			For example, the derived table dt in the following query contains a reference
# 			t1.b to the table t1 in the outer query:
#
# 				WHERE t1.d > (SELECT AVG(dt.a)
# 									FROM (SELECT SUM(t2.a) AS a FROM
# 											t2 WHERE t2.b = t1.b GROUP BY t2.c) dt
# 								WHERE dt.a > 10);
#
# 			The query is valid in MySQL 8.0.14 and higher.
#
# 			Before 8.0.14, it produces an error: 
#
# 				Unknown column 't1.b' in 'where clause'
#
# The optimizer determines information about derived tables in such a way that
# EXPLAIN does not need to materialize them.
#
# See SECTION 8.2.2.4, "OPTIMIZING DERIVED TABLES, VIEW REFERENCES, AND COMMON TABLE
# EXPRESSIONS WITH MERGING OR MATERIALIZATION"
#
# It is possible under certain circumstances that using EXPLAIN_SELECT will modify table
# data.
#
# This can occur if the outer query accesses any tables and an inner query invokes
# a stored function that changes one or more rows of a table.
#
# Suppose that there are two tables t1 and t2 in database d1, and a stored function
# f1 that modifies t2, created as shown here:
#
# 		CREATE DATABASE d1;
# 		USE d1;
# 		CREATE TABLE t1 (c1 INT);
# 		CREATE TABLE t2 (c1 INT);
# 		CREATE FUNCTION f1(p1 INT) RETURNS INT
# 			BEGIN
# 				INSERT INTO t2 VALUES (p1);
# 				RETURN p1;
# 			END;
#
# Referencing the function directly in an EXPLAIN_SELECT has no effect on t2,
# as shown here:
#
# 		SELECT * FROM t2;
# 		Empty set (0.02 sec)
#
# 		EXPLAIN SELECT f1(5)\G
# 		******************************* 1. row ***********************************
# 
# 								id: 1
# 					select_type: SIMPLE
# 							table: NULL
# 					partitions : NULL
# 							type : NULL
# 				possible_keys : NULL
# 				key 			  : NULL
# 						key_len : NULL
# 							ref  : NULL
# 							rows : NULL
# 						filtered: NULL
# 							Extra: No tables used
# 				1 row in set (0.01 sec)
#
# 		SELECT * FROM t2;
# 		Empty set (0.01 sec)
#
# This is because the SELECT statement did not reference any tables, as can be seen in the 
# table and Extra columns of the output.
#
# This is also true of the following nested SELECT:
#
# 		EXPLAIN SELECT NOW() AS a1, (SELECT f1(5)) AS a2\G
# 		************************* 1. row *****************************
# 
# 								id: 1
# 				select_type   : PRIMARY
# 							table: NULL
# 						   type : NULL
# 				possible_keys : NULL
# 							  key: NULL
# 						key_len : NULL
# 							  ref: NULL
# 							rows : NULL
# 						filtered: NULL
# 							Extra: No tables used
# 		1 row in set, 1 warning (0.00 sec)
#
# 		SHOW WARNINGS;
# 		+--------+----------+--------------------------------------------+
# 		| Level  | Code 	  | Message 											  |
# 		+--------+----------+--------------------------------------------+
# 		| Note   | 1249     | Select 2 was reduced during optimization   |
# 		+--------+----------+--------------------------------------------+
# 		1 row in set (0.00 sec)
#
# 		SELECT * FROM t2;
# 		Empty set (0.00 se)
#
# However, if the outer SELECT references any tables, the optimizer executes the
# statement in the subquery as well, with the result that t2 is modified:
#
# 		EXPLAIN SELECT * FROM t1 AS a1, (SELECT f1(5)) AS a2\G
# 		**************************** 1. row *****************************
# 						id: 1
# 			select_type: PRIMARY
# 					table: <derived2>
# 			partitions : NULL
# 					type : system
# 		possible_keys : NULL
# 					  key: NULL
# 				key_len : NULL
# 					  ref: NULL
# 					 rows: 1
# 				filtered: 100.00
# 					Extra: NULL
# 		*************************** 2. row *******************************
# 						id: 1
# 			select_type: PRIMARY
# 					table: a1
# 			partitions : NULL
# 					type : ALL
# 		possible_keys : NULL
# 					key  : NULL
# 				key_len : NULL
# 					ref  : NULL
# 					rows : 1
# 			filtered   : 100.00
# 					Extra: NULL
# 		************************* 3. row *********************************
# 						id: 2
# 			select_type: DERIVED
# 					table: NULL
# 			partitions : NULL
# 					type : NULL
# 		possible_keys : NULL
# 					key  : NULL
# 				key_len : NULL
# 					ref  : NULL
# 					rows : NULL
# 				filtered: NULL
# 					Extra: No tables used
# 		3 rows in set (0.00 sec)
#
# 		SELECT * FROM t2;
# 		+--------+
# 		| c1 	   |
# 		+--------+
# 		| 5 	   |
# 		+--------+
# 		1 row in set (0.00 sec)
#
# This also means that an EXPLAIN_SELECT statement such as the one shown
# here may take a long time to execute because the BENCHMARK() function
# is executed once for each row in t1:
#
# 		EXPLAIN SELECT * FROM t1 AS a1, (SELECT BENCHMARK(1000000, MD5(NOW())));
#
# 13.2.11.9 SUBQUERY ERRORS
#
# There are some errors that apply only to subqueries. This section describes them.
#
# 		) Unsupported subquery syntax:
#
	# 			ERROR 1235 (ER_NOT_SUPPORTED_YET)
	# 			SQLSTATE = 42000
	# 			Message = "This version of MySQL doesn't yet support
	# 			'LIMIT & IN/ALL/ANY/SOME subquery'"
	#
# 			This means that MySQL does not support statements of the following form:
#
# 				SELECT * FROM t1 WHERE s1 IN (SELECT s2 FROM t2 ORDER BY s1 LIMIT 1)
#
# 		) Incorrect number of columns from subquery:
#
# 				ERROR 1241 (ER_OPERAND_COL)
# 				SQLSTATE = 21000
# 				Message = "Operand should contain 1 column(s)"
#
# 			This error occurs in cases like this:
#
# 				SELECT (SELECT column1, column2 FROM t2) FROM t1;
#
# 			You may use a subquery that returns multiple columns, if the purpose is row
# 			comparison.
#
# 			In other contexts, the subquery must be a scalar operand.
#
# 			See SECTION 13.2.11.5, "ROW SUBQUERIES"
#
# 		) Incorrect number of rows from subquery:
#
# 				ERROR 1242 (ER_SUBSELECT_NO_1_ROW)
# 				SQLSTATE = 21000
# 				Message = "Subquery returns more than 1 row"
#
# 		 	This error occurs for statements where the subquery must return at most one row
# 			but returns multiple rows.
#
# 			Consider the following example:
#
# 				SELECT * FROM t1 WHERE column1 = (SELECT column1 FROM t2);
#
# 			If SELECT column1 FROM t2 returns just one row,, the previous query will work.
#
# 			If the subquery returns more thhan one row, error 1242 will occur.
#
# 			In that case, the query should be rewritten as:
#
# 				SELECT * FROM t1 WHERE column1 = ANY (SELECT column1 FROM t2);
#
# 		) Incorrectly used table in subquery:
#
# 				Error 1093 (ER_UPDATE_TABLE_USED)
# 				SQLSTATE = HY000
# 				Message = "You can't specify target table 'x'
# 				for update in FROM clause"
#
# 			This error occurs in cases such as the following, which attempts to modify a table
# 			and select from the same table in the subquery:
#
# 				UPDATE t1 SET column2 = (SELECT MAX(column1) FROM t1);
#
# 			You can use a subquery for assignment within an UPDATE statement because subqueries
# 			are legal in UPDATE and DELETE statements as well as in SELECT statements.
#
# 			However, you cannot use the same table (in this case, table t1) for both the subquery
# 			FROM clause and the update target.
#
# For transactional storage engines, the failure of a subquery causes the entire statement to fail.
#
# For nontransactional storage engines, data modifications made before the error was
# encountered are preserved.
#
# 13.2.11.10 OPTIMIZING SUBQUERIES
#
# Development is ongoing, so no optimization tip is reliable for the long term.
#
# The following list provides some interesting tricks that you might want to paly
# with.
#
# See also SECTION 8.2.2, "OPTIMIZING SUBQUERIES, DERIVED TABLES, VIEW REFERENCES, AND COMMON TABLE EXPRESSIONS"
#
# 		) Use subquery clauses that affect the number or order of the rows in the subquery.
#
# 			For example:
#
# 				SELECT * FROM t1 WHERE t1.column1 IN
# 					(SELECT column1 FROM t2 ORDER BY column1);
#
# 				SELECT * FROM t1 WHERE t1.column1 IN
# 					(SELECT DISTINCT column1 FROM t2);
#
# 				SELECT * FROM t1 WHERE EXISTS 
# 					(SELECT * FROM t2 LIMIT 1);
#
# 		) Replace a join with a subquery. For example, try this:
#
# 				SELECT DISTINCT column1 FROM t1 WHERE t1.column1 IN (
# 					SELECT column1 FROM t2);
#
# 			Instead of this:
#
# 				SELECT DISTINCT t1.column1 FROM t1, t2
# 					WHERE t1.column1 = t2.column1;
#
# 		) Some subqueries can be transformed to joins for compatibility with older versions
# 			of MySQL that do not support subqueries.
#
# 			However, in some cases, converting a subquery to a join may improve performance.
#
# 			See SECTION 13.2.11.11, "REWRITING SUBQUERIES AS JOINS"
#
# 		) Move clauses from outside to inside the subquery. For example, use  this query:
#
# 				SELECT * FROM t1
# 					WHERE s1 IN (SELECT s1 FROM t1 UNION ALL SELECT s1 FROM t2);
#
# 			Instead of this query:
#
# 				SELECT * FROM t1
# 					WHERE s1 IN (SELECT s1 FROM t1) OR s1 IN (SELECT s1 FROM t2);
#
# 			For another example, use this query:
#
# 				SELECT (SELECT column1 + 5 FROM t1) FROM t2;
#
# 			Instead of this query:
#
# 				SELECT (SELECT column1 FROM t1) + 5 FROM t2;
#
# 		) Use a row subquery instead of a correlated subquery. For example, use this query:
#
# 				SELECT * FROM t1
# 					WHERE (column1,column2) IN (SELECT column1,column2 FROM t2);
#
# 			Instead of this query:
#
# 				SELECT * FROM t1
# 					WHERE EXISTS (SELECT * FROM t2 WHERE t2.column1=t1.column1
# 									  AND t2.column2=t1.column2);
#
# 		) Use NOT (a = ANY (---)) rather than a <> ALL (---)
#
# 		) Use x = ANY (table containing (1,2)) rather than x=1 OR x=2
#
# 		) Use = ANY rather than exists
#
# 		) For uncorrelated subqueries that always return one row, IN is always slower than =
#
# 			For example, use this query:
#
# 				SELECT * FROM t1
# 					WHERE t1.col_name = (SELECT a FROM t2 WHERE b = some_const);
#
# 			Instead of this query:
#
# 				SELECT * FROM t1
# 					WHERE t1.col_name IN (SELECT a FROM t2 WHERE b = some_const);
#
# These tricks might cause programs to go faster or slower.
#
# Using MySQL facilities like the BENCHMARK() function, you can get an idea
# about what helps in your own situation.
#
# See SECTION 12.15, "INFORMATION FUNCTIONS"
#
# Some optimizations that MySQL itself makes are:
#
# 		) MySQL executes uncorrelated subqueries only once.
#
# 			Use EXPLAIN to make sure that a given subquery really is uncorrelated.
#
# 		) MySQL rewrites IN, ALL, ANY and SOME subqueries in an attempt to take advantage
# 			of the possibility that the select-list columns in the subquery are indexed.
#
# 		) MySQL replaces subqueries of the following form with an index-lookup function,
# 			which EXPLAIN describes as a special join type (unique_subquery or index_subquery):
#
# 			--- IN (SELECT indexed_column FROM single_table ---)
#
# 		) MySQL enhances expressions of the following form with an expression involving MIN() or MAX(),
# 			unless NULL values or empty sets are involved:
#
# 				value {ALL|ANY|SOME} {> | < | >= | <=} (uncorrelated subquery)
#
# 			For example, this WHERE clause:
#
# 				WHERE 5 > ALL (SELECT x FROM t)
#
# 			might be treated by the optimizer like this:
#
# 				WHERE 5 > (SELECT MAX(x) FROM t)
#
# See also MYSQL INTERALS: HOW MYSQL TRANSFORMS SUBQUERIES
#
# 13.2.11.11 REWRITING SUBQUERIES AS JOINS
#
# Sometimes there are other ways to test membership in a set of values than by using a subquery.
#
# Also, on some ocassions - it is not only possible to rewrite a query without a subquery,
# but it can be more efficient to make use of some of these techniques rather than to use
# subqueries.
#
# One of these is the IN() construct:
#
# For example, this query:
#
# 			SELECT * FROM t1 WHERE id IN (SELECT id FROM t2);
#
# Can be rewritten as:
#
# 			SELECT DISTINCT t1.* FROM t1, t2 WHERE t1.id=t2.id;
#
# The queries:
#
# 		SELECT * FROM t1 WHERE id NOT IN (SELECT id FROM t2);
# 		SELECT * FROM t1 WHERE NOT EXISTS (SELECT id FROM t2 WHERE t1.id=t2.id);
#
# can be rewritten as:
#
# 		SELECT table1.*
# 			FROM table1 LEFT JOIN table2 ON table1.id=table2.id
# 			WHERE table2.id IS NULL;
#
# A LEFT [OUTER] JOIN can be faster than an equivalent subquery because the server might
# be able to optimizer it better - a fact that is not specific to MySQL Server alone.
#
# Prior to SQL-92, outer joins did not exist, so subqueries were the only way to do
# certain things.
#
# Today, MySQL Server and many other modern database systems offer a wide range
# of outer join types.
#
# MySQL Server supports multiple-table DELETE statements that can be used to efficiently
# delete rows based on information from one table or even from many tables at the
# same time.
#
# Multiple-table UPDATE statements are also supported.
#
# See SECTION 13.2.2, "DELETE SYNTAX" and SECTION 13.2.12, "UPDATE SYNTAX"
#
# 13.2.12 UPDATE SYNTAX
#
# UPDATE is a DML statement that modifies rows in a table.
#
# An UPDATE statement can start with a WITH clause to define common table
# expressions accessible within the UPDATE.
#
# See SECTION 13.2.13, "WITH SYNTAX (COMMON TABLE EXPRESSIONS)"
#
# Single-table syntax:
#
# 		UPDATE [LOW_PRIORITY] [IGNORE] table_reference
# 			SET assignment_list
# 			[WHERE where_condition]
# 			[ORDER BY ---]
# 			[LIMIT row_count]
#
# 		value:
# 			{expr | DEFAULT}
#
# 		assignment:
# 			col_name = value
#
# 		assignment_list:
# 			assignment [, assignment] ---
#
# Multiple-table syntax:
#
# 		UPDATE [LOW_PRIORITY] [IGNORE] table_references
# 			SET assignment_list
# 			[WHERE where_condition]
#
# For the single-table syntax, the UPDATE statement updates columns of existing
# rows in the named table with new values.
#
# The SET clause indicates which columns to modify and the values they should be given.
#
# Each value can be given as an expression, or the keyword DEFAULT to set a column
# explicitly to its default value.
#
# The WHERE clause, if given, specifies the conditions that identify which rows to update.
#
# With no WHERE clause, all rows are updated.
#
# If the ORDER BY clause is specified, the rows are updated in the order that is specified.
# The LIMIT clause places a limit on the number of rows that can be updated.
#
# For the multiple-table syntax, UPDATE updates rows in each table named in table_references
# that satisfy the conditions.
#
# Each matching row is updated once, even if it matches the conditions multiple times.
#
# For multiple-table syntax, ORDER BY and LIMIT cannot be used.
#
# For partitioned tables, both the single-single and multiple-table forms of this statement
# support the use of a PARTITION option as part of a table reference.
#
# This option takes a list of one or more partitions or subpartitions (or both)
#
# Only the partitions (or subpartitions) listed are checked for matches, and a row that
# is not in any of these partitions or subpartitions is not updated, whether it satisfies
# the where_condition or not.
#
# NOTE:
#
# 		Unlike the case when using PARTITION with an INSERT or REPLACE statement, an otherwise
# 		valid UPDATE --- PARTITION statement is considered successful even if no rows in the
# 		listed partitions (or subpartitions) match the where_condition
#
# For more information and examples, see SECTION 23.5, "PARTITION SELECTION"
#
# where_condition is an expression that evaluates to true for each row to be updated:
# For expression syntax, see SECTION 9.5, "EXPRESSIONS"
#
# table_references and where_condition are specified as described in SECTION 13.2.10, "SELECT SYNTAX"
#
# You need the UPDATE privilege only for columns referenced in an UPDATE that are actually updated.
#
# You need only the SELECT privilege for any columns that are read but not modified.
#
# The UPDATE statement supports the following modifiers:
#
# 		) With the LOW_PRIORITY modifier, execution of the UPDATE is delayed until no other clients
# 			are reading from the table.
#
# 			This affects only storage engines that use only table-level locking (such as MyISAM, MEMORY, and MERGE)
#
# 		) With the IGNORE modifier, the update statement does not abort even if errors occur during the update.
#
# 			Rows for which duplicate-key conflicts occur on a unique key value are not updated.
#
# 			Rows updated to values that would cause data conversion errors are updated to the closest
# 			valid values instead.
#
# 			For more information, see COMPARISON OF THE IGNORE KEYWORD AND STRICT SQL MODE
#
# UPDATE_IGNORE statements, including those having an ORDER BY clause, are flagged as unsafe
# for statement-based replication.
#
# (This is because the order in which the rows are updated determines which rows are ignored)
#
# Such statements produce a warning in the error log when using statement-based mode and are 
# written to the binary log using the row-based format when using MIXED mode.
#
# (Bug #11758262, Bug #50439)
#
# See SECTION 17.2.1.3, "DETERMINATION OF SAFE AND UNSAFE STATEMENTS IN BINARY LOGGING"
# for more information.
#
# If  you access a column from the table to be updated in an expression, UPDATE uses the current
# value of the column.
#
# For example, the following statement sets col1 to one more than its current value:
#
# 		UPDATE t1 SET col1 = col1 + 1;
#
# The second assignment in the following statement sets col2 to the current (updated)
# col1 value, not the original col1 value.
#
# The result is that col1 and col2 have the same value.
#
# This behavior differs from standard SQL.
#
# 		UPDATE t1 SET col1 = col1 + 1, col2 = col1;
#
# Single-table UPDATE assignments are generally evaluated from left to right.
#
# For multiple-table updates, there is no guarantee that assignments are carried
# out in any particular order.
#
# If you set a column to the value it currently has, MySQL notices this and does
# not update it.
#
# If you update a column that has been declared NOT NULL by setting to NULL, an error
# occurs if strict SQL mode is enabled; otherwise, the column is set to the implicit
# default value for the column data type and the warning count is incremented.
#
# The implicit default value is 0 for numeric types, the empty string('') for string
# types, and the "zero" value for date and time types.
#
# See SECTION 11.7, "DATA TYPE DEFAULT VALUES"
#
# If a generated column is updated explicitly, the only permitted value is DEFAULT.
#
# For information about generated columns, see SECTION 13.1.20.8, "CREATE TABLE AND GENERATED COLUMNS"
#
# UPDATE returns the number of rows that were actually changed.
#
# The mysql_info() C API function returns the number of rows that were matched and updated
# and the number of warnings that occurred during the UPDATE.
#
# You can use LIMIT row_count to restrict the scope of the UPDATE 
#
# A LIMIT clause is a rows-matched restriction. The statement stops as soon as it has found
# row_count rows that satisfy the WHERE clause, whether or not they actually were changed.
#
# If an UPDATE statement includes an ORDER BY clause, the rows are updated in the order specified
# by the clause.
#
# This can be useful in certain situations that might otherwise result in an error.
#
# Suppose that a table t contains a column id that has a unique index.
#
# The following statement could fail with a duplicate-key error, depending
# on the order in which rows are updated:
#
# 		UPDATE t SET id = id + 1;
#
# For example, if the table contains 1 and 2 in the id column and 1 is updated
# to 2 before 2 is updated to 3, an error occurs.
#
# To avoid this problem, add an ORDER BY clause to cause the rows with larger
# id values to be updated before those with smaller values:
#
# 		UPDATE t SET id = id + 1 ORDER BY id DESC;
#
# You can also perform UPDATE operations covering multiple tables.
#
# However, you cannot use ORDER BY or LIMIT with a multiple-table UPDATE.
#
# The table_references clause lists the tables involved in teh join.
#
# Its syntax is described in SECTION 13.2.10.2, "JOIN SYNTAX"
#
# Here is an example:
#
# 		UPDATE items,month SET items.price=month.price
# 		WHERE items.id=month.id;
#
# The preceding example shows an inner join that uses the comma operator, but multiple-table
# UPDATE statements can use any type of join permitted in SELECT statements, such as LEFT JOIN.
#
# If you use a multiple-table UPDATE statement involving InnoDB tables for which there are
# foreign key constraints, the MySQL optimizer might process tables in an order that
# differs from that of their parent/child relationship.
#
# In this case, the statement fails and rolls back.
#
# Instead, update a single table and rely on the ON UPDATE capabilities that
# InnoDB provides to cause the other tables to be modified accordingly.
#
# See SECTION 15.6.1.5, "INNODB AND FOREIGN KEY CONSTRAINTS"
#
# You cannot update a table and select from the same table in a subquery.
#
# An UPDATE on a partitioned table using a storage engine such as MyISAM that employs
# table-level locks locks only those partitions containing rows that match the
# UPDATE statement WHERE clause, as long as none of the table partitioning columns
# are updated.
#
# (For storage engines such as InnoDB that employ row-level locking, no locking of
# partitions takes place)
#
# For more information, see PARTITIONING AND LOCKING
#
# 13.2.13 WITH SYNTAX (COMMON TABLE EXPRESSIONS)
#
# A common table expression (CTE) is a named temporary result set that exists
# within the scope of a single statement and that can be referred to later
# within that statement, possibly multiple times.
#
# The following discussion describes how to write statements that use CTEs.
#
# 		) COMMON TABLE EXPRESISON SYNTAX
#
# 		) RECURSIVE COMMON TABLE EXPRESSIONS
#
# 		) LIMITING COMMON TABLE EXPRESSION RECURSION
#
# 		) RECURSIVE COMMON TABLE EXPRESSION EXAMPLES
#
# 		) COMMON TABLE EXPRESSIONS COMPARED TO SIMILAR CONSTRUCTS
#
# For informaiton about CTE optimization, see SECTION 8.2.2.4, "OPTIMIZING
# DERIVED TABLES, VIEW REFERENCES, AND COMMON TABLE EXPRESSIONS WITH MERGING OR MATERIALIZATION"
#
# ADDITIONAL RESOURCES
#
# These articles contain additional information about using CTEs in MySQL, including many examples:
#
# 		<LINKS, RETURN TO AFTER COMPLETED SECTION>
#
# COMMON TABLE EXPRESSION SYNTAX
#
# To specify common table expressions, use a WITH clause that has one or more comma-separated
# subclauses.
#
# Each subclause provides a subquery that produces a result set and associates a name with the
# subquery.
#
# The following example defines CTEs named cte1 and cte2 in the WITH clause, and refers to them
# in the top-level SELECT that follows the WITH clause:
#
# 		WITH
# 			cte1 AS (SELECT a, b FROM table1),
# 			cte2 AS (SELECT c, d FROM table2)
# 		SELECT b, d FROM cte1 JOIN cte2
# 		WHERE cte1.a = cte2.c;
#
# In the statement containing the WITH clause, each CTE name can be referenced
# to access the corresponding CTE result set.
#
# A CTE name can be referenced in other CTEs, enabling CTEs to be defined based
# on other CTEs.
#
# A CTE can refer to itself to define a recursive CTE
#
# Common applications of recursive CTEs include series generation and traversal
# of hierarchial or tree-structured data.
#
# Common table expressions are an optional part of the syntax for DML statements.
#
# They are defined using a WITH clause:
#
# 		with_clause:
# 			WITH [RECURSIVE]
# 				cte_name [(col_name [, col_name] ---)] AS (subquery)
# 				[, cte_name [(col_name [, col_name] ---)] AS (subquery)] ---
#
# cte_name names a single common table expression and can be used as a table
# reference in the statement containing the WITH clause.
#
# The subquery part of AS (subquery) is called the "subquery of the CTE" and is what
# produces the CTE result set.
#
# The parentheses following AS are required.
#
# A common table expression is recursive if its subquery refers to its own name.
#
# The RECURSIVE keyword must be included if any CTE in the WITH clause is recursive.
#
# For more information, see RECURSIVE COMMON TABLE EXPRESSIONS
#
# Determination of column names for a given CTE occurs as follows:
#
# 		) If a parenthesized list of names follows the CTE name, those names are the column names:
#
# 			WITH cte (col1, col2) AS
# 			(
# 				SELECT 1, 2
# 				UNION ALL
# 				SELECT 3, 4
# 			)
# 			SELECT col1, col2 FROM cte;
#
# 			The number of names in the list must be the same as the number of columns in the result set.
#
# 		) Otherwise, the column names come from the select list of the first SELECT within the AS (subquery) part:
#
# 			WITH cte AS
# 			(
# 				SELECT 1 AS col1, 2 AS col2
# 				UNION ALL
# 				SELECT 3, 4
# 			)
# 			SELECT col1, col2 FROM cte;
#
# A WITH clause is permitted in these contexts:
#
# 		) At the beginning of SELECT, UPDATE and DELETE statements.
#
# 			WITH --- SELECT ---
# 			WITH --- UPDATE ---
# 			WITH --- DELETE ---
#
# 		) At the beginning of subqueries (including derived table subqueries):
#
# 			SELECT --- WHERE id IN (WITH --- SELECT ---) ---
# 			SELECT * FROM (WITH --- SELECT ---) AS dt ---
#
# 		) Immediately preceding SELECT for statements that include a SELECT statement:
#
# 			INSERT --- WITH --- SELECT ---
# 			REPLACE --- WITH --- SELECT ---
# 		
# 			CREATE TABLE --- WITH --- SELECT ---
# 			CREATE VIEW --- WITH --- SELECT ---
#
# 			DECLARE CURSOR --- WITH --- SELECT ---
# 			EXPLAIN --- WITH --- SELECT ---
#
# Only one WITH clause is permitted at the same level.
#
# WITH followed by WITH at the same level is not permitted, so this is illegal:
#
# 		WITH cte1 AS (---) WITH cte2 AS (---) SELECT ---
#
# To make the statement legal, use a single WITH clause that separates
# the subclauses by a comma:
#
# 		WITH cte1 AS (---), cte2 AS (---) SELECT ---
#
# However, a statement can contain multiple WITH clauses if they occur at different
# levels:
#
# 		WITH cte1 AS (SELECT 1)
# 		SELECT * FROM (WITH cte2 AS (SELECT 2) SELECT * FROM cte2 JOIN cte1) AS dt;
#
# A WITH clause can define one or more common table expressions, but each CTE name
# must be unique to the clause. This is illegal:
#
# 		WITH cte1 AS (---), cte1 AS (---) SELECT ---
#
# To make the statement legal, define the CTEs with unique names:
#
# 		WITH cte1 AS (---), cte2 AS (---) SELECT ---
#
# A CTE can refer to itself or to other CTEs:
#
# 		) A self-referencing CTE is recursive
#
# 		) A CTE can refer to CTEs defined earlier in the same WITH clause, but not those defined later.
#
# 		  This constraint rules out mutually-recursive CTEs, where cte1 references cte2 and cte2
# 			references cte1.
#
# 			One of those references must be to a CTE defined later, which is not permitted.
#
# 		) A CTE in a given query block can refer to CTEs defined in query blocks at a more outer level,
# 			but not CTEs defined in query blocks at a more inner level.
#
# For resolving references to objects with the same names, derived tables hide CTEs; and CTEs
# hide base tables, TEMPORARY tables, and views.
#
# Name resolution occurs by seaching for objects in the same query block, then proceeding
# to outer blocks in turn while no object with the name is found.
#
# Like derived tables, a CTE cannot contain outer references prior to MySQL 8.0.14
#
# This is a MySQL restriction that is lifted in MySQL 8.0.14, not a restriction of the
# SQL standard.
#
# For additional syntax considerations specific to recursive CTEs, see RECURSIVE COMMON TABLE EXPRESSIONS
#
# RECURSIVE COMMON TABLE EXPRESSIONS
#
# A recursive common table expression is one having a subquery that refers to its own name.
#
# For example:
#
# 		WITH RECURSIVE cte (n) AS
# 		(
# 			SELECT 1
# 			UNION ALL
# 			SELECT n + 1 FROM cte WHERE n < 5
# 		)
# 		SELECT * FROM cte;
#
# When executed, the statement produces this result, a single column containing a simple
# linear sequence:
#
# 		+--------+
# 		| n 		|
# 		+--------+
# 		| 1 	   |
# 		| 2 		|
# 		| 3 	   |
# 		| 4 	   |
# 		| 5 		|
# 		+--------+
#
# A recursive CTE has this structure:
#
# 		) The WITH clause must begin with WITH RECURSIVE if any CTE in the WITH clause refers to itself.
#
# 			(If no CTE refers to itself, RECURSIVE is permitted but not required)
#
# 			If you forget RECURSIVE for a recursive CTE, this error is a likely result:
#
# 				ERROR 1146 (42S02): Table 'cte_name' doesn't exist
#
# 		) The recursive CTE subquery has two parts, separated by UNION_[ALL] or UNION_DISTINCT:
#
# 			SELECT --- 			--- return initial row set
# 			UNION ALL
# 			SELECT --- 			--- return additional row sets
#
# 			The first SELECT produces the initial row or rows for the CTE and does not refer to the
# 			CTE name.
#
# 			The second SELECT produces additional rows and recurses by referring to the CTE name
# 			in its FROM clause.
#
# 			Recursion ends when this part produces no new rows.
#
# 			Thus, a recursive CTE consists of a nonrecursive SELECT part followed by a recursive SELECT part.
#
# 			Each SELECT part can itself be a union of multiple SELECT statements.
#
# 		) The types of the CTE result columns are inferred from the column types of the nonrecursive
# 			SELECT part only, and the columns are all nullable.
#
# 			For type determination, the recursive SELECT part is ignored.
#
# 		) If the nonrecursive and recursive parts are separated by UNION_DISTINCT, duplicate rows
# 			are eliminated.
#
# 			This is useful for queries that perform transitive closures, to avoid infinite loops.
#
# 		) Each iteration of the recursive part operates only on the rows produced by the previous iteration.
#
# 			If the recursive part has multiple query blocks, iterations of each query block are
# 			scheduled in unspecified order, and each query block operates on rows that have been
# 			produced either by its previous iteration or by other query blocks since that previous
# 			iteration's end.
#
# The recursive CTE subquery shown earlier has this nonrecursive part that retrieves a single row
# to produce the initial row set:
#
# 		SELECT 1
#
# The CTE subquery also has this recursive part:
#
# 		SELECT n + 1 FROM cte WHERE n < 5
#
# At each iteration, that SELECT produces a row within a new value one greater than the
# value of n from the previous row set.
#
# The first iteration operates on the initial row set (1) and produces 1+1=2; 
#
# The second iteration operates on the first iteration's row set (2) and produces
# 2+1=3; and so forth.
#
# This continues until recursion ends, which occurs when n is no longer less than 5
#
# If the recursive part of a CTE produces wider values for a column than the nonrecursive
# part, it may be necessary to widen the column in the nonrecursive part to avoid
# data truncation.
#
# Consider this statement:
#
# 		WITH RECURSIVE cte AS
# 		(
# 			SELECT 1 AS n, 'abc' AS str
# 			UNION ALL
# 			SELECT n + 1, CONCAT(str, str) FROM cte WHERE n < 3
# 		)
# 		SELECT * FROM cte;
#
# In nonstrict SQL mode, the statement produces this output:
#
# 		+--------+----------+
# 		| n 		| str 	  |
# 		+--------+----------+
# 		| 1 		| abc 	  |
# 		| 2 		| abc 	  |
# 		| 3 		| abc 	  |
# 		+--------+----------+
#
# The str column values are all 'abc' because the nonrecursive SELECT determines
# the column widths.
#
# Consequently, the wider str values produced by the recursive SELECT are truncated.
#
# In strict SQL mode, the statement produces an error:
#
# 		ERROR 1406 (22001): Data too long for column 'str' at row 1
#
# To address this issue, so that the statement does not produce truncation or errors,
# use CAST() in the nonrecursive SELECT to make the str column wider:
#
# 		WITH RECURSIVE cte AS
# 		(
# 			SELECT 1 AS n, CAST('abc' AS CHAR(20)) AS str
# 			UNION ALL
# 			SELECT n + 1, CONCAT(str, str) FROM cte WHERE n < 3
# 		)
# 		SELECT * FROM cte;
#
# Now the statement produces this result, without truncation:
#
# 		+-----+-----------------+
# 		| n   | str 				|
# 		+-----+-----------------+
# 		| 1   | abc 				|
# 		| 2   | abcabc 			|
# 		| 3   | abcabcabcabc 	|
# 		+-----+-----------------+
#
# Columns are accessed by name, not position, which means that columns in the recursive
# part can access columns in the nonrecursive part that have a different position, as
# this CTE illustrates:
#
# 		WITH RECURSIVE cte AS
# 		(
# 			SELECT 1 AS n, 1 AS p, -1 AS q
# 			UNION ALL
# 			SELECT n + 1, q * 2, p * 2 FROM cte WHERE n < 5
# 		)
# 		SELECT * FROM cte;
#
# Because p in one row is derived from q in the previous row, and vice versa,
# the positive and negative values values swap positions in each successive
# row of the output:
#
# 		+--------+-----------+------------+
# 		| n 	   | p 		   | q 			 |
# 		+--------+-----------+------------+
# 		| 1 		| 1 			| -1 			 |
# 		| 2 		| -2 			| 2 			 |
# 		| 3 		| 4 			| -4 			 |
# 		| 4 		| -8 			| 8 			 |
# 		| 5 		| 16 			| -16 		 |
# 		+--------+-----------+------------+
#
# Some syntax constraints apply within recursive CTE subqueries:
#
# 		) The recursive SELECT part must not contain these constructs:
#
# 			) Aggregate functions such as SUM()
#
# 			) Window functions
#
# 			) GROUP BY
#
# 			) ORDER BY
#
# 			) LIMIT
#
# 			) DISTINCT
#
# 			This constraint does not apply to nonrecursive SELECT part of a recursive CTE.
#
# 			The prohibition on DISTINCT applies only to UNION members; UNION DISTINCT is 
# 			permitted.
#
# 		) The recursive SELECT part must reference the CTE only once and only in its FROM clause,
# 			not in any subquery.
#
# 			It can reference tables other than the CTE and join them with the CTE:
#
# 			If used in a join like this, the CTE must not be on the right side of a LEFT JOIN
#
# These constraints come from the SQL standard, other than the MySQL-specific exclusions
# of ORDER BY, LIMIT, and DISTINCT.
#
# For recursive CTEs, EXPLAIN output rows for recursive SELECT parts display Recursive
# in the Extra column.
#
# Cost estimates displayed by EXPLAIN represents cost per iteration, which might differ
# considerably from total cost.
#
# The optimizer cannot predict the number of iterations because it cannot predict
# when the WHERE clause will become false.
#
# CTE actual cost may also be affected by result set size.
#
# A CTE that produces many rows may require an internal temporary table large enough
# to be converted from in-memory to on-disk format and may suffer a performance
# penalty.
#
# If so, increasing the permitted in-memory temporary table-size may improve performance;
# see SECTION 8.4.4, "INTERNAL TEMPORARY TABLE USE IN MYSQL"
#
# LIMITING COMMON TABLE EXPRESSION RECURSION
#
# It is important for recursive CTEs that the recursive SELECT part include a condition
# to terminate recursion.
#
# As a development technique to guard against a runaway recursive CTE; you can
# force termination by placing a limit on execution time:
#
# 		) The cte_max_recursion_depth system variable enforces a limit on the number
# 			of recursion levels for CTEs.
#
# 			The server terminates execution of any CTE that recurses more levels
# 			than the value of this variable.
#
# 		) The max_execution_time system variable enforces an execution timeout for SELECT
# 			statements executed within the current session.
#
# 		) The MAX_EXECUTION_TIME optimizer hint enforces a per-query execution timeout for the
# 			SELECT statement in which it appears.
#
# Suppose that a recursive CTE is mistakenly written with no recursion execution termination condition:
#
# 		WITH RECURSIVE cte (n) AS
# 		(
# 			SELECT 1
# 			UNION ALL
# 			SELECT n + 1 FROM cte
# 		)
# 		SELECT * FROM cte;
#
# By default, cte_max_recursion_depth has a value of 1000, causing the CTE to terminate when
# it recurses past 1000 levels.
#
# Applications can change the session value to adjust for their requirements:
#
# 		SET SESSION cte_max_recursion_depth = 10; 		-- Permit only shallow recursion
# 		SET SESSION cte_max_recursion_depth = 1000000; 	-- permit deeper recursion
#
# You can also set the global cte_max_recursion_depth value to affect all sessions
# that begin subsequently.
#
# For queries that execute and thus recurse slowly or in contexts for which there is
# reason to set the cte_max_recursion_depth value very high, another way to guard
# against deep recursion is to set a per-session timeout.
#
# To do so, execute a statement like this prior to executing the CTE statement:
#
# 		SET max_execution_time = 1000; -- impose one second timeout
#
# Alternatively, include an optimizer hint within the CTE statement itself:
#
# 		WITH RECURSIVE cte (n) AS
# 		(
# 			SELECT 1
# 			UNION ALL
# 			SELECT n + 1 FROM cte
# 		)
# 		SELECT /*+ MAX_EXECUTION_TIME(1000) */ * FROM cte;
#
# If a recursive query without an execution time limit enters an infinite loop, you can
# terminate it from another session using KILL_QUERY
#
# Within the session itself, the client program used to run the query might provide
# a way to kill the query.
#
# For example, in mysql, doing CTRL+C interuppts the current statement
#
# RECURSIVE COMMON TABLE EXPRESSION EXAMPLES
#
# As mentioned previously, recursive common table expressions (CTEs)
# are frequently used for series generation and traversing hierarchial
# or tree-structured data.
#
# This section shows some simple examples of these techniques.
#
# 		) FIBONACCI SERIES GENERATION
#
# 		) DATE SERIES GENERATION
#
# 		) HIERARCHIAL DATA TRAVERSAL
#
# FIBONACCI SERIES GENERATION
#
# A Fibonacci series begins with the two numbers 0 and 1 (or 1 and 1) and each number
# after that is the sum of the previous two numbers.
#
# A recursive common table expression can generate a Fibonacci series if each row
# produced by the recursive SELECT has access to the two previous numbers
# from the series.
#
# The following CTE generates a 10-number series using 0 and 1 as the first two numbers:
#
# 		WITH RECURSIVE fibonacci (n, fib_n, next_fib_n) AS
# 		(
# 			SELECT 1, 0, 1
# 			UNION ALL
# 			SELECT n + 1, next_fib_n, fib_n + next_fib_n
# 				FROM fibonacci WHERE n < 10
# 		)
# 		SELECT * FROM fibonacci;
#
# The CTE produces this result:
#
# 		+---------+------------+---------------------+
# 		| n 		 | fib_n 	  | next_fib_n 		   |
# 		+---------+------------+---------------------+
# 		| 1 		 | 0 			  | 1 						|
# 		| 2 		 | 1 			  | 1 						|
# 		| 3 		 | 1 			  | 2 						|
# 		| 4 		 | 2 			  | 3 					   |
# 		| 5 		 | 3 			  | 5 						|
# 		| 6 		 | 5 			  | 8 						|
# 		| 7 		 | 8 			  | 13 						|
# 		| 8 		 | 13 		  | 21 					   |
# 		| 9 		 | 21 		  | 34 						|
# 		| 10 		 | 34 		  | 55 						|
# 		+---------+------------+---------------------+
#
# How the CTE works:
#
# 		) n is a display column to indicate that the row contains the n-th Fibonacci number.
#
# 			For example, the 8th Fibonacci number is 13.
#
# 		) The fib_n column displays Fibonacci number n
#
# 		) The next_fib_n column displays the next Fibonaci number after number n.
#
# 			This column provides the next series value to the next row, so that row can
# 			produce the sum of the two previous series values in its fib_n column
#
# 		) Recursion ends when n reaches 10. This is an arbitrary choice, to limit output to
# 			a small set of rows.
#
# The preceding output shows the entire CTE result.
#
# To select just part of it, add an appropriate WHERE clause to the top-level SELECT
#
# For example, to select the 8th Fibonacci number, do this:
#
# 		WITH RECURSIVE fibonacci ---
# 		---
# 		SELECT fib_n FROM fibonacci WHERE n = 8;
# 		+-----------+
# 		| fib_n 		|
# 		+-----------+
# 		| 13 			|
# 		+-----------+
#
# DATE SERIES GENERATION
#
# A common table expression can generate a series of successive dates, which is useful
# for generating summaries that include a row for all dates in the series, including
# dates not represented in the summarized data.
#
# Suppose that a table of sales numbers contains these rows:
#
# 		SELECT * FROM sales ORDER BY date, price;
# 		+----------------+----------+
# 		| date 			  | price 	 |
# 		+----------------+----------+
# 		| 2017-01-03 	  | 100.00   |
# 		| 2017-01-03 	  | 200.00   |
# 		| 2017-01-06 	  | 50.00 	 |
# 		| 2017-01-08 	  | 10.00 	 |
# 		| 2017-01-08 	  | 20.00    |
# 		| 2017-01-08 	  | 150.00   |
# 		| 2017-01-10 	  | 5.00 	 |
# 		+----------------+----------+
#
# This query summarizes the sales per day:
#
# 		SELECT date, SUM(price) AS sum_price
# 		FROM sales
# 		GROUP BY date
# 		ORDER BY date;
# 		+----------------+------------------+
# 		| date 			  | sum_price 		   |
# 		+----------------+------------------+
# 		| 2017-01-03 	  | 300.00 				|
# 		| 2017-01-06 	  | 50.00 				|
# 		| 2017-01-08 	  | 180.00 				|
# 		| 2017-01-10 	  | 5.00 				|
# 		+----------------+------------------+
#
# However, that result contains "holes" for dates not represented in the range
# of dates spanned by the table.
#
# A result that represents all dates in the range can be produced using a recursive
# CTE to generate that set of dates, joined with a LEFT JOIN to the sales data.
#
# Here is the CTE to generate the date range series:
#
# 		WITH RECURSIVE dates (date) AS
# 		(
# 			SELECT MIN(date) FROM sales
# 			UNION ALL
# 			SELECT date + INTERVAL 1 DAY FROM dates
# 			WHERE date + INTERVAL 1 DAY <= (SELECT MAX(date) FROM sales)
# 		)
# 		SELECT * FROM dates;
#
# The CTE produces this result:
#
# 		+-------------------+
# 		| date 				  |
# 		+-------------------+
# 		| 2017-01-03 		  |
# 		| 2017-01-04 		  |
# 		| 2017-01-05 		  |
# 		| 2017-01-06 		  |
# 		| 2017-01-07 		  |
# 		| 2017-01-08 		  |
# 		| 2017-01-09 		  |
# 		| 2017-01-10 		  |
# 		+-------------------+
#
# How the CTE works:
#
# 		) The nonrecursive SELECT produces the lowest date in the date range spanned by the sales table.
#
# 		) Each row produced by the recursive SELECT adds one day to the date produced by the previous row.
#
# 		) Recursion ends after the dates reach the highest date in the date range spanned by the sales table.
#
# Joining the CTE with a LEFT JOIN against the sales table produces the sales summary with a row
# for each date in the range:
#
# 		WITH RECURSIVE dates (date) AS
# 		(
# 			SELECT MIN(date) FROM sales
# 			UNION ALL
# 			SELECT date + INTERVAL 1 DAY FROM dates
# 			WHERE date + INTERVAL 1 DAY <= (SELECT MAX(date) FROM sales)
# 		)
# 		SELECT dates.date, COALESCE(SUM(price), 0) AS sum_price
# 		FROM dates LEFT JOIN sales ON dates.date = sales.date
# 		GROUP BY dates.date
# 		ORDER BY dates.date;
#
# The output looks like this:
#
# 		+--------------------+--------------+
# 		| date 					| sum_price 	|
# 		+--------------------+--------------+
# 		| 2017-01-03 			| 300.00 		|
# 		| 2017-01-04 			| 0.00 			|
# 		| 2017-01-05 			| 0.00 			|
# 		| 2017-01-06 			| 50.00 			|
# 		| 2017-01-07 			| 0.00 			|
# 		| 2017-01-08 			| 180.00 		|
# 		| 2017-01-09 			| 0.00 			|
# 		| 2017-01-10 			| 5.00 			|
# 		+--------------------+--------------+
#
# Some points to note:
#
# 		) Are the queries inefficient, particularly the one with the MAX() subquery executed
# 			for each row in the recursive SELECT?
#
# 			Checking with EXPLAIN shows that the subqueries are optimized away for efficiency.
#
# 		) The use of COALESCE() avoids displaying NULL in the sum_price column on days for which
# 			no sales data occur in the sales table.
#
# HIERARCHIAL DATA TRAVERSAL
#
# Recursive common table expressions are useful for traversing data that forms a hierarchy.
#
# Consider these statements that create a small data set that shows, for each employee
# in a company, the employee name and ID number, and the ID of the employee's manager.
#
# The top-level employee (the CEO), has a manager ID of NULL (no manager)
#
# 		CREATE TABLE employees (
# 			id 			INT PRIMARY KEY NOT NULL,
# 			name 			VARCHAR(100) NOT NULL,
# 			manager_id 	INT NULL,
# 			INDEX (manager_id),
# 		FOREIGN KEY (manager_id) REFERENCES EMPLOYEES (id)
# 		);
# 		INSERT INTO employees VALUES
# 		(333, "Yasmina", NULL), #CEO, manager_id is NULL
# 		(198, "John", 333),
# 		(692, "Tarek", 333),
# 		(29, "Pedro", 198),
# 		(4610, "Sarah", 29),
# 		(72, "Pierre", 29),
# 		(123, "Adil", 692);
#
# The resulting data set looks like this:
#
# 		SELECT * FROM employees ORDER BY id;
# 		+-----+------------+-------------+
# 		| id  | name 		 | manager_id  |
# 		+-----+------------+-------------+
# 		| 29  | Pedro 		 | 198 		   |
# 		etc.
#
# To produce the organizational chart with the management chain for each
# employee (that is, the path from CEO to employee), use a recursive CTE:
#
# 		WITH RECURSIVE employee_paths (id, name, path) AS
# 		(
# 			SELECT id, name, CAST(id AS CHAR(200))
# 				FROM employees
# 				WHERE manager_id IS NULL
# 			UNION ALL
# 			SELECT e.id, e.name, CONCAT(ep.path, ',', e.id)
# 				FROM employee_paths AS ep JOIN employees AS e
# 					ON ep.id = e.manager_id
#		)
# 		SELECT * FROM employee_paths ORDER BY path;
#
# The CTE produces this output:
#
# 		+-------+-----------+-------------------+
# 		| id 	  | name 	  | path 				 |
# 		+-------+-----------+-------------------+
# 		| 333   | Yasmina   | 333 					 |
# 		| 198   | John 	  | 333, 198 			 |
# 		| 29 	  | Pedro 	  | 333, 198, 29 	    |
# 		| 4610  | Sarah 	  | 333, 198, 29, 4610|
# 		| 72 	  | Pierre 	  | 333, 198, 29, 72  |
# 		| 692   | Tarek 	  | 333, 692 			 |
# 		| 123   | Adil 	  | 333, 692, 123 	 |
# 		+-------+-----------+-------------------+
#
# How the CTE works:
#
# 		) The nonrecursive SELECT produces the row for the CEO (the row with a NULL-manager ID)
#
# 			The path column is widened to CHAR(200) to ensure that there is room for the longer path
# 			values produced by the recursive SELECT.
#
# 		) Each row produced by the recursive SELECT finds all employees who report directly to
# 			an employee produced by a previous row.
#
# 			For each such employee, the row includes the employee ID and name, and the employee
# 			management chain.
#
# 			The chain is the manager's chain, with the employee ID added ot the end.
#
# 		) Recursion ends when employees have no others who report to them
#
# To find the path for a specific employee or employees, add a WHERE clause
# to the top-level SELECT.
#
# For example, to display the results for Tarek and Sarah, modify that SELECT
# like this:
#
# 		WITH RECURSIVE ---
# 		---
# 		SELECT * FROM employees_extended
# 		WHERE id IN (692, 4610)
# 		ORDER BY path;
# 		+------+-------+-----------------------+
# 		| id   | name  | path 					   |
# 		+------+-------+-----------------------+
# 		| 4610 | Sarah | 333, 198, 29, 4610    |
# 		| 692  | Tarek | 333, 692 					|
# 		+------+-------+-----------------------+
#
# COMMON TABLE EXPRESSIONS COMPARED TO SIMILAR CONSTRUCTS
#
# Common table expressions (CTEs) are similar to derived tables in some ways:
#
# 		) Both constructs are named
#
# 		) Both constructs exist for the scope of a single statement
#
# Because of these similarities, CTEs and derived tables often can be used
# interchangably.
#
# As a trivial example, these statements are equivalent:
#
# 		WITH cte AS (SELECT 1) SELECT * FROM cte;
# 		SELECT * FROM (SELECT 1) AS dt;
#
# However, CTEs have some advantages over derived tables:
#
# 		) A derived table can be referenced only a single time within a query.
#
# 			A CTE can be referenced multiple times.
#
# 			To use multiple instances of a derived table result, you must derive
# 			the result multiple times.
#
# 		) A CTE can be self-referencing (recursive)
#
# 		) One CTE can refer to another
#
# 		) A CTE may be easier to read when its definition appears at the beginning
# 			of the statement rather than embedded within it.
#
# CTEs are similar to tables created with CREATE [TEMPORARY] TABLE but need not be defined
# or dropped explicitly.
#
# For a CTE, you need no privileges to create tables.
#
# 13.3 TRANSACTIONAL AND LOCKING STATEMENTS
#
# 13.3.1 START TRANSACTION, COMMIT, AND ROLLBACK SYNTAX
# 13.3.2 STATEMENTS THAT CANNOT BE ROLLED BACK
#
# 13.3.3 STATEMENTS THAT CAUSE AN IMPLICIT COMMIT
# 13.3.4 SAVEPOINT, ROLLBACK TO SAVEPOINT, AND RELEASE SAVEPOINT SYNTAX
#
# 13.3.5 LOCK INSTANCE FOR BACKUP AND UNLOCK INSTANCE SYNTAX
# 13.3.6 LOCK TABLES AND UNLOCK TABLES SYNTAX
#
# 13.3.7 SET TRANSACTION SYNTAX
# 13.3.8 XA TRANSACTIONS
#
# MySQL supports local transactions (within a given client session) through statements,
# such as SET_autocommit, START_TRANSACTION, COMMIT, and ROLLBACK.
#
# See SECTION 13.3.1, "START TRANSACTION, COMMIT, AND ROLLBACK SYNTAX"
#
# XA transaction support enables MySQL to participate in distributed transactions
# as well.
#
# See SECTION 13.3.8, "XA TRANSACTIONS"
#
# 13.3.1 START TRANSACTION, COMMIT AND ROLLBACK SYNTAX
#
# START TRANSACTION 
# 		[transaction_characteristic [, transaction_characteristic] ---]
#
# transaction_characteristic: {
# 		WITH CONSISTENT SNAPSHOT
# 	 | READ WRITE
# 	 | READ ONLY
# }
#
# BEGIN [WORK]
# COMMIT [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
# ROLLBACK [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
# SET autocommit = {0 | 1}
#
# These statements provide control over use of transactions:
#
# 	) START TRANSACTION or BEGIN start a new transaction
#
# 	) COMMIT commits the current transaction, making its changes permanent
#
# 	) ROLLBACK rolls back the current transaction, canceling its changes
#
# 	) SET autocommit disables or enables the default autocommit mode for the current session
#
# By default, MySQL runs with autocommit mode enabled.
#
# This means that as soon as you execute a statement that updates (modifies) table,
# MySQL stores the update on disk to make it permanent.
#
# The change cannot be rolled back.
#
# To disable autocommit mode implicitly for a single series of statements, use the
# START TRANSACTION statement:
#
# 		START TRANSACTION;
# 		SELECT @A:=SUM(salary) FROM table1 WHERE type=1;
# 		UPDATE table2 SET summary=@A WHERE type=1;
# 		COMMIT;
#
# With START TRANSACTION, autocommit remains disabled until you end the transaction
# with COMMIT or ROLLBACK.
#
# The autocommit mode then reverts to its previous state.
#
# START TRANSACTION permits several modifiers that control transaction characteristics.
#
# To specify multiple modifiers, separate them by commas.
#
# 	) The WITH CONSISTENT SNAPSHOT modifier starts a consistent read for storage engines that
# 		are capable of it.
#
# 		This applies only to InnoDB
#
# 		The effect is the same as issuing a START TRANSACTION followed by a SELECT
# 		from any InnoDB table.
#
# 		See SECTION 15.7.2.3, "CONSISTENT NONLOCKING READS"
#
# 		The WITH CONSISTENT SNAPSHOT modifier does not change the current transaction
# 		isolation level, so it provides a consistent snapshot only if the current
# 		isolation level is one that permits a consistent read.
#
# 		The only isolation level that permits a consistent read is REPEATABLE_READ
#
# 		For all other isolation levels, the WITH CONSISTENT SNAPSHOT clause is ignored.
#
# 		A warning is generated when the WITH CONSISTENT SNAPSHOT clause is ignored.
#
# 	) The READ WRITE and READ ONLY modifiers set the transaction access mode.
#
# 		They permit or prohibit changes to tables used in the transaction.
#
# 		The READ ONLY restriction prevents the transaction from modifying or locking
# 		both transactional and nontransactional tables that are visible to other
# 		transactions;
#
# 		The transaction can still modify or lock temporary tables
#
# 		MySQL enables extra optimizations for queries on InnoDB tables when
# 		the transaction is known to be read-only.
#
# 		Specifying READ ONLY ensures these optimizations are applied in cases
# 		where the read-only status cannot be determined automatically.
#
# 		See SECTION 8.5.3, "OPTIMIZING INNODB READ-ONLY TRANSACTIONS" for more information.
#
# 		If no access mode is specified, the default mode applies.
#
# 		Unless the default has been changed, it is read/write.
#
# 		it is not permitted to specify both READ WRITE and READ ONLY in the same
# 		statement.
#
# 		In read-only mode, it remains possible to change tables created with the
# 		TEMPORARY keyword using DML statements.
#
# 		Changes made with DDL statements are not permitted, just as with permanent
# 		tables.
#
# 		For additional information about transaction access mode, including ways to change
# 		the default mode, see SECTION 13.3.7, "SET TRANSACTION SYNTAX"
#
# 		If the read_only system variable is enabled, explicitly starting a transaction
# 		with START TRANSACTION READ WRITE requires the CONNECTION_ADMIN or SUPER privilege.
#
# 			IMPORTANT:
#
# 				Many APIS used for writing MySQL client applications (such as JDBC) provide
# 				their own methods for starting transactions that can (and sometimes should)
# 				be used instead of sending a START TRANSACTION statement from the client.
#
# 				See CHAPTER 28, CONNECTORS AND APIS, or the documentation for your API
# 				for more information.
#
# 		To disable autocommit mode explicitly, use the following statement:
#
# 			SET autocommit=0;
#
# 		After disabling autocommit mode by setting the autocommit variable to zero, changes to
# 		transaction-safe tables (such as those for InnoDB or NDB) are not made permanent
# 		immediately.
#
# 		You must use COMMIT to store your changes to disk or ROLLBACK to ignore the changes.
#
# 		autocommit is a session variable and must be set for each session.
#
# 		To disable autocommit mode for each new connection, see the description
# 		of the autocommit system variable at SECTION 5.1.8, "SERVER SYSTEM VARIABLES"
#
# 		BEGIN and BEGIN WORK are supported as aliases of START TRANSACTION for initiating
# 		a transaction.
#
# 		START TRANSACTION is standard SQL syntax, is the recommended way to start an
# 		ad-hoc transaction, and permits modifiers that BEGIN does not.
#
# 		The BEGIN statement differs from the use of the BEGIN keyword that starts a BEGIN_---_END
# 		compound statement.
#
# 		The latter does not begin a transaction. See SECTION 13.6.1, "BEGIN --- END COMPOUND-STATEMENT SYNTAX"
#
# 		NOTE:
#
# 			Within all stored programs (stored procedures and functions, triggers, and events), the parser
# 			treats BEGIN [WORK] as the beginning of a BEGIN_---_END block.
#
# 			Begin a transaction in this context with START_TRANSACTION instead.
#
# 		The optional WORK keyword is supported for COMMIT and ROLLBACK, as are teh CHAIN and RELEASE
# 		clauses.
#
# 		CHAIN and RELEASE can be used for additional control over transaction completion.
#
# 		The value of the completion_type system variable determines the default completion
# 		behavior.
#
# 		See SECTION 5.1.8, "SERVER SYSTEM VARIABLES"
#
# 		The AND CHAIN clause causes a new transaction to begin as soon as the current one ends,
# 		and the new transaction has the same isolation level as the just-terminated transaction.
#
# 		The new transaction also uses the same access mode (READ WRITE or READ ONLY) as the just-terminated
# 		transaction.
#
# 		The RELEASE clause causes the server to disconnect the current client session after terminating
# 		the current transaction.
#
# 		Including the NO keyword suppresses CHAIN or RELEASE completion, which can be useful if
# 		the completion_type system variable is set to cause chaining or release completion by default.
#
# 		Beginning a transaction causes any pending transaction to be committed.
#
# 		See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT", for more information.
#
# 		Beginning a transaction also causes table locks acquired with LOCK_TABLES to be released,
# 		as though you had executed UNLOCK_TABLES
#
# 		Beginning a transaction does not release a global read lock acquired with FLUSH_TABLES_WITH_READ_LOCK
#
# 		For best results, transactions should be performed using only tables managed by a single
# 		transaction-safe storage engine.
#
# 		Otherwise, the following problems can occur:
#
# 			) If you use tables from more than one transaction-safe storage engine (such as InnoDB),
# 				and the transaction isolation level is not SERIALIZABLE, it is possible that when
# 				one transaction commits, another ongoing transaction that uses the same tables will
# 				see only some of the changes made by the first transaction.
#
# 				That is, the atomicity of transactions is not guaranteed with mixed engines and
# 				inconsistencies can result.
#
# 				(If mixed-engine transactions are infrequent, you can use SET_TRANSACTION_ISOLATION_lEVEL
# 				to set the isolation level to SERIALIZABLE on a per-transaction basis as necessary.)
#
# 			) If you use tables that are not transaction-safe within a transaction, changes to those tables
# 				are stored at once, regardless of the status of autocommit mode.
#
# 			) If you issue a ROLLBACK statement after updating a nontransactional table within a transaction,
# 				an ER_WARNING_NOT_COMPLETE_ROLLBACK warning occurs.
#
# 				Changes to transaction-safe tables are rolled back, but not changes to nontransaction-safe tables.
#
# 		Each transaction is stored in the binary log in one chunk, upon COMMIT.
#
# 		Transactions that are rolled back are not logged.
#
# 		(Exception:
#
# 			Modifications to nontransactional tables cannot be rolled back.
#
# 			If a transaction that is rolled back includes modifications to nontransactional
# 			tables, the entire transaction is logged with a ROLLBACK statement at the
# 			end to ensure that modifications to the nontransactional tables are replicated)
#
# 			See SECTION 5.4.4, "THE BINARY lOG"
#
# 			You can change the isolation level or access mode for transactions with the
# 			SET_TRANSACTION statement.
#
# 			See SECTION 13.3.7, "SET TRANSACTION SYNTAX"
#
# 			Rolling back can be a slow operation that may occur implicitly without the user
# 			having explicitly asked for it (for example, when an error occurs)
#
# 			Because of this, SHOW_PROCESSLIST displays Rolling back in the State column
# 			for the session, not only for explicit rollbacks performed with the ROLLBACK
# 			statement but also for implicit rollbacks.
#
# 				NOTE:
#
# 					In MySQL 8.0, BEGIN, COMMIT and ROLLBACK are not affected by
# 					--replicate-do-db or --replicate-ignore-db rules
#
# 13.3.2 STATEMENTS TAHT CANNOT BE ROLLED BACK
#
# Some statements cannot be rolled back.
#
# In general, these include data definition language (DDL) statements, such as those
# that create or drop databases,, those that create, drop or alter tables
# or stored routines.
#
# You should design your transactions not to include such statements.
#
# If you issue a statement early in a transaction that cannot be rolled back,
# and then another statement later fails, the full effect of the transaction
# cannot be rolled back in such cases by issuing a ROLLBACK statement.
#
# 13.3.3 STATEMENTS THAT CAUSE AN IMPLICIT COMMIT
#
# The statements listed in this section (and any synonyms for them) implicitly
# end any transaction active in the current session, as if you had done a COMMIT
# before executing the statement.
#
# Most of these statements also cause an implicit commit after executing.
#
# The intent is to handle each such statement in its own special transaction.
#
# Transaction-control and locking statements are exceptions:
#
# If an implicit commit occurs before execution, another does not occur after.
#
# 		) DATA DEFINITION LANGUAGE (DDL) STATEMENTS THAT DEFINE OR MODIFY DATABASE OBJECTS.
#
# 			ALTER_EVENT
#
# 			ALTER_FUNCTION
#
# 			ALTER_PROCEDURE
#
# 			ALTER_SERVER
#
# 			ALTER_TABLE
#
# 			ALTER_VIEW
#
# 			CREATE_DATABASE 
#
# 			CREATE_EVENT
#
# 			CREATE_FUNCTION
#
# 			CREATE_INDEX
#
# 			CREATE_PROCEDURE
#
# 			CREATE_ROLE
#
# 			CREATE_SERVER
#
# 			CREATE_SPATIAL_REFERENCE_SYSTEM
#
# 			CREATE_TABLE
#
# 			CREATE_TRIGGER
#
# 			CREATE_VIEW
#
# 			DROP_DATABASE 
#
# 			DROP_EVENT
#
# 			DROP_FUNCTION
#
# 			DROP_INDEX
#
# 			DROP_PROCEDURE 
#
# 			DROP_ROLE
#
# 			DROP_SERVER
#
# 			DROP_SPATIAL_REFERENCE_SYSTEM
#
# 			DROP_TABLE
#
# 			DROP_TRIGGER
#
# 			DROP_VIEW
#
# 			INSTALL_PLUGIN
#
# 			RENAME_TABLE
#
# 			TRUNCATE_TABLE
#
# 			UNINSTALL_PLUGIN
#
# 			CREATE_TABLE and DROP_TABLE statements do not commit a transaction
# 			if the TEMPORARY keyword is used.
#
# 			(This does not apply to other operations on temporary tables such as
# 			ALTER_TABLE and CREATE_INDEX, which do cause a commit)
#
# 			However, although no implicit commit occurs, neither can the statement
# 			be rolled back, which means that the use of such statements cause transactional
# 			atomicity to be violated.
#
# 			For example, if you use CREATE_TEMPORARY_TABLE and then roll back the
# 			transaction, the table remains in existence.
#
# 			The CREATE_TABLE statement in InnoDB is processed as a single transaction.
#
# 			This means that a ROLLBACK from the user does not undo CREATE_TABLE statements
# 			the user made during that transaction.
#
# 			CREATE_TABLE_---_SELECT causes an implicit commit before and after the statement
# 			is executed when you are creating nontemporary tables.
#
# 			(No commit occurs for CREATE TEMPORARY TABLE --- SELECT)
#
# 		) STATEMENTS THAT IMPLICITLY USE OR MODIFY TABLES IN THE mysql DATABASE.
#
# 			ALTER_USER
#
# 			CREATE_USER
#
# 			DROP_USER
#
# 			GRANT
#
# 			RENAME_USER
#
# 			REVOKE
#
# 			SET_PASSWORD
#
# 		) TRANSACTION-CONTROL AND LOCKING STATEMENTS.
#
# 			BEGIN
#
# 			LOCK_TABLES 
#
# 			SET autocommit = 1 (if the value is not already 1)
#
# 			START TRANSACTION
#
# 			UNLOCK TABLES
#
# 			UNLOCK_TABLES commits a transaction only if any tables currently
# 			have been locked with LOCK_TABLES to acquire nontransactional table
# 			locks.
#
# 			A commit does not occur for UNLOCK_TABLES following FLUSH_TABLES_WITH_READ_LOCK
# 			because the latter statement does not acquire table-level locks.
#
# 			Transactions cannot be nested.
#
# 			This is a consequence of the IMPLICIT commit performed for any current transaction
# 			when you issue a START_TRANSACTION statement or one of its synonyms.
#
# 			Statements that cause an implicit commit cannot be used in an XA transaction
# 			while the transaction is in an ACTIVE state.
#
# 			The BEGIN statement differs from the use of the BEGIN keyword that starts
# 			a BEGIN_---_END compound statement.
#
# 			The latter does not cause an implicit commit.
#
# 			See SECTION 13.6.1, "BEGIN -- END COMPOUND-STATEMENT SYNTAX"
#
# 		) DATA LOADING STATEMENTS
#
# 			LOAD_DATA_INFILE
#
# 			LOAD_DATA_INFILE causes an implicit commit only for tables using the NDB storage engine.
#
# 		) ADMINISTRATIVE STATEMENTS
#
# 			ANALYZE_TABLE
#
# 			CACHE_INDEX
#
# 			CHECK_TABLE
#
# 			FLUSH
#
# 			LOAD_INDEX_INTO_CACHE
#
# 			OPTIMIZE_TABLE
#
# 			REPAIR_TABLE
#
# 			RESET (but not RESET PERSIST)
#
# 		) REPLICATION CONTROL STATEMENTS
#
# 			START SLAVE
#
# 			STOP SLAVE
#
# 			RESET SLAVE
#
# 			CHANGE MASTER TO
#
# 13.3.4 SAVEPOINT, ROLLBACK TO SAVEPOINT, AND RELEASE SAVEPOINT SYNTAX
#
# 		SAVEPOINT identifier
# 		ROLLBACK [WORK] TO [SAVEPOINT] identifier
# 		RELEASE SAVEPOINT identifier
#
# InnoDB supports the SQL statements SAVEPOINT, ROLLBACK_TO_SAVEPOINT, RELEASE_SAVEPOINT
# and the optional WORK keyword for ROLLBACK
#
# The SAVEPOINT statement sets a named transaction savepoint with a name of identifier.
#
# If the current transaction has a savepoint with the same name, the old savepoint is deleted
# and a new one is set.
#
# The ROLLBACK_TO_SAVEPOINT statement rolls back a transaction to the named savepoint
# without terminating the transaction.
#
# Modifications that the current transaction made to rows after the savepoint was set
# are undone in the rollback, but InnoDB does not release the row locks that were stored
# in memory after the savepoint.
#
# (For a new inserted row, the lock information is carried by the transaction ID stored in the
# row; the lock is not separately stored in memory.
#
# In this case, the row lock is released in the undo)
#
# Savepoints that were set at a later time than the named savepoint are deleted.
#
# If the ROLLBACK_TO_SAVEPOINT statement returns the following error, it means that
# no savepoint with the specified name exists:
#
# 		ERROR 1305 (42000): SAVEPOINT identifier does not exist
#
# The RELEASE_SAVEPOINT statement removes the named savepoint from the set of savepoints
# of the current transaction.
#
# No commit or rollback occurs.
#
# It is an error if the savepoint does not exist.
#
# All savepoints of the current transaction are deleted if you execute a COMMIT,
# or a ROLLBACK that does not name a savepoint.
#
# A new savepoint level is created when a stored function is invoked or a trigger is activated.
#
# The savepoints on previous levels become unavailable and thus do not conflict
# with savepoints on the new level.
#
# When the function or trigger terminates, any savepoints it created are released
# and the previous savepoint level is restored.
#
# 13.3.5 LOCK INSTANCE FOR BACKUP AND UNLOCK INSTANCE SYNTAX
#
# 		LOCK INSTANCE FOR BACKUP
#
# 		UNLOCK INSTANCE
#
# LOCK INSTANCE FOR BACKUP acquires an instance-level backup lock that permits DML during
# an online backup while preventing operations that could result in an inconsistent snapshot.
#
# Executing the LOCK INSTANCE FOR BACKUP statement requires the BACKUP_ADMIN privilege.
#
# The BACKUP_ADMIN privilege is automatically granted to users with the RELOAD 
# privilege when performing an in-place upgrade to MySQL 8.0 from an earlier version.
#
# Multiple sessions can hold a backup lock simultaneously.
#
# UNLOCK INSTANCE releases a backup lock held by the current session.
#
# A backup lock held by a session is also released if the session is terminated.
#
# LOCK INSTANCE FOR BACKUP prevents files from being created, renamed or removed.
#
# REPAIR_TABLE
#
# TRUNCATE TABLE
#
# OPTIMIZE TABLE
#
# and account management statements are blocked.
#
# See SECTION 13.7.1, "ACCOUNT MANAGEMENT STATEMENTS"
#
# Operations that modify InnoDB files that are not recorded in the InnoDB
# redo log are also blocked.
#
# LOCK INSTANCE FOR BACKUP permits DDL operations that only affect user-created
# temporary tables
#
# In effect, files that belong to user-created temporary tables can be created,
# renamed or removed while a backup lock is held.
#
# Creation of binary log files is also permitted.
#
# A backup lock acquired by LOCK INSTANCE FOR BACKUP is independent of transactional
# locks and locks taken by FLUSH_TABLES_tbl_name [, tbl_name] --- WITH READ LOCK,
# and the following sequences of statements are permitted:
#
# 		LOCK INSTANCE FOR BACKUP;
# 		FLUSH TABLES tbl_name [, tbl_name] --- WITH READ LOCK;
# 		UNLOCK TABLES;
# 		UNLOCK INSTANCE;
#
# 		FLUSH TABLES tbl_name [, tbl_name] --- WITH READ LOCK;
# 		LOCK INSTANCE FOR BACKUP;
# 		UNLOCK INSTANCE;
# 		UNLOCK TABLES;
#
# The lock_wait_timeout setting defines the amount of time that a LOCK INSTANCE FOR BACKUP
# statement waits to acquire a lock before giving up.
#
# 13.3.6 LOCK TABLES AND UNLOCK TABLES SYNTAX
#
# LOCK TABLES
# 		tbl_name [[AS] alias] lock_type
# 		[, tbl_name [[AS] alias] lock_type] ---
#
# lock_type: {
# 		READ [LOCAL]
# 	 | [LOW_PRIORITY] WRITE
# }
#
# UNLOCK TABLES
#
# MySQL enables client sessions to acquire table locks explicitly for the purpose
# of cooperating with other sessions for access to tables, or to prevent other
# sessions from modifying tables during periods when a session requires exclusive
# access to them.
#
# A session can acquire or release locks only for itself
#
# One session cannot acquire locks for another session or release
# locks held by another session
#
# Locks may be used to emulate transactions or to get more speed when
# updating tables.
#
# This is explained in more detail in TABLE-LOCKING RESTRICTIONS AND CONDITIONS
#
# LOCK_TABLES explicitly acquires table locks for the current client session.
#
# Table locks can be acquired for base tables or views.
#
# You must have the LOCK_TABLES privilege, and the SELECT privilege
# for each object to be locked.
#
# For view locking, LOCK_TABLES adds all base tables used in the view to the
# set of tables to be locked and locks them automatically.
#
# If you lock a table explicitly with LOCK TABLES, any tables used in triggers
# are also locked implicitly, as described in LOCK TABLES AND TRIGGERS
#
# If you lock a table explicitly with LOCK_TABLES, any tables related by a foreign
# key constraint are opened and locked implicitly.
#
# For foreign key checks, a shared read-only lock (LOCK_TABLES_READ) is taken
# on related tables.
#
# For cascading updates, a shared-nothing write lock (LOCK_TABLES_WRITE) is taken
# on related tables that are involved in the operation.
#
# UNLOCK_TABLES explicitly releases any table locks held by the current session.
#
# LOCK_TABLES implicitly releases any table locks held by the current session before
# acquiring new locks.
#
# Another use for UNLOCK_TABLES is to release the global read lock acquired with 
# the FLUSH_TABLES_WITH_READ_LOCK statement, which enables you to lock all tables
# in all databases.
#
# See SECTION 13.7.7.3, "FLUSH SYNTAX" (This is a very convenient way to get backups
# if you  have a file system such as Veritas that can take snapshots in time)
#
# A table lock protects only against inappropriate reads or writes by other sessions.
#
# A session holding a WRITE lock can perform table-level operations such as DROP_TABLE
# or TRUNCATE_TABLE
#
# For sessions holding a READ lock, DROP_TABLE and TRUNCATE_TABLE operations are not permitted.
#
# The following discussion applies only to non-TEMPORARY tables.
#
# LOCK_TABLES is permitted (but ignored) for a TEMPORARY table.
#
# The table can be accessed freely by the session within which it was created,
# regardless of what other locking may be in effect.
#
# No lock is necessary because no other session can see the table.
#
# 		) TABLE LOCK ACQUISITION
#
# 		) TABLE LOCK RELEASE
#
# 		) INTERACTION OF TABLE LOCKING AND TRANSACTIONS
#
# 		) LOCK TABLES AND TRIGGERS
#
# 		) TABLE-LOCKING RESTRICTIONS AND CONDITIONS
#
# TABLE LOCK ACQUISITION
#
# To acquire table locks within the current session, use the LOCK_TABLES statement,
# which acquires metadata locks (see SECTION 8.11.4, "METADATA LOCKING")
#
# The following lock types are available:
#
# READ [LOCAL] lock:
#
# 		) The session that holds the lock can read the table (but not write it)
#
# 		) Multiple sessions can acquire a READ lock for the table at the same time
#
# 		) Other sessions can read the table without explicitly acquiring a READ lock
#
# 		) The LOCAL modifier enables nonconflicting INSERT statements (concurrent inserts)
# 			by other sessions to execute while the lock is held.
#
# 			(See SECTION 8.11.3, "CONCURRENT INSERTS")
#
# 			However, READ LOCAL cannot be used if you are going to manipulate the database
# 			using processes external to the server while you hold the lock.
#
# 			For InnoDB tables, READ LOCAL is the same as READ
#
# [LOW_PRIORITY] WRITE lock:
#
# 		) The session that holds the lock can read and write the table
#
# 		) Only the session that holds the lock can access the table.
#
# 			No other session can access it until the lock is released.
#
# 		) Lock requests for the table by other sessions block while the WRITE lock is held
#
# 		) The LOW_PRIORITY modifier has no effect.
#
# 			In previous versions of MySQL, it affected locking behavior, but this
# 			is no longer true.
#
# 			It is now deprecated and its use produces a warning. 
#
# 			Use WRITE without LOW_PRIORITY instead
#
# WRITE locks normally have higher priority than READ locks to ensure that updates
# are processed as soon as possible.
#
# This means that if one session obtains a READ lock and then another session
# requests a WRITE lock, subsequent READ lock requests wait until the session
# that requested the WRITE lock has obtained the lock and released it.
#
# (An exception to this policy can occur for small values of the max_write_lock_count
# 	system variable; See SECTION 8.11.4, "METADATA LOCKING")
#
# If the LOCK_TABLES statement must wait due to locks held by other sessions on any
# of the tables, it blocks until all locks can be acquired.
#
# A session taht requries locks must acquire all the locks that it needs in a single
# LOCK_TABLES statement.
#
# While the locks thus obtained are held, the session can access only the locked
# tables.
#
# For example, in the following sequence of statements, an error occurs for the attempt
# to access t2 because it was not locked in the LOCK_TABLES statement:
#
# 		LOCK TABLES t1 READ;
# 		SELECT COUNT(*) FROM t1;
# 		+---------------+
# 		| COUNT(*) 		 |
# 		+---------------+
# 		| 			3 		 |
# 		+---------------+
# 		SELECT COUNT(*) FROM t2;
# 		ERROR 1100 (HY000): Table 't2' was not locked with LOCK TABLES
#
# Tables in the INFORMATION_SCHEMA database are an exception.
#
# they can be accessed without being locked explicitly even while a session
# holds table locks obtained with LOCK_TABLES
#
# You cannot refer to a locked table multiple times in a single query using the
# same name.
#
# Use aliases instead, and obtain a separate lock for the table and each alias:
#
# 		LOCK TABLE t WRITE, t AS t1 READ;
# 		INSERT INTO t SELECT * FROM t;
# 		ERROR 1100: Table 't' was not locked with LOCK TABLES
# 		INSERT INTO t SELECT * FROM t AS t1;
#
# The error occurs for the first INSERT because there are two references to the same
# name for a locked table.
#
# The second INSERT succeeds because the references to the table use different names.
#
# If your statement refer to a table by means of an alias, you must lock the table
# using that same alias.
#
# It does not work to lock the table without specifying the alias:
#
# 		LOCK TABLE t READ;
# 		SELECT * FROM t AS myalias;
# 		ERROR 1100: Table 'myalias' was not locked with LOCK TABLES
#
# Conversely, if you lock a table using an alias, you must refer to it
# in your statements using that alias:
#
# 		LOCK TABLE t AS myalias READ;
# 		SELECT * FROM t;
# 		ERROR 1100: Table 't' was not locked with LOCK TABLES
# 		SELECT * FROM t AS myalias;
#
# NOTE:
#
# 		LOCK TABLES or UNLOCK TABLES, when applied to a partitioned table,
# 		always locks or unlocks the entire table;
#
# 		These statements do not support partition lock pruning. See PARTITIONING AND LOCKING.
#
# TABLE lOCK RELEASE
#
# When the table locks held by a session are released, they are all released at the same time.
#
# A session can release its locks explicitly, or locks may be released implicitly
# under certain conditions:
#
# 		) A session can release its locks explicitly with UNLOCK_TABLES
#
# 		) If a session issues a LOCK_TABLES statement to acquire a lock while already holding locks,
# 			its existing locks are released implicitly before the new locks are granted.
#
# 		) If a session begins a transaction (for example, with START_TRANSACTION), an implicit
# 			UNLOCK_TABLES is performed, which causes existing locks to be released.
#
# 			(For additional information about the interaction between table locking
# 			and transactions, see INTERACTION OF TABLE LOCKING AND TRANSACTIONS)
#
# If the connection for a client session terminates, whether normally or abnormally, the server
# implicitly releases all table locks held by the session (transactional and nontransactional)
#
# If the client reconnects, the locks will no longer be in effect.
#
# In addition, if the client had an active transaction, the server rolls back the transaction
# upon disconnect, and if reconnect occurs, the new session begins with autocommit enabled.
#
# For this reason, clients may wish to disable auto-reconnect
#
# With auto-reconnect in effect, the client is not notified if reconnect occurs but any table
# locks or current transaction will have been lost.
#
# With auto-reconnect disabled, if the connection drops, an error occurs for the next
# statement issued.
#
# The client can detect the error and take appropriate action such as reacquiring the locks
# or redoing the transaction.
#
# See SECTION 28.7.24, "C API AUTOMATIC RECONNECTION CONTROL"
#
# NOTE:
#
# 		If you use ALTER_TABLE on a locked table, it may become unlocked.
#
# 		For example, if you attempt a second ALTER_TABLE operation, the result
# 		may be an error Table 'tbl_name' was not locked with LOCK TABLES
#
# 		To handle this, lock the table again prior to the second alteration
#
# 		See also SECTION B.6.6.1, "PROBLEMS WITH ALTER TABLE"
#
# INTERACTION OF TABLE LOCKING AND TRANSACTIONS
#
# LOCK_TABLES and UNLOCK_TABLES interact with the use of transactions as follows:
#
# 		) LOCK_TABLES is not transaction-safe and implicitly commits any active transaction
# 			before attempting to lock the tables.
#
# 		) UNLOCK_TABLES implicitly commits any active transaction, but only if LOCK_TABLES
# 			has been used to acquire table locks.
#
# 			For example, in the following set of statements, UNLOCK_TABLE releases
# 			the global read lock but does not commit the transaction because no table
# 			locks are in effect:
#
# 				FLUSH TABLES WITH READ LOCK;
# 				START TRANSACTION;
# 				SELECT ---;
# 				UNLOCK TABLES;
#
# 		) Beginning a transaction (for example, with START_TRANSACTION) implicitly commits
# 			any current transaction and releases existing table locks.
#
# 		) FLUSH_TABLES_WITH_READ_LOCK acquires a global read lock and not table locks,
# 			so it is not subject to the same behavior as LOCK_TABLES and UNLOCK_TABLES
# 			with respect to table locking and implicit commits.
#
# 			For example, START_TRANSACTION does not release the global read lock
#
# 			See SECTION 13.7.7.3, "FLUSH SYNTAX"
#
# 		) Other statements that implicitly cause transactions to be committed do not
# 			release existing table locks.
#
# 			For a list of such statements, see SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# 		) The correct way to use LOCK_TABLES and UNLOCK_TABLES with transactional tables, such as
# 			InnoDB tables, is to begin a transaction with SET autocommit = 0 (not START TRANSACTION)
# 			followed by LOCK_TABLES, and to not call UNLOCK_TABLES until you commit the
# 			transaction explicitly.
#
# 			For example, if you need to write to table t1 and read from table t2, you can do this:
#
# 				SET autocommit=0;
# 				LOCK TABLES t1 WRITE, t2 READ, ---;
# 				--- Do something with tables t1 and t2 here ---
# 				COMMIT;
# 				UNLOCK TABLES;
#
# 			When you call LOCK_TABLES, InnoDB internally takes its own table lock, and MySQL
# 			takes its own table lock.
#
# 			InnoDB releases its internal table lock at the next commit, but for MySQL
# 			to release its table lock, you have to call UNLOCK_TABLES.
#
# 			You should not have autocommit = 1, because then InnoDB releases its internal
# 			table lock immediately afer the call of LOCK_TABLES, and deadlocks can very easily happen.
#
# 			InnoDB does not acquire the internal table lock at all if autocommit = 1, to help
# 			old applications avoid unnecessary deadlocks.
#
# 		) ROLLBACK does not release table locks
#
# LOCK TABLES AND TRIGGERS
#
# If you lock a table explicitly with LOCK_TABLES, any tables used in triggers are also
# locked implicitly:
#
# 		) The locks are taken as the same time as those acquired explicitly with the LOCK_TABLES statement
#
# 		) The lock on a table used in a trigger depends on whether the table is used only for reading.
#
# 			If so, a read lock suffices
#
# 			Otherwise, a write lock is used
#
# 		) If a table is locked explicitly for reading with LOCK_TABLES, but needs to be locked for
# 			writing because it might be modified within a trigger, a write lock is taken rather
# 			than a read lock.
#
# 			(That is, an implicit write lock needed due to the table's appearance within a trigger
# 				causes an explicit read lock request for the table to be converted to a write lock request)
#
# Suppose that you lock two tables, t1 and t2, using this statement:
#
# 		LOCK TABLES t1 WRITE, t2 READ;
#
# If t1 or t2 have any triggers, tables used within the triggers will also be locked.
#
# Suppose that t1 has a trigger defined like this:
#
# 		CREATE TRIGGER t1_a_ins AFTER INSERT ON t1 FOR EACH ROW
# 		BEGIN
# 			UPDATE t4 SET count = count+1
# 				WHERE id = NEW.id AND EXISTS (SELECT a FROM t3);
# 			INSERT INTO t2 VALUES(1, 2);
# 		END;
#
# The result of the LOCK_TABLES statement is that t1 and t2 are locked because they appear
# in the statement, and t3 and t4 are locked because they are used within the trigger:
#
# 		) t1 is locked for writing per the WRITE lock request
#
# 		) t2 is locked for writing, even though the request is for a READ lock.
#
# 			This occurs because t2 is inserted into within the trigger, so the READ
# 			request is converted to a WRITE request.
#
# 		) t3 is locked for reading because it is only read from within the trigger
#
# 		) t4 is locked for writing because it might be updated within the trigger
#
# TABLE-LOCKING RESTRICTIONS AND CONDITIONS
#
# You can safely use KILL to terminate a session that is waiting for a table lock.
#
# See SECTION 13.7.7.4, "KILL SYNTAX"
#
# LOCK_TABLES and UNLOCK_TABLES cannot be used within stored programs
#
# Tables in the performance_schema database cannot be locked with LOCK_TABLES,
# except the setup_xxx tables
#
# The following statements are prohibited while a LOCK_TABLES statement is in effect:
#
# 		CREATE_TABLE
#
# 		CREATE_TABLE_---_LIKE
#
# 		CREATE_VIEW
#
# 		DROP_VIEW
#
# and DDL statements on stored functions and procedures and events.
#
# For some operations, system tables in the mysql database must be accessed.
#
# For example, the HELP statement requires the contents of the server-side
# help tables, and CONVERT_TZ() might need to read the time zone tables.
#
# The server implicitly locks the system tables for reading as necessary
# so that you need not lock them explicitly.
#
# These tables are treated as just described:
#
# 		mysql.help_category
# 		mysql.help_keyword
#
# 		mysql.help_relation
# 		mysql.help_topic
#
# 		mysql.time_zone
# 		mysql.time_zone_leap_second
#
# 		mysql.time_zone_name
# 		mysql.time_zone_transition
#
# 		mysql.time_zone_transition_type
#
# If you want to explicitly place a WRITE lock on any of those tables with a LOCK_TABLES
# statement, the table must be the only one locked; no other table can be locked with
# the same statement.
#
# Normally, you do not need to lock tables, because all single UPDATE statements are atomic;
# no other session can interfere with any other currently executing SQL statement.
#
# However, there are a few cases when locking tables may provide an advantage:
#
# 		) If you are going to run many operations on a set of MyISAM tables, it is much faster
# 			to lock the tables you are going to use.
#
# 			Locking MyISAM tables speeds up inserting, updating or deleting on them
# 			because MySQL does not flush the key cache for the locked tables until
# 			UNLOCK_TABLES is called.
#
# 			Normally, the key cache is flushed after each SQL statement.
#
# 			The downside to locking the tables is that no session can update a READ-locked
# 			table (including the one holding the lock) and no session can access
# 			a WRITE-locked table other than the one holding the lock.
#
# 		) If you are using tables for a nontransactional storage engine, you must use
# 			LOCK_TABLES if you want to ensure that no other session modifies the tables
# 			between a SELECT and an UPDATE.
#
# 			The example shown here requires LOCK_TABLES to execute safely:
#
# 				LOCK TABLES trans READ, customer WRITE;
# 				SELECT SUM(value) FROM trans WHERE customer_id=some_id;
# 				UPDATE customer
# 					SET total_value=sum_from_previous_statement
# 					WHERE customer_id=some_id;
# 				UNLOCK TABLES;
#
# 			Without LOCK_TABLES, it is possible that another session might insert
# 			a new row in the trans table between execution of the SELECT and UPDATE statements.
#
# You can avoid using LOCK_TABLES in many cases by using relative updates (UPDATE customer SET value=value+new_value)
# or the LAST_INSERT_ID() function
#
# You can also avoid locking tables in some cases by using the user-level advisory lock functions
# GET_LOCK() and RELEASE_LOCK()
#
# These locks are saved in a hash table in the server and implemented with pthread_mutex_lock()
# and pthread_mutex_unlock() for high speed.
#
# See SECTION 12.14, "LOCKING FUNCTIONS"
#
# See SECTION 8.11.1, "INTERNAL LOCKING METHODS", for more information on locking policy.
#
# 13.3.7 SET TRANSACTION SYNTAX
#
# 		SET [GLOBAL | SESSION] TRANSACTION
# 			transaction_characteristic [, transaction_characteristic] ---
#
# 		transaction_characteristic: {
# 			ISOLATION LEVEL level
# 		 | access_mode
# 		}
#
# 		level: {
# 			REPEATABLE READ
# 		 | READ COMMITTED
# 		 | READ UNCOMMITTED
# 		 | SERIALIZABLE
# 		}
# 		
# 		access_mode: {
# 			READ WRITE
# 		 | READ ONLY
# 		}
#
# This statement specifies transaction characteristics.
#
# It takes a list of one or more characteristic values separated by commas.
#
# Each characteristic value sets the transaction isolation level or access mode.
#
# The isolation level is used for operations on InnoDB tables.
#
# The access mode specifies whether transactions operate in read/write or 
# read-only mode
#
# In addition, SET_TRANSACTION can include an optional GLOBAL or SESSION keyword
# to indicate the scope of the statement.
#
# 		) TRANSACTION ISOLATION LEVELS
#
# 		) TRANSACTION ACCESS MODE
#
# 		) TRANSACTION CHARACTERISTIC SCOPE
#
# TRANSACTION ISOLATION LEVELS
#
# To set the transaction isolation level, use an ISOLATION LEVEL level clause.
#
# It is not permitted to specify multiple ISOLATION LEVEL clauses in the same
# SET_TRANSACTION statement.
#
# The default isolation level is REPEATABLE_READ.
#
# Other permitted values are READ_COMMITTED, READ_UNCOMMITTED, and SERIALIZABLE
#
# For information about these isolation levels, see SECTION 15.7.2.1, "TRANSACTION ISOLATION LEVELS"
#
# TRANSACTION ACCESS MODE
#
# To set the transaction access mode, use a READ WRITE or READ ONLY clause.
#
# It is not permitted to specify multiple access-mode clauses in the same SET_TRANSACTION
# statement.
#
# By default, a transaction takes place in read/write mode, with both reads and writes permitted
# to tables used in the transaction.
#
# This mode may be specified explicitly using SET_TRANSACTION with an access mode of READ WRITE
#
# If the transaction access mode is set to READ ONLY, changes to tables are prohibited.
#
# This may enable storage engines to make performance improvements that are possible
# when writes are not permitted.
#
# In read-only mode, it remains possible to change tables created with the TEMPORARY keyword
# using DML statements.
#
# Changes made with DDL statements are not permitted, just as with permanent tables.
#
# The READ WRITE and READ ONLY access modes also may be specified for an individual transaction
# using the START_TRANSACTION statement.
#
# TRANSACTION CHARACTERISTIC SCOPE
#
# You can set transaction characteristic globally, for the current session, or for the
# next transaction only:
#
# 		) With the GLOBAL keyword:
#
# 			) The statement applies globally for all subsequent sessions
#
# 			) Existing sessions are unaffected
#
# 		) With the SESSION keyword:
#
# 			) The statement applies to all subsequent transactions performed within the current session.
#
# 			) The statement is permitted within transactions, but does not affect the current ongoing transaction
#
# 			) If executed between transactions, the statement overrides any preceding statement that sets the
# 				next-transaction value of the named characteristics
#
# 		) Without any SESSION or GLOBAL keyword:
#
# 			) The statement applies only to the next single transaction performed within the session
#
# 			) Subsequent transactions revert to using the session value of the named characteristics
#
# 			) The statement is not permitted within transactions:
#
# 				START TRANSACTION;
# 				Query OK, 0 rows affected (0.02 sec)
#
# 				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
# 				ERROR 1568 (25001): Transaction characteristics can't be changed
# 				while a transaction is in progress
#
# A change to global transaction characteristics requires the CONNECTION_ADMIN or SUPER privilege.
#
# Any session is free to change its session characteristics (even in the middle of a transaction),
# or the characteristics for its next transaction (prior to the start of that transaction)
#
# To set the global isolation level at server startup, use the --transaction-isolation=level option
# on the command line or in an option file.
#
# Values of level for this option uses dashes rather than spaces, so the permissible values are
# READ-UNCOMMITTED, READ-COMMITTED, REPEATABLE-READ, or SERIALIZABLE
#
# Similarly, to set the global transaction access mode at server startup, use the --transaction-read-only
# option
#
# The default is OFF (read/write mode) but the value can be set to ON for a mode of read only.
#
# For example, to set the isolation level to REPEATABLE READ and the access mode to READ WRITE,
# use these lines in the [mysqld] section of an option file:
#
# 		[mysqld]
# 		transaction-isolation = REPEATABLE-READ
# 		transaction-read-only = OFF
#
# At runtime, characteristics at the global, session, and next-transaction scope levels
# can be set indirectly using the SET_TRANSACTION statement, as described previously.
#
# They can also be set directly using the SET statement to assign values to the 
# transaction_isolation and transaction_read_only system variables:
#
# 		) SET_TRANSACTION permits optional GLOBAL and SESSION keywords for setting transaction
# 			characteristics at different scope levels.
#
# 		) The SET statement for assigning values to the transaction_isolation and transaction_read_only
# 			system variables has syntaxes for setting these variables at different scope levels.
#
# The following tables show the characteristic scope level set by each SET_TRANSACTION
# and variable-assignment syntax.
#
# TABLE 13.7 SET TRANSACTION SYNTAX FOR TRANSACTION CHARACTERISTICS
#
# 		SYNTAX 															AFFECTED CHARACTERISTIC SCOPE
#
# 	SET GLOBAL TRANSACTION transaction_characteristic 		Global
#
# 	SET SESSION TRANSACTION transaction_characteristic 	Session
#
# 	SET TRANSACTION transaction_characteristic 				Next transaction only
#
# TABLE 13.8 SET SYNTAX FOR TRANSACTION CHARACTERISTICS
#
# 		SYNTAX 															AFFECTED CHARACTERISTIC SCOPE
#
# 	SET GLOBAL var_name = value 									Global
#
# 	SET @@GLOBAL.var_name = value 								Global
#
# 	SET PERSIST var_name = value 									Global
#
# 	SET @@PERSIST.var_name = value 								Global
#
# 	SET PERSIST_ONLY var_name = value 							No runtime effect
#
# 	SET @@PERSIST_ONLY var_name = value 						No runtime effect
#
# 	SET SESSION var_name = value 									Session
#
# 	SET @@SESSION.var_name = value 								Session
#
# 	SET var_name = value 											Session
#
# 	SET @@var_name = value 											Next transaction only
#
# It is possible to check the global and sesion values of transaction characteristics at runtime:
#
# 		SELECT @@GLOBAL.transaction_isolation, @@GLOBAL.transaction_read_only;
# 		SELECT @@SESSION.transaction_isolation, @@SESSION.transaction_read_only;
#
# 13.3.8 XA TRANSACTIONS
#
# 13.3.8.1 XA TRANSACTION SQL SYNTAX
# 13.3.8.2 XA TRANSACTION STATES
#
# Support for XA transactions is available for the InnoDB storage engine.
#
# The MySQL XA implementation is based on the X/Open CAE document Distributed Transaction Processing: The XA specfication
#
# This document is published by The Open Group and available at <link>
#
# Limitations of the current XA implementation are described in SECTION C.6, "RESTRICTIONS ON XA TRANSACTIONS"
#
# On the client side, there are no special requirements. The XA interface to a MySQL server consists
# of SQL statements that begin with the XA keyword.
#
# MySQL client programs must be able to send SQL statements and to understand the semantics
# of the XA statement interface.
#
# They do not need be linked against a recent client library.
#
# Older client libraries also will work.
#
# Among the MySQL Connectors, MySQL Connector/J 5.0.0 and higher supports XA directly,
# by means of a class interface that handles the XA SQL statement interface for you.
#
# XA supports distributed transactions, that is, the ability to permit multiple separate
# transactional resources to participate in a global transaction.
#
# Transactional resources often are RDBMSs but may be other kinds of resources.
#
# A global transaction involves several actions that are transactional in themselves,
# but that all must either complete successfully as a group, or all be rolled back
# as a group.
#
# In essence, this extends ACID properties "up a level" so that multiple ACID transactions
# can be executed in concert as components of a global operation that also has ACID
# properties.
#
# (As with nondistributed transactions, SERIALIZABLE may be preferred if your applications
# are sensitive to read phenomena.
#
# REPEATABLE_READ may not be sufficient for distributed transactions)
#
# Some examples of distributed transactions:
#
# 		) An application may act as an integration tool that combines a messaging service
# 			with an RDBMS.
#
# 			The application makes sure that transactions dealing with message sending, retrieval
# 			and processing that also involve a transactional database all happen in a global transaction.
#
# 			You can think of this as "transactional email"
#
# 		) An application performs actions that involve different database servers, such as a MySQL
# 			server and an Oracle server (or multiple MySQL servers), where actions that involve
# 			multiple servers must happen as part of a global transaction, rather than as separate
# 			transactions local to each server.
#
# 		) A bank keeps account information in an RDBMS and distributes and receives money through
# 			automated teller machines (ATMs) 
#
# 			It is necessary to ensure that ATM actions are correctly reflected in the accounts,
# 			but this cannot be done with the RDBMS alone.
#
# 			A global transaction manager integrates the ATM and database resources to ensure
# 			overall consistency of financial transactions.
#
# Applications that use global transactions involve one or more Resource Managers and a Transaction Manager:
#
# 		) A Resource Manager (RM) provides access to transactional resources.
#
# 			A database server is one kind of resource manager. It must be possible to either commit or roll
# 			back transactions managed by the RM
#
# 		) A Transaction Manager (TM) coordinates the transactions that are part of a global transaction.
#
# 			It communicates with the RMs that handle each of these transactions.
#
# 			The individual transactions within a global transaction are "branches" of the global transaction.
#
# 			Global transactions and their branches are identified by a naming scheme described later.
#
# The MySQL implementation of XA enables a MySQL server to act as a Resource Manager that handles
# XA transactions within a global transaction.
#
# A client program that connects to the MySQL server acts as the Transaction Manager
#
# To carry out a global transaction, it is necessary to know which components are involved,
# and bring each component to a point when it can be committed or rolled back.
#
# Depending on what each component reports about its ability to succeed, they must all commit
# or roll back as an atomic group.
#
# That is, either all components must commit, or all components must roll back.
#
# To manage a global transaction, it is necessary to take into account that any
# component or the connecting network might ffail.
#
# The process for executing a global transaction uses two-phase commit (2PC)
#
# This takes place after the actions performed by the branches of the global transaction
# have been executed.
#
# 		1. In the first phase, all branches are prepared.
#
# 			That is, they are told by the TM to get ready to commit.
#
# 			Typically, this means each RM that manages a branch records the
# 			actions for the branch in stable storage.
#
# 			The branches indicate whether they are able to do this, and these
# 			results are used for the second phase.
#
# 		2. In the second phase, the TM tells the RMs whether to commit or roll back.
#
# 			If all branches indicated when they were prepared that they will be able
# 			to commit, all branches are told to commit.
#
# 			If any branch indicated when it was prepared that it will not be able to commit,
# 			all branches are told to roll back.
#
# In some cases, a global transaction might use one-phase commit (1PC)
#
# For example, when a Transaction Manager finds a global transaction consists of only
# one transactional resource (that is, a single branch), that resource can be told
# to prepare and commit at the same time.
#
# 13.3.8.1 XA TRANSACTION SQL SYNTAX
#
# To perform XA transactions in MySQL, use the following statements:
#
# 		XA {START|BEGIN} xid [JOIN|RESUME]
#
# 		XA END xid [SUSPEND [FOR MIGRATE]]
#
# 		XA PREPARE xid
#
# 		XA COMMIT xid [ONE PHASE]
#
# 		XA ROLLBACK xid
#
# 		XA RECOVER [CONVERT XID]
#
# For XA_START, the JOIN and RESUME clauses are not supported.
#
# For XA_END the SUSPEND [FOR MIGRATE] clause is not supported.
#
# Each XA statement begins with the XA keyword, and most of them require an
# xid value.
#
# An xid is an XA transaction identifier.
#
# It indicates which transaction the statement applies to.
# xid values are supplied by the client, or generated by the MySQL server.
#
# An xid value has from one to three parts:
#
# 		xid: gtrid [, bqual [, formatID ]]
#
# gtrid is a global transaction identifier, bqual is a branch qualifier, and
# formatID is a number that identifies the format used by the gtrid and bqual
# values.
#
# As indicated by the syntax, bqual and formatID are optional.
#
# The default bqual value is '' if not given.
#
# The default formatID value is 1 if not given.
#
# gtrid and bqual must be string literals, each up to 64 bytes (not characters)
# long
#
# gtrid and bqual can be specified in several ways
#
# You can use a quoted string ('ab'), hex string(X'6162', 0x6162) or bit value (b'nnnn')
#
# formatID is an unsigned integer
#
# The gtrid and bqual values are interpreted in bytes by the MySQL server's underlying
# XA support routines.
#
# However, while an SQL statement containing an XA statement is being parsed,
# the server works with some specific character set.
#
# To be safe, write gtrid and bqual as hex strings.
#
# xid values typically are generated by the Transaction Manager.
#
# Values generated by one TM must be different from values generated by other
# TMs.
#
# A given TM must be able to recognize its own xid values in a list of values
# returned by the XA_RECOVER statement.
#
# XA_START_xd starts an XA transaction with the given xid value.
#
# Each XA transaction must have a unique xid value, so the value must not 
# currently be used by another XA transaction.
#
# Uniqueness is assessed using the gtrid and bqual values. All following XA statements
# for the XA transaction must be specified using the same xid value as that
# given in the XA_START statement.
#
# If you use any of those statements but specify an xid value that does not
# correspond to some existing XA transaction, an error occurs.
#
# One or more XA transactions can be part of the same global transaction.
#
# All XA transactions within a given global transaction must use the same
# gtrid value in the xid value´.
#
# For this reason, gtrid values must be globally unique so that there is
# no ambiguity about which global transaction a given XA transaction is
# part of.
#
# The bqual part of the xid value must be different for each XA transaction
# within a global transaction.
#
# (The requirement that bqual values be different is a limitation of the
# current MySQL XA implementation.
#
# It is not part of the XA specification)
#
# The XA_RECOVER statement returns information for those XA transactions
# on the MySQL server that are in the PREPARED state.
#
# (See SECTION 13.3.8.2, "XA TRANSACTION STATES")
#
# The output includes a row for each such XA transaction on the server,
# regardless of which client started it.
#
# XA_RECOVER requires the XA_RECOVER_ADMIN privilege.
#
# This privilege requirement prevents users from discovering the XID values
# for oustanding prepared XA transactions other than their own.
#
# It does not affect normal commit or rollback of an XA transaction
# because the user who started it knows its XID
#
# XA_RECOVER output rows look like this (for an example xid value consisting of the parts 'abc', 'def', and 7):
#
# 		XA RECOVER;
# 		+----------+------------------+--------------------+-------------------+
# 		| formatID | gtrid_length 		| bqual_length 		| data 				  |
# 		+----------+------------------+--------------------+-------------------+
# 		| 		7 	  | 			3 		 	| 		3 					| 	abcdef 			  |
# 		+----------+------------------+--------------------+-------------------+
#
# The output columns have the following meanings:
#
# 		) formatID is the formatID part of the transaction xid
#
# 		) gtrid_length is the length in bytes of the gtrid part of the xid
#
# 		) bqual_length is the length in bytes of the bqual part of the xid
#
# 		) data is the concatenation of the gtrid and bqual parts of the xid
#
# XID values may contain nonprintable characters 
#
# XA_RECOVER permits an optional CONVERT XID clause so that clients can request
# XID values in hexadecimal.
#
# 13.3.8.2 XA TRANSACTION STATES
#
# An XA transaction progresses through the following states:
#
# 		1. Use XA_START to start an XA transaction and put it in the ACTIVE state
#
# 		2. For an ACTIVE XA transaction, issue the SQL statements that make up the transaction,
# 			and then issue an XA_END statement.
#
# 			XA_END puts the transaction in the IDLE state.
#
# 		3. For an IDLE XA transaction, you can issue either an XA_PREPARE statement or an
# 			XA COMMIT --- ONE phase statement:
#
# 			) XA_PREPARE puts the transaction in the PREPARED state.
#
# 				An XA_RECOVER statement at this point will include the transaction's xid value
# 				in its output, because XA_RECOVER lists all XA transactions that are in the 
# 				PREPARED state
#
# 			) XA COMMIT --- ONE PHASE prepares and commits the transaction.
#
# 				The xid value will not be listed by XA_RECOVER because the transaction terminates.
#
# 		4. For a PREPARED XA transaction, you can issue an XA_COMMIT statement to commit and
# 			terminate the transaction, or XA_ROLLBACK to roll back and terminate the transaction.
#
# Here is a simple XA transaction that inserts a row into a table as part of a global transaction:
#
# 		XA START 'xatest';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		INSERT INTO mytable (i) VALUES(10);
# 		Query OK, 1 row affected (0.04 sec)
#
# 		XA END 'xatest';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		XA PREPARE 'xatest';
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		XA COMMIT 'xatest';
# 		Query OK, 0 rows affected (0.00 sec)
#
# Within the context of a given client connection, XA transactions and local (non-XA) transactions
# are mutually exclusive.
#
# For example, if XA_START has been issued to begin an XA transaction, a local transaction
# cannot be started until the XA transaction has been committed or rolled back.
#
# Conversely, if a local transaction has been started with START_TRANSACTION,
# no XA statements can be used until the transaction has been committed or rolled back.
#
# If an XA transaction is in the ACTIVE state, you cannot issue any statements that cause
# an implicit commit.
#
# That would violate the XA contract because you could not roll back the XA transaction.
#
# You will receive the following error if you try to execute such a statement:
#
# 		ERROR 1399 (XAE07): XAER_RMFAIL: The command cannot be executed
# 		when global transaction is in the ACTIVE state
#
# Statements to which the preceding remark applies are listed at 
# SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# 13.4 REPLICATION STATEMENTS
#
# 13.4.1 SQL STATEMENTS FOR CONTROLLING MASTER SERVERS
# 13.4.2 SQL STATEMENTS FOR CONTROLLING SLAVE SERVERS
# 13.4.3 SQL STATEMENTS FOR CONTROLLING GROUP REPLICATION
#
# Replication can be controlled through the SQL interface using the statements
# described in this section.
#
# Statements are split into a group which controls master servers, a group
# which controls slave servers, and a group which can be applied to any replication
# servers.
#
# 13.4.1 SQL STATEMENTS FOR CONTROLLING MASTER SERVERS
#
# 13.4.1.1 PURGE BINARY LOGS SYNTAX
# 13.4.1.2 RESET MASTER SYNTAX
# 13.4.1.3 SET SQL_LOG_BIN SYNTAX
#
# This section discusses statements for managing master replication servers.
#
# SECTION 13.4.2, "SQL STATEMENTS FOR CONTROLLING SLAVE SERVERS", discusses
# statements for managing slave servers.
#
# In addition to the statements described here, the following SHOW statements
# are used with master servers in replication.
#
# For information about these statements, see SECTION 13.7.6, "SHOW SYNTAX"
#
# 		) SHOW BINARY LOGS
#
# 		) SHOW BINLOG EVENTS
#
# 		) SHOW MASTER STATUS
#
# 		) SHOW SLAVE HOSTS
#
# 13.4.1.1 PURGE BINARY LOGS SYNTAX
#
# 	PURGE { BINARY | MASTER } LOGS
# 		{ TO 'log_name' | BEFORE datetime_expr }
#
# The binary log is a set of files that contain information about data modifications
# made by the MySQL server.
#
# The log consists of a set of binary log files, plus an index file 
# (See SECTION 5.4.4, "THE BINARY LOG")
#
# The PURGE_BINARY_LOGS statement deletes all the binary log files listed in the
# log index file prior to the specified log file name or date.
#
# BINARY and MASTER are synonyms
#
# Deleted log files also are removed from the list recorded in the index file, so that
# the given log file becomes the first in the list.
#
# This statement has no effect if the server was not started with the --log-bin
# option to enable binary logging.
#
# Examples:
#
# 		PURGE BINARY LOGS TO 'mysql-bin.010';
# 		PURGE BINARY LOGS BEFORE '2008-04-02 22:46:26';
#
# The BEFORE variant's datetime_expr argument should evaluate to a DATETIME value
# (a value in 'YYYY-MM-DD hh:mm:ss' format)
#
# This statement is safe to run while slaves are replicating.
#
# You need not stop them. If you have an active slave that currently is reading
# one of the log files you are trying to delete, this statement does not delete
# the log file that is in use or any log files later than that one, but it deletes
# any earlier log files.
#
# A warning message is issued in this situation.
#
# However, if a slave is not connected and you happen to purge one of the log files
# it has yet to read, the slave will be unable to replicate after it reconnects.
#
# To safely purge binary log files, follow this procedure:
#
# 		1. On each slave server, use SHOW_SLAVE_STATUS to check which log file it is reading.
#
# 		2. Obtain a listing of the binary log files on the master server with SHOW_BINARY_LOGS
#
# 		3. Determine the earliest log file among all the slaves.
#
# 			This is the target file. If all the slaves are up to date, this is the last log file
# 			on the list.
#
# 		4. Make a backup of all the log files you are about to delete (optional)
#
# 		5. Purge all log files up to but not including the target file
#
# PURGE BINARY LOGS TO and PURGE BINARY LOGS BEFORE both fail with an error when binary
# log files listed in the .index file had been removed from the system by some other means
# (such as using rm on Linux)
#
# (Bug #18199, Bug #18453) 
#
# To handle such errors, edit the .index file (which is a simple text file) manually
# to ensure that it lists only the binary log files that are actually present, then
# run again the PURGE_BINARY_LOGS statement that failed.
#
# Binary log files are automatically removed after the server's binary log expiration
# period.
#
# Removal of the files can take place at startup and when the binary log is flushed.
#
# The default binary log expiration period is 30 days.
#
# You can specify an alternative expiration period using the binlog_expire_logs_seconds
# system variable.
#
# If you are using replication, you should specify an expiration period that is no lower
# than the maximum amount of time your slaves might lag behind the master.
#
# 13.4.1.2 RESET MASTER SYNTAX
#
# 		RESET MASTER [TO binary_log_file_number]
#
# RESET MASTER enables you to delete any binary log files and their related binary log
# index file, returning the master to its state before binary logging was started.
#
# WARNING:
#
# 		Use this statement with caution to ensure you do not lose binary log file data
#
# Issuing RESET MASTER without the optional TO clause deletes all binary log files listed
# in the index file, resets the binary log index file to be empty, and creates a new
# binary log file starting at 1.
#
# Use the optional TO clause to start the binary log file index from a number other than
# 1 after the reset.
#
# Issuing RESET MASTER also clears the values of the gtid_purged system variable and the
# gtid_executed system variable; that is, issuing this statement sets each of these
# values to an empty string ('')
#
# This statement also clears the mysql.gtid_executed table (see MYSQL.GTID_EXECUTED TABLE)
#
# Using RESET MASTER with the TO clause to specify a binary log file index number to start
# from simplifies failover by providing a single statement alternative to the FLUSH_BINARY_LOGS
# and PURGE_BINARY_LOGS_TO statements.
#
# The following example demonstrates TO clause usage:
#
# 		RESET MASTER TO 1234;
#
# 		SHOW BINARY LOGS;
# 		+-----------------------------+---------------+
# 		| Log_name 							| File_size 	 |
# 		+-----------------------------+---------------+
# 		| master-bin.001234 			   | 154 			 |
# 		+-----------------------------+---------------+
#
# IMPORTANT:
#
# 		The effects of RESET_MASTER without the TO clause differ from those of
# 		PURGE_BINARY_LOGS in 2 key ways:
#
# 			1. RESET_MASTER removes all binary log files that are listed in the index file,
# 				leaving only a single, empty binary log file with a numeric suffix of
# 				.000001, whereas the numbering is not reset by PURGE_BINARY_LOGS
#
# 			2. RESET_MASTER is not intended to be used while any replication slaves
# 				are running.
#
# 				The behavior of RESET_MASTER when used while slaves are running
# 				is undefined (and thus unsupported), whereas PURGE_BINARY_LOGS
# 				may be safely used while replication slaves are running.
#
# 		See also SECTION 13.4.1.1, "PURGE BINARY LOGS SYNTAX"
#
# RESET_MASTER without the TO clause can prove useful when you first set up
# the master and the slave, so that you can verify the setup as follows:
#
# 		1. Start the master and slave, and start replication (see SECTION 17.1.2, "SETTING UP BINARY LOG FILE POSITION BASED REPLICATION")
#
# 		2. Execute a few test queries on the master
#
# 		3. Check that the queries were replicated to the slave
#
# 		4. When replication is running correctly, issue STOP_SLAVE followed by
# 			RESET_SLAVE on the slave, then verify that no unwanted data from the
# 			test queries exists on the slave.
#
# 		5. Issue RESET_MASTER on the master to clean up the test queries
#
# After verifying the setup, resetting the master and slave and ensuring that no unwanted
# data or binary log files generated by testing remain on the master or slave, you can
# start the slave and begin replicating.
#
# 13.4.1.3 SET SQL_LOG_BIN_SYNTAX
#
# 		SET sql_log_bin = {OFF|ON}
#
# The sql_log_bin variable controls whether logging to the binary log is enabled
# for the current session (assuming that the binary log itself is enabled)
#
# The default value is ON
#
# To disable or enable binary logging for the current session, set the session
# sql_log_bin variable to OFF or ON
#
# Set this variable to OFF for a session to temporarily disable binary logging
# while making changes to the master you do not want replicated to the slave.
#
# Setting the session value of this system variable is a restricted operation
#
# The session user must have privileges sufficient to set restricted session
# variables.
#
# See SECTION 5.1.9.1, "SYSTEM VARIABLE PRIVILEGES"
#
# It is not possible to set the session value of sql_log_bin within
# a transaction or subquery
#
# Setting this variable to OFF prevents GTIDs from being assigned to transactions
# in the binary log.
#
# If you are using GTIDs for replication, this means that even when binary logging
# is later enabled again, the GTIDs written into the log from this point do not
# account for any transactions that occurred in the meantime, so in effect those
# transactions are lost.
#
# 13.4.2 SQL STATEMENTS FOR CONTROLLING SLAVE SERVERS
#
# 13.4.2.1 CHANGE MASTER TO SYNTAX
# 13.4.2.2 CHANGE REPLICATION FILTER SYNTAX
#
# 13.4.2.3 MASTER_POS_WAIT() SYNTAX
# 13.4.2.4 RESET SLAVE SYNTAX
#
# 13.4.2.5 SET GLOBAL SQL_SLAVE_SKIP_COUNTER SYNTAX
# 13.4.2.6 START SLAVE SYNTAX
#
# 13.4.2.7 STOP SLAVE SYNTAX
#
# This section discusses statements for managing slave replication servers.
#
# SECTION 13.4.1, "SQL STATEMENTS FOR CONTROLLING MASTER SERVERS", discusses statements
# for managing master servers.
#
# In addition to the statements described here, SHOW_SLAVE_STATUS and SHOW_RELAYLOG_EVENTS
# are also used with replicaiton slaves.
#
# For information about these statements, see SECTION 13.7.6.34, "SHOW SLAVE STATUS SYNTAX"
# and SECTION 13.7.6.32, "SHOW RELAYLOG EVENTS SYNTAX"
#
# 13.4.2.1 CHANGE MASTER TO SYNTAX
#
# 	CHANGE MASTER TO option [, option] --- [ channel_option ]
#
# 	option:
# 		MASTER_BIND = 'interface_name'
#   | MASTER_HOST = 'host_name'
#   | MASTER_USER = 'user_name'
#   | MASTER_PASSWORD = 'password'
#   | MASTER_PORT = port_num
#   | MASTER_CONNECT_RETRY = interval
#   | MASTER_RETRY_COUNT = count
#   | MASTER_DELAY = interval
#
#   | MASTER_HEARTBEAT_PERIOD = interval
# 	 | MASTER_LOG_FILE = 'master_log_name'
#   | MASTER_LOG_POS = master_log_pos
#   | MASTER_AUTO_POSITION = {0|1}
#   | RELAY_LOG_FILE = 'relay_log_name'
# 	 | RELAY_LOG_POS = relay_log_pos
#
# 	 | MASTER_SSL = {0|1}
# 	 | MASTER_SSL_CA = 'ca_file_name'
#   | MASTER_SSL_CAPATH = 'ca_directory_name'
# 	 | MASTER_SSL_CERT = 'cert_file_name'
# 	 | MASTER_SSL_CRT = 'crl_file_name'
# 	 | MASTER_SSL_CRLPATH = 'crl_directory_name'
#   | MASTER_SSL_KEY = 'key_file_name'
#   | MASTER_SSL_CIPHER = 'cipher_list'
#   | MASTER_SSL_VERIFY_SERVER_CERT = {0|1}
#   | MASTER_TLS_VERSION = 'protocol_list'
#   | MASTER_PUBLIC_KEY_PATH = 'key_file_name'
#   | GET_MASTER_PUBLIC_KEY = {0|1}
#   | IGNORE_SERVER_IDS = (server_id_list)
#
# 	channel_option:
# 		FOR CHANNEL channel
#
# 	server_id_list:
# 		[server_id [, server_id] --- ]
#
# CHANGE_MASTER_TO changes the parameters that the slave server uses for
# connecting to the master server, for reading the master binary log and
# reading the slave relay log.
#
# It also updates the contents of the master info and relay log info repositories
# (see SECTION 17.2.4, "REPLICATION RELAY AND STATUS LOGS")
#
# CHANGE_MASTER_TO requires the REPLICATION_SLAVE_ADMIN or SUPER privilege
#
# You can issue CHANGE MASTER TO statements on a running slave without first
# stopping it, depending on the states of the slave SQL thread and slave I/O
# thread.
#
# The rules governing such use are provided later in this section
#
# When using a multithreaded slave (in other words slave_parallel_workers is greater
# than 0), stopping the slave can cause "gaps" in the sequence of transactions that
# have been executed from the relay log, regardless of whether the slave was stopped
# intentionally or otherwise.
#
# When such gaps exist, issuing CHANGE_MASTER_TO fails
#
# The solution in this situation is to issue START_SLAVE_UNTIL_SQL_AFTER_MTS_GAPS
# which ensures that the gaps are closed.
#
# The optional FOR CHANNEL channel clause enables you to name which replication
# channel the statement applies to.
#
# Providing a FOR CHANNEL channel clause applies the CHANGE MASTER to statement
# to a specific replication channel, and is used to add a new channel or modify
# an existing channel.
#
# For example, to add a new channel called channel2:
#
# 		CHANGE MASTER TO MASTER_HOST=host1, MASTER_PORT=3002 FOR CHANNEL 'channel2'
#
# If no clause is named and no extra channels exist, the statement applies to the
# default channel.
#
# When using multiple replication channels, if a CHANGE MASTER TO statement does not
# name a channel using a FOR CHANNEL channel clause, an error occurs.
#
# See SECTION 17.2.3, "REPLICATION CHANNELS" for more information.
#
# Options not specified retain their value, except as indicated in the following discussion.
#
# Thus, in most cases, there is no need to specify options that do not change.
#
# MASTER_HOST, MASTER_USER, MASTER_PASSWORD and MASTER_PORT provide information
# to the slave about how to connect to its master:
#
# 		) MASTER_HOST and MASTER_PORT are the host name (or IP address) of the master host and its TCP/IP port
#
# 			NOTE:
#
# 				Replication channel use UNIX socket files.
#
# 				You must be able to connect to the master MySQL server using TCP/IP
#
# 			If you specify the MASTER_HOST or MASTER_PORT option, the slave assumes that the master
# 			server is different from before (even if the option value is the same as its current value)
#
# 			In this case, the old values for the master binary log file name and position are considered
# 			no longer applicable, so if you do not specify MASTER_LOG_FILE and MASTER_lOG_POS in the
# 			statement, MASTER_LOG_FILE='' and MASTER_LOG_POS=4 are silently appended to it.
#
# 			Setting MASTER_HOST='' (that is, setting its value explicitly to an empty string) is not
# 			the same as not setting MASTER_HOST at all.
#
# 			Trying to set MASTER_HOT to an empty string fails with an error.
#
# 			Values used for MASTER_HOST and other CHANGE MASTER TO options are checked for
# 			linefeed (\n or 0x0A) characters; the presence of such characters in these values
# 			causes the statement to fail with ER_MASTER_INFO.
#
# 			(Bug #11758581, Bug #50801)
#
# 		) MASTER_USER and MASTER_PASSWORD are the user name and password of the account to use
# 			for connecting to the master.
#
# 			MASTER_USER cannot be made empty; setting MASTER_USER = '' or leaving it unset when
# 			setting a value for MASTER_PASSWORD causes an error (Bug #13427949)
#
# 			The password used for a MySQL Replication slave account in a CHANGE MASTER TO
# 			statement is limited to 32 characters in length;
#
# 			Trying to use a password of more than 32 characters causes CHANGE MASTER TO to fail
#
# 			The text of a running CHANGE_MASTER_TO statement, including values for MASTER_USER and
# 			MASTER_PASSWORD, can be seen in the output of a concurrent SHOW_PROCESSLIST statement.
#
# 			(The complete text of a START_SLAVE statement is also visible to SHOW_PROCESSLIST)
#
# The MASTER_SSL_xxx options, and the MASTER_TLS_VERSION option, specify how the slave uses
# encryption and ciphers to secure the replication connection.
#
# These options can be changed even on slaves that are compiled without SSL support.
#
# They are saved to the master info repository, but are ignored if the slave does not
# have SSL support enabled.
#
# The MASTER_SSL_xxx options perform the same functions as the --ssl-xxx options described
# in SECTION 6.4.2, "COMMAND OPTIONS FOR ENCRYPTED CONNECTIONS"
#
# The correspondence between the two sets of options, and the use of the MASTER_SSL_xxx
# and MASTER_TLS_VERSION options to set up a secure connection, is explained in
# SECTION 17.3.9, "SETTING UP REPLICATION TO USE ENCRYPTED CONNECTIONS"
#
# 		IMPORTANT:
#
# 			To connect to the replication master using a user account that authenticates
# 			with the caching_sha2_password plugin, you must either set up a secure
# 			connection as described in SECTION 17.3.9, "SETTING UP REPLICATION TO USE ENCRYPTED CONNECTIONS",
# 			or enable the unencrypted connection to support password exchange using an
# 			RSA key pair.
#
# 			The caching_sha2_password authentication plugin is the default for new users
# 			created from MySQL 8.0 (for details, see SECTION 6.5.1.3, "CACHING SHA-2 PLUGGABLE AUTHENTICATION")
#
# 			If the user account that you create or use for replication (as specified by the
# 			MASTER_USER option) uses this authentication plugin, and you are not using a
# 			secure connection, you must enable RSA key pair-based password exchange for a 
# 			successful connection.
#
# To enable RSA key pair-based password exchange, specify either the MASTER_PUBLIC_KEY_PATH
# or the GET_MASTER_PUBLIC_KEY=1 option
#
# Either of these options provides the RSA public key to the slave:
#
# 		) MASTER_PUBLIC_KEY_PATH indicates the path name to a file containing a slave-side
# 			copy of the public key required by the master for RSA key pair-based password
# 			exchange.
#
# 			The file must be in PEM format.
#
# 			This option applies to slaves that authenticate with the sha256_password
# 			or caching_sha2_password authentication plugin.
#
# 			(For sha256_password, MASTER_PUBLIC_KEY_PATH can be used only if MySQL
# 			was built using OpenSSL)
#
# 		) GET_MASTER_PUBLIC_KEY indicates whether to request from the master the public key
# 			required for RSA key pair-based password exchange.
#
# 			This option applies to slaves that authenticate with the caching_sha2_password
# 			authentication plugin.
#
# 			For connections by accounts that authenticate using this plugin, the master
# 			does not send the public key unless requested, so it must be requested or
# 			specified in the client.
#
# 			If MASTER_PUBLIC_KEY_PATH is given and specifies a valid public key file,
# 			it takes precedence over GET_MASTER_PUBLIC_KEY
#
# The MASTER_HEARTBEAT_PERIOD, MASTER_CONNECT_RETRY and MASTER_RETRY_COUNT options
# control how the slave recognizes that the connection to the master has been
# lost and makes attempts to reconnect.
#
# 		) The slave_net_timeout system variable specifies the number of seconds that
# 			 the slave waits for either more data or a heartbeat signal from the master,
# 			before the slave considers the connection broken, aborts the read, and tries
# 			to reconnect.
#
# 			The default value is 60 seconds (one minute)
#
# 		) The heartbeat interval, which stops the connection timeout occurring in the
# 			absence of data if the connection is still good, is controlled by the 
# 			MASTER_HEARTBEAT_PERIOD option.
#
# 			A heartbeat signal is sent to the slave after that number of seconds, and the
# 			waiting period is reset whenever the master's binary log is updated
# 			with an event.
#
# 			Heartbeats are therefore sent by the master only if there are no unset events
# 			in the binary log file for a period longer than this.
#
# 			The heartbeat interval interval is a decimal value having the range 0 to 4294967
# 			seconds and a resolution in milliseconds; the smallest nonzero value is 0.001
#
# 			Setting interval to 0 disables heartbeats altogether.
#
# 			The heartbeat interval defaults to half the value of the slave_net_timeout
# 			system variable.
#
# 			It is recorded in the master info log and shown in the replication_connection_configuration
# 			Performance Schema table.
#
# 			Issuing RESET_SLAVE resets the heartbeat interval to the default value.
#
# 			Note that a change to the value or default setting of slave_net_timeout does not
# 			automatically change the heartbeat interval, whether that has been set
# 			explicitly or is using a previously calculated default.
#
# 			A warning is issued if you set @@GLOBAL.slave_net_timeout to a value less than
# 			that of the current heartbeat interval.
#
# 			If slave_net_timeout is changed, you must also issue CHANGE_MASTER_TO to adjust
# 			the heartbeat interval to an appropriate value so that the heartbeat signal occurs before
# 			the connection timeout.
#
# 			If you do not do this, the heartbeat signal has no effect, and if no data is received
# 			from the master, the slave can make repeated reconnection attempts, creating zombie
# 			dump threads.
#
# 		) If the slave does need to reconnect, the first retry occurs immediately after the timeout.
#
# 			MASTER_CONNECT_RETRY specifies the interval between reconnection attempts, and MASTER_RETRY_COUNT
# 			limits the number of reconnection attempts.
#
# 			If both the default settings are used, the slave waits 60 seconds between reconnection attempts
# 			(MASTER_CONNECT_RETRY=60), and keeps attempting to reconnect at this rate for 24 hours
# 			(MASTER_RETRY_COUNT=86400)
#
# 			These values are recorded in the master info log and shown in the replication_connection_configuration
# 			Performance Schema table.
#
# 			MASTER_RETRY_COUNT supersedes the --master-retry-count server startup option.
#
# MASTER_DELAY specifies how many seconds behind the master the slave must lag.
#
# An event received from the master is not executed until at least interval seconds later
# than its execution on the master.
#
# The default is 0.
#
# An error occurs if interval is not a nonnegative integer in teh range from 0 to 2^31-1
#
# For more information, see SECTION 17.3.12, "DELAYED REPLICATION"
#
# A CHANGE MASER TO statement employing the MASTER_DELAY option can be executed on a running
# slave when the slave SQL thread is stopped.
#
# MASTER_BIND is for use on replication slaves having multiple network interfaces, and determines
# which of the slave's network interfaces is chosen for connecting to the master.
#
# The address configured with this option, if any, can be seen in the Master_Bind column
# of the output from SHOW_SLAVE_STATUS
#
# In the master info repository table mysql.slave_master_info, the value can be seen
# as the Master_bind column.
#
# The ability to bind a replicaiton slave to a specific network interface is also supported
# by NDB Cluster.
#
# MASTER_lOG_FILE and MASTER_LOG_POS are the coordinates at which the slave I/O thread should
# begin reading from the master the next time the thread starts.
#
# RELAY_LOG_FILE and RELAY_LOG_POS are the coordinates at which the slave SQL thread should
# begin reading from teh relay log the next time the thread starts.
#
# If you specify either of MASTER_LOG_FILE or MASTER_LOG_POS, you cannot specify RELAY_LOG_FILE
# or RELAY_LOG_POS
#
# If you specify either of MASTER_LOG_FILE or MASTER_LOG_POS, you also cannot specify MASTER_AUTO_POSITION = 1
# (described later in this section)
#
# If neither of MASTER_LOG_FILE or MASTER_LOG_POS is specified, the slave uses the last coordinates
# of the slave SQL thread before CHANGE_MASTER_TO was issued.
#
# This ensures that there is no discontinuity in replication, even if the slave SQL thread was
# late compared to the slave I/O thread, when you merely want to change, say, the PW.
#
# A CHANGE MASTER TO statement employing RELAY_LOG_FILE, RELAY_LOG_POS or both options
# can be executed on a running slave when the slave SQL thread is stopped.
#
# Relay logs are preserved if at least one of the slave SQL thread and the slave I/O
# thread is running; if both threads are stopped, all relay log files are deleted
# unless at least one of RELAY_LOG_FILE or RELAY_LOG_POS is specified.
#
# RELAY_LOG_FILE can use either an absolute or relative path, and uses teh same base name
# as MASTER_LOG_FILE
#
# When MASTER_AUTO_POSITION = 1 is used with CHANGE MASTER TO, the slave attempts to connect
# to the master using the GTID-based replication protocol.
#
# This option can be used with CHANGE MASTER TO only if both the slave SQL and slave I/O
# threads are stopped.
#
# Both the slave and the master must have GTIDs enabled (GTID MODE=ON, ON_PERMISSIVE or OFF_PERMISSIVE
# on the slave, and GTID_MODE=ON on the master)
#
# Auto-positioning is used for the connection, so the coordinates represented by MASTER_LOG_FILE
# and MASTER_LOG_POS are not used, and the use of either or both of these options together with
# MASTER_AUTO_POSITION = 1 causes an error.
#
# If multi-source replication is enabled on the slave, you need to set the MASTER_AUTO_POSITION = 1
# option for each applicable replication channel.
#
# With MASTER_AUTO_POSITION = 1 set, in the initial connection handshake, the slave sends a 
# GTID set containing the transactions that it has already received, committed, or both.
#
# The master responds by sending all transactions recorded in its binary log whose GTID
# is not included in the GTID set sent by the slave.
#
# This exchange ensures that the master only sends the transactions with a GTID that the slave
# has not already recorded or committed.
#
# If the slave receives transactions from more than one master, as in the case of a 
# diamond topology, the auto-skip function ensures that the transactions are not applied twice.
#
# For details of how the GTID set sent by the slave is computed, see SECTION 17.1.3.3,
# "GTID AUTO-POSITIONING"
#
# If any of the transactions that should be sent by the master have been purged from the
# master's binary log, or added to the set of GTIDs in the gtid_purged system variable
# by another method, the master sends the error:
#
# 		ER_MASTER_HAS_PURGED_REQUIRED_GTIDS
#
# to the slave, and replication does not start.
#
# The GTIDs of the missing purged transactions are identified and listed in the master's
# error log in the warning message:
#
# 		ER_FOUND_MISSING_GTIDS
#
# Also, if during the exchange of transactions it is found that the slave has recorded
# or committed transactions with the master's UUID in the GTID, but the master itself
# has not committed them, the master sends the error:
#
# 		ER_SLAVE_HAS_MORE_GTIDS_THAN_MASTER
#
# to the slave and replication does not start.
#
# For information on how to handle these situations, see SECTION 17.1.3.3,
# "GTID AUTO-POSITIONING"
#
# You can see whether replication is running with auto-positoning enabled
# by checking the Performance Schema replication_connection_status table
# or the output of SHOW_SLAVE_STATUS
#
# Disabling the MASTER_AUTO_POSITION option again makes the slave revert
# to file-based replication, in which case you must also specify one or both
# of the MASTER_LOG_FILE or MASTER_LOG_POS options.
#
# IGNORE_SERVER_IDS takes a comma-separated list of 0 or more server IDs.
#
# Events originating from the corresponding servers are ignored, with the 
# exception of log rotation and deletion events, which are still recorded
# in the relay log.
#
# In circular replication, the originating server normally acts as the terminator
# of its own events, so that they are not applied more than once.
#
# Thus, this option is useful in circular replication when one of the servers
# in the circle is removed.
#
# Suppose that you have a circular replication setup with 4 servers,
# having server IDs 1, 2, 3 and 4 and server 3 fails.
#
# When bridging the gap by starting replication from server 2 to server
# 4, you can include IGNORE_SERVER_IDS = (3) in the CHANGE_MASTER_TO
# statement that you issue on server 4 to tell it to use server 2 as its
# master instead of server 3.
#
# Doing so causes it to ignore and not to propagate any statements
# that originated with the server that is no longer in use.
#
# if IGNORE_SERVER_IDS contains the server's own ID and the server was
# started with the --replicate-same-server-id option enabled, an error results.
#
# NOTE:
#
# 		When global transaction identifiers (GTIDs) are used for replication,
# 		transactions that have already been applied are automatically ignored,
# 		so the IGNORE_SERVER_IDS function is not required and is deprecated.
#
# 		If gtid_mode=ON is set for the server, a deprecation warning is issued
# 		if you include the IGNORE_SERVER_IDS option in a CHANGE_MASTER_TO 
# 		statement.
#
# The master info repository and the output of SHOW_SLAVE_STATUS provide the list
# of servers that are currently ignored.
#
# For more information, see SECTION 17.2.4.2, "SLAVE STATUS lOGS" and
# SECTION 13.7.6.34, "SHOW SLAVE STATUS SYNTAX"
#
# If a CHANGE_MASTER_TO statement is issued without any IGNORE_SERVER_IDS
# option, any existing list is preserved.
#
# To clear the list of ignored servers, it is necessary to use the option
# with an empty list:
#
# 		CHANGE MASTER TO IGNORE_SERVER_IDS = ();
#
# RESET SLAVE ALL clears IGNORE_SERVER_IDS
#
# NOTE:
#
# 		A deprecation warning is issued if SET GTID_MODE=ON is issued
# 		when any channel has existing server IDs set with IGNORE_SERVER_IDS
#
# 		Before starting GTID-based replication, check for and clear all ignored
# 		server ID lists on the servers involved.
#
# 		The SHOW_SLAVE_STATUS statement displays the list of ignore IDs,
# 		if there is one.
#
# 		If you do receive the deprecation warning, you can still clear a 
# 		list after gtid_mode=ON is set by issuing a CHANGE_MASTER_TO statement
# 		containing the IGNORE_SERVER_IDS option with an empty list.
#
# Invoking CHANGE_MASTER_TO causes the previous values for MASTER_HOST, MASTER_PORT,
# MASTER_LOG_FILE and MASTER_LOG_POS to be written to the error log, along with
# other information about the slave's state prior to execution.
#
# CHANGE MASTER TO causes an implicit commit of an ongoing transaction.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# From MySQL 5.7, the strict requirements to execute STOP_SLAVE prior to issuing
# any CHANGE_MASTER_TO statement (and START_SLAVE afterward) is removed.
#
# Instead of depending on whether the slave is stopped, the behavior of CHANGE MASTER TO
# depends on the states of the slave SQL thread and slave I/O threads; which of these
# threads is stopped or running now determines the options that can or cannot be used
# with a CHANGE MASTER TO statement at a given point in time.
#
# The rules for making this determinaiton are listed here:
#
# 		) If hte SQL thread is stopped, you can execute CHANGE MASTER TO using
# 			any combination that is otherwise allowed of RELAY_LOG_FILE, RELAY_LOG_POS,
# 			and MASTER_DELAY options, even if the slave I/O thread is running.
#
# 			No other options may be used with this statement when the I/O thread
# 			is running.
#
# 		) If the I/O thread is stopped, you can execute CHANGE MASTER TO using any
# 			of the options for this statement (in any allowed combination) except:
#
# 				RELAY_LOG_FILE
#
# 				RELAY_LOG_POS
#
# 				MASTER_DELAY
#
# 			even when the SQL thread is running.
#
# 			These three options may not be used when the I/O thread is running.
#
# 		) Both the SQL thread and the I/O thread must be stopped before issuing a 
# 			CHANGE MASTER TO statement that employs MASTER_AUTO_POSITION = 1
#
# You can check the current state of the slave SQL and I/O threads using SHOW_SLAVE_STATUS
#
# For more information, see SECTION 17.3.8, "SWITCHING MASTERS DURING FAILOVER"
#
# If you are using statement-based replication and temporary tables, it is possible
# for a CHANGE MASTER TO statement following a STOP SLAVE statement to leave behind
# temporary tables on the slave.
#
# A warning (ER_WARN_OPEN_TEMP_TABLES_MUST_BE_ZERO) is now issued whenever this occurs.
#
# You can avoid this in such cases by making sure that the value of the SLAVE_OPEN_TEMP_TABLES
# system status variable is equal to 0 prior to executing such a CHANGE MASTER TO statement.
#
# CHANGE_MASTER_TO is useful for setting up a slave when you have the snapshot of the master
# and have recorded the master binary log coordinates corresponding to the time of hte
# snapshot.
#
# After loading the snapshot into the slave to synchronize it with the master, you can run
# CHANGE MASTER TO MASTER_LOG_FILE='log_name', MASTER_LOG_POS=log_pos on the slave to specify
# the coordinates at which the slave should begin reading the master binary log.
#
# The following example changes the master server the slave uses and establishes the master
# binary log coordinates from which the slave begins reading.
#
# This is used when you want to set up the slave to replicate the master:
#
# 		CHANGE MASTER TO
# 			MASTER_HOST='master2.example.com',
# 			MASTER_USER='replication',
# 			MASTER_PASSWORD='password',
# 			MASTER_PORT=3306,
# 			MASTER_LOG_FILE='master2-bin.001',
# 			MASTER_LOG_POS=4,
# 			MASTER_CONNECT_RETRY=10;
#
# The next example shows an operation that is less frequently employed.
#
# It is used when the slave has relay log files that you want it to execute
# again for some reason.
#
# To do this, the master need not be reachable.
#
# You need only use CHANGE_MASTER_TO and start the SQL thread (START SLAVE SQL_THREAD):
#
# 		CHANGE MASTER TO
# 			RELAY_LOG_FILE='slave-relay-bin.006',
# 			RELAY_LOG_POS=4025;
#
# The following table shows the maximum permissible length for hte string-valued options.
#
# OPTION 			MAX LENGTH
# 
# MASTER_HOST 			60
# 					
# MASTER_USER 			96
#
# MASTER_PASSWORD 	32
#
# MASTER_LOG_FILE 	511
#
# RELAY_LOG_FILE 		511
#
# MASTER_SSL_CA 		511
#
# MASTER_SSL_CAPATH 	511
#
# MASTER_SSL_CERT 	511
#
# MASTER_SSL_CRL 		511
#
# MASTER_SSL_CRLPATH 511
#
# MASTER_SSL_KEY 		511
#
# MASTER_SSL_CIPHER 	511
#
# MASTER_TLS_VERSION 511
#
# MASTER_PUBLIC_KEY_PATH 511
#
# 13.4.2.2 CHANGE REPLICATION FILTER SYNTAX
#
# CHANGE REPLICATION FILTER filter[, filter]
# 		[, ---] [FOR CHANNEL channel]
#
# filter:
# 		REPLICATE_DO_DB = (db_list)
#   | REPLICATE_IGNORE_DB = (db_list)
#   | REPLICATE_DO_TABLE = (tbl_list)
#   | REPLICATE_IGNORE_TABLE = (tbl_list)
#   | REPLICATE_WILD_DO_TABLE = (wild_tbl_list)
# 	 | REPLICATE_WILD_IGNORE_TABLE = (wild_tbl_list)
#   | REPLICATE_REWRITE_DB = (db_pair_list)
#
# db_list:
# 		db_name[, db_name][, ---]
#
# tbl_list:
# 		db_name.table_name[, db_name.table_name[, ---]
# wild_tbl_list:
# 		'db_pattern.table_pattern'[, 'db_pattern.table_pattern'][, ---]
#
# db_pair_list:
# 		(db_pair)[, (db_pair)][, ---]
#
# db_pair:
# 		from_db, to_db
#
# CHANGE REPLICATION FILTER sets one or more replicaiton filtering rules on the
# slave in teh same way as starting the slave mysqld with replication filtering
# options such as:
#
# 		--replicate-do-db
#
# 		or
#
# 		--replicate-wild-ignore-table
#
# Unlike the case with the server options, this statement does not require
# restarting the server to take effect, only that the slave SQL thread
# be stopped using STOP_SLAVE_SQL_THREAD first (and restarted with START_SLAVE_SQL_THREAD afterwards).
#
# CHANGE_REPLICATION_FILTER requires the REPLICATION_SLAVE_ADMIN or SUPER privilege
#
# Use the FOR CHANNEL channel clause to make a replicaiton filter specific to a replication
# channel, for example on a multi-source replication slave.
#
# Filters applied without a specific FOR CHANNEL clause are considered global filters,
# meaning that they are applied to all replication channels.
#
# 	NOTE:
#
# 		Global replication filters cannot be set on a MySQL server instance that is configured
# 		for Group Replication, because filtering transactions on some servers would make the group
# 		unable to reach agreement on a consistent state.
#
# 		Channel specific replication filters can be set on replication channels that are not
# 		directly involved with Group Replication, such as where a group member also acts
# 		as a replication slave to a master that is outside the group.
#
# 		They cannot be set on the group_replication_applier or group_replication_recovery channels
#
# The following list shows the CHANGE REPLICATION FILTER options and how they relate to 
# --replicate-* server options:
#
# 		) REPLICATE_DO_DB: Include updates based on database name. Equivalent to --replicate-do-db
#
# 		) REPLICATE_IGNORE_DB: Exclude updates based on database name. Equivalent to --replicate-ignore-db
#
# 		) REPLICATE_DO_TABLE: Include updates based on table name. Equivalent to --replicate-do-table
#
# 		) REPLICATE_IGNORE_TABLE: Exclude updates based on table name. Equivalent to --replicate-ignore-table
#
# 		) REPLICATE_WILD_DO_TABLE: Include updates based on wildcard pattern matching table name. Equivalent to --replicate-wild-do-table
#
# 		) REPLICATE_WILD_IGNORE_TABLE: Exclude updates based on wildcard pattern matching table name. Equivalent to --replicate-wild-ignore-table
#
# 		) REPLICATE_REWRITE_DB: Perform updates on slave after substituting new name on slave for specified database on master.
#
# 											Equivalent to --replicate-rewrite-db
#
# The precise effects of REPLICATE_DO_DB and REPLICATE_IGNORE_DB filters are dependent on whether statement-based
# or row-based replication is in effect.
#
# See SECTION 17.2.5, "HOW SERVERS EVALUATE REPLICATION FILTERING RULES", for more information.
#
# Multiple replication filtering rules can be created in a single CHANGE REPLICATION FILTER statement
# by separating the rules with commas, as shown here:
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_DO_DB = (d1), REPLICATE_IGNORE_DB = (d2);
#
# Issuing the statement just shown is equivalent to starting the slave mysqld with the options
# --replicate-do-db=d1 --replicate-ignore-db=d2
#
# On a multi-score replicaiton slave, which uses multiple replicaiton channels to process transaction
# from different sources, use the FOR CHANNEL channel clause to set a replication filter on
# a replication channel:
#
# 		CHANGE REPLICATION FILTER REPLICATE_DO_DB = (d1) FOR CHANNEL channel_1;
#
# This enables you to create a channel specific replication filter to filter out selected
# data from a source.
#
# When a FOR CHANNEL clause is provided, the replication filter statement acts
# on that slave replication channel removing any existing replication filter which
# has the same filter type as the specified replication filters, and replacing them
# with the specified filter.
#
# Filter types not explicitly listed in the statement are not modified
#
# If issued against a slave replication channel which is not configured,
# the statement fails with an ER_SLAVE_CONFIGURATION error
#
# If issued against Group Replication channels, the statement fails with an
# ER_SLAVE_CHANNEL_OPERATION_NOT_ALLOWED error
#
# On a replication slave with multiple replicaiton channels configured, issuing
# CHANGE_REPLICATION_FILTER with no FOR CHANNEL clause configures the replication
# filter for every configured slave replication channel, and for the global replication filters.
#
# For every filter type, if the filter type is listed in the statement, then any existing
# filter rules of that type are replaced by the filter rules specified in the most recently
# issued statement, otherwise the old value of the filter type is retained.
#
# For more information see SECTION 17.2.5.4, "REPLICATION CHANNEL BASED FILTERS"
#
# If the same filtering rule is specified multiple times, only the last such rule
# is actually used.
#
# For example, the two statements shown here have exactly the same effect,
# because the first REPLICATE_DO_DB rule in the first statement is ignored:
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_DO_DB = (db1, db2), REPLICATE_DO_DB = (db3, db4);
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_DO_DB = (db3, db4);
#
# CAUTION:
#
# 		This behavior differs from that of the --replicate-* filter options
# 		where specifying the same option multiple times causes the
# 		creation of multiple filter rules.
#
# Names of tables and database not containing any special characters need
# not be quoted.
#
# Values used with REPLICATION_WILD_TABLE and REPLICATION_WILD_IGNORE_TABLE
# are string expressions, possibly containing (special) wildard characters,
# and so must be quoted.
#
# This is shown in the following example statements:
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_WILD_DO_TABLE = ('db1.old%');
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_WILD_IGNORE_TABLE = ('db1.new%', 'db2.new%');
#
# Values used with REPLICATE_REWRITE_DB represents pairs of database names;
#
# Each such value must be enclosed in parentheses.
#
# The following statement rewrites statements occurring on database db1
# on the master to database db2 on the slave:
#
# 		CHANGE REPLICATION FILTER REPLICATE_REWRITE_DB = ((db1, db2));
#
# The statement just shown contains two sets of parentheses, one enclosing the pair
# of database names, and the other enclosing the entire list.
#
# This is perhaps more easily seen in the following example, which creates two
# rewrite-db rules, one rewriting database dbA to dbB, and one rewriting database dbC to dbD:
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_REWRITE_DB = ((dbA, dbB), (dbC, dbD));
#
# The CHANGE_REPLICATION_FILTER statement replaces replication filtering rules only
# for the filter types and replication channels affected by the statement, and leaves
# other rules and channels unchanged.
#
# If you want to unset all filters of a given type, set the filter's value to an
# explicitly empty list, as shown in this example, which removes all existing
# REPLICATE_DO_DB and REPLICATE_IGNORE_DB rules:
#
# 		CHANGE REPLICATION FILTER
# 			REPLICATE_DO_DB = (), REPLICATE_IGNORE_DB = ();
#
# Setting a filter to empty in this way removes all existing rules, does not create
# any new ones, and does not restore any rules set at mysqld startup using --replicate-*
# options on the command line or in the configuration file.
#
# The RESET_SLAVE_ALL statement removes channel specific replication filters that were
# set on channels deleted by the statement.
#
# When the deleted channel or channels are recreated, any global replication filters
# specified for the slave are copied to them, and no channel specific replication
# filters are applied.
#
# For more information, see SECTION 17.2.5, "HOW SERVERS EVALUATE REPLICATION FILTERING RULES"
#
# 13.4.2.3 MASTER_POS_WAIT() SYNTAX
#
# 		SELECT MASTER_POS_WAIT('master_log_file', master_log_pos [, timeout][, channel])
#
# This is actually a function, not a statement.
#
# It is used to ensure that the slave has read and executed events up to a given position
# in the master's binary log.
#
# See SECTION 12.23, "MISCELLANEOUS FUNCTIONS", for a full description.
#
# 13.4.2.4 RESET SLAVE SYNTAX
#
# 		RESET SLAVE [ALL] [channel_option]
#
# 		channel_option:
# 			FOR CHANNEL channel
#
# RESET_SLAVE makes the slave forget its replication channel position in the master's binary log.
#
# This statement is meant to be used for a clean start:
#
# 		it clears the master info and relay log info repositories, deletes all the relay
# 		log files, and starts a new relay log file.
#
# It also resets to 0 the applicaiton delay specified with the MASTER_DELAY option to
# CHANGE MASTER TO RESET_SLAVE does not change the values of gtid_executed or gtid_purged.
#
# NOTE:
#
# 		All relay log files are deleted, even if they have not been completely executed by the
# 		slave SQL thread.
#
# 		(This is a condition likely to exist on a replication slave if you have issued
# 		a STOP_SLAVE statement or if hte slave is highly loaded)
#
# To use RESET_SLAVE, the slave replication threads must be stopped, so on a running slave
# use STOP_SLAVE before issuing RESET_SLAVE
#
# To use RESET_SLAVE on a Group Replication group member, the member status must be 
# OFFLINE, meaning that the plugin is loaded but the member does not currently belong
# to any group.
#
# A group member can be taken offline by using a STOP_GROUP_REPLICATION statement.
#
# The optional FOR CHANNEL channel clause enables you to name which replication channel
# the statement applies to.
#
# Providing a FOR CHANNEL channel clause applies the RESET SLAVE statement to a specific
# replication channel.
#
# Combining a FOR CHANNEL channel clause with the ALL option deletes the specified
# channel.
#
# If no channel is named and no extra channels exist, the statement applies to the
# default channel.
#
# Issuing a RESET_SLAVE_ALL statement without a FOR CHANNEL channel clause when
# multiple replication channels exist deletes all replication channels and recreates
# only the default channel.
#
# See SECTION 17.2.3, "REPLICATION CHANNELS" for more information.
#
# RESET_SLAVE does not change any replication connection parameters such as
# master host, master port, master user or master password.
#
# 		) From MySQL 8.0.13, when master_info_repository=TABLE is set on the server
# 			(which is the default from MySQL 8.0), replication connection parameters
# 			are preserved in the crash-safe InnoDB table mysql.slave_master_info as
# 			part of the RESET_SLAVE operation.
#
# 			They are also retained in memory.
#
# 			In the event of a server crash or deliberate restart after issuing
# 			RESET_SLAVE but before issuing START_SLAVE, the replication connection
# 			parameters are retrieved from the table and reused for the new connection.
#
# 		) When master_info_repository=FILE is set on the server, replication connection
# 			parameters are only retained in memory.
#
# 			If the slave mysqld is restarted immediately after issuing RESET_SLAVE due
# 			to a server crash or deliberate restart, the connection parameters are lost.
#
# 			In that case, you must issue a CHANGE_MASTER_TO statement after the server
# 			start to respecify the connection parameters before issuing START_SLAVE
#
# If you want to reset the connection parameters intentionally, you need to use RESET_SLAVE_ALL,
# which clears the connection parameters.
#
# In that case, you must issue a CHANGE_MASTER_TO statement after the server start to
# specify the new connection parameters.
#
# RESET SLAVE ALL clears the IGNORE_SERVER_IDS list set by CHANGE_MASTER_TO
#
# RESET_SLAVE does not change any replication filter settings (such as --replicate-ignore-table)
# for channels affected by the statement.
#
# However, RESET SLAVE ALL removes the replication filters that were set on the channels
# deleted by the statement.
#
# When the deleted channel or channels are recreated, any global replication filters
# specified for the slave are copied to them, and no channel specific replication filters
# are applied.
#
# For more information, see SECTION 17.2.5.4, "REPLICATION CHANNEL BASED FILTERS"
#
# RESET SLAVE causes an implicit commit of an ongoing transaction.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# If the slave SQL thread was in the middle of replicating temporary tables when it was
# stopped, and RESET_SLAVE is issued, these replicated temporary tables are deleted on
# the slave.
#
# RESET SLAVE does not reset the heartbeat period (Slave_heartbeat_period) or SSL_VERIFY_SERVER_CERT
#
# NOTE:
#
# 		When used on an NDB Cluster replication slave SQL node, RESET SLAVE clears the mysql.ndb_apply_status
# 		table.
#
# 		You should keep in mind when using this statement that ndb_apply_status uses the NDB storage engine
# 		and so is shared by all SQL nodes attached to the slave cluster.
#
# 		You can override this behavior by issuing SET GLOBAL @@ndb_clear_apply_status=OFF prior to executing
# 		RESET SLAVE, which keeps the slave from purging the ndb_apply_status table in such cases.
#
# 13.4.2.5 SET GLOBAL SQL_SLAVE_SKIP_COUNTER_SYNTAX
#
# 		SET GLOBAL sql_slave_skip_counter = N
#
# This statement skips the next N events from the master.
#
# This is useful for recovering from replication stops caused by a statement.
#
# When using this statement, it is important to understand that the binary log is actually
# organized as a sequence of groups known as event groups.
#
# Each event group consists of a sequence of events.
#
# 		) For transactional tables, an event group corresponds to a transaction
#
# 		) For nontransactional tables, an event group corresponds to a single SQL statement
#
# NOTE:
#
# 		A single transaction can contain changes to both transactional and nontransactional tables
#
# When you use SET_GLOBAL_sql_slave_skip_counter to skip events and the result is in the middle
# of a group, the slave continues to skip events until it reaches the end of the group.
#
# Execution then starts with the next event group
#
# 13.4.2.6 START SLAVE SYNTAX
#
# 		START SLAVE [thread_types] [until_option] [connection_options] [channel_option]
#
# 		thread_types:
# 			[thread_type [, thread_type] ---]
#
# 		thread_type:
# 			IO_THREAD | SQL_THREAD
#
# 		until_option:
# 			UNTIL { 	{SQL_BEFORE_GTIDS | SQL_AFTER_GTIDS} = gtid_set
# 					|  MASTER_LOG_FILE = 'log_name', MASTER_LOG_POS = log_pos
# 					|  RELAY_LOG_FILE = 'log_name', RELAY_LOG_POS = log_pos
# 					|  SQL_AFTER_MTS_GAPS }
#
# 		connection_options:
# 			[USER='user_name'] [PASSWORD='user_pass'] [DEFAULT_AUTH='plugin_name'] [PLUGIN_DIR='plugin_dir']
#
# 		channel_option:
# 			FOR CHANNEL channel
#
# 		gtid_set:
# 			uuid_set [, uuid_set] ---
# 			| ''
#
# 		uuid_set:
# 			uuid:interval[:interval]---
#
# 		uuid:
# 			hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhh
#
# 		h:
# 			[0-9,A-F]
#
# 		interval:
# 			n[-n]
# 		
# 			(n >= 1)
#
# START_SLAVE with no thread_type options starts both of the slave threads.
#
# The I/O thread reads events from the master server and stores them in the relay
# log.
#
# The SQL thread reads events from the relay log and executes them.
#
# START_SLAVE requires the REPLICATION_SLAVE_ADMIN or SUPER privilege.
#
# If START_SLAVE succeeds in starting the slave threads, it returns without any
# error.
#
# However, even in that case, it might be that the slave threads start and then
# later stop (for example, because they do not manage to connect to the master or read its
# binary log, or some other problem)
#
# START_SLAVE does not warn you about this.
#
# You must check the slave's error log for error messages generated by the slave threads,
# or check that they are running satisfactorally with SHOW_SLAVE_STATUS
#
# START SLAVE causes an implicit commit of an ongoing transaction.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# gtid_next must be set to AUTOMATIC before issuing this statement.
#
# The optional FOR CHANNEL channel clause enables you to name which replication
# channel the statement applies to.
#
# Providing a FOR CHANNEL channel clause applies the START SLAVE statement to a 
# specific replication channel.
#
# If no clause is named and no extra channels exist, the statement applies to the
# default channel.
#
# If a START SLAVE statement does not have a channel defined when using multiple
# channels, this statement starts the specified threads for all channels.
#
# This statement is disallowed for the group_replication_recovery channel
#
# See SECTION 17.2.3, "REPLICATION CHANNELS" for more information
#
# MySQL supports pluggable user-password authentication with START SLAVE
# with the USER, PASSWORD, DEFAULT_AUTH and PLUGIN_DIR options, as described
# in the following list:
#
# 		) USER: User name. Cannot be set to an empty or null string, or left unset if PASSWORD is used
#
# 		) PASSWORD: Password
#
# 		) DEFAULT_AUTH: Name of plugin; default is MySQL native authentication
#
# 		) PLUGIN_DIR: Location of plugin
#
# You cannot use the SQL_THREAD option when specifying any of USER, PASSWORD,
# DEFAULT_AUTH or PLUGIN_DIR, unless the IO_THREAD option is also provided.
#
# See SECTION 6.3.10, "PLUGGABLE AUTHENTICATION" for more information
#
# If an insecure connection is used with any of these options, the server issues the warning:
#
# 		SENDING PASSWORDS IN PLAIN TEXT WITHOUT SSL/TLS IS EXTREMELY INSECURE
#
# START_SLAVE_---_UNTIL supports two additional options for use with global transaction
# identifiers (GTIDs) (see SECTION 17.1.3, "REPLICATION WITH GLOBAL TRANSACTION IDENTIFIERS")
#
# Each of these takes a set of one or more global transaction identifiers gtid_set
# as an argument (see GTID Sets, for more information)
#
# When no thread_type is specified, START SLAVE UNTIL SQL_BEFORE_GTIDS causes the slave
# SQL thread to process transactions until it has reached the first transaction whose
# GTID is listed in the gtid_set.
#
# START SLAVE UNTIL SQL_AFTER_GTIDS causes the slave threads to process all transactions
# until the last transaction in the gtid_set has been processed by both threads.
#
# In other words, START SLAVE UNTIL SQL_BEFORE_GTIDS causes the slave SQL thread to process
# all transactions occurring before the first GTID in the gtid_set is reached, and 
# START SLAVE UNTIL SQL_AFTER_GTIDS causes the slave threads to handle all transactions,
# including those whose GTIDs are found in gtid_set, until each has encountered a transaction
# whose GTID is not part of the set.
#
# SQL_BEFORE_GTIDS and SQL_AFTER_GTIDS each support the SQL_THREAD and IO_THREAD options,
# although using IO_THREAD with them currently has no effect.
#
# For example, START SLAVE SQL THREAD UNTIL SQL_BEFORE_GTIDS = <value> causes the salve
# SQL thread to process all transactions originating from the master whose server_uuid is
# <value> until it encounters the transaction having <sequence number>.
#
# It then stops without processing this transaction.
#
# In other words, all transactions up to and including the transaction with sequence
# number 10 are processed.
#
# Executing START SLAVE SQL_THREAD UNTIL SQL_AFTER_GTIDS = <Value>:<range>
#
# on the other hand, would cause the salve SQL thread to obtain all transactions just
# mentioned from the master, including all of the transactions having the sequence
# numbers of the range - and then stop without processing any additional transactions;
#
# that is, the transaction having sequence number equal to the last one in the range,
# would be the last transaction fetched by the slave SQL thread.
#
# When using a multithreaded slave with slave_preserve_commit_order=0 set, there is a 
# chance of gaps in the sequence of transactions that have been executed from the
# relay log in the following cases:
#
# 		) Killing the coordinator thread
#
# 		) After an error occurs in the applier threads
#
# 		) mysqld shuts down unexpectedly
#
# Use the START_SLAVE_UNTIL_SQL_AFTER_MTS_GAPS statement to cause a multithreaded
# slave's worker threads to only run until no more gaps are found in the relay log,
# and then to stop.
#
# This statement can take an SQL_THREAD option, but the effects of the statement
# remain unchanged.
#
# It has no effect on the slave I/O thread (and cannot be used with the IO_THREAD option)
#
# Issuing START_SLAVE on a multithreaded slave with gaps in the sequence of transactions
# executed from the relay log generates a warning.
#
# In such a situation, the solution is to use START_SLAVE_UNTIL_SQL_AFTER_MTS_GAPS,
# then issue RESET_SLAVE to remove any remaining relay logs.
#
# See SECTION 17.4.1.34, "REPLICATION AND TRANSACTION INCONSISTENCIES" for more information.
#
# To change a failed multithreaded slave to single-threaded mode, you can issue the following
# series of statements, in the order shown:
#
# 		START SLAVE UNTIL SQL_AFTER_MTS_GAPS;
#
# 		SET @@GLOBAL.slave_parallel_workers = 0;
#
# 		START SLAVE SQL_THREAD;
#
# NOTE:
#
# 		It is possible to view the entire text of a running START SLAVE --- statement,
# 		including any USER or PASSWORD values used, in the output of SHOW PROCESSLIST.
#
# 		This is also true for the text of a running CHANGE_MASTER_TO statement, including
# 		any values it employs for MASTER_USER or MASTER_PASSWORD
#
# START_SLAVE sends an acknowledgement to the user after both the I/O thread and the SQL
# thread have started.
#
# However, the I/O thread may not yet have connected.
#
# For this reason, a successful START_SLAVE causes SHOW_SLAVE_STATUS to show Slave_SQL_Running=Yes,
# but it does not guarantee that Slave_IO_Running=Yes (because Slave_IO_Running=Yes only if the
# I/O thread is running and connected)
#
# For more information, see SECTION 13.7.6.34, "SHOW SLAVE STATUS SYNTAX", and SECTION 17.1.7.1, "CHECKING REPLICATION STATUS"
#
# You can add IO_THREAD and SQL_THREAD options to the statement to name which of the threads to start.
#
# The SQL_THREAD option is disallowed when specifying any of USER, PASSWORD, DEFAULT_AUTH or
# PLUGIN_DIR, unless the IO_THREAD option is also provided.
#
# An UNTIL clause (until_option, in the preceding grammar) may be added to specify that the slave
# should start and run until the SQL thread reaches a given point in the master binary log,
# specified by the MASTER_LOG_POS and MASTER_LOG_FILE options, or a given point in the slave
# relay log, indicated with the RELAY_LOG_POS and RELAY_LOG_FILE options.
#
# When the SQL thread reaches the point specified, it stops.
#
# If the SQL_THREAD option is specified in the statement, it starts only the SQL thread
#
# Otherwise, it starts both slave threads.
#
# If the SQL thread is running, the UNTIL clause is ignored and a warning is issued.
#
# You cannot use an UNTIL clause with the IO_THREAD option
#
# It is also possible with START SLAVE UNTIL to specify a stop point relative to a given GTID
# or set of GTIDs using one of the options SQL_BEFORE_GTIDS or SQL_AFTER_GTIDS, as explained
# previously here.
#
# When using one of these options, you can specify SQL_THREAD, IO_THREAD - both of these -
# or neither of them.
#
# If you specify only SQL_THREAD, then only the slave SQL thread is affected by the statement;
#
# if only IO_THREAD is used, then only the slave I/O is affected
#
# If both SQL_THREAD and IO_THREAD are used, or if neither of them is used, then both the
# SQL and I/O threads are affected by the statement.
#
# For an UNTIL clause, you must specify any of the following:
#
# 		) Both a log file name and a position in that file
#
# 		) Either of SQL_BEFORE_GTIDS or SQL_AFTER_GTIDS
#
# 		) SQL_AFTER_MTS_GAPS
#
# Do not mix master and relay log options. Do not mix log file options with GTID options.
#
# The UNTIL clause is not supported for multithreaded slaves except when also using
# SQL_AFTER_MTS_GAPS
#
# If UNTIL is used on a multithreaded slave without SQL_AFTER_MTS_GAPS, the slave operates
# in single-threaded (sequential) mode for replication until the point specified by
# the UNTIL clause is reached.
#
# Any UNTIL condition is reset by a subsequent STOP_SLAVE statement, a START_SLAVE statement
# that includes no UNTIL clause, or a server restart.
#
# When specifying a log file and position, you can use the IO_THREAD option with START SLAVE --- UNTIL
# even though only the SQL thread is affected by this statement.
#
# The IO_THREAD option is ignored in such cases.
#
# The preceding restriction does not apply when using one of the GTID options
# (SQL_BEFORE_GTIDS and SQL_AFTER_GTIDS); the GTID options support both SQL_THREAD
# and IO_THREAD, as explained previously in this section.
#
# The UNTIL clause can be useful for debugging replication, or to cause replication
# to proceed until just before the point where you want to avoid having the slave
# replicate an event.
#
# For example, if an unwise DROP_TABLE statement was executed on the master, you acn
# use UNTIL to tell the slave to execute up to that point but no farther.
#
# To find what the event is, use mysqlbinlog with the master binary log or slave relay
# log, or by using a SHOW_BINLOG_EVENTS statement.
#
# If you are using UNTIL to have the slave process replicated queries in sections,
# it is recommended that you start the slave with the --skip-slave-start option to prevent
# the SQL thread from running when the slave server starts.
#
# It is probably best to use this option in an option file rather than on the
# command line, so that an unexpected server restart does not cause it to be forgotten.
#
# The SHOW_SLAVE_STATUS statement includes output fields that display the current values
# of the UNTIL condition.
#
# In very old versions of MySQL (before 4.0.5), this statement was called SLAVE START.
# That syntax now produces an error.
#
# 13.4.2.7 STOP SLAVE SYNTAX
#
# 		STOP SLAVE [thread_types]
#
# 		thread_types:
# 			[thread_type [, thread_type] ---]
#
# 		thread_type: IO_THREAD | SQL_THREAD
#
# 		channel_option:
# 			FOR CHANNEL channel
#
# Stops the slave threads.
#
# STOP_SLAVE requires the REPLICATION_SLAVE_ADMIN or SUPER privilege.
#
# Recommended best practice is to execute STOP SLAVE on the slave before
# stopping the slave server (see SECTION 5.1.17, "THE SERVER SHUTDOWN PROCESS", for more information)
#
# When using the row-based logging format:
#
# 	You should execute STOP SLAVE or STOP SLAVE SQL_THREAD on the slave prior to shutting down
# 	the slave server if you are replicating any tables that use a nontransactional storage engine
# 	(see the Note later in this section)
#
# Like START_SLAVE, this statement may be used with the IO_THREAD and SQL_THREAD options to
# name the thread or threads to be stopped.
#
# STOP SLAVE causes an implicit commit of an ongoing transaction.
#
# See SECTION 13.3.3, "STATEMENTS THAT CAUSE AN IMPLICIT COMMIT"
#
# gtid_next must be set to AUTOMATIC before issuing this statement.
#
# You can control how long STOP SLAVE waits before timing out by setting the rpl_stop_slave_timeout
# system variable.
#
# This can be used to avoid deadlocks between STOP SLAVE and other slave SQL statements using
# different client connections to the slave.
#
# When the timeout value is reached, the issuing client returns an error message and
# stops waiting, but the STOP SLAVE intstruction remains in effect.
#
# Once the slave threads are no longer busy, the STOP SLAVE statement is executed and 
# the slave stops.
#
# Some CHANGE MASTER TO statements are allowed while the slave is running, depending on
# the states of the slave SQL and I/O threads.
#
# However, using STOP SLAVE prior to executing CHANGE MASTER TO in such cases is still
# supported.
#
# See SECTION 13.4.2.1,"CHANGE MASTER TO SYNTAX", and SECTION 17.3.8, "SWITCHING MASTERS DURING FAILOVER",
# for more information.
#
# The optional FOR CHANNEL channel clause enables you to name which replication channel the statement
# applies to.
#
# Providing a FOR CHANNEL channel clause applies the STOP SLAVE statement to a specific replication
# channel.
#
# If no channel is named and no extra channels exist, the statement applies to the default channel.
#
# If a STOP SLAVE statement does not name a channel when using multiple channels, this statement stops the
# specified threads for all channels..
#
# This statement cannot be used with the group_replication_recovery channel.
#
# See SECTION 17.2.3, "REPLICATION CHANNELS" for more information.
#
# When using statement-based replication:
#
# 		changing the master while it has open temporary tables is potentially unsafe.
#
# 		This is one of the reasons why statement-based replication of temporary tables
# 		is not recommended.
#
# 		You can find out whether there are any temporary tables on the slave by checking
# 		the value of Slave_open_temp_tables; when using statement-based replication, this value
# 		should be 0 before executing CHANGE MASTER TO.
#
# If there are any temporary tables open on the slave, issuing a CHANGE MASTER TO statement
# after issuing a STOP SLAVE causes an ER_WARN_OPEN_TEMP_TABLES_MUST_BE_ZERO warning.
#
# When using a multithreaded slave (slave_parallel_workers is a nonzero value), any gaps in the
# sequence of transactions executed from the relay log are closed as part of stopping the
# worker threads.
#
# If the slave is stopped unexpectedly (for example due to an error in a worker thread,
# or another thread issuing KILL), while a STOP_SLAVE statement is executing, the sequence
# of executed transactions from the relay log may become inconsistent.
#
# See SECTION 17.4.1.34, "REPLICATION AND TRANSACTION INCONSISTENCIES" for more information.
#
# If the current replication event group has modified one or more nontransactional tables,
# STOP SLAVE waits for up to 60 seconds for the event grop to complete, unless you issue
# a KILL_QUERY or KILL_CONNECTION statement for the slave SQL thread.
#
# If the event group remains incomplete after the timeout, an error message is logged.
#
# 13.4.3 SQL STATEMENTS FOR CONTROLLING GROUP REPLICATION
#
# 13.4.3.1 START GROUP_REPLICATION SYNTAX
# 13.4.3.2 STOP GROUP_REPLICATION SYNTAX
#
# 13.4.3.3 FUNCTION WHICH CONFIGURES GROUP REPLICATION PRIMARY
# 13.4.3.4 FUNCTIONS WHICH CONFIGURE THE GROUP REPLICATION MODE
#
# 13.4.3.5 FUNCTIONS TO INSPECT AND CONFIGURE THE MAXIMUM CONSENSUS INSTANCES OF A GROUP
#
# This section provides information about the statements used for controlling group replication.
#
# 13.4.3.1 START GROUP_REPLICATION SYNTAX
#
# 		START GROUP_REPLICATION
#
# Starts group replication.
#
# This statement requires the GROUP_REPLICATION_ADMIN or SUPER privilege.
#
# If super_read_only=ON and the member should join as a primary, super_read_only
# is set to OFF once Group Replication successfully starts.
#
# 13.4.3.2 STOP GROUP_REPLICATION SYNTAX
#
# 		STOP GROUP_REPLICATION
#
# Stops Group Replication.
#
# This statement requires the GROUP_REPLICATION_ADMIN or SUPER privilege.
#
# As soon as you issue STOP_GROUP_REPLICATION the member is set to super_read_only=ON,
# which ensures that no writes can be made to the member while Group Replication stops.
#
# Any other replication channels running on the member are also stopped.
#
# 		WARNING:
#
# 			Use this statement with extreme caution because it removes the server
# 			instance from the group, meaning it is no longer protected by Group
# 			Replication's consistency guarantee mechanisms.
#
# 			To be completely safe, ensure that your applications can no longer
# 			connect to the instance before issuing this statement to avoid
# 			any chance of stale reads.
#
# 13.4.3.3 FUNCTION WHICH CONFIGURES GROUP REPLICATION PRIMARY
#
# The following funciton enables you to configure which member of a single-primary
# replication group is the primary.
#
# 		) group_replication_set_as_primary()
#
# 			Appoints a specific member of the group as the new primary,
# 			overriding any election process.
#
# 			Pass in member_uuid which is the server_uuid of the member that you
# 			want to become the new primary.
#
# 			Must be issued on a member of a replication group running in single-primary
# 			mode.
#
# 			Syntax:
#
# 				STRING group_replication_set_as_primary(member_uuid)
#
# 			Return value:
#
# 			A string containing the result of the operation, for example whether it was 
# 			successful or not.
#
# 			Example:
#
# 				SELECT group_replication_set_as_primary(member_uuid)
#
# 			For more information, see SECTION 18.4.2.1, "CHANGING A GROUP'S PRIMARY MEMBER"
#
# 13.4.3.4 FUNCTIONS WHICH CONFIGURE THE GROUP REPLICATION MODE
#
# The following functions enable you to control the mode which a replication group is running in,
# either single-primary or multi-primary mode.
#
# 		) group_replication_switch_to_single_primary_mode()
#
# 			Changes a group running in multi-primary mode to single-primary mode, without the need to stop
# 			Group Replication.
#
# 			Must be issued on a member of a replication group running in multi-primary mode.
#
# 			Syntax:
#
# 				STRING group_replication_switch_to_single_primary_mode([str])
#
# 			Arguments:
#
# 				str: A string containing the UUID of a member of the group which should become the
# 						new single primary.
#
# 						Other members of the group become secondaries.
#
# 			Return value:
#
# 			A string containing the result of the operation, for example whether it was successful or not.
#
# 			Example:
#
# 				SELECT group_replication_switch_to_single_primary_mode(member_uuid);
#
# 			For more information, see SECTION 18.4.2.2, "CHANGING A GROUP'S MODE"
#
# 		) group_replication_switch_to_multi_primary_mode()
#
# 			Changes a group running in single-primary mode to multi-primary mode.
#
# 			Must be issued on a member of a replication group running in single-primary mode.
#
# 			Syntax:
#
# 				STRING group_replication_switch_to_multi_primary_mode()
#
# 			This function has no parameters
#
# 			Return value:
#
# 			A string containing the result of the operation, for example whether it was successful or not.
#
# 			Example:
#
# 				SELECT group_replication_switch_to_multi_primary_mode()
#
# 			All members which belong to the group becomes primaries.
#
# 			For more information, see SECTION 18.4.2.2, "CHANGING A GROUP'S MODE"
#
# 13.4.3.5 FUNCTIONS TO INSPECT AND CONFIGURE THE MAXIMUM CONSENSUS INSTANCES OF A GROUP
#
# The following functions enable you to inspect and configure the maximum number of consensus
# instances that a group can execute in parallel.
#
# 		) group_replication_get_write_concurrency()
#
# 			Check the maximum number of consensus instances that a group can execute in parallel.
#
# 			Syntax:
#
# 				STRING group_replication_get_write_concurrency()
#
# 			This function has no parameters.
#
# 			Return value:
#
# 			Any resulting error as a string
#
# 			Example:
#
# 				SELECT group_replication_get_write_concurrency()
#
# 			For more information, see SECTION 18.4.2.3, "USING GROUP REPLICATION GROUP WRITE CONSENSUS"
#
# 		) group_replication_set_write_concurrency()
#
# 			Configures the maximum number of consensus instances that a group can execute in parallel.
#
# 			Syntax:
#
# 				STRING group_replication_set_write_concurrency(instances)
#
# 			Arguments:
#
# 				) members: Sets the maximum number of consensus instances that a group can execute
# 								in parallel.
#
# 								Default value is 10, valid values are integers in the range of 10 to 200
#
# 			Return value:
#
# 			Any resulting error as a string.
#
# 			Example:
#
# 				SELECT group_replication_set_write_concurrency(instances);
#
# 			For more information, see SECTION 18.4.2.3, "USING GROUP REPLICATION GROUP WRITE CONSENSUS"
#
# 13.5 PREPARED SQL STATEMENT SYNTAX
#
# 13.5.1 PREPARE SYNTAX
# 13.5.2 EXECUTE SYNTAX
# 13.5.3 DEALLOCATE PREPARE SYNTAX
#
# MySQL 8.0 provides support for server-side prepared statements.
#
# This support takes advantage of the efficient client/server binary protocol.
#
# Using prepared statements with placeholders for parameter values has the following benefits:
#
# 		) Less overhead for parsing the statement each time it is executed.
#
# 			Typically, database applications process large volumes of almost-identical
# 			statements, with only changes to literal or variables values in clauses such as
# 			WHERE for queries and deletes, SET for updates, and VALUES for inserts.
#
# 		) Protection against SQL injection attacks. The parameter values can contain unescaped
# 			SQL quote and delimiter characters.
#
# PREPARED STATEMENTS IN APPLICATION PROGRAMS
#
# You can use server-side prepared statements through client programming interfaces, including
# the MySQL C API CLIENT LIBRARY or MySQL CONNECTOR/C for C programs, MySQL Connector/J for
# java programs, and MySQL Connector/NET for programs using .NET tech.
#
# For example, the C API provides a set of function calls that make up its prepared statement
# API.
#
# See SECTION 28.7.8, "C API PREPARED STATEMENTS"
#
# Other language interfaces can provide support for prepared statements that use the binary
# protocol by linking in the C client library, one example being the mysqli extension, available
# in PHP 5.0 and later.
#
# PREPARED STATEMENTS IN SQL SCRIPTS
#
# An alternative SQL interface to prepared statements is available.
#
# This interface is not as efficient as using the binary protocol through a prepared
# statement API, but requires no programming because it is available directly at the SQL level:
#
# 		) You can use it when no programming interface is available to you
#
# 		) You can use it from any program that can send SQL statements to the server to be executed,
# 			such as the mysql client program.
#
# 		) You can use it even if the client is using an old version of the client library, as long
# 			as you connect to a server running MySQL 4.1 or higher
#
# SQL syntax for prepared statements is intended to be used for situations such as these:
#
# 		) To test how prepared statements work in your application before coding it
#
# 		) To use prepared statements when you do not have access to a programming API that supports them
#
# 		) To interactively troubleshoot application issues with prepared statements.
#
# 		) To create a test case that reproduces a problem with prepared statements, so that you can file a bug report
#
# PREPARE, EXECUTE, AND DEALLOCATE PREPARE STATEMENTS
#
# SQL syntax for prepared statements is based on three SQL statements:
#
# 		) PREPARE prepares a statement for execution (see SECTION 13.5.1, "PREPARE SYNTAX")
#
# 		) EXECUTE executes a prepared statement (see SECTION 13.5.2, "EXECUTE SYNTAX")
#
# 		) DEALLOCATE_PREPARE releases a prepared statement (see SECTION 13.5.3, "DEALLOCATE PREPARE SYNTAX")
#
# The following examples show two equivalent ways of preparing a statement that computes the 
# hypotenuse of a triangle given the lengths of the two sides.
#
# The first example shows how to create a prepared statement by using a string literal to supply
# the text of the statement:
#
# 		PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
# 		SET @a = 3;
# 		SET @b = 4;
# 		EXECUTE stmt1 USING @a, @b;
# 		+---------------------+
# 		| hypotenuse 		    |
# 		+---------------------+
# 		| 		 5 				 |
# 		+---------------------+
# 		DEALLOCATE PREPARE stmt1;
#
# The second example is similar, but supplies the text of the statement as a user variable:
#
# 		SET @s = 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
# 		PREPARE stmt2 FFROM @s;
# 		SET @a = 6;
# 		SET @b = 8;
# 		EXECUTE stmt2 USING @a, @b;
# 		+------------------+
# 		| hypotenuse 		 |
# 		+------------------+
# 		| 		10 			 |
# 		+------------------+
# 		DEALLOCATE PREPARE stmt2;
#
# Here is an additional example that demonstrates how to choose the table on which
# to perform a query at runtime, by storing the name of the table as a user variable:
#
# 		USE test;
# 		CREATE TABLE t1 (a INT NOT NULL);
# 		INSERT INTO t1 VALUES (4), (8), (11), (32), (80);
#
# 		SET @table = 't1';
# 		SET @s = CONCAT('SELECT * FROM ', @table);
# 
# 		PREPARE stmt3 FROM @s;
# 		EXECUTE stmt3;
# 		+------+
# 		| a 	 |
# 		+------+
# 		| 4 	 |
# 		| 8 	 |
# 		| 11   |
# 		| 32 	 |
# 		| 80   |
# 		+------+
#
# 		DEALLOCATE PREPARE stmt3;
#
# A prepared statement is specific to the session in which it was created.
#
# If you terminate a session without deallocating a previously prepared statement,
# the server deallocates it automatically.
#
# A prepared statement is also global to the session. If you create a prepared statement
# within a stored routine, it is not deallocated when the stored routine ends.
#
# To guard against too many prepared statements being created simultaneously, set the
# max_prepared_stmt_count system variable.
#
# To prevent the use of prepared statements, set the value to 0.
#
# SQL SYNTAX ALLOWED IN PREPARED STATEMENTS
#
# The following SQL statements can be used as prepared statements:
#
# 		ALTER TABLE
# 		ALTER USER
# 		ANALYZE TABLE
#
# 		CACHE INDEX
# 		CALL
# 		CHANGE MASTER
#
# 		CHECKSUM {TABLE | TABLES}
# 		COMMIT
# 		{CREATE | DROP} INDEX
#
# 		{CREATE | RENAME | DROP} DATABASE
# 		{CREATE | DROP} TABLE
# 		{CREATE | RENAME | DROP} USER
#
# 		{CREATE | DROP} VIEW
# 		DELETE
# 		DO
#
# 		FLUSH {TABLE | TABLES | TABLES WITH READ LOCK | HOSTS | PRIVILEGES
# 			| LOGS | STATUS | MASTER | SLAVE | USER_RESOURCES}
# 		GRANT
# 		INSERT
#
# 		INSTALL PLUGIN
# 		KILL
# 		LOAD INDEX INTO CACHE
#
# 		OPTIMIZE TABLE
# 		RENAME TABLE
# 		REPAIR TABLE
#
#  	REPLACE
# 		RESET {MASTER | SLAVE}
# 		REVOKE
#
# 		SELECT
# 		SET
# 		SHOW {WARNINGS | ERRORS}
#
# 		SHOW BINLOG EVENTS
# 		SHOW CREATE {PROCEDURE | FUNCTION | EVENT | TABLE | VIEW}
# 		SHOW {MASTER | BINARY} LOGS
# 
# 		SHOW {MASTER | SLAVE} STATUS
# 		SLAVE {START | STOP}
# 		TRUNCATE TABLE
#
# 		UNINSTALL PLUGIN
# 		UPDATE
#
# For compliance with the SQL standard, which states that diagnostics statements are not preparable,
# MySQL does not support the following as prepared statements:
#
# 		) SHOW WARNINGS, SHOW COUNT(*) WARNINGS
#
# 		) SHOW ERRORS, SHOW COUNT(*) ERRORS
#
# 		) Statements containing any reference to the warning_count or error_count system variable.
#
# Other statements are not supported in MySQL 8.0
#
# Generally, statements not permitted in SQL preapred statements are also not permitted in stored
# programs.
#
# Exceptions are noted in SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS"
#
# Metadata changes to tables or views referred to by prepared statements are detected
# and cause automatic repreparation of the statement when it is next executed.
#
# For more information, see SECTION 8.10.3, "CACHING OF PREPARED STATEMENTS AND STORED PROGRAMS"
#
# Placeholders can be used for the arguments of the LIMIT clause when using prepared statements.
#
# See SECTION 13.2.10, "SELECT SYNTAX"
#
# In prepared CALL statements used with PREPARE and EXECUTE, placeholder support for OUT and
# INOUT parameters is available beginning with MySQL 8.0
#
# See SECTION 13.2.1, "CALL SYNTAX", for an example and a workaround for earlier versions.
#
# Placeholders can be used for IN parameters regardless of version.
#
# SQL syntax for prepared statements cannot be used in nested fashion. That is, a statement
# passed to PREPARE cannot itself be a PREPARE, EXECUTE or DEALLOCATE_PREPARE statement.
#
# SQL syntax for prepared statements is distinct from using prepared statement API calls.
#
# For example, you cannot use the mysql_stmt_prepare() C API function to prepare a
# PREPARE, EXECUTE or DEALLOCATE_PREPARE statement.
#
# SQL syntax for prepared statements can be used within stored procedures, but not
# in stored functions or triggers.
#
# However, a cursor cannot be used for a dynamic statement that is prepared and
# executed with PREPARE and EXECUTE.
#
# The statement for a cursor is checked at cursor creation time, so the statement
# cannot be dynamic.
#
# SQL syntax for prepared statements does not support multi-statements (that is,
# multiple statements within a single string separated by ; characters)
#
# To write C programs that use the CALL SQL statement to execute stored procedures
# that contain prepared statements, the CLIENT_MULTI_RESULTS flag must be enabled.
#
# This is because each CALL returns a result to indicate the call status, in addition
# to any result sets that might be returned by statements executed within the procedure.
#
# CLIENT_MULTI_RESULTS can be enabled when you call mysql_real_connect(), either
# explicitly by passing the CLIENT_MULTI_RESULTS flag itself, or implicitly by
# passing CLIENT_MULTI_STATEMENTS (which also enables CLIENT_MULTI_RESULTS)
#
# For additional information, see SECTION 13.2.1, "CALL SYNTAX"
#
# 13.5.1 PREPARE SYNTAX
#
# 		PREPARE stmt_name FROM preparable_stmt
#
# The PREPARE statement prepares a SQL statement and assigns it a name, stmt_name, by which
# to refer to the statement later.
#
# The prepared statement is executed with EXECUTE and released with DEALLOCATE_PREPARE
#
# For examples, see SECTION 13.5, "PREPARED SQL STATEMENT SYNTAX"
#
# Statement names are not case-sensitive. preparable_stmt is either a string literal or
# a user variable that contains the text of the SQL statement.
#
# The text must represent a single statement, not multiple statements.
#
# Within the statement, ? characters can be used as parameter markers to indicate
# where data values are to be bound to the query later when you execute it.
#
# The ? characters should not be enclosed within quotation marks, even if you
# intend to bind them to string values.
#
# Parameter markers can be used only where data values should appear, not for
# SQL keywords, identifiers, and so forth.
#
# If a prepared statement with the given name already exists. It is deallocated implicitly
# before the new statement is prepared.
#
# This means that if the new statement contains an error and cannot be prepared,
# an error is returned and no statement with the given name exists.
#
# The scope of a prepared statement is the session within which it is created,
# which as several implications:
#
# 		) A prepared statement created in one session is not available to other sessions
#
# 		) When a session ends, whether normally or abnormally, its prepared statements
# 			no longer exist.
#
# 			If auto-reconnect is enabled, the client is not notified that the connection
# 			was lost.
#
# 			For this reason, clients may wish to disable auto-reconnect
#
# 			See SECTION 28.7.24, "C API AUTOMATIC RECONNECTION CONTROL"
#
# 		) A prepared statement created within a stored program continues to exist
# 			after the program finishes executing and can be executed outside the 
# 			program later.
#
# 		) A statement prepared in stored program context cannot refer to stored procedure
# 			or function parameters or local variables because they go out of scope when the
# 			program ends and would be unavailable were the statement to be executed later outside
# 			the program.
#
# 			As a workaround, refer instead to user-defined variables, which also have
# 			session scope;
#
# 			See SECTION 9.4, "USER-DEFINED VARIABLES"
#
# 13.5.2 EXECUTE SYNTAX
#
# 		EXECUTE stmt_name
# 			[USING @var_name [, @var_name] ---]
#
# After preparing a statement with PREPARE, you execute it with an EXECUTE statement
# that refers to the prepared statement name.
#
# If the prepared statement contains any parameter markers, you must supply a USING
# clause that lists user variables containing the values to be bound to the parameters.
#
# Parameter values can be supplied only by user variables, and the USING clause must
# name exactly as many variables as the number of parameter markers in the statement.
#
# You can execute a given prepared statement multiple times, passing different variables
# to it or setting the variables to different values before each execution.
#
# For examples, see SECTION 13.5, "PREPARED SQL STATEMENT SYNTAX"
#
# 13.5.3 DEALLOCATE PREPARE SYNTAX
#
# 		{DEALLOCATE | DROP} PREPARE stmt_name
#
# To deallocate a prepared statement produced with PREPARE, use a DEALLOCATE_PREPARE
# statement that refers to the prepared statement name.
#
# Attempting to execute a prepared statement after deallocating it results in an
# error.
#
# If too many prepared statements are created and not deallocated by either the
# DEALLOCATE PREPARE statement or the end of the session, you might encounter
# the upper limit enforced by the max_prepared_stmt_count system variable.
#
# For examples, see SECTION 13.5, "PREPARED SQL STATEMENT SYNTAX"
#
# 13.6 COMPOUND-STATEMENT SYNTAX
#
# 		13.6.1 BEGIN --- END COMPOUND-STATEMENT SYNTAX
# 		13.6.2 STATEMENT LABEL SYNTAX
# 
# 		13.6.3 DECLARE SYNTAX
# 		13.6.4 VARIABLES IN STORED PROGRAMS
#
# 		13.6.5 FLOW CONTROL STATEMENTS
# 		13.6.6 CURSORS
# 	
# 		13.6.7 CONDITION HANDLING
#
# This section desccribes the syntax for the BEGIN_---_END compound statement and other
# statements that can be used in the body of stored programs:
#
# 		Stored procedures and functions, triggers, and events.
#
# These objects are defined in terms of SQL code that is stored on the server
# for later invocation
#
# (See CHAPTER 24, STORED PROGRAMS AND VIEWS)
#
# A compound statement is a block that can contain other blocks; declarations
# for variables, condition handlers and cursors; and flow control constructs 
# such as loops and conditional tests.
#
# 13.6.1 BEGIN --- END COMPOUND-STATEMENT SYNTAX
#
# 		[begin_label:] BEGIN
# 			[statement_list]
# 		END [end_label]
#
# BEGIN_---_END syntax is used for writing compound statements, which can appear
# within stored programs (stored procedures and functions, triggers and events)
#
# A compound statement can contain multiple statements, enclosed by the BEGIN 
# and END keywords.
#
# statement_list represents a list of one or more statements, each terminated
# by a semicolon (;) statement delimiter.
#
# The statement_list itself is optional, so the empty compound statement
# (BEGIN END) is legal.
#
# BEGIN_---_END blocks can be nested.
#
# Use of multiple statements requires that a client is able to send statement
# strings containing the ; statement delimiter.
#
# In the mysql command-line client, this is handled with the delimiter command.
#
# Changing the ; end-of-statement delimiter (for example, to //) permit ; to
# be used in a program body.
#
# For an example, see SECTION 24.1, "DEFINING STORED PROGRAMS"
#
# A BEGIN_---_END block can be labeled. See SECTION 13.6.2, "STATEMENT LABEL SYNTAX"
#
# The optional [NOT] ATOMIC clause is not supported.
#
# This means that no transactional savepoint is set at the start of the instruction
# block and the BEGIN clause used in this context has no effect on the current transaction.
#
# NOTE:
#
# 		Within all stored programs, the parser treats BEGIN_[WORK] as the beginning of a 
# 		BEGIN_---_END block.
#
# 		To begin a transaction in this context, use START_TRANSACTION instead.
#
# 13.6.2 STATEMENT LABEL SYNTAX
#
# 		[begin_label:] BEGIN
# 			[statement_list]
# 		END [end_label]
#
# 		[begin_label:] LOOP
# 			statement_list
# 		END LOOP [end_label]
#
# 		[begin_label:] REPEAT
# 			statement_list
# 		UNTIL search_condition
# 		END REPEAT [end_label]
#
# 		[begin_label:] WHILE search_condition DO
# 			statement_list
# 		END WHILE [end_label]
#
# Labels are permitted for BEGIN_---_END blocks and for the LOOP, REPEAT and WHILE statements.
#
# Label use for those statements follows these rules:
#
# 		) begin_label must be followed by a colon
#
# 		) begin_label can be given without end_label.
#
# 			If end_label is present, it must be the same as begin_label
#
# 		) end_label cannot be given without begin_label
#
# 		) Labels at the same nesting level must be distinct.
#
# 		) Labels can be up to 16 characters long
#
# To refer to a label within the labeled construct, use an ITERATE 
# or LEAVE statement.
#
# The following example uses those statements to continue iterating or
# terminate the loop:
#
# 		CREATE PROCEDURE doiterate(p1 INT)
# 		BEGIN
# 			label1: LOOP
# 				SET p1 = p1 + 1;
# 				IF p1 < 10 THEN ITERATE label1; END IF;
# 				LEAVE label1;
# 			END LOOP label1;
# 		END;
#
# The scope of a block label does not include the code for handlers declared within the
# block.
#
# For details, see SECTION 13.6.7.2, "DECLARE --- HANDLER SYNTAX"
#
# 13.6.3 DECLARE SYNTAX
#
# The DECLARE statement is used to define various items local to a program:
#
# 		) Local variables. See SECTION 13.6.4, "VARIABLES IN STORED PROGRAMS"
#
# 		) Conditions and handlers. See SECTION 13.6.7, "CONDITION HANDLING"
#
# 		) Cursors. See SECTION 13.6.6, "CURSORS"
#
# DECLARE is permitted only inside a BEGIN_---_END compound statement and must be
# at its start, before any other statements.
#
# Declarations must follow a certain order.
#
# Cursor declarations must appear before handler declarations.
#
# Variable and condition declarations must appear before cursor or
# handler declarations.
#
# 13.6.4 VARIABLES IN STORED PROGRAMS
#
# 13.6.4.1 LOCAL VARIABLE DECLARE SYNTAX
# 13.6.4.2 LOCAL VARIABLE SCOPE AND RESOLUTION
#
# System variables and user-defined variables can be used in stored programs, just as they can be used
# outside stored-program context.
#
# In addition, stored programs can use DECLARE to define local variables, and stored routines
# (procedures and functions) can be declared to take parameters that communicate
# values between the routine and its caller.
#
# 		) To declare local variables, use the DECLARE statement, as described in SECTION 13.6.4.1, "LOCAL VARIABLE DECLARE SYNTAX"
#
# 		) Variables can be set directly with the SET statement. See SECTION 13.7.5.1, "SET SYNTAX FOR VARIABLE ASSIGNMENT"
#
# 		) Results from queries can be retrieved into local variables using SELECT_---_INTO_var_list or by opening a cursor
# 			and using FETCH_---_INTO_var_list
#
# 			See SECTION 13.2.10.1, "SELECT --- INTO SYNTAX", and SECTION 13.6.6, "CURSORS"
#
# For information about the scope of local variables and how MySQL resolves ambiguous names, see SECTION 13.6.4.2,
# "LOCAL VARIABLE SCOPE AND RESOLUTION"
#
# It is not permitted to assign the value DEFAULT to stored procedure or function parameters or stored
# program local variables (for example with a SET var_name = DEFAULT statement)
#
# In MySQL 8.0, this results in a syntax error
#
# 13.6.4.1 LOCAL VARIABLE DECLARE SYNTAX
#
# 		DECLARE var_name [, var_name] --- type [DEFAULT value]
#
# This statement declares local variables within stored programs.
#
# To provide a default value for a variable, include a DEFAULT clause.
#
# The value can be specified as an expression; it need not be a constant.
#
# If the DEFAULT clause is missing, the initial value is NULL
#
# Local variables are treated like stored routine parameters with respect to data
# type and overflow checking.
#
# See SECTION 13.1.17, "CREATE PROCEDURE AND CREATE FUNCTION SYNTAX"
#
# Variable declarations must appear before cursor or handler declarations
#
# Local variable names are not case-sensitive. Permissible characters and quoting rules
# are the same as for other identifiers, as described in SECTION 9.2, "SCHEMA OBJECT NAMES"
#
# The scope of a local variable is the BEGIN_---_END block within which it is declared.
#
# The variable can be referred to in blocks nested within the declaring block, except
# those blocks that declare a variable with the same name.
#
# For examples of variable declarations, see SECTION 13.6.4.2, "LOCAL VARIABLE SCOPE AND RESOLUTION"
#
# 13.6.4.2 LOCAL VARIABLE SCOPE AND RESOLUTION
#
# The scope of a local variable is the BEGIN_---_END block within which it is declared.
#
# The variable can be referred to in blocks nested within the declaring block, except
# those blocks that declare a variable with the same name.
#
# Because local variables are in scope only during stored program execution, references
# to them are not permitted in prepared statements created within a stored program.
#
# Prepared statement scope is the current session, not the stored program, so the
# statement could be executed after the program ends, at which point the variables
# would no longer be in scope.
#
# For example, SELECT --- INTO local_var cannot be used as a prepared statement.
#
# This restriction also applies to stored procedure and function parameters.
#
# See SECTION 13.5.1, "PREPARE SYNTAX"
#
# A local variable should not have the same name as a table column.
#
# If an SQL statement, such as SELECT_---_INTO statement, contains a reference
# to a column and a declared local variable with the same name, MySQL currently
# interprets the reference as the name of a variable.
#
# Consider the following procedure definition:
#
# 		CREATE PROCEDURE sp1 (x VARCHAR(5))
# 		BEGIN
# 			DECLARE xname VARCHAR(5) DEFAULT 'bob';
# 			DECLARE newname VARCHAR(5);
# 			DECLARE xid INT;
#
# 			SELECT xname, id INTO newname, xid
# 				FROM table1 WHERE xname = xname;
# 			SELECT newname;
# 		END;
#
# MySQL interprets xname in the SELECT statement as a reference to the 
# xname variable rather than the xname column.
#
# Consequently, when the procedure sp1() is called, the newname variable
# returns the value 'bob' regardless of the value of the table1.xname
# column.
#
# Similarly, the cursor definition in the following procedure contains a SELECT
# statement that refers to xname.
#
# MySQL interprets this as a reference to the variable of that name rather
# than a column reference.
#
# 		CREATE PROCEDURE sp2 (x VARCHAR(5))
# 		BEGIN
# 			DECLARE xname VARCHAR(5) DEFAULT 'bob';
# 			DECLARE newname VARCHAR(5);
# 			DECLARE xid INT;
# 			DECLARE done TINYINT DEFAULT 0;
# 			DECLARE cur1 CURSOR FOR SELECT xname, id FROM table1;
# 			DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
#
# 			OPEN cur1;
# 			read_loop: LOOP
# 				FETCH FROM cur1 INTO newname, xid;
# 				IF done THEN LEAVE read_loop; END IF
# 				SELECT newname;
# 			END LOOP;
# 			CLOSE cur1;
# 		END;
#
# See also SECTION C.1, "RESTRICTIONS ON STORED PROGRAMS"
#
# 13.6.5 FLOW CONTROL STATEMENTS
#
# 13.6.5.1 CASE SYNTAX
# 13.6.5.2 IF SYNTAX
#
# 13.6.5.3 ITERATE SYNTAX
# 13.6.5.4 LEAVE SYNTAX
#
# 13.6.5.5 LOOP SYNTAX
# 13.6.5.6 REPEAT SYNTAX
#
# 13.6.5.7 RETURN SYNTAX
# 13.6.5.8 WHILE SYNTAX
#
# MySQL supports the IF, CASE, ITERATE, LEAVE LOOP, WHILE and REPEAT constructs for flow control
# within stored programs.
#
# It also supports RETURN within stored functions.
#
# Many of these constructs contain other statements, as indicated by the grammar specifications
# in the following sections.
#
# Such constructs may be nested.
#
# For example, an IF statement might contain a WHILE loop, which itself contains a CASE statement.
#
# MySQL does not support FOR Loops.
#
# 13.6.5.1 CASE SYNTAX
#
# 		CASE case_value
# 			WHEN when_value THEN statement_list
# 			[WHEN when_value THEN statement_list]
# 			[ELSE statement_list]
# 		END CASE
#
# Or:
#
# 		CASE
# 			WHEN search_condition THEN statement_list
# 			[WHEN search_condition THEN statement_list]
# 			[ELSE statement_list]
# 		END CASE
#
# The CASE statement for stored programs implements a complex conditional construct.
#
# NOTE:
#
# 		There is also a CASE expression, which differs from the CASE statement described here.
#
# 		See SECTION 12.4, "CONTROL FLOW FUNCTIONS"
#
# 		The CASE statement cannot have an ELSE NULL clause, and it is terminated with 
# 		END CASE instead of END
#
# For the first syntax, case_value is an expression.
#
# This value is compared to the when_value expression in each WHEN clause until one of them
# is equal.
#
# When an equal when_value is found, the corresponding THEN clause statement_list executes.
#
# If no when_value is equal, the ELSE clause statement_list executes, if there is one.
#
# This syntax cannot be used to test for equalit with NULL because NULL = NULL is false.
#
# See SECTION 3.3.4.6, "WORKING WITH NULL VALUES"
#
# For the second syntax, each WHEN clause search_condition expression is evaluated until one
# is true, at which point its corresponding THEN clause statement_list executes.
#
# If no search_condition is equal, the ELSE clause statement_list executes, if there is one.
#
# If no when_value or search_condition matches the value tested and the CASE statement contains
# no ELSE clause, a:
#
# 		Case not found for CASE statement
#
# error results.
#
# Each statement_list consists of one or more SQL statements; an empty statement_list
# is not permitted.
#
# To handle situations where no value is matched by any WHEN clause, use an ELSE containing
# an empty BEGIN_---_END block, as shown in this example.
#
# (The indentation used here in the ELSE clause is for purposes of clarity only,
# and is not otherwise significant)
#
# DELIMITER |
#
# CREATE PROCEDURE p()
# 		BEGIN
# 			DECLARE v INT DEFAULT 1;
#
# 			CASE v
# 				WHEN 2 THEN SELECT v;
# 				WHEN 3 THEN SELECT 0;
# 				ELSE
# 					BEGIN
# 					END;
# 			END CASE;
# 		END;
# 		|
#
# 13.6.5.2 IF SYNTAX
#
# IF search_condition THEN statement_list
# 		[ELSEIF search_condition THEN statement_list] ---
# 		[ELSE statement_list]
# END IF
#
# The IF statement for stored programs implements a basic conditional construct.
#
# NOTE:
#
# 		There is also an IF() funciton, which differs from the IF statement described here.
#
# 		See SECTION 12.4, "CONTROL FLOW FUNCTIONS"
#
# 		The IF statement can have THEN, ELSE and ELSEIF clauses, and it is
# 		terminated with END IF.
#
# If the search_condition evaluates to true, the corresponding THEN or ELSEIF clause
# statement_list executes.
#
# If no search_condition matches, the ELSE clause statement_list executes.
#
# Each statement_list consists of one or more SQL statements; an empty statement_list is
# not permitted.
#
# An IF --- END IF block, like all other flow-control blocks used within stored programs,
# must be terminated with a semicolon, as shown in this example:
#
# 		DELIMITER //
#
# 		CREATE FUNCTION SimpleCompare(n INT, m INT)
# 			RETURNS VARCHAR(20)
#
# 			BEGIN
# 				DECLARE s VARCHAR(20);
#
# 				IF n > m THEN SET s = '>';
# 				ELSEIF n = m THEN SET s = '=';
# 				ELSE SET s = '<';
# 				END IF;
#
# 				SET s = CONCAT(n, ' ', s, ' ', m);
#
# 				RETURN s;
# 			END //
#
# 		DELIMITER;
#
# AS with other flow-control constructs, IF --- END IF blocks may be nested within other
# flow-control constructs, including other IF statements.
#
# Each IF must be terminated by its own END IF followed by a semicolon.
#
# You can use indentation to make nested flow-control blocks more easily readable
# by humans (although this is not required by MySQL), as shown here:
#
# 		DELIMITER //
#
# 		CREATE FUNCTION VerboseCompare (n INT, m INT)
# 			RETURNS VARCHAR(50)
#
# 			BEGIN
# 				DECLARE s VARCHAR(50);
#
# 				IF n = m THEN SET s = 'equals';
# 				ELSE
# 					IF n > m THEN SET s = 'greater';
# 					ELSE SET s = 'less';
# 					END IF;
#
# 					SET s = CONCAT('is', s, ' than');
# 				END IF;
#
# 				SET s = CONCAT(n, ' ', s, ' ', m, '.');
#
# 				RETURN s;
# 			END //
#
# 		DELIMITER ;
#
# In this example, the inner IF is evaluated only if n is not equal to m
#
# 13.6.5.3 ITERATE SYNTAX
#
# 		ITERATE label
#
# ITERATE can appear only within LOOP, REPEAT, and WHILE statements.
#
# ITERATE means "start the loop again"
#
# For an example, see SECTION 13.6.5.5, "LOOP SYNTAX"
#
# 13.6.5.4 LEAVE SYNTAX
#
# 		LEAVE label
#
# This statement is used to exit the flow control construct that has the given label.
#
# If the label is for the outermost stored program block, LEAVE exits the program
#
# LEAVE can be used within BEGIN_---_END or loop constructs (LOOP, REPEAT, WHILE)
#
# For an example, see SECTION 13.6.5.5, "LOOP SYNTAX"
#
# 13.6.5.5 LOOP SYNTAX
#
# 		[begin_label:] LOOP
# 			statement_list
# 		END LOOP [end_label]
#
# LOOP implements a simple loop construct, enabling repeated execution of the statement
# list, which consists of one or more statements, each terminated by a semicolon (;) 
# statement delimiter.
#
# The statements within the loop are repeated until the loop is terminated.
#
# Usually, this is accomplished with a LEAVE statement.
#
# Within a stored function, RETURN can also be used, which exits the function entirely
#
# Neglecting to include a loop-termination statement results in an infinite loop
#
# A LOOP statement can be labeled. For the rules regarding label use, see SECTION 13.6.2, "STATEMENT LABEL SYNTAX"
#
# Example:
#
# 		CREATE PROCEDURE doiterate(p1 INT)
# 		BEGIN
# 			label1: LOOP
# 				SET p1 = p1 + 1;
# 				IF p1 < 10 THEN
# 					ITERATE label1;
# 				END IF;
# 				LEAVE label1;
# 			END LOOP label1;
# 			SET @x = p1;
# 		END;
#
# 13.6.5.6 REPEAT SYNTAX
#
# 	[begin_label:] REPEAT
# 		statement_list
# 	UNTIL search_condition
# 	END REPEAT [end_label]
#
# The statement list within a REPEAT statement is repeated until the search_condition expression
# is true.
#
# Thus, a REPEAT always enters the loop at least once.
#
# statement_list consists of one or more statements, each terminated by a semicolon (;) statement delimiter
#
# A REPEAT statement can be labeled. For the rules regarding label use, see SECTION 13.6.2,
# "STATEMENT LABEL SYNTAX"
#
# Example:
#
# 		delimiter //
#
# 		CREATE PROCEDURE dorepeat(p1 INT)
# 		BEGIN
# 			SET @x = 0;
# 			REPEAT
# 				SET @x = @x + 1;
# 			UNTIL @x > p1 END REPEAT;
# 		END
# 		//
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		CALL dorepeat(1000)//
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT @x//
# 		+---------+
# 		| @x 	    |
# 		+---------+
# 		| 1001 	 |
# 		+---------+
# 		1 row in set (0.00 sec)
#
# 13.6.5.7 RETURN SYNTAX
#
# 		RETURN expr
#
# The RETURN statement terminates execution of a stored function and returns the value expr to
# the function caller.
#
# There must be at least one RETURN statement in a stored function.
#
# There may be more than one if the function has multiple exit points.
#
# This statement is not used in stored procedures, triggers, or events.
#
# The LEAVE statement can be used to exit a stored program of those types.
#
# 13.6.5.8 WHILE SYNTAX
#
# 		[begin_label:] WHILE search_condition DO
# 			statement_list
# 		END WHILE [end_label]
#
# The statement list within a WHILE statement is repeated as long as the search_condition
# expression is true.
#
# statement_list consists of one or more SQL statements, each terminated by a semicolon
# (;) statement delimiter.
#
# A WHILE statement can be labeled. For the rules regarding label use,
# see SECTION 13.6.2, "STATEMENT LABEL SYNTAX"
#
# Example:
#
# 		CREATE PROCEDURE dowhile()
# 		BEGIN
# 			DECLARE v1 INT DEFAULT 5;
#
# 			WHILE v1 > 0 DO
# 				---
# 				SET v1 = v1 - 1;
# 			END WHILE;
# 		END;
#
# 13.6.6 CURSORS
#
# 13.6.6.1 CURSOR CLOSE SYNTAX
# 13.6.6.2 CURSOR DECLARE SYNTAX
# 13.6.6.3 CURSOR FETCH SYNTAX
# 13.6.6.4 CURSOR OPEN SYNTAX
#
# MySQL supports cursors inside stored programs.
#
# The syntax is as in embedded SQL. Cursors have these properties:
#
# 		) Asensitive: The server may or may not make a copy of its result table
#
# 		) Read only: Not updatable
#
# 		) Nonscrollable: Can be traversed only in one direction and cannot skip rows
#
# Cursor declarations must appear before handler declarations and after variable and condition
# declarations.
#
# Example:
#
# 		CREATE PROCEDURE curdemo()
# 		BEGIN
# 			DECLARE done INT DEFAULT FALSE;
# 			DECLARE a CHAR(16);
# 			DECLARE b, c INT;
# 			DECLARE cur1 CURSOR FOR SELECT id, data FROM test.t1;
# 			DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
# 			DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
#
# 			OPEN cur1;
# 			OPEN cur2;
#
# 			read_loop: LOOP
# 				FETCH cur1 INTO a, b;
# 				FETCH cur2 INTO c;
# 				IF done THEN
# 					LEAVE read_loop;
# 				END IF;
# 				IF b < c THEN
# 					INSERT INTO test.t3 VALUES (a,b);
# 				ELSE
# 					INSERT INTO test.t3 VALUES (a,c);
# 				END IF;
# 			END LOOP;
#
# 			CLOSE cur1;
# 			CLOSE cur2;
# 		END;
#
# 13.6.6.1 CURSOR CLOSE SYNTAX
#
# 		CLOSE cursor_name
#
# This statement closes a previously opened cursor.
#
# For an example, see SECTION 13.6.6, "CURSORS"
#
# An error occurs if the cursor is not open.
#
# If not closed explicitly, a cursor is closed at the end of the
# BEGIN_---_END block in which it was declared.
#
# 13.6.6.2 CURSOR DECLARE SYNTAX
#
# 		DECLARE cursor_name CURSOR FOR select_statement
#
# This statement declares a cursor and associates it with a SELECT statement that
# retrieves the rows to be traversed by the cursor.
#
# To fetch the rows later, use a FETCH statement.
#
# The number of columns retrieved by the SELECT statement must match the number
# of output variables specified in the FETCH statement.
#
# The SELECT statement cannot have an INTO clause.
#
# Cursor declarations must appear before handler declarations and after variable
# and condition declarations.
#
# A stored program may contain multiple cursor declarations, but each cursor declared
# in a given block must have a unique name.
#
# For an example, see SECTION 13.6.6, "CURSORS"
#
# For information available through SHOW statements, it is possible in many cases
# to obtain equivalent information by using a cursor with an INFORMATION_SCHEMA table.
#
# 13.6.6.3 CURSOR FETCH SYNTAX
#
# 		FETCH [[NEXT] FROM] cursor_name INTO var_name [, var_name] ---
#
# This statement fetches the next row for the SELECT statement associated with the
# specified cursor (which must be open), and advances the cursor pointer.
#
# If a row exists, the fetched columns are stored in the named variables.
#
# The number of columns retrieved by the SELECT statement must match the number
# of output variables specified in the FETCH statement.
#
# If no more rows are available, a No Data condition occurs with SQLSTATE
# value '02000'
#
# To detect this condition, you can set up a handler for it (or for a NOT FOUND condition)
# 
# For an example, see SECTION 13.6.6, "CURSORS"
#
# Be aware that another operation, such as a SELECT or another FETCH, may also cause
# the handler to execute by raising the same condition.
#
# If it is necessary to distinguish which operation raised the condition,
# place the operation within its own BEGIN_---_END block so that it can be
# associated with its own handler.
#
# 13.6.6.4 CURSOR OPEN SYNTAX
#
# 		OPEN cursor_name
#
# This statement opens a previously declared cursor. For an example, see SECTION 13.6.6, "CURSORS"
#
# 13.6.7 CONDITION HANDLING
#
# 13.6.7.1 DECLARE --- CONDITION SYNTAX
# 13.6.7.2 DECLARE --- HANDLER SYNTAX
#
# 13.6.7.3 GET DIAGNOSTICS SYNTAX
# 13.6.7.4 RESIGNAL SYNTAX
#
# 13.6.7.5 SIGNAL SYNTAX
# 13.6.7.6 SCOPE RULES FOR HANDLERS
#
# 13.6.7.7 THE MYSQL DIAGNOSTICS AREA
# 13.6.7.8 CONDITION HANDLING AND OUT OR INOUT PARAMETERS
#
# Conditions may arise during stored program execution that require special handling,
# such as exiting the current program block or continuing execution.
#
# Handlers can be defined for general conditions such as warnings or exceptions,
# or for specific conditions such as particular error code.
#
# Specific conditions can be assigned names and referred to that way in handlers.
#
# To name a condition, use the DECLARE_---_CONDITION statement.
#
# To declare a handler, use the DECLARE_---_HANDLER statement.
#
# See SECTION 13.6.7.1, "DECLARE --- CONDITION SYNTAX", and SECTION 13.6.7.2, "DECLARE_---_HANDLER SYNTAX"
#
# For information about how the server chooses handlers when a condition occurs,
# see SECTION 13.6.7.6, "SCOPE RULES FOR HANDLERS"
#
# To raise a condition, use the SIGNAL statement. To modify condition information within
# a condition handler, use RESIGNAL.
#
# See SECTION 13.6.7.1, "DECLARE --- CONDITION SYNTAX", and SECTION 13.6.7.2, "DECLARE --- HANDLER SYNTAX"
#
# To retrieve information from the diagnostics area, use the GET_DIAGNOSTICS statement (see SECTION 13.6.7.3,
# "GET DIAGNOSTICS SYNTAX")
#
# For information about the diagnostics area, see SECTION 13.6.7.7, "THE MYSQL DIAGNOSTICS AREA"
#
# 13.6.7.1 DECLARE --- CONDITION SYNTAX
#
# DECLARE condition_name CONDITION FOR condition_value
#
# condition_value: {
# 		mysql_error_code
# 	 | SQLSTATE [VALUE] sqlstate_value
# }
#
# The DECLARE_---_CONDITION statement declares a named error condition, associating
# a name with a condition that needs specific handling.
#
# The name can be referred to in a subsequent DECLARE_---_HANDLER statement (see SECTION 13.6.7.2, "DECLARE_---_HANDLER SYNTAX")
#
# Condition declarations must appear before cursor or handler declarations.
#
# The condition_value for DECLARE_---_CONDITION indicates the specific condition or class of conditions
# to associate with the condition name.
#
# It can take the following forms:
#
# 		) mysql_error_code: An integer literal indicating a MySQL error code.
#
# 			Do not use MySQL error code 0 because that indicates success rather than an error
# 			condition.
#
# 			For a list of MySQL error codes, see SECTION B.3, "SERVER ERROR MESSAGE REFERENCE"
#
# 		) SQLSTATE[VALUE] sqlstate_value: A 5-character string literal indicating an SQLSTATE value.
#
# 			Do not use SQLSTATE values that begin with '00' because those indicate success rather
# 			than an error condition.
#
# 			For a list of SQLSTATE values, see SECTION B.3, "SERVER ERROR MESSAGE REFERENCE"
#
# Condition names referred to in SIGNAL or use RESIGNAL statements must be associated with
# SQLSTATE values, not MySQL error codes.
#
# Using names for conditions can help make stored program code clearer.
#
# For example, this handler applies to attempts to drop a nonexistent table,
# but that is apparent only if you know that 1051 is the MySQL error code for "unknown table":
#
# 		DECLARE CONTINUE HANDLER FOR 1051
# 			BEGIN
# 				-- body of handler
# 			END;
#
# By declaring a name for the condition, the purpose of the handler is more readily seen:
#
# 		DECLARE no_such_table CONDITION FOR 1051;
# 		DECLARE CONTINUE HANDLER FOR no_such_table
# 			BEGIN
# 				-- body of handler
# 			END;
#
# Here is a named condition for the same condition, but based on the corresponding
# SQLSTATE value rather than the MySQL error code:
#
# 		DECLARE no_such_table CONDITION FOR SQLSTATE '42S02';
# 		DECLARE CONTINUE HANDLER FOR no_such_table
# 			BEGIN
# 				-- body of handler
# 			END;
#
# 13.6.7.2 DECLARE --- HANDLER SYNTAX
#
# 	DECLARE handler_action HANDLER
# 		FOR condition_value [, condition_value]
# 		statement
#
# 	handler_action: {
# 		CONTINUE
# 	 | EXIT
#   | UNDO
# 	}
#
# 	condition_value: {
# 		mysql_error_code
#   | SQLSTATE [VALUE] sqlstate_value
# 	 | condition_name
# 	 | SQLWARNING
# 	 | NOT FOUND
#   | SQLEXCEPTION
#  }
#
# The DECLARE_---_HANDLER statement specifies a handler that deals with one or more
# conditions.
#
# If one of these conditions occurs, the specified statement executes.
#
# statement can be a simple statement such as SET var_name = value, or a compound statement
# written using BEGIN and END (see SECTION 13.6.1, "BEGIN --- END COMPOUND-STATEMENT SYNTAX")
#
# Handler declarations must appear after variable or condition declarations.
#
# The handler_action value indicates what action the handler takes after execution
# of the handler statement:
#
# 		) CONTINUE: Execution of the current program continues
#
# 		) EXIT: Execution terminates for the BEGIN_---_END compound statement in which the handler
# 			is declared.
#
# 			This is true even if the condition occurs in an inner block.
#
# 		) UNDO: Not supported.
#
# The condition_value for DECLARE_---_HANDLER indicates the specific condition or class
# of conditions that activates the handler.
#
# It can take the following forms:
#
# 		) mysql_error_code: An integer literal indicating a MySQL error code, such as 1051 to specify "Unknown table":
#
# 			DECLARE CONTINUE HANDLER FOR 1051
# 				BEGIN
# 					-- body of handler
# 				END;
#
# 			Do not use MySQL error code 0 because that indicates success rather than an error condition.
#
# 			For a list of MySQL error codes, see SECTION B.3, "SERVER ERROR MESSAGE REFERENCE"
#
# 		) SQLSTATE[VALUE] sqlstate_value: A 5-character string literal indicating an SQLSTATE value,
# 			such as '42S01' to specify "unknown table":
#
# 				DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
# 					BEGIN
# 						-- body of handler
# 					END;
#
# 			Do not use SQLSTATE values that begin with '00' because those indicate success
# 			rather than an error condition.
#
# 			For a list of SQLSTATE values, see SECTION B.3, "SERVER ERROR MESSAGE REFERENCE"
#
# 		) condition_name: A condition name previously specified with DECLARE_---_CONDITION
#
# 			A condition name can be associated with a MySQL error code or SQLSTATE value.
#
# 			See SECTION 13.6.7.1, "DECLARE --- CONDITION SYNTAX"
#
# 		) SQLWARNING: Shorthand for the class of SQLSTATE values that begin with '01'
#
# 			DECLARE CONTINUE HANDLER FOR SQLWARNING
# 				BEGIN
# 					--- body of handler
# 				END;
#
# 		) NOT FOUND:
#
# 			Shorthand for the class of SQLSTATE values that begin with '02'
#
# 			This is relevant within the context of cursors and is used to control
# 			what happens when a cursor reaches the end of a data set.
#
# 			If no more rows are available, a No Data condition occurs with SQLSTATE 
# 			value '02000'
#
# 			To detect this condition, you can set up a handler for it or for a NOT FOUND
# 			condition.
#
# 				DECLARE CONTINUE HANDLER FOR NOT FOUND
# 					BEGIN
# 						-- body of handler
# 					END;
#
# 			For another example, see SECTION 13.6.6, "CURSORS"
#
# 			The NOT FOUND condition also occurs for SELECT --- INTO var_list statements
# 			that retrieve no rows.
#
# 		) SQLEXCEPTION:
#
# 			Shorthand for the class of SQLSTATE values that do not begin with 
# 			'00', '01', or '02'
#
# 				DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 					BEGIN
# 						-- body of handler
# 					END;
#
# For information about how the server chooses handlers when a condition occurs,
# see SECTION 13.6.7.6, "SCOPE RULES FOR HANDLERS"
#
# If a condition occurs for which no handler has been declared, the action taken
# depends on the condition class:
#
# 		) For SQLEXCEPTION conditions, the stored program terminates at the statement
# 			that raised the condition, as if there were an EXIT handler.
#
# 			If the program was called by another stored program, the calling program
# 			handles the condition using the handler selection rules applied to
# 			its own handlers.
#
# 		) For SQLWARNING conditions, the program continues executing, as if there were a CONTINUE handler.
#
# 		) For NOT FOUND conditions, if the condition was raised normally, the action is CONTINUE.
#
# 			If it was raised by SIGNAL or RESIGNAL, the action is EXIT.
#
# The following example uses a handler for SQLSTATE '23000', which occurs for a 
# duplicate-key error:
#
# 		CREATE TABLE test.t (s1 INT, PRIMARY KEY (s1));
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		delimiter //
#
# 		CREATE PROCEDURE handlerdemo ()
# 		BEGIN
# 			DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @x2 = 1;
# 			SET @x = 1;
# 			INSERT INTO test.t VALUES (1);
# 			SET @x = 2;
# 			INSERT INTO test.t VALUES (1);
# 			SET @x = 3;
# 		END;
# 		//
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		CALL handlerdemo()//
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT @x//
# 		+------------+
# 		| @x 			 |
# 		+------------+
# 		| 3 			 |
# 		+------------+
# 		1 row in set (0.00 sec)
#
# Notice that @x is 3 after the procedure executes, which shows that execution continued
# to the end of the procedure after the error occurred.
#
# If the DECLARE_---_HANDLER statement had not been present, MySQL would have taken the
# default action (EXIT) after the second INSERT failed due to the PRIMARY KEY constraint,
# and SELECT @x would have returned 2.
#
# To ignore a condition, declare a CONTINUE handler for it and associate it with an empty block.
#
# For example:
#
# 		DECLARE CONTINUE HANDLER FOR SQLWARNING BEGIN END;
#
# The scope of a block label does not include the code for handlers declared within the block.
#
# Therefore, the statement associated with a handler cannot use ITERATE or LEAVE to refer
# to labels for blocks that enclose the handler declaration.
#
# Consider the following example, where the REPEAT block has a label of retry:
#
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE i INT DEFAULT 3;
# 			retry:
# 				REPEAT
# 					BEGIN
# 						DECLARE CONTINUE HANDLER FOR SQLWARNING
# 							BEGIN
# 								ITERATE retry; #Illegal
# 							END;
# 						IF i < 0 THEN
# 							LEAVE retry; #legal
# 						END IF;
# 						SET i = i - 1;
# 					END;
# 				UNTIL FALSE END REPEAT;
# 		END;
#
# The retry label is in scope for the IF statement within the block.
#
# It is not in scope for the CONTINUE handler, so the reference there is invalid
# and results in an error:
#
# 		ERROR 1308 (42000): LEAVE with no matching label: retry
#
# To avoid references to outer labels in handlers, use one of these strategies:
#
# 		) To leave the block, use an EXIT handler. If no block cleanup is required, the
# 			BEGIN_---_END handler body can be empty:
#
# 				DECLARE EXIT HANDLER FOR SQLWARNING BEGIN END;
#
# 			Otherwise, put the cleanup statements in the handler body:
#
# 				DECLARE EXIT HANDLER FOR SQLWARNING
# 					BEGIN
# 						block cleanup statements
# 					END;
#
# 		) To continue execution, set a status variable in a CONTINUE handler that can be checked
# 			in the enclosing block to determine whether the handler was invoked.
#
# 			The following example uses the variable done for this purpose:
#
# 				CREATE PROCEDURE p ()
# 				BEGIN
# 					DECLARE i INT DEFAULT 3;
# 					DECLARE done INT DEFAULT FALSE;
# 					retry:
# 						REPEAT
# 							BEGIN
# 								DECLARE CONTINUE HANDLER FOR SQLWARNING
# 									BEGIN
# 										SET done = TRUE;
# 									END;
# 								IF done OR i < 0 THEN
# 									LEAVE retry;
# 								END IF;
# 								SET i = i - 1;
# 							END;
# 						UNTIL FALSE END REPEAT;
# 				END; 
#
# 13.6.7.3 GET DIAGNOSTICS SYNTAX
#
# 		GET [CURRENT | STACKED] DIAGNOSTICS
# 		{
# 			statement_information_item
# 			[, statement_information_item] ---
# 		 | CONDITION condition_number
# 			condition_information_item
# 		 	[, condition_information_item] ---
# 		}
#
# 		statement_information_item:
# 			target = statement_information_item_name
#
# 		condition_information_item:
# 			target = condition_information_item_name
#
# 		statement_information_item_name:
# 			NUMBER
# 		 | ROW_COUNT
#
# 		condition_information_item_name: {
# 			CLASS_ORIGIN
# 		 | SUBCLASS_ORIGIN
# 		 | RETURNED_SQLSTATE
# 		 | MESSAGE_TEXT
# 		 | MYSQL_ERRNO
# 		 | CONSTRAINT_CATALOG
# 		 | CONSTRAINT_SCHEMA
# 		 | CONSTRAINT_NAME
# 		 | CATALOG_NAME
# 		 | SCHEMA_NAME
# 		 | TABLE_NAME
# 		 | COLUMN_NAME
# 		 | CURSOR_NAME
# 		}
#
# 		condition_number, target:
# 			(see following discussion)
#
# SQL statements produce diagnostic information that populates the diagnostics area.
#
# The GET_DIAGNOSTICS statement enables applications to inspect this information.
#
# (You can also use SHOW_WARNINGS or SHOW_ERRORS to see conditions or errors)
#
# No special privileges are required to execute GET_DIAGNOSTICS
#
# The keyword CURRENT means to retrieve information from the current diagnostics area.
#
# The keyword STACKED means to retrieve information from the second diagnostics
# area, which is available only if the current context is a condition handler.
#
# If neither keyword is given, the default is to use the current diagnostics area.
#
# The GET_DIAGNOSTICS statement is typically used in a handler within a stored program.
#
# It is a MySQL extension that GET_[CURRENT]_DIAGNOSTICS is permitted outside
# handler context to check the execution of any SQL statement.
#
# For example, if you invoke the mysql client program, you can enter these statements
# at the prompt:
#
# 		DROP TABLE test.no_such_table;
# 		ERROR 1051 (42S02): Unknown table 'test.no_such_table'
# 		GET DIAGNOSTICS CONDITION 1
# 			@p1 = RETURNED_SQLSTATE, @p2 = MESSSAGE_TEXT;
# 		SELECT @p1, @p2;
# 		+-------+------------------------------------+
# 		| @p1   | @p2 									      |
# 		+-------+------------------------------------+
# 		| 42S02 | Unknown table 'test.no_such_table' |
# 		+-------+------------------------------------+
#
# This extension applies only to the current diagnostics area.
#
# It does not apply to the second diagnostics area because GET STACKED DIAGNOSTICS
# is permitted only if the current context is a condition handler.
#
# If that is not the case, a:
#
# 	 GET STACKED DIAGNOSTICS when handler not active
#
# error occurs
#
# For a description of the diagnostics area, see SECTION 13.6.7.7, "THE MySQL DIAGNOSTICS AREA"
#
# Briefly, it contains two kinds of information:
#
# 		) Statement information, such as the number of conditions that occurred or the affected-rows count
#
# 		) Condition information, such as the error code and message.
#
# 			If a statement raises multiple conditions, this part of the diagnostics area has
# 			a condition area for each one.
#
# 			If a statement raises no conditions, this part of the diagnostics area is empty.
#
# For a statement that produces three conditions, the diagnostics area contains statement
# and condition information like this:
#
# 		Statement information:
# 			row count
# 			--- other statement information items ---
# 		Condition area list:
# 			Condition area 1:
# 				error code for condition 1
# 				error message for condition 1
# 				--- other condition information items ---
# 			Condition area 2:
# 				error code for condition 2:
# 				error message for condition 2
# 				--- other condition information items ---
# 			Condition area 3:
# 				error code for condition 3
# 				error message for condition 3
# 				--- other condition information items --
#
# GET_DIAGNOSTICS can obtain either statement or condition information, but not
# both in the same statement:
#
# 		) To obtain statement information, retrieve the desired statement items into target
# 			variables.
#
# 			This instance of GET_DIAGNOSTICS assigns the number of available conditions
# 			and the rows-affected count to the user variables @p1 and @p2:
#
# 				GET DIAGNOSTICS @p1 = NUMBER, @p2 = ROW_COUNT;
#
# 		) To obtain condition information, specify the condition number and retrieve the desired
# 			condition items into target variables.
#
# 			This instance of GET_DIAGNOSTICS assigns the SQLSTATE value and error message
# 			to the user variables @p3 and @p4:
#
# 				GET DIAGNOSTICS CONDITION 1
# 					@p3 = RETURNED_SQLSTATE, @p4 = MESSAGE_TEXT;
#
# The retreival list specifies one or more target = item_name assignments, separated by commas.
#
# Each assignment names a target variable and either a statement_information_item_name or
# condition_information_item_name designator, depending on whether the statement retrieves
# statement or condition information.
#
# Valid target designators for storing item information can be stored procedure or
# function parameters, stored program local variables declared with DECLARE,
# or user-defined variables.
#
# Valid condition_number designators can be stored procedure or function parameters,
# stored program local variables declared with DECLARE, user-defined variables,
# system variables, or literals.
#
# A character literal may include a _charset introducer.
#
# A warning occurs if the condition number is not in the range from 1 to the
# number of condition areas that have information.
#
# In this case, the warning is added to the diagnostics area without clearing it.
#
# When a condition occurs, MySQL does not populate all condition items recognized
# by GET_DIAGNOSTICS.
#
# For example:
#
# 		GET DIAGNOSTICS CONDITION 1
# 			@p5 = SCHEMA_NAME, @p6 = TABLE_NAME;
# 		SELECT @p5, @p6;
# 		+------+-----------+
# 		| @p5  | @p6 		 |
# 		+------+-----------+
# 		|  	 | 			 |
# 		+------+-----------+
#
# In standard SQL, if there are multiple conditions, the first condition relates
# to the SQLSTATE value returned for the previous SQL statement.
#
# In MySQL, this is not guaranteed.
#
# To get the main error, you cannot do this:
#
# 		GET DIAGNOSTICS CONDITION 1 @errno = MYSQL_ERRNO;
#
# Instead, retrieve the condition count first, then use it to specify
# which condition number to inspect:
#
# 		GET DIAGNOSTICS @cno = NUMBER;
# 		GET DIAGNOSTICS CONDITION @cno @errno = MYSQL_ERRNO;
#
# For information about permissible statement and condition information items,
# and which ones are populated when a condition occurs, see DIAGNOSTICS AREA INFORMATION ITEMS
#
# Here is an example that uses GET_DIAGNOSTICS and an exception handler in stored procedure
# context to assess the outcome of an insert operation.
#
# If the insert was successful, the procedure uses GET_DIAGNOSTICS to get the rows-affected
# count.
#
# This shows that you can use GET_DIAGNOSTICS multiple times to retrieve information about
# a statement as long as the current diagnostics area has not been cleared.
#
# 		CREATE PROCEDURE do_insert(value INT)
# 		BEGIN
# 			--- DECLARE variables to hold diagnostics area information
# 			DECLARE code CHAR(5) DEFAULT '00000';
# 			DECLARE msg TEXT;
# 			DECLARE rows INT;
# 			DECLARE result TEXT;
# 			-- Declare exception handler for failed insert
# 			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 				BEGIN
# 					GET DIAGNOSTICS CONDITION 1
# 						code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
# 				END;
#
# 			-- Perform the insert
# 			INSERT INTO t1 (int_col) VALUES(value);
# 			-- Check whether the insert was successful
# 			IF code = '00000' THEN
# 				GET DIAGNOSTICS rows = ROW_COUNT;
# 				SET result = CONCAT('insert succeeded, row count = ',rows);
# 			ELSE
# 				SET result = CONCAT('insert failed, error = ',code,', message = ',msg);
# 			END IF;
# 			-- Say what happened
# 			SELECT result;
# 		END;
#
# Suppose that t1.int_col is an integer column that is declared as NOT NULL.
#
# The procedure produces these results when invoked to insert non-NULL and
# NULL values, respectively:
#
# 		CALL do_insert(1);
# 		+---------------------------------+
# 		| result 							    |
# 		+---------------------------------+
# 		| insert succeeded, row count = 1 |
# 		+---------------------------------+
#
# 		CALL do_insert(NULL);
# 		+-------------------------------------------------------------------------+
# 		| result 																					  |
# 		+-------------------------------------------------------------------------+
# 		| insert failed, error = 23000, message = Column 'int_col' cannot be null |
# 		+-------------------------------------------------------------------------+
#
# When a condition handler activates, a push to the diagnostics area stack occurs:
#
# 		) The first (current) diagnostics area becomes the second (stacked) diagnostics area
# 			and a new current diagnostics area is created as a copy of it.
#
# 		) GET_[CURRENT]_DIAGNOSTICS and GET_STACKED_DIAGNOSTICS can be used within the handler
# 			to access the contents of the current and stacked diagnostics areas.
#
# 		) Initially, both diagnostics areas return the same result, so it is possible to get
# 			information from the current diagnostics area about the condition that activated
# 			the handler, as long as you execute no statements within the handler that change
# 			its current diagnostics area.
#
# 		) However, statements executing within the handler can modify the current diagnostics area,
# 			clearing and setting its contents according to the normal rules (see HOW THE DIAGNOSTICS AREA IS CLEARED AND POPULATED)
#
# 			A more reliable way to obtain information about the handler-activating condition is to use the
# 			stacked diagnostics area, which cannot be modified by statements executing within the handler
# 			except RESINGAL.
#
# 			For information about when the current diagnostics area is set and cleared, see
# 			SECTION 13.6.7.7, "THE MYSQL DIAGNOSTICS AREA"
#
# The next example shows how GET STACKED DIAGNOSTICS can be used within a handler to obtain
# information about the handled exception, even after the current diagnostics area has been
# modified by handler statements.
#
# Within a stored procedure p(), we attempt to insert two values into a table that contains a
# TEXT NOT NULL column.
#
# The first value is a non-NULL string and the second is NULL
#
# The column prohibits NULL values, so the first insert succeeds but the
# second causes an exception.
#
# The procedure includes an exception handler that maps attempts to insert
# NULL into inserts of the empty string:
#
# 		DROP TABLE IF EXISTS t1;
# 		CREATE TABLE t1 (c1 TEXT NOT NULL);
# 		DROP PROCEDURE IF EXISTS p;
# 		delimiter //
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			-- Declare variables to hold diagnostics area information
# 			DECLARE errcount INT;
# 			DECLARE errno INT;
# 			DECLARE msg TEXT;
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTIOn
# 			BEGIN
# 				-- Here the current DA is nonempty because no prior statements
# 				-- executing within the handler have cleared it
# 				GET CURRENT DIAGNOSTICS CONDITION 1
# 					errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 				SELECT 'current DA before mapped insert' AS op, errno, msg;
# 				GET STACKED DIAGNOSTICS CONDITION 1
# 					errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 				SELECT 'stacked DA before mapped insert' AS op, errno, msg;
#
# 				-- Map attempted NULL insert to empty string insert
# 				INSERT INTO t1 (c1) VALUES('');
#
# 				-- Here the current DA should be empty (if the INSERT succeeded),
# 				-- so check whether there are conditions before attempting to
# 				-- obtain condition information
# 				GET CURRENT DIAGNOSTICS errcount = NUMBER;
# 				IF errcount = 0
# 				THEN
# 					SELECT 'mapped insert succeeded, current DA is empty' AS op;
# 				ELSE
# 					GET CURRENT DIAGNOSTICS CONDITION 1
# 						errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 					SELECT 'current DA after mapped insert' AS op, errno, msg;
# 				END IF ;
# 				GET STACKED DIAGNOSTICS CONDITION 1
# 					errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 				SELECT 'stacked DA after mapped insert' AS op, errno, msg;
# 			END;
# 			INSERT INTO t1 (c1) VALUES('string 1');
# 			INSERT INTO t1 (c1) VALUES(NULL);
# 		END;
# 		//
# 		delimiter ;
# 		CALL p();
# 		SELECT * FROM t1;
#
# When the handler activates, a copy of the current diagnostics area is pushed to the
# diagnostics area stack.
#
# The handler first displays the contents of the current and stacked diagnostics areas,
# which are both the same initially:
#
# 		+-------------------------------------------+-----------+-------------------------------------+
# 		| op 													  | errno 	  | msg 											 |
# 		+-------------------------------------------+-----------+-------------------------------------+
# 		| current DA before mapped insert 			  | 1048 	  | Column 'c1' cannot be null 			 |
# 		+-------------------------------------------+-----------+-------------------------------------+
#
# 		+-------------------------------------------+-----------+-------------------------------------+
# 		| op 													  | errno 	  | msg 											 |
# 		+-------------------------------------------+-----------+-------------------------------------+
# 		| stacked DA before mapped insert 			  | 1048 	  | Column 'c1' cannot be null 			 |
# 		+-------------------------------------------+-----------+-------------------------------------+
#
# Statements executing after the GET_DIAGNOSTICS statements may reset the current diagnostics area.
#
# Statements may reset the current diagnostics area.
#
# For example, the handler maps the NULL insert to an empty string insert and displays the result.
#
# The new insert succeeds and clears the current diagnostics area, but the stacked diagnostics
# area remains unchanged and still contains information about the condition that activated the handler:
#
# 		+-----------------------------------------------+
# 		| op 															|
# 		+-----------------------------------------------+
# 		| mapped insert succeeded, current DA is empty  |
# 		+-----------------------------------------------+
#
# 		+-----------------------------------------------+---------+--------------------------------+
# 		| op 															| errno 	 | msg 									 |
# 		+-----------------------------------------------+---------+--------------------------------+
# 		| stacked DA after mapped insert 					| 1048 	 | Column 'c1' cannot be null     |
# 		+-----------------------------------------------+---------+--------------------------------+
#
# When the condition handler ends, its current diagnostics area is popped from the stack and the stacked
# diagnostics area becomes the current diagnostics area in the stored procedure.
#
# After the procedure returns, the table contains two rows.
#
# The empty row results from the attempt to insert NULL that was mapped to an empty string insert:
#
# 		+---------------+
# 		| c1 				 |
# 		+---------------+
# 		| string 1 		 |
# 		| 					 |
# 		+---------------+
#
# In the preceding example, the first two GET_DIAGNOSTICS statements within the condition handler
# that retrieve information from the current and stacked diagnostics areas return the same values.
#
# This will not be the case if statements that reset the current diagnostics area execute earlier
# within the handler.
#
# Suppose that p() is rewritten to place the DECLARE statements within the handler definition
# rather than preceding it:
#
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION
# 			BEGIN
# 				-- Declare variables to hold diagnostics area information
# 				DECLARE errcount INT;
# 				DECLARE errno INT;
# 				DECLARE msg TEXT;
# 				GET CURRENT DIAGNOSTICS CONDITION 1
# 					errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 				SELECT 'current DA before mapped insert' AS op, errno, msg;
# 				GET STACKED DIAGNOSTICS CONDITION 1
# 					errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
# 				SELECT 'stacked DA before mapped insert' AS op, errno, msg;
# 		---
#
# In this case, the result is version dependent:
#
# 		) Before MySQL 5.7.2, DECLARE does not change the current diagnostics area, so the first two
# 			GET_DIAGNOSTICS statements return the same result, just as in the original version of p()
#
# 			In MySQL 5.7.2, work was done to ensure that all nondiagnostic statements populate the
# 			diagnostics area, per the SQL standard.
#
# 			DECLARE is one of them, so in 5.7.2 and higher, DECLARE statements executing at the 
# 			beginning of the handler clear the current diagnostics area and the GET_DIAGNOSTICS
# 			statements produce different results:
#
# 				+-----------------------------------+-----------+-----------+
# 				| op 											| errno 	   | msg 		|
# 				+-----------------------------------+-----------+-----------+
# 				| current DA before mapped insert   | NULL 		| NULL 		|
# 				+-----------------------------------+-----------+-----------+
#
# 				+-----------------------------------+-----------+---------------------------------------+
# 				| op 											| errno 	   | msg 											 |
# 				+-----------------------------------+-----------+---------------------------------------+
# 				| stacked DA before mapped insert   | 1048 		| Column 'c1' cannot be null 				 |
# 				+-----------------------------------+-----------+---------------------------------------+
#
# To avoid this issue within a condition handler when seeking to obtain information about the condition
# that activated the handler, be sure to access the stacked diagnostics area, not the current
# diagnostics area.
#
# 13.6.7.4 RESIGNAL SYNTAX
#
# 		RESIGNAL [condition_value]
# 			[SET signal_information_item
# 			[, signal_information_item] ---]
#
# 		condition_value: {
# 			SQLSTATE [VALUE] sqlstate_value
# 		 | condition_name
# 		}
#
# 		signal_information_item:
# 			condition_information_item_name = simple_value_specification
#
# 		condition_information_item_name: {
# 			CLASS_ORIGIN
# 		 | SUBCLASS_ORIGIN
# 		 | MESSAGE_TEXT
# 		 | MYSQL_ERRNO
# 		 | CONSTRAINT_CATALOG
# 		 | CONSTRAINT_SCHEMA
# 		 | CONSTRAINT_NAME
# 		 | CATALOG_NAME
# 		 | SCHEMA_NAME
# 		 | TABLE_NAME
# 		 | COLUMN_NAME
# 		 | CURSOR_NAME
# 		}
#
# 		condition_name, simple_value_specification:
# 			(see following discussion)
#
# RESIGNAL passes on the error condition information that is available during
# execution of a condition handler within a compound statement inside a stored
# procedure or function, trigger, or event.
#
# RESIGNAL may change some or all information before passing it on.
#
# RESIGNAL is related to SIGNAL, but instead of originating a condition
# as SIGNAL does, RESIGNAL relays existing condition information, possibly
# after modifying it.
#
# RESIGNAL makes it possible to both handle an error and return the error information.
#
# Otherwise, by executing an SQL statement within the handler, information that caused
# the handler's activation is destroyed.
#
# RESIGNAL also can make some procedures shorter if a given handler can handle part
# of a situation, then pass the condition "up the line" to another handler.
#
# No privileges are required to execute the RESIGNAL statement.
#
# All forms of RESIGNAL require that the current context be a condition handler.
#
# Otherwise, RESIGNAL is illegal and a:
#
# 		RESIGNAL when handler not active
#
# error occurs.
#
# To retrieve information from the diagnostics area, use the GET_DIAGNOSTICS
# statement (see SECTION 13.6.7.3, "GET DIAGNOSTICS SYNTAX")
#
# FOr information about the diagnostics area, see SECTION 13.6.7.7,
# "THE MYSQL DIAGNOSTICS AREA"
#
# 		) RESIGNAL OVERVIEW
#
# 		) RESIGNAL ALONE
#
# 		) RESIGNAL WITH NEW SIGNAL INFORMATION
#
# 		) RESIGNAL WITH A CONDITION VALUE AND OPTIONAL NEW SIGNAL INFORMATION
#
# 		) RESIGNAL REQUIRES CONDITION HANDLER CONTEXT
#
# RESIGNAL OVERVIEW
#
# For condition_value and signal_information_item, the definitions and rules are the same
# for RESIGNAL as for SIGNAL.
#
# For example, the condition_value can be an SQLSTATE value, and the value can indicate errors,
# warnings, or "not found".
#
# For additional information, see SECTION 13.6.7.5, "SIGNAL SYNTAX"
#
# The RESIGNAL statement takes condition_value and SET clauses, both of which are optional.
#
# This leads to several possible uses:
#
# 		) RESIGNAL alone:
#
# 			RESIGNAL;
#
# 		) RESIGNAL with new signal information:
#
# 			RESIGNAL SET signal_information_item [, signal_information_item] ---;
#
# 		) RESIGNAL with a condition value and possibly new signal information:
#
# 			RESIGNAL condition_value
# 				[SET signal_information_item [, signal_information_item] ---];
#
# These use cases all cause changes to the diagnostics and condition areas:
#
# 		) A diagnostics area contains one or more condition areas.
#
# 		) A condition area contains condition information items, such as the SQLSTATE value, MYSQL_ERRNO,
# 			or MESSAGE_TEXT
#
# There is a stack of diagnostics areas.
#
# When a handler takes control, it pushes a diagnostics area to the top of the stack, so there
# are two diagnostics areas during handler execution:
#
# 		) The first (current) diagnostics area, which starts as a copy of the last diagnostics area,
# 			but will be overwritten by the first statement in the handler that changes the current
# 			diagnostics area.
#
# 		) The last (stacked) diagnostics area, which has the condition areas that were set up before the handler
# 			took control.
#
# The maximum number of condition areas in a diagnostics area is determined by the value of the max_error_count
# system variable.
#
# See DIAGNOSTICS AREA-RELATED SYSTEM VARIABLES
#
# RESIGNAL ALONE
#
# A simple RESIGNAL alone means "pass on the error with no change."
#
# It restores the last diagnostics area and makes it the current diagnostics area.
#
# That is, it "Pops" the diagnostics area stack.
#
# Within a condition handler that catches a condition, one use for RESIGNAL alone is to
# perform some other actions, and then pass on without change the original condition
# information (the information that existed before entry into the handler)
#
# Example:
#
# 		DROP TABLE IF EXISTS xx;
# 		delimiter //
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION
# 			BEGIN
# 				SET @error_count = @error_count + 1;
# 				IF @a = 0 THEN RESIGNAL; END IF;
# 			END;
# 			DROP TABLE xx;
# 		END//
# 		delimiter ;
# 		SET @error_count = 0;
# 		SET @a = 0;
# 		CALL p();
#
# Suppose that the DROP TABLE xx statement fails. The diagnostics area stack looks like this:
#
# 		DA 1. ERROR 1051 (42S02): Unknown table 'xx'
#
# Then execution enters the EXIT handler. It starts by pushing a diagnostics area to the top of
# the stack, which now looks like this:
#
# 		DA 1. ERROR 1051 (42S02): Unknown table 'xx'
# 		DA 2. ERROR 1051 (42S02): Unknown table 'xx'
#
# At this point, the contents of the first (current) and second (stacked) diagnostics areas are
# teh same.
#
# The first diagnostics area may be modified by statements executing subsequently within
# the handler.
#
# Usually a procedure statement clears the first diagnostics area.
#
# BEGIN is an exception, it does not clear, it does nothing.
#
# SET is not an exception, it clears,performs the operation, and produces a result of
# "success"
#
# The diagnostics area stack now looks like this:
#
# 		DA 1. ERROR 0000 (00000): Successful operation
# 		DA 2. ERROR 1051 (42S02): Unknown table 'xx'
#
# At this point, if @a = 0, RESIGNAL pops the diagnostics area stack, which now looks
# like this:
#
# 		DA 1. ERROR 1051 (42S02): Unknown table 'xx'
#
# And that is what the caller sees.
#
# If @a is not 0, the handler simply ends, which means that there is no more use for the
# current diagnostics area (it has been "handled"), so it can be thrown away, causing
# the stacked diagnostics area to become the current diagnostics area again.
#
# The diagnostics area stack looks like this:
#
# 		DA 1. ERROR 0000 (00000): Successful operation
#
# The details make it look complex, but the end result is quite useful:
#
# 		Handlers can execute without destroying information about the condition
# 		that caused activation of the handler.
#
# RESIGNAL WITH NEW SIGNAL INFORMATION
#
# RESIGNAL with a SET clause provides new signal information, so the statement means
# "pass on the error with changes"
#
# 		RESIGNAL SET signal_information_item [, signal_information_item] ---;
#
# As with RESIGNAL alone the idea is to pop the diagnostics area stack so that
# the original information will go out.
#
# Unlike RESIGNAL alone, anything specified in the SET clause changes.
#
# Example:
#
# 		DROP TABLE IF EXISTS xx;
# 		delimiter //
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION
# 			BEGIN
# 				SET @error_count = @error_count + 1;
# 				IF @a = 0 THEN RESIGNAL SET MYSQL_ERRNO = 5; END IF;
# 			END;
# 			DROP TABLE xx;
# 		END//
# 		delimiter ;
# 		SET @error_count = 0;
# 		SET @a = 0;
# 		CALL p();
#
# Remember from the previous discussion that RESIGNAL alone results in a diagnostics
# area stack like this:
#
# 		DA 1. ERROR 1051 (42S02): Unknown table 'xx'
#
# The RESIGNAL SET MYSQL_ERRNO = 5 statement results in this stack instead, which is what the caller sees:
#
# 		DA 1. ERROR 5 (42S02): Unknown table 'xx'
#
# In other words, it changes the error number, and nothing else.
#
# The RESIGNAL statement can change any or all of the signal information items, making
# the first condition area of the diagnostics area look quite different.
#
# RESIGNAL WITH A CONDITION VALUE AND OPTIONAL NEW SIGNAL INFORMATION
#
# RESIGNAL with a condition value means "push a condition into the current diagnostics area"
#
# If the SET clause is present, it also changes the error information.
#
# 		RESIGNAL condition_value
# 			[SET signal_information_item [, signal_information_item] ---];
#
# This form of RESIGNAL restores the last diagnostics area and makes it the current
# diagnostics area.
#
# That is, it "pops" the diagnostics area stack, which is the same as what a simple
# RESIGNAL alone would do.
#
# However, it also changes the diagnostics area depending on the condition value or
# signal information.
#
# Example:
#
# 		DROP TABLE IF EXISTS xx;
# 		delimiter //
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION
# 			BEGIN
# 				SET @error_count = @error_count + 1;
# 				IF @a = 0 THEN RESIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=5; END IF;
# 			END;
# 			DROP TABLE xx;
# 		END//
# 		delimiter ;
# 		SET @error_count = 0;
# 		SET @a = 0;
# 		SET @@max_error_count = 2;
# 		CALL p();
# 		SHOW ERRORS;
#
# This is similar to the previous example, and the effects are the same, except that if
# RESIGNAL happens, the current condition area looks different at the end.
#
# (The reason the condition adds to rather than replaces the existing condition is the
# use of a condition value)
#
# The RESIGNAL statement includes a condition value (SQLSTATE '45000'), so it adds a new
# condition area, resulting in a diagnostics area stack that looks like this:
#
# 		DA 1. (condition 2) ERROR 1051 (42S02): Unknown table 'xx'
# 				(condition 1) ERROR 5 (45000) Unknown table 'xx'
#
# The result of CALL_p() and SHOW_ERRORS for this example is:
#
# 		CALL p();
# 		ERROR 5 (45000): Unknown table 'xx'
# 		SHOW ERRORS;
# 		+--------+---------+--------------------------------------------------+
# 		| Level  | Code    | Message 														 |
# 		+--------+---------+--------------------------------------------------+
# 		| Error  | 1051 	 | Unknown table 'xx' 										 |
# 		| Error  | 5 		 | Unknown table 'xx' 										 |
# 		+--------+---------+--------------------------------------------------+
#
# RESIGNAL REQUIRES CONDITION HANDLER CONTEXT
#
# All forms of RESIGNAL require that the current context be a condition handler.
#
# Otherwise, RESIGNAL is illegal and a RESIGNAL when handler not active error
# occurs.
#
# For example:
#
# 		CREATE PROCEDURE p () RESIGNAL;
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		CALL p();
# 		ERROR 1645 (0K000): RESIGNAL when handler not active
#
# Here is a more dificult example:
#
# 		delimiter //
# 		CREATE FUNCTION f () RETURNS INT
# 		BEGIN
# 			RESIGNAL;
# 			RETURN 5;
# 		END//
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @a=f();
# 			SIGNAL SQLSTATE '55555';
# 		END//
# 		delimiter ;
# 		CALL p();
#
# RESIGNAL occurs within the stored function f()
#
# Although f() itself is invoked within the context of the EXIT handler, execution
# within f() has its own context, which is not handler context.
#
# Thus, RESIGNAL within f() results in a "handler not active" error.
#
# 13.6.7.5 SIGNAL SYNTAX
#
# 		SIGNAL condition_value
# 			[SET signal_information_item
# 			[, signal_information_item] ---]
#
# 		condition_value: {
# 			SQLSTATE [VALUE] sqlstate_value
# 		 | condition_name
# 		}
#
# 		signal_information_item:
# 			condition_information_item_name = simple_value_specification
#
# 		condition_information_item_name: {
# 			CLASS_ORIGIN
# 		 | SUBCLASS_ORIGIN
# 		 | MESSAGE_TEXT
# 		 | MYSQL_ERRNO
# 		 | CONSTRAINT_CATALOG
# 		 | CONSTRAINT_SCHEMA
# 		 | CONSTRAINT_NAME
# 		 | CATALOG_NAME
# 		 | SCHEMA_NAME
# 		 | TABLE_NAME
# 		 | COLUMN_NAME
# 		 | CURSOR_NAME
# 		}
#
# 		condition_name, simple_value_specification:
# 			(see following discussion)
#
# SIGNAL is the way to "return" an error.
#
# SIGNAL provides error information to a handler, to an outer portion
# of the application, or to the client.
#
# Also, it provides control over the error's characteristics (error number,
# SQLSTATE value, message)
#
# Without SIGNAL, it is necessary to resort to workarounds such as deliberately
# referring to a nonexistent table to cause a routine to return an error.
#
# No privileges are required to execute the SIGNAL statement.
#
# To retrieve information from the diagnostics area, use the GET_DIAGNOSTICS
# statement (see SECTION 13.6.7.3, "GET DIAGNOSTICS SYNTAX")
#
# For information about the diagnostics area, see SECTION 13.6.7.7, "THE MYSQL DIAGNOSTICS AREA"
#
# 		) SIGNAL OVERVIEW
#
# 		) SIGNAL CONDITION INFORMATION ITEMS
#
# 		) EFFECT OF SIGNALS ON HANDLERS, CURSORS AND STATEMENTS
#
# SIGNAL OVERVIEW
#
# The condition_value in a SIGNAL statement indicates the error value to be returned.
#
# It can be an SQLSTATE value (a 5-character string literal) or a condition_name
# that refers to a named condition previously defined with DECLARE_---_CONDITION
# (See SECTION 13.6.7.1, "DECLARE --- CONDITION SYNTAX")
#
# An SQLSTATE value can indicate errors, warnings, or "not found"
#
# The first two characters of the value indicates its error class, as discussed
# in SIGNAL CONDITION INFORMATION ITEMS.
#
# Some signal values cause statement termination: see EFFECT OF SIGNALS ON HANDLERS, CURSORS AND STATEMENTS
#
# The SQLSTATE value for a SIGNAL statement should not start with '00' because such values
# indicate success and are not valid for signaling an error.
#
# This is true whether the SQLSTATE value is specified directly in the SIGNAL statement or in
# a named condition referred to in the statement.
#
# If the value is invalid, a BAD SQLSTATE error occurs.
#
# To signal a generic SQLSTATE value, use '45000', which means "unhandled user-defined exception"
#
# The SIGNAL statement optionally includes a SET clause that contains multiple signal items,
# in a list of condition_information_item_name = simple_value_specification assignments,
# separated by commas.
#
# Each condition_information_item_name may be specified only once in the SET clause.
#
# Otherwise, a Duplicate condition information item error occurs.
#
# Valid simple_value_specification designators can be specified using stored procedure
# or function parameters, stored program local variables declared with DECLARE,
# user-defined variables, system variables, or literals.
#
# A character literal may include a _charset introducer.
#
# For information about permissible condition_information_item_name values, see SIGNAL CONDITION INFORMATION ITEMS
#
# The following procedure signals an error or warning depending on the value of pval, its
# input parameter:
#
# 		CREATE PROCEDURE p (pval INT)
# 		BEGIN
# 			DECLARE speciality CONDITION FOR SQLSTATE '45000';
# 			IF pval = 0 THEN
# 				SIGNAL SQLSTATE '01000';
# 			ELSEIF pval = 1 THEN
# 				SIGNAL SQLSTATE '45000'
# 					SET MESSAGE_TEXT = 'An error occurred';
# 			ELSEIF pval = 2 THEN
# 				SIGNAL speciality
# 					SET MESSAGE_TEXT = 'An error occurred';
# 			ELSE
# 				SIGNAL SQLSTATE '01000'
# 					SET MESSAGE_TEXT = 'A warning occurred', MYSQL_ERRNO = 1000;
# 				SIGNAL SQLSTATE '45000'
# 					SET MESSAGE_TEXT = 'An error occurred', MYSQL_ERRNO = 1001;
# 			END IF;
# 		END;
#
# If pval is 0, p() signals a warning because SQLSTATE values that begin with '01' are signals
# in the warning class.
#
# The warning does not terminate the procedure, and can be seen with SHOW_WARNINGS after the
# procedure returns.
#
# If pval is 1, p() signals an error and sets the MESSAGE_TEXT condition information item.
#
# The error terminates the procedure, and the text is returned with the error information.
#
# If pval is 2, the same error is signaled, although the SQLSTATE value is specified using
# a named condition in this case.
#
# If pval is anything else, p() first signals a warning and sets the message text and error
# number condition information items.
#
# This warning does not terminate the procedure, so execution continues and p() then signals
# an error.
#
# The error does terminate the procedure. The message text and error number set by the warning
# are replaced by the values set by the error, which are returned with the error information.
#
# SIGNAL is typically used within stored programs, but it is a MySQL extension that it is permitted
# outside handler context.
#
# For example, if you invoke the mysql client program, you can enter any of these statements
# at the prompt:
#
# 		SIGNAL SQLSTATE '77777';
#
# 		CREATE TRIGGER t_bi BEFORE INSERT ON t
# 			FOR EACH ROW SIGNAL SQLSTATE '77777';
#
# 		CREATE EVENT e ON SCHEDULE EVERY 1 SECOND
# 			DO SIGNAL SQLSTATE '77777';
#
# SIGNAL executes according to the following rules:
#
# 	If the SIGNAL statement indicates a particular SQLSTATE value, that value is used to
# 	signal the condition specified.
#
# Example:
#
# 		CREATE PROCEDURE p (divisor INT)
# 		BEGIN
# 			IF divisor = 0 THEN
# 				SIGNAL SQLSTATE '22012';
# 			END IF;
# 		END;
#
# If the SIGNAL statement uses a named condition, the condition must be declared in some
# scope that applies to the SIGNAL statement, and must be defined using an SQLSTATE value,
# not a MySQL error number.
#
# Example:
#
# 		CREATE PROCEDURE p (divisor INT)
# 		BEGIN
# 			DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
#			IF divisor = 0 THEN
# 				SIGNAL divide_by_zero;
# 			END IF;
# 		END;
#
# If the named condition does not exist in the scope of the SIGNAL statement, an 
# Undefined CONDITION error occurs.
#
# If SIGNAL refers to a named condition that is defined with a MySQL error number rather
# than an SQLSTATE value, a:
#
# 	 SIGNAL/RESIGNAL can only use a CONDITION defined with SQLSTATE error
#
# occurs.
#
# The following statements cause that error because the named condition is associated
# with a MySQL error number:
#
# 		DECLARE no_such_table CONDITION FOR 1051;
# 		SIGNAL no_such_table;
#
# If a condition with a given name is declared multiple times in different scopes,
# the declaration with the most local scope applies.
#
# Consider the following procedure:
#
# 		CREATE PROCEDURE p (divisor INT)
# 		BEGIN
# 			DECLARE my_error CONDITION FOR SQLSTATE '45000';
# 			IF divisor = 0 THEN
# 				BEGIN
# 					DECLARE my_error CONDITION FOR SQLSTATE '22012';
# 					SIGNAL my_error;
# 				END;
# 			END IF;
# 			SIGNAL my_error;
# 		END;
#
# If divisor is 0, the first SIGNAL statement executes.
#
# The innermost my_error condition declaration applies, raising SQLSTATE '22012'
#
# If divisor is not 0, the second SIGNAL statement executes. The outermost my_error
# condition declaration applies, raising SQLSTATE '45000'
#
# For information about how the server chooses handlers when a condition occurs,
# see SECTION 13.6.7.6, "SCOPE RULES FOR HANDLERS"
#
# Signals can be raised within exception handlers:
#
# 		CREATE PROCEDURE p ()
# 		BEGIN
# 			DECLARE EXIT HANDLER FOR SQLEXCEPTION
# 			BEGIN
# 				SIGNAL SQLSTATE VALUE '99999'
# 					SET MESSAGE_TEXT = 'An error occurred';
# 			END;
# 			DROP TABLE no_such_table;
# 		END;
#
# CALL p() reaches the DROP_TABLE statement.
#
# There is no table named no_such_table, so the error handler is activated.
#
# The error handler destroys the original error ("No such table") and makes a
# new error with SQLSTATE '99999' and message An error occurred.
#
# SIGNAL CONDITION INFORMATION ITEMS
#
# The following table lists the names of diagnostics area condition information items
# that can be set in a SIGNAL (or RESIGNAL) statement.
#
# All items are standard SQL except MYSQL_ERRNO, which is a MySQL extension.
#
# For more information about these items see SECTION 13.6.7.7, "THE MYSQL DIAGNOSTICS AREA"
#
# 		Item Name 					Definition
# 		---------- 					----------
# 		CLASS_ORIGIN 				VARCHAR(64)
# 		SUBCLASS_ORIGIN 			VARCHAR(64)
#
# 		CONSTRAINT_CATALOG 		VARCHAR(64)
# 		CONSTRAINT_SCHEMA 		VARCHAR(64)
#
# 		CONSTRAINT_NAME 			VARCHAR(64)
# 		CATALOG_NAME 				VARCHAR(64)
#
# 		SCHEMA_NAME 				VARCHAR(64)
# 		TABLE_NAME 					VARCHAR(64)
#
# 		COLUMN_NAME 				VARCHAR(64)
# 		CURSOR_NAME 				VARCHAR(64)
#
# 		MESSAGE_TEXT 				VARCHAR(128)
# 		MYSQL_ERRNO 				SMALLINT UNSIGNED
#
# The character set of character items is UTF-8
#
# It is illegal to assign NULL to a condition information item in a SIGNAL statement.
#
# A SIGNAL statement always specifies an SQLSTATE value, either directly, or indirectly
# by referring to a named condition defined with an SQLSTATE value.
#
# The first two characters of an SQLSTATE value are its class, and the class
# determines the default value for the condition information items:
#
# 		) Class = '00' (success)
#
# 			Illegal. SQLSTATE values that begin with '00' indicate success and are not valid for SIGNAL
#
# 		) Class = '01' (warning)
#
# 			MESSAGE_TEXT = 'Unhandled user-defined warning condition';
# 			MYSQL_ERRNO = ER_SIGNAL_WARN
#
# 		) Class = '02' (not found)
#
# 			MESSAGE_TEXT = 'Unhandled user-defined not found condition';
# 			MYSQL_ERRNO = ER_SIGNAL_NOT_FOUND
#
# 		) Class > '02' (exception)
#
# 			MESSAGE_TEXT = 'Unhandled user-defined exception condition';
# 			MYSQL_ERRNO = ER_SIGNAL_EXCEPTION
#
# For legal classes, the other condition information items are set as follows:
#
# 		CLASS_ORIGIN = SUBCLASS_ORIGIN = '';
# 		CONSTRAINT_CATALOG = CONSTRAINT_SCHEMA = CONSTRAINT_NAME = '';
# 		CATALOG_NAME = SCHEMA_NAME = TABLE_NAME = COLUMN_NAME = '';
# 		CURSOR_NAME = '';
#
# The error values that are accessible after SIGNAL executes are the SQLSTATE value
# raised by the SIGNAL statement and the MESSAGE_TEXT and MySQL_ERRNO items.
#
# These values are available from the C API:
#
# 		) mysql_sqlstate() returns the SQLSTATE value
#
# 		) mysql_errno() returns the MYSQL_ERRNO value
#
# 		) mysql_error() returns the MESSAGE_TEXT value
#
# At the SQL level, the output from SHOW_WARNINGS and SHOW_ERRORS indicates the MYSQL_ERRNO
# and MESSAGE_TEXT values in the Code and Message columns.
#
# To retrieve information from the diagnostics area, use the GET_DIAGNOSTICS statement
# (see SECTION 13.6.7.3, "GET DIAGNOSTICS SYNTAX")
#
# For information about the diagnostics area, see SECTION 13.6.7.7, "THE MYSQL DIAGNOSTICS AREA"
#
# EFFECT OF SIGNALS ON HANDLERS, CURSORS, AND STATEMENTS
#
# Signals have different effects on statement execution depending on the signal class.
#
# The class determines how severe an error is. MySQL ignores the value of the sql_mode
# system variable; in particular, strict SQL mode does not matter.
#
# MySQL also ignores IGNORE: The intent of SIGNAL is to raise a user-generated error
# explicitly, so a signal is never ignored.
#
# In the following descriptions, "unhandled" means that no handler for the signaled
# SQLSTATE value has been defined with DECLARE_---_HANDLER
#
# 		) Class = '00' (success)
#
# 			Illegal. SQLSTATE values that begin with '00' indicates success and are not valid for SIGNAL
#
# 		) Class = '01' (warning)
#
# 			The value of the warning_count system variable goes up.
#
# 			SHOW_WARNINGS shows the signal. SQLWARNING handlers catch the signal.
#
# 			Warnings cannot be returned from stored functions because the RETURN statement that causes
# 			the function to return clears the diagnostic area.
#
# 			The statement thus clears any warnings that may have been present there 
# 			(and resets warning_count to 0)
#
# 		) Class = '02' (not found)
#
# 			NOT FOUND handlers catch the signal.
#
# 			There is no effect on cursors. If the signal is unhandled in a stored function,
# 			statements end.
#
# 		) Class > '02' (exception)
#
# 			SQLEXCEPTION handlers catch the signal.
#
# 			if the signal is unhandled in a stored function, statements end.
#
# 		) Class = '40'
#
# 			Treated as an ordinary exception
#
# 13.6.7.6 SCOPE RULES FOR HANDLERS
#
# A stored program may include handlers to be invoked when certain conditions occur within
# the program.
#
# The applicability of each handler depends on its location within the program definition
# and on the condition or conditions that it handles:
#
# 		) A handler declared in a BEGIN_---_END block is in scope only for the SQL statements
# 			following the handler declarations in the block.
#
# 			If the handler itself raises a condition, it cannot handle that condition, nor 
# 			can any other handlers declared in the block.
#
# 			In the following example, handlers H1 and H2 are in scope for conditions
# 			raised by statements stmt1 and stmt2.
#
# 			But neither H1 nor H2 are in scope for conditions raised in the body of H1 or H2.
#
# 				BEGIN -- outer block
# 					DECLARE EXIT HANDLER FOR ---; --- handler H1
# 					DECLARE EXIT HANDLER FOR ---; --- handler H2
# 					stmt1;
# 					stmt2;
# 				END;
#
# 		) A handler is in scope only for the block in which it is declared, and cannot be
# 			activated for conditions occurring outside that block.
#
# 			In the following example, handler H1 is in scope for stmt1 in the inner block,
# 			but not for stmt2 in the outer block:
#
# 				BEGIN -- outer block
# 					BEGIN -- inner block
# 						DECLARE EXIT HANDLER FOR ---; --- handler H1
# 						stmt1;
# 					END;
# 					stmt2;
# 				END;
#
# 		) A handler can be specific or general.
#
# 			A specific handler is for a MySQL error code, SQLSTATE value, or condition name.
#
# 			A general handler is for a condition in the SQLWARNING, SQLEXCEPTION, or NOT FOUND
# 			class.
#
# 			Condition specificity is related to condition precedence, as described later.
#
# Multiple handlers can be declared in different scopes and with different specifities.
#
# For example, there might be a specific MySQL error code handler in an outer block,
# and a general SQLWARNING handler in an inner block.
#
# Or there might be handlers for a specific MySQL error code and the general SQLWARNING
# class in the same block.
#
# Whether a handler is activated depends not only on its own scope and condition value,
# but on what other handlers are present.
#
# When a condition occurs in a stored program, the server searches for applicable handlers
# in the current scope (current BEGIN_---_END block)
#
# If there are no applicable handlers, the search continues outward with the handlers
# in each successive containing scope (block).
#
# When the server finds one or more applicable handlers at a given scope, it chooses
# among them based on condition precdence:
#
# 		) A MySQL error code handler takes precedence over an SQLSTATE value handler
#
# 		) An SQLSTATE value handler takes precedence over general SQLWARNING, SQLEXCEPTION,
# 			or NOT FOUND handlers.
#
# 		) An SQLEXCEPTION handler takes precedence over an SQLWARNING handler
#
# 		) It is possible to have several applicable handlers with the same precedence.
#
# 			For example, a statement could generate multiple warnings with different#
# 			error codes, for each of which an error-specific handler exists.
#
# 			In this case, the choice of which handler the server activates is
# 			nondeterministic, and may change depending on the circumstances under which
# 			the condition occurs.
#
# One implication of the handler selection rules is that if multiple applicable handlers
# occur in different scopes, handlers with the most local scope take precedence
# over handlers in outer scopes, even over those for more specific conditions.
#
# If there is no appropriate handler when a condition occurs, the action taken depends
# on the class of the condition:
#
# 		) For SQLEXCEPTION conditions, the stored program terminates at the statement that
# 			raised the condition, as if there were an EXIT handler.
#
# 			If the program was called by another stored program, the calling program handles
# 			the condition using the handler selection rules applied to its own handlers.
#
# 		) For SQLWARNING conditions, the program continues executing, as if there were a CONTINUE handler
#
# 		) For NOT FOUND conditions, if the condition was raised normally, the action is CONTINUE.
#
# 			If it was raised by SIGNAL or RESIGNAL, the action is EXIT.
#
# The following examples demonstrate how MySQL applies the handler selection rules.
#
# This procedure contains two handlers, one for the specific SQLSTATE value ('42S02')
# that occurs for attempts to drop a nonexistent table, and one for the general
# SQLEXCEPTION class:
#
# 		CREATE PROCEDURE p1()
# 		BEGIN
# 			DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
# 				SELECT 'SQLSTATE handler was activated' AS msg;
# 			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 				SELECT 'SQLEXCEPTION handler was activated' AS msg;
#
# 			DROP TABLE test.t;
# 		END;
#
# Both handlers are declared in the same block and have the same scope.
#
# However, SQLSTATE handlers take precedence over SQLEXCEPTION handlers,
# so if the table t is nonexistent, the DROP_TABLE statement raises a condition
# that activates the SQLSTATE handler:
#
# 		CALL p1();
# 		+--------------------------------------+
# 		| msg 										   |
# 		+--------------------------------------+
# 		| SQLSTATE handler was activated 		|
# 		+--------------------------------------+
#
# This procedure contains the same two handlers. But this time, the DROP_TABLE statement
# and SQLEXCEPTION handler are in an inner block relative to the SQLSTATE handler:
#
# 		CREATE PROCEDURE p2()
# 		BEGIN -- outer block
# 				DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
# 					SELECT 'SQLSTATE handler was activated' AS msg;
# 			BEGIN -- inner block
# 				DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 					SELECT 'SQLEXCEPTION handler was activated' AS msg;
#
# 				DROP TABLE test.t; -- occurs within inner block
# 			END;
# 		END;
#
# In this case, the handler that is more local to where the condition occurs
# takes precedence.
#
# The SQLEXCEPTION handler activates, even though it is more general than the
# SQLSTATE handler:
#
# 		CALL p2();
# 		+-------------------------------------------------+
# 		| msg 														  |
# 		+-------------------------------------------------+
# 		| SQLEXCEPTION handler was activated 				  |
# 		+-------------------------------------------------+
#
# In this procedure, one of the handlers is declared in a block inner to the scope of the
# DROP_TABLE statement:
#
# 		CREATE PROCEDURE p3()
# 		BEGIN -- outer block
# 			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 				SELECT 'SQLEXCEPTION handler was activated' AS msg;
# 			BEGIN -- inner block
# 				DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
# 					SELECT 'SQLSTATE handler was activated' AS msg;
# 			END;
#
# 			DROP TABLE test.t; -- occurs within outer block
# 		END;
#
# Only the SQLEXCEPTION handler applies because the other one is not in scope
# for the condition raised by the DROP_TABLE:
#
# 		CALL p3();
# 		+------------------------------------------+
# 		| msg 												 |
# 		+------------------------------------------+
# 		| SQLEXCEPTION handler was activated 		 |
# 		+------------------------------------------+
#
# In this procedure, both handlers are declared in a block inner to the scope of the
# DROP_TABLE statement:
#
# 		CREATE PROCEDURE p4()
# 		BEGIN -- Outer block
# 			BEGIN -- Inner block
# 				DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
# 					SELECT 'SQLEXCEPTION handler was activated' AS msg;
# 				DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
# 					SELECT 'SQLSTATE handler was activated' AS msg;
# 			END;
#
# 			DROP TABLE test.t -- Occurs within outer block
# 		END;
#
# Neither handler applies because they are not in scope for the DROP_TABLE 
#
# The condition raised by the statement goes unhandled and terminates the procedure
# with an error:
#
# 		CALL p4();
# 		ERROR 1051 (42S02): UNKNOWN TABLE 'test.t'
#
# 13.6.7.7 THE MYSQL DIAGNOSTICS AREA
#
# SQL statements produce diagnostic information that populates the diagnostics area.
#
# Standard SQL has a diagnostics area stack, containing a diagnostics area for each
# nested execution context.
#
# Standard SQL also supports GET_STACKED_DIAGNOSTICS syntax for referring to the
# second diagnostics area during condition handler execution.
#
# The following discussion describes the structure of the diagnostics area in MySQL,
# the information items recognized by MySQL, how statements clear and set the
# diagnostics area, and how diagnostics areas are pushed to and popped from the stack.
#
# 		) DIAGNOSTICS AREA STRUCTURE
#
# 		) DIAGNOSTICS AREA INFORMATION ITEMS
#
# 		) HOW THE DIAGNOSTICS AREA IS CLEARED AND POPULATED
#
# 		) HOW THE DIAGNOSTICS AREA STACK WORKS
#
# 		) DIAGNOSTICS AREA-RELATED SYSTEM VARIABLES
#
# DIAGNOSTICS AREA STRUCTURE
#
# The diagnostics area contains two kinds of information:
#
# 		) Statement information, such as the number of conditions that occurred or the affected-rows
# 			count.
#
# 		) Condition information, such as the error code and message.
#
# 			If a statement raises multiple conditions, this part of the diagnostics area has
# 			a condition area for each one.
#
# 			If a statement raises no conditions, this part of the diagnostics area is empty.
#
# For a statement that produces three conditions, the diagnostics area contains statement
# and condition information like this:
#
# 		Statement information:
# 			row count
# 			--- other statement information items ---
# 		Condition area list:
# 			Condition area 1:
# 				error code for condition 1
# 				error message for condition 1
# 				--- other condition information items ---
# 			Condition area 2:
# 				error code for condition 2:
# 				error message for condition 2
# 				--- other condition information items ---
# 			Condition area 3:
# 				error code for condition 3
# 				error message for condition 3
# 				--- other condition information items ---
#
# DIAGNOSTICS AREA INFORMATION ITEMS
#
# The diagnostics area contains statement and condition information items.
#
# Numeric items are integers.
#
# The character set for character items is UTF-8. No item can be NULL.
#
# If a statement or condition item is not set by a statement that populates
# the diagnostics area, its value is 0 or the empty string, depending on the
# item data type.
#
# The statement information part of the diagnostics area contains these items:
#
# 		) NUMBER: An integer indicating the number of condition areas that have information
#
# 		) ROW_COUNT: An integer indicating the number of rows affected by the statement 
#
# 			ROW_COUNT has the same value as the ROW_COUNT() function (see SECTION 12.15,
# 			"INFORMATION FUNCTIONS")
#
# The condition information part of the diagnostics area contains a condition area for
# each condition.
#
# Condition areas are numbered from 1 to the value of the NUMBER statement condition
# item
#
# If NUMBER is 0, there are no condition areas
#
# Each condition area contains the items in the following list.
#
# All items are standard SQL except MySQL_ERRNO, which is a MySQL extension.
#
# The definitions apply for conditions generated other than by a signal (that is,
# by a SIGNAL or RESIGNAL statement)
#
# For nonsignal conditions, MySQL populates only those condition items not
# described as always empty.
#
# The effects of signals on the condition area are described later.
#
# 		) CLASS_ORIGIN: A string containing the class of the RETURNED_SQLSTATE value.
#
# 			If the RETURNED_SQLSTATE value begins with a class value defined in SQL
# 			standards document ISO 9075-2 (SECTION 24.1, SQLSTATE), CLASS_ORIGIN is 'ISO 9075'
#
# 			Otherwise, CLASS_ORIGIN is 'MySQL'
#
# 		) SUBCLASS_ORIGIN: A string containing the subclass of the RETURNED_SQLSTATE value.
#
# 			If CLASS_ORIGIN is 'ISO 9075' or RETURNED_SQLSTATE ends with '000'
#
# 			SUBCLASS_ORIGIN is 'ISO 9075'. Otherwise, SUBCLASS_ORIGIN is 'MySQL'
#
# 		) RETURNED_SQLSTATE: A string that indicates the SQLSTATE value for the condition
#
# 		) MESSAGE_TEXT: A string that indicates the error message for the condition
#
# 		) MYSQL_ERRNO: An integer that indicates the MySQL error code for the condition
#
# 		) CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME: Strings that indicate the catalog,
# 			schema, and name for a violated constraint.
#
# 			They are always empty.
#
# 		) CATALOG_NAME, SCHEMA_NAME, TABLE_NAME, COLUMN_NAME: Strings that indicate the catalog, schema, table,
# 			and column related to the condition.
#
# 			They are always empty.
#
# 		) CURSOR_NAME: A string that indicates the cursor name. This is always empty
#
# For the RETURNED_SQLSTATE, MESSAGE_TEXT and MYSQL_ERRNO values for particular errors,
# see SECTION B.3, "SERVER ERROR MESSAGE REFERENCE"
#
# If a SIGNAL (or RESIGNAL) statement populates the diagnostics area, its SET clause can
# assign to any condition information item except RETURNED_SQLSTATE any value that is
# legal for the item data type.
#
# SIGNAL also sets the RETURNED_SQLSTATE value, but not directly in its SET clause.
#
# That value comes from the SIGNAL statement SQLSTATE argument.
#
# SIGNAL also sets statement information items. It sets NUMBER to 1.
#
# It sets ROW_COUNT to -1 for errors and 0 otherwise.
#
# HOW THE DIAGNOSTICS AREA IS CLEARED AND POPULATED
#
# Nondiagnostic SQL statements populate the diagnostics area automatically,
# and its contents can be set explicitly with the SIGNAL and RESIGNAL statements.
#
# The diagnostics area can be examined with GET_DIAGNOSTICS to extract specific
# items, or with SHOW_WARNINGS or SHOW_ERRORS to see conditions of errors.
#
# SQL statements clear and set the diagnostics area as follows:
#
# 		) When the server starts executing a statement after parsing it, it clears the diagnostics
# 			area for nondiagnostic statements.
#
# 			Diagnostic statements do not clear the diagnostics area.
#
# 			These statements are diagnostic:
#
# 				) GET_DIAGNOSTICS
#
# 				) SHOW_ERRORS
#
# 				) SHOW_WARNINGS
#
# 		) If a statement raises a condition, the diagnostics area is cleared of conditions
# 			that belong to earlier statements.
#
# 			The exception is that conditions raised by GET DIAGNOSTICS and RESIGNAL
# 			are added to the diagnostics area without clearing it.
#
# Thus, even a statement that does not normally clear the diagnostics area when it begins
# executing clears it if the statement raises a condition.
#
# The following example shows the effect of various statements on the diagnostics area,
# using SHOW_WARNINGS to display information about conditions stored there.
#
# This DROP_TABLE statement clears the diagnostics area and populates it when the condition occurs:
#
# 		DROP TABLE IF EXISTS test.no_such_table;
# 		Query OK, 0 rows affected, 1 warning (0.01 sec)
#
# 		SHOW WARNINGS;
# 		+--------+-----------+----------------------------------------+
# 		| Level  | Code 		| Message 										  |
# 		+--------+-----------+----------------------------------------+
# 		| note   | 1051 		| Unknown table 'test.no_such_table' 	  |
# 		+--------+-----------+----------------------------------------+
# 		1 row in set (0.00 sec)
#
# This SET statement generates an error, so it clears and populates the
# diagnostics area:
#
# 		SET @x = @@x;
# 		ERROR 1193 (HY000): Unknown system variable 'x'
#
# 		SHOW WARNINGS;
# 		+--------+---------+-------------------------------------------+
# 		| Level  | Code 	 | Message 												|
# 		+--------+---------+-------------------------------------------+
# 		| Error  | 1193 	 | Unknown system variable 'x' 					|
# 		+--------+---------+-------------------------------------------+
# 		1 row in set (0.00 sec)
#
# The previous SET statement produced a single condition, so 1 is the only valid
# condition number for GET_DIAGNOSTICS at this point.
#
# The following statement uses a condition number of 2, which produces a warning
# that is added to the diagnostics area without clearing it:
#
# 		GET DIAGNOSTICS CONDITION 2 @p = MESSAGE_TEXT;
# 		Query OK, 0 rows affected, 1 warning (0.00 sec)
#
# 		SHOW WARNINGS;
# 		+-------+-----------+----------------------------------------+
# 		| Level | Code 	  | Message 										 |
# 		+-------+-----------+----------------------------------------+
# 		| Error | 1193 	  | Unknown system variable 'xx' 			 |
# 		| Error | 1753 	  | Invalid condition number 					 |
# 		+-------+-----------+----------------------------------------+
# 		2 rows in set (0.00 sec)
#
# Now there are two conditions in the diagnostics area, so the same 
# GET_DIAGNOSTICS statement succeeds:
#
# 		GET DIAGNOSTICS CONDITION 2 @p = MESSAGE_TEXT;
# 		Query OK, 0 rows affected (0.00 sec)
#
# 		SELECT @p;
# 		+-------------------------------------+
# 		| @p 											  |
# 		+-------------------------------------+
# 		| Invalid condition number 			  |
# 		+-------------------------------------+
# 		1 row in set (0.01 sec)
#
# HOW THE DIAGNOSTICS AREA STACK WORKS
#
# When a push to the diagnostics area stack occurs, the first (current) diagnostics area
# becomes the second (stacked) diagnostics area and a new current diagnostics area
# is created as a copy of it.
#
# Diagnostics areas are pushed to and popped from the stack under the following circumstances:
#
# 		) Execution of a stored program
#
# 			A push occurs before the program executes and a pop occurs afterward.
#
# 			If the stored program ends while handlers are executing, there can be more than
# 			one diagnostics area to pop; this occurs due to an exception for which there
# 			are no appropriate handlers or due to RETURN in the handler.
#
# 			Any warning or error conditions in the popped diagnostics areas then are added to the
# 			current diagnostics area, except that, for triggers, only errors are added.
#
# 			When the stored program ends, the caller sees these conditions in its current
# 			diagnostics area.
#
# 		) Execution of a condition handler within a stored program
#
# 			When a push occurs as a result of condition handler activation, the stacked
# 			diagnostics area is the area that was current within the stored program
# 			prior to the push.
#
# 			The new now-current diagnostics area is the handler's current diagnostics area.
#
# 			GET_[CURRENT]_DIAGNOSTICS and GET_STACKED_DIAGNOSTICS can be used within the
# 			handler to access the contents of the current (handler) and stacked (stored program)
# 			diagnostics areas.
#
# 			Initially, they return the same result, but statements executing within the
# 			handler modify the current diagnostics area, clearing and setting its contents
# 			according to the normal rules (see HOW THE DIAGNOSTICS AREA IS CLEARED AND POPULATED)
#
# 			The stacked diagnostics area cannot be modified by statements executing within the
# 			handler except RESIGNAL.
#
# 			If the handler executes successfully, the current (handler) diagnostics area is popped
# 			and the stacked (stored program) diagnostics area again becomes the current diagnostics area.
#
# 			Conditions added to the handler diagnostics area during handler execution are added to the
# 			current diagnostics area.
#
# 		) Execution of RESIGNAL
#
# 			The RESIGNAL statement passes on the error condition information that is available during
# 			execution of a condition handler within a compound statement inside a stored program.
#
# 			RESIGNAL may change some or all information before passing it on, modifying the diagnostics
# 			stack as described in SECTION 13.6.7.4, "RESIGNAL SYNTAX"
#
# DIAGNOSTICS AREA-RELATED SYSTEM VARIABLES
#
# Certain system variables control or are related to some aspects of the diagnostics area:
#
# 		) max_error_count controls the number of condition areas in the diagnostics area.
#
# 			If more conditions than this occur, MySQL silently discards information for the excess
# 			conditions.
#
# 			(Conditions added by RESIGNAL are always added, with older conditions being discarded
# 			as necessary to make room)
#
# 		) warning_count indicates the number of conditions that occurred.
#
# 			This includes errors, warnings, and notes.
#
# 			Normally, NUMBER and warning_count are teh same.
#
# 			However, as the number of conditions generated exceeds max_error_count,
# 			the value of warning_count continues to rise whereas NUMBER remains capped
# 			at max_error_count because no additional conditions are stored in the
# 			diagnostics area.
#
# 		) error_count indicates the number of errors that occurred.
#
# 			This value includes "not found" and exception conditions, but excludes
# 			warnings and notes.
#
# 			Like warning_count, its value can exceed max_error_count
#
# 		) If the sql_notes system variable is set to 0, notes are not stored and do
# 			not increment warning_count
#
# Example:
#
# 		If max_error_count is 10, the diagnostics area can contain a maximum of 10 condition areas.
#
# 		Suppose that a statement raises 20 conditions, 12 of which are errors.
#
# 		In that case, the diagnostics area contains the first 10 conditions, NUMBER
# 		is 10, warning_count is 20 and error_count is 12.
#
# Changes to the value of max_error_count have no effect until the next attempt to
# modify the diagnostics area.
#
# If the diagnostics area contains 10 condition areas and max_error_count is set
# to 5, that has no immediate effect on the size or content of the diagnostics area.
#
# 13.6.7.8 CONDITION HANDLING AND OUT OR INOUT PARAMETERS
#
# If a stored procedure exits with an unhandled exception, modified values of OUT and
# INOUT parameters are not propogated back to the caller.
#
# If an exception is handled by a CONTINUE or EXIT handler that contains a RESIGNAL
# statement, execution of RESIGNAL pops the Diagnostics Area stack, thus signalling the
# exception (that is, the information that existed before entry into the handler)
#
# If the exception is an error, the values of OUT and INOUT parameters are not propogated
# back to the caller.
#
# 13.7 DATABASE ADMINISTRATION STATEMENTS
#
# 13.7.1 ACCOUNT MANAGEMENT STATEMENTS
# 13.7.2 RESOURCE GROUP MANAGEMENT STATEMENTS
#
# 13.7.3 TABLE MAINTENANCE STATEMENTS
# 13.7.4 COMPONENT, PLUGIN, AND USER-DEFINED FUNCTION STATEMENTS
#
# 13.7.5 SET SYNTAX
# 13.7.6 SHOW SYNTAX
#
# 13.7.7 OTHER ADMINISTRATIVE STATEMENTS
#
# 13.7.1 ACCOUNT MANAGEMENT STATEMENTS
#
# 13.7.1.1 ALTER USER SYNTAX
# 13.7.1.2 CREATE ROLE SYNTAX
#
# 13.7.1.3 CREATE USER SYNTAX
# 13.7.1.4 DROP ROLE SYNTAX
#
# 13.7.1.5 DROP USER SYNTAX
# 13.7.1.6 GRANT SYNTAX
#
# 13.7.1.7 RENAME USER SYNTAX
# 13.7.1.8 REVOKE SYNTAX
#
# 13.7.1.9 SET DEFAULT ROLE SYNTAX
# 13.7.1.10 SET PASSWORD SYNTAX
#
# 13.7.1.11 SET ROLE SYNTAX
#
# MySQL account information is stored in teh tables of the mysql system database.
#
# This database and the access control system are discussed extensively in
# CHAPTER 5, MYSQL SERVER ADMINISTRATION, which you should consult for additional details.
#
# IMPORTANT:
#
# 		Some MySQL releases introduce changes to the grant tables to add new privileges
# 		or features.
#
# 		To make sure that you can take advantage of any new capabilities, update your
# 		grant tables to the current structure whenever you upgrade MySQL.
#
# 		See SECTION 4.4.5, "MYSQL_UPGRADE -- CHECK AND UPGRADE MYSQL TABLES"
#
# When the read_only system variable is enabled, account-management statements
# require the CONNECTION_ADMIN or SUPER privilege, in addition to any other
# required privileges.
#
# This is because they modify tables in the mysql system database
#
# Account management statements are atomic and crash safe.
#
# For more information, see SECTION 13.1.1, "ATOMIC DATA DEFINITION STATEMENT SUPPORT"
#
# 13.7.1.1 ALTER USER SYNTAX
#
# 	ALTER USER [IF EXISTS]
# 		user [auth_option] [, user [auth_option]] ---
# 		[REQUIRE {NONE | tls_option [[AND] tls_option] ---}]
# 		[WITH resource_option [resource_option] ---]
# 		[password_option | lock_option] ---
#
# 	ALTER USER [IF EXISTS] USER() user_func_auth_option
#
# 	ALTER USER [IF EXISTS]
# 		user DEFAULT ROLE
# 		{NONE | ALL | role [, role ] ---}
#
# 	user:
# 		(see Section 6.2.4, "Specifying Account Names")
#
# 	auth_option: {
# 		IDENTIFIED BY 'auth_string'
# 			[REPLACE 'current_auth_string']
# 			[RETAIN CURRENT_PASSWORD]
# 	 | IDENTIFIED WITH auth_plugin
# 	 | IDENTIFIED WITH auth_plugin BY 'auth_string'
# 			[REPLACE 'current_auth_string']
# 			[RETAIN CURRENT PASSWORD]
# 	 | IDENTIFIED WITH auth_plugin AS 'hash_string'
# 	 | DISCARD OLD PASSWORD
# }
#
# user_func_auth_option: {
# 		IDENTIFIED BY 'auth_string'
# 			[REPLACE 'current_auth_string']
# 			[RETAIN CURRENT PASSWORD]
# 	 | DISCARD OLD PASSWORD
# }
#
# tls_option: {
# 	 SSL
# | X509
# | CIPHER 'cipher'
# | ISSUER 'issuer'
# | SUBJECT 'subject'
# }
#
# resource_option: {
# 		MAX_QUERIES_PER_HOUR count
#   | MAX_UPDATES_PER_HOUR count
#   | MAX_CONNECTIONS_PER_HOUR count
# 	 | MAX_USER_CONNECTIONS count
# }
#
# password_option: {
# 		PASSWORD EXPIRE [DEFAULT | NEVER | INTERVAL N DAY]
# 	 | PASSWORD HISTORY {DEFAULT | N}
#   | PASSWORD REUSE INTERVAL {DEFAULT | N DAY}
#   | PASSWORD REQUIRE CURRENT [DEFAULT | OPTIONAL]
# }
#
# lock_option: {
# 		ACCOUNT LOCK
#   | ACCOUNT UNLOCK
# }
#
# The ALTER_USER statement modifies MySQL accounts.
#
# It enables authentication, role, SSL/TLS, resource-limit and password-management
# properties to be modified for existing accounts.
#
# It can also be used to lock and unlock accounts.
#
# In most cases, ALTER_USER requires the global CREATE_USER privilege, or the UPDATE
# privilege for the mysql system database.
#
# The exceptions are:
#
# 		) Any client who connects to the server using a nonanonymous account can change the password
# 			for that account.
#
# 			(In particular, you can change your own password)
#
# 			To see which account the server authenticated you as, invoke the CURRENT_USER() function:
#
# 				SELECT CURRENT_USER();
#
# 		) For DEFAULT ROLE syntax, ALTER_USER requires these privileges:
#
# 			) Setting the default roles for another user requires the global CREATE_USER
# 				privilege, or the UPDATE privilege for the mysql.default_roles system table.
#
# 			) Setting the default roles for yourself requires no special privileges, as long 
# 				as the roles you want as the default have been granted to you.
#
# 		) Statements that modify secondary passwords require these privileges:
#
# 			) The APPLICATION_PASSWORD_ADMIN privilege is required to use the RETAIN CURRENT PASSWORD
# 				or DISCARD OLD PASSWORD clause for ALTER_USER statements that apply to your own account.
#
# 				The privilege is required to manipulate your own secondary password because most users
# 				require only one password.
#
# 			) If an account is to be permitted to manipulate secondary passwords for all accounts,
# 				it should be granted the CREATE_USER privilege rather than APPLICATION_PASSWORD_ADMIN
#
# When the read_only system variable is enabled, ALTER_USER additionally requires the CONNECTION_ADMIN
# or SUPER privilege.
#
# By default, an error occurs if you try to modify a user that does not exist.
#
# If the IF EXISTS clause is given, the statement produces a warning for each named user that
# does not exist, rather than an error.
#
# 	IMPORTANT:
#
# 		Under some circumstances, ALTER_USER may be recorded in server logs or on the client
# 		side in a history file such as ~/.mysql_history, which means that cleartext passwords
# 		may be read by anyone having read access to that information.
#
# 		For information about the conditions under which this occurs for the server logs
# 		and how to control it, see SECTION 6.1.2.3, "PASSWORDS AND LOGGING"
#
# 		For similar information about client-side logging, see SECTION 4.5.1.3, "MYSQL CLIENT LOGGING"
#
# There are several aspects to the ALTER_USER statement, described under the following topics:
#
# 		) ALTER USER OVERVIEW
#
# 		) ALTER USER AUTHENTICATION OPTIONS
#
# 		) ALTER USER ROLE OPTIONS
#
# 		) ALTER USER SSL/TLS OPTIONS
#
# 		) ALTER USER RESOURCE-LIMIT OPTIONS
#
# 		) ALTER USER PASSWORD-MANAGEMENT OPTIONS
#
# 		) ALTER USER ACCOUNT-LOCKING OPTIONS
#
# 		) ALTER USER BINARY LOGGING
#
# ALTER USER OVERVIEW
#
# For each affected account, ALTER_USER modifies the corresponding row in the mysql.user
# system table to reflect the properties specified in the statement.
#
# Unspecified properties retain their current values.
#
# Each account name uses the format described in SECTION 6.2.4, "SPECIFYING ACCOUNT NAMES"
#
# The host name part of the account name, if omitted, defaults to '%'
#
# It is also possible to specify CURRENT_USER or CURRENT_USER() to refer to the account
# associated with the current session.
#
# For one syntax only, the account may be specified with the USER() function:
#
# 		ALTER USER USER() IDENTIFIED BY 'auth_string';
#
# This syntax enables changing your own password without naming your account literally.
#
# (The syntax also supports the REPLICATE RETAIN CURRENT PASSWORD, and DISCARD OLD PASSWORD
# clauses described at ALTER USER AUTHENTICATION OPTIONS)
#
# For ALTER_USER syntaxes that permit an auth_option value to follow a user value,
# auth_option indicates how the account authenticates by specifying an account authentication
# plugin, credentials (for example, a password), or both.
#
# Each auth_option value applies only to the account named immediately preceding it.
#
# Following the user specifications, the statement may include options for SSL/TLS,
# resource-limit, password-management, and locking properties.
#
# All such options are global to the statement and apply to all accounts named
# in the statement.
#
# Example:
#
# 		Change an account's password and expire it. As a result, the user must connect with
# 		the named password and choose a new one at the next connection:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED BY 'new_password' PASSWORD EXPIRE;
#
# Example:
#
# 		Modify an account to use the sha256_password authentication plugin and the given
# 		password.
#
# 		Require that a new password be chosen every 180 days:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED WITH sha256_password BY 'new_password'
# 				PASSWORD EXPIRE INTERVAL 180 DAY;
#
# Example:
#
# 		Lock or unlock an account
#
# 			ALTER USER 'jeffrey'@'localhost' ACCOUNT LOCK;
# 			ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK;
#
# Example:
#
# 		Require an account to connect using SSL and establish a limit of 20 connections per hour:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				REQUIRE SSL WITH MAX_CONNECTIONS_PER_HOUR 20;
#
# Example:
#
# 		Alter multiple accounts, specifying some per-account properties and some global properties:
#
# 			ALTER USER
# 				'jeffrey'@'localhost'
# 					IDENTIFIED BY 'jeffrey_new_password',
# 				'jeanne'@'localhost',
# 				'josh'@'localhost'
# 					IDENTIFIED BY 'josh_new_password'
# 					REPLACE 'josh_current_password'
# 					RETAIN CURRENT PASSWORD
# 				REQUIRE SSL WITH MAX_USER_CONNECTIONS 2
# 				PASSWORD HISTORY 5;
#
# The IDENTIFIED BY value following jeffrey applies only to its immediately preceeding
# account, so it changes the password to 'jeffrey_new_password' only for jeffrey.
#
# For jeanne, there is no per-account value (thus leaving the password unchanged)
#
# For josh, IDENTIFIED BY establishes a new password ('josh_new_password'), REPLACE
# is specified to verify that hte user issuing the ALTER_USER statement knows the
# current password ('josh_current_password'), and that current password is also retained
# as the account secondary password.
#
# (As a result, josh can connect with either the primary or secondary password)
#
# The remaining properties apply globally to all accounts named in the statement,
# so for both accounts:
#
# 		) Connections are required to use SSL
#
# 		) The account can be used for a maximum of two simultaneous connections
#
# 		) Password changes cannot reuse any of the five most recent PWs
#
# Example:
#
# 		Discard the secondary password for josh, leaving the account with only
# 		its primary password:
#
# 			ALTER USER 'josh'@'localhost' DISCARD OLD PASSWORD;
#
# In the absence of a particular type of option, the account remains unchanged
# in that respect.
#
# FOr example, with no locking option, the locking state of the account is not
# changed.
#
# ALTER USER AUTHENTICATION OPTIONS
#
# An account name may be followed by an auth_option authentication option that specifies
# the account authentication plugin, credentials or both.
#
# It may also include a password-verification clause that specifies the account current password
# to be replaced, and clauses that manage whether an account has a seondary password.
#
# NOTE:
#
# 		Clauses for password verification and secondary passwords apply only to accounts that
# 		store credentials internally in the mysql.user system table
#
# 		(mysql_native_password, sha256_password, or caching_sha2_password)
#
# 		For accounts that use plugins that perform authentication against an
# 		external credential system, password management must be handled externally
# 		against the system as well.
#
# 	) auth_plugin names an authentication plugin.
#
# 		The plugin name can be a quoted string literal or an unquoted name.
#
# 		Plugin names are stored in the plugin column of the mysql.user system system table.
#
# 		For auth_option syntaxes that do not specify an authentication plugin, the default
# 		plugin is indicated by the value of the default_authentication_plugin system
# 		variable.
#
# 		For descriptions of each plugin, see SECTION 6.5.1, "AUTHENTICATION PLUGINS"
#
# 	) Credentials are stored in the mysql.user system table.
#
# 		An 'auth_string' or 'hash_string' value specifies account credentials, either
# 		as a cleartext (unencrypted) string or hashed in the format except by the
# 		authentication plugin associated with the account, respectively:
#
# 			) For syntaxes that use 'auth_string', the string is cleartext and is passed
# 				to the authentication plugin for possible hashing.
#
# 				The result returned by the plugin is stored in the mysql.user table
#
# 				A plugin may use the value as specified, in which case no hashing occurs.
#
# 			) For syntaxes that use 'hash_string', the string is assumed to be already
# 				hashed in the format required by the authentication plugin.
#
# 				If the hash format is inappropriate for the plugin, it will not be usable
# 				and correct authentication of client connections will not occur.
#
# 	) The REPLACE 'current_auth_string' clause is available as of MySQL 8.0.13
#
# 		If given:
#
# 			) REPLACE specifies the account current password to be replaced, as a cleartext (unencrypted) string
#
# 			) The clause must be given if password changes for the are required to specify the current password,
# 				as verification that the user attempting to make the change actually knows the current PW.
#
# 			) THe clause is optional if password changes for the account may but need not specify the current password
#
# 			) The statement fails if the clause is given but does not match the current password, even if the clause is optional
#
# 			) REPLACE can be specified only when changing the account password for the current user
#
# 		For more information about password verification by specifying the current password, see SECTION 6.3.8, "PASSWORD MANAGEMENT"
#
# 	) The RETAIN CURRENT PASSWORD and DISCARD OLD PASSWORD clauses implement dual-password capability
# 		and are available as of MySQL 8.0.14
#
# 		Both are optional, but if given, have the following effects:
#
# 			) RETAIN CURRENT PASSWORD retains an account current password as its secondary password,
# 				replacing any existing secondary password.
#
# 				The new password becomes the primary password, but clients can use the account to connect
# 				to the server using either the primary or secondary password.
#
# 				(Exception: if the new password specified by the ALTER_USER statement is empty, the secondary
# 					password becomes empty as well, even if RETAIN CURRENT PASSWORD is given)
#
# 			) If you specify RETAIN CURRENT PASSWORD for an account that has an empty primary password, the statement fails
#
# 			) If an account has a secondary password and you change its primary password without specifying
# 				RETAIN CURRENT PASSWORD, the secondary password remains unchanged.
#
# 			) If you change the authentication plugin assigned to the account, the secondary password is discarded.
#
# 				If you change the authentication plugin and also specify RETAIN CURRENT PASSWORD, the statement fails.
#
# 			) DISCARD OLD PASSWORD discards the secondary password, if one exists.
#
# 				The account retains only its primary password, and clients can use the account
# 				to connect to the server only with the primary password.
#
# 		FOr more information about use of dual passwords, see SECTION 6.3.8, "PASSWORD MANAGEMENT"
#
# ALTER_USER permits these auth_option syntaxes:
#
# 		) IDENTIFIED BY 'auth_string' [REPLACE 'current_auth_string'] [RETAIN CURRENT PASSWORD]
#
# 			Sets the account authentication plugin to the default plugin, passes the cleartext 
# 			'auth_string' value to the plugin for hashing, and stores the result in the account
# 			row in the mysql.user system table.
#
# 			The REPLACE clause, if given, specifies the account current password, as described
# 			previously in this section.
#
# 			The RETAIN CURRENT PASSWORD clause, if given, causes the account current password 
# 			to be retained as its secondary password, as described previously in this section.
#
# 		) IDENTIFIED WITH auth_plugin
#
# 			Sets the account authentication plugin to auth_plugin, clears the credentials
# 			to the empty string (the credentials are associated with the old authentication
# 			plugin, not the new one), and stores the result in the account row in the mysql.user
# 			system table
#
# 			In addition, the password is marked expired.
#
# 			the user must choose a new one when next connecting
#
# 		) IDENTIFIED WITH auth_plugin BY 'auth_string' [REPLACE 'current_auth_string'] [RETAIN CURRENT PASSWORD]
#
# 			Sets the account authentication plugin to auth_plugin, passes the cleartext 'auth_string'
# 			value to the plugin for hashing, and stores the result in the account row
# 			in the mysql.user system table
#
# 			The REPLACE clause, if given, specifies the account current password, as described
# 			previously in this section
#
# 			The RETAIN CURRENT PASSWORD clause, if given, causes the account current password
# 			to be retained as its secondary password, as described previously in this section.
#
# 		) IDENTIFIED WITH auth_plugin AS 'hash_string'
#
# 			Sets the account authentication plugin to auth_plugin and stores the hashed
# 			'hash_string' value as in the mysql.user account row.
#
# 			The string is assumed to be already hashed in the format required by the plugin
#
# 		) DISCARD OLD PASSWORD
#
# 			Discards the account secondary password, if there is one, as described previously
#
# Example:
#
# 		Specify the password as cleartext; the default plugin is used:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED BY 'password';
#
# Example:
#
# 		Specify the authentication plugin, along with a cleartext password value:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED WITH mysql_native_password
# 								BY 'password';
#
# Example:
#
# 		Like the preceding example, but in addition, specify the current password as a cleartext
# 		value to satisfy any account requirement that the user making the change knows that password:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED WITH mysql_native_password
# 								BY 'password'
# 								REPLACE 'current_password';
#
# 		The preceding statement fails unless the current user is jeffrey because REPLACE is permitted
# 		only for changes to the current user's password.
#
# Example:
#
# 		Establish a new primary password and retain the existing password as the secondary password:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED BY 'new_password'
# 				RETAIN CURRENT PASSWORD;
#
# Example:
#
# 		Discard the secondary password, leaving the account with only its primary password:
#
# 			ALTER USER 'jeffrey'@'localhost' DISCARD OLD PASSWORD;
#
# Example:
#
# 		Specify the authentication plugin, along with a hashed password value:
#
# 			ALTER USER 'jeffrey'@'localhost'
# 				IDENTIFIED WITH mysql_native_password
# 					AS '<value>';
#
# For additional information about setting passwords and authentication plugins,
# see SECTION 6.3.7, "ASSIGNING ACCOUNT PASSWORDS" and SECTION 6.3.10, "PLUGGABLE AUTHENTICATION"
#
# ALTER USER ROLE OPTIONS
#
# ALTER_USER_---_DEFAULT_ROLE defines which roles become active when the user connects to the server
# and authenticates, or when the user executes the SET_ROLE_DEFAULT statement during a session.
#
# ALTER_USER_---_DEFAULT_ROLE is alternative syntax for SET_DEFAULT_ROLE (see SECTION 13.7.1.9, "SET DEFAULT ROLE SYNTAX")
#
# However, ALTER_USER can set the default for only a single user, whereas SET_DEFAULT_ROLE can set the
# default for multiple users.
#
# On the other hand, you can specify CURRENT_USER as the user name for the
# ALTER_USER statement, whereas you cannot for SET_DEFAULT_ROLE
#
# Each user account name uses the format described previously.
#
# Each role name uses the format described in SECTION 6.2.5, "SPECIFYING ROLE NAMES"
#
# For example:
#
# 		ALTER USER 'joe'@'10.0.0.1' DEFAULT ROLE administrator, developer;
#
# The host name part of the role name, if omitted, defaults to '%'
#
# The clause following the DEFAULT ROLE keywords permites these values:
#
# 		) NONE: Set the default to NONE (no roles)
#
# 		) ALL: Set the default to all roles granted to the account
#
# 		) role [, role] ---. Set the default to the named roles, which must exist
# 			and be granted to the account at the time ALTER_USER_---_DEFAULT_ROLE
# 			is executed.
#
# ALTER USER SSL/TLS OPTIONS
#
# MySQL can check X.509 cert attributes in addition to the usual authentication
# that is based on the user name and credentials.
#
# For background information on the use of SSL/TLS with MySQL, see SECTION 6.4, "USING ENCRYPTED CONNECTIONS"
#
# To specify SSL/TLS-related options for a MySQL account, use a REQUIRE clause that specifies
# one or more tls_option values.
#
# Order of REQUIRE options does not matter, but no option can be specified twice.
#
# The AND keyword is optional between REQUIRE options.
#
# ALTER_USER permits these tls_option values:
#
# 		) https://dev.mysql.com/doc/refman/8.0/en/alter-user.html
# 