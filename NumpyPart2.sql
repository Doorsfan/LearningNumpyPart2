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

SET sql_notes = 1;

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

SELECT * FROM example WHERE (y_attribute IS NOT NULL) AND (name LIKE 'Some_T%i__'); #Showcasing wildcard char and regex of 2 chars pattern length
/* The above interplays so that % is wildchar, __ is specific length of pattern, as in, pattern of length 2 */

#We can also utilize regex to locate for beginning and end, with ^ and $, where each is beginning/end respectively
SELECT * FROM example WHERE REGEXP_LIKE(name, '^E');

SELECT * FROM example WHERE REGEXP_LIKE(name, 'k$'); #Ends with k

SELECT * FROM example WHERE REGEXP_LIKE(name, '^.{3,9}$'); #Checks a range of length of the name attribute from beginning to end, length interval of 3 to 9

SELECT DISTINCT name FROM example WHERE REGEXP_LIKE(name, '^.{3,9}$');
#We could keep compounding different operations to check for values, patterns etc.

SELECT DISTINCT name, x_attribute FROM example WHERE x_attribute < 100 ORDER BY x_attribute ASC, name ASC;
#The ordering in terms of Descending and Ascending is a matter of a compounded stature where we can just throw on more and more
#orders of operations in terms of integrations of Structure and differentiate how they should be partitioned.

#https://dev.mysql.com/doc/refman/8.0/en/date-calculations.html