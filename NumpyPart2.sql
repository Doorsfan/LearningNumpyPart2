#Some Queries are commented out, but every query has been tested.

#SELECT version(), current_date; /* We can access basic functions and date formattings/underlying data with function calls and attribute designations */
/* Casing in terms of the function name etc, is irrelevant. */

/*we can, also - if we wish - use MySQL as a calculator for basic arithmetic operations */


#SELECT SIN(pi()/5), 5*2;

/* A couple of notes on this matter:

** is not allowed as an operator.

Each result of a query is parsed in a seperate windowing. */


/*
SELECT version(); SELECT 5*2;
*/


/* Just showcasing that we can perform several operations on the same line. 

Do denote, that each ; section, is denoted as a individual query each. */

/*
SELECT
USER(),

CURRENT_DATE;

*/

/* The above showcases that we can perform several line long queries, where the termination point of the query
or the "endpoint" of it - is the ; notation. */

/* In terms of if we were to run this by CMD line, we could incorporate a number of other factorials if we so wish:

akin to /c to stop execution or to perform cancellation.

As for the prompt in terms of CMD structure, it would be:

mysql> - is ready for a new query

-> Waiting for the next line of a multiple-line query

'> Waiting for the next line, waiting for completion in terms of string that begins with a '

"> Same as above, except string that begins with a "

`> Same as above, except identifier with backtick as beginning structure

/*> Same as above, except completion of comment section awaited

*/

SHOW DATABASES;

/* Covering some basics of Syntax interactions

Do note - that if you do not yield the privleges or rights to view a database, it is not shown by this command. */

USE world; 

/* Use, akin to Quit - does not need a semicolon, as it's a special designation command. 
It must be used on one line. */

GRANT ALL ON world TO 'root'@'localhost';

/* Whilst granting full rights to the base Root user is not a wise move, this is done here to just illustrate the process */

#CREATE DATABASE illustration; 

/* Keep in mind that DB names are case sensitive. */

/* Where of we can create tables as well, if we so wish */

USE illustration;

SET sql_notes = 0;  
/* The above turns off storing and messaging in terms of warning messages 

Meaning, if you run SHOW WARNINGS; - it won't have anything to show, even if any triggered, as it won't
register them or catalog them. */

/*In case of changing attributes, we can utilize ALTER_TABLE statements. */
CREATE TABLE IF NOT EXISTS example (name VARCHAR(20), x_attribute INTEGER(10), y_attribute INTEGER(10));


/* In terms of the Create if not exists attribute, it mainly applies to checking for table existence. */

#SET sql_notes = 1;

/*If we wish, ,we can denote to find out what the attributes of a Table is, with Describe. */

DESCRIBE example;

/* Little bit of a note about the Local notation in the following:

LOAD DATA LOCAL INFILE 'D:/loadintodb.txt' INTO TABLE example;

It's a sensetive wording that is based on the installation and setup of the MySQL. This can either
come down to overriding with enabling construction in the underlying installation or overriding akin to
adhering of that MySQL have the full path installed - lest it will resolve to internal handles.

This can also be changed in Config files, akin to setting local-infile=1 in the .cnf file

We can also utilize things akin to exec()

*/

/* In terms of file security, we have the setup of certain privacy adherences to different file formats.

As of such, we can adhere to this, by running the showing of secure_file_priv - to then write to that file or upload,
as it's adhered to being safe. */

SHOW VARIABLES LIKE "secure_file_priv";

#LOAD DATA INFILE 'D:/loadintodb.txt' INTO TABLE example; NOT ALLOWED BECAUSE OF SAFETY PRIVS OF FOLDERINGS
#Have to save to C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\ \n

/* There is a number of different levels of interactions that are relevant to talk about in terms of Loading Local Data.

This can vary from permissions on Server side to Client siding and compilation settings.

To verifications in terms of SSL and dynamics akin to omitting Local to circumvent permissions needed of File
access, where of Local will be utilize loading up speed.

The major problem here - and sake of omittal in terms of this specific instance, is mostly file configuration
constraint. 

Need be, i will change this for upcoming repeated cases. */


#LOAD LOCAL DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\loadintodb' INTO TABLE example;

/* We can of course, commit to having insertions of tables as well. */

DELETE FROM example; #Just clear out the Table

INSERT IGNORE INTO example VALUES ('Example_1', 10, 15);
#Etc. Also, a small difference between Insert and Load Data, is that Load Data represents NULL with /N
#Whilst, if we wish to have NULL in terms of Insert, we can simply state it as NULL.

#The general pattern of Selecting is:
# SELECT <attribute_to_select> 
# FROM <table>
# WHERE <conditions>

#SELECT * FROM example;

#Where of we can of course, specify this and performs updates etc.

UPDATE example SET x_attribute = 30 WHERE name = 'Example_1';
#We can of course, modify more and update the conditions, involve operators etc.
#We will cover that later.

#SELECT * FROM example;

