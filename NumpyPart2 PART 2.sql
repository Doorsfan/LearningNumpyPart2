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
# 		CRAETE EVENT myevent
#
# https://dev.mysql.com/doc/refman/8.0/en/alter-event.html