INSERT IGNORE INTO example VALUES ('Example_2', 55, NULL);
INSERT IGNORE INTO example VALUES ('Example_Two', 3, NULL);
INSERT IGNORE INTO example VALUES ('Testiiiiiiiing', 3, NULL);
INSERT IGNORE INTO example VALUES ('aaaaaaaaa', 3, NULL);

INSERT IGNORE INTO example VALUES ('Some_Tricky', NULL, 1003);
INSERT IGNORE INTO example VALUES ('Some_Thing', NULL, 55);
INSERT IGNORE INTO example VALUES ('Some_Trick', NULL, 10000);
INSERT IGNORE INTO example VALUES ('Some_Trick', NULL, 10000);
INSERT IGNORE INTO example VALUES ('Some_Trick', NULL, 10000);
INSERT IGNORE INTO example VALUES ('Some_Trick', NULL, 10000); 
INSERT IGNORE INTO example VALUES ('Some_Trick', NULL, 10000);


SELECT * FROM example WHERE name LIKE '%xam%';

#We can basically utilize different forms of Regex or pattern recognition applications akin to % denotations to showcase, anything that fits
#along the designation of xam goes into the string.

#And of course, we can commit structured queries and prepared statements - however, we will cover that later.

#We can also select based on numerical samplings or comparisons

#SELECT * FROM example WHERE (y_attribute IS NOT NULL) AND (name LIKE 'Some_T%i__'); #Showcasing wildcard char and regex of 2 chars pattern length
/* The above interplays so that % is wildchar, __ is specific length of pattern, as in, pattern of length 2 */

#We can also utilize regex to locate for beginning and end, with ^ and $, where each is beginning/end respectively
#SELECT * FROM example WHERE REGEXP_LIKE(name, '^E');

SELECT * FROM example WHERE REGEXP_LIKE(name, 'k$'); #Ends with k

SELECT * FROM example WHERE REGEXP_LIKE(name, '^.{3,9}$'); #Checks a range of length of the name attribute from beginning to end, length interval of 3 to 9

SELECT DISTINCT name FROM example WHERE REGEXP_LIKE(name, '^.{3,9}$');

#We could keep compounding different operations to check for values, patterns etc.

SELECT DISTINCT name, x_attribute FROM example WHERE x_attribute < 100 ORDER BY x_attribute ASC, name ASC;

#The ordering in terms of Descending and Ascending is a matter of a compounded stature where we can just throw on more and more
#orders of operations in terms of integrations of Structure and differentiate how they should be partitioned.

#If we were interested, we could ordane TIMESTAMPDIFF to integrate accessing of Date denotations akin to CURDATE()

#For instance, in the documentation it is showcased as:
SELECT name, birth, CURDATE(), TIMESTAMPDIFF(YEAR, birth, CURDATE()) AS age FROM pet;
#
# Where the mosti mportant part is just to denote the CURDATE() function and the TIMESTAMPDIFF() which interacts with date stamps
#Computing a differential

CREATE TABLE IF NOT EXISTS datestuff (name VARCHAR(20), age INTEGER(20), first_date DATE, second_date DATE);

#DELETE FROM datestuff;
DELETE FROM datestuff;

INSERT IGNORE INTO datestuff VALUES ('Base_1', 100, '2018-10-10', CURDATE()); #Insert some basic date operations
INSERT IGNORE INTO datestuff VALUES ('Base_2', 15, '2018-09-11', CURDATE()); 
INSERT IGNORE INTO datestuff VALUES ('Base_3', NULL, '2018-05-11', CURDATE());
INSERT IGNORE INTO datestuff VALUES ('Base_4', 5, '2011-01-11', CURDATE());
INSERT IGNORE INTO datestuff VALUES ('Base_5', 100, NULL, CURDATE());  

SELECT name AS variable_name, age AS x_variable, TIMESTAMPDIFF(MONTH, first_date, second_date) AS months_differing FROM datestuff 
WHERE TIMESTAMPDIFF(MONTH, first_date, second_date) IS NOT NULL ORDER BY name; 
#As shown above, we can compute more and more "compounded" statements based on the Query Structure.
#
#The hiearchial principle of subcomposition in the query is based on the complexity of the Query, as we can chain the commands.
#However, we'll get into that later.

#We can subaccess the different dates by virtue of Month, Year, day, and intervals etc.

#In terms of Truth values - we run with binary denotation of truth/false values
SELECT first_date IS NOT NULL FROM datestuff; #0 denotes a False outcome, 1 is a True outcome

#As far as Operations of Regex goes, we can utilize Grep, vi and sed of which are extensions

SELECT name, COUNT(*) FROM datestuff GROUP BY age; #Now, if we had different structures and different parts of which we wish to
#integrate - we can do so - by better sub partitioning in the pattern of different structure pieces.
#To which we can perform count across a specific axis etc.

#In case you attempt to ordane selects past the point of Counts, we have to consider the
# ONLY_FULL_GROUP_BY attribute. Of which defines if only full groupings are to be accounted for.

#If the ONLY_FULL_GROUP_BY is not activated, the query is as if all the rows are a single group.
#But the nature of the naming of each column is nondeterministic.

CREATE TABLE IF NOT EXISTS secondtable (name VARCHAR(20), age INTEGER(20), misc VARCHAR(20) , third_date DATE);

DELETE FROM secondtable;


INSERT IGNORE INTO secondtable VALUES ('SecondBase_1', 100, 'Example_1', CURDATE());
INSERT IGNORE INTO secondtable VALUES ('SecondBase_2', 100, 'Example_2', CURDATE());
INSERT IGNORE INTO secondtable VALUES ('SecondBase_3', 100, 'Example_3', CURDATE());
INSERT IGNORE INTO secondtable VALUES ('SecondBase_4', 100, 'Example_4', CURDATE());
INSERT IGNORE INTO secondtable VALUES ('SecondBase_5', 100, 'Example_5', CURDATE());




#We can access the hierarchy in terms of the databases with the class names and the sub attribute namings etc.

SELECT illustration.datestuff.name as datestuff_name, illustration.secondtable.name as second_table_name,
illustration.secondtable.age as cross_over_age
FROM illustration.datestuff, illustration.secondtable WHERE illustration.datestuff.age = illustration.secondtable.age;

# The above causes the inherent pattern of querying across:
# Cycle from every element on base table -> Cycle through across every element of target Table
# TABLE[0][0-Length of sub-table denoted by element chosen] -> TABLE[1][0-length of sub-table denoted by element chosen]
#
# So, in our case - since both tables are 5 elements, this is 25 operations, as it cycles through 5x5 operations
# 2 of them co-align, so that means we have 5x2 results, 10 results
#

#We could omit the structure referal of doing explicit calls to explicit paths - however, that would fall back to local handle
#designation parameter interpretation - i.e, ambiguity is introduced into the Schematic.

#If we need to, we can run MySQL In batch mode as well, which allows us to integrate so that we are not running in a interactive mode.
#This is needed if we are to run for instance Cron Jobs.

#Run from CMD:
#
# mysql < batch-file , case of special chars being issues - run with -e
#
# The CMD line can also look like:
#
# mysql -h host -u user -p < batch-file
# enter password: --------

#We can also then pipe the output to either page more or have a further outputting file
#
# mysql < batch-file | more
#
# mysql < batch-file > mysql out

#We can also trigger MySQL scripts from CMD prompt of MySQL:
#
# mysql> source filename
# mysql> \ filename

#Showcasing some basic structural composition of base integrations

CREATE TABLE IF NOT EXISTS Shoes (
	Size INT(4) UNSIGNED ZEROFILL DEFAULT '0000' NOT NULL, #The base it goes for is 0000, numeral designated will simply inject unto the beginning
	owner  CHAR(20) 					   DEFAULT '' 		NOT NULL, #The base string appended to, is ''
	price   DOUBLE(16,2) 				DEFAULT '0.00' NOT NULL, #The default in terms of Pricing is just a 0.00
	PRIMARY KEY(Size, owner));                            #The primary keys bound to the table

CREATE TABLE IF NOT EXISTS People (
	Age INT(4) UNSIGNED ZEROFILL DEFAULT '00' NOT NULL,
	Name CHAR(20) 					  DEFAULT '' NOT NULL,
	Last_Name CHAR(20) 			  DEFAULT '' NOT NULL,
	PRIMARY KEY(Name, Last_Name));

INSERT IGNORE INTO People VALUES
	(30, 'Adrian', 'Markovich'), (50, 'Bonny', 'Taylor'), (60, 'Camille', 'Johnsonn'), (10, 'Zoe', 'Quinn'),
	(15, 'Alexander', 'The Great'), (49, 'Alice', 'Cooper'), (100, 'Daniel', 'Markov'), (18, 'Alexander', 'The Great'),
	(150, 'Daniel', 'Markov'); #Since Name and Last_Name are primary keys, they are implicitly Unique. I.e, duplications are ignored.


INSERT IGNORE INTO Shoes VALUES
	(34, 'Adrian', 3.45), (33, 'Bonny', 5.99), (32, 'Camille', 12.55), (35, 'Quinn', 1.10),
	(41, 'Alexander', 10.00), (44, 'Alice', 12.33), (43, 'Daniel', 23.31);
	
SELECT MAX(Size) AS Largest_Shoe_Size FROM Shoes;

#We can, if we so wish - denote to structure sub-queries of selectional structure.

SELECT illustration.Shoes.Size AS size, illustration.Shoes.Price AS price, illustration.Shoes.owner AS owner_name FROM illustration.people, illustration.Shoes 
WHERE illustration.people.name = illustration.Shoes.owner ORDER BY price LIMIT 2; #We can impose limits as well 

SELECT owner AS owner_name, size AS largest_size FROM Shoes ORDER BY size DESC LIMIT 1; #Find the person with the biggest shoe size

#there is ways to circumvent the denotation of selecting the whole set and simply do a more specific Query in terms of Sorting and Grouping
#Albeit, that is a more advanced partition.


SELECT name, last_name, Age, size FROM People, Shoes WHERE name = illustration.Shoes.owner AND age % 5 = 0;
#We can also involve operators in our selection of AND statements.



#https://dev.mysql.com/doc/refman/8.0/en/examples.html

