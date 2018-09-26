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

#If we wish, we can implement further denotations in terms of assigned variables

#Runs assignment from selected variables
SELECT @min_size:=MIN(size), @max_size:=MAX(size) FROM Shoes;

SELECT * FROM Shoes WHERE size=@min_size OR size=@max_size; #Get all the columns that trigger on having the size of assigned variables, in a or fashion

#In terms of creations of Tables - if we denote a References clause - that's a ignored section which only acts a indirecty way of comment or reminder.

#If we were to search based on optimized standardization of Query parsing - We can use an OR, bound to a single key
#Another way, is to do a Union between two Queries of Selects

SELECT size FROM Shoes WHERE size > 10
UNION
SELECT owner FROM Shoes WHERE owner LIKE '%onn%';
#Kind of a poor example, but combines the two queries of performing where Size and owner is checked up on.

CREATE TABLE IF NOT EXISTS purchased_ice_cream (name CHAR(20), price INT(4) UNSIGNED ZEROFILL, date_of_purchase DATE);

#Omit ignore into, to allow for duplications
INSERT INTO purchased_ice_cream VALUES("Vanilla", 10, "2018-08-01");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-08-02");
INSERT INTO purchased_ice_cream VALUES("Strawberry", 20, "2017-07-03");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-08-04");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-08-05");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-08-06");	
							
INSERT INTO purchased_ice_cream VALUES("Caramell", 30, "2011-09-07");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-02-08");
INSERT INTO purchased_ice_cream VALUES("Strawberry", 20, "2015-03-09");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2016-04-10");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2018-06-11");
INSERT INTO purchased_ice_cream VALUES("Chocolate", 15, "2011-08-12");

SELECT name, price, BIT_COUNT(BIT_OR(1<<DAY(date_of_purchase))) AS Unique_dates_of_purchase, COUNT(DAY(date_of_purchase)) AS amount_of_purchases FROM purchased_ice_cream GROUP BY name, price;
#The above showcases that we can run Queries against amount of purchases, on what amount of different days, unique or not, etc.
#We can of course also designate to be a factor of uniqueness to count in terms of BIT_COUNT, but we could also count by virtue of
#other methods.

#And we can, if we so wish - utilize Auto_Increment - which interplays so that it defaults to what value was designated last
#based on insertion operations

CREATE TABLE IF NOT EXISTS example_of_auto_increment(id INT(10) NOT NULL AUTO_INCREMENT,
	name CHAR(30) NOT NULL,
	x_attribute CHAR(30) DEFAULT '' NOT NULL,
	y_attribute CHAR(30) DEFAULT '' NOT NULL,
	PRIMARY KEY (id)
);
#When something is a Numerical akin to ID and we have auto_increment,
#We do not need to have a default designation - as the handle in terms of defaulting is implicit
#in designation to last numerical call or 0, depending on context.

INSERT IGNORE INTO example_of_auto_increment (id, name, x_attribute) VALUES
	(1, 'Shoe', 'Brown'),
	(2, 'Pasta', 'Tasty'),
	(3, 'Mug', 'Cheramic'),
	(1001, 'Sickle', 'Ripping'),
	(5, 'Frown', 'Sad'),
	(100, 'Locks', 'Unbreakable'),
	(10, 'Fox', 'Jumped over the Rice'),
	(11, 'Box', 'Square');

INSERT INTO example_of_auto_increment (name) VALUES
	('Shoe');
INSERT INTO example_of_auto_increment (name) VALUES
	('Shoe_box');
INSERT INTO example_of_auto_increment (id, name) VALUES
	(NULL,'Glove_box');
#Simply runs auto-increment to reflect of where the last designated default handle was put in terms of Value designation
#We can also designate Null values as auto_increment generation if NOT NULL has been designated.

#If we wish to find out the latest Automatic generated ID, we can access it with LAST_INSERT_ID()

#We can further Enumerate structures by virtue of utilizing the MyISAM Engine designation of Tables.

CREATE TABLE IF NOT EXISTS isam_example (
	groupings ENUM('Shoe', 'Sock', 'Pants') NOT NULL,
	id INT NOT NULL AUTO_INCREMENT,
	color CHAR(30) NOT NULL,
	PRIMARY KEY (groupings,id)
) ENGINE=MyISAM;

INSERT IGNORE INTO isam_example (groupings, color) VALUES
	('Shoe', 'Brown'), ('Shoe', 'Green'), ('Shoe', 'Yellow'),
	('Sock', 'Rainbow'), ('Sock', 'White'),
	('Pants', 'Black'), ('Pants', 'Grey'),('Pants', 'Red'), ('Pants', 'Green');

SELECT * FROM isam_example ORDER BY groupings, id;

#If we wish to configure the Apache logging format to adhere to MySQL's structure - we can do so by virtue of
#putting the following into the Apache configuration file:
#
# LogFormat \
# 				"\"%h\",%{%Y%m%d%H%M%S}t,%>s, \"%b\", "%{Content_Type}o\", \
# 				\"%U\", \"%{Referer}i\",\"%{User-Agent}i\""

#Where of the loading of a log file might look as follows:
#
# LOAD DATA INFILE '/local/access_log' INTO TABLE tbl_name
# FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'

#There are a number of programs related to MySQL overall:
#
#mysql - the mysql daemon, i.e, the mysql server.
#
#mysqld_safe - A server startup script. mysqld_safe attempts to start mysqld.
#
#mysql.server - A server startup script. Used on systems that use System V-style run directories containing
#scripts that start system services for particular run levels. It invokes the mysqld_safe to start the MySQL Server.
#
#mysqld_multi - A server startup script that can start or stop multiple servers installed on the system.

#comp_err - Used during the MySQL build/installation process. Compiles error messages files from the error source files.

#mysql_secure_installation - Enables to improve the security of your MySQL installation.

#mysql_ssl_rsa_setup - creates the SSL cert and key files and RSA key-pair files required to support secure connections, if those
#files are missing. Files created by mysql_ssl_rsa_setup can be used for secure connections using SSL or RSA.

#mysql_tzinfo_to_sql - This program loads the time zone tables in the mysql db using the contents of the host system zoneinfo db
# (This is a set of files that describes time zones)

#mysql_upgrade - Used after a MySQL upgrade operation. Checks tables for incompatibilies and repairs them if nessecary, and updates
#the grant tables with any changes relevant in newer versionings of MySQL.

#The following is the client programs that connect to the MySQL server:

#mysql - cmd line tool for interactively entering SQL statements or executing them from a file in batch mode.

#mysqladmin - A client that performs administrative operations, such as creating or dropping DBs, reloading the grant tables,
#flushing tables to disk and reopening log files.
#
#mysqladmin can also be used to retrieve version, process and status information from the server. 

#mysqlcheck - A table-maintenance client that checks, repairs and analyzes and optimizes tables.

#mysqldump - A client that dumps a MySQL db into a file as SQL,text, or XML.

#mysqlimport - A client that imports text files into their respective tables using LOAD DATA INFILE.

#mysqlpump - a client that dumps a MySQL db into a file as SQL.

#mysqlsh - MySQL Shell is a code editor for MySQL server. Allows for scripting of JS and Python.

#mysqlshow - A client that displays information about DBs, tables, columns and indexes.

#mysqlslap - A client made to emulate client load for a MySQL server and report the timing of each stage.
#Works as if multiple clients are accessing the server.

#There are a few MySQL Administrative and utility sectioned programs as well
#
#innochecksum - a offline InnoDB offline checksum utility.

#myisam_ftdump - A utility that displays information about full-text indexes in MyISAM tables.

#myisamchk - A utility to describe, check and optimize/repair MyISAM tables.

#myisamlog - A utility that processes the contents of a MyISAM log file.

#myisampack - A utiliy that compresses MyISAM tables to produce smaller read-only tables.

#mysql_config_editor - A utility that enables you to store authentication credentials in a secure, encrypted login path file
#named .mylogin.cnf

#mysqlbinlog - A utility for reading statements from a binary log. The log of executed statements contained in the binary log files
#can be used to help recover from a crash.

#mysqldumpslow - A utility to read and summarize the contents of a slow query log.

#Past this, there are MySQL program-development utilities.

#mysql_config - A shell script that produces the option values needed when compiling MySQL programs.

#my_print_defaults - A utility that shows which options are present in option groups of option files.

#resolve_stack_dump - A utility program that resolves a numeric stack trace dump to symbols.

#There are some misc. utilities:

#lz4_decompress - A utility that decompresses mysqlpump output that was created using LZ4 compression.

#perror - A utility that displays the meaning of system or MySQL error codes.

#resolveip - A utility program that resolves a host name to an IP address or vice versa.

#zlib_decompress - Utility that decompresses mysqlpump output that was created using ZLIB compression.

#Some of the ENvironment variables used by MySQL are as follows:

#MYSQL_UNIX_PORT - The default Unix socket file, used for connections to localhost

#MYSQL_TCP_PORT - The default port number, used for TCP/IP connections

#MYSQL_PWD - The default PW

#MYSQL_DEBUG - Debug trace options when debugging

#TMPDIR - The dir where temporary tables and files are created.

#Past this, there is the interaction of actually interacting with MySQL from the Commandline

#mysql --user=root test 
#
#Harkening back unto Unix systems, -- denotes commands, - denotes unix options
#test is a DB name, in this instnace

#most common operations shorthand to the first letter of the naming to denote command interaction
#--host/-h - Host
#--user/-u - User
#--password/-p - Password
#
#--port/-P - Port number to connect to
#--socket/-S - Specify a UNIX socket file on Unix (named Pipe name on Windows)

#To circumvent full need of explicit path denotation in parameter accessing, we can include the installation Path
#in the PATH setup.
#
#Meaning, if Mysql is installed to /usr/local/mysql/bin - we can put that into PATH, allowing us to simply denote it as 
#mysql
#
#Generally the runtime path declaration resolves to a local handle in terms of the bin designation path
#as in, just refering to bin with resolve it to a local designation path for MySQL.
#
#This can be important as well in terms of recursive path resolution, as this can come to be bugged.

#The following pertains to connecting to a MySQL Server
#
# There are a number of default parameter handligns to fallback unto, in terms of how MySQL operates.
#This means that if you just write for instance MySQL in the cmd, it will resolve to the default resolution
#of certain program variables:

#default host name: localhost
#
#default user name: ODBC on Windows, Unix login name on UNIX.
#
#if neither -p or --password is given, password is given as empty field
#
#default name of db to access: the first non option parameter found. If none, it does not select one

#Example of showcasing of accessing
#
# mysql --host=localhost --user=myname --password=password mydb
# mysql -h localhost -u myname -ppassword mydb

#note, no space between -p or --password command and actual PW.

#Other users on the system can see the pw entered on cmd line with ps auxw.

#To avoid security risks in that department, simply omit writing the pw on the cmd line
#
# mysql --host=localhost --user=myname --password mydb
# mysql -h localhost -u myname -p mydb

# The above examples has omitted PW on the CMDline.

#Some systems limit the PW to 8 chars. Either have the PW as 8 chars, or put it as a value in a option file

#On Unix systems, localhost attempts to ordane connection through a UNix Socket. 
#To circumvent this, use explicit IP declaration
#
# mysql --host=127.0.0.1
# mysql --protocol=TCP Allows us to denote different connection types, even if it would default ot something else

#If the server is made to accept Ipv6 connections, clients can connect with --host=::1

#On windows, we can force named-pipe connections by specifying the --pipe or --protocol=PIPE option, or by using
#. as the hostname

#If named-pipe connections are not enabled, an error occurs. Use the --socket option to specify the
#name of the pipe, if we do not wish to have the default naming on pipes.

#Default port is 3306
#mysql --host=remote.example.com Defaults to port being 3306

#To specify a port use --port or -P
#mysql --host=remote.example.com --port=13306

#Do note, attempting to ordane localhost on a unix system will use a socket file
#to circumvent this, use more explicit denotation

#mysql --port=13306 --host=localhost Will ignore the port part on a Unix system, as it defaults to a socket file

#mysql --port=13306 --host=127.0.0.1
#mysql --port=13306 --protocol=TCP

#We can utilize things akin to hints to denote what the client-side authentication plugin should be:
#
#--default-auth=plugin

#To utilize pipes, we can use:
#--pipe, -W
#However, the server must be started with the --enable-named-pipe option to enable named-pipe connections.

#We can denote what kind of protocol to use, which relates back unto what kind of a OS is permissible to utilize it
#
# --protocol=TCP - TCP/IP connection to local or remote server, usable by all
#
# --protocol=SOCKET - Unix socket file connection to local server, Unix only

# --protocol=PIPE   - Named-pipe connection to local or remote server, Windows only

# --protocol=MEMORY - Shared-memory connection to local server, Windows only

#Do denote, for most cases - overhead is avoided with Socket default integrations in Unix systems.

#To run with Shared memory:

#--shared-memory-base-name=name , defaults to MYSQL. Server must be started with --shared-memory

#--socket=file_name, -S file_name - On Unix, the Unix socket file to use, for connections made using a named pipe to a local server.
# On Unix, defaults to /tmp/mysql.sock
# 
# On windows, the named pipe name to use. defaults to MySQL.

#Server must be started with --enable-named-pipe to enable this.

#--ssl* to start up connection based on SSL layering

#--tls-version=protocol list
#Denotes the protocols permitted by the client for encrypted connections. The value is a comma-separated list containing one
#or more protocol names.

#The protocols usable for this option depend on the SSL library used to compile MySQL.

#--user=user name, -u user_name - username to be used. default on Windows is ODBC or the Unix login name on Unix.

#We can modify options files akin to the Client section of an option file.

#We can also utilize PATH variables, akin to MYSQL_HOST, USER or MYSQL_PWD.

#The following section showcases the Path parameters in terms of connections
#They are bound to URI type strings or data dictionaries

#scheme:Specifies the connection protocol to use. To account for a specific protocol, use mysqlx, mysql for classic
#MySQL protocol connections. If a protocol is not specified - the server attempts to guess the protocol.

#user: Specifies the MySQL user account to be used for the authentication process.

#password: Specifies the password to be used for the authentication process. Do not store hte PW in the connection path

#host: Specifies the server instance the connection refers to. Can be either an IpV4 address, an IpV6 address or a hostname. If not specified,
#localhost is used by default.

#port: Specifies a network port which the target MySQL server is listening on for connections. If not specified, 33060 is used by default
#for X protocol connections.

#3306 is the default for classic MySQL protocol connections.

#socket: path to a Unix socket or Windows named-pipe. The values are local file paths and must be encoded in URI type strings,
#using % encodings or surrounding the path with ()'s - as full resolution of path is then realized, instead of needing to escape for explicit stature.

#To connect as root@localhost using Unix sockets, we can use /tmp/mysqld.sock we can use % or ()'s:

#()'s:
#root@localhost?socket=(/tmp/mysqld.sock)

#%'s:
#root@localhost?socket=%2Ftmp%2Fmysqld.sock

#Basically in the case of % escaping, we replace the direct symbols with underlying unicode translations
#akin to accessing of typing/other structuring.
#It resolves to /, regardless.

#schema: specifies the database to be set as default when a connection is established.

#?attribute=value: Specifies a data dictionary that contains options.

#The params are case insensitive and can only be defined once.
#If defined more than once, a error is generated.

#When a dictionary is used, the following options are also valid:
#
#ssl-mode: the SSL mode to be used for the connection.
#
#ssl-ca: the path to the X.509 cert authority in PEM format.
#
#ssl-capath: the path to the directory that contains the X.509 certs authorities in PEM format.
#
#ssl-cert:The path to the X.509 certs in PEM format.
#
#ssl-key: The path to the X.509 key in PEM format.
#
#ssl-crl: The path to file that contains certificate revocation lists
#
#ssl-crlpath: The path to the directory that contains certificate revocation list files.
#
#ssl-cipher: the SSL cipher to use.
#
#tls-version: List of protocols permitted for secure connections.
#
#auth-method: Authentication method used for the connection. Defaults to AUTO, meaning that the server attempts to guess.
#Can be one of the following:
#
#AUTO, MYSQL41, SHA256_MEMORY, FROM_CAPABILITIES, FALLBACK, PLAIN

#Whenever we use a X Protocol connection, any configured auth-method is overridden to this sequence of authentication methods:
#MYSQL41, SHA256_MEMORY, PLAIN.

#get-server-public-key. 
#Requests the public key from the server required for RSA key-paired based password exchange.
#
#use this when connecting to the MySQL 8.0 servers over classic MySQL protocol with SSL mode DISABLED.
#You must specify the protocol in this case, for example:
#
#mysql://user@localhost:3306?get-server-key=true

#server-public-key-path: The path name to a file containing a client-side copy of the public key required for RSA key pair-based password exchange.
#Use when connecting to MySQL 8.0 servers over classic MySQL protocol with SSL mode DISABLED.

#The ?attribute=value options data dictionary can contain are the following options:
#
#mycnfPath: the path to the MySQL configuration file of the instance.
#
#outputMycnfPath: alternative output path to write the MySQL configuration file of the instance.
#
#password: the password to be used by the connection.
#
#clusterAdmin: the name of the InnoDB cluster administrator used to be created. The supported format is the standard
#MySQL account name format.
#
#clusterAdminPassword: the password for the innoDB cluster admin account.
#
#clearReadOnly: a boolean value used to confirm that super_read_only must be disabled.
#
#interactive: A boolean of which disables the interactive wizards of assignments of variables/non-assignments etc.

#restart: A boolean of which is used to indicate that a remote restart of the target instance should be performed to finalize operations.

#The following is a covering of how to connect using a URI string

#We can specify a connection using a URI type string format. Such strings can be used with
#the MySQL Shell --uri command option, along with the MySQL Shell \connect command

#This also applies to tools like MySQL Routers and Connectors of whom implement X DevAPI.

#A typical URI type string has the following format:

#[scheme://][user[:[password]]@]target[:port][/schema][?attribute1=value1&attribute2=value2]

#Note, that reserved keywords must be escaped, akin to:
#% - %25
#@ - %40

#Some examples of connections being made with this formatting:
#
#A classical MySQL protocol connection to a local server instance listening at port 3333
#mysql://user@localhost:3333
#
#A X Protocol connection to a local server instance listening at port 33065
#mysqlx://user@localhost:33065
#
#A X protocol connection to a remote server instance, using a host name, an IpV4 address and an IpV6 address.
#
#mysqlx://user@server.example.com/
#mysqlx://user@198.51.100.14:123 IPV4 address
#mysqlx://user@[2001:db8:85a3:8d3:1319:8a2e:370:7348]
#
#We can also specify a optional path which represents a DB schema
#mysqlx://user@198.51.100.1/world%5Fx Basically, the encoding/escaping of chars akin to %5Fx is Hexadecimal and akin.
#mysqlx://user@198.51.100.2:33060/world

#Where of the following example illustrates a connection to a localhost, SSL integration with certs,
#key and cert.
#
#The example is just to illustrate the difference between escaping of characters and paranthesis integration
#
#ssluser@127.0.0.1?ssl-ca=%2Froot%2Fclientcert%2Fca-cert.pem\
#&ssl-cert=%2Froot%2Fclientcert%2Fclient-cert.pem\
#&ssl-key=%2Froot%2Fclientcert%2Fclient-key

#ssluser@127.0.0.1?ssl-ca=(/root/clientcert/ca-cert.pem)\
#&ssl-cert=(/root/clientcert/client-cert.pem)\
#&ssl-key=(/root/clientcert/client-key)

#Denote, the above documentation assumes that the integration does require a Password based on Syntax interaction.
#
#To account for a passwordless structure of where we can access the structure without a explicit PW,
#i.e - pw-less or integrated unto Unix socket connections, we must use the following Syntax:
#
#mysqlx://user:@localhost

#We can also utilize Dictionaries in terms of connection details towards a server, with the
#shell.connect() or dba.createCluster() MySQL Shell commands and with MySQL Connectors that implement the X DevAPI.

#Unlike URI strings, we need not escape characters in a Dictionary structure composition.

#If no PW is specified in the dict, none is promted for.

#Some examples are as follows:

#A X protocol connection to a local server @ port 33065
#{user:'user', host:'localhost', port:33065}

#A classic MySQL protocol X protocol connection, local server @ 3333
#{user:'user', host:'localhost', port:3333}

#An X protocol connection to a remote server instance, using a host name, an IPv4 address and an IPv6 address, is showcased:
#
#{user:'user', host:'server.example.com'}
#{user:'user', host:198.51.100.14:123}
#{user:'user', host:[2001:db8:85a3:8d3:1319:8a2e:370:7348]}
#
#We can also display an optional schema to represent a DB
#
#{user:'user', host:'localhost', schema:'world'}
#
# The above showcasing requires a PW.
# Showcasing case of no PW integration required
#
# {user:'user', password:'', host:'localhost'}

#There are a number of ways that we can specify program options:

#CMD line after the instegated command

#Options file to integrate options before running the program

#List the options in the environment variables

#Since the options are iteratively parsed, on duplications, the last one in the ordering is commited:

#mysql -h example.com -h localhost <- Will resolve to -h Localhost, since repetition of -h command parsing

#In the case of conflicting or related options are given - the later in the ordering is taken, instead of the earlier
#mysql --column-names --skip-column-names

#The ordering of processing is:
#Environment variables
#option files
#command line

#for the server, mysqld-auto.cnf takes highest prio (i.e, last)

#The following designates and showcases the usage of options on the CMD line

#Options are given after the cmd name

#A option argument begins with one or two dashes, depending on the format of the option.
#
#An example is the help command:
#
#-? (short) or --help (long)

#Option namings and designations are case sensitive. Example showcasing this:
#
# -v (verbose) or -V (version)

#Of course, sometimes options need arguments, as is showcased:
#
#-h localhost 
#
#or
#
#--host=localhost

#Delegation of parameters in long formatted PWs are separated with a =
#
#--password=<some value goes here> #Incinuates that we are to connect with said PW
#
#--password #Prompts for PW

#In the case of shortcutting the letter designation of password prompts, the dynamics can be seen as follows:
#
#mysql -ptest #Will attempt to access with a PW value of test, to whatever DB it defaults to
#
#mysql -p test #Will attempt to access the test DB, with no pw defined

#Do denote, that in terms of commands _ and - are synonymous in terms of interpretation
#
#--skip-grant-tables is the same as --skip_grant_tables

#We can also utilize suffixes in terms of utilization of commands.

#The notations are as follows: K, M, G (1024^1, 1024^2, 1024^3)
#
#In 8.0.14 or beyond:
#T,P,E (1024^4, 1024^5, 1024^6)

#For instance, if we wish to ping the server 1024 times intertwined with the power:

#mysqladmin --count=1K --sleep=10 ping 
#Denotes to ping 1024 times, 10 seconds interval

#If using filenames as option values, do not use ~

#When we denote to make queries on the CMD line, we use "" encapsulation, for instance
#
#mysql -u root -p --execute="SELECT User, Host FROM mysql.user" #Connect using the user of root, prompt for pw, execute the escaped Query
#

#Different levels of escaping might be needed, in terms of " or '
#
#Multiple statements can be passed in the option value on the CMD line separated by semicolons:
#
#mysql -u root -p -e "SELECT VERSION();SELECT NOW()"

#If we wish - we can disable/enable certain parts:

#Disabling:
#--disable-column-names
#--skip-column-names
#--column-names=0

#Enabling:
#--column-names
#--enable-column-names
#--column-names=1

#We can also use TRUE, OFF, FALSE - Non-case sensitive

#If we denote the --loose, it is a option of denoting that the program do not exit upon an error or unrecognized command, instead it does so with a warning
#
#mysql --no-such-option #Would cause an error, unrecognized command
#
#mysql --loose-no-such-option #Would exit with a warning, despite unrecognized command

#We can also limit session values, akin to memory allocation - as follows, in mysqld:
#
#--maximum-max_heap_table_size=32M - Prevents a client from making the heap table size limit larger than 32M.
#
#--maximum cannot be applied to system vars that are global in scope:
#
#--maximum-back_log=200 #Gives an error because attempted designation to a global system var

#In case of if we wish to denote what options files are read, we can use --verbose and --help
#
#a MySQL program with --no-defaults reads no option files other than .mylogin.cnf
#
#A server started with the persisted globals load system var disabled does not read mysqld-auto.cnf

#The login path group options allow for the following:
#
#host,user,password,port and socket

#To  define what login path to read from in the .mylogin.cnf - we can use the --login-path option.

# If we wish to specify another login path file name, we can set the MYSQL_TEST_LOGIN_FILE environment variable.
# This variable is used by mysql-test-run.pl and is recognized by other mysql clients.

#There is a second config file, that is auto managed by the server - that is called:
#
#mysqld-auto.cnf file in the data directory. This is a JSON file that contains persisted system var settings.
#
#It is created by the server upon execution of SET PERSIST or PERSIST_ONLY.
#
#One should not manage said fail alone, and leave that to the server.

#On Windows systems, the files are read in the following order:
#
# NAME 																	PURPOSE
#
# %WINDIR%\my.ini, %WINDIR%\my.cnf 							Global options

# C:\my.ini, C:\my.cnf 											Global options

# BASEDIR\my.ini, BASEDIR\my.cnf 							Global options

# defaults-extra-file 											The file specified with --defaults-extra-file (if any)

# %APPDATA%\MySQL\.mylogin.cnf 								Login path options (clients only)

# DATADIR\mysqld-auto.cnf 										System variables persisted with SET PERSIST or PERSIST_ONLY (server only)

#The %WINDIR% and %APPDATA% are basically system path designations that are found by utilization of Regex,
#to find them, we can simply echo their  designation in the cmd line:
#
# C:\> echo %WINDIR% #Showcases where the Windows directory is
#
# C:\> echo %APPDATA% #Showcases where the Appdata dir is

#BASEDIR refers to the MySQL base install dir. usually, it is at C:\PROGRAMDIR\MySQL\MySQL 8.0 Server
#where the Programdir, is the program files dir.

#DATADIR is the MySQL data dir. It is used to find mysqld-auto.cnf - the default being the data dir loc
#built in when MySQL was compiled - but can be changed with --datadir specified as a option-file.

#It can also be changed by virtue of cmd line designation before the mysqld-auto.cnf is processed.

#On Unix, the ordering of the startup is as follows:
#
# FILE NAME 						PURPOSE
# /etc/my.cnf 						Global options
# /etc/mysql/my.cnf 				Global options
# SYSCONFDIR/my.cnf 				Global options
# $MYSQL_HOME/my.cnf 			Server-specific options (server only)
# defaults-extra-file 			The file specified with --defaults-extra-file, if any
# ~/.my.cnf 						User-specific options
# ~/.mylogin.cnf 					User-specific login path options (clients only)
# DATADIR/mysqld-auto.cnf 		System variables persisted with SET PERSIST or PERSIST_ONLY (server only)

#As per usual, the ~ denotes the home dir, the set system var of $HOME
#
# SYSCONFDIR is the dir specified with the SYSCONFDIR option to CMake when MySQL was built.
# By default, this is the etc file dir

# MYSQL_HOME is an env variable containing the path to the dir in which the server-specific my.cnf file
# resides.
#
# If MYSQL_HOME is not set and you start the server using mysqld_safe, mysqld_safe sets it to BASEDIR, the MySQL base install dir.

# DATADIR refers to the MySQL data dir. As used to find mysqld-auto.cnf, its default value is the data dir location built in when
# MySQL was compiled.
#
# can be changed with --datadir specified as an option-file or command-line option processed before mysqld-auto.cnf is processed.

# If multiple instances are given, the latest is taken.
#
# The one exception is mysqld, where the first is taken of the --user option as security precaution.

#The following integration rules adheres to the manually edited files - not standing in terms of the .mylogin.cnf which is
# created using mysql_config_editor and is encrypted. 
#
# This too accounts for mysqld_auto.cnf, which the server creates in JSON.

#In terms of Options files, the following rules are adhered to:

# Any cmd line integrated on CMD line is done with --, in option files we omit thoose.

# Empty lines are ignored. Comments start with ; or #

# [group] denotes a group subsectioning. Holds until end of file or different Group designation.

#Leading and trailing spaces are deleted. We can have spaces around the =

#We are allowed to use the following escape sequences:
#
# \b, \t, \n, \r, \\ and \s
#
# they are in order:
#
# backspace, tab, newline, carriage return, backslash and space

#The chars are only escaped if they are not valid commands. i.e, \s is not escaped - \S is, due to invalid command.

#The above implies that we can write a \ as either: \\ or \

#The escape rules in terms of opton files is denoted as conversion unto "(char)" upon errornous registration of a command.
#As in, if \x is not a command, it's converted to "x"

#Note: In option files, on Windows - \ can be written as / as well

#Examples of usage:

#basedir="C:\\Program Files\MySQL\MySQL Server 8.0"
#basedir="C:\\Program Files\\MySQL\\MySQL Server 8.0"
#basedir="C:/Program Files/MySQL/MySQL/MySQL Server 8.0"
#basedir=C:\\Program\sFiles\\MySQL\\MySQL\sServer\s8.0

#If a option name denotation is the same as a program name, then that group applies specifically to that program.
#Akin to:
#
# [mysqld] and [mysql] applying to mysqld and mysql respectively.

# [client] is read by all client programs provided in MySQL distributions.

# Do note, we have to be careful about level of options that we put in in terms of Client,
# that it is understood by all levels of the clients. If not understood, the client will raise an exception and quit.

#In terms of ordering of hierarchy in terms of options, we go from:
#
#Highest global reach
#
# More specific
#
# Most specific
#
# For instance:
#
# [client]
# port=3306
# socket=/tmp/mysql.sock
#
# [mysqld]
# port=3306
# socket=/tmp/mysql.sock
# key_buffer_size=16M
# max_allowed_packet=128M
#
# [mysqldump]
# quick

#Another example of a option file:

#[client]
# Send out a standardized password for all client level integrations
# password="my password"

#[mysql]
#no-auto-rehash
#connect_timeout=2

#We can target versionings as well:
#
#[mysqld-8.0]
#sql_mode=TRADITIONAL

#To include specific files or even dirs, we can use !include and !includedir
#
# !include /home/mydir/myopt.cnf #reads that specific config file
#
# !include /home/mydir #reads all the option files in mydir

#On Windows, the extensions included are .ini and .cnf
#
#Linux is .cnf
#
#Past that, MySQL does not guarantee ordering of integration

#As far as Grouping goes contra Parsing, as we iterate - we integrate what actually is
#targeted by the respective groupings - akin to that if MySQLD is reading something - it will
#trigger thoose respective groups.

#Past this, we can come to talk about CMD line options that affect option-file handling

#The following commands, to function properly - must be given before other options, except for:
#
# --print-defaults can be used after --defaults-file, --defaults-extra-file or --login-path
#
# On Windows, if the server is started with the --defaults-file and --install options,
# --install must be first.
#

#--defaults-extra-file=file_name - reads this option file after the global option file 
#
# On Unix, this is read before the user option file 

# On all platforms, this is read before the login path file.

# The parameter name in terms of file name, is treated as a relative path towards the CWD.
# To fundamentally assess greater control, we can denote the full explicit path, if we want

# --defaults-file=file_name - reads the given option file.
# 
# Note: even with the above, mysqld refers to mysqld-auto.cnf and client refers to .mylogin.cnf

# --defaults-group-suffix=str
#
# Denotes a default suffix of grouping name to read.
#
# For instance - a parameter name of "dogs" would groups that have a suffix of "dogs",
# like - [options_dogs]

# --login-path=name
#
# Reads options from the named login path in the .mylogin.cnf login path file.
# This specific group denotes which MySQL server to connect to and which account to authenticate as.
#
# To create or modify this login path file - use the mysql_config_editor

#This path is read even if --no-defaults is set.
#
# The given command is appended unto the already list of defaulted programs, as can be showcased:
#
# mysql --login-path=somextra
#
# Would end up with mysql reading [client] and [mysql] from the option files,
# and [client], [mysql], and [mypath] from the login path file.

#To specify an alternate login path file name, set the MYSQL_TEST_LOGIN_FILE env variable

#--no-defaults
#
# Prevents default option files from being read.
# Will still read .mylogin.cnf

#--print-defaults
#
#Prints the program name and all of the options that it gets from the option files.
#PWs are masked.

# --max_allowed_packet=32M #Can be specified in Bytes.
#
# Still power denotation in terms of K, M, G (1024^1, 1024^2, 1024^3) and T,P,E (1024^4, 1024^5, 1024^6)
#
# In option files:
#
# [mysql]
# max_allowed_packet=32M #can be specified in bytes

#- and _ are treated as equals in the context of variable names
#
# example:
#
# [mysqld]
# key_buffer_size=512M
# 
# is identical to
#
# [mysqld]
# key-buffer-size=512M

#In terms of variable naming, we can give ambigious naming that can be autocompleted,
#However, it's just a better idea to denote a option name htat is fully declared.

# mysql --max=1000000 would be interpreted as ambigious as it would not be clear to what it means, in terms of
# meaning max_allowed_packet or max_join_size
# to which we would be warned.

#Server setup denotation of commands do not support arithmetic interpretation in terms of intialization
#
# mysql --max_allowed_packet=16M #Allowed in server startup
# mysql --max_allowed_packet=16*1024*1024 #Not allowed, due to being a operation

# At runtime, when the server is running etc, though:
# SET GLOBAL max_allowed_packet=16M; #Not allowed in a runtime env.
# SET GLOBAL max_allowed_packet=16*1024*1024;

#For options that do not require a value, we can omit the assignment operator in notation (=):
#
# mysql --host=somehost --user=someguy #Usable with default value integrations
#
# mysql --host tonfisk --user jon #Usable with non-default value integrations

# In terms of omitting variables names, can cause errors akin to skipping, as showcased:
#
# mysql --host --user jon #Will give an error in trying to access host --user

#An example of denoting of where to log errors, in terms of a UNIX system
# NOTE: For safety, use = assignment in variable name contexts

# mysqld_safe --log-error=my-errors & #The & is just a background designation operator for UNIX systems
#
#For default isntallation and relative pathing, this gives to:
# '/usr/local/mysql/var/my-errors.err'

#The next section will be about setting ENV Vars

#We can denote environment variables in terms of Usernames, ports, exporting etc:
#
# SET USER=your_name
#
# For unix systems, accounting for sh, ksh, bash, zsh:
#
# MYSQL_TCP_PORT=3306
# export MYSQL_TCP_PORT
#
# For csh and tcsh:
#
# setenv MYSQL_TCP_PORT 3306

#The above are allocated to session. To denote for more permanent startup status:
#
# Windows -> Control panel
#
# Unix (Bash) -> .bashrc or .bash_profile for bash 
# Unix (tcsh) -> .tcshrc

#An example of modifying the path denotation variable in Bash
#
# #Assume /usr/local/mysql/bin is the installation path
# 
# PATH=${PATH}:/usr/local/mysql/bin #put in .bashrc file to allow for easy access to MySQL setup in terms of options

#Note, the .bashrc is for login shells, and .bash_profile is for nonlogin shells

#In the case of tcsh:
# setenv PATH ${PATH}:/usr/local/mysql/bin

#The next section is mysqld_safe

#Some Unix systems involve usage of a MySQL Server startup that is safer,
#i.e - mysqld_safe

#These features include things like restarting the server and logging runtime info to an error log.

#On some specific UNix systems, akin to RPM or Debian, include systemd support for managing MySQl server
#startup/shutdown.

#If we wish to override the default options and specify a explicit name of the server we wish to run
#we can specify --mysqld or --mysqld-version option to mysqld_safe.

#You can also use --ledir to indicate the dir where mysqld_safe should look for the server.

#The options in terms of mysqld_safe is the same as mysqld

#If the option is unknown to mysqld_safe, they are passed to mysqld if it's done on the cmd line
#
#However, if this is done in a option file - specified to [mysqld_safe] as a group
#they are ignored.

#mysqld_safe will read all of the options from the [mysqld], [server] and [mysqld_safe] sections
#in option files.

#Note, for backwards compability cases - mysqld_safe also reads [safe_mysqld] sections

#The following denotes the options for mysqld_safe

# Format 	 					Desc
#	
# --basedir 					path to MySQL installation dir
# --core-file-size 			Size of core file that mysqld should be able to create
# --datadir 					path to the data dir
# --defaults-extra-file 	Read named option file in addition to usual option files
#
# --defaults-file 			Read only named option file
# --help 						display help message and exit
# --ledir 					 	Path to directory where server is located
# --log-error 					Write error log to named file
#
# --malloc-lib 						Alternative malloc library to use for mysqld
# --mysqld 								Name of server program to start (in ledir directory)
# --mysqld-safe-log-timestamps 	Timestamp format for logging
# --mysqld-version 					Suffix for server program name
# --nice 								Use nice program to set server scheduling priority
# --no-defaults 						Read no option files
#
# --open-files-limit 				Number of files that mysqld should be able to open
# --pid-file 							Path name of server process ID file
# --plugin-dir 						Directory where plugins are installed
# --port 								Port number on which to listen for TCP/IP connections

# --skip-kill-mysqld 				Do not try to kill stray mysqld processes
# --skip-syslog 						Do not write error messages to syslog; use error log file
# --socket 								Socket file on which to listen for Unix socket connections

# --syslog 								Write error messages to syslog
# --syslog-tag 						Tag suffix for messages written to syslog
# --timezone 							Set TZ time zone environment variable to named value
# --user 								Run mysqld as user having name user_name or numeric user ID user_id

#Some further covering in terms of different parts
#
#--help - Display a help message and exit
#
#--basedir=dir_name - The path to the MySQL install dir

#--core-file-size=size - The size of the core file that mysqld should be able to create. 
#The value of the option is passed to ulimit -c
#
# If we disable innodb buffer pool in core file, we can reduce the core file size.

#--datadir=dir_name - The path to the data dir

#--defaults-extra-file=file_name - Read this option file in addition to the usual option files.
#
# If the file is not found, does not exist or permissions are not given - the server exists with an error.
#
# file_name is interpreted as relative to the current dir if given as a relative path name rather than
# a full path name. 
#
#This must be the first option on the cmd line if used.

#--defaults-file=file_name
#
#Use only the given option file. If the file does not exist or is otherwise inaccessible, the server exits with an error.
#
#file_name is interpreted as relative to the current dir if given as a relative path name rather than a explicit one.
#
#This must be the first option on the cmd line if used

#--ledir=dir_name - 
#
#If mysqld_safe cannot find the server, use this option to indicate the path name to the dir where the server is located.
#
#This command can only be given on cmdline, not in option files. On platforms that use systemd, the value can be specified
#in the value of MYSQLD_OPTS.

#--log-error=file_name
#
#Write the error log to the given file

#--mysqld-safe-log-timestamps
#
#This option is the one that controls the format of timestamps in the log output produced by mysqld_safe.
#
#If the value does not belong to any of the following, a warning is logged and resorts to UTC formatting.
#
#UTC,utc - ISO 8601 UTC format (this is the same as --log timestamps=UTC for the server) - Defaults to this

#SYSTEM, system - ISO 8601 local time format (same as --log timestamps=SYSTEM for the server)

#HYPHEN, hyphen - YY-MM-DD h:mm:ss format, as in mysqld_safe for MySQL 5.6

#LEGACY, legacy - YYMMDD hh:mm:ss format, as in mysqld_safe prior to MySQL 5.6

#--malloc-lib=[lib name]
#
#The name of the library to use for memory allocation instead of the system malloc() library. 
#
#The option value must be one of the dirs:
# /usr/lib
# /usr/lib64
# /usr/lib/i386-linux-gnu
# /usr/lib/x86_64-linux-gnu

#The --malloc-lib option works by modifying the LD_PRELOAD env value to affect dynamic linking to enable
#the loader to find the memory-allocation library when mysqld runs.

#Some notes on this:

#If the option is not given, or is given without a value (--malloc-lib=), LD_PRELOAD is not modified
#and no attempt is made to use tcmalloc.

#If the option is given as --malloc-lib=tcmalloc, mysqld_safe looks for a tcmalloc library in /usr/lib
#
#If tcmalloc is found, its path name is added to the beginning of the the LD_PRELOAD value for mysqld.
#
#If tcmalloc is not found, mysqld_safe aborts with an error.

#If the option is given as --malloc-lib=/path/to/some/library, that full path is added to the beginning
#of the LD_PRELOAD value.
#
#If said path is not legitimate - as in nonexistent or unreadable, mysqld_safe aborts with an error.

#For the cases of where mysqld_safe adds a path name to LD_PRELOAD - it adds the path to the beginning of any
#existing value the variable already has.

#NOTE: In case that our system manage using systemd, mysqld_safe is not available.
#Thus - we instead specify the allocation lib by setting LD_PRELOAD in /etc/sysconfig/mysql.

#In terms of Linux, we can use the libtcmalloc_minimal.so lib on any platform for which a tcmalloc
#package is installed in /usr/lib by adding the following lines to my.cnf:
#
# [mysqld_safe]
# malloc-lib=tcmalloc

#To use a specific tcmalloc lib, specify its full path name:
#
# [mysqld_safe]
# malloc-lib=/opt/lib/libtcmalloc_minimal.so

#--mysqld=prog_name
#
#The name of the server program (in the ledir directory) that you want to start.
#
#This option is needed if you use the MySQL binary distirbution but have the data
#dir outside of the binary distribution.
#
#If mysqld_safe cannot find the server, use the --ledir option to indicate the path name
#to the dir where the server is located.
#
#This command is only available on cmd line, not in option files. On platforms that use systemd,
#the value can be specified in the value of MYSQLD_OPTS.

#--mysqld-version=suffix
#
#This option is similar to the --mysqld option, but you specify only the suffix for the server program name.
#The base name is assumed to be mysqld.
#
#--nice=priority
#
#Use the nice program to set the server's scheduling prio to the given value.

#--no-defaults
#
#Do not read option files. Can be used to prevent crashing of attempting to access invalid paths/errors raised are simply offset
#as in the failed files are not read.

#--open-files-limit=count
#
#The number of files that mysqld should be able to open. This options value is passed to ulimit -n.
#
#NOTE: This call requires root permissions in terms of level of started the program.

#--pid-file=file_name
#
#The path name that mysqld should use for its process ID file.

#--plugin-dir=dir_name
#
#The path name of the plugin dir

#--port=port_num
#
#The port number that the server should use when listening for TCP/IP connections. The port number
#must be 1024 or higher lest the server is started by root priveleges.

#--skip-kill-mysqld
#
#An option to disallow killings of stray mysqld processes at startup.
#Works only on Linux.

#--socket=path
#The Unix socket file that the server should use when listening for local connections.

#--syslog, --skip-syslog
#
# --syslog: Causes error messages to be sent to syslog on systems that support the logger program.

# --skip-syslog: suppresses the use of syslog; messages are written to a error log file.

#If syslog is used for error logging, daemon.err facility/severity is used for all log messages.

#However, the above is deprecated in terms of controlling mysqld.
#To control the facility, use the server log syslog facility system var.

#--syslog-tag=tag: also deprecated, use the server log syslog tag system var.

#--timezone=timezone - Sets the TZ time zone environment var to the given option value.
#Legal time zone specs is relative to OS doc specs

#--user={<USER> name|<USER> id}
#
#Run the mysqld server as the user having the name user_name or the numeric user ID user_id.
#(<USER> in this context refers to a system login account - not a part of the MySQL users in teh grant tables.)

#Illustration of forced ordering in terms of --defaults-file or --defaults-extra-file:
#
# mysqld_safe --port=port_num --defaults-file=file_name #Will ignore the default file command, due to not first place ordering
#
# mysqld_safe --defaults-file=file_name --port=port_num

#To have a decent run with mysqld_safe - one of the following conditions need to be true:
#
# If we executed mysqld_safe from the MySQL Install dir - the server and DB must be able to be found in terms of
# a relative path to the working dir.
#
# For binary distributions, mysqld_safe looks for bin and data in the CWD

# For source distris, it looks for libexec and var dirs

# If the above fails, it attempts by absolute paths akin to:
#
# /usr/local/libexec
#
# or 
#
# /usr/local/var

#These locations are determined upon config when installing MySQL.

#An example of running MySQL anywhere, based on relative pathing, assuming initial path is done to the MySQL Install dir:
#
# cd mysql_installation_directory
# bin/mysqld_safe & #Delegate to background job

#If this fails, we can delegate with --ledir or --datadir to indicate dirs for the server and DB.

#The default attempts to attempting to start is 5/second, by utility of sleep and date.
#If this is exceeded - it waits 1 full second before going at it again.

#Error messages go to syslog and stdout.
#To direct options - use syslog.

#The following covers server interaction on the CMD line.
#Naming refers to local installation naming, such as mysqld or mysql.
#I will simply refer to it as mysql here.

#This pertains to Linux systems.

#To start/Stop the script:
#
# mysql start #To start
# mysql stop  #To stop

#To run the server as some specific user, we can config the /etc/my.cnf - adding a user option to
# the [mysqld] group.

#To start or stop MySQL Automatically on the server - we can add start and stop commands in /etc/rc*

#If we use the Linux server RPM package (MySQL-server-VERSION.rpm) or a native Linux package, it may be installed
# in the /etc/init.d dir with the name mysqld or mysql.

#If we do not have the server installed, we can copy a version of it
#
#cp mysql.server /etc/init.d/mysql  #Copy the server to the designated folder
#chmod +x /etc/init.d/mysql

#Depending on our system and integration of Unix - we can use chkconfig to activate it to run at system startup
#
# chkconfig --add mysql
#
# Sometimes, we need a different version
#
# chkconfig --level 345 mysql on

#If it is a version of FreeBSD, the scripts should generally go in /usr/local/etc/rc.d/
#
#Install the mysql.server script as /usr/local/etc/rc.d/mysql.server.sh to enable automatic startup

#The base name file pattern must be *.sh to trigger, otherwise it is silently ignored.

#Sometimes, some operative systems use /etc/rc.local or /etc/init.d/boot.local to start additional
#services on startup.
#
#To utilize it, append something akin to the following to a startup file:
#
# /bin/sh -c 'cd /usr/local/mysql; ./bin/mysqld_safe --user=mysql &'

#mysql.server reads from [mysql.server] and [mysqld] sections of option files.
#
#We can add options for mysql.server in a global /etc/my.cnf, it might look as follows:
#
# [mysqld]
# datadir=/usr/local/mysql/var
# socket=/var/tmp/mysql.sock
# port=3306
# user=mysql

# [mysql.server]
# basedir=/usr/local/mysql

#The following are mysql.server option-file options
#
# Option Name 								Desc 														Type
# basedir 						Path to MySQL installation dir 								Directory name
# datadir 						Path to MySQL data directory 									Directory name
# pid-file 						File in which server should write its process ID  		File name
# service-startup-timeout 	How long to wait for server startup 						Integer

#The following is explonations of the different parts:
#
#basedir=<dir name> # The path to the MySQL installation dir
#
#datadir=<dir name> # The path to the MySQL data dir
#
#pid-file=<file name> # The path name of the file in which the server should write its process ID.
#
## if this option is not given, it defaults to <host_name>.pid
# This file value overrides the mysqld_safe specified in [mysqld_safe] option file group
#
# For safety in terms of the server value starting designations, we can specify both
# in [mysqld_safe] and [mysqld] groups.

# service-startup-timeout=<seconds>
#
# How many seconds to wait for confirmation of server startup.
# If the server does not start within said limit, mysql.server exits with an error.
# Defaults to 900.
#
# Negative is forever (no timeout), 0 is to not wait at all.

#The following is related to mysqld_multi - which is to manage multiple MySQL servers

#The mysqld_multi is designed to handle/listen to different connections on different Unix sockets files 
# and TCP/IP ports.

#The mysqld_multi searches for groups that are called [mysqldN] in my.cnf
#
# Or in the file named by the --defaults-file option
#
#N refers to the group number, to which can also be represented as GNR.
#It can be any positive integer.

#Each respective numeral represents a server/connection - they have their own values
#
#To invoke mysqld_multi - we can use the following syntax:
#
# mysqld_multi [options] {start|stop|reload|report} [GNR[, GNR] ...]

#If no list exists - mysqld_multi performs the operation for all servers in the option file.
#
#We can perform more specific numerals in terms of listing of gnr's, operations and listing of options

#Some examples of utilization of starting multiple servers, groupings etc:
#
# mysqld_multi start 17 #Just starts nr 17
#
# mysqld_multi stop 8, 10-13 #8, 10,11,12,13
#
# mysqld_multi --example #more examples

#The search order for option files are as follows:
#
# --no-defaults - no option files read
#
# --defaults-file=<file name> - onl the named file is read

# Beyond this standard prio is taken, incl. --defaults-extra-file=<file name>

#Option files read are searched for [mysqld_multi] and [mysqldN] option groups.
#
# The [mysqld_multi] can be used for options to mysqld_multi itself

# The [mysqldN] groups can be used for options passed to specific mysqld instances.

# The [mysqld] or [mysqld_safe] groups can be used for common options read by all instances of mysqld or
# mysqld_safe.

# We can specify a --defaults-file=<file name> option to use a different config file for that instance
# To which the sourceo f [mysqld] or [mysqld_safe] is redirected to this file.

# The following options are what pertain to mysqld_multi:
#
# --help - Displays a help message and exits
#
# --example - Display a sample option file
#
# --log=<file name> - Specify the name of the log file. If hte file exists, log output is appended to it.
#
# --mysqladmin=<prog name> - the mysqladmin binary to be used to stop servers
#
# --mysqld=<prog name> - The mysqld binary to be used. We can specify mysqld_safe for this option.
# if we do - we can include mysqld or ledir in the corresponding [mysqldN] option group.
#
# These options are to indicate the name of the server that mysqld_safe should start and the path
# name of the dir where the server is located.
#
# For instance:
#
# [mysqld38]
# mysqld = mysqld-debug
# ledir = /opt/local/mysql/libexec

# --no-log - Print log info to stdout rather than the log file. By default, it goes to log.

# --password=<password> - The PW of the MySQL acc to use when invoking mysqladmin. Non-optional, for this program.

# --silent - Silent mode, no warnings

# --tcp-ip - Connect to each MySQL server through the TCP/IP port instead of the Unix socket file.
# (If a socket file is missing, the server might still be running, but accessible only through the TCP/IP port)
#
# By default, the connections are made through the Unix socket file. Affects stop and report operations.

# --user=<user name> - User name of the MySQL acc to use when invoking mysqladmin

# --verbose - Verbose mode

# --version - Version info and exit

#NOTE: Use seperate dirs when splintering with mysqld servers.
#
# Make sure of clearance of reading/writing of each file dir.
#
#Splintering does not give performance increasing in terms of the threading pooling

#We also have to make sure that privs to SHUTDOWN is given, and that we have the same connection params for all
#parts involved. 

#Showcasing of targetting and giving privs to each resp. server:
#
# mysql -u root -S /tmp/mysql sock -p #Will prompt for pw
# CREATE USER 'name_to_be_given_to_multi_admin'@'your_server' IDENTIFIED BY 'multipass'
#
# GRANT SHUTDOWN ON *.* TO 'name_to_be_given_to_multi_admin'@'your_server'
#
# The above, is shorthand for giving shutdown privleges on all fronts in terms of the given user account 
#
# The above must be repeated for every mysqld server.
# We must also have multi_admin rights from where we connect with mysqld_multi

# The respective socket files in terms of Unix and TCP/IP port must be different for every mysqld.
#
# If the host has multiple network addresses, we can use --bind-address to cause different servers
# to listen to different interfaces

# The --pid-file option is important for if we use mysqld_safe to start mysqld (for example, --mysqld=<mysqld_safe>
# We need to have a seperate pid file for every respective mysqld.

# The advantage of using mysqld_safe instead of mysqld is that mysqld_safe monitors its mysqld process,
# allowing us to have restarts in case of kill signals (kill -9) or segmentation faults.

#To be allowed to use --user for mysqld, we have to run the mysqld_multi as root
#Designating options in the option file, does not matter.

# if we try to run mysqld whilst not root, we get a warning and it's run under our own Unix acc

#The following is an example of having a option file to use with mysqld_multi:

# The order of the mysqld programs are started or stopped depends on the order in the opt file
# The sequence need not be unbroken 

# [mysqld_multi] #The base mysqld_multi structure
# mysqld 		= /usr/local/mysql/bin/mysqld_safe
# mysqladmin 	= /usr/local/mysql/bin/mysqladmin
# user 			= multi_admin
# password 		= my_password

# [mysqld2] #The splinters
# socket 		= /tmp/mysql.sock2
# port 			= 3307
# pid-file 		= /usr/local/mysql/data2/hostname.pid2
# datadir 		= /usr/local/mysql/data2
# language 		= /usr/local/mysql/share/mysql/english
# user 			= unix_user1

# [mysqld3]
# mysqld 		= /path/to/mysqld_safe
# ledir 			= /path/to/mysqld-binary/
# mysqladmin 	= /path/to/mysqladmin
# socket 		= /tmp/mysql.sock3
# port 			= 3308
# pid-file 		= /usr/local/mysql/data3/hostname.pid3
# datadir 		= /usr/local/mysql/data3
# language 		= /usr/local/mysql/share/mysql/swedish
# user 			= unix_user2

# [mysqld4]
# socket 		= /tmp/mysql.sock4
# port 			= 3309
# pid-file 		= /usr/local/mysql/data4/hostname.pid4
# datadir 		= /usr/local/mysql/data4
# language 		= /usr/local/mysql/share/mysql/estonia
# user 			= some_user_5

# [mysqld6]
# socket 		= /tmp/mysql.sock6
# port 			= 3311
# pid-file 		= /usr/local/mysql/data6/hostname.pid6
# datadir 		= /usr/local/mysql/data6
# language 		= /usr/local/mysql/share/mysql/japanese
# user 			= unix_user4

#The next section covers MySQL installation related things, akin to:
# comp_err, ssl_rsa, tzinfo_to_sql, mysql_upgrade etc.

#comp_err:

# Creates the errmsg.sys file that is used by mysqld to determine the error message to display
# for different error codes.

# comp_err normally is run automatically when MySQL is built. It compiles the errmsg.sys file
# from the text file located at sql/share/errmsg-utf8.txt in the MySQL source distr.

# It also generates mysqld_error.h, mysqld_ername.h and sql_state.h header files

# To invoke comp_err:

# comp_err [options]

# Supports the following options:

# --help, -? - Displays a help message and exit

# --charset=<dir name>, -C dir_name - The char set directory. The default is ../sql/share/charsets

# --debug=<debug options>, -# <debug options> - Write a debug log. 
# A typical debug_options string is d:t:O, <file name>
# the default is:
# d:t:O, /tmp/comp_err.trace

# --debug-info, -T - Print debug info when the program exits

# --header file=<file name>, -H <file_name> - name of the error header file. 
# defaults to: mysqld_error.h

# --in file=<file name>, -F <file_name> - The name of the input file.
# defaults to: ../sql/share/errmsg-utf8.txt

# --name file=<file name>, -N <file_name> - The name of the error name file.
# Defaults to: mysqld_ername.h

# --out dir=<dir name>, -D <dir name> - Name of output base dir
# Defaults to: ../sql/share/

# --out file=<file name>, -O <file name> - Name of the output file
# Defaults to: errmsg.sys

# --statefile=<file name>, -S <file_name> - Name of the SQLSTATE header file.
# Defaults to: sql_state.h

# --version, -V #Displays version info and exits

# mysql_secure_installation:
#
# Allows us to set pw for root accs, remove root accs outside of localhost, remove anon users, remove the test DB
# (The test DB can be accessed by anon users/all users) - we can also remove permits of dbs with name that starts with
# test_

# Base usage:
# mysql_secure_installation

# Doing this, will prompt for an action.

# We can utilize validate_password to check PW strength.

# Showcasing of using cmd line and options files to connect:
#
# mysql_secure_installation --host::1 --port=3307

#The following options can be defined by cmd line or in option file groups of:
# [mysql_secure_installation] 
# [client]

#The options of the mysql_secure_installation are as follows:
#
# FORMAT 													DESC
#
# --defaults-extra-file 				Read named option file in addition to usual option files
# --defaults-file 						Read only named option file
# --defaults-group-suffix 				Option group suffix value
# --help 									Display help messages n exit
# --host 									Host to connect to (IP address or host name)
# --no-defaults 							Read no option files
# --password 								Accepted but ignored. Prompt occurs regardless
# --port 									TCP/IP port number for connection
# --print-defaults 						Print default options
#
# --protocol 								Connection protocol to use
# --socket 									For connections to localhost, the Unix socket file to use
# --ssl-ca 									File that contains list of trusted SSL Certs Auths
# --ssl-capath 							Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 								File that contains X.509 certificate
# --ssl-cipher 							List of permitted ciphers for connection encryption
#
# --ssl-crl 								File that contains cert revocation list files
# --ssl-crlpath 							Dir that contains cert revocation list files
# --ssl-fips-mode 						Whether to enable FIPS mode on the client side
#
# --ssl-key 								file that contains X.509 key
# --tls-version 							Protocols permitted for encrypted connections
# --use-default 							Execute with no user interactivity
# --user 									MySQL user name to use when connecting to the server

# Further explaining of subsections:
#
# --help, -? - Display a help message and exit
# --defaults-extra-file=<file name> - Reads this option file after the global option file, but before the user option file.
# --defaults-file=<file name> - use only the given option file. If the file does not exist or is inaccessible, errors occur.
# 										  Pathing is: relative (default), full on explicit designation
# --defaults-group-suffix=<str> - Additional groupings to read in terms of suffix regex designation (i.e, all of the defaults + suffix matches)
# --host=<host_name>, -h <host_name> - Connect to the MySQL Server on the given host.
#
# --no-defaults - Do not read any option files. If program startup fails due to reading unknown options from an option file, --no-defaults can be used to
# prevent them from being read.
#
# As per usual, if .mylogin.cnf exists - it is read, regardless of options.

# --password=<password>, -p <password> - The option is accepted but ignored. mysql_secure_installation always prompts for PW.
# --port=<port num>, -P <port_num> - TCP/IP port to use for the connection

# --print-defaults - Print the program name and all options that it gets from option files
# --protocol={TCP|SOCKET|PIPE|MEMORY} - The connection protocol to use for connecting to the server.
# --socket=<path>, -S <path> - What Unix socket/Windows pipe to use when connecting to localhost.
# --ssl* - Connect using SSL, implies need to specify SSL keys and certs.

# --ssl-fips-mode={OFF|ON|STRICT} - Controls whether to enable FIPS mode on the client side.
# Denotes what cryptographic operations are permitted - not actually used to establish encrypted connections.

# OFF - Disables FIPS mode.
# ON - Enables FIPS mode.
# STRICT - Enable "strict" FIPS mode.

# If the OpenSSL FIPS Object Module is not available, the onl permitted value is OFF.
# Attempting to ordane ON or STRICT, causes warning at startup, resorting to non-FIPS mode.

# --tls-version=<protocol list> - Protocols permitted by the client for encrypted connections. The value is a comma-separated list
# containg one or more protocol names.
#
# The protocols used depend on the SSL lib used to compile MySQL.

# --use-default - Execute noninteractively. Can be used for unattended installation operations

# --user=<user name>, -u <user_name> - MySQL user name when connecting to the server.

#Next section covers: mysql_ssl_rsa_setup - Creating SSL/RSA files
#
# creates the SSL certificate and key files and RSA key-pair files required to support secure
# connections using SSL and secure password exchange using RSA over unencrypted connections,
# if those files are missing.
#
# Can also be used to create new SSL files if existing ones have expired.
#
# Note, these forms of certs are self-signed - i.e, not safe. This is more about the principle of creation/usage,
# not the factual gain of security in terms of usage.
#
# To invoke mysql_ssl_rsa_setup:
#
# mysql_ssl_rsa_setup [options]
#
# The typical options are --datadir to specify where to create the files, and --verbose to see the openssl commands
# that mysql_ssl_rsa_setup executes.
#
# mysql_ssl_rsa_setup attempts to create SSL and RSA files using a default set of file names. It works as follows:
#
# > checks for the openssl binary at the locations specified by the PATH env var.
# > If not found - nothing happens.
#
# If openssl is present, mysql_ssl_rsa_setup looks for default SSL and RSA files in the MySQL data dir specified
# by the --datadir option or the compiled-in data dir if the --datadir option is not given.
#
# > Checks the data dir for SSL files with the following names:
# ca.pem
# server-cert.pem
# server-key.pem
#
# > If any of the above exist, no SSL files are created. Otherwise, openssl is invoked to create them, for a total of:
#
# ca.pem 			#Self-signed CA cert
# ca-key.pem 		#CA private key
# server-cert.pem #Server cert
# server-key.pem 	#Server private key
# client-cert.pem #Client cert
# client-key.pem 	#Client private key
#
# > Checks data dir for RSA files with the following names:
#
# private_key.pem 	#Private member of private/public key pair
# public_key.pem 		#Public member of private/public key pair

# If any of the above is present, mysql_ssl_rsa_setup creates no RSA files.
# Otherwise, invokes openSSL to create them.
#
# The files enable secure PW exchange using RSA over unencrypted connections for
# accounts authenticated by the sha256_password or caching_sha2_password plugin

# When starting the MySQL Server, it automatically uses the SSL files created by mysql_ssl_rsa_setup
# to enable SSL if no explicit SSL options are given other than --ssl (possibly also --ssl-cipher)
#
# If we prefer to designate the files explicitly, invoke the clients with the --ssl-ca, --ssl-cert and
# --ssl-key options to name the ca.pem, client-cert.pem and client-key.pem files, respectively
#
# The server also automatically uses the RSA files created by mysql_ssl_rsa_setup to enable RSA, if none are explicitly given
#
# If the server has activated SSL, the client uses SSL by default for the connection.
#
# Also, to circumvent the read/write permission problems in terms of locations of Certs,
# due to that the initialized data dir permissions is restricted to the System account that runs the server.
#
# To make the files available, copy them to a dir that is readable (but not writable) by clients:
#
# For local clients, the MySQL install is assumed, thus, we can use a relative path in terms of implied referal in copying:
#
# cp ca.pem client-cert.pem client-key.pem
#
# For remote clients, we distribute the files using a secure channel to ensure they are not tampered with.
#
# If the SSL files have expired - we can use mysql_ssl_rsa_setup to create new ones:
#
# > Stop the server
# > Rename or remove the existing SSL files. You may wish to make a backup of them first.
# (RSA's do not expire)
# > Run mysql_ssl_rsa_setup with the --datadir option to specify where to create the new files.
# >Restart the server

# mysql_ssl_rsa_setup supports the following CMD line options - can be specified on the CMD line or 
# in the [mysql_ssl_rsa_setup] and [mysqld] groups of an option file.

# Options for mysql_ssl_rsa_setup :
#
# FORMAT 			DESC
# --datadir 		Path to data directory
# --help 			Display help messagee and exit
# --suffix 			Suffix for X.509 cert Common Name attribute
# --uid 				Name of effective user to use for file permissions
# --verbose 		Verbose mode
# --version 		Display version info and exit

# Further explonation of the commands:
#
# --help, ? - Display a help message and exit
# --datadir=<dir name> - The path to the directory that mysql_ssl_rsa_setup should check for default SSL and RSA files and in
# which it should create files if they are missing. 
#
# Defaults to compiled-in data dir
#
# --suffix=<str> - Suffix of the common name attribute in X.509 certs. The suffix value is limit to 17 chars.
# The default is based on the MySQL version number.
#
# --uid=<name>, -v - The name of the user who should be the owner of any created files. The value is a user name,
# not a numeric user ID. 
#
# In case this is absent, files created by mysql_ssl_rsa_setup are owned by the user who executes it. This option is 
# valid only if you execute the program as root on a system that supports the chown() system call.
#
# --verbose, -v - Verbose mode. Tells about if it skipped SSL, RSA file creation and openssl commands being run.
#
# --version, -V - Display version info and exit.

#Next covers mysql_tzinfo_to_sql - The time Zone tables
#
# Loads the time zone tables in the mysql db. It is used on systems that have a zoneinfo DB (set of files that describe time zones)
#
# Examples of such OS's: Linux, FreeBSD, Solaris, and OS X. One likely location for these is the /usr/share/zoneinfo dir
# (/usr/share/lib/zoneinfo on Solaris).
#
# mysql_tzinfo_to_sql can be invoked several ways:
# mysql_tzinfo_to_sql <tz_dir>
# mysql_tzinfo_to_sql <tz_file> <tz_name>
# mysql_tzinfo_to_sql --leap <tz_file>

#Exampel of invocation:
# mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql #Pipe the output to mysql from the zoneinfo dir path name, access mysql with root user

# mysql_tzinfo_to_sql reads the systems time zone files and generates SQL statements from them. mysql processes them to load the time zone tables.
# 
# The second syntax, loads a single time zone file <tz_file> that corresponds to a time zone name tz_name:
#
# mysql_tzinfo_to_sql <tz_file> <tz_name> | mysql -u root mysql
#
# If we need to account for leap seconds, use the third syntax noted in the above ordering.

#To account for the newly initialized data and to circumvent previously cached time zone data 
# we have to restart the server.

#Next up, is mysql_upgrade

#mysql_upgrade is a utility in terms of integrating updates to tables and capacities in terms of between versionings

#If mysql_upgrade finds that a table has a possible incompability - it performs a table check and, if issues are found
#attempts a table repair.

#The mysql_upgrade runs updating in terms of the MySQL tables

#The base initialization of command is:

#mysql_upgrade [options]

#After we have run mysql_upgrade - we need to stop and restart it.

#If we have multiple MySQL servers running - we can invoke mysql_upgrade with connection parameters
#as can be showcased:
#
# mysql_upgrade --protocol=tcp -P 3306 [other_options]
# mysql_upgrade --protocol=tcp -P 3307 [other_options]
# mysql_upgrade --protocol=tcp -P 3308 [other_options]

#In terms of running on localhost on Unix, the --protocol=tcp options forces a connection
#using TCP/IP rather than the Unix socket file

#NOTE: In case of disabled_storage_engines sys var set to disable certain storage engines (for instance, MyISAM)
#mysql_upgrade might fail as follows:
#
# mysql_upgrade: [ERROR] 3161: Storage engine MyISAM is disabled (Table creation is disallowed)
#
# To handle it, restart the server with disabled_storage_engines disabled.
# We can then run mysql_upgrade successfully. 
#
# After that, restart the server with disabled_storage_engines set to its original value

#mysql_upgrade runs a version comparison in terms of a file named mysql_upgrade_info in the data dir.
#
#This is used to quickly check whether all tables have been checked for this release so that
#table-checking is skipped.
#
#To ignore this file, run --force

#Unless we invoked with --skip-sys-schema - then mysql_upgrade installs the sys schema and upgrades it.
#
# However, if there exists one and has no version view - we have to rename it/remove it and then
#run the upgrade.

#If we wish, we can upgrade specific individual tables with ALTER TABLE ... UPGRADE PARTITIONING

#mysql upgrade can fail to upgrade due to expired PWs, which we can reset with the following:

#mysql -u root -p #Then reset the PW with alter user
#ALTER USER USER() IDENTIFIED BY 'root-password';

#Run the mysql_upgrade again after having exited:
#mysql_upgrade [options]

#The following options are the ones that mysql_upgrade supports
#
# They are found in [mysql_upgrade] and [client]groups of an option file.
#
# FORMAT 																		DESC
# --bind-address 					Use specified network interface to connect to MySQL Server
# --character-sets-dir 			Directory where character sets are installed
# --compress 						Compress all information sent between client and server
#
# --debug 							Write debugging log
# --debug-check 					Print debugging information when program exits
# --debug-info 					Print debugging information, memory and CPU statistics when program exits
# --default-auth 					Authentication plugin to use
# --default-character-set 		Specify default character set
# --defaults-extra-file 		Read named option file in addition to usual option files
#
# --defaults-file 				Read only named option file
# --defaults-group-suffix 		Option group suffix value
# --force 							Force execution even if mysql_upgrade has already been executed for current version of MySQL
# --get-server-public-key 		Request RSA public key from server
#
# --help 							display help messages and exit
# --host 							Connect to MySQL server on given host
# --login-path 					Read login path options from .mylogin.cnf
# --max-allowed-packet 			Maximum packet length to send or recieve from server
#
# --net-buffer-length 			Buffer size for TCP/IP and socket communication
# --no-defaults 					Read no option files
# --password 						Password to use when connecting to server
# --pipe 							On Windows, connect to server using named pipe
# --plugin-dir 					Directory where plugins are installed
#
# --port 							TCP/IP port number for connection
# --print-defaults 				Print default options
# --protocol 						Connection protocol to use
# --server-public-key-path 	Path name to file containing RSA public key
#
# --shared-memory-base-name 	The name of shared memory to use for shared-memory connections
# --skip-sys-schema 				Do not install or upgrade the sys schema
# --socket 							For connections to localhost, the Unix socket file to use
# --ssl-ca 							File that contains list of trusted SSL Certificate Authorities
# --ssl-capath 					Directory that contains trusted SSL Certificate Authority certificate files
#
# --ssl-cert 						File that contains X.509 certificate
# --ssl-cipher 					List of permitted ciphers for connection encryption
# --ssl-crl 						File that contains certificate revocation lists
# --ssl-crlpath 					Directory that contains certificate revocation list files
#
# --ssl-fips-mode 				Whether to enable FIPS mode on the client side
# --ssl-key 						File that contains X.509 key
# --ssl-mode 						Security state of connection to server
# --tls-version 					Protocols permitted for encrypted connections
#
# --upgrade-system-tables 		Update only system tables, not data
# --user 							MySQL user name to use when connecting to server
# --verbose 						Verbose mode
# --version-check 				Check for proper server version
# --write-binlog 					Write all statements to binary log

#The showcasing in terms of Options and what they do:
#
# --help - Display a short help message and exit
# --basedir=<dir name> - The path to the MySQL installation dir
# --bind-address=<ip address> - On a computer having multiple network interfaces, use this to decide which one to use for connecting
# --character-sets-dir=<dir name> - The dir where char sets are installed
#
# --compress, -C - Compress all info between client and server, if both support compression.
# --debug[=<debug options>], -# [<debug options>] - Writes a debug log. Typical: d:t:o, <file_name>
# Defaults to: d:t:O,/tmp/mysql_upgrade.trace
# --debug-check - Print some debugging information when the program exits
# --debug-info, -T - Print debugging information and memory and CPU usage stats when the program exits
#
# --default-auth=<plugin> - A hint about the client-side auth plugin to use.
# --default-character-set=<charset name> - Use <charset_name> as the default character set
# --defaults-extra-file=<file name> - Read this option file after the global option file but (on Unix) before the user option file.
# --defaults-file=<file name> - Use only the given option file. If the file does not exist or inaccessible - error is raised. Path is relative if given as such, Full otherwise.
#
# --defaults-group-suffix=<str> - Read not only the usual option groups, but also groups with usual names and suffix of <str>.
#   										 Normally reads [client] and [mysql_upgrade] - treats str input as suffix regex.
# --force - 							 Ignore the mysql_upgrade_info and force run
#
# --get-server-public-key 			 Requests the public key required for the RSA key-pair PW exchange.
# 											 Applies to the clients whom authenticate with caching_sha2_password auth plugin.
# 											 In case of usage of this plugin - the server does not send the public key lest requested.
# 											 The option is ignored for accs that do not authenticate with said plugin.
# 					
# 											 If a secure connection is rendered to the server, RSA exchange is not used - as such, this command is then ignored.
#
# 											 If --server-public-key-path=<file name> is given and specifies a valid public key file, it takes precedence over
# 											 --get-server-public-key
#
# --host=<host name>, 				 Connect to the MySQL on the given host. 
# -h <host name>
# --login-path=<name> 				 Read options from the named login path in the .mylogin.cnf login path file.
# 											 The login path is the group option that specifies which MySQL server to connect to
# 											 and which acc to authenticate as.
#
# --max-allowed-packet=<value> 	 The max size of the buffer for client/server communication. Defaults to 24MB. Min is 2kb, max is 2Gb.
# --net-buffer-length=<value> 	 The initial size of the buffer for client/server comm. Default is 1MB - 1kb. The min 4KB, max 16MB
# --no-defaults 						 Do not read any option files. Prevents exception raising failures
# 							
# 											 Exception is .mylogin.cnf file, if it exists - is read in all cases (reading PW from File)
# --password[=<password>], 		  
# -p [<password>]	  					 PW. -p prevents space after input, --password without value prompts for it
#
# --pipe, -W 							 On Windows, connect to the server using a named pipe. Applies only if the server supports named-pipe connections
# --plugin-dir=<dir name> 			 The dir in which to look for plugins. Use if --default-auth is used for an Auth plugin, but it is not found.
# --port=<port num>, 
# -P <port_num> 						 The TCP/IP port number to use for the connection.
# --print-defaults 					 Print the program name and all options that it gets from option files.
#
# --protocol=
#{TCP|SOCKET|PIPE|MEMORY} 			 The connection protocol to use for connecting to the server. 
# 											 It is useful when the other connection parameters normally would cause
# 											 a protocol to be used other than the one you want.
#
# --server-public-key-path=       The path name to a file containing a client-side copy of the public key required by the server
# <file name> 							 for RSA key pair-based PW exchange. The file must be in PEM format.
#              
# 											 This option applies to clients that authenticate with the sha256_password or caching_sha2_password
# 											 authentication plugin. This is ignored for accounts that do not authenticate with one of those plugins.
#
# 											 It is also ignored if RSA-based pw exchange is not used, as is the case when the client connects to
# 											 the server using safe connections (SSL)
#
# 											 If --server-public-key-path=<file name> is given and specifies a valid public key file, it takes
# 											 precedence over --get-server-public-key.
#
# 											 For Sha256_pw, this applies only if we used SSL to build the MySQL.
#
# --shared-memory-base-name= 		 On Windows, the shared memory name to use, for connections made using shared memory to a local server.
# <name> 								 Defaults to MySQL. Case-sensitive. Must startup with --shared-memory to enable shared-memory connections.
#
# --skip-sys-schema 					 mysql_upgrade installs the sys schema if it is not installed, and upgrades it to the current version otherwise.
#                                 This suppresses that behavior.
#
# --socket=<path>, -S <path> 		 Connections to localhost, Unix socket file to use - Windows, the named pipe to use.
# --ssl* 								 Options that begin with --ssl specify whether to connect the server using SSL and indicate where to 
# 											 find SSL keys and certs.
#
# --ssl-fips-mode={OFF|ON|STRICT} Controls whether to enable FIPS mode on the client side. The --ssl-fips-mode option differs from other
# 										    --ssl-xxx options in that it is not used to establish encrypted connections, but rather to affect which
# 											 cryptographic operations are permitted.
#
# 											 The options are: OFF (Disable FIPS mode), ON (Enable FIPS mode), STRICT (Enable "strict" FIPS mode).
# 											 
# 											 If the OpenSSL FIPS Object Module is not available, the only permitted value is OFF. 
# 											 Going against it, produces a warning and starts in non-FIPS mode.
#
# --tls-version=<protocol list> 	 The protocols permitted by the client for encrypted connections. The value is a comma-separated list 
# 											 containing one or more protocol names. 
# 												
#                                 The protocols that can be named for this option depend on the SSL library used to compile MySQL.
#
# --upgrade-system-tables, -s 	 Upgrade only the system tables, do not upgrade the data.
#
# --user=<user name>,  				 The MySQL user name to use when connecting to the server. defaults to root.
# -u <user_name>
# 
# --verbose 							 Verbose mode
#
# --version-check, -k 				 Check the version of the server to which mysql_upgrade is connecting to verify that it is
# 											 the same as the version for which mysql_upgrade was built.
# 
# 											 This option is enabled by default - to disable it, use --skip-version-check
#
# --write-binlog 						 By default, binary logging by mysql_upgrade is disabled. Invoke the program with 
# 											 --write-binlog if you want its actions to be written to  the binary log.
#
# 											 When the server is running with global transactions identifiers (GTIDs) enabled
# 										    (gtid mode=ON), do not enable binary logging by mysql_upgrade.
#
# The next section covers mysql on the cmd line
#
# If used interactively, query results are presented in an ASCII table format.
# If not, it's in a tab-separated format.
#
# If there is not enough memory, use --quick. Forces usage of one row at a time instead of 
# buffering in memory and retrieving everything. Utilizes mysql_use_result() C api in the client/server lib,
# instead of the mysql_store_result()
#
# Examples of simple usages:
#
# mysql <db_name>
#
# mysql --user=<user_name> --password <db_name> #Causes prompt
#
# Ctrl+C stops current query or partial inputs.
# To finish a query on the cmd line, end with ;, \g or \G and Enter
#
# We can execute SQL statements in a script file (batch file) as follows:
# mysql db_name < script sql > output tab
#
# On Unix, the client logs statements executed interactively to a history file.
#
# The next section covers mysql options for the Cmd line or [client] and [mysql] groups of an option file.
#
# FORMAT 								DESC
# --auto-rehash 						Enable automatic rehashing
# --auto-vertical-output 			Enable automatic vertical result set display
# --batch 								Do not use history file
# --binary-as-hex 					Display binary values in hexadecimal notation
#
# --binary-mode 						Disable \r\n - to - \n translation and treatment of \0 as end-of-query
# --bind-address 						Use specified network interface to connect to the MySQL Server
# --character-sets-dir 				Directory where character sets are installed
# --column-names 						Write column names in results
# --column-type-info 				Display result set metadata
# --comments 							Whether to retain or strip comments in statements sent to the server
#
# --compress 							Compress all information sent between client and server
# --connect-expired-password 		Indicate to server that client can handle expired-password sandbox mode
# --connect_timeout 					Number of seconds before connection timeout
# --database 							The database to use
# --debug 								Write debugging log; supported only if MySQL was built with debugging support
#
# --debug-check 						Print debugging information when program exits
# --debug-info 						Print debugging information, memory and CPU stats when the program exits
# --default-auth 						Authentication plugin to use
# --default-character-set 			Specify default character set
#
# --defaults-extra-file 			Read named option file in addition to usual option files
# --defaults-file 					Read only named option file
# --defaults-group-suffix 			Option group suffix value
# --delimiter 							Set the statement delimiter
# --enable-cleartext-plugin 		Enable cleartext authentication plugin
#
# --execute 							Execute the statement and quit
# --force 								Continue even if an SQL error occurs
# --get-server-public-key 			Request RSA public key from server
# --help 								Display help message and exit
# --histignore 						Patterns specifying which statements to ignore for logging
# --host 								Connect to MySQL server on given host
#
# --html 								Produce HTML output
# --ignore-spaces 					Ignore spaces after function names
# --init-command 						SQL statement to execute after connecting
# --line-numbers 						Write line numbers for errors
# --local-infile 						Enable or disable for LOCAL capability for LOAD DATA INFILE
#
# --login-path 						Read login path options from .mylogin.cnf
# --max_allowed_packet 				Maximum packet length to send to or recieve from the server
# --max_join_size 					The automatic limit for rows in a join when using --safe-updates
# --named-commands 					Enable named mysql commands
# --net_buffer_length 				Buffer size for TCP/IP and socket communication
#
# --no-auto-rehash 					Disable automatic rehashing
# --no-beep 							Do not beep when errors occur
# --no-defaults 						Read no option files
# --one-database 						Ignore statements except those for the default DB named on the cmd line
# --pager 								Use the given command for paging query output
# --password 							Password to use when connecting to server
#
# --pipe 								On Windows, connect to server using named pipe
# --plugin-dir 						Directory where plugins are installed
# --port 								TCP/IP port number for connection
# --print-defaults 					Print default options
# --prompt 								Set the prompt to the specified format
# --protocol 							Connection protocol to use
#
# --quick 								Do not cache each query result
# --raw 									Write column values without escape conversion
# --reconnect 							If the connection to the server is lost, automatically try to reconnect
# --i-am-a-dummy, --safe-updates Allow only UPDATE and DELETE statements that specify key values
#
# --select_limit 						The automatic limit for SELECT statements when using --safe-updates
# --server-public-key-path 		Path name to file containing RSA public key
# --shared-memory-base-name 		The name of shared memory to use for shared-memory connections
# --show-warnings 					Show warnings after each statement if there are any
# --sigint-ignore 					Ignore SIGINT signals (typically the result of typing Ctrl+C)
#
# --silent 								Silent mode
# --skip-auto-rehash 				Disable automatic rehashing
# --skip-column-names 				Do not write column names in results
# --skip-line-numbers 				Skip line numbers for errors
# --skip-named-commands 			Disable named mysql commands
# --skip-pager 						Disable paging
#
# --skip-reconnect 					Disable reconnecting
# --socket 								For connections to localhost, the Unix socket file or Windows named pipe to use
# --ssl-ca 								File that contains list of trusted SSL Cert Auths
# --ssl-capath 						Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 							File that contains X.509 cert
#
# --ssl-cipher 						List of permitted ciphers for connection encryption
# --ssl-crl 							File that contains certificate revocation lists
# --ssl-crlpath 						Directory that contains cert revocation list files
# --ssl-fips-mode 					Whether to enable FIPS mode on the client side
# --ssl-key 							File that contains X.509 key
# --ssl-mode 							Security state of connection to server
#
# --syslog 								Log interactive statements to syslog
# --table 								Display output in tabular format
# --tee 									Append a copy of output to named file
# --tls-version 						Protocols permitted for encrypted connections
# --unbuffered 						Flush the buffer after each query
#
# --user 								MySQL user name to use when connecting to server
# --verbose 							Verbose mode
# --version 							Display version information and exit
# --vertical 							Print query output rows vertically (one line per column value)
# --wait 								If the connection cannot be established, wait and retry instead of aborting
# --xml 									Produce XML output
#

# Further explonation of the interactions:
#
# --help, -? - Display a help message and exit
# --auto-rehash - Enable automatic rehashing. On by default, enables database, table and column name completion.
# 					   Use --disable-auto-rehash to disable rehashing. That causes mysql to start faster, but you must
# 						issue the rehash command or its \# shortcut if you want to use name completion.
#
# 						To cycle through completion of names, write the first part and press Tab to cycle Regex matchings.
# 						Does not trigger unless there is a default DB.
#
# 						The above requires a MySQL client that is compiled with the readline library. Typically, the readline
# 						library is not available on Windows.
#
# --auto-vertical-output - Cause result sets to be displayed vertically if they are too wide for the current window, and using
# 									normal tabular format otherwise. (Applies to statements terminated by ; or \G)
#
# --batch, -B 				 - Print results using tab as the column separator, with each row on a new line. With this option, mysql
# 									does not use the history file.
#
# 									Batch mode results in nontabular output format and escaping of special characters. Escaping may be
# 									disabled by using raw mode; see the description for the --raw option.
#
# --binary-as-hex 			When this option is given, mysql displays binary data using hexadecimal notation (0x value).
# 									This occurs whether the overall output display format is tabular, vertical, HTML or XML.
#
# --binary-mode 				This option helps when processing mysqlbinlog output that may contain BLOB values.
# 									By default, mysql translates \r\n in statement strings to \n and interprets \0 as
# 									the statement terminator.
#
# 									This option disables both features. Also disables all mysql commands except charset and delimiter
# 									in non-interactive mode (for input piped to mysql or loaded using the source command)
#
# --bind-address= 			On a computer having multiple network interfaces, use this option to select which interface to use
#   <ip address> 				for connecting to the MySQL server.
#
# --character-sets-dir= 	The directory where char sets are installed.
#   <dir name>
#
# --column-names 				Write column names in results
#
# --column-type-info 		Display result sets metadata
#
# --comments, -c 				Whether to strip or preserve comments in statements sent to the server. (DEPRECATED)
# 									Defaults to --skip-comments (strip comments), enable with --comments (preserves them)
# 
# 									Note: Commands and queries directed towards the server - are just hints. Server yields final say.
# 														
# --compress, -C 				Compress all information sent between client and the server if both support compression.
#
# --connect-expired- 		Indicate to the server that the client can handle sandbox mode if the account used to connect has an expired PW.
#   password 					Can be useful for noninteractive invocations of mysql because normally the server disconnects noninteractive clients
# 									that attempt to connect using an account with an expired PW.
#
# --database=<db_name>, 	The DB to use. Useful primarily in a option file.
#   -D <db_name>
#
# --debug[=<debug_options>], Write a debugging tool. A typical <debug_options> string is d:t:o, <file_name>. Defaults to d:t:o, /tmp/mysql.trace
#   -# [<debug options>]     Available only if MySQL was built using WITH_DEBUG.
#
# 									  MySQL release binaries are NOT designed for this option.
#
# --debug-check 				Print some debugging information when the program exits.
#
# --debug-info, -T 			Print debugging information and memory and CPU usage stats when the program exits.
#
# --default-auth=<plugin>  A hint about the client-side auth plugin to use
#
# --default-character-set  Use charset_name as the default char set for the client and connection.
# =<charset_name> 			This option can be useful if the OS uses one char set and the mysql client by default
# 									uses another.
#
# 									In this case, output may be formatted incorrectly. You can usually fix such issues by using
# 									this option to force the client to use the system char set instead.
#
# --defaults-extra-file 	Read this option file after the global option file but (On Unix) before user option files.
# =<file name> 				If not found/inaccessible, error raised. Relative if not full path specified, explicit otherwise.
#
# --defaults-file 			Use only the given option file. .mylogin.cnf is still read. If not found/inaccessible, error raised.
# =<file name>
#
# --defaults-group-suffix  Read not only the usual option groups, but also groups with the usual names and a suffix of <str>.
# =<str> 						Regex triggering of suffix sorting, basically.
#
# --delimiter=<str> 			Set the statement delimiter. The default is the semicolon char (;)
#
# --disable-named-commands Disable named commands. Use the \* format only, or use named commands only at the beginning of a line ending with (;)
# 									Starts with this option enabled by default.
#
# 								   Even with this option, long-format commands still work from the first line.
#
#--enable-cleartext-plugin Enables the mysql_clear_password cleartext authentication plugin.
#
# --execute=<statement>, 	Execute the statement and quit. The default output format is like that produced with --batch.
#  -e <statement>
# 									If this option is done, the history file is not used by MySQL.
#
# --force, -f 					Continue even if an error is raised
#
# --get-server-public-key  Request from the server the public key required for RSA key pair-based PW exchange.
# 									This option applies to clients that authenticate with the caching_sha2_password authentication plugin.
#
# 									For that plugin, the server does not send the public key unless requested. This option is
# 									ignored for accounts that do not authenticate with that plugin. 
#
# 									It is also ignored if RSA-based PW exchange is not used, as is the case when the client connects
# 									to the server using a secure connection.
#
# 									If --server-public-key-path=<file name> is given and specifies a valid public key file,
# 									it takes precedence over --get-server-public-key
#
# --histignore 				Colon-seperated list of one or more patterns specifying statements to ignore for logging purposes.
# 									The patterns are added to the default pattern list ("*IDENTIFIED*:*PASSWORD*")
#
# 									The value specified for this option affects logging of statements written to the history file, and
# 									to syslog if the --syslog option is given.
#
# --host=<host name>, 		Connect to the MySQL server on the given host.
# -h <host name>
#
# --html, -H 					Produce HTML Output
#
# --ignore-spaces, -i 		Ignore spaces after function names. The effect of this is described in the discussion
# 									for the IGNORE_SPACE SQL mode
#
# --init-command=<str> 		SQL statements to execute after connecting to the server. If auto-reconnect is enabled, the statement
# 									is executed again after reconnection occurs.
#
# --line-numbers 				Write line numbers for errors. Disable this with --skip-line-numbers.
#
# --local-infile[={0|1}] 	Enable or disable LOCAL capability for LOAD DATA INFILE. For mysql, this capability is disabled by default.
# 									With no value, the option enables LOCAL. This option may be given as --local-infile=0 or --local-infile=1 
# 									to explicitly disable or enable LOCAL.
#
# 									Enabling local data loading also requires that the server permits it.
#
# --login-path=<name> 		Read options from the named login path in the .mylogin.cnf login path file.
# 									A "login path" is an option group containing options that specify which MySQL server
# 									to connect to and which account to authenticate as.
#
# 									To create or modify a login path file, use the mysql_config_editor.
#
# --named-commands, -G 		Enables named mysql commands. Long-format commands are permitted, not just short-format commands.
# 									For example, quit and \q both are recognized. Use --skip-named-commands to disable named commands.
#
# --no-auto-rehash, -A 		This has the same effect as --skip-auto-rehash.
#
# --no-beep, -b 				No beep @ errors
#
# --no-defaults 				Do not read any option files. Prevents error causing files. 
# 									.mylogin.cnf is read regardless.
#
# --one-database, -o 		Ignore statements except those that occur while the default DB is the one named on the CMD line.
# 									This option is rudimentary and should be used with care.
#
# 									Statement filtering is based only on USE statements.
#
# 									Initially, mysql executes statements in the input because specifying a DB <db_name>
# 									on the CMD line is the equivalent to inserting USE <db name> at the beginning of the input.
#
# 									Then, for each USE statement encountered, mysql accepts or rejects following statements depending on
# 									whether the database named is the one on the CMD line.
#
# 									The content of hte statement is irrelevant.
#
# 									Assuming the following Query:
# 									DELETE FROM db2.t2; USE db2; DROP TABLE db1.t1; CREATE TABLE db1.t1 (i INT); USE db1;
# 									INSERT INTO t1 (i) VALUES(1); CREATE TABLE db2.t1 (j INT);
#
# 									If the command to process it, is: 
# 									mysql --force --one-database db1, mysql
#
# 									The DELETE statement is executed because the default database is db1, even though the statement
# 									names a table in a different database.
#
# 									The DROP TABLE and CREATE TABLE statements are not executed because the default database is not db1,
# 									even though the statements named a table in db1
#
# 									The INSERT and CREATE TABLE statements are executed because the default database is db1, even though
# 									the CREATE TABLE statement names a table in a different database.
#
# --pager[=<command>] 		Use the given command for paging query output. If the command is omitted, the default pager is the value of
# 									your PAGER environment variable.
#
# 									Valid pagers are less, more, car [> filename>], and so forth. This option works only on Unix and only
# 									in interactive mode. To disable it - use --skip-pager.
#
# --password=[=<password>] The password to use when connecting to the server. If you use the short option form (-p), you cannot
#   ,-p[<password>]        have a space between the option and the PW.
#
# 									If you omit the PW value following the --password or -p option on the command line, mysql prompts for one.
#
# --pipe, -W 					On Windows, connect to the server using a named pipe. This option applies only if the server supports named-pipe
# 									connections.
#
# --plugin-dir=<dir name> 	The dir in which to look for plugins. Specify this option if the --default-auth option is used to specify an authentication
# 									plugin but mysql does not find it.
#
# --port=<port num>, 		The TCP/IP port number to use for the connection. 
#  -P <port_num>
#
# --print-defaults 			Print the program name and all options that it gets from option files.
#
# --prompt=<format str> 	Set the prompt to the specified format. The default is mysql>. The special sequences
# 									that the prompt can contain are described later.
#
# --protocol={TCP|SOCKET 	The connection protocol to use for connecting to the server. It is useful when the other connection
#   |PIPE|MEMORY} 			parameters normally would cause a protocol to be used other than the one you want.
#
# --quick, -q 					Do not cache each query result, print each row as it is received. This may slow down the server if the output is suspended.
# 									With this option, mysql does not use the history file.
#
# --raw, -r 					For tabular output, the "boxing" around columns enables one column value to be distinguished from another.
# 									For nontabular output (such as is produced in batch mode or when the --batch or --silent option is given),
# 									special chars are escaped in the output so they can be identified easily.
#
# 									Newline, tab, NUL, and backslash are written as \n, \t, \0, and \\. The --raw disables the char escaping.
#
# Showcasing of differences:
# mysql> SELECT CHAR(92); #Select ORD numeral 92 char, which is \
# +-------------------+
# | 		CHAR(92) 	 | 
# +-------------------+
# | 			\ 			 |
# +-------------------+
#
# mysql -s #Silent mode
# mysql> SELECT CHAR(92); #Select ORD numeral 92, silent, escape enabled
# CHAR(92)
# \\
#
# mysql -s -r #Silent raw mode
# mysql> SELECT CHAR(92);
# CHAR(92)
# \
#
# --reconnect
# If the connection to the server is lost, automatically try to reconnect. A single reconnect attempt 
# is made each time the connection is lost.
#
# To surpress the reconnection behavior, use --skip-reconnect.
#
# --safe-updates, --i-am-a-dummy, -U
# Permit only those UPDATE and DELETE statements that specify which rows to modify by using key values.
# If you have set this option in an option file, you can override it by using --safe-updates on
# on the cmd line.
#
# --secure-auth
# This option was removed in MySQL 8.0.3
#
# --server-public-key-path=<file name>
# The path name to a file containing a client-side copy of the public key required by the server for RSA key pair-based password exchange.
# The file must be in PEM format.
# This option applies to clients that authenticate with the sha256_password or caching_sha2_password authentication plugin.
# 
# This option is ignored for accounts that do not authenticate with one of those plugins. It is also ignored for instances of
# RSA-based PW exchange not being used.
#
# If --server-public-key-path=<file name> is defined and is valid, it takes precedence over --get-server-public-key
# It is only available if MySQL was built using OpenSSL.
#
# --shared-memory-base-name=<name>
# On Windows, the shared-memory name to use, for connections made using shared memory to a local server.
# The default is MySQL. Case-sensitive.
# 
# Must start with --shared-memory to enable shared-memory connections.
#
# --show-warnings
# Causes warnings to be shown after each statement if there are any. This option applies to interactive and batch mode.
#
# --sigint-ignore
# Ignore SIGINT signals (typically the result of using CTRL+C)
#
# --silent, -s
# Silent mode. Produces less output. 
# This option can be given multiple times to produce less and less output.
# Results in nontabular output format and escaping of special characters. 
# Escaping may be disabled by using
# raw mode. (--raw)
# 
# --skip-column-names, -N
# Do not write column names in results
#
# --skip-line-numbers, -L
# Do not write line numbers for errors. Useful when you want to compare result files that include error messages.
#
# --socket=<path>, -S <path> 
# For connections to localhost, the Unix socket file to use - or on Windows, the name of the named pipe to use.
#
# --ssl*
# Options that begin with --ssl specify whether to connect to the server using SSL and indicate where to find
# SSL keys and certs.
#
# --ssl-fips-mode={OFF|ON|STRICT}
# Controls whether to enable FIPS mode on the client side.
# The --ssl-fips-mode option differs from other --ssl-xxx options in that it is not used to
# establish encrypted connections, but rather to affect which cryptographic ops are permitted.
#
# These --ssl-fips-mode values are permitted:
# 		OFF - disables fips mode
# 		ON  - enables fips mode
#     STRICT - Enable "strict" FIPS mode.
#
# If the OpenSSL FIPS Object Module is not available, the only permitted value for --ssl-fips-mode is OFF.
# In this case, setting --ssl-fips-mode to ON or STRICT - produces a warning, and defaults to OFF.
#
# --syslog, -j
# Causes mysql to send interactive statements to the system logging facility.
# On Unix, this is syslog; on Windows, it is the Windows Event Log.
#
# The destination where logged messages appear is system dependent. 
#
# On Linux, the destination is often the /var/log/messages file.
#
# a sample of output generated on Linux by using --syslog.
# Each line is usually one line:
#
# Mar 	7 12:39:25 myhost MysqlClient[20824]:
# 		SYSTEM_USER:'oscar', MYSQL_USER:'my_oscar', CONNECTION_ID:23,
# 		DB_SERVER:'127.0.0.1', DB:'--', QUERY:'USE test;'
# Mar 	7 12:39:28 myhost MysqlClient[20824]:
# 		SYSTEM_USER:'oscar', MYSQL_USER:'my_oscar', CONNECTION_ID:23,
# 		DB_SERVER:'127.0.0.1', DB:'test', QUERY:'SHOW TABLES;'
#
# --table, -t
# Display output in table format. This is the default for interactive use, but can be used to produce
# table output in batch mode.
#
# --tee=<file name>
# Append a copy of output to the given file. This option works only in interactive mode.
#
# --tls-version=<protocol list>
# The protocols permitted by the client for encrypted connections. 
# The value is a comma-separated list containing one or more protocol names.
# The protocols that can be named for this option depend on the SSL lib used to compile MySQL.
# 
# --unbuffered, -n
# Flush the buffer after each query.
#
# --user=<user name>, -u <user_name>
# The MySQL user name to use when connecting to the server.
#
# --verbose, -v
# Verbose mode. Can be given multiple times.
#
# --version, -V
# Version info and exit
#
# --vertical, -E
# Print query output rows vertically (one line per column value).
# Without this option, you can specify vertical output for individual statements
# by terminating them with \G.
#
# --wait, -w
# If the connection cannot be established, wait and retry insteaed of aborting.
#
# --xml, -X
# Produce XML output
# <field name="column_name">NULL</field>
#
# The output when --xml is used with mysql matches that of mysqldump --xml.
#
# An example of output is as follows:
#
# mysql --xml -uroot -e "SHOW VARIABLES LIKE 'version%'"
# <?xml version="1.0"?>
# 
# <resultset statement="SHOW VARIABLES LIKE 'version%'" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
# <row>
# <field name="Variable_name">version</field>
# <field name="Value">5.0.40-debug</field>
# </row>
#
# <row>
# <field name="Variable_name">version_comment</field>
# <field name="Value">Source distribution</field>
# </row>
#
# <row>
# <field name="Variable_name">version_compile_machine</field>
# <field name="Value">i686</field>
# </row>
#
# <row>
# <field name="Variable_name">version_compile_os</field>
# <field name="Value">suse-linux-gnu</field>
# </row>
# </resultset>
#
# We can also set the following variables by using --<var_name>=<value>
# 
# connect_timeout - Number of seconds before connection timeout (Defaults to 0)
# max_allowed_packet - Maximum size of the buffer for client/server communication. defaults to 16MB, max is 1GB.
# max_join_size - Automatic limit for rows in a join when using --safe-update. Defaults 1 million
# net_buffer_length - The buffer size for TCP/IP and socket communication (default is 16KB)
# select_limit - Automatic limit for SELECT statements when using --safe-updates. (default is 1000)

#The following section covers mysql commands:
#
# Showcasing of the results of writing help on the cmd line
#
# mysql> help
#
# List of all MySQL commands:
# Note that all text commands must be first on line and end with ';'
# ? 			(\?) 	Synonym for 'help'.
# clear 		(\c)  Clear the current input statement.
# connect  	(\r) 	Reconnect to the server. Optional arguments are db and host.
# delimiter (\d) 	Set statement delimiter
# edit 		(\e) 	Edit command with $EDITOR.
# ego 		(\G) 	Send command to mysql server, display result vertically
#
# exit 		(\q) 	Exit mysql. same as quit.
# go 			(\g) 	Send command to mysql server
# help 		(\h) 	Display this help
# nopager 	(\n) 	Disable pager, print to stdout
# notee 		(\t) 	Do not write into outfile
#
# pager 		(\P) 	Set PAGER [to_pager]. Print the query results via PAGER
# print 		(\p) 	Print current command
# prompt 	(\R) 	Change your mysql prompt
# quit 		(\q) 	Quit mysql
# 
# rehash 	(\#) 	Rebuild completion hash
# source 	(\.) 	Execute an SQL script file. Takes a file name as an argument.
# status 	(\s) 	Get status information from the server.
# system 	(\!) 	Execute a system shell command
#
# tee 		(\T) 	Set outfile [to_outfile]. Append everything into given outfile.
# use 		(\u) 	Use another database. Takes database name as argument
# charset 	(\C) 	Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
#
# warnings 	(\W) 	Show warnings after every statement
# nowarning (\w) 	Don't show warnings after every statement.
# resetconnection(\x) 	show warnings after every statement
#
# If MySQL is invoked with the --binary-mode option, all mysql commands are disabled except charset and delimiter
# in non-interactive mode (for input piped to mysql or loaded using the source command)
#
# Each command has both a long and short form. Long is not case-sensitive. Short is.
#
# Long can be followed by an optional semicolon terminator, but short should not.
#
# We are not allowed to use multiple line comments with /* ... */
#
# the following showcases the different commands in terms of long format and short format
#
# help [arg], \h [arg], \? [arg], ? [arg]
# 
# Displays a help message listing the available mysql commands.
# The arg input to help, acts as regex match in server-side help commands.
#
# charset <charset_name>, \C <charset_name>
#
# Changes the default character set and issues a SET_NAMES statement. This enables the character set to remain
# synchronized on the client and server if mysql is run with auto-reconnect enabled (not recommended),
# as the specified char set is used for reconnects.
# 
# clear, \c
# Clear the current input. Use this if you change your mind about executing the statement that you are entering.
#
# connect [<db_name> <host_name>]], \r [<db name> <host name>]]
#
# Reconnect to the server. The optional database name and host name arguments may be given to specify the default
# DB or the host where the server is running.
#
# If omitted, the current values are used.
#
# delimiter <str>, \d <str>
# 
# Change the string that mysql interprets as the separator between SQL statements. The default is the semicolon char (;)
#
# The delimiter string can be specified as an unquoted or quoted argument on the delimiter command line. Quoting can be done
# with either single quote ('), double quote (") or backtick (`) chars.
#
# To include a quote within a quoted string, either quote the string with a different quote character or
# escape the quote with a (\) char.
#
# Backslash should be avoided outside of quoted strings because it is the escape character for MySQL.
# For an unquoted argument, the delimiter is read up to the first space or end of line.
#
# For a quoted argument, the delimiter is read up to the matching quote on the line.
#
# mysql interprets instances of the delimiter string as a statement delimiter anywhere it occurs, except within
# quoted strings.
#
# Be careful about defining a delimiter that might occur within other words. For example, if you define
# the delimiter as X, you will be unable to use the word <INDEX> in statements.
#
# Mysql interprets this as <INDE> followed by the delimiter X.
#
# When the delimiter recognized by mysql is set to something other than the default of ;,
# instances of that character are sent to the server without interpretation.
#
# However, the server itself still interprets ; as a statement delimiter and process statements
# accordingly. This behavior on the server side comes into play for multiple-statement execution,
# for parsing the body of stored procedures and functions, triggers and events.
#
# edit, \e
# Edit the current input statement. mysql checks the values of the EDITOR and VISUAL env variables
# to determine which editor to use.
#
# The default editor is vi if neither variable is set.
#
# The edit command works only in Unix.
#
# ego, \G
# Send the current statement to the server to be executed and display the result using vertical format.
#
# exit, \q
# Exit mysql
#
# go, \g
# Send the current statement to the server to be executed.
#
# nopager, \n
# Disable output paging. See the description for pager.
#
# The nopager command works only in Unix.
#
# notee, \t
# Disable output copying to the tee file. See the description for tee.
#
# nowarning, \w
# Disable display of warnings after each statement.
#
# pager [<command>], \P [<command>]
# Enable output paging. By using the --pager option when you invoke mysql, it is possible to browse or search query
# results in interactive mode with Unix programs such as less, more, or any other similar program.
#
# If you specify no value for the option, mysql checks the value of the PAGER environment variable and sets the
# pager to that. Pager functionality works only in interactive mode.
#
# Output paging can be enabled interactively with the pager command and disabled with nopager.
# The command takes an optional argument; if given, the paging program is set to that.
#
# With no arg, the pager is set to the pager that was set on the command line, or stdout if no pager was specified.
#
# Output paging works only in Unix because it uses the popen() function, which does not exist on Windows.
# For Windows, the tee option can be used instead to save query output, although it is not as convenient
# as pager for browsing output in some situations.
#
# print, \p
# Print the current input statement without executing it
#
# prompt [<str>], \R [<str>]
# Reconfigure the mysql prompt to the given string. The special character sequences that can be used in the
# prompt are described later in this section.
#
# If you specify the prompt command with no argument, mysql resets the prompt to the default of mysql>.
#
# quit, \q
# Exit mysql.
#
# rehash, \#
# Rebuild the completion hash that enables database, table and column name completion while you are entering statements.
# (See the description for the --auto-rehash option)
#
# resetconnection, \x
# Reset the connection to clear the session state.
#
# Resetting a connection has effects similar to mysql_change_user() or an auto-reconnect except that
# the connection is not closed and reopened, and re-authentication is not done.
#
# Showcasing of example:
#
# SELECT LAST_INSERT_ID(3); #gives 3
# SELECT LAST_INSERT_ID(); #gives 3, still set to this
# resetconnection; #Resets defaults
# SELECT LAST_INSERT_ID(); #Gives 0, reset has been done

# source <file_name>, \. <file_name>
# Read the named file and execute the statements contained therein. On Windows, you can specify
# path name separators as / or \\.
#
# Quote characters are taken as part of the file name itself. For best results, the name should not
# include space characters.
#
# status, \s
# Provide status information about the connection and the server you are using.
# If you are running in --safe-updates mode, status also prints the values for the
# mysql variables that affect your queries.
#
# system <command>, \! <command>
# Execute the given command using your default cmd interpreter.
# Works only on Unix.
#
# tee [<file_name>], \T [<file_name>]
# By using the --tee option when you invoke mysql, you can log statements and their output.
# All the data displayed on the screen is appended into a given file.
#
# This can be very useful for debugging purposes also. mysql flushes results to the file
# after each statement, just before it prints its next prompt.
#
# Tee functionality works only in interactive mode.
#
# You can enable this feature interactively with the tee command. Without a parameter,
# the previous file is used. The tee file can be disabled with the notee command.
#
# Executing tee again re-enables logging.
#
# use <db_name>, \u <db_name>
# Use <db_name> as the default DB.
#
# warnings, \W
# Enable display of warnings after each statement (if there are any)
#
# Tips about the pager command:
# 
# Example of writing only to a file:
# pager cat > /tmp/log.txt
#
# We can also pass options with the pager
# pager less -n -i -S
#
# Example of piping to different files mounted on two different systems, still displaying to screen using less:
# pager cat | tee /dr1/tmp/res.txt \
# 			| tee /dr2/tmp/res2.txt | less -n -i -S
#
# We can also combine the tee and pager functions. Have a tee file enabled and pager set to less, and you are
# able to browse the results using the less program and still have everything appended into a file the same time.
#
# The difference between the Unix tee used with the pager command and the mysql built-in tee command is that the
# built-in tee works even if you do not have the Unix tee available.
#
# The built-in tee logs everything that is printed on the screen, where as the Unix tee used with pager
# does not log equal amounts.
#
# Additionally, tee file logging can be turned on and off interactively from within mysql. This is useful
# when you want to log some queries to a file, but not others.
#
# The prompt command reconfigures the default mysql> prompt. The string for defining the prompt can
# contain the following special sequences:
#
# Option 					Desc
# \C 				The current connection identifier
# \c 				A counter that increments for each statement you issue
# \D 				The full current date
# \d 				The default database
# \h 				The server host
#
# \l 				The current delimiter
# \m 				Minutes of the current time
# \n 				A newline char
# \O 				The current month in three letter format (Jan, Feb, etc.)
# 
# \o 				The current month in numeric format
# \P 				am/pm
# \p 				The current TCP/IP port or socket file
# \R 				The current time, in 24-hour military time(0-23)
#
# \r 				The current time, standard 12-hour time (1-12)
# \S 				Semicolon
# \s 				Seconds of the current time
# \t 				A tab char
#
# \U 				Your full user_name@host_name acc name
# \u 				Your user name
# \v 				The server version
# \w 				The current dat of the week in three letter format (Mon, Tue, etc.)
#
# \Y 				The current year, four digits
# \y 				The current year, two digits
# \_ 				A space
# \ 				A space (space after the \)
# \' 				Single quote
# \" 				Double quote
# \\ 				A literal backslash char
#
# \x 				x, for any "x" not listed above

# There is a number of ways we can change the prompt:
#
# An environment variable: 
# export MYSQL_PS1="(\u@\h) [\d]> "
#
# A cmd line option. Can set the prompt with --prompt on the cmd line:
# mysql --prompt="(\u@\h) [\d]> "
# (user@host) [database]>
#
# Using an option file. Prompt option in the [mysql] group, such as /etc/my.cnf or the .my.cnf in the home dir:
# [mysql]
# prompt(\\u@\\h) [\\d]>\\_
#
# \\ is used in the option file for explicit escaping.
#
# We can also set it interactively, by using prompt or \R

# prompt (\u@\h) [\d]>\_
# PROMPT set to '(\u@\h) [\d]>\_'
# (user@host) [database]>
# (user@host) [database]> prompt
# Returning to default PROMPT of mysql>
# mysql>
#
#The next part covers Mysql logging
#
# The mysql client can do these types of logging for statements executed interactively:
#
# Unix -> mysql writes the statements to a history file. By default, the file is named .mysql_history in your home dir.
# To specify a different file, set the value of the MYSQL_HISTFILE env variable.
#
# On all platforms, if the --syslog option is given, mysql writes the statements to the system logging facility.
# Unix -> syslog
# Windows -> Windows Event Log
#
# the destination where logged messages appear is system dependent. On Linux, the destination is often
# the /var/log/messages file.
#
# How Logging Occurs:
#
# For each enabled logging destination - statement logging occurs as is shown:
# 
# Statements are logged only when executed interactively. Statements are noninteractive, for example, when read
# from a file or a pipe. It is also possible to suppress statement logging by using the --batch or --execute option.
#
# Statements are ignored and not logged if they match any pattern in the "ignore" list. Shown later.
#
# mysql logs each nonignored, nonempty statement line individually.
#
# If a nonignored statement spans multiple lines (not including the terminating delimiter), mysql concatenates
# the lines to form the complete statement, maps newlines to spaces and then logs the result + a delimiter.
#
# For instance:
# SELECT
# 	'Today is'
#  ,
#  CURDATE()
#  ;
#Gives:
# SELECT 'Today is' , CURDATE();

# mysql ignores for logging purposes statements that match any pattern in the "ignore" list.
# By default, the pattern list is "*IDENTIFIED*:*PASSWORD*", to ignore statements that identify as PWs.

# Two chars are significant in terms of the regex pattern: ? (Single wildcard char), * any sequence of zero or more chars.
#
# To specify additional patterns, use the --histignore option or set the MYSQL_HISTIGNORE env variable.
# Option value takes precedence.
#
# The value should be a colon separated list, which are appended to the default list.
# An example of a pattern delimiter defined on the cmd line, to ignore UPDATE and DELETE:
#
# mysql --histignore="*UPDATE*:*DELETE*"
#
# If we do not wish to maintain a hist file, cause it can contain PW info, we can remove it and do one of hte following:
#
# Set the MYSQL_HISTFILE env var to /dev/null - put in one of the shell startup files, causing deployment of options at the startup.
# 
# Create .mysql_history as a symbolic link to /dev/null; - only needs to be done once:
#
# ln -s /dev/null $HOME/.mysql_history
#
# syslog Logging Characeristics
#
# If the --syslog option is given, mysql writes interactive statements to the system logging facility.
# Message logging has the following characteristics:
#
# Logging occurs at the "informational" level. 
# This corresponds to the LOG_INFO priority for syslog on Unix/Linux syslog capability and to 
# EVENTLOG_INFORMATION_TYPE for the Windows Event Log.
#
# Message size limit is 1024 bytes.
#
# Messages consists of the identifier MysqlClient followed by these values:
#
# SYSTEM_USER - The system user name (login name) or -- if the user is unknown.
# 
# MYSQL_USER  - The MySQL user name (specified with the --user option) or -- if the user is unknown.
#
# CONNECTION_ID - The client connection identifier. This is the same as the CONNECTION_ID() function value within the session.
#
# DB_SERVER - The server host or -- if the host is unknown
# 
# DB - The default database or -- if no DB has been selected.
#
# QUERY - The text of the logged statement.
#
# Example of output generated on Linux by using --syslog. Formatted for readability, each logged message takes a single line:
#
# Mar 	7 12:39:25 myhost 	MysqlClient[20824]:
# 		SYSTEM_USER:'oscar', MYSQL_USER:'my_oscar', CONNECTION_ID:23,
# 		DB_SERVER:'127.0.0.1', DB:'--', QUERY:'USE test;'
# Mar 	7 12:39:28 myhost 	MysqlClient[20824]:
# 		SYSTEM_USER:'oscar', MYSQL_USER:'my_oscar', CONNECTION_ID:23,
# 		DB_SERVER:'127.0.0.1', DB:'test', QUERY:'SHOW TABLES;'

# The following section covers the mysql Server-Side Help
#
# mysql> help <search_string>
#
# For this operation to work, the help tables in the mysql database must be initialized with the help topic information.
#
# If no value is found, an error is thrown.
#
# To see a list of categories:
# 
# mysql> help contents
# You asked for help about help category: "Contents"
# For more info, type 'help <item>', where <item> is one of the following categories:
#
# Account management
# Administration
# Data Definition
# Data Manipulation
# Data Types
# Functions
# Functions and Modifiers for Use with GROUP BY
# Geographic Features
# Language Structure
# 
# Plugins
# Storage Engines
# Stored Routines
# Table Maintenance
# Transactions
# Triggers
#
# If multiple tags coincide, a list of the topics are shown:
#
# help logs
# Many help items for your request exist
# To make a more specific request, please type 'help <item>'
# where <item> is one of the following topics:
# 		SHOW
# 		SHOW BINARY LOGS
# 		SHOW ENGINE
# 		SHOW LOGS
#
# Use a topic as the search string to see the help entry for that topic:
#
# mysql> help show binary logs
# Name: 'SHOW BINARY LOGS'
# Description:
# Syntax:
# SHOW BINARY LOGS
# SHOW MASTER LOGS
#
# Lists the binary log files on the server. This statement is used as
# part of the procedure described in [purge-binary-logs] - which shows how to determine which logs can be purged.
#
# mysql> SHOW BINARY LOGS;
# +------------------------------+
# | Log_name 	    |   File_size |
# +------------------------------+
# | binlog.000015  |    724935   |
# | binlog.000016  | 	733481 	|
# +------------------------------+

# The search string can contain the wildcard char % and _. These have the same meaning as for pattern-matching,
# such as % as any sequencing following but yields designated part in respective parting before that
#
# EXAMPLE% Finds anything that begins with EXAMPLE
# %EXAMPLE Finds anything that ends with EXAMPLE
#
# mysql> HELP rep%
# Many help items for your request exist
# To make a more specific request, please type 'help <item>'
# where <item> is one of the following topics:
#
# REPAIR TABLE
# REPEAT FUNCTION
# REPEAT LOOP
# REPLACE
# REPLACE FUNCTION
#
# The following showcases of how to execute SQL statements from a Text File
#
# Typically the mysql client is interactively done as:
#
# shell> mysql <db_name>
#
# However - we can run a script from a file, unto a DB - as follows:
#
# shell> mysql <db_name> < <text_file>
#
# If we include a USE <db_name> statement as the first statement in the file, no DB name must be done on the cmd line.
#
# If mysql is already running - we can execute a SQL script file using the source command or \. command:
#
# mysql> source <file_name>
# mysql> \ <file_name>

# mysql ignores Unicode byte order mark (BOM) chars at the beginning of input files.

#MYSQL tips section next

# Input-Line Editing
#
# mysql supports input-line editing, which enables you to modify the current input line in place or recall previous input lines.
# For example, up/down arrows moves between previous entered lines.
#
# To change the set of key sequences permitted by a given input library, define key bindings in the library startup file.
# .editrc for libedit and .inputrc for readline
#
# in Libedit:
# CTRl+W - deletes everything before current cursor pos.
# CTRL+U - the entire line.
#
# in readline:
# Ctrl+W - deletes the word before the cursor
# CTRl+U - deletes everything before the current cursor pos.

# Unicode on Windows:
# provided through UTF-16LE APIs reading from and to the console.
# The mysql client for Windows is able to use these APIs.
# 
# The Windows installer creates an item in the MySQL menu named MySQL command line client - Unicode.
# This item invokes the mysql client with properties set to communicate through the console to
# the MySQL server using Unicode.
#
# Open the console window
# Go to console window properties - select font tab - choose Lucidia Console or some other compatible UNICODE font.
#
# This is called for, due to console windows start by default using a DOS raster font that is uncalled for Unicode.
#
# Execute mysql with --default-character-set=utf8 (or utf8mb4) option.
# It is nessecary because utf16le cannot be used as client char set, amongst others.
#
# With said changes, Windows will use the Windows API to communicate with the console using UTF-16LE,
# and communicate with the server using UTF-8.
#
# To avoid said steps each time we run mysql, we can create a shortcut that invokes mysql.exe
# The shortcut should set the console font to Lucida Console or some other compatible
# Unicode font, and pass the --default-character-set=utf8 to mysql.
#
# Alternatively, we have a shortcut for the console font - with the char set in the [mysql] group in a my.ini file:
# [mysql]
# default-character-set=utf8
#
# The following covers Displaying Query Results Vertically
# 
# Just end the query with \G instead of ;
# mysql> SELECT * FROM mails WHERE LENGTH(txt) < 300 LIMIT 300,1\G
# 
# ******************************* 1. row ****************************
# 
#   msg_nro: 3068
# 		 date: 2000-03-01 23:29:50
# time_zone: +0200
# mail_from: Monty
#     reply: monty@no.spam.com
#   mail_to: "Thimble Smith" <tim@no.spam.com>
# 	 	  sbj: UTF-8
# 		  txt: >>>>> "Thimble" == Thimble Smith Writes:
#
# Thimble> Hi, i think this is a good idea. Is anyone familiar 
# Thimble> with UTF-8 or Unicode? Otherwise, i'll put this on my
# Thimble> TODO list and see what happens.
#
# Yes, please do that
# 
# Regards,
# Monty
# 		 file: inbox-jani-1
# 		 hash: 190402944

# Using the --safe-updates Option
# 
# For beginners, a useful startup option is --safe-updates (or --i-am-a-dummy, which has the same effect).
# It is helpful for cases when you might have issued a DELETE FROM <tbl_name> statement, but if we forgot the Where part.
#
# By --safe-updates, we enforce key referal to commit to delete updates.
#
# The query sent upon startup is the following:
# 
# SET sql_safe_updates=1, sql_select_limit=1000, max_join_size=1mil
#
# The SET statement has the following effects:
#
# You are not permitted to execute an UPDATE or DELETE statement unless you specify a key constraint in the
# WHERE clause or provide a LIMIT clause (or both)
#
# Example:
#
# UPDATE <tbl_name> SET <not_key_column>=<val> WHERE <key_column>=<val>;
#
# UPDATE <tbl_name> SET <not_key_column>=<val> LIMIT 1;
#
# The server limits all large SELECT results to 1,000 rows unless the statement includes a LIMIT clause.
# 
# The server aborts multiple-table SELECT statements that probably need to examine more than 1 mil row combos.
#
# We can override the defaults by using --select_limit and --max_join_size options:
#
# mysql --safe-updates --select_limit=500 --max_join_size=10000
#
# Disabling mysql Auto-Reconnect
#
# If the mysql client loses its connection to the server while sending a statement, it immediately and automatically
# tries to reconnect once to the server and send the statement again.
#
# However, even if mysql succeeds in reconnecting, your first connection has ended and all your previous session objects/settings
# are lost.
#
# Temporary tables, the autocommit mode, user-defined vars and session vars.
#
# Any current transactions roll back. 
#
# An example of loss of designation:
#
# mysql> SET @a=1;
# mysql> INSERT INTO t VALUES(@a); #Gets error
#
# mysql> SELECT * FROM t; #a is now Null

#To terminate with an error, start mysql with --skip-reconnect

# The next section covers mysqladmin - Client to administer a MySQL server
#
# Invoked:
#
# mysqladmin [<options>] <command> [<command-arg>] [<command> [<command-arg>]] ...
#
# mysqladmin supports the following commands. Some of the commands take an argument following the cmd name:
#
# create <db_name> - creates a DB with <db_name>
# debug - Tell the server to write debug information to the error log. Connnected user must have SUPER privs.
# drop <db_name> - Delete the DB named <db_name> and all of its tables.
# extended-status - Display the server status vars and their values.
# flush-hosts - Flush all information in the host cache
#
# flush-logs [<log_type> ...] - Flush all logs. The mysqladmin flush-logs cmd permits optional log types to be given,
# to specify which logs to flush.
#
# Following the flush-logs command, you can provide a space-separated list of one or more of the following log types:
# binary, engine, error, general, relay, slow
#
# These correspond to the log types that can be specified for the <FLUSH LOGS> SQL statement.
#
# flush-privileges - Reload the grant tables (same as reload)
#
# flush-status - Clear status vars
#
# flush-tables - Flush all tables
#
# flush-threads - Flush the thread cache
#
# kill id, id, ... - Kill server threads. If multiple thread ID values are given, there must be no spaces in the list.
# 							To kill threads belonging to other users, the connected user must have the CONNECTION_ADMIN or SUPER privs.
#
# password <new_pw> - Sets a new PW. This changes the PW to <new_pw> for the account that you use with mysqladmin for connecting to the server.
# 							 Thus, the next time you invoke mysqladmin (or any other client program) using the same account, you need to specify the new PW.
#
# NOTE: Setting a pw using mysqladmin should be considered <insecure>. On some systems, your PW becomes visibile to system status programs such as 
# ps that may be invoked by other users to display cmd lines. MySQL clients typically overwrite the cmd-line pw argument with 0's during init seq.
#
# There is still a brief interval during which the value is visible. Also, on some systems this overwriting strategy is ineffective and the PW
# remains visible to ps.
#
# If the <new_pw> contains spaces or other chars that are special to your cmd line, you need to enclose it with ""
# On windows, be sure to use "" rather than '', '' are not stripped from the PW.
#
# Simply use config files for PWs.
#
# ping - Check whether the server is available. The return status from mysqladmin is 0 if the server is running, 1 if it is not.
# Even errors produce 0 - as it does not denote that the server is offline.
#
# processlist - Show a list of active server threads. This is the same as SHOW PROCESSLIST. If Verbose is given, the output is like that
# of SHOW FULL PROCESSLIST.

# reload - Reload the grant tables.
#
# refresh - Flush all tables and close and open log files.
#
# shutdown - Stop the server
#
# start-slave - Start replication on a slave server
#
# status - Display a short server status message
#
# stop-slave - Stop replication on a slave server
#
# variables - Display the server system vars and their values
#
# version - Display version info from the server
#
# All commands can be shortened to any unique prefix:
#
# mysqladmin proc stat #Prints ID, user, host, db, command, Time, State, Info
# #Also prints stats
#
# The mysqladmin status command result displays the following values:
# 
# Uptime - Number of seconds the MySQL server has been running
# Threads - Number of active threads (clients)
# Questions - The number of questions (queries) from clients since the server was started.
# Slow queries - Number of queries that have taken more than long query time seconds.
#
# Opens - The number of tables the server has opened
# Flush tables - The number of flush-*, refresh and reload commands the server has executed
# Open tables - Number of tables that currently are open

# If you execute mysqladmin shutdown when connecting to a local server using a Unix socket file, mysqladmin waits until
# the server's process ID file has been removed, to ensure that the server has stopped properly.
#
# The following options are supported in terms of mysqladmin - of which can be specified on the cmd line or in the [mysqladmin] and [client] groups of a option file.
#
# mysqladmin Options
#
# Format 									Desc
# --bind-address 							Use specified network interface to connect to MySQL Server
# --compress 								Compress all information sent between client and server
# --connect_timeout 						Number of seconds before connection timeout
# --count 									Number of iterations to make for repeated command execution
#
# --debug 									Write debugging log
# --debug-check 							Print debugging information when program exits
# --debug-info 							Print debugging information, memory and CPU stats when the program exits.
#
# --default-auth 							Authentication plugin to use.
# --default-character-set 				Specify default character set
# --defaults-extra-file 				Read named option file in addition to usual option files
# --defaults-file 						Read only named option file
#
# --defaults-group-suffix 				Option group suffix value
# --enable-cleartext-plugin 			Enable cleartext authentication plugin
# --force 									Continue even if an SQL error occurs
# --get-server-public-key 				Request RSA public key from server
# --help 									Display help message and exit
#
# --host 									Connect to MySQL Server on given host
# --login-path 							Read login path options from .mylogin.cnf
# --no-beep 								Do not beep when errors occur
# --no-defaults 							Read no option files
# --password 								Password to use when connecting to server
# --pipe 									On Windows, connect to server using named pipe
# --plugin-dir 							Directory where plugins are installed
#
# --port										TCP/IP port number for connection
# --print-defaults 						Print default options
# --protocol 								Connection protocol to use
# --relative 								Show the difference between the current and previous values when used with the --sleep option
# --secure-auth 							Do not send PWs to server in old formats (REMOVED)
# --server-public-key-path 			Path name to file containing RSA public key
#
# --shared-memory-base-name 			Name of the shared memory to use for shared-memory connections
# --show-warnings 						Show warnings after statement execution.
# --shutdown_timeout 					The maximum number of seconds to wait for server shutdown
# --silent 									Silent mode
# --sleep 									Execute commands repeatedly, sleeping for delay in between
# --socket 									For connections to localhost, the Unix socket file to use
# --ssl-ca 									File that contains list of trusted SSL Cert Auths
#
# --ssl-capath 							Directory that contains trusted SSL cert Auth cert files
# --ssl-cert 								File that contains X.509 cert
# --ssl-cipher 							List of permitted ciphers for connection encryption
# --ssl-crl 								File that contains cert revocation lists
#
# --ssl-crlpath 							Dir that contains cert revocation list files
# --ssl-fips-mode 						Whether to enable FIPS mode on the client side
# --ssl-key 								File that contains X.509 key
# --ssl-mode 								Security state of connection to server
# --tls-version 							Protocols permitted for encrypted connections
# --user 									MySQL user name to use when connecting to server
# --verbose 								Verbose mode
#
# --version 								Display version information and exit
# --vertical 								Print query output rows vertically (one line per column value)
# --wait 									If the connection cannot be established, wait and retry instead of aborting

# The following showcases short commands for some of the above of whom are listed:
#
# --help, -? - Display a help msg and exit
# --bind-address=<ip address> - A computer having multiple network interfaces, use this option to select which interface to use for connecting to the MySQL Server.
# --character-sets-dir=<dir name> - The dir where char sets are installed.
# --compress, -C - Compress all information sent between the client and server if both support compression.
# --count=<N>, -c <N> - The number of iterations to make for repeated command execution if the --sleep option is given.
# --debug[=<debug options>], -# [<debug_options>] - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>.
# 									     Defaults to d:t:o, /tmp/mysqladmin.trace
# --debug-check - Prints some debugging information when the program exits.
# --debug-info - Print debugging info, memory, CPU usage stats when the program exits.
# --default-auth=<plugin> - A hint about the client side auth to use.
#
# --default-character-set=<charset name> - Use <charset_name> as the default char set.
# --defaults-extra-file=<file name> - Read this option file after global, but before user option files on Unix.
# 												  If not found or not permissioned, error raised. Relative if relative, Absolute otherwise.
# --defaults-file=<file name> - Use only the given option file. If the file does not exist or is otherwise inaccessible, an error occurs.
# 										  relative if relative, full otherwise.
#
# 										  The exception is .mylogin.cnf
#
# --defaults-group-suffix=<str> - read also groups with suffix regex match to str.
# --enable-cleartext-plugin - Enables cleartext authentication plugin.
# --force, -f - Do not ask for confirmation for the drop <db_name> command. with several commands, Continue even if an error occurs.
# --get-server-public-key - Request RSA public key from server.
# --help - Display help message and exit
# --host - Connect to MySQL server on given host
# --login-path - Read login path options from .mylogin.cnf
#
# --no-beep - Do not beep when errors occur
# --no-defaults - Read no option files
# --password - Password to use when connecting to server
# --pipe - On Windows, connect to server using named pipe
# --plugin-dir - Directory where plugins are installed
# --port - TCP/IP port number for connection
# --print-defaults - Print default options
#
# --protocol - Connection protocol to use
# --relative - Show the difference between the current and previous values when used with the --sleep option
# --secure-auth - Do not send passwords to server in old format (REMOVED)
# --server-public-key-path - Path name to file containing RSA public key
# --shared-memory-base-name - The name of shared memory to use for shared-memory connections
#
# --show-warnings - Show warnings after statement execution
# --shutdown_timeout - The maximum number of seconds to wait for server shutdown
# --silent - Silent mode
# --sleep - Execute commands repeatedly, sleeping for delay seconds in between
# --socket - For connections to localhost, the Unix socket file to use
# --ssl-ca - File that contains list of trusted SSL Cert Auths
# --ssl-capath - Directory that contains trusted SSL Cert Auth cert files
# --ssl-cert - File that contains X.509 cert
#
# --ssl-cipher - List of permitted ciphers for connection encryption
# --ssl-crl - File that contains certificate revocation lists
# --ssl-crlpath - Dir that contains the cert revocation list files
# --ssl-fips-mode - Whether to enable FIPS modeon the client side
# --ssl-key - File that contains X.509 key
# --ssl-mode - Security state of connection to server
# --tls-version - Protocols permitted for encrypted connections
# --user - MySQL user name to use when connecting to server
#
# --verbose - Verbose mode
# --version - Display version information and exit
# --vertical - Print query output rows vertically (one line per column value)
# --wait - If the connection cannot be established, wait and retry instead of aborting

#Basically, a lot of these options in terms of shorthand are repeats - thus, i will omit them.

#Next up, is mysqlcheck 
#
# The mysqlcheck client performs table maintenance: checks, repairs, optimizes and analyzes tables.
#
# Each table is locked and therefore unavailable to other sessions while it is being processed, although for
# check ops, the table is locked with a READ lock only
#
# mysqlcheck must be used when the mysqld server is running, which means that you do not have to stop the server
# to perform table maintenance.
#
# mysqlcheck uses the SQL statements CHECK TABLE, REPAIR TABLE, ANALYZE TABLE and OPTIMIZE TABLE in a convenient way for
# the user. It determines which statements to use for the operation you want to perform, then sends the statements to 
# the server to be executed.
#
# Not all storage engines do not support all four maintenance operations.
#
# Note: We are wise to make backups in terms of tables - in case of error in file parsing
#
# The three general ways of invoking mysqlchecks:
#
# mysqlcheck [<options>] <db_name> [<tbl_name ...>]
# mysqlcheck [<options>] --databases <db_name> ...
# mysqlcheck [<options>] --all-databases
#
# If the tbl name option is ommitted, or --databases or --all-databases options are used - entire DBs are checked.
#
# mysqlcheck has a special feature compared to other client programs.
# The default behavior of checking tables (--check) can be changed by renaming the binary.
#
# If you want to have a tool that repairs tables by default, you should just make a copy of mysqlcheck 
# named mysqlrepair, or make a symbolic link to mysqlcheck named mysqlrepair.
#
# The following names can be used to change mysqlcheck default behavior
#
# Command 			Meaning
# mysqlrepair 		Default option is --repair
# mysqlanalyze 	Default option is --analyze
# mysqloptimize 	Default option is --optimize

# mysqlcheck supports the following options, which can be specified on the command file or in the
# [mysqlcheck] and [client] groups of an option file.
#
# Format 										Desc
# 
# --all-databases 		Check all tables in all DBs
# --all-in-1 				Execute a single statement for each DB that names all the tables from that DB
# --analyze 				Analyze the tables
# --auto-repair 			If a checked table is corrupted, automatially fix it
# --bind-address 			Use specified network interface to connect to MySQL Server
# --character-sets-dir 	Dir where char sets are installed
# --check 					Check the tables for errors
#
# --check-only-changed 	Check only tables that have changed since the last check
# --check-upgrade 		Invoke CHECK TABLE with the FOR UPGRADE option
# --compress 				Compress all information sent between client and server
# --databases 				Interpret all arguments as DB names
# --debug 					Write debugging log
# --debug-check 			Print debug info when program exits
# --debug-info 			Print debug info, memory and CPU stats @ exit
#
# --default-auth 			Authentication plugin to use
# --default-character-set 			Specify default char set
# --defaults-extra-file Read named option file in addition to usual option files
# --defaults-file 		Read only named option file
# --defaults-group-suffix 		Option group suffix value
# --enable-cleartext-plugin 	Enable cleartext auth plugin
# --extended 						Check and repair tables
# --fast 							Check only tables that have not been closed properly
# --force 							Continue even if an SQL error occurs
#
# --get-server-public-key 		Request RSA public key from server 		
# --help 							Display help message and exit
# --host 							Connect to MySQL server on given host
# --login-path 					Read login path options from .mylogin.cnf
# --medium-check 					Do a check that is faster than an --extended operation
# --no-defaults 					Read no option files
# --optimize 						Optimizes the tables
# --password 						Password to use when connecting to server
#
# --pipe 							On Windows, connect to server using named pipe
# --plugin-dir 					Dir where plugins are installed
# --port 							TCP/IP port number for connection
# --print-defaults 				Print default options
# --protocol 						Connection protocol to use
# --quick 							The fastest method of checking
#
# --repair 							Perform a repair that can fix almost anything except unique keys that are not unique
# --secure-auth 					Do not send PW to server in old format (REMOVED)
# --server-public-key-path 	Path name to file containing RSA public key
# --shared-memory-base-name 	Name of shared memory to use for shared-memory connections
# --silent 							Silent mode
# --skip-database 				Omit this database from performed operations
# --socket 							For connections to localhost, the Unix socket file to use
# --ssl-ca 							File that contains list of trusted SSL Cert Auths
#
# --ssl-capath 					Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 						File that contains X.509 cert
# --ssl-cipher 					List of permitted ciphers for connection encryption
# --ssl-crl 						File that contains cert revocation lists
# --ssl-crlpath 					Dir that contains cert revocation list files
# --ssl-fips-mode 				Whether to enable FIPS mode on the client side
#
# --ssl-key 						File that contains X.509 key
# --ssl-mode 						Security state of connection to server
# --tables 							Overrides the --database or -B option
# --tls-version 					Protocols permitted for encrypted connections
# --use-frm 						For repair operations on MyISAM tables
# --user 							MySQL user name to use when connecting to server
# --verbose 						Verbose mode
# --version 						Display version information and exit
# --write-binlog 					Log ANALYZE, OPTIMIZE, REPAIR statements to binary log, 
# 										--skip-write-binlog adds NO_WRITE_TO_BINLOG to these statements.
# 
# --help, -? - Displays a help message and exits
# --all-databases, -A - Check all tables in all databases. This is the same as using the --databases option and naming all the databases
# 								on the CMD line, except for the INFORMATION_SCHEMA and performance_schema DBs of whom are not checked.
#
# 								To check them, explicitly name them with the --databases option
#
# --all-in-1, -1 - Instead of issuing a statement for each table, execute a single statement for each DB that names all the tables from that DB to be processed.
# --analyze, -a - Analyzes the tables
# --auto-repair - If a checked table is corrupted, automatically fix it. Any necessary repairs are done after all the tables have been checked.
# --bind-address=<ip_address> - On a computer having multiple network interfaces, use this option to select which interface to use for connecting to the MySQL Server.
# --character-sets-dir=<dir name> - The dir where char sets are installed
#
# --check, -c - Check the tables for errors. This is the default operation.
# --check-only-changed, -C - Check only tables that have changed since the last check or that have not been closed properly.
# --check-upgrade, -g - invoke the CHECK_TABLE with the FOR UPGRADE option to check tables for incompabilities with the current version of the server.
# --compress - Compress all information sent between the client and the server if both support it.
# --databases, -B - Process all tables in the named databases. Normally, mysqlcheck treats the first name argument on the cmd line as a DB name
# 						  and any following names as table names. With this option, it treats all name args as DB names.
# --debug[=<debug_options>], -# [<debug_options>] - Write a debugging log. A typical debug_options string is d:t:o, <file_name>. Default is d:t:o
# --debug-check - Print some debug info when the program exits
# 
# --debug-info - Print debugging info, memory and CPU usage stats when the program exits.
# --default-character-set=<charset_name> - Use <charset_name> as default char set
# --defaults-extra-file=<file name> - Read this option file after the global option file, but on Unix, before hte user option file.
# 												  If not found or inaccessible, an error occurs. Interpreted as relative, lest declared full path.
# --defaults-file=<file name> - Use only the given option file. If the file does not exist or is otherwise inaccessible, an error occurs.
# 										  <file_name> is relative, lest explicit. Still reads .mylogin.cnf
#
# --defaults-group-suffix=<str> - Regex pattern against suffix inclusion in addition to default groupings.
#
# --extended, -e - If you are using this option to check tables, it ensures that they are 100% consistent but takes a long time.
# 						 If used in conjunction with repair - it may produce garbage as well.
#
# --default-auth=<plugin> - A hint about the client-side auth plugin to use.
#
# --enable-cleartext-plugin - Enable the <mysql_clear_password> cleartext auth plugin
#
# --fast, -F - Check only tables that have not been closed properly
#
# --force, -f - Continue even if an SQL error occurs.
#
# --get-server-public-key - Request from the server public key required for RSA key pair-based PW exchange.
# 									 Applies to clients that authenticate with the <caching_sha2_password> auth plugin.
# 									 For said plugin, the server does not send the public key unless requested.
#
# 									 Is ignored for accs that do not authenticate with that plugin. 
# 									 Also ignored if RSA-based PW exchange is not used, as is when clients use secure connections.
# 	
# 									 If --server-public-key-path=<file_name> is given and valid - it's > in prio over --get-server-public-key
#
# --host=<host name>,  		 Connect to the MySQL server on the given host.
#  -h <host_name>
# 
# --login-path=<name> 		 Read options from the named login path in the .mylogin.cnf login path file.
# 									 A "login path" is an option group containing options that specify which MySQL
# 									 server to connect to and which account to authenticate as.
#
# 								    To create or modify a login path file, use the mysql_config_editor utility.
#
# --medium-check, -m 		 Do a check that is faster than a --extended operation. This finds only 99.99% of all errors,
# 									 which should be enough in most cases.
#
# --no-defaults 				 Do not read option files. Prevents errors thrown due to errornous parsing.
# 									 .mylogin.cnf is read in all cases.
#
# --optimize, -o 				 Optimize the tables
#
# --password[=<password>],  The PW to use when connecting to the server. Short option (-p) requires no space between option and PW.
#  -p [<password>] 			 If omitted, prompts afterwards for it.
#
# --pipe, -W 					 Connect to the server using a named pipe. Only applies if server supports named-pipes
#
# --plugin-dir=<dir_name> 	 The dir in which to look for plugins. Specify if --default-auth is used for auth plugin but mysqlcheck can't find it
#
# --port=<port num>,        The TCP/IP port number to use for the connection. 
#  -P <port num>
#
# --print-defaults 			 Print the program name and all options that it gets from option files.
#
# --protocol= 					 The connection protocol to use for connecting to the server. It is useful when the other connection params
# {TCP|SOCKET|PIPE|MEMORY}  normally would cause a protocol to be used other than the one you want.
#
# --quick, -q 					 If you are using this option to check tables, it prevents the check from scanning the rows to check
# 								    for incorrect links. The fastest check method.
#
# 									 If attempting to repair tables, it tries only to repair the index tree.
#
# --repair, -r 				 Perform a repair that can fix almost anything except unique keys that are not unique.
#
# --secure-auth 				 REMOVED.
#
# --server-public-key-path= The path name to a file containing a client-side copy of the public key required by the server for RSA
#   <file name> 				 key pair-based PW exchange.
#
# 								    File must be in PEM format. Applies to clients that authenticate with the sha256_password or caching_sha2_password
# 									 auth plugin. Ignored for accounts that do not authenticate with one of those plugins.
#
# 									 Also ignored if RSA based PW exchange is not used, as in secure connection.
# 									 sha256_password only applies with MySQL being built with OpenSSL.
# 									 
# 									 If --server-public-key-path=<file name> is given and specified as a valid public key,
# 									 it takes precedence over --get-server-public-key
#
# --shared-memory-base-name= On Windows, the shared memory name to use - for connections made using shared memory to a local server.
# <name>  						 Defaults to MySQL. Shared name is case-sensitive.
#
# 									 Server must be started with the --shared-memory option to enable shared-memory connections.
#
# --silent, -s 				 Silent mode. Print only error messages.
#
# --skip-database=<db name> Do not include the named DB (case-sensitive) in the operations performed by mysqlcheck.
#
# --socket=<path>,  			 For connections to localhost, the Unix socket file to use, or on Windows, the name of the named pipe to use.
#  -S <path>
#
# --ssl* 						 Options that begin with --ssl specify whether to connect to the server using SSL and indicate where to find SSL keys and certs.
#
# --ssl-fips-mode= 			 Controls whether to enable FIPS mode on the client side. Defines which Cryptographic ops are permitted.
# {OFF|ON|STRICT} 			 allows:
#
# 									 OFF - Disabled, ON - Enabled, STRICT - "strict" FIPS mode
#
# --tables 						 Overrides the --databases or -B option. All names following are regarded as table names.
#
# --tls-version= 				 The protocols permitted by the client for encrypted connections. Comma separated list containing one or more protocol names.
#  <protocol list> 			 Protocols that can be named, depend on the SSL Lib used to Compile MySQL.
#
# --use-frm 					 For repair operations on MyISAM tables, get the table structure from the data dictionary so that the table can be repaired even
# 									 if the .MYI header is corrupted.
#
# --user=<user name>, 		 The MySQL user name to use when connecting to the server. 
#  -u <user_name>
#
# --verbose, -v 				 Verbose mode. Prints info about various stages of program ops.
#
# --version, -V 				 Display version info and exit.
#
# --write-binlog 				 Enabled by default, so that ANALYZE_TABLE, OPTIMIZE_TABLE, and REPAIR_TABLE statements generated by mysqlcheck are written to 
# 									 the binary log.
#
# 									 Use --skip-write-binlog to cause NO_WRITE_TO_BINLOG to be added to the statements so that they are not logged.
# 									 Use --skip-write-binlog when these statements should not be sent to replication slaves or run when using the binary
# 									 logs for recovery from backup.
#
# The next section covers mysqldump
#
# The mysqldump client utility performs logical backups, producing a set of SQL statements that can be executed
# to reproduce the original database object definitions and table data. 
#
# It dumps one or more MySQL databases for backup or transfer to another SQL server.
#
# mysqldump can also generate output in CSV, text or XML.
#
# mysqldump requires at least the SELECT privlege for dumped tables, SHOW VIEW for dumped views, TRIGGER for dumped triggers
# LOCK TABLES if the --single-transaction option is not used.
#
# Certain options might require other privs as noted in the option desc.
#
# To reload a dump file, you must have the privs required to execute the statements that it contains, such as
# the appropriate CREATE privs for objects created by those statements.
#
# mysqldump output can include ALTER DATABASE statements that change the database collation.
# These may be used when dumping stored programs to preserve their char encodings.
#
# To reload a dump file containing such statements, the ALTER priv for the affected DB is required.

# For instance, a dump made by PowerShell will be in UTF16 - which is not a permitted connection char encoding.
# To account for this - use --result-file to have it written in ASCII:
#
# mysqldump [<options>] --result-file=dump.sql
#
# mysqldump advantages include the convenience and flexibility of viewing or even editing the output before restoring.
# You can clone DBs and create slight variations, kind of like branching, in a way.
#
# The backup step can take a reasonable time - however, restoring the data can be very slow because replaying
# the SQL involves disk I/O for insertion, index creation and so on.
#
# If we have a lot of tables using InnoDB tables or a mix of InnoDB and MyISAM - we can use mysqlbackup from MySQL Enterprise Backup.
#
# It has the best performance for InnoDB.
#
# Otherwise, for large scale backup operations - utilize physical allocation.
#
# mysqldump can retrieve and dump table contents row by row, or it can retrieve the entire content from a table
# and buffer it in memory before dumping it.
#
# Buffering in memory can be a problem if you are dumping large tables. To dump tables row by row, use the --quick
# option (or --opt, which enables --quick).
#
# The --quick (implicitly activated by --opt) is on by default, so to enable memory buffering - use --skip-quick
#
# If you are using a recent version of mysqldump to generate a dump to be reloaded into a very old MySQL server,
# use the --skip-opt option instead of the --opt or --extended-insert option.
#
# There is in general three ways of using mysqldump - one for a set of one or more tables, a set of one or more complete DBs,
# or an entire MySQL server -
#
# mysqldump [<options>] <db_name> [<tbl_name> ...] #Omitting table names infers to dump the entire db
# mysqldump [<options>] --databases <db_name>
# mysqldump [<options>] --all-databases

# mysqldump supports the following options - which can be specified on the cmd line or in the [mysqldump] and [client] groups
# of an option file.
#
# Format 									Description
# --add-drop-database 				Add DROP DATABASE statement before each CREATE DATABASE statement
# --add-drop-table 					Add DROP TABLE statement before each CREATE TABLE statement
# --add-drop-trigger 				Add DROP TRIGGER statement before each CREATE TRIGGER statement
# --add-locks 							Surround each table dump with LOCK TABLES and UNLOCK TABLES statements
#
# --all-databases 					Dump all tables in all databases
# --allow-keywords 					Allow creation of column names that are keywords
# --apply-slave-statements 		Include STOP SLAVE prior to CHANGE MASTER statement and START SLAVE at end of Output
# --bind-address						Use specified network interface to connect to MySQL Server
# --character-sets-dir 				Directory where char sets are installed
# --column-statistics 				Write ANALYZE TABLE statements to generate statistics histograms
#
# --comments 							Add comments to dump file
# --compact 							Produce more compact output
# --compatible 						Produce output that is more compatible with other database systems or with older MySQL servers
# --complete-insert 					Use complete INSERT statements that include column names
# --compress 							Compress all information sent between client and server
# --create-options 					Include all MySQL-specific table options in CREATE TABLE statements
# 
# --databases 							Interpret all name arguments as database names
# --debug 								Write debugging log
# --debug-check 						Print debugging information when program exits
# --debug-info 						Print debugging information, memory, CPU stats when program exits
# --default-auth 						Authentication plugin to use
# --default-character-set 			Specify default character set
# --defaults-extra-file 			Read named option file in addition to usual option files
#
# --defaults-file 					Read only named option file
# --defaults-group-suffix 			Option group suffix value
# --delete-master-logs 				On a master replication server, delete the binary logs after performing the dump operation
# --disable-keys 						For each table, surround INSERT statements with statements to disable and enable keys
# --dump-date 							Include dump date as "Dump completed on" comment, if comments option is given
# --dump-slave 						Include CHANGE MASTER statement that lists binary log coordinates of slave's master
# --enable-cleartext-plugin 		Enable cleartext authentication plugin
#
# --events 								Dump events from dumped databases
# --extended-insert 					Use multiple-row INSERT syntax
# --fields-enclosed-by 				This option is used with the --tab option and has the same meaning as the corresponding clause for LOAD DATA INFILE
# --fields-escaped-by 				This option is used with the --tab option and has the same meaning as the corresponding clause for LOAD DATA INFILE
# --fields-optionally-escaped-by -||- (Denotes "same as above", basically)
# --fields-terminated-by 			-||-
# --flush-logs 						Flush MySQL server log files before starting dump
#
# --flush-privileges 				Emit a FLUSH PRIVILEGES statement after dumping mysql database
# --force 								Continue even if an SQL error occurs during a table dump
# --get-server-public-key 			Request RSA public key from server
# --help 								Display help message and exit
# --hex-blob 							Dump binary columns using hexadecimal notation
# --host 								Host to connect to (IP address or hostname)
# --ignore-error 						Ignore specified errors
#
# --ignore-table 						Do not dump given table
# --include-master-host-port 		Include MASTER_HOST/MASTER_PORT options in CHANGE MASTER statement procured by --dump-slave option enabled
# --insert-ignore 					Write INSERT IGNORE rather than INSERT statements
# --lines-terminated-by 			This option is used with the --tab option and has the same meaning as the corresponding clause for LOAD DATA INFILE
# --lock-all-tables 					Lock all tables across all databases
# --lock-tables 						Lock all tables before dumping them
# --log-error 							Append warnings and errors to named file
# --login-path 						Read login path options from .mylogin.cnf
# --master-data 						Write the binary log file name and position to the output
# --max_allowed_packet 				Maximum packet length to send to or receive from server
#
# --net_buffer_length 				Buffer size for TCP/IP and socket communication
# --network-timeout 					Increase network timeouts to permit larger table dumps
# --no-autocommit 					Enclose the INSERT statements for each dumped table within SET autocommit = 0 and COMMIT statements
# --no-create-db 						Do not write CREATE DATABASE statements
# --no-create-info 					Do not write CREATE TABLE statements that re-create each dumped table
# --no-data 							Do not dump table contents
# --no-defaults 						Read no option files
# --no-set-names 						Same as --skip-set-charset
# --no-tablespaces 					Do not write any CREATE LOGFILE GROUP or CREATE TABLESPACE statements in output
# --opt 									Shorthand for --add-drop-table --add-locks --create-options --disable-keys --extended-insert
# 															  --lock-tables --quick --set-charset
# 
# --order-by-primary 				Dump each table's rows sorted by its primary key, or by its first unique index
# --password 							Password to use when connecting to server
# --pipe 								On Windows, connect to server using named pipe
# --plugin-dir 						Dir where plugins are installed
# --port 								TCP/IP port number for connection
# --print-defaults 					Print default options
# --protocol 							Connection protocol to use
# --quick 								Retrieve rows for a table from the server a row at a time
# --quote-names 						Quote identifiers within backtick characters
#
# --replace 							Write REPLACE statements rather than INSERT statements
# --result-file 						Direct output to a given file
# --routines 							Dump stored routines (procedures and functions) - from dumped databases
# --secure-auth 						Do not send passwords to server in old (REMOVED)
# --server-public-key-path 		Path name to file containing RSA public key 
# --set-charset 						Add SET NAMES default_character_set to output
# --set-gtid-purged 					Whether to add SET @@GLOBAL.GTID_PURGED to output
# --shared-memory-base-name 		The name of shared memory to use for shared-memory connections
# --single-transaction 				Issue a BEGIN SQL statement before dumping data from server
#
# --skip-add-drop-table 			Do not add a DROP TABLE statement before each CREATE TABLE statement
# --skip-add-locks 					Do not add locks
# --skip-comments 					Do not add comments to dump file
# --skip-compact 						Do not produce more compact output
# --skip-disable-keys 				Do not disable keys
# --skip-extended-insert 			Turn off extended-insert
# --skip-opt 							Turn off options set by --opt
# --skip-quick 						Do not retrieve rows for a table from the server a row at a time
# --skip-quote-names 				Do not quote identifiers
# --skip-set-charset 				Do not write SET NAMES statement
# --skip-triggers 					Do not dump triggers
#
# --skip-tz-utc 						Turn off tz-utc
# --socket 								For connections to localhost, the Unix socket file to use
# --ssl-ca 								File that contains list of trusted SSL Cert Auths
# --ssl-capath 						Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 							File that contains X.509 cert
# --ssl-cipher 						List of permitted ciphers for connection encryption
# --ssl-crl 							File that contains certificate revocation lists
# --ssl-crlpath 						Dir that contains cert revocation list files
#
# --ssl-fips-mode 					Whether to enable FIPS mode on the client side
# --ssl-key 							File that contains X.509 key
# --ssl-mode 							Security state of connection to server
# --tab 									Produce tab-separated data files
# --tables 								Override --databases or -B option
# --tls-version 						Protocols permitted for encrypted connections
# --triggers 							Dump triggers for each dumped table
# --tz-utc 								Add SET TIME_ZONE='+00:00' to dump file
#
# --user 								MySQL user name to use when connecting to server
# --verbose 							Verbose mode
# --version 							Display version info and exit
# --where 								Dump only rows selected by given WHERE condition
# --xml 									Produce XML output
#
# The mysqldump command logs into a MySQL server to extract information. 
# The following options relate to how the connection interacts with the MySQL Server, local or remote:
#
# --bind-address=<ip address> - On a computer having multiple network interfaces, use this option to select which interface to use for connecting to the MySQL server.
# --compress, -C - Compress all information sent between the client and the server if both support compression.
# --default-auth=<plugin> - A hint about the client-side authentication plugin to use.
# --enable-cleartext-plugin - Enable the <mysql_clear_password> cleartext authentication plugin
# --get-server-public-key - Request as per before:
#
# 									 Request from the server the public key required for RSA key pair-based PW exchange.
# 									 This option applies to clients that authenticate with the <caching_sha2_password> authentication plugin.
#              
#                           For that plugin, the server does not send the public key unless requested. This option is ignored
# 									 for accounts that do not authenticate with that plugin. Also ignored for non RSA based PWs, i.e secure connections.
#
# 									 If --server-public-key-path=<file name> is given and specifies a valid public key file - it takes precedence over
# 									 --get-server-public-key.
#
# --host=<host_name>, 		 Dump data from the MySQL server on the given host. Defaults localhost 
#  -h <host_name>
#
# --login-path=<name> 		 Read options from the named login path in the .mylogin.cnf login path file.
# 									 A "login path" is an option group containing options that specify which MySQL Server
# 									 to connect to and which account to authenticate as.
#
# 									 To create or modify a login path file, use the mysql_config_editor utility.
# 									 
# --network-timeout, -M 	 Enable large tables to be dumped by setting max_allowed_packet to its maximum value
# 									 and network read and write timeouts to a large value.
#
# 									 This option is enabled by default. To disable, use --skip-network-timeout
#
# --password[=<password>],  The password to use when connecting to the server. If you use the short option form (-p), no space req
#  -p [<password>] 			 Prompt kicks in if no pw - can specify PW in a option file
#
# --pipe, -W 					 On Windows, connect to the server using a named pipe. Applies only if the server supports named-pipe connections
#
# --plugin-dir=<dir_name> 	 The dir of where to look for plugins. Specify if the --default-auth option is used to specify an authentication plugin but mysqldump does not find it.
#
# --port=<port_num>, 		 The TCP/IP port number to use for the connection
# 	-P <port_num>
#
# --protocol= 					 The connection protocol to use for connecting to the server. 
# {TCP|SOCKET|PIPE|MEMORY}
#
# --secure-auth 				 REMOVED
#
# --server-public-key-path  Same as before
#   =<file name>
#
# --socket=<path>, 			 For connections to <localhost>, the Unix socket file to use - or Windows, name of the named pipe to use 
#  -S <path>
#
# --ssl* 						 Options that begin with --ssl specify whether to connect to the server using SSL, indicate where to find SSL keys and Certs.
#
# --ssl-fips-mode= 			 Whether to enable FIPS mode on the client side. Which cryptographic ops are permitted.
#  {OFF|ON|STRICT} 			 OFF: Disable FIPS mode. ON: Enable FIPS mode. STRICT: Enable "strict" FIPS mode.
#
# --tls-version= 				 The protocols permitted by the client for encrypted connections. 
# <protocol list> 			 The value is a comma-separated list containing one or more protocol names. Allowed values depend on the SSL lib used to Compile MySQL.
#
# --user=<user_name>, 		 User name to use for connecting
#  -u <user_name>
#
# --max_allowed_packet= 	 Maximum size of the buffer for client/server comm. Defaults to 24MB, max is 1GB.
#   <value>
#
# --net_buffer_length 		 The initial size of the buffer for client/server communication. When creating multiple-row INSERT
# 									 statements (as with the --extended-insert or --opt option), mysqldump creates rows up to <net_buffer_length>
# 									 bytes long. If we increase this, the MySQL Server in terms of net_buffer_length, must be at least this large.
#
# The following options pertain to option files and which option files to read:
# 
# --defaults-extra-file=<file name> - Same as before, read before user option file on unix but after global, permissions, etc.
# --defaults-file=<file name> - Use only given option. Relative if relative, still use .mylogin.cnf - error if inaccessible.
# --defaults-group-suffix=<str> - Regex match against suffix in grouping 
# --print-defaults - Print the program name and all options that it gets from option files.
#
# Scenarios of where you'd use mysqldump include setting up an entire new MySQL instance (including DB tables), and replacing
# data inside an existing instance with existing DBs and tables.
#
# The following options let you specify which things to tear down and what to set up when restoring a dump - by utilizing
# DDL statements in the dump file.
#
# --add-drop-database - Write a <DROP DATABASE> statement before each <CREATE DATABASE> statement. 
# 							   Usually used with a --all-databases or --databases option
# --add-drop-table 	 - Write a <DROP TABLE> statement before each <CREATE TABLE> statement.
# --add-drop-trigger  - Write a <DROP TRIGGER> statement before each <CREATE TRIGGER> statement.
#
# --all-tablespaces,  - Adds to a table dump all SQL statements needed to create any tablespaces used by an NDB table.
#                       Otherwise not included from mysqldump, only relevant to NDB cluster tables, not supported by MySQL 8.0
# --no-create-db, -n  - Suppress the <CREATE DATABASE> statements that are otherwise included in the output if the --databases
#                       or --all-databases option is given.
#
# --no-create-info,   - Do not write <CREATE TABLE> statements that create each dumped table.
#  -t 						This option does not exclude statements creating log file groups or tablespaces from mysqldump output.
# 								However, you can use the --no-tablespaces option for this.
#
# --replace 				Write REPLACE statements rather than INSERT statements.
# 
# The following options pertain to debuging
#
# --allow-keywords - Permit creation of column names that are keywords. This works by prefixing each column name with the table name.
# --comments, -i 	 - Write additional information in the dump file such as program version,server version and host.
# 							This option is enabled by default. To suppress this additional information, use --skip-comments.
# --debug 				 
# [=<debug_options>], Writes a debugging log. A typical <debug_options> string is d:t:o, <file_name>. Defaults to d:t:o, /tmp/mysqldump.trace
#-# [<debug options>]	
#
# --debug-check 	 - Print some debugging information when the program exits
# --debug-info 	 - Print debugging information, memory and CPU stats when the program exits.
# --dump-date 		 - If the --comments option is given, mysqldump produces a comment at the end of the dump of the following form:
# 							-- Dump completed on <DATE>
# 						
# 						   However, the date causes dump files taken at different times to appear to be different, even if data is identical.
# 							--dump-date and --skip-dump-date control whether the date is added to the comment.
# 							Defaults to --dump-date (include date in comment), --skip-dump-date to suppress
#
# --force, -f 		 - Ignore all errors, continue even if an SQL error occurs during a table dump.
# 							Can for instance ignore view errornous referential addresses - if underlying table has been dropped.
#
# 							Without --force, mysqldump exits with an error message.
# 						   --force causes mysqldump to print the error message - but also writes an SQL comment
# 							containing the view definition to the dump output and continues executing.
#
# 							If --ignore-error is also given, --force takes higher prio
#
# --log-error= 		Log warnings and errors by appending them to the named file. Defaults to no logging.
#	<file_name>
#
# --skip-comments 	See the description for the --comments options
#
# --verbose, -v 		Verbose mode
#
# The following options pertain to some help options
#
# --help, -? - Display a help message and exit
# --version, -V - Display version info and exit
#
# The following options pertain to char sets in relation to national language settings
#
# --character-sets-dir=<dir_name> - The dir where character sets are installed.
# --default-character-set= 		 - Use <charset_name> as default char set. If none specified, defaults to UTF8.
#  <charset_name>
# --no-set-names, -N 				 - Turns off the --set-charset setting, the same as specifying --skip-set-charset
# --set-charset 						 - Write SET NAMES <default character set> to the output. Enabled by default. 
# 												To suppress the SET NAMES, use --skip-set-charset
#
# The following options pertain to Replication and akin
#
# The mysqldump command is frequently used to create an empty instance, or an instance including data, on a slave server
# in a replication configuration.
#
# The following options apply to dumping and restoring data on replication master and slave servers:
#
# --apply-slave-statements - For a slave dump produced with the --dump-slave option, add a STOP SLAVE statement before the
# 									  CHANGE MASTER TO statement and a START SLAVE statement at the end of the output.
#
# --delete-master-logs 		- On a master replication server, delete the binary logs by sending a PURGE BINARY LOGS statement to the server
# 									  after performing the dump operation. Automatically enables --master-data.
#
# --dump-slave[=<value>] 	- Similar to --master-data except that it is used to dump a replication slave server to produce a dump file
# 									  that can be used to set up another server as a slave that has the same master as the dumped server.
#
# 									  It causes the dump output to include a CHANGE MASTER TO statement that indicates the binary log coords
# 									  (file name and pos) of the dumped slave's master.
#
# 									  The CHANGE MASTER TO statement reads the values of Relay_Master_Log_File and Exec_Master_Log_Pos
# 									  from the SHOW SLAVE STATUS output and uses them for MASTER_LOG_FILE and MASTER_LOG_POS respectively.
#
# 									  Thoose are the master server coords to which the slave is to replicate from.
#
# 									  NOTE: Inconsistencies in the sequence of transactions from the relay log which have been executed can
# 									  cause the wrong coords to be used.
#
# 									  This option causes the coords from the master to be used rather than those of the dumped server, as is 
# 									  done by the --master-data option.
#
# 									  In addition - specifying this option causes the --master-data option to be overridden, if used, and ignored.
#
#  								  WARNING: Do not use in conjunction with dumped server coords which yields gtid mode=ON and MASTER_AUTOPOSITION=1
#
#  								  The option value is handled the same way as for --master-data:
#                            no value or 1 - Causes a CHANGE MASTER TO statement to be written to the dump
# 									  2 - Causes the statement to be written but encased in SQL comments (same effect as --master-data 
# 									  in enabling or disabling other options and in how locking is handled)
#
# 									  This option causes mysqldump to stop the slave SQL thread before the dump and restart it again after.
# 									  With --dump-slave - the --apply-slave-statements and --include-master-host-port options can also be used.
#
# --include-master-host-port For the CHANGE MASTER TO statement in a slave dump produced with --dump-slave option, add MASTER_HOST and MASTER_PORT
# 									  options for the host name and TCP/IP port number of the slave's master.
#
# --master-data[=<value>] 	  Use this option to dump a master replication server to produce a dump file that can be used to set up another server
# 									  as a slave of the master.
#
# 									  Causes the dump output to include a CHANGE_MASTER_TO statement that indicates the binary log coords (file name and pos) 
# 									  of the dumped server. Said coords are the master server coords from which the slave should start replicating after the dump
# 									  is loaded into the slave.
# 							
# 									  If the option value is 2 - the CHANGE_MASTER_TO statement is written as an SQL comment, and is informative only.
# 									  Has no effect when the dump file is reloaded.
#
# 									  If the option value is 1 - the statement is not written as a comment and takes effect when the dump file is reloaded.
# 									  If none is specified - it defaults to 1.
#
# 									  Requires the RELOAD privilege and the binary log must be enabled.
#
# 									  The --master-data option automatically turns off --lock-tables. 
# 									  Also turns on --lock-all-tables, unless --single-transaction also is specified.
# 									  If --single-transaction is also specified - a global read lock is acquired only for a short time
# 									  at the beginning of the dump.
#
# 									  Any action on logs happens at the exact moment of the dump.
# 									  We can also set up a slave by dumping an existing slave of the master, using the --dump-slave option
# 									  - overriding the --master-data - causing both to be ignored.
#
# --set-gtid-purged=<value>  Enables control over global transaction ID (GTID) information written to the dump file, by indicating whether
# 									  to add a SET @@global.gtid purged statement to the output.
#
# 									  May also cause a statement to be written to the output that disables binary logging while the dump file is being
# 									  reloaded.
#
# 									  Default: AUTO.
#									  OFF  : Add no SET statement to the output.
# 									  ON   : Add a SET statement to the output. An error occurs if GTIDs are not enabled on the server.
# 								     AUTO : Add a SET statement to the output if GTIDs are enabled on the server.
#
# 									  A partial dump from a server that is using GTID-based replication requires the --set-gtid-purged={ON|OFF} option
# 									  to be specified.

# 									  If we wish to deploy a new replication slave using only some of the data from the dumped server, use ON.

# 									  If we wish to repair the table in terms of copying within a topology or copy between disjoint topologies
# 									  of which remain so - Use OFF.
# 
# 									  The --set-gtid-purged option has the following effect on binary logging when the dump file is reloaded:
#
# 									  --set-gtid-purged=OFF : SET @@SESSION.SQL_LOG_BIN=0; is not added to the output.
# 									  --set-gtid-purged=ON  : SET @@SESSION.SQL_LOG_BIN=0; is added to the output
# 									  --set-gtid-purged=AUTO: SET @@SESSION.SQL_LOG_BIN=0; is added to the output if GTIDs are enabled on the server you are backing up. (If AUTO evalutes to ON)
#
# 									  NOTE: It is not recommended to load a dump file when GTIDs are enabled on the server (gtid mode=ON), if your dump file
# 									  includes system tables.
#
# 								     mysqldump issues DML instructions for the system tables which use the non-transactional MyISAM storage engine,
#								     and this combination is not permitted when GTIDs are enabled.
#
# 									  Also be aware that loading a dump file from a server with GTIDs enabled - into another server with GTIDs enabled -
# 									  causes different transaction identifiers to be generated.
# 
# The following options specify how to represent the entire dump file or certain kinds of data in the dump file.
# They also control whether certain optional info is written to the dump file:
#
# --compact - Produce more compact output. This option enables the --skip-add-drop-table, --skip-add-locks, --skip-comments,
# 																						 --skip-disable-keys, --skip-set-charset options.
# --compatible=<name> - Produce output that is more compatible with other database systems or with older MySQL servers.
# 								Only permitted value for this is ansi - has the same meaning as for the Server SQL mode option.
# --complete-insert, -c Use complete INSERT statements that include column names
#
# --create-options 		Include all MySQL-specific table options in the CREATE TABLE statements.
#
# --fields-terminated-by=<...>, 				Options used with the --tab option and have the same meaning as the corresponding FIELDS
# --fields-enclosed-by=<...>, 				clauses for LOAD DATA INFILE.
# --fields-optionally-enclosed-by=<...>,
# --fields-escaped-by=<...>
#
# --hex-blob 				Dump binary columns using hexadecimal notation ('abc' becomes 0x616263).
# 								Affected data types are BINARY, VARBINARY, BLOB types and BIT.
#
# --lines-terminated-by=<...> 				Used with the --tab option and has the same meaning as the corresponding LINES clause for LOAD DATA INFILE.
#
# --quote-names, -Q 		Quote identifiers, such as DB, table and column names - within ` chars. If the ANSI_QUOTES SQL mode is on, identifiers are quoted with "
# 								Enabled by default. Can be disabled with --skip-quote-names, but this option should be given after any option such as --compatible that may
# 								enable --quote-names. i.e - Order this command after others
#
# --result-file= 		   Direct output to the named file. Result file is created and its previous contents overwritten, even if an error occurs while generating dump.
#  <file_name>, 			Used on Windows to prevent \n from becoming \r\n
#
# --tab=<dir_name>, 	   Produce tab-separated text-format data files. For each dumped table, mysqldump creates a <tbl_name>.sql file that contains 
#  -T <dir_name> 			the CREATE TABLE statements - of which create the table and the server writes a <tbl_name>.txt that contains its data.
# 								The option value is the dir in which to write the files.
#
# 								NOTE: Should only be used when mysqldump is run on the same machine as the mysqld server.
# 										The server creates *.txt files in the dir that we specify - the dir must be writable by the server
# 										and the MySQL acc that we use must have the FILE privs.
#
# 									   Because mysqldump creates *.sql in the same dir, it must be writable by the system login acc.
#
# 								By default - the .txt data files are formatted using tab chars between column values and a newline at the end of each line.
# 								The format can be specified explicitly using the --fields-<xxx> and --lines-terminated-by options.
#
# 								Column values are converted to the character set specified by the --default-character-set option.
#
# --tz-utc 					Enables TIMESTAMP columns to be dumped and reloaded between servers in different time zones.
# 								mysqldump sets its connection time zone to UTC and adds SET TIME_ZONE='+00:00' to the dump file.
# 			
# 								Without this - TIMESTAMP columns are dumped and reloaded in the time zones local to the source and
# 								destination servers - Which causes discrepencies in values if the servers are in different timezones.
#
# 								Also protects against changes due to daylight saving time.
# 								Enabled by default - disable with --skip-tz-utc
#
# --xml, -X 				
#  -r <file_name> 		Write dump output as well-formed XML.
#
# 								The following example showcases the differences:
# 								VALUE: 									XML Representation:
# 								NULL(unknown value) 					<field name="column_name" xsi:nil="true" />
# 								''(empty strting) 					<field name="column_name"></field>
# 								'NULL'(string value) 				<field name="column_name">NULLL</field>
#
# 								An example of mysqldump can be showcased as follows:
#
# 								mysqldump --xml -u root world City
# 								<?xml version="1.0"?>
# 								<mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
# 								<database name="world">
#
# 								<table_structure name="City">
# 								<field Field="ID" Type="int(11)" Null="NO" Key="PRI" Extra="auto_increment" />
# 								<field Field="Name" Type="char(35)" Null="NO" Key="" Default="" Extra="" />
# 								<field Field="CountryCode" Type="char(3)" Null="NO" Key="" Default="" Extra="" />
# 
# 								<field Field="District" Type="char(20)" Null="NO" Key="" Default="" Extra="" />
# 								<field Field="Population" Type="int(11)" Null="NO" Key="" Default="0" Extra="" />
# 								<key Table="City" Non_unique="0" Key_name="PRIMARY" Seq_in_index="1" Column_name="ID"
# 								Collation="A" Cardinality="4079" Null="" Index_type="BTREE" Comment="" />
# 								
# 								<options Name="City" Engine="MyISAM" Version="10" Row_format="Fixed" Rows="4079"
# 								Avg_row_length="67" Data_length="273293" Max_data_length="<numbers>"
# 								Index_length="43008" Data_free="0" Auto_increment="4080"
# 								Create_time="2007-03-31 01:47:01" Update_time="2007-03-31 01:47:02"
# 								Collation="latin1_swedish_ci" Create_options="" Comment="" />
# 								</table_structure>
# 								
# 								<table_data name="City">
# 								<row>
# 								<field name="ID">1</field>
# 								<field name="Name">SomeName</field>
# 								<field name="CountryCode">SomeValue</field>
# 								<field name="District">SomeValue</field>
# 								<field name="Population">SomeValue</field>
# 								</row>
#
# 								<row>
# 								<field name="ID">SomeValue</field>
# 								<field name="Name">SomeValue</field>
# 								<field name="CountryCode">SomeValue</field>
# 								<field name="District">SomeValue</field>
# 								<field name="Population">SomeValue</field>
# 								</row>
# 								</table_data>
# 								</database>
# 								</mysqldump>
#
# 
# The following options pertain to filtering in terms of Schema objects being written to dump files, sorted by:
# Category
# triggers/events
# names to be dumped
# Filtering based on WHERE
#
# --all-databases, -A - Dump all the tables in all of the DBs. Same as using --databases on cmd line
# 								To include routines and events in terms of > 8.0, use --routines and --events in addition to the --all-databases
# 								The reason for this - is that the mysql.event and mysql.proc tables are not used.
#
# 								< 8.0, the system DB included the mysql.proc and mysql.event tables with the routines and event defs
#
# --databases, -B 	 - Dump several DBs. Normally - mysqldump treats each name past the first as tables. This treats all names as DBs.
# 								This can be used to dump the performance_schema DB, not normally dumped with --all-databases
# 								(Also use the --skip-lock-tables)
#
# --events, -E 		 - Include Event Scheduler events for the dumped databases in the output. This option requires the EVENT privs for those DBs.
# 								The output generated by using --events contains CREATE EVENT statements to create the events.
#
# --ignore-error= 		Ignore the specified errors. The option value is a comma-separated list of error numbers specifying the errors to ignore
#   <error>[,<error>].. during mysqldump execution.
#
# 								If the --force option is also given to ignore all errors, --force takes precedence.
#
# --ignore-table= 		Do not dump the given table, which must be specified using both the DB and Table names.
#   <db_name>.<tbl_name> To ignore multiple tables, use this option multiple times. Can also be used to ignore views.
#
# --no-data, -d 			Do not write any table row info (that is, do not dump the table contents). This is useful if you want to dump
# 								only the CREATE TABLE statement for the table (For example - to create a empty copy of the table by loading the dump file)
#
# --routines, -R 			Include stored routines (procedures and functions) for the dumped databases in the output. This option requires the global
# 								SELECT priv.
#
# 								The output generated by using --routines contains CREATE_PROCEDURE and CREATE_FUNCTION statements to create the routine.
# 
# --tables 					Override the --databases or -B option. mysqldump regards all name arguments following the option as table names.
#
# --triggers 				Include triggers for each dumped table in the output. This option is enabled by default; disable it with --skip-triggers
#
# 								To be able to dump a table's triggers - you must have the TRIGGER priv for the table.
#
# 								Multiple triggers are permitted. mysqldump dumps triggers in activation order so that when the dump file is reloaded,
# 								triggers are created in the same activation order. 
#
# 								If a mysqldump file contains multiple triggers for a table that have the same trigger event and action time,
# 								an error occurs to load the dump file into a older server that does not support multiple triggers.
#
# --where= 					Dump only rows selected by the given <WHERE> condition. Quotes around the condition are mandatory if it contains
#  <WHERE CONDITION>  	spaces or other chars that are special to your cmd interpreter (Just escape with ""'s)
#  -w <WHERE CONDITION>
#
# The following options pertain to performance options related to restore operations.
# For large data sets - restore operations (processing the INSERT statements in the dump file) takes a lot of time (or most)
# 
# Performance is also influenced by the transactional options, primarily for the dump operation.
#
# --column-statistics - Add <ANALYZE TABLE> statements to the output to generate histogram stats for dumped tables when the dump file is reloaded.
# 								This option is disabled by default because histogram generation for large tables takes a long time.
#
# --disable-keys, -K  - For each table - surround the <INSERT> statements with /*!40000 ALTER TABLE <tbl_name> DISABLE KEYS */;
# 																										 /*!40000 ALTER TABLE <tbl_name> ENABLE KEYS */;
#
# 								This makes loading the dump files faster because the indexes are created after all rows are inserted.
#								Effective only for nonunique indexes of MyISAM tables.
#
# --extended-insert,  - Write <INSERT> statements using multiple-row syntax that includes several VALUES lists.
#  -e  						Results in a smaller dump file and speeds up inserts when the file is reloaded.
#
# --insert-ignore 	 - Write <INSERT IGNORE> statements rather than <INSERT> statements.
#
# --opt 					 - This option, enabled by default - is short hand for: 
# 											--add-drop-table --add-locks --create-options
# 											--disable-keys --extended-insert --lock-tables
# 											--quick --set-charset
#
# 								It's basically a fast dump.
# 								Since --opt is default, running --skip-opt just turns off several defaults.
#
# --quick, -q 			 - Useful for dumping large tables. Forces mysqldump to retrieve rows for a table from the
# 								server a row at a time rather than retrieving the entire row set and buffering it in memory before writing it out.
#
# --skip-opt 			 - Read --opt 
#
# The following options pertain to trade off between speed, reliability and consistency of the exported data.
#
# --add-locks 			- Surround-each table dump with LOCK TABLES and UNLOCK TABLES statements.
# 							  Results in faster inserts when dump file is reloaded.
#
# --flush-logs,  		-  Flush the MySQL server log files before starting the dump. This option requires the RELOAD priv.
#  -F 					 	If you use this option in combo with the --all-databases option - the logs are flushed
# 								for each DB dumped.
#
# 								The exception is when using --lock-all-tables, --master-data or --single-transaction.
# 								In this case, the logs are flushed only once - corresponding to the moment that all tables
# 								are locked by <FLUSH TABLES WITH READ LOCK>.
#
# 								If you want your dump and the log flush to happen at exactly the same moment - you should use
# 								--flush-logs together with --lock-all-tables, --master-data, or --single-transaction.
#
# --flush-privileges 	Adds a FLUSH PRIVILEGES statement to the dump output after dumping the mysql database.
# 								This option should be used any time the dump contains the mysql DB and any other DB that depends
# 								on the data in the mysql db for proper restoration.
#
# 								For > 5.7.2 - do not use --flush-privileges.
#
# --lock-all-tables, 	Lock all tables across all databases. This is achieved by acquiring a global read lock for the
#  -x  						duration of the whole dump.
#
# 								This option automatically turns off --single-transaction and --lock-tables
# 
# --lock-tables, -l 		For each dumped database, lock all tables to be dumped before dumping them.
# 								The tables are locked with READ LOCAL to permit concurrent inserts in the case
# 								of MyISAM tables.
#
# 								For transactional tables such as InnoDB, --single-transaction is a much better option
# 								than --lock-tables because it does not need to lock the tables at all.
#
# 								Because --lock-tables locks tables for each DB separately, this option does not guarantee
# 								that the tables in the dump file are logically consistent between DBs.
#
# 								Tables in different DBs may be dumped in different states.
#
# 								Some options such as --opt automatically enable --lock-tables.
# 								If you want to override this  - use --skip-lock-tables at the end of the options list.
# 								
# --no-autocommit 		Enclose the INSERT statements for each dumped table within SET autocommit = 0 and COMMIT statements.
#
# --order-by-primary 	Dump each table's rows sorted by it's primary key - or by its first unique index - if such an index exists.
# 								This is useful when dumping a MyISAM table to be loaded into an InnoDB table, but makes the dump operation
# 								take a lot more time.
#
# --shared-memory- 		On Windows, the shared-memory name to use - for connections made using shared memory to a local server.
#  base-name=<name> 		The default value is MySQL. The shared-memory name is case-sensitive.
#
# 								Server must be started with the --shared-memory to enable shared-memory connections
#
# --single-transaction 	This option sets the transaction isolation mode to REPEATABLE READ and sends a START TRANSACTION SQL statement
# 								to the server before dumping data. It is useful only with transactional tables such as InnoDB - because it
# 								dumps the consistent state of the DB at the time of when START TRANSACTION was issued without blocking
# 								any apps.
#
# 								When using this option - you should keep in mind that only InnoDB tables are dumped in a consistent state.
# 								For example, any MyISAM or MEMORY tables dumped while using this option may still change state.
#
# 								While a --single-transaction dump is in process, to ensure a valid dump file (correct table contents and binary log coords)
# 								no other connection should use the following statements:
#
# 								ALTER TABLE, CREATE TABLE, DROP TABLE, RENAME TABLE, TRUNCATE TABLE
#
# 								A consistent read is not isolated from those statements - so use of them on a table to be dumped
# 								can cause the SELECT that is performed by mysqldump to retrieve the table contents to obtain incorrect contents or fail.
#
# 								The --single-transaction option and the --lock-tables option are mutually exclusive because LOCK TABLES causes any
# 								pending transactions to be committed implicitly.
#
# 								To dump larger tables - combine the --single-transaction option with the --quick option.
#
# The following are some examples:
#
# Backup of an entire DB:
#
# mysqldump <db_name> > backup-file.sql
#
# To load the dump file back into the server:
#
# mysql <db_name> < backup-file.sql
#
# Another way to reload the dump file:
#
# mysql -e "source /path-to-backup/backup-file.sql" <db_name>
#
# mysqldump can also populate other DBs by copying data from one MySQL server to another:
#
# mysqldump --opt <db_name> | mysql --host=<remote_host> -C <db_name>
#
# We can also dump several DBs with one comment:
#
# mysqldump --databases <db_name1> [<db_name2> ...] > <my_databases.sql>
#
# We can also direct flow of output to a sql file :
# mysqldump --all-databases > all_databases.sql
#
# For InnoDB tables, mysqldump provides a way of making a online backup:
#
# mysqldump --all-databases --master-data --single-transaction > all_databases.sql
#
# This backup acquires global read lock on all tables (using the FLUSH TABLES WITH READ LOCK) at the beginning of the dump.
# As soon as the lock has been aquired - the binary log co-ords are read and the lock is released.
#
# If long updating statements are running when the FLUSH statement is issued - the MySQL server may get stalled
# until said statements finish.
#
# After that - the dump becomes lock free and does not disturb reads and writes on the tables. If the update statements
# that the MySQL server receives are short (in terms of execution time) - the initial lock period should not be noticable.
#
# If we are interested in point-in-time recovery (known as "roll-forward" - when we need to restore an old backup and replay the changes that
# 																  happened since that backup) - it is useful to rotate the binary log - or at least know the binary log co-ords
# 																  to which the dump corresponds:
#
# mysqldump --all-databases --master-data=2 > all_databases.sql
#
# OR
#
# mysqldump --all-databases --flush-logs --master-data=2 > all_databases.sql
#
# The --master-data and --single-transaction options can be used at the same time - which provides a convenient way to make a online
# backup suitable for use prior to point-in-time recovery if tables are used with InnoDB as a storage engine.
#
# Mysqldump does not dump the performance_schema or sys schema by default. To dump any of these - name them explicitly  on the cmd line.
# You can also name them with the --databases option. For performance_schema - also use the --skip-lock-tables option.
#
# mysqldump does not dump the INFORMATION_SCHEMA schema
#
# mysqldump does not dump InnoDB CREATE TABLESPACE statements
#
# mysqldump includes statements to recreate the <general_log> and <slow_query_log> tables for dumps of the mysql database.
# Log table contents are not dumped.
#
# The following options section pertains to mysqlimport - which is used for data imports.
#
# The mysqlimport client provides a CMD line interface to the LOAD DATA INFILE SQL statement.
# Most options to mysqlimport correspond directly to clauses of LOAD DATA INFILE syntax.
#
# To invoke mysqlimport, the syntax is generally:
#
# mysqlimport [<options>] <db_name> <textfile1> [<textfile2>]
#
# For each text file named on the cmd line - mysqlimport strips any extension from the file name and uses
# the result to determine the name of the table into which to import the file's contents.
#
# For example - files named patient.txt, patient.text and patient all would be imported into a table called patient.
#
# We can define the following options on the cmd line or the [mysqlimport] and [client] groups of an option file.
#
# 		FORMAT 											Desc
# --bind-address  			Use specified network interface to connect to MySQL Server
# --columns 					This option takes a comma-separated list of column names as its value
# --compress 					Compress all information sent between client and server
# --debug 						Write debug log
# --debug-check 				Print debug info when program exits
# --debug-info 				Print debug info, memory and CPU stats when the program exits
# --default-auth 				Auth plugin to use
#
# --default-character-set 	Specify default character set
# --defaults-extra-file 	Read named option file in addition to usual option files
# --defaults-file 			Read only named option file
# --defaults-group-suffix 	Option group suffix value
# --delete 						Empty the table before importing the text file
#
# --enable-cleartext- 		Enable cleartext auth plugin
#   plugin
# --fields-enclosed-by 		keeps the same for several structures adhering to the following
# --force 						Continue even if an SQL error occurs
# --get-server-public-key 	Request RSA public key from server
# --help 						Displays help message and exits
# --host 						Connect to MySQL server on given host
#
# --ignore 						See the desc file for the --replace option
# --ignore-lines 				Ignore the first N lines of hte data file
# --lines-terminated-by 	Same as other terminated by dynamics
# --local 						Read input files locally from the client host
# --lock-tables 				Lock all tables for writing before processing any text files
#
# --login-path 				Read login path options from .mylogin.cnf
# --low-priority 				Use LOW_PRIORITY when loading the table
# --no-defaults 				Read no option files
# --password 					PW to use when connecting to server
# --pipe 						On Windows, connect to the server using named pipe
#
# --plugin-dir 				Dir where plugins are installed
# --port 						TCP/IP number for connection
# --print-defaults 			Print default options
# --protocol 					Connection protocol to use
# --replace 					The --replace and --ignore options control handling of input rows that duplicate
# 									existing rows on unique key values
# --secure-auth 				REMOVED
#
# --server-public-key-path Path name to file containing RSA public key
# --shared-memory-base- 	Name of the shared memory to use for shared-memory connections
#   name
# --silent 						Produce output only when errors occur
# --socket 						For connections to localhost, the Unix file socket to use
#
# --ssl-ca 						File that contains list of trusted SSL Cert Auths
# --ssl-capath 				Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 					File that contains X.509 cert
# --ssl-cipher 				List of permitted ciphers for connection encryption
# --ssl-crl 					File that contains cert revocation lists
# --ssl-crlpath 				Dir that contains cert revocation list files
#
# --ssl-fips-mode 			Whether to enable FIPS mode on the client side
# --ssl-key 					File that contains X.509 key
# --ssl-mode 					Security state of connection to the server
# --tls-version 				Protocols permitted for encrypted connections
# --use-threads 				Number of threads for parallel file-loading
# --user 						MySQL user name to use when connecting to server
# --verbose 					Verbose mode
# --version 					Display v info and exit

# --help, -? - Display help and exit
# --bind-adress=<ip address> - On a computer having multiple network interfaces, use this option to select which interface to use for connecting to the MySQL serv.
# --character-sets-dir=<dir name> - The dir where char sets are installed
# --columns=<column list>, 		 - This option takes a comma-separated list of column names as its value. The order of the column names indicates how to match
#  -c <column_list> 						data file columns with table columns
# --compress, -C 						 - Compress all information sent between client and the server if both support compression
# --debug[=<debug options>], 		 - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>. Default is d:t:o
#  -# [<debug_options>]
# --debug-check 						 - Print some debugging information when the program exits
# --debug-info 						 - Print debugging info, memory info, CPU usage etc. when the program exits
# 
# --default-character-set= 		 - Use <charset_name> as the default char set
#  <charset_name>
#
# --default-auth=<plugin> 			 - Hint about client-side auth plugin to use
#
# --defaults-extra-file= 			 - Same as previous file ordering partition
#  <file name>
#
# --defaults-file=<file name> 	 - Use only given option file, .mylogin.cnf is still read - path is relative if relative, full otherwise
#
# --defaults-group-suffix= 		 - Suffix regex against group names
# 	 <str>
#
# --delete, -D 						 - Empty the table before importing the text file
#
# --enable-cleartext-plugin 		 - Enable the mysql_clear_password cleartext auth plugin
#
# Ommited a few due to repetition
#
# --host=<host name>, 				 - Import data to mysql server on the given host - defaults to Local
#  -h <host_name>
#
# --ignore, -i 						 - --replace, basically
#
# --ignore-lines=<N> 				 - Ignore the N first lines of hte data file
#
# --lines-terminated-by=<...> 	 - This option has the same meaning as the corresponding clause for LOAD DATA INFILE.
# 												For example - to import Windows files that have lines terminated with carriage return/linefeed pairs,
# 												use --lines-terminated-by="\r\n".
#
# --local, -L 							 - Default, files are read by the server on the server host. With this option, mysqlimport reads input files locally
# 												on the client host. Enabling local data loading also requires that the server permits it.
#
# --lock-tables, -l 					 - Lock all tables for writing before processing any text files. Ensures that all tables are synched on the server.
#
# --login-path=<name> 				 - Read options from the named login path in the .mylogin.cnf login path file.
# 												A "login path" is an option group containing options that specify which MySQL server to connect to
# 												and which acc to auth as. Used with mysql_config_editor
#
# --low-priority 						 - Use LOW_PRIORITY when loading the table. This affects only storage engines that use only table-level locking
# 												(such as MyISAM, MEMORY, and MERGE)
#
# --no-defaults 						 - Same as other no-defaults
#
# SKIP A FEW BECAUSE REPEAT
#
# --replace, -r 						  - The --replace and --ignore options control handling of input rows that duplicate existing rows on unique key values.
# 												 If given - new rows replace existing rows that have the same unique key value.
# 												 --ignore skips - If neither is given, an error occurs when running into a duplication and ignores the rest of the file.
#
# //SKIPPED REPEATAL
#
# --use-threads=<N> 						- Load files in parallel using <N> threads
#
# Example of showcasing of usage:
#
# mysql -e 'CREATE TABLE imptest(id INT, n VARCHAR(30))' test #Create the table
# ed #Linux text editor interaction
# a
# 100 		Max Sydow
# 101 		Count Dracula
#
# w imptest.txt #Write to imptext.txt
# 32
# q
# od -c imptest.txt #Dump octal format unto text file and utilize -c to run the command as this program in terms of interpretation
# <Octal format for String chars> <id value> <String structure> #The first string value of 100 max Sydow
# etc.
#
# mysqlimport --local test imptest.txt #connect to local, select a table called test and insert the imptest info
# test.imptest: Records: 2 Deleted: 0 Skipped: 0 warning: 0 #Imports into table
# mysql -e 'SELECT * FROM imptest' test #Select all from imptext, escape chars with -e
# +----------------------------------+
# | id 	| 	n 								 |
# +------+---------------------------+
# |  100 | Max Sydow 					 |
# |  101 | Count Dracula 				 |
# +------+---------------------------+
#
#
# The following section covers mysqlpump - which breaks down DBs etc. into logical backups, which comes in the form of
# a set of SQL statements that can rebuild the system you broke down.
#
# Can dump one or several DBs.
#
# The features covers things akin to:
#
# Parallel processing of DBs, and of objects within DBs
# Better control over which DB and DB objects (tables, stored programs, user accs) to dump
# Dumping of user accs as account-management statements (CREATE USER, GRANT) - rather than as inserts into the mysql DB
# 
# Capability of creating compressed output
# Progress indicator (estimates)
# In terms of dump file reloading, faster secondary index creation for InnoDB tables by adding indexes after rows are inserted
#
# mysqlpump requires at least the SELECT privilege for dumped tables, SHOW VIEW for dumped views, TRIGGER for dumped triggers
# LOCK TABLES if the --single-transaction option is not used
#
# The SELECT priv on the mysql system db is required to dump user defs. Certain options might require other privs
# as noted in the option desc.
#
# To reload a dump file - you must have the privs reqed to execute the statements that it contains - such as appropiate CREATE privs
# for objects created by said statements.
#
# When dumping, use --result-file to circumvent UTF-16 encoding
#
# mysqlpump [<options>] > dump.sql #UTF-16, not allowed as server conn Char set
#
# mysqlpump [<options>] --result-file=dump.sql
#
# By default, mysqlpump dumps all the DBs, except a few. Can use --all-databases to do all
#
# To dump more specifically - following syntax holds:
#
# mysqlpump <db_name>
# mysqlpump <db_name> <tbl_name1, tbl_name2>
#
# To treat all name args as DB names - use the --databases option:
#
# mysqlpump --databases <db_name1, db_name2>
#
# By default, mysqlpump does not dump user acc defs - even if you dump the mysql system DB that contains the grant tables.
# To dump grant table contents as logical definitions in the form of CREATE USER and GRANT statements - use the --users option
# and suppress all DB dumping
#
# mysqlpump --exclude-databases=% --users
#
# The % above is wildchar regex against any name sequence in the context above
#
# mysql has different options for including/excluding DBs, tables, stored programs and user defs.
#
# To reload a dump file - execute the statements that it contains. For instance:
#
# mysqlpump [<options>] > dump.sql
# mysql < dump.sql
#
# FORMAT 										Desc
# --add-drop-database 				Add DROP DATABASE statement before each CREATE DATABASE statement
# --add-drop-table 					Add DROP TABLE statement before each CREATE TABLE statement
# --add-drop-user 					Add DROP USER statement before each CREATE USER statement
# --add-locks 							Surround each table dump with LOCK TABLES and UNLOCK TABLES statements
# --all-databases 					Dump all DBs
#
# --bind-address 						Use specified network interface to connect to MySQL Server
# --character-sets-dir 				Dir where char sets are installed
# --column- statistics 				Write ANALYZE TABLE statements to generate stats histograms
# --complete-insert 					Use complete INSERT statements that include column names
# --compress 							Compress all information sent between client and server
#
# --compress-output 					Output compress algo
# --databases 							Interpret all name args as DB names
# --debug 								Write debugging log
# --debug-check 						Print debugging info when program exits
# --debug-info 						Print debug info, memory and CPU stats when program exits
# --default-auth 						Auth plugin to use
#
# --default-character-set 			Specify default char set
# --default-parallelism 			Default number of threads for parallel processing
# --defaults-extra-file 			Read named option file in addition to usual option files
# --defaults-file 					Read only named option file
#
# --defaults-group-suffix 			Option group suffix regex
# --defer-table-indexes 			For reloading, defer index creation until after loading table rows
# --events 								Dump events from dumped databases
# --exclude-databases 				Databases to exclude from dump
# --exclude-events 					Events to exclude from dump
#
# --exclude-routines 				Routines to exclude from dump
# --exclude-tables 					Tables to exclude from dump
# --exclude-triggers 				Triggers to exclude from dump
# --exclude-users 					Users to exclude from dump
# --extended-insert 					Use multiple-row INSERT syntax
#
# --get-server-public-key 			Request RSA public key from server
# --help 								Display help and exit
# --hex-blob 							Dump binary columns using hexadecimal notation
# --host 								Host to connect to (IP address or hostname)
# --include-databases 				DBs to include in dump
#
# --include-events 					Events to include in dump
# --include-routines 				Routines to include in dump
# --include-tables 					Tables to include in dump
# --include-triggers 				Triggers to include in dump
# --include-users 					Users to include in dump
#
# --insert-ignore 					Write INSERT IGNORE rather than INSERT statements
# --log-error-file 					Append warnings and errors to named file
# --login-path 						Read login path options from .mylogin.cnf
# --max-allowed-packet 				Maximum packet length to send or recieve from server
# --net-buffer-length 				Buffer size for TCP/IP and socket communication
# --no-create-db 						Do not write CREATE DATABASE statements
# --no-create-info 					Do not write CREATE TABLE statements that re-create each dumped table
#
# --no-defaults 						Read no option files
# --parallel-schemas 				Specify schema-processing parallelism
# --password 							Password to use when connecting to server
# --plugin-dir 						Dir where plugins are installed
# --port 								TCP/IP port number for connection
# --print-defaults 					Print default options
#
# --protocol 							Connection protocol to use
# --replace 							Write REPLACE statements rather than INSERT statements
# --result-file 						Direct output to a given file
# --routines 							Dump stored routines (procedures and functions) from dumped DBs
# --server-public-key-path 		Path name to file containing RSA public key
#
# --set-charset 						Add SET NAMES default_char_set to output
# --set-gtid-purged 					Whether to add SET @@GLOBAL.GTID_PURGED to output
# --single-transaction 				Dump tables within single transaction
# --skip-definer 						Omit DEFINER and SQL SECURITY clauses from view and stored program CREATE statements
# --skip-dump-rows 					Do not dump table rows
# --socket 								For connections to localhost, the Unix socket file to use
# --ssl-ca 								File that contains list of trusted SSL Cert Auths
# --ssl-capath 						Dir that contains trusted SSL Cert Auth cert files
#
# --ssl-cert 							File that contains X.509 cert
# --ssl-cipher 						List of permitted ciphers for connection encryption
# --ssl-crl 							File that contains cert revocation lists
# --ssl-crlpath 						Dir that contains cert revocation list files
# --ssl-fips-mode 					Whether to enable FIPS mode on the client side
# --ssl-key 							File that contains X.509 key
#
# --ssl-mode 							Security state of connection to server
# --tls-version 						Protocols permitted for encrypted connections
# --triggers 							Dump triggers for each dumped table
# --tz-utc 								Add SET TIME_ZONE='+00:00' to dump file
# --user 								MySQL user name to use when connecting to server
# --users 								Dump user accs
#
# --version 							Display version info and exit
# --watch-progress 					Display progress indicator
#
# The following is further designation of options:
#
# --help, -? - Display a help message and exit
# --add-drop-database - Write a DROP DATABASE statement before each CREATE DATABASE statement.
# --add-drop-table - Write a DROP TABLE statement before each CREATE TABLE statement
# --add-drop-user - Write a DROP USER statement before each CREATE USER statement
#
# --add-locks - Surround each table dump with LOCK_TABLES and UNLOCK_TABLES statements. Causes faster inserts when dump is loaded
#
# 					 Does not work with parallelism because INSERT statements from different tables can be interleaved,
# 					 UNLOCK TABLES following the end of the inserts for one table could release locks on tables for which inserts remain.
#
# 					 i.e - --add-locks and --single-transaction are mutually exclusive
#
# --all-databases, - Dump all databases. Exclusive towards --databases. Defaults to dumping all, except few.
#  -A
#
# 							< MySQL 8.0 - includes mysql system db, also mysql.proc and mysql.event tables - with routines and events
# 							>= MySQL 8.0 - mysql.event and mysql.proc tables are not used. To include, use --routines and -events explicitly
#
# --bind-address   - On a computer having multiple network interfaces - use this option to select which interface to use for connecting to the MySQL server 
#  =<ip address>
#
# --character-sets-dir - The dir where char sets are installed
#  =<path>
#
# --column-statistics - Add ANALYZE TABLE statements to the output to generate histogram statistics for dumped tables when the dump file is reloaded.
# 								This option is disabled by default because histogram generation for large tables can take a long time.
#
# --complete-insert 	 - Write complete INSERT statements that include column names
#
# --compress, -C 		 - Compress all information sent between the client and server if both support compression
#
# --compress-output=  - By default, mysqlpump does not compress output. This option specifies output compressiion using the specified algo.
#  <algorithm> 		   Permitted are LZ4 and ZLIB.
#
# 								To uncompress compressed output - you must have an appropiate utility. If the system commands iz4 and openssl zlib are not about,
# 								MySQL includes iz4_decompress and zlib_decompress utilities that can be used to decompress mysqlpump output that was
# 								compressed using the --compress-output=LZ4 and --compress-output=ZLIB.
#
# --databases, -B 	 - Normally, mysqlpump treats the first name arg on the cmd line as a db name and any following names as table names.
# 								With this option - it treats all name args as db names. CREATE DATABASE statements are included in the output before
# 								each new DB.
#
# 								--all-databases and --databases are exclusive.
#
# --debug[=<debug options>] - Write a debugging log. A typical <debug_options> is d:t:o, <file_name>. Defaults to d:t:O, /tmp/mysqlpump.trace
#  -# [<debug_options>
#
# --debug-check - Print some debugging when the program exits
#
# --debug-info, -T - Print debugging info, memory and stats usage when the program exits.
#
# --default-auth - Hint about the client-side auth plugin to use 
#  =<plugin>
#
# --default-character-set= - Use <charset_name> as the default char set - if none specified, defaults to UTF8
#   <charset_name>
#
# --default-parallelism=<N> - The default number of threads for each parallel processing queue. Defaults to 2.
#
# 										--parallel-schemas also affects parallelism - and can be used to override the default numbers of threads.
#
# 										If we use --default-parallelism=0 and no --parallel-schemas - mysqlpump runs a single-threaded process and 
# 										creates no queues.
# 	
#  									With parallelism enabled - it is possible for output from different databases to be interleaved
#
# --defaults-extra-file=    - Read this option file after the global option file but (on Unix) before the user option file.
#   <file name> 					Relative if relative, absolute if absolute - failure to access throws an error
#
# --defaults-file= 			 - Use only the given option file. If it does not exist or cannot be accessed - error is thrown.
#   <file name> 					.mylogin.cnf is still read
#
# 										Relative if relative, absolute if absolute etc.
#
# --defaults-group-suffix=  - Regex match against suffix in groupings
#  <str>
#
# --defer-table-indexes 	 - In the dump output, defer index creation for each table until after its rows have been loaded.
# 										This works for all storage engines - but for InnoDB applies only for secondary indexes.
#
# 										Enabled by default, --skip-defer-tables-indexes to disable.
#
# --events 							Include Event Scheduler events for the dumped databases in the output. 
# 										Event dumping requires the EVENT privs for those DBs.
#
# 										The output generated by using --events contains CREATE EVENT statements to create the events.
# 										On by default - use --skip-events to disable it
#
# --exclude-databases= 		 - Do not dump the DBs in said list. This option stacks.
#  <db_list>
#
# --exclude-events= 			 - Do not dump the DBs in <event list>. Stacks.
#  <event_list>
#
# --exclude-routines/tables/triggers/users - Do not dump events/tables/triggers/users in said list. Stacks.
#
# --extended-insert=<N> 	 - Write INSERT statements using multiple-row syntax that includes several VALUES lists.
# 										Results in smaller dump file and speeds up inserts when the file is reloaded.
#
# 										Option value indicates number of rows to include in each INSERT statement. Defaults to 250.
# 										This means the total of 250 rows are bound to a INSERT statement in terms of list relation.
#
# --hex-blob 					-  Binary colums are converted to hexadecimal. BINARY, VARBINARY, BLOB and BIT are affected.
#
# --host=<host name>,      -  Dump data from the MySQL server on the given host.
#  -h <host name>
#
# --include-databases/events/routines/tables/triggers/user= Dump the databases/events/routines/tables/triggers/users in the respective list. Stacks. 		-  
# 	 <db_list>
#
# --insert-ignore 			- Write INSERT IGNORE instead of INSERT statements.
#
# --log-error-file= 			- Log warnings and errors by appending them to the named file. If this option is not given, mysqlpump writes warnings and 
# 									  errors to the std error output.
#
# --login-path=<name> 		- Read options from the named login path in the .mylogin.cnf login path file.
# 									  A "login path" is an option group containing options that specify which MySQL
# 									  to connect to and which acc to auth as. Create or modify with mysql_config_editor
#
# --max-allowed-packet=<N> - Max size of the buffer for client/server comm. Defaults to 24MB, max to 1gb
#   <file name>
#
# --net-buffer-length=<N>  - The initial size of the buffer for client/server comm. When creating multiple-row INSERT 
# 									  statements (as with the --extended-insert) - mysqlpump creates rows up to <N> bytes long.
#
# 									  If you use this option to increase the value - ensure that the MySQL server <net buffer length>
# 									  system var has a value at least this large.
#
# --no-create-db 				- Suppress any <CREATE DATABASE> statements that might otherwise be included in the output.
#
# --no-create-info, -t 		- Do not write <CREATE TABLE> statements that create each dumped table
#
# --parallel-schemas=[<N:> - Create a queue for processing the DBs in db_list. If N is given, the queue uses N threads.
#  <db list>] 					  If N is not defined - --default-parallelism defines the number of queue threads.
#
# 									  Multiple instances of this option creates multiple queues. Also creates a default queue to use
# 									  for DBs not named in any --parallel-schemas option - and for dumping user definitions if command
# 									  options select them.
#
# --password[=<password>], - The PW to use for connecting to the server. If -p is used - cannot have space between designation.
#  -p [<password>] 			  
#
# --plugin-dir=<dir name>  - The dir where to look for plugins. Specify this option if the --default-auth option is used to specify
# 									  an auth plugin but mysqlpump doesn ot find it.
#
# --port=<port num>, 	   - The TCP/IP port number to use for the connection
#  -P <port_num>
#
# --print-defaults 			- Print the program name and all options that it gets from option files
#
# --protocol= 					- Protocol to use
#  {TCP|SOCKET|PIPE|MEMORY}
#
# --replace 					- Write REPLACE statements rather than INSERT statements
#
# --result-file=<file name>- Direct output to the named file. Result file is created and its previous contents overwritten,
# 									  even if an error occurs while generating the dump.
#
# 									  Should be used on Windows to prevent \n from being converted to \r\n
#
# --routines 					- Include stored routines (procedures and functions) for the dumped DB in the output.
# 									  Requires the global SELECT priv.
#
# 									  output generated by using --routines contains CREATE PROCEDURE and CREATE FUNCTION statements to 
# 									  create the routines.
#
# 									  Enabled by default, use --skip-routines to disable it.
#
# --secure-auth 				- REMOVED
#
# --set-gtid-purged=<value>- Enables control over global transaction ID (GTID) info written to the dump file, by indicating whether
# 									  to add a SET @@global.gtid purged statement to the output.
#
# 									  This option may also cause a statement to be written to the output that disables binary logging
# 									  while the dump file is being reloaded.
#
# 									  Defaults: AUTO
# 									  OFF --> No SET statement in the output
# 									  ON  --> Add a SET statement to the output. Error occurs if GTIDs are not enabled on the server.
# 									  AUTO -> Add a SET statement to the output if GTIDs are enabled on the server.
#
# 									  The --set-gtid-purged option has the following effect on binary logging when the dump file is reloaded:
#
# 									  --set-gtid-purged=OFF:SET @@SESSION.SQL_LOG_BIN=0; is not added to the output
# 									  --set-gtid-purged=ON:SET @@SESSION.SQL_LOG_BIN=0; is added to the output
# 									  --set-gtid-purged=AUTO:SET @@SESSION.SQL_LOG_BIN=0; is added to the output if GTIDs are enabled on the server
# 									  you are backing up (that is - if AUTO is evaluated as ON)
#
# --single-transaction 		- Sets the transaction isolation mode to REPEATABLE READ and sends a START TRANSACTION SQL statement to the server before dumping data.
# 									  It is useful only with transactional tables such as InnoDB, because then it dumps the consistent state of the DB
# 									  at the time when START TRANSACTION was issued without blocking any app.
#
# 									  Only InnoDB tables are dumped in a consistent state. For example - MyISAM or MEMORY tables dumped while using this
# 									  may still change state.
#
# 									  While a --single-transaction dump is in process, to ensure a valid dump file (correct table contents and binary log coords)
# 									  no other connection should use the following statements:
#
# 									  ALTER TABLE, CREATE TABLE, DROP TABLE, RENAME TABLE, TRUNCATE TABLE
#
# 									  a consistent read is not isolated from those statements - so use of them on a table to be dumped
# 									  can cause the SELECT that is performed by mysqlpump to retrieve the table contents to obtain
# 									  incorrect contents or fail.
#
# 								     --add-locks is exclusive against --single-transaction
#
# --skip-definer 				- Omit DEFINER and SQL SECURITY clauses from the CREATE statements for views and stored programs. The dump file,
# 									  when reloaded - creates objects that use the default DEFINER and SQL SECURITY values.
#
# --skip-dump-rows, 			- Do not dump table rows
#  -d
#
# --socket= 						- For connections to localhost, the Unix socket file to use - or on Windows, name of the named pipe to use
# {<file name>|<pipe name>}, 
# -S {<file name>|<pipe name>}
#
# --ssl* 							- Options that begin with --ssl specify whether to connect to the server using SSL and indicate where to find SSL keys/certs
#
# --ssl-fips-mode= 				- Whether to use fips mode on client. 
#  {OFF|ON|STRICT}
#
# --tls-version=<protocol list> - The protocols permitted by the client for encrypted connections.
#
# --triggers 						- Include triggers for each dumped table in the output.
# 										  Enabled by default - use --skip-triggers to disable it
#
# --tz-utc 							- Enables TIMESTAMP columns to be dumped and reloaded between servers in different time zones.
# 										  mysqlpump Sets its connection time zone to UTC and adds SET TIME_ZONE='+00:00' to the dump file.
#
# 										  Without this option - TIMESTAMP columns are dumped and reloaded in the time zones local to the source
# 										  and destination server - which can cause the values to change if servers are in different time zones.
# 
# 										  --tz-utc also protects against changes due to daylight saving time.
#
# 										  Enabled by default, use --skip-tz-utc to disable it
#
# --user=<user name>, 		   - Name of MySQL user to connect with
#  -u <user_name>
#
# --users 							- Dump user accs as logical definitions in the form of CREATE USER and GRANT statements.
# 											
#                               User definitions are stored in the grant tables in the mysql system database. By default, mysqlpump
# 										  does not include the grant tables in mysql database dumps.
#
# 										  To dump the contents of the grant tables as logical definitions - use the --users option and suppress
# 										  all database dumping:
#
# 										  mysqlpump --exclude-databases=% --users
#
# --version, -V 					- Display version info and exit
#
# --watch-progress 				- Periodically display a progress indicator that provides info about the completed and total number of tables, rows, etc.
# 										  On by default - --skip-watch-progress to disable it
#
# The following section covers mysqlpump Object Selection
#
# mysqlpump has a set of inclusion and exclusion options that enable filtering of several object types and control which objects to dump:
#
# --include-databases and --exclude-databases apply to databases and all objects within them
# --include-tables and --exclude-tables apply to tables. These options also affect triggers associated with tables unless the trigger-specific
# 																			options are given.
# --include-triggers and --exclude-triggers - apply to triggers
#
# --include-routines and --exclude-routines - apply to stored procedures and functions. If a routine option matches a stored
# 															 function of the same name.
#
# --include-events and --exclude-events - apply to Event Scheduler events
#
# --include-users and --exclude-users - apply to user accounts
#
# Any inclusion or exclusion option may be given multiple times. Stacks. Order of options does not matter.
# The value of each inclusion and exclusion option is a list of namings
#
# --exclude-databases=test,world
# --include-tables=customer,invoice
#
# Wildcard chars are permitted (% as sequence, _ as regex against singular char)
#
# Example: --include-tables=t%, _____tmp matches all table names that begin with t - and all len(5) table names that end with tmp
#
# For users, a name specified without a host part is interpreted with an implied host of %.
# For example: u1 and u1@% are equivalent.
#
# Inclusion and exclusion options interact as follows:
#
# With no inclusion or exclusion options - mysqlpump dumps all databases (with a few notable exceptions)
#
# If inclusion options are given in the absence of exclusion options - only the objects named as included are dumped.
#
# If exclusion options are given in the absence of inclusion options - all objects are dumped except those named as excluded.
#
# If inclusion and exclusion options are given - all objects named as excluded and not named as inlcuded are not dumped. All others are.
#
# If multiple DBs are being dumped - it is possible to name tables, triggers and routines in a specific database by qualifying 
# the object names with the DB name.
#
# Example:
#
# mysqlpump --include-databases=db1,db2 --exclude-tables=db1.t1,db2.t2 #Dumps db1 and db2, but excludes specific tables
#
# The following options provide alternative ways to specify which DB to dump:
#
# The --all-databases option dumps all DBs (with certain exceptions). Equivalent to specifying no object options at all
#
# --include-databases=% is similar to --all-databases, but selects all databases for dumping, even those that are exceptions for --all-databases
#
# The --databases option causes mysqlpump to treat all name args as names of DBs to dump.
# Equivalent to an --include-databases option that names the same DBs.
#
# mysqlpump Parallel Processing
#
# mysqlpump can use parallelism to achieve concurrent processing. You can select concurrency between DBs (to dump multiple DBs at once)
# and within DBs (to dump multiple objects from a given DB simultaneously)
#
# By default - mysqlpump sets up one queue with two threads. You can create additional queues and control the number of threads assigned
# to each one - including the default queue:
#
# --default-parallelism=<N> specifies the default number of threads used for each queue. In the absence of this Option, N is 2.
#
# 									 The default queue always uses the default number of threads. Additional queues use the default number of threads
# 									 unless you specify otherwise.
#
# --parallel-schemas=[<N:>] sets up a processing queue for dumping the DBs named in <db_list> and optionally specifies how many
#  <db_list> 					 threads the queue uses.
#
# 									 <db_list> is a list of DB names. If the option argument begins with <N:>, the queue uses <N> threads.
# 									 Otherwise, the --default-parallelism option determines the number of queue threads.
#
# 									 Multiple instances of the --parallel-schemas option create multiple queues.
#
# 									 Names in the database list are permitted to contain the same % and _ wildcards as filtering.
#
# mysqlpump uses the default queue for processing any DBs not named explicitly with a --parallel-schemas option, and for dumping 
# user defs if cmd options select them.
#
# In general - with multiple queues, mysqlpump uses parallelism between the sets of DBs processed by the queues, to dump multiple
# DBs at once.
#
# For a queue that uses multiple threads, mysqlpump uses parallelism within DBs - to dump multiple objects from a given DB at once.
# Exceptions can occur; for example, mysqlpump may block queues while it obtains from the server lists of objects in DBs.
#
# With parallelism on - it is possible for output from different DBs to interleave. For example, INSERT statements from multiple
# tables dumped in parallel can be interleaved - they are not written in any specific order.
#
# Does not affect reloading because output statements qualify object names with DB names or are preceded by USE statements as required.
#
# The smallest scope of parallelism - is a single DB.
#
# Example:
#
# mysqlpump --parallel-schemas=db1,db2 --parallel-schemas=db3 #Partition db1 and db2 to a specific queue, another to Db3 - and a default for the rest. All queues use two threads.
#
# mysqlpump --parallel-schemas=db1,db2 --parallel-schemas=db3 --default-parallelism=4 #Same as above, except 4 threads for each queue
#
# We can also further partition thread usage if we wish:
#
# mysqlpump --parallel-schemas=5:db1,db2 --parallel-schemas=3:db3 #Run with 5 threads for queue related to db1 and db2, run with 3 for queue on db3, 2 for default to rest
#
# We can also disable multi-threading and allocate no queues
#
# --default-parallelism=0 and no --parallel-schemas options - runs a single-threaded process and creates no queues.
#
# The following pertains to mysqlpump in terms of restrictions
#
# mysqlpump does not dump the performance_schema, ndbinfo or sys schema by default. To dump any of said ones, name them
# explicitly on cmd line. Can also name them with --databases or --include-databases option
#
# mysqlpump does not dump the INFORMATION_SCHEMA schema
#
# mysqlpump does not dump InnoDB CREATE_TABLESPACE statements
#
# mysqlpump dumps user accounts in logical form using CREATE USER and GRANT statements (for example - when using the --include-users or --users option)
# For this reason, dumps of the mysql system DB do not by default include the grant tables that contain user defs:
#
# user,db,tables_priv, columns_priv, procs_priv or proxies_priv. To dump any of the grant tables, name the mysql DBs by the table names:
#
# mysqlpump mysql user db ...
#
# The following section pertains to mysqlshow.
#
# The mysqlshow client can be used to quickly see which DB exists, their tables or a table's columns or indexes.
#
# mysqlshow provides a cmd-line interface to several SQL SHOW statements. The same info can be obtained by using those statements directly.
# For example - we can issue them from the mysql client program.
#
# mysqlshow [<options>] [<db_name> [<tbl_name> [<col_name>]]]
#
# If no DB is given - a list of DB names is shown.
# If no table is given - all matching tables in the DB are shown.
# If no column is given - all matching columns and column types in the table are shown.
#
# The output displays only the names of those databases, tables or columns for which you have some privs.
# 
# If the last argument contains shell or SQL wildcard chars (*, ?, %, or _) - only those names that are matched
# by the wildcard are shown. If a DB name contains any underscores - those should be escaped with // or /.
#
# * and ? are converted into SQL % and _ wildcard chars. This might cause some confusion when you try to display
# the columns for a table with a _ in the name, because in this case - mysqlshow shows you only the table names
# that match the pattern.
#
# Can be fixed by adding an extra % last on the cmd line as a arg
#
# mysqlshow can utilize the following options:
#
# 		Format 					Desc
# --bind-address 	 Use specified network interface to connect to MySQL server
# --compress 		 Compress all information sent between client and server
# --count 			 Show the number of rows per table
# --debug 			 Write debugging log
#
# --debug-check 	 Print debug info when program exits
# --debug-info 	 Print debug info, memory and CPU stats when exiting
# --default-auth 	 Auth plugin to use
# --default-char-  Specify default charset
#   set
# --defaults-extra- Read named option file in addition to usual option files
#   file
#
# --defaults-file  Read only named option file
# --defaults-group Option group suffix value
#  -suffix
#
# --enable-cleartext Enable cleartext Auth plugin
#  -plugin 			 
# --get-server-      Request RSA public key from server
#   public-key
# --help 				Display help message and exit
# --host 				Connect to MySQL server on given host
# --keys 				Show table indexes
# --login-path 		Read login path options from .mylogin.cnf
# --no-defaults 		Read no option files
#
# --password 			Password to use when when connecting to server
# --pipe 				On Windows, connect to server using named pipe
# --plugin-dir 		Dir where plugins are installed
# --port 				TCP/IP port number for connection
# --print-defaults 	Print default options
#
# --protocol 			Connection protocol to use
# --secure-auth 		REMOVED
# --server-public-   Path name to file containing RSA public key
#   key-path
# --shared-memory    Name of the shared memory to use for shared-memory connections
#  -base-name
# --show-table-type 	Show a column indicating the table type
# --socket 				For connections to localhost, the Unix socket file to use
# --ssl-ca 				File that contains list of trusted SSL Cert Auths
#
# --ssl-capath 		Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 			File that contains X.509 cert
# --ssl-cipher 		List of permitted ciphers for connection encryption
# --ssl-crl 			File that contains cert revocation lists
# --ssl-crlpath 		Dir that contains cert revocation list files
# --ssl-fips-mode 	Whether to enable FIPS mode on the client side
#
# --ssl-key 			File that contains X.509 key
# --ssl-mode 			Security state of connection to server
# --status 				Display extra information about each table
# --tls-version 		Protocols permitted for enc. connections
# --user 				MySQL user name to use
# --verbose 			Verbose
# --version 			Verison info and exit
#
# --help, -? - Display a help message and exit
# --bind-address=<ip address> - On a computer having multiple network interfaces, use this to select which interface to use for connecting to the MySQL server.
# --character-sets-dir=<dir name> - The dir where char sets are installed
#
# --compress, -C - Compress all info sent between client and server if both support it
# --count - Show number of rows per table. Can be slow for non-MyISAM tables.
# --debug[=<debug options>], - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>. Defaults to d:t:o
#  -# [<debug_options>]
# --debug-check - Print some debug info when the program exits
# --debug-info - Print debbug info, memory and CPU usage stats upon exit
# --default-character-set=<charset name> - Use <charset_name> as default char set
#
# --default-auth=<plugin> - Hint about client-side auth plugin to use
# --defaults-extra-file=<file name> - Read this option file after the global option file but (on Unix) before the user option file.
# 											     Relative if relative, absolute if absolute - error raised if inaccessible or lack of perms.
# --defaults-file=<file name> - Use only said file. Still uses .mylogin.cnf - relative if relative, absolute if absolute.
# --defaults-group-suffix=<str> - Regex suffix matching
# 
# //cleartext, get-server-public-key
#
# --keys, -k - Show table indexes
# --host=<host name>, - Connect to MySQL server on the given host 
#  -h <host_name>
# --login-path=<name> - options from the named login path in the .mylogin.cnf - option group for MySQL server to connect to and which acc to auth as
# --no-defaults - Still reads .mylogin.cnf
# --password[=<password>], -p [<password>] - pw to use, normal dynamics in relation to no space 
# --pipe, -W - connect using named pipe. Only applies if named-pipe connections are supported
# --plugin-dir=<dir name> - Where to look for plugins, use if --default-auth can't find
#
# --port=<port num>, -P <port_num> - TCP/IP port to use for connection
# --print-defaults - Print the program name and all options that it gets from option files.
# --protocol={TCP|SOCKET|PIPE|MEMORY} - The protocol to use for the connection
# --secure-auth - REMOVED
# --server-public-key-path=<file name> - Path name to a file containing a client-side copy of the public key required by the server for RSA key pair
# 													  exchange. Must be PEM, applies to sha256_password or caching_sha2_password auth plugin.
#
# 													  Ignored for accounts that do not authenticate with said things. Also ignored if 
# 													  RSA-based PW exchange is not used.
#
# 													  If --server-public-key-path=<file name> is given and specifies a valid public key - it takes precedene over
# 													  --get-server-public-key
#
# 													  For sha256_password, this applies only if MySQL was built using OpenSSL.
#
# --shared-memory-base-name=<name> 		  On Windows, shared-memory name to use for connections made using shared memory to a local server.
# 													  Defaults to MYSQL - case-sensitive. Must be started with --shared-memory to enable shared-memory connections
#
# --show-table-type, -t 					  Show a column indicating the table type - as in SHOW FULL TABLES. The type is BASE TABLE or VIEW.
#
# --socket=<path>, -S <path> 				  For connections to localhost, the Unix socket file to use or on Windows the named pipe to use
#
# --ssl* 										  Options that begin with --ssl specify whether to connect to the server using SSL and indicate where to find SSL keys and certs.
#
# --ssl-fips-mode={OFF|ON|STRICT} 		  etc.
#
# --status, -i 								  Display extra info about each table
# --tls-version=<protocol list> 			  Protocols allowed for secure connections
# --user=<user name>, -u <user_name> 	  The MySQL user name to use when connecting to the server
# --verbose, -v 								  Verbose mode, stacks
# --version, -V 								  Display version info and exit
#
# The following covers mysqlslap , used for diagnostics to emulate client load for a MySQL Server and to report timing of each stage.
#
# The interaction is emulating as if multiple clients are accessing the server.
#
# mysqlslap [<options>]
#
# Some options such as --create or --query enables you to specify a string containing an SQL statement or a file containing statements.
# If it specifies a file - it must contain one statement per line. (Implicit delimiter is \n)
#
# Use the --delimiter to specify a different delimiter - which allows us to span multiple lines or place multiple statements on a single line.
# Comments cannot be included in terms of mysqlslap
#
# It runs in three stages:
#
# Create schema, table and optionally any stored programs or data to use for the test. This stage uses a single client connection
# 
# Run the load test. Can use many client connections
#
# Clean up (disconnect, drop table if specified) - uses a single client connection
#
# An example of 50 clients, 200 selects for each - created query integrated:
#
# mysqlslap --delimiter=";" 
#   --create="CREATE TABLE a (b int);INSERT INTO a VALUES (23)"
#   --query="SELECT * FROM a" --concurrency=50 --iterations=200
#
# Let mysqlslap build the query SQL statements with a table of two INT and Three VARCHAR columns.
# Use five clients querying 20 times each. 
#
# Do not create the table or insert the data (that is - use previous test's schema and data):
#
# mysqlslap --concurrency=5 --iterations=20 #5 clients, 20 times each
#   --number-int-cols=2 --number-char-cols=3 #2 int, 3 char
#   --auto-generate-sql #Auto build the query statements
#
# Tell the program to load the create, insert and query SQL statements from the specified files - where the
# create.sql has multiple table creation statements delimited by ';' and multiple insert statements delimited by
# ';'
#
# In this instance, the Query file has multiple queries delimited by ';'. Run all of em, then run all
# the queries in the query file with five clients (five times each):
#
# mysqlslap --concurrency=5
#   --iterations=5 --query=query.sql --create=create.sql
#   --delimiter=";"
#
# mysqlslap supports the following options - which can be specified on the cmd line or in the [mysqlslap] and [client]
# groups of an option file.
#
# Format 										Desc
# --auto-generate-sql 			Generate SQL statements automatically when they are not supplied in files or using command options
# --auto-generate-sql 			Add AUTO_INCREMENT column to automatically generated tables
#  -add-autoincrement
# --auto-generate-sql-/[execute-number, guild-primary, load-type, secondary-indexes, unique-query-number, unique-write-number, write-number]
# 										
# 										Number of queries/GUID based primary key to auto generate tables/Test load type
# 										Number of secondary indexes to add to automated generated tables/
# 									   Number of unique queries for automated tests/
# 										Number of unique queries for --auto-generate-sql-write-number/
# 										Number of row inserts to perform on each thread
# --commit 							Number of statements to execute before committing
# --compress 						Compression of info between client and server
#
# --concurrency 					Number of clients to simulate when issuing the SELECT statement
# --create 							File or string containing the statement to use for creating the table
# --create-schema 				Schema in which to run the tests
# --csv 								Generate output in comma-separated values format
# --debug 							Write debugging log
#
# --debug-check 					Print debugging information when program exits
# --debug-info 					Print debugging information, memory and CPU stats when exiting
# --default-auth 					Auth plugin to use
# --defaults-extra-file 		Read named option file in addition to usual option files
# --defaults-file 				Read only named option file
#
# --defaults-group-suffix 		Option group suffix value
# --delimiter 						Delimiter to use in SQL statements
# --detach 							Detach (close and reopen) each connection after each <N> statements
# --enable-cleartext-plugin 	Enable cleartext auth plugin
#
# --engine 							Storage engine to use for creating the table
# --get-server-public-key 		Request RSA public key from server
# --help 							Display help msg and exit
# --host 							Connect to MySQL servers or given host
# --iterations 					Number of times to run the tests
# --login-path 					Read login path options from .mylogin.cnf
# --no-defaults 					Read no option files
# --no-drop 						Do not drop any schema created during the test run
#
# --number-char-cols 			Number of VARCHAR columns to use if --auto-generate-sql is specified
# --number-int-cols 				Number of INT columns to use if --auto-generate-sql is specified
# --number-of-queries 			Limit each client to approx this number of queries
# --only-print 					Do not connect to databases, mysqlslap only prints what it would have done
# --password 						Password to use when connecting to server
# --pipe 							On Windows, connect to server using named pipe
#
# --plugin-dir 					Dir where plugins are installed
# --port 							TCP/IP port number for connection
# --post-query 					File or string containing the statement to execute after the tests have completed
# --pre-query 						File or string containing the statements to execute before running the tests
# --pre-system 					String to execute using system() before running the tests
# --print-defaults 				Print default options
# --protocol 						Connection protocol to use
#
# --query 							File or string containing the SELECT statement to use for retrieving data
# --secure-auth 					REMOVED
# --server-public-key-path 	Path name to file containing RSA public key
# --shared-memory-base-name 	The name of shared memory to use for shared-memory connections
# --silent 							Silent mode
# --socket 							For connections to localhost, the Unix socket file to use
#
# --sql-mode 						Set SQL mode for client session
# --ssl-ca 							File that contains list of trusted SSL cert auths
# --ssl-capath 					Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 						File that contains X.509 cert
# --ssl-cipher 					List of permitted ciphers for connection encryption
# --ssl-crl 						File that contains cert revocation lists
# --ssl-fips-mode 				Enabling fips mode on client side
#
# --ssl-key 						File that contains X.509 key
# --ssl-mode 						Security state of connection to server
# --tls-version 					Protocols permitted for encrypted connections
# --user 							MySQL user name to use when connecting to server
# --verbose 						Verbose mode
# --version 						Display version info and exit
#
# --help, -? - Display help and exit
# --auto-generate-sql, -a - Generate SQL statements automatically when they are not supplied in files or using command options
# --auto-generate-sql-add-autoincrement - Add an AUTO_INCREMENT column to automatically generated tables
# --auto-generate-sql-execute-number=<N> - Specifies how many queries to generate automatically
#
# --auto-generate-sql-guid-primary - Add a GUID based primary key to automatically generated tables
# --auto-generate-sql-load-type=<type> - Specify the test load type. The permissible values are:
#
# 													  read - Scans tables
# 													  write - Inserts into tables
# 													  key - Read primary keys
# 													  update - update primary keys
# 													  mixed - half inserts, half scanning selects.
#
# 													  Defaults to mixed.
#
# --auto-generate-sql-secondary-indexes= - Specifies how many secondary indexes to add to automatically generated tables. Defaults to none.
#  <N>
# --auto-generate-sql-unique-query-number= - How many different queries to generate for automatic tests. For example - if you run a key
#  <N> 													test that performs 1000 selects - you can use this option with a value of 1000 to run 1000 unique Queries.
#  													   Defaults to 10.
#
# --auto-generate-sql-unique-write-number= - How many different queries to generate for --auto-generate-sql-write-number. Defaults to 10.
#  <N>
# --auto-generate-sql-write-number=<N> 	 - How many row inserts to perform. Defaults to 100.
# --commit=<N> 									 - How many statements to execute before committing. Defaults to 0.
# --compress, -C 									 - Compress all info sent between client and server, if both support compression.
# --concurrency=<N>, -c <N> 					 - Number of parallel clients to simulate
# --create=<value> 								 - File or string containing statement to use for creating the table
# --create-schema=<value> 						 - The schema in which to run the tests. If --auto-generate-sql is also denoted - mysqlslap drops the schema
# 															at the end of the test run.
#
# 															To avoid - use --no-drop as well.
# --csv[=<file name>] 							 - Generate output in comma separated values format. Output goes to named file - or to STD out if no file
# --debug[=<debug options>], 					 - Write a debug log. A typical <debug_options> is d:t:o, <file_name> - defaults to d:t:o, /tmp/mysqlslap.trace
#  -# [<debug_options>]
# --debug-check 									 - Print some debug info when the program exits
# --debug-info, -T 								 - Print debug info, memory and CPU usage stats when exiting.
# --default-auth=<plugin> 						 - A hint about the client side auth plugin to use
# --defaults-extra-file= 						 - Read this option file after the global option file but (on Unix) before the user option file. 
#   <file name>  										If it does not exist/not found - error is thrown. Relative path is interpreted, absolute as absolute
# --defaults-file= 								 - Use only the given option file. relative if relative, absolute if absolute.
#   <file name> 										Still reads .mylogin.cnf
# --defaults-group-suffix 						 - Read not only the usual option groups - but also the regex suffix
#   =<str>
# --delimiter=<str>, 							 - Delimiter to use in the SQL statement supplied in files or using the CMD options.
#  -F <str>
# --detach=<N> 									 - Detach (close and reopen) each connection afer each <N> statements. Default is 0 (connections are not detached)
#
# --enable-cleartext-plugin 					 - Enable the mysql_clear_password cleartext auth plugin
# --engine=<engine name>, 						 - Storage engine to use for creating tables 
#  -e <engine_name>
# --get-server-public-key 						 - Request from the server the RSA public key that it uses for key pair-based PW exchange.
# 															Applies to clients that connect with caching_sha2_password Auth plugin.
#
# 															etc.
#
# --host=<host name>, 							 - Connect to the MySQL server on the given host.
#  -h <host_name>
# --iterations=<N>, 								 - Number of times to run the tests
#  -i <N>
# --login-path=<name> 							 - Read options from the named login path in the .mylogin.cnf path file.
# --no-drop 										 - Prevent mysqlslap from dropping any schema it creates during the test run.
# --no-defaults 									 - Do not read any option files. Exception is .mylogin.cnf
# --number-char-cols=<N>, 						 - Number of VARCHAR columns to use if --auto-generate-sql is specified
#  -x <N>
# --number-int-cols=<N>, 						 - Number of INT columns to use if --auto-generate-sql is specified
#  -y <N>
# --number-of-queries=<N> 						 - Limit each client to approximately this many queries. Query counting takes into account
# 															the statement delimiter. 
# 															
# 															For example - if you invoke mysqlslap as follows, the ; delimiter
# 															is recognized so that each instance of the query string counts as two queries.
# 					
# 															As a result - 5, in this case - not 10 - are inserted.
#
# 															mysqlslap --delimiter=";" --number-of-queries=10
# 																--query="use test;insert into t values(null)"
#
# --only-print 									 - Do not connect to DBs. Only prints what it would have done.
# --password[=<password>],  					 - Normal dynamics
#  -p [<password>]
# --pipe, -W 										 - Connect to the server using a named pipe. Applies only if the server supports named-pipe connections
# --plugin-dir=<dir name> 						 - The dir in which to look for plugins.
# --port=<port num>, 							 - TCP/IP port number to use for the connection
#  -P <port_num>
# --post-query=<value> 							 - File or string containing the statement to execute after the tests have completed.
# 															Execution is not counted for timing purposes.
# --post-system=<str> 							 - String to execute using system() after the tests have completed.
# 															Not counted for timing purposes.
# --pre-query=<value> 							 - File or string containing the statement to execute before running the tests.
# --pre-system=<str> 							 - The string to execute using system() before running the tests. Not counted for timing purposes
#
# --print-defaults 								 - Print the program name and all options that it gets from option files.
# --protocol={TCP|SOCKET|PIPE|MEMORY} 		 - Connection protocol to use for connecting to the server.
# --query=<value>, 								 - File or string containing the SELECT statements to use for retrieving data
#  -q <value>
# --secure-auth 									 - REMOVED
# --server-public-key-path=<file name> 	 - Path name to file containing client-side copy of the public key etc.
# --shared-memory-base-name=<name> 			 - On Windows, shared-memory name to use for connections made using shared memory to a local server.
#  														Only applies if the server supports shared-memory connections.
# --silent, -s 									 - Silent mode. No output.
# --socket=<path>, -S <path> 					 - For connections to localhost, the Unix socket file to use or on Windows - the named pipe to use.
# --sql-mode=<mode> 								 - Set the SQL mode for the client session
# --ssl* 											 - Indications of where to find certs, keys and wether to connect with SSL
# --ssl-fips-mode={OFF|ON|STRICT} 			 - Wether to enable FIPS mode on the client side.
# --tls-version=<protocol list> 				 - The protocols permitted by the client for encrypted connections.
# --user=<user name>, 							 - The MySQL user name to use when connecting to the server
#  -u <user_name>
#
# --verbose, -v 									 - Verbose mode. Stacks.
# --version, -V 									 - Display version info and exit.
#
# The following section covers Administrative and Utility programs
#
# The following pertains to ibd2sdi - InnoDB Tablespace SDI Extraction Utility
#
# ibd2sdi is a utility for extracting serialized dictionary information (SDI) from InnoDB tablespace files.
# SDI data is present all persistent InnoDB tablespace files.
#
# ----------------------------------------------
# SDI:
#
# Dictionary object metadata in a serialized form. SDI is stored in JSON format.
#
# >= 8.0.3, SDI is present in all InnoDB tablespace files except for temp tablespace and undo tablespace files.
# The presence of SDI in tablespace files provides metadata redundancy. For example - dictionary object metadata
# can be extracted from tablespace files using the ib2sdi utility if the data dictionary becomes unavailable.
#
# For a MyISAM table, SDI is stored in a .sdi metadata file in the schema dir. 
# An SDI metadata file is required to perform an IMPORT TABLE operation.
# 															
# ----------------------------------------------
#
# ibd2sdi can be run on:
# file-per-table tablespace files (*.ibd files), 
# general tablespace files (*.ibd files),
# system tablespace files (ibdata* files),
# data dict tablespace (mysql.ibd) 
#
# It is not supported for use with temp tablespaces or undo tablespaces.
#
# ib2sdi can be used at runtime or while the server is offline. 
# During DDL operations, ROLLBACK operations, and to undo log purge operations related to SDI.  
# There may be a short interval of time when ibd2sdi fails to read SDI data stored in the tablespace.
#
# ibd2sdi performs an uncommitted read of SDI from the specified tablespace. Redo logs and undo logs are not accessed.
# To invoke the ibd2sdi:
#
# ib2sdi [<options>] <file_name1> [<file_name2> <file_name3> ...]
#
# ibd2sdi supports multi-file tablespaces like the InnoDB system tablespace - but it cannot be run on more
# than one tablespace at a time.
#
# For multi-file tablespaces:
#
# ibd2sdi <ibdata1 ibdata2>
#
# The files of a multi-file tablespace must be specified in order of the ascending page number.
# If two successive files have the same space ID - the later file must start with the 
# last page number of the previous file + 1.
#
# ibd2sdi outputs SDI (containing id, type and data fields) in JSON format.
#
# ibd2sdi Options
#
# ibd2sdi supports the following options:
#
# --help, -h
#
# ibd2sdi --help
# USAGE: 	/ibd2sdi [-v] [-c <strict-check>] [-d <dump file name>] [-n] <filename1> [<filenames>]
# See http://dev.mysql.com/doc/refman/8.0/en/ibd2sdi.html for usage hints:
#
# -h, --help - Display help and exit
# -v, --version - Display version info and exit
# -#, --debug[=<name>] - Output debug log. see -> http://dev.mysql.com/doc/refman/8.0/en/dbug-package.html
# -d, --dump-file=<name> - Dump the tablespace SDI into the file passed by user.
# 									Without the filename, it will default to stdout
# -s, --skip-data - Skip retrieving data from SDI records. Retrieve only id and type
# -i, --id=<#> - Retrieve the SDI record matching the id passed by user
# -t, --type=<#> - Retrieve the SDI records matching the type passed by user
# -c, --strict-check=<name>
# 		Specify the strict checksum algo by the user.
# 		Allowed values are innodb, crc32, none
# -n, --no-check - Ignore the checksum verification
# -p, --pretty - Pretty format the SDI output. 
#     If false, SDI would be not human readable but it will be of less size
# 		(Defaults to on;  use --skip-pretty to disable)
#
# Variables (--variable-name=<value>) and boolean options {FALSE|TRUE} 
# debug 			(NO DEFAULT)
# dump-file 	(NO DEFAULT)
# skip-data 	FALSE
# id 				0
# type 			0
# strict-check crc32
# no-check 		FALSE
# pretty 		TRUE
#
# --version, -v - Displays MySQL version info. 
#
#  ibd2sdi --version
#  ibd2sdi Ver 8.0.3-dmr for Linux on x86_64 (Source distri)
#
# --debubg[=<debug options>], - Prints a debug log.
#  -# [<debug_options>]
#  
# 	ibd2sdi --debug=d:t /tmp/ibd2sdi.trace
#
# --dump-file=, -d - Dumps serialized dictionary info (SDI) into the specified dump file. 
#   If a dump file is not specified, the  tablespace SDI is dumped to stdout.
#
#   ibd2sdi --dump-file=<file_name>  ../data/test/t1.ibd
# 
# --skip-data, -s - Skip retrieval of data field values from the serialized dictionary information (SDI) and only
#                   retrieves ID, type field values - which are primary keys for SDI records.
#
# 						  ibd2sdi --skip-data ../data/test/t1.ibd
# 						  ["ibd2sdi"
#
# 						  {
# 								"type": 1,
# 							   "id": 330
# 						  }
# 						  ,
# 						  {
# 								"type": 2,
# 								"id": 7
# 						  }
# 						  ]
#
# --id=#, -i #
# 
# 	Retrieves SDI matching the specified table or tablespace object id. 
#  An object id is unique to the object type.
#
#  Table and tablespace object id's are also found in the id column of the mysql.tables and
#  mysql.tablespace data dir tables.
#
#  ibd2sdi --id=7 ../data/test/t1.ibd
#  ["ibd2sdi"
#  ,
#  {
# 		"type": 2,
# 		"id": 7,
# 		"object":
# 			{
# 		"mysqld_version_id": 80003,
# 		"dd_version": 80003,
# 		"sdi_version": 1,
# 		"dd_object_type": "Tablespace",
# 		"dd_object": {
# 			"name": "test/t1",
# 			"comment": "",
# 			"options": "",
# 			"se_private_data": "flags=16417;id=2;server_version=80003;space_version=1;"
# 			"engine": "InnoDB",
# 			"files": [
# 				{
# 					"ordinal_position": 1,
# 					"filename": "./test/t1.ibd",
# 					"se_private_data": "id=2;"
# 				}
# 			]
# 		}
#  }
#  }
#  ]
#
# --type=#, -t # - Retrieves SDI matching the specified object type. SDI is provided for table (type=1) and tablespace (type=2) objects:
# 
# ibd2sdi --type=2 ../data/test/t1.ibd
# ["ibd2sdi"
# ,
# {
# 		"type": 2,
# 		"id": 7,
# 		"object":
# 			{
# 		"mysqld_version_id": 80003,
# 		"dd_version": 80003,
# 		"sdi_version": 1,
# 		"dd_object_type": "Tablespace",
# 		"dd_object": {
# 			"name": "test/t1",
# 			"comment": "",
# 			"options": "",
# 			"se_private_data": "flags=16417;id=2;server_version=80003;space_version=1;"
# 			"engine": "InnoDB",
# 			"files": [
# 				{
# 					"ordinal_position": 1,
# 					"filename": "./test/t1.ibd",
# 					"se_private_data": "id=2;"
# 				}
# 			]
# 		}
# }
# }
# ]
#
# --strict-check, -c - Specifies a strict checksum algo for validating the checksum of pages that are read.
#   Options include innodb, crc32 and none.
#
# Strict of innodb - ibd2sdi --strict-check=innodb ../data/test/t1.ibd
# 
# Strict of crc32 - ibd2sdi -c crc32 ../data/test/t1.ibd
#
# If --strict-check is not specified, validation is performed against non-strict innodb, crc32 and none.
#
# --no-check, -n - Skip checksum validation for pages that are read - ibd2sdi --no-check ../data/test/t1.ibd
#
# --pretty, -p - Outputs SDI in JSON pretty print format. Enabled by default. 
#   If disabled, SDI is not human readable but is smaller in size. Use --skip-pretty to disable
# 
#   ibd2sdi --skip-pretty ../data/test/t1.ibd
#
# The following covers innochecksum - Offline InnoDB File Checksum Utility
#
# Innochecksum prints checksums for InnoDB files. 
#
# This tool reads an InnoDB tablespace file, calculates the checksum for each page, 
# compares the calculated checksum to the stored checksum and reports mismatches, 
# which indicate damaged pages.
#
# Originally developed to speed up verifying the integrity of tablespace files after power
# outages but can also be used after file copies.
#
# Because checksum mismatches cause InnoDB to deliberately shut down a running server,
# it may be preferable to use this tool rather than waiting for an in-production server to encounter the damaged pages.
#
# Innochecksum cannot be used on tablespace files that the server already has open.
# For such files, you should use CHECK TABLE to check tables within the tablespace.
#
# Attempting to run innochecksum on a tablespace that the server already has open will
# result in an "Unable to lock file" error.
#
# If checksum mismatches are found - you would normally restore the tablespace from backup
# or start the server and attempt to use mysqldump to make a backup of the tables within the tablespace.
#
# innochecksum [<options>] <file_name>
#
# innochecksum supports the following options. For options that refer to page numbers, the numbers are zero-based:
#
# --help, -? 
# innochecksum --help
#
# --info, -I
# Synonym for --help. Displays command line help.
# innochecksum --info
#
# --version, -V
# Displays version info
# innochecksum --version
#
# --verbose, -v
# Verbose mode; prints progress indicator to log file every five seconds. 
# 
# innochecksum --verbose - Verbose mode on
#
# innochecksum --verbose=FALSE - Verbose mode off
#
# --verbose and --log can be specified at the same time:
#
# innochecksum --verbose --log=/var/lib/mysql/test/logtest.txt
#
# To locate the progress indicator info in the log file - you can preform the following search:
#
# cat ./logtest.txt | grep -i "okay"
#
# Prints lines simply put of status, progress, etc.
#
# --count, -c - Prints a count of the number of pages in the file and exit.
# innochecksum --count ../data/test/tab1.ibd
#
# --start-page=<num>, -s <num> - Starts at this page number:
#
#  innochecksum --start-page=600 ../data/test/tab1.ibd
#
#  innochecksum -s 600 ../data/test/tab1.ibd
#
# --end-page=<num>, - End at this page number
#  -e <num>
# 							 --end-page=700 ../data/test/tab1.ibd
#
# 							 --p 700 ../data/test/tab1.ibd
# 
# --page=<num>, -p <num> - Check only this page number.
# 									innochecksum --page=701 ../data/test/tab1.ibd
#
# --strict-check, -C - Specify a strict checksum algo. Options include innodb, crc32 and none.
#
# 							  innochecksum --strict-check=innodb ../data/test/tab1.ibd #use innodb checksum
#
# 							  innochecksum -C crc32 ../data/test/tab1.ibd
#
# 							  The following conditions apply:
#
# 							  If you do not specify --strict-check - innochecksum validates against innodb, crc32 and none.
#
# 							  If none: only checksums generated by none are allowed
# 							  If innodb: only checksums generated by innodb are allowed
# 							  If crc32: only checksums generated by crc32 are allowed
#
# --no-check, -n - Ignore the checksum verification when rewriting a checksum. This option may only be used with the innochecksum
# 						 --write option. If the --write option is not specified - innochecksum will terminate.
#
# 						 Example of innodb checksum rewritten to replace invalid checksum:
#
# 						 innochecksum --no-check --write innodb ../data/test/tab1.ibd
#
# --allow-mismatches, - The max number of checksum mismatches allowed before innochecksum terminates.
#  -a 						Defaults to 0. If --allow-mismatches=<N>, where N>=0 - N mismatches are permitted and innochecksum terminates at N+1.
#
# 								When --allow-mismatches is set to 0, innochecksum terminates on the first checksum mismatch.
#
# 								In this example, an existing innodb checksum is written to set --allow-mismatches to 1.
#
# 								innochecksum --allow-mismatches=1 --write innodb ../data/test/tab1.ibd
#
# 								With --allow-mismatches set to 1, if there is a mismatch at page 600 and another at page 700 out of 1k pages
#
# 								If a mismatch at 600 and 700, it's updated for 0-599 - and 601-699 - terminates at second.
# 								Leaves 600 and 700-999 unchanged
#
# --write=<name>, 	 - Rewrite a checksum. When rewriting an invalid checksum, the --no-check option must be used together with
# 								the --write option.
#
# 								The --no-check option tells innochecksum to ignore verification of the invalid checksum.
# 								You do not have to specify the --no-check option if the current checksum is valid.
#
# 								An Algo must be specified when using the --write option. Possible values are:
#
# 								innodb - Checksum calculated in software, using the original algo from InnoDB
# 								crc32 - Checksum calculated using the crc32, possibly done with a hardware assist
# 								none - A constant number
#
# 								The --write option rewrites entire pages to disk. If the new checksum is identical to the existing
# 								checksum, the new checksum is not written to disk in order to minimize I/O.
#
# 								innochecksum obtains an exclusive lock when the --write option is used.
#
# 								In this example, a crc32 checksum is written for tab1.ibd:
#
# 								innochecksum -w crc32 ../data/test/tab1.ibd
#
# 								Here, we replace the invalid crc32 checksum:
#
# 								innochecksum --no-check --write crc32 ../data/test/tab1.ibd
#
# --page-type-summary, - Display a count of each page type in a tablespace. Example:
#  -S 						 innochecksum --page-type-summary ../data/test/tab1.ibd
#
# 								 Sample output for --page-type-summary:
#
# 								 File::./data/test/tab1.ibd
# 								 ====================PAGE TYPE SUMMARY===================
# 								 #PAGE_COUNT PAGE_TYPE
# 								 ========================================================
# 								 		2 		 Index page
# 										0      Undo log page
# 										1 		 Incode page
# 										0 		 Insert buffer free list page
# 										2 		 Freshly allocated page
# 										1 		 Insert buffer bitmap
# 									   0 		 System page
# 										0 		 Transaction system page
# 										1 		 File Space Header
# 										0 		 Extent descriptor page
# 										0 		 BLOB page
# 										0 		 Compressed BLOB page
# 									   0 		 Other type of page
# 								 =========================================================
# 								 Additional information:
# 								 Undo page type: 0 insert, 0 update, 0 other
# 								 Undo page state: 0 active, 0 cached, 0 to_free, 0 to_purge, 0 prepared, 0 other
#
# --page-type-dump,   - Dump the page type info for each page in a tablespace to stderr or stdout. Example:
#  -D 						innochecksum --page-type-dump=/tmp/a.txt ../data/test/tab1.ibd
#
# --log, -l 			 - Log output for the innochecksum tool. A log file name must be provided.
# 								Log output contains checksum values for each tablespace page.
#
# 								For uncompressed tables, LSN values are also provided. The --log replaces the --debug option,
# 								which was available in earlier releases. Example usage:
#
# 								innochecksum --log=/tmp/log.txt ../data/test/tab1.ibd
#
# 								innochecksum -l /tmp/log.txt ../data/test/tab1.ibd
#
# - Option
# Specify this to read from STD input.
# 								Specify the - option to read from STD input. 
# 								
# 								If the - option is missing when "read from standard in" is expected
# 								innochecksum will output innochecksum usage information indicating that the
# 								"-" option was omitted. Examples of usage:
#
# 								cat t1.ibd | innochecksum -
#
# 								In this example, innochecksum writes the crc32 checksum algorithm to a.ibd without
# 								changing the original t1.ibd file.
#
# 								cat t1.ibd | innochecksum --write=crc32 - > a.ibd
#
# The following section covers the case of running innochecksum on Multiple User-defined Tablespace files
#
# User defined tablespace files are denoted (.ibd)
#
# The following examples demonstrate how to run innochecksum on multiple user-defined tablespace files
#
# innochecksum ./data/test/*.ibd #Run innochecksum for all tablespace (.ibd) files in a DB called "test"
#
# innochecksum ./data/test/t*.ibd #Run innochecksum for all tablespace files (.ibd files) that start with t
#
# innochecksum ./data/*/*.ibd #Run innochecksum for all tablespace files (.ibd files) in the data dir
#
# Running innochecksum on multiple user-defined tablespace files is not supported on Windows OS, as Windows shells
# such as cmd.exe do not support glob pattern expansion.
#
# On Windows systems, innochecksum must be run separately for each user-defined tablespace file.
# 
# cmd> innochecksum.exe t1.ibd
# cmd> innochecksum.exe t2.ibd
# cmd> innochecksum.exe t3.ibd
#
# The following section covers innochecksum on Multiple System Tablespace Files
#
# By default - there is only one InnoDB system tablespace file (ibdata1) but multiple files for the system
# tablespace can be defined using the innodb data file path option.
#
# In the following example, three files for the system tablespace are defined using the innodb data file path option:
# ibdata1, ibdata2 and ibdata3
#
# ./bin/mysqld --no-defaults --innodb-data-file-path="ibdata1:10M;ibdata2:10M;ibdata3:10M:autoextend"
#
# The three above files form a logical system tablespace.
#
# To run innochecksum on multiple files that form one logical system tablespace - innochecksum requires the
# - option to read the tablespace file from Standard input - which equates to concatenating multiples files to creating one.
#
# To run the above, we would use:
#
# cat ibdata* | innochecksum -
#
# Windows CMD shell does not support globbing patterns - thus each file must be run seperately.
#
# The following covers myisam_ftdump - Used to display Full-Text Index information:
#
# myisam_ftdump displays info about FULLTEXT indexes in MyISAM tables.
# It reads MyISAM index files directly - so it must be run on the server host where the table is located.
#
# Before using myisam_ftdump, be sure to issue a FLUSH TABLES statement first if the server is running.
#
# myisam_ftdump scans and dumps the entire index - which is not fast. Does not need to be run often, however.
#
# To invoke the myisam_ftdump:
#
# myisam_ftdump [<options>] <tbl_name> <index_num>
#
# We can also specify the table name by naming its index file (a file with .MYI suffix).
#
# If we do not invoke the myisam_ftdump in the dir where the table files are located - the table
# or index file name must be preceded by the path name to the table's DB dir.
#
# Index numbers begin with 0.
#
# Assume the base of:
#
# CREATE TABLE mytexttable
# (
# 	 id 	INT NOT NULL, #Index 0
#   txt  TEXT NOT NULL, #Index 1
#   PRIMARY KEY (id),
#   FULLTEXT (txt)
# ) ENGINE=MyISAM;
#
# If the cwd is test DB dir, invoke myisam_ftdump:
#
# myisam_ftdump mytexttable 1
#
# If our path name to the test DB dir is /usr/local/mysql/data/test - you can also specify the table
# name arg using that path name.
#
# myisam_ftdump /usr/local/mysql/data/test/mytexttable 1
#
# We can also use myisam_ftdump to generate a list of index entries in order of frequency of occurence
# on Unix systems:
#
# myisam_ftdump -c mytexttable 1 | sort -r #-c is count, pipe the output and sort it - -r here is Recursive calling
#
# On Windows, can use:
#
# myisam_ftdump -c mytexttable 1 | sort /R - same as above, except /R is Recursive interaction on Windows
#
# The following options are supported by myisam_ftdump:
#
# --help, -h -? - Display a help message and exit
#
# --count, -c - Calculate per-word stats (counts and global weights)
#
# --dump, -d - Dump the index, include data offset and word weights
#
# --length, -l - Report length distribution
#
# --stats, -s - Report global index stats. Default operation if not other operation is specified
#
# --verbose, -v - Verbose. 
#
# The following section covers - myisamchk - a MyISAM Table-Maintenance Utility
#
# The myisamchk utility gets information about the DB, checks, repairs or optimizes them.
#
# myisamchk works with MyISAM tables (tables with .MYD and .MYI files for storing data and indexes)
#  
# We can also use the CHECK TABLE and REPAIR TABLE to check and repair MyISAM tables.
#
# NOTE: Not supported for partitioned tables, have backups in case of Errors.
#
# General syntax of myisamchk:
#
# myisamchk [<options>] <tbl_name> ...
#
# myisamchk defaults to checking tables - to get more info or correct tables - specify options.
#
# Path of file is relative if relative, Absolute if Absolute
#
# myisamchk *.MYI #Checks all files in CWD
#
# Absolute path check:
#
# myisamchk /path/to/database_dir/*.MYI
#
# * wildcarding is also allowed for Folders.
#
# An example of running a fast check on all MyISAM tables:
#
# myisamchk --silent --fast /path/to/datadir/*/*.MYI
#
# An example of repairing any corrupt tables and checking:
#
# myisamchk --silent --force --fast --update-state \
# 	  --key_buffer_size=64M --myisam_sort_buffer_size=64M \
# 	  --read_buffer_size=1M --write_buffer_size=1M \
# 	  /path/to/datadir/*/*.MYI
#
# Assumes >= 64M memory allocation
#
# When checking tables - no other operations are to be run on them. I.e - they must be locked - or server completely dead.
#
# Otherwise, we might get:
#
# warning: Clients are using or have not closed table properly
#
# This can occur if the table has not been closed or it has been updated - Iterating over it and modifying it in this state,
# can cause corruption and loss of data in terms of MyISAM tables.
#
# If mysqld is running - you must force it to flush table modifications, to clear buffered memory with FLUSH TABLES.
# 
# We could also just use CHECK TABLE to check tables.
#
# myisamchk supports the following options - can be specified on CMD or in the [myisamchk] group of an option file.
#
# FORMAT 					DESC
# --analyze 				Analyze the distribution of key values
# --backup 					Make a backup of the .MYD file as file_name-time.BAK
# --block-search 			Find the record that a block at the given offset belongs to
# --check 					Check the table for errors
# --check-only-changed 	Check only tables that have changed since the last check
#
# --correct-checksum 	Correct the checksum information for the table
# --data-file-length 	Maximum length of the data file (when re-creating data file when it is full)
# --debug 					Write debugging log
# --decode_bits 			?
#
# --defaults-extra-file Read named option file in addition to usual option files
# --defaults-file 		Read only named option file
# --defaults-group 		Option group suffix value
#  -suffix 
# --description 			Print some descriptive info about the table
# --extend-check 			Do very thorough table check or repair that tries to recover every possible row from the data file
# 
# --fast 					Check only tables that have not been closed properly
# --force 					Do a repair operation automatically if myisamchk finds any errors in the table
# --force 					Overwrite old temporary files. For use with the -r or -o option
# --ft_max_word_len 		Max word length for FULLTEXT indexes
# --ft_min_word_len 		Min word length for FULLTEXT indexes
# --ft_stopword_file 	Use stopwords from this file instead of built-in list
# --HELP/--help 					Display help message and exit
# 
# --information 			Print info stats about the table that is checked
# --key_buffer_size 		Size of buffer used for index blocks for MyISAM tables
# --keys-used 				A bit-value that indicates which indexes to update
# --max-record-length 	Skip rows larger than the given length if myisamchk cannot allocate memory to hold them
# --medium-check 			Do a check that is faster than an --extend-check operation
#
# --myisam_block_size 	Block size to be used for MyISAM index pages
# --myisam_sort_ 			The buffer that is allocated when sorting the index when doing a REPAIR or when creating indexes with CREATE INDEX or ALTER TABLE
#  buffer_size
# --no-defaults 			Read no option files
# --parallel-recover 	Same as -r and -n, but creates all keys in parallel using different threads
# --print-defaults 		Print default options
# --quick 					Achieve a faster repair by not modifying the data file
# --read_buffer_size 	Each thread that does a sequential scan allocates a buffer of this size for each table it scans
#
# --read-only 				Do not mark the table as checked
# --recover 				Do a repair that can fix almost any problem except unique keys that are not unique
# --safe-recover 			Do a repair using a old recovery method that reads through all rows in order and updates all index trees based on the rows found
# --set-auto-increment 	Force AUTO_INCREMENT numbering for new records to start at the given value
# --set-collation 		Specify the collation to use for sorting table indexes
# --silent 					Silent mode
# --sort_buffer_size 	The buffer that is allocated when sorting the index when doing a REPAIR or when creating indexes with CREATE INDEX or ALTER TABLE
# --sort-index 			Sort the index tree blocks in high-low order
# --sort_key_blocks 		?
#
# --sort-records 			Sort records according to a particular index
# --sort-recover 			Force myisamchk to use sorting to resolve the keys even if the temporary files would be very large
# --stats_method 			Specifies how MyISAM index stats collection code should treat NULLs
# --tmpdir 					Dir to be used for storing temp files
# --unpack 					Unpack a table that was packed with myisampack
# --update-state 			Store information in the .MYI file to indicate where the table was checked and whether the table crashed.
# --verbose 				Verbose mode
# --version 				Display version information and exit
# --write_buffer_size 	Write buffer size
#
# The following pertains to myisamchk General Options
#
# --help, -? - Display help and exit. Options are grouped by type of operation
# --HELP, -H - Displays help and exit. Presented in a single list.
# --debug=<debug options>, - Write a debugging log. Typical string is d:t:o, <file_name>. Defaults to d:t:o, /tmp/myisamchk.trace
#  -# <debug_options>
# --defaults-extra-file=<file name> - Read this option file after global option file but (On Unix) before the User option file.
# 												  Relative if relative, absolute if absolute - if cannot access file, error is thrown
# --defaults-file=<file name> - Use only the given option file. Relaive if relative, absolute if absolute - error thrown if inaccessible.
# --defaults-group-suffix - Read not only the usual option groups, but also suffix regex. Normally only reads [myisamchk]
#
# --no-defaults - Do not read any option files. .mylogin.cnf is read if exists 
# --print-defaults - Print the program name and all options that it gets from option files
# --silent, -s - Silent mode. Write output only when errors occur - stacks twice (-ss)
# --verbose, -v - Verbose mode. Prints more info about what the program does. Can be used with -d and -e. Stacks.
# --wait, -w - Instead of terminating with an error if the table is locked - wait until the table is unlocked before continuing.
# 					If you are running mysqld with external locking disabled - the table can be locked only by another myisamchk cmd
#
# We can also define the following variables with the general syntax of --var_name=value:
#
# 		Var 					 Default
# decode_bits 				 9
# ft_max_word_len 		 version-dependent
# ft_min_word_len 		 4
# ft_stopword_file 		 built-in-list
# key_buffer_size 		 523264
# myisam_block_size 		 1024
# myisam_sort_key_blocks 16
# read_buffer_size 		 262136
# sort_buffer_size 		 2097144
# sort_key_blocks 		 16
# stats_method 			 nulls_unequal
# write_buffer_size 		 262136
#
# The possible myisamchk vars and their default values can be examined with myisamchk --help:
#
# myisam_sort_buffer_size is used when the keys are repaired by sorting keys, which is the normal case when you use
# --recover. 
#
# sort_buffer_size is a deprecated synonym for myisam_sort_buffer_size
#
# key_buffer_size is used when you are checking the table with --extend-check or when the keys are repaired by inserting
# keys row by row into the table 
#
# Repairing through the key buffer is used in the following cases:
#
# You use --safe-recover
#
# The temp files needed to sort the keys would be more than twice as big as when creating the key file directly.
# This is usually the case when you have large key values for CHAR, VARCHAR or TEXT columns - because the sort operation
# needs to store the complete key values as it proceeds.
#
# If we have  a lot of tmp space and we can force myisamchk to repair by sorting - we can use the --sort-recover option.
#
# Repairing through the key buffer takes much less disk space than using sorting, but is also much slower.
#
# If we wish to have fast repairs - we can set the key_buffer_size and myisam_sort_buffer_size var to about 25%
# of our available memory.
#
# Only one of em is used at a time.
#
# myisam_block_size is the size used for index blocks.
#
# stats_method influences how NULL values are treated for index stats collection when the --analyze option is given.
# It acts like the myisam_stats_method system var.
#
# ft_min_word_len and ft_max_word_len indicate the min and max word length for FULLTEXT indexes on MyISAM tables.
# ft_stopword_file names the stopword file. 
#
# If we use myisamchk to perform an operation that modifies table indexes (such as repair or analyze), the FULLTEXT
# indexes are rebuilt using the default full-text param values for min and max word length and the stopword file unless specified otherwise.
# This can cause Queries to fail.
# 
# This can occur due to that said params are known only by the server.
# They are not stored in MyISAM index files. 
#
# To avoid the problem if you have modified the min or max word length or the stopward file in the server, specify
# the same ft_min_word_len, ft_max_word_len and ft_stopword_file values to myisamchk that we use for mysqld.
#
# For example - if we have set the min word length to 3 - we can repair a table with myisamchk as follows:
#
# myisamchk --recover --ft_min_word_len=3 <tbl_name.MYI>
#
# To ensure that myisamchk and the server uses the same values for full-text params - we can place each one in both the
# [mysqld] and [myisamchk] sections of a option file:
#
# [mysqld]
# ft_min_word_len=3
#
# [myisamchk]
# ft_min_word_len=3
#
# An alternative to using myisamchk is to use the REPAIR TABLE, ANALYZE TABLE, OPTIMIZE TABLE or ALTER TABLE.
#
# The above statements are executed by the server.
#
# The following section covers myisamchk Check options
#
# myisamchk supports the following options for table checking ops:
#
# --check, -c - Check the table for errors. Default operation if you specify no option that selects an operation type explicitly
# --check-only-changed, -C - Check only tables that have changed since the last check
# --extend-check, -e - Check the table extensively. Very slow. Extreme case usage. Can raise key_buffer_Size to help speed.
# --fast, -F - Check only tables that have not been closed properly
# --force, -f - Do a repair operation automatically if myisamchk finds any errors in the table. Same as --recover or -r
# --information, -i - Print info stats about the table that is being checked
# --medium-check, -m - Faster than --extend-check.
# --read-only, -T - Do not mark the table as checked - useful if you use myisamchk to check a table that is in use by some other app that does not use locking 
# 						  - such as mysqld when run with external locking disabled
# --update-state, -U - Store info in the .MYI file to indicate when the table was checked and whether the table crashed. Should be used to get full benefit
# 							  of the --check-only-changed option - but you should not use this option if the mysqld server is using the table and you run it with external locking off.
#
#
# The following section covers myisamchk Repair Options
#
# myisamchk supports the following options for table repair operations (operations performed when an option such as --recover or --safe-recover is given):
#
# --back, -B - Make a backup of the .MYD file as <file_name-time.BAK>
# --character-sets-dir=<dir name> - The dir where char sets are installed
# --correct-checksum - Correct the checksum info for the table
# --data-file-length=<len>, -D <len> - The max length of the data file (when re-creating data file when it is "full")
# --extend-check, -e - Do a repair that tries to recover every possible row from the data file.
# 							  Normally - this also finds a lot of garbage rows.  Extreme case usage.
# --force, -f - Overwrite old intermediate files (files with names like <tbl_name.TMD>) instead of aborting
#
# --keys-used=<val>, - For myisamchk - the option value is a bit value that indicates which indexes to update.
#  -k <val> 			  Each binary bit of the option value corresponds to a table index - where the first index is bit 0.
# 							  
# 							  An option value of 0 disables updates to all indexes, which can be used to get faster inserts.
#							  Deactivated indexes can be reactivated by using myisamchk -r.
#
# --no-symlinks, -l  - Do not follow symbolic links. Normally myisamchk repairs the table that a symlink points to. 
# 							  Deprecated past 4.0 because symlinks are not removed during repair operations.
#
# --max-record-length= - Skip rows larger than the given length if myisamchk cannot allocate memory to hold them.
#  <len>  							  
#
# --parallel-recover,  - Use the same technique as -r and -n, but create all the keys in parallel - using different threads. (beta)
#  -p 
#
# --quick, -r 			  - Achieve a faster repair by modifying only the index file - not the data file.
# 								 You can specify this option twice to force myisamchk to modify the original data file in case of duplicate keys.
#
# --recover, -r 		  - Do a repair that can fix almost any problem except unique keys that are not unique.
# 								 Use this to recover tables.
#
# 								 Data remains intact if this fails. If it fails, use --safe-recover instead.
#
# --safe-recover,  	  - Do a repair using an old recovery method that reads through all rows in order and updates all index trees
#  -o 						 based on the rows found.
#
# 								 Slower than --recover, uses less memory though.
#
# --set-collation=     - Specify the collation to use for sorting table indexes. The char set is implied by the first part of the collation name.
#  <name> 
#
# --sort-recover, 	  - Force myisamchk to use sorting to resolve the keys even if temp files would be v large
#  -n
#
# --tmpdir=<dir name>, - The path of the dir to be used for storing temp files. If not set - myisamchk uses the value of the TMPDIR env var.
#  -t <dir name> 			 --tmpdir can be set to a list of dir paths that are used successivly on rotation for creating temp files.
#								 Separation char is : on Unix, ; on Windows.
#
# --unpack, -u - Unpack a table that was packed with myisampack.
#
# The following covers myisamchk options for actions other than table checks and repairs:
#
# --analyze, -a - Analyze the distribution of key values. This improves join performance by enabling the join optimizer to better choose the order
# 						in which to join the tables and which indexes it should use.
#
# 						To obtain information about the key distribution - use a myisamchk --description --verbose <tbl name> command or
# 						the SHOW INDEX FROM <tbl_name> statement.
#
# --block-search=<offset> - Find the record that a block at the given offset belongs to.
#  -b <offset>
#
# --description, -d - Print some descriptive info about the table. Specifying the --verbose option once or twice produces more info.
#
# --set-auto-increment [=<value>], - Force AUTO_INCREMENT numbering for new records to start at the given value (or higher - if there exists
#  -A [<value>] 							 records with AUTO_INCREMENT values this large).
#
# 												 If <value> is not specified, <AUTO_INCREMENT> numbers for new records begin with the largest value in the table + 1.
#
# --sort-index, -S 	- 	Sort the index tree blocks in high-low order. Optimizes seeks and makes table scans that use indexes faster.
#
# --sort-records=<N>, - Sort records according to a particular index. This makes your data much more localized and may speed up range-based
#  -R <N> 					SELECT and ORDER BY operations that use this index.
#
# 								May be very slow at first use.
#
# 								To determine table index number - use SHOW INDEX, which displays a table's indexes in the same order
# 								that myisamchk sees them. Indexes are numbered beginning with 1.
#
# 								If keys are not packed (PACK_KEYS=0) - they have the same length - so when myisamchk sorts and moves records,
# 								it just overwrites record offsets in the index.
#
# 								If keys are packed (PACK_KEYS=1), myisamchk must unpack key blocks first - then re-create indexes and pack
# 								the key blocks again. (re-creating indexes is faster than updating offsets for each index - in this case)
#
# The following covers how to obtain table info with myisamchk:
#
# To obtain a desc of a MyISAM table or stats about it - use the commands shown here. The output from these commands is explained later in this section.
#
# myisamchk -d <tbl name> - Runs myisamchk in "describe mode" to produce a description of your table. 
# 									 If you start the MySQL server with external locking disabled - myisamchk may report an
# 									 error for a table that is updated while it runs.
#
# 									 However - because myisamchk does not change the table in describe mode - there is no risk of destroying data.
#
# myisamchk -dv <tbl name> - Adding -v runs myisamchk in verbose mode so that it produces more info about the table. Stacks.
# myisamchk -eis <tbl name> - Shows only the most important information from a table. This operation is slow because it must read the entire table.
# myisamchk -eiv <tbl name> - This is like -eis, but tells you what is being done.
#
# The <tbl_name> arg can be either the name of a MyISAM table or the name of its index file. Multiple args can be given.
# 
# Assume following table Structure:
#
# CREATE TABLE person
# (
#   id 			INT NOT NULL AUTO_INCREMENT,
# 	 last_name 	VARCHAR(20) NOT NULL,
#   first_name VARCHAR(20) NOT NULL,
#   birth 		DATE,
#   death 		DATE,
#   PRIMARY KEY  (id),
#   INDEX (last_name, first_name),
#   INDEX (birth)
# ) MAX_ROWS = 10000000 ENGINE=MYISAM;
#
# Suppose also that the table has these data and index file sizes:
# -rw-rw---- 	1 mysql 	mysql 	9347072 Aug 19 11:47 person.MYD
# -rw-rw---- 	1 mysql 	mysql 	6066176 Aug 19 11:47 person.MYI
#
# An example of myisamchk -dvv would then output:
# 
# MyISAM file: 	person
# Record format: 	Packed
# Character set: 	utf8mb4_0900_ai_ci (255)
# File-version: 	1
# Creation time: 	2017-03-30 21:21:30
# Status: 			checked, analyzed, optimized, keys, sorted index pages
# Auto increment key: 				1 	Last value: 			306688
# Data records: 				 306688 	Deleted blocks: 			  0
# Datafile parts: 			 306688 	Deleted data: 				  0
# Datafile pointer (bytes): 		4 	Keyfile pointer (bytes):  3
# Datafile length: 			9347072  Keyfile length: 	  6066176
# Max datafile length:  4294967294  Max keyfile length: 17179867159
# Recordlength: 					  54  
#
# table description:
# Key Start Len Index 	Type 					Rec/key 			Root Blocksize
# 1 	2 		4 	 unique 	long 					1 								 1024
# 2 	6 		80  multip. varchar prefix 	0 								 1024
# 		87 	80 			varchar 				0
# 3 	168 	3 	 multip. uint24 NULL 		0 								 1024
#
# Field Start Length 	Nullpos 	Nullbit 	Type
# 1 	  1 	  1 
# 2 	  2 	  4 									no zeros
# 3 	  6 	  81 									varchar
# 4 	  87 	  81 									varchar
# 5 	  168   3 				1 			1 		no zeros
# 6 	  171   3 				1 			2 		no zeros
#
# Explanations for the types of information myisamchk produces are given here. "Keyfile" refers to the index file.
# "Record" and "row" are synonymous - as are "field" and "column"
#
# The initial part of the table desc contains these values:
#
# MyISAM file - Name of the MyISAM (index) file
# Record format - The format used to store table rows. The preceding examples use Fixed length.
# 						Other possible values are Compressed and Packed. (Packed corresponds to what SHOW TABLE STATUS reports as Dynamic)
# Character set - The table default char set
# File-version  - Version of MyISAM format. Always 1.
# Creation time - When the data file was created
# Recover time  - When the index/data file was last reconstructed
# Status 		 - Table status flags. Possible values are crashed, open, changed, analyzed, optimized keys and sorted index pages.
# Auto increment key, Last value - The key number associated the table's AUTO_INCREMENT column, and most recently generated value. Does not appear if none found.
# Data records  - Number of rows in the table
# Deleted blocks - How many deleted blocks still have reserved space. can optimize tables to minimize this space.
# Datafile parts - For dynamic-row format, this indicates how many data blocks there are. For an optimized table without fragmented rows, this is the same as Data records.
# 
# Deleted data - How many bytes of unreclaimed deleted data there are. You can optimize your table to minimize this space.
# Datafile pointer - The size of the data file pointer, in bytes. Usually is 2,3,4 or 5. Most manage with 2 - cannot be controlled with MySQL.
# 							For fixed tables - this is row address. For dynamic tables, this is byte address.
# Keyfile pointer - Size of the index file pointer, in bytes. Usually 1,2 or 3. Most manage with 2 - auto calculated by MySQL. is always a block address.
# Max datafile length - How long the table data file can become, in bytes.
# Max keyfile length - How long the table index can become, in bytes.
# Recordlength - How much space each row takes, in bytes.
#
# The table desc part of the output includes a list of all keys in the table. For each key, myisamchk displays some low-level info:
#
# Key - This key's number. This value is shown only for the first column of the key. If this value is missing, the line corresponds to the
# second or later column of a multiple-column key.
#
# For the table shown in the example, there are two table description lines for the second index.
# This indicates that it is a multiple-part index with two parts.
#
# Start - Where in the row this portion of the index starts.
# Len - How long this portion of the index is. For packed numbers, this should always be the full length of the column.
# 		  For strings - it may be shorter than the full length of the indexed column - because you can index a prefix of a string column.
#
# 		  The total length of a multiple-part key is the sum of the Len values for all key parts.
# Index - Whether a key value can exist multiple times in the index. Possible values are unique or multip. (multiple)
# Type - What data type this portion of the index has. This is a MyISAM data type with the possible values packed, stripped or empty.
# Root - Address of the root index block.
# Blocksize - The size of each index block. By default is 1024, but the value may be changed at compile time when MySQL is built from source.
# Rec/key - This is a statistical value used by the optimizer. It tells how many rows there are per value for this index.
# 				A unique index always has a value of 1. This may be updated after a table is loaded (or greatly changed) with myisamchk -a.
#
# 				If this is not updated at all,a default value os 30 is given.
#
# The last part of the output provides info about each column:
#
# Field - The column number.
# Start - The byte position of the column named within table rows.
# Length - The length of the column in bytes.
# Nullpos, Nullbit - For columns that can be NULL, MyISAM stores NULL values as a flag in a byte.
# 							Depending on how many nullable columns there are, there can be one or more bytes used for this purpose.
# 							The Nullpos and Nullbit values - if nonempty, indicate which byte and bit contains that flag indicating whether the column is NULL.
#
# 							The position and number of bytes used to store NULL flags is shown in the line for field 1. This is why there are
# 							six Field lines for the person table even though it has only five columns.
#
# Type - The data type. The value may contain any of the following descriptors:
# 			constant - all rows have the same value.
# 			no endspace - Do not store endspace.
# 			no endspace, not_always - Do not store endspace and do not do endspace compression for all values
# 			no endspace, no empty - Do not store endspace. Do not store empty values
# 			table-lookup - The column was converted to an ENUM.
# 			zerofill(N) - The most significant N bytes in the value are always 0 and are not stored.
#
# 			no zeros - Do not store zeros.
# 			always zero - Zero values are stored using one bit.
#
# Huff tree - The number of the Huffman tree associated with the column.
# Bits - The number of bits used in the Huffman tree.
#
# The Huff tree and Bits fields are displayed if the table has been compressed with myisampack.
#
# an example of a myisamchk -eiv output:
#
# Checking MyISAM file: person
# Data records: 	306688 		Deleted blocks: 				0
# - check file-size
# - check record delete-chain
# No recordlinks
# - check key delete-chain
# block_size 1024:
# - check index reference
# - check data record references index: 1
# Key: 	1: 	Keyblocks used: 98% Packed: 	0% 	Max levels: 3
# - check data record references index: 2
# Key: 	2: 	Keyblocks used: 99% Packed: 	97% 	Max levels: 3
# - check data record references index: 3
# Key: 	3: 	Keyblocks used: 98% Packed: 	-14%  Max levels: 3
# Total: 		Keyblocks used: 98% Packed: 	89%
#
# - check records and index references
# *** LOTS OF ROW NUMBERS DELETED ***
#
# Records: 		  306688 	M.recordlength: 		25 Packed: 			83%
# Recordspace used: 97% 	Empty space: 			2% Blocks/Record: 1.00
# Record blocks: 306688 	Delete blocks: 		0
# Record data:  7934464 	Deleted data: 			0
# Lost space: 	  256512 	Linkdata: 		1156096
# 
# User time 43.08, System time 1.68
# Maximum resident set size 0, Integral resident set size 0
# Non-physical pagefaults 0, Physical pagefaults 0, Swaps 0
# Blocks in 0 out 7, Messages in 0 out 0, Signals 0
# Voluntary context switches 0, Involuntary context switches 0
# Maximum memory usage: 1046926 bytes (1023k)
#
# myisamchk -eiv output includes the following info:
#
# data records - Number of rows in the table
# Deleted blocks - How many deleted blocks still have reserved space. You can optimize your table to minimize this space.
# Key - The key number
# Keyblocks used - What percentage of the keyblocks are used. When a table has just been reorganized with myisamchk, the values
# 						 are very high (very near theoretical maximum)
# Packed - MySQL tries to pack key values that have a common suffix. This can only be used for indexes on CHAR and VARCHAR columns.
# 			  For long indexed strings that have similar leftmost parts - this can significantly reduce the space used.
#
# 			  In the preceeding example - the second key is 40 bytes long and a 97% reduction in space is achieved.
#
# Max levels - How deep the B-tree for this key is. Large tables with long key values get high values
# Records - How many rows are in the table.
# M.recordlength - The average row length. This is the exact row length for tables with fixed-length rows, because all rows have the same length.
# Packed - MySQL strips spaces from the end of strings. The Packed value indicates the percentage of savings achieved by doing this.
# Recordspace used - What percentage of the data file is used.
# Empty space - What percentage of the data file is unused.
# Blocks/Record - Average number of blocks per row (that is - how many links a fragmented row is compsoed of). This is always 1.0 for fixed-format tables.
#						This value should stay as close to 1.0 as possible. If it gets too large - you can reorganize the table.
# Recordblocks - How many blocks (links) are used. For fixed-format tables, this is the same as the number of rows.
# Deleteblocks - How many blocks (links) are deleted
#
# Recorddata - How many bytes in the data file are used
# Deleted data - How many bytes in the data file are deleted (unused)
# Lost space - If a row is updated to a shorter length - some space is lost. This is the sum of all such losses - in bytes.
# Linkdata - When the dynamic table format is used, row fragments are linked with pointers (4 to 7 bytes each).
# 				 Linkdata is the sum of the amount of storage used by all such pointers.
#
# The following section covers myisamchk Memory Usage:
#
# Memory allocation is important when you run myisamchk. myisamchk uses no more memory than its memory-related vars are set to.
# If you are going to use myisamchk on very large tables - you should first decide how much memory you want it to use.
#
# The default is to use about 3MB to perform repairs. By using larger values, you can get myisamchk to operate faster.
# For example, if you have more than 512MB RAM available - you could use options such as these (in addition to any other options you might specify):
#
# myisamchk --myisam_sort_buffer_size=256M \
# 						--key_buffer_size=512M   \
# 						--read_buffer_size=64M 	 \
# 						--write_buffer_size=64M ...
#
# Using --myisam_sort_buffer_size=16M is probably enough for most cases.
#
# Be aware that myisamchk uses temp files in TMPDIR. If TMPDIR points to a memory file system - out of memory
# errors can easily occur. If this happens - run myisamchk with the --tmpdir=<dir name> option to specify
# a dir located on a file system that has more space.
#
# When performing repair operations, myisamchk also needs a lot of disk space:
#
# Twice the size of the data file (the original file and copy). This space is not needed if you do a repair
# with --quick; in this case, only the index file is re-created. (This space must be available on the same file system as the original data file)
# as the copy is created in the same dir as the original.
# 
# Space for the new index file that replaces the old one. The old index file is truncated at the start of the repair operation, so you usually
# ignore this space. This space must be available on the same file system as the original data file.
#
# When using --recover or --sort-recover (but not when using --safe-recover) - you need space on disk for sorting.
# This space is allocated in the temp dir (specified by TMPDIR or --tmpdir=<dir name>). 
#
# The following formula yields the amount of space required:
#
# (largest_key + row_pointer_length) * number_of_rows * 2
#
# You can check the length of the keys and the row_pointer_length with myisamchk -dv <table name>
# The <row_pointer_length> and <number_of_rows> values are the <Datafile pointer> and <Data records> values
# in the table desc.
#
# To determine the <largest_key> value - check the Key lines in the table desc.
# The Len column indicates the number of bytes for each key part.
# For a multiple-column index, the key size is the sum of the Len values for all key parts.
#
# If disk space is an issue in relation to repairs, use --safe-recover instead of --recover
#
# The following part pertains to myisamlog - Interactions of displaying MyISAM Log File Contents
#
# myisamlog processes the contents of a MyISAM log file. To create such a file, start the server with
# a --log-isam=<log file> option.
#
# Invoke myisamlog as follows:
#
# myisamlog [<options>] [<file_name> [<tbl_name>] ...]
#
# The default operation is to update (-u).
# If a recovery is done (-r) - all writes and possibly updates and deletes are done and errors are only counted.
# The default log file name is myisam.log if no <log_file> arg is given.
#
# If tables are named on the cmd line - only those tables are updated.
#
# myisamlog supports the following options:
#
# -?, -I - display a help message and exit
# -c <N> - Execute only N amount of commands
# -f <N> - Specify the max number of open files
# -F <filepath/> - Specify the file path with a trailing slash
# -i - Display extra info before exiting
# -o <offset> - Specify the starting offset
#
# -p <N> - Removes <N> components from path
# -r - Performs a recovery operation
# -R <record_pos_file record_pos> - Specify record pos file and record pos
# -u - Perform an update operation
# -v - Verbose mode. Print more output. Stacks.
# -w <write_file> - Specify the write file
# -V - version info
#
# myisampack - Generate compressed, Read-Only MyISAM Tables
#
# The myisampack utility compresses MyISAM tables. myisampack works by compressing each column in the table separately.
# Usually, myisampack packs the data file 40% to 70%
#
# When the table is used later - the server reads into memory the info needed to decompress columns.
# This results in much better performance when accessing individual rows, because you only have to uncompress exactly one row.
#
# MySQL uses mmap() when possible to perform memory mapping on compressed tables.
# If mmap() does not work - MySQL falls back to normal read/write file operations.
#
# NOTE: 
#
# If the mysqld server was invoked with external locking disabled - it is not a good idea to invoke myisampack if the 
# table might be updated by the server during the packing process. It is better to compress tables with the server turned off.
#
# After packing a table - it becomes read only. 
#
# myisampack does not support partitioned tables.
#
# To invoke:
#
# myisampack [<options>] <file_name> ...
#
# Each file name argument should be the name of an index (.MYI) file. 
# If you are not in the DB dir, you should specify the path name to the file. 
# It is permissible to omit the .MYI extension
#
# After we compress a table with myisampack - we can use myisamchk -rq to rebuild its indexes.
# 
# 
# It also reads option files and supports the options for processing them.
#
# myisampack supports the following options: 
#
# --help, -?
# --backup, -b - Make a backup of each table's data file using the name <tbl_name>.OLD
# --character-sets-dir=<dir name> - The dir where char sets are installed.
# --debug[=<debug_options>], - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>. Defaults to d:t:o
#  -# [<debug_options>]
# --force, -f - Produce a packed table even if it becomes larger than the original or if the intermediate file from an earlier invocation
# 					 of myisampack exists.
#
# 					 myisampack creates an intermediate file named <tbl_name>.TMD in the database dir while it compresses the table.
# 					 If you kill myisampack, the .TMD file might not be deleted.
# 					 Normally, myisampack exits with an error if it finds that <tbl_name>.TMD exists.
#
# 					 With --force, myisampack packs the table anyway.
#
# --join=<big tbl name>, - Join all tables named on the cmd line into a single packed table <big_tbl_name>.
#  -j <big_tbl_name> 		All tables that are to be combined must have identical structure (same column names and types, same indexes, etc.)
# 	
# 									<big_tbl_name> must not exist prior to the join operation. All source tables named on the cmd line
# 									to be merged into <big_tbl_name> must exist. The source tables are read for the join operation but not modified.
# --silent, -s 			 - Silent mode. Writes only error outputs.
# --test, -t 				 - Do not actually pack the table, just test packing it.
# --tmpdir=<dir name>,   - Use the named dir as the location where myisampack creates temp files.
#  -T <dir_name>
# --verbose, -v 			 - Verbose. Write info about the progress of the packing ops and its result.
# --version, -V 			 - Display version info and exit
# --wait, -w 				 - Wait and retry if the table is in use. If the mysqld server was invoked with external locking disabled, it is not a good idea
# 									to invoke myisampack if the table might be updated by the server during the packing process.
#
# The following sequence of commands illustrates a typical table compression session:
#
# ls -l station
# -rw-rw-r-- 	1 monty 	my 		994128 Apr 17 19:00 station.MYD
# -rw-rw-r-- 	1 monty  my 		 53248 Apr 17 19:00 station.MYI
#
# myisamchk - dvv station
#
# MyISAM file: 		station
# Isam-version: 	2
# Creation time: 	1996-03-13 10:08:58
# Recover time:   1997-02-02 3:06:43
# Data records: 				  1192  Deleted blocks: 			  0
# Datafile parts: 			  1192  Deleted data: 			     0
# Datafile pointer (bytes): 	  2  Keyfile pointer (bytes):   2
# Max datafile length: 	 54657023  Max keyfile length: 33554431
# Recordlength: 					834
# Record format: Fixed length
#
# table description:
# Key  Start  Len  Index   Type 				Root Blocksize 	Rec/key
# 1 	 2 	  4 	 unique 	unsigned long 	1024 1024 					1
# 2 	 32 	  30 	 multip. text 			  10240 1024 					1
# 
# Field Start Length Type
# 1 	  1 	  1
# 2 	  2 	  4
# 3 	  6 	  4
# 4 	  10 	  1
# 5 	  11 	  20
# 6 	  31 	  1
# etc.
#
# myisampack station.MYI
# Compressing station.MYI: (1192 records)
# - Calculating statistics
#
# normal: 		20  empty-space: 		16 empty-zero: 		12 empty-fill:  11
# pre-space: 	 0  end-space: 		12	table-lookups: 	 5 zero: 		  7
# Original trees:  57 	After join: 17
# - Compressing file
# 87.14%
# Remember to run myisamchk -rq on compressed tables
# 
# myisamchk -rq station
# - check record delete-chain
# - recovering (with sort) MyISAM-table 'station'
# Data records: 1192
# - Fixing index 1
# - Fixing index 2
#
# mysqladmin -uroot flush-tables
#
# ls -l station
# -rw-rw-r-- 	1 monty 	my 		127874 Apr 17 19:00 station.MYD
# -rw-rw-r-- 	1 monty 	my 		 55296 Apr 17 19:04 station.MYI
#
# myisamchk -dvv station
# 
# MyISAM file: 		station
# Isam-version: 		2
# Creation time: 		1996-03-13 10:08:58
# Recover time: 		1997-04-17 19:04:26
# Data records: 					  1192 	Deleted blocks: 		    0
# Datafile parts: 				  1192 	Deleted data: 		       0
# Datafile pointer (bytes): 		  3 	Keyfile pointer (bytes): 1
#
# Max datafile length:      16777215 	Max keyfile length: 131071
# Recordlength: 						834
# Record format: Compressed
#
# table description:
# Key Start Len 	Index 	Type 			   Root 		Blocksize 	Rec/key
# 1 	2 		4 		unique 	unsigned long  10240 		1024 				1
# 2 	32 	30 	multip.  text 				54272 		1024 				1
# 
# Field Start Length Type 										Huff tree Bits
# 1 	  1 	  1 		constant 								 		  1    0
# 2 	  2 	  4 		zerofill(1) 									  2 	 9
# etc.
#
# myisampack displays the following kinds of info:
#
# normal - Number of cols for which no extra packing is used
# empty-spaces - Number of cols containing values that are only spaces. Occupies one bit.
# empty-zero - Number of cols containing values that are only binary zeros. Occupies one bit
# empty-fill - Number of integer cols that do not occupy the full byte range of their type. These are 
# 					changed to a smaller type. For example - a BIGINT column (eight bytes) can be stored
# 					as a TINYINT col (one byte) if all the values are in the range of a TINYINT (-128 to 127)
# pre-space  - Number of decimal cols that are stored with leading spaces. In this case - each value contains a count for the number of leading spaces.
# end-space  - Number of columns that have a lot of trailing space. In this case - each value contains a count for the number of trailing spaces
# table-lookup - The column had only a small number of different values, which are converted to ENUM before Huffman compression.
# zero 		 - Number of cols in which all values are zero
# Original trees - Initial number of Huffman trees.
# 
# After join - Number of distinct Huffman trees left after joining trees to save some header space.
#
# After a table has been compressed, the Field lines displayed by myisamchk -dvv include additional informaton about each col:
#
# Type - The data type. Can be one of the following:
#
# constant - Same values across all rows
# no endspace - Do not store endspace
# no endspace, not_always - Do not store endspace and do not do endspace compression for all values
# no endspace, no empty - Do not store endspace. Do not store empty values
# table-lookup - The column was converted to an ENUM.
# zerofill(<N>) - The most significant <N BYTES> in the value are always 0 and are not stored.
# no zeros - Do not store zeros
# always zero - Zero values are stored using one bit.
#
# Huff tree - Number of the Huffman tree associated with the column.
# Bits - Number of bits used in the huffman tree
#
# After you run myisampack, use myisamchk to re-create any indexes. 
# At this time, you can also sort the index blocks and create stats needed for the MySQL optimizer to work better:
#
# myisamchk -rq --sort-index --analyze <tbl_name.MYI>
#
# After you have installed the packed table into the MySQL DB dir, you should execute mysqladmin flush-tables to force
# mysqld to start using the new table.
#
# To unpack a packed table, use the --unpack option to myisamchk.
#
# The following covers mysql_config_editor - a MySQL Configuration Utility
#
# The mysql_config_editor utility enables you to store authentication creds in a obfuscated login path file named .mylogin.cnf
# 
# The file location is the %APPDATA%\MySQL directory on Windows and the current user's home dir on non-Windows systems.
# The file can be read later by MySQL client programs to obtain authentication credentials for connecting to MySQL server. 
#
# The unobfuscated format of the .mylogin.cnf login path consists of option groups, similar to other option files.
# Each option group in .mylogin.cnf is called a "login path" which is a group that permits only certain options:
#
# host, user, password, port and socket
#
# Think of a login path option group as a set of options that specify which MySQL server to connect to and which
# account to authenticate as.
#
# An unobfuscated example:
#
# [client]
# user = mydefaultname
# password = mydefaultpass
# host = 127.0.0.1
# [mypath]
# user = myothername
# password = myotherpass
# host = localhost
#
# Order of prio is: Cmd > mylogin.cnf > other option files
#
# To specify a alternative login path file name, set the MYSQL_TEST_LOGIN_FILE environment variable.
# This variable is recognized by mysql_config_editor, by standard MySQL clients and the mysql-test-run.pl testing utility.
#
# Programs use groups in the login path file as follows:
#
# mysql_config_editor operates on the client login path by default if you specify no --login-path=<name> option
# to indicate explicit pathing.
#
# Without a --login-path option - it reads the same groups from other option files as well as the loginpath file.
# i.e default groups pertaining to said command.
#
# With a --login-path option, client programs read the named login path from the login path file.
# The option groups read from other option files remain the same.
#
# mysql --login-path=<mypath>
#
# The mysql client then reads [client] and [mysql] from other option files - whilst reading [client], [mysql] and [mypath] from the login path file.
#
# Client programs read the login path file even when the --no-defaults option is used.
# 
# mysql_config_editor obfuscates the .mylogin.cnf file so it cannot be read as cleartext - and it's contents when obfuscated by client programs
# are used only in memory.
#
# In said way - a PW can be stored in a file in non-cleartext format and used later, without exposing in a Env var or cmd.
# 
# mysql_config_editor does come with a print command as to show login path file contents - but this still omits PWs.
#
# Note: .mylogin.cnf files can be unobfuscated with root privs
#
# The login path file must be readable and writable to the current user - and inaccessible to other users.
# Otherwise, mysql_config_editor ignores it and client programs do not use it either.
#
# To invoke mysql_config_editor:
#
# mysql_config_editor [<program options>] <command> [<command_options>]
#
# If the login path files does not exist - mysql_config_editor creates it.
#
# <program options> : Pertains to general mysql_config_editor options
# <command> : Pertains to what action to perform on the .mylogin.cnf login path file. 
# 				  For example - set writes a login path to the file, remove removes a login path, and print displays login path contents.
# <command_options> : Indicates any additional options specific to the command, such as the login path name and the values to use in the login path.
#
# The position of the command name within the set of program arguments is explicit.
# 
# mysql_config_editor --help set #Interprets it as "--help", ignores the set part
# mysql_config_editor set --help #Interprets it as "set --help" - as in, help command regarding set
#
# Assuming that you wish to have a client login path that defines default connection params - and a separate one for remote,,
# an example:
#
# The following will modify your .mylogin.cnf using set commands:
#
# mysql_config_editor set --login-path=client
# 		--host=localhost --user=localuser --password
# >Prompt for PW to localhost
#
# mysql_config_editor set --login-path=remote
# 		--host=remote.example.com --user=remoteuser --password
# >Prompt for PW to Remote 
#
# We can showcase groupings from the .mylogin.cnf with print --all:
#
# mysql_config_editor print --all
# [client]
# user = localuser
# password = *******
# host = localhost
# [remote]
# user = remoteuser
# password = *******
# host = remote.example.com
#
# If we omit names or --all, it prints client path by default - if there is one.
#
# The login path file can contain multiple login paths.
# A quick example of how to access remote in addition to the stnadard config ones:
#
# mysql --login-path=remote #Reads [client], [mysql] and [remote] groups form login path file
#
# Note: Groups read from later appearances - take precedence over earlier ones appearing.
#
# mysql_config_editor adds login paths to the login path file in the order we create them,
# Thus, more general ones first - more specific ones later on
#
# Ommited values can be appended in terms of specification:
# mysql --login-path=remote --host=remote2.example.com #Assuming that remote yields same login details as the remote2.example.com host, we can just redirect to that specific host
#
# The following are mysql_config_editor General options
#
# mysql_config_editor supports the following general options 
#
# --debug - Write debugging log
# --help - Display help message and exit
# --verbose - Verbose mode
# --version - Display version info and exit
#
# --help, -? - Display a general help message and exit. 
# Example: mysql_config_editor <command> --help
#
# --debug[=<debug options>], - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>.
#  -# <debug_options> 			 Defaults to d:t:o, /tmp/mysql_config_editor.trace
#
# --verbose, -v - Verbose mode.
#
# --version, -V - Display version info and exit
#
# The following covers:
# mysql_config_editor Commands and Command-Specific Options
#
# This section describes the permitted mysql_config_editor commands, and for each one - the command-specific options
# permitted following the command name on the cmd line.
#
# In addition - mysql_config_editor supports general options that can be used preceding any command.
#
# The following options are supported:
#
# help - Display a general help message and exit. This command takes no following options.
# 		
# 			To see a command-specific help message, invoke mysql_config_editor as follows, where <command> is a command other than help:
#
# 			mysql_config_editor <command> --help
# 
# print [<options>] - Print the contents of the login path file in unobfuscated form, with the exception that passwords are displayed as ****.
# 
# 							 The default login path name is <client> if no login path is named.
# 							 If both --all and --login-path are given, --all takes precedence.
#
# 							 The <print> command permits these options following the command name:
#
# 							 --help, -? - Display a help message for the <print> command and exit.
# 							 To see a general help message - use mysql_config_editor --help
# 		
# 							 --all - Print the contents of all login paths in the login path file.
# 
# 							 --login-path=<name>, -G <name> - Print the contents of the named login path.
#
# remove [<options>] - Remove a login path from the login path file - or modify a login path by removing options from it.
#
# 							  This command removes from the login path only such options as are specified with the --host, --password, --port, --socket
# 							  and --user options.
# 
# 							  	If none of the above are given - remove removes the entire login path.
#
#								mysql_config_editor remove --login-path=mypath --user #Removes the user option from login path option 
#
# 								mysql_config_editor remove --login-path=mypath #Removes the entire mypath login path
#
# 								The remove command permits these options following the cmd name:
#
# 								--help, -? - Displays a help message for the remove command and exit.
# 								
# 												 To see a general help message - use mysql_config_editor --help
#
# 								--host, -h - Remove the host name from the login path.
#
# 								--login-path=<name>, -G <name> - The login path to remove or modify. 
# 																			Default login path name is client if this option is not given.
#
#
#  							--password, -p - Removes the PW from the login path
#
# 								--port, -P - Remove the TCP/IP port number from the login path
#
# 								--socket, -S - Remove the Unix socket file name from the login path
#
# 								--user, -u - Remove the user name from the login path
#
# 								--warn, -w - Warn and prompt the user for confirmation if the command attempts to remove the default login
# 												 path (client) and --login-path=client was not specified. On by default, turn off with --skip-warn
#
# reset [<options>] - Empty the contents of the login path file.
#
# 							 The reset command permits these options following the command name:
#
# 							 --help, -? - Display a help message for the reset command and exit.
# 											  To see a general help message, use mysql_config_editor --help
#
# set [<options>] - Write a login path to the login path file.
#
# 						  This command writes to the login path only such options as are specified with the --host,
# 						  --password, --port, --socket and --user options.
#
# 						  If none of those options are given - mysql_config_editor writes the login path as an empty group.
#
# 						  The set command permits these options following the command name:
#
# 						  --help, -? - Display a help message for the set command and exit.
# 
# 											To see a general help message, use mysql_config_editor --help
#
# 						  --host=<host_name>, -h <host_name> - The host name to write to the login path.
#
# 						  --login-path=<name>, -G <name> - The login path to create. The default login path is <client> if this option is not given.
#
# 						  --password, -p - Prompt for a password to write to the login path. After mysql_config_editor displays the prompt,
# 												 type the password and press Enter. mysql_config_editor does not echo it.
#
# 												 To specify a empty password - just press Enter, and it generates:
#
# 												 password =
#
# 						  --port=<port_num>, -P <port_num> - The TCP/IP port number to write to the login path.
#
# 						  --socket=<file_name>, -S <file_name> - The Unix socket file name to write to the login path.
#
# 						  --user=<user_name>, -u <user_name> - User name to write to the login path.
#
# 						  --warn, -w - Warn and prompt the user for confirmation if the command attempts to overwrite an existing login path.
# 											On by default - turn off with --skip-warn
#
# The following section pertains to mysqlbinlog - A utility for Processing Binary Log Files
#
# The server's binary log consists of files containing "events" that describe modifications to the DB contents.
# The server writes these files in binary formatting. To display said contents in text - use the mysqlbinlog utility.
#
# You can also use mysqlbinlog to display the contents of relay log files written by a slave server in a replication setup
# because relay logs have the same format as binary logs.
#
# The binary log and relay log are covered later.
#
# Invoke mysqlbinlog as follows:
#
# mysqlbinlog [<options>] <log_file>
#
# To display contents of binary log file binlog.000003:
#
# mysqlbinlog binlog.000003
#
# The output includes events contained in binlog.000003.
# For statement-based logging, event information includes the SQL statement, the ID of the server on which it
# was executed, timestamp of execution, time taken, etc.
#
# For row-based logging, the event indicates a row change rather than an SQL statement.
#
# Events are preceded by header comments that provide additional information:
#
# # at 141 #Line start or offset in the bin log file
#
# #100309 9:28:36 server id 123 end_log_pos 245 #date, time, server, id, end_log_pos + 1 is where next event will start - timestamp is propagated to slave servers. 
#
#  Query thread_id=3350 exec_time=11 error_code=0 #id of thread, time spent executing the event on the master server. 
#  
#  #On a slave, it is the replication lag behind the master the slave is having. error_code is the raised error - 0 means no error.
#
# When using event groups - the file offset of events may be grouped together and the comments of events may be grouped together.
# Do not mistake these grouped events for blank file offsets.
#
# The output from mysqlbinlog can be re-executed (For example - by using it as input to mysql) - to redo the statements in the log.
# This is useful for recovery operations after a server crash.
#
# Normally - we use mysqlbinlog to read binary log files directly and apply them to the local MySQL server.
# It is also possible to read binary logs from a remote server by using the --read-from-remote-server option.
#
# To read remote binary logs - the connection param options can be given to indicate how to connect to the server.
# These options are --host, --password, --port, --protocol, --socket and --user.
# They are ignored except when you also use the --read-from-remote-server option.
#
# When running mysqlbinlog against a large binary log - be careful that the filesystem has enough space for the
# resulting files.
#
# To configure the directory that mysqlbinlog uses for temp files - use the TMPDIR environment variable.
#
# mysqlbinlog supports the following options, which can be specified on cmd line or in [mysqlbinlog] and [client] groups.
#
# Format 										Desc
# --base64-output 			Print binary log entries using base-64 encoding
# --bind-address 				Use specified network interface to connect to MySQL Server
# --binlog-row-event-max   Binary log max event size
#  -size
# --character-sets-dir 		Directory where char sets are installed
# --connection-server-id 	Used for testing and debugging.
# 
# --database 					List entries for just this db
# --debug 						Write debugging log
# --debug-check 				Print debug info when program exits
# --debug-info 				Print debug info, memory and CPU stats when the program exits
# --default-auth 				Auth plugin to use
# --defaults-extra-file 	Read named option file in addition to usual option files
# --defaults-file 			Read only named option file
#
# --defaults-group-suffix 	Option group suffix value
# --disable-log-bin 			Disable binary logging
# --exclude-gtids 			Do not show any of the groups in the GTID set provided
# --force-if-open 			Read binary log files even if open or not closed properly
# --force-read 				If mysqlbinlog reads a binary log event that it does not recognize - it prints a warning
#
# --get-server-public-key 	Request RSA public key from server
# --help 						Display help message and exit
# --hexdump 					Display a hex dump of the log in comments
# --host 						Connect to MySQL on the given host
# --idempotent 				Cause the server to use idempotent mode while processing binary log updates from this session only
# --include-gtids 			Show only the groups in the GTID set provided
# --local-load 				Prepare local temporary files for LOAD DATA INFILE in the specified dir
# --login-path 				Read login path options from .mylogin.cnf
#
# --no-defaults 				Read no option files
# --offset 						Skip the first N entries in the log
# --password 					Password to use when connecting to server
# --plugin-dir 				Dir where plugins are installed
# --port 						TCP/IP port number for connection
# --print-defaults 			Print default options
# --print-table-metadata 	Print table metadata
# --protocol 					Connection protocol to use
#
# --raw 							Write events in raw (binary) format to output files
# --read-from-remote 		Read the binary log from a MySQL master rather than reading a local log file
#  -master
# --read-from-remote 		Read binary log from MySQL server rather than local log file
#  -server
# --result-file 				Direct output to named file
# --rewrite-db 				Create rewrite rules for databases when playing back from logs written in row-based format. Stacks.
# --secure-auth 				REMOVED
#
# --server-id 					Extract only those events created by the server having the given server ID
# --server-id-bits 			Tell mysqlbinlog how to interpret server IDs in binary log when log was written by a
# 									mysqld having its server-id-bits-set to less than the maximum.
#
# 									Supported only by MySQL Cluster version of mysqlbinlog.
# --server-public-key-path Path name to file containing RSA public key
# --set-charset 				Add a SET NAMES charset_name statement to the output
# --shared-memory-base 		The name of shared memory to use for shared-memory connections
#  -name 
# --short-form 				Display only the statements contained in the log
# --skip-gtids 				Do not print any GTIDs; use this when writing a dump file from bin logs containing GTIDs.
# --socket 						For connections to localhost, the Unix socket file to use
# --ssl-ca 						File that contains list of trusted SSL Cert Auths
# --ssl-capath 				Dir that contains trusted SSL Cert Auth cert files
# --ssl-cert 					File that contains X.509 Cert
#
# --ssl-cipher 				List of permitted ciphers for connection encryption
# --ssl-crl 					File that  contains cert revocation lists
# --ssl-crlpath 				Dir that contains cert revocation list files
# --ssl-fips-mode 			Whether to enable FIPS mode on the client side
# --ssl-key 					File that contains X.509 key
# --ssl-mode 					Security state of connection to server
# --start-datetime 			Read binary log from first event with timestamp equal to or later than datetime argument
# --start-position 			Read binary log from first event with position equal to or greater than argument
# --stop-datetime 			Stop reading binary log at first event with timestmap equal to or greater than datetime arg
#
# --stop-never 				Stay connected to server after reading last binary log file
# --stop-never-slave- 		Slave server ID to report when connecting to server
#  server-id
# --stop-position 			Stop reading binary log at first event when position equal to or greater than arg
# --tls-version 				Protocols permitted for enc. connections
# --to-last-log 				Do not stop at the end of requested binary log from a MySQL server, but rather continue
# 									printing to end of last binary log
# --user 						MySQL user name to use when connecting to server
# --verbose 					Reconstruct row events as SQL statements
# --verify-binlog-checksum Verify checksums in binary log
# --version 					Display version info and exit
#
# The following maps the further attributes of some of the above commands:
#
# --help, -? - Display a help message and exit
# --base64-output=<value> - This option determines when events should be displayed encoded as base-64 strings using BINLOG statements.
# 									 The option has these permissible values (not case-sensitive):
#
# 									 AUTO/UNSPEC - displays BINLOG statements automatically when necessary (that is - for format desc. events and row events).
# 														If no --base64-output option is given, the effect is the same as --base64-output=AUTO
#
# 														NOTE: Automatic BINLOG display is the only safe behavior if you intend to use the output of mysqlbinlog 
# 														to re-execute binary log file contents.
#
# 														The other option values are intended only for debugging or testing purposes because they may produce output
# 														that does not include all events in executable form.
#
# 									 NEVER - Causes BINLOG statements not to be displayed. mysqlbinlog exits with an error if a row event is found that must
# 												be displayed using BINLOG.
#
# 									 DECODE-ROWS - Specifies to mysqlbinlog that you intend for row events to be decoded and displayed as commented SQL statements
# 														by also specifying the --verbose option.
#
# 														Like NEVER, DECODE-ROWS suppresses display of BINLOG statements, but unlike NEVER - it does not exit with an error
# 														if a row event is found.
#
# 									 For examples that show the effect of --base64-output and --verbose on row event output.
#
# --bind-address=<ip address> - On a computer having multiple network interfaces, use this option to select which interface to use for connecting to the MySQL server.
# --binlog-row-event-max-size=<N> - General syntax formatting and values:
#
# 												Command-Line format - --binlog-row-event-max-size=#
# 												Type 						 Numeric
# 												Default Value 			 4294967040
# 												Minimum Value 			 256
# 												Maximum Value 			 18446744073709547520
# 											
# 												The above values are in bytes. Refers to row-based binary log events size.
# 												Rows are grouped into events smaller than this size if possible.
#
# 												Value should be a multiple of 256 - Defaults to 4GB
#
# --character-sets-dir=<dir name> - The dir where char sets are installed.
#
# --connection-server-id=<server id> - specifies the server ID that mysqlbinlog reports when it connects to the server. 
# 													Can be used to avoid a conflict with the ID of a slave server or another mysqlbinlog process.
#
# 													If the --read-from-remote-server option is specified, mysqlbinlog reports a server ID of 0,
# 													which tells the server to disconnect after sending the last log file (nonblocking behavior)
#
# 													If the --stop-never option is also specified to maintain the connection to the server, mysqlbinlog
# 													reports a server ID of 1 by default instead of 0 - and --connection-server-id can be used to
# 													replace that server ID if required.
#
# --database=<db name>, -d <db_name> - This option causes mysqlbinlog to output entries from the binary log (local log only) that occur
# 													while <db_name> has been selected as the default DB by <USE>.
#
# 													The --database option for mysqlbinlog is similar to the --binlog-do-db option for mysqld, but
# 													can be used to specify only one DB. If --database is given several times, the last one is taken.
#
# 													The effects of this option depend on whether the statement-based or row-based logging format is
# 													in use, in the same way that the effects of --binlog-do-db depend on whether statement-based
# 													or row-based logging is used.
#
# 													Statement-based logging:
#
# 													The --database option works as follows:
#
# 														While <db_name> is the default DB, statements are output whether they modify tables in
# 														<db_name> or a different database.
#
# 														Unless <db_name> is selected as the default DB, statements are not output - even if they modify tables in <db_name>.
#
# 														There is an exception for CREATE DATABASE, ALTER DATABASE and DROP DATABASE. 
# 														The database being created, altered or dropped is considered to be the default database
# 														when determining whether to output the statement.
#
#													Assuming the following base of implementation:
#
# 														INSERT INTO test.t1 (i)  VALUES(100);
# 														INSERT INTO db2.t2 (j) 	 VALUES(200);
# 														USE test;
# 														INSERT INTO test.t1 (i)  VALUES(101);
# 														INSERT INTO t1 (i) 		 VALUES(102);
# 														INSERT INTO db2.t2 (j) 	 VALUES(201);
# 														USE db2;
# 														INSERT INTO test.t1 (i)  VALUES(103);
# 														INSERT INTO db2.t2 (j) 	 VALUES(202);
# 														INSERT INTO t2 (j) 		 VALUES(203);
#
# 													mysqlbinlog --database=test does not output the first two INSERT statements because there is no default DB.
# 													It outputs the three INSERT statements following USE test, but not the three INSERT statements following USE db2.
#
# 													mysqlbinlog --database=db2 does not output the first two INSERT statements because there is no default DB.
# 													It does not output the three INSERT statements after USE.test - but it does output the three after USE db2. (because default usage db2)
#
# 													Row-based logging. mysqlbinlog outputs only entires that change tables belonging to <db_name>.
# 													The default DB has no effect on this. Suppose that the binary log just described was created using
# 													row-based logging rather than statement-based logging.
#
# 													mysqlbinlog --database=test outputs only those entries that modify t1 in the test database, regardless of
# 													whether USE was issued or what the default DB is.
#
# 													If a server is running with binlog format set to MIXED - and we want to use mysqlbinlog with --database option,
# 													the modified tables must be selected by USE. (In particular, no cross-database updates should be used)
#
# 													When used together with the --rewrite-db option, the --rewrite-db option is applied first;
# 													Then the --database option is applied - using the rewritten database name.
#
# 													The order in which the options are provided makes no difference in this regard.
#
# --debug[=<debug options>], 			 	Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>. Defaults to d:t:o, /tmp/mysqlbinlog.trace
#  -# [<debug options>]
#
# --debug-check 								Print debug info when the program exits
#
# --debug-info 								Print debug info, memory and CPU usage stats when exiting
#
# --default-auth=<plugin> 					A hint about the client-side auth plugin to use.
#
# --defaults-extra-file=<file name> 	Read this option file after the global option file, but (on Unix) before the user option file.
# 													Relative if relative, absolute if absolute - error if permissions denied or not found.
#
# --defaults-file=<file name> 			Use only the given option file. Relative if relative, error if non permissible or found. Still reads .mylogin.cnf
#
# --defaults-group-suffix=<str> 			Regex suffix matching in grouping 
#
# --disable-log-bin, -D 					Disable binary logging. Useful for avoiding an endless loop if we use --to-last-log option and we are sending the output
# 													to the same MySQL server.
#
# 													Useful when restoring after a crash to avoid duplication of the statements we logged.
#
# 													Causes mysqlbinlog to include a <SET sql log bin = 0> statement in its output to disable binary
# 													logging of the remaining output.
#
# 													Manipulating the session value of the sql log bin system var is a restricted operation - so 
# 													this requires permissions to set restricted session vars.
#
# --exclude-gtids=<gtid set> 				Do not display any of the groups listed in the <gtid_set>
#
# --force-if-open, -F 						Read binary log files even if they are open or were not closed properly.
#
# --force-read, -f 							With this option, if mysqlbinlog reads a binary log event that it does not recognize
# 													- it prints a warning, ignores the event and continues. Without this option - mysqlbinlog stops reading in such an event.
#
# --get-server-public-key 					Same as otherwise with RSA public key request, applies to clients authenticating caching_sha2_password auth plugin.
#
# --hexdump, -H 								Display a hex dump of the log in comments - can be useful for replicating debugging
#
# --host=<host name>, 						Get the binary log from the MySQL server on the given host.
#  -h <host name>
#
# --idempotent 								Tell the MySQL server to use idempotent mode while processing updates.
# 													Causes suppression of any duplicate-key or key-not-found errors that the server
# 													encounters in the current session while processing updates.
#
# 													May prove useful whenever it is desirable or nessecary to replay one or more binary logs
# 													to a MySQL server which may not contain all of the data to which the logs refer.
#
# 													The scope of effect for this option includes the current mysqlbinlog client and session only.
#
# --include-gtids=<gtid set> 		 		Display only the groups listed in the gtid_set
#
# --local-load=<dir name>,  				Prepare local temporary files for LOAD DATA INFILE in the specified dir.
#  -l <dir_name> 								(These are not automatically removed by any MySQL program)
#
# --login-path=<name> 						Read options from the named login path in the .mylogin.cnf login path file.
# 													This specific option group pertains to connection details to server and account to auth as.
#
# --no-defaults 								Do not read any option files. If program startup fails due to reading unknown options from an option file
# 													--no-defaults can be used to prevent them from being read.
#
# 													The exception is that the .mylogin.cnf file, it's always read.
#
# --offset=<N>, -o <N> 						Skip the first N entries in the log.
#
# --password[=<password>], 				The PW to use when connecting to the server. If you use the short option (-p) - cannot have space.
#  -p [<password>]  							If value omitted, prompted for one
#
# --plugin-dir=<dir name> 					The dir in which to look for plugins. Specify if --default-auth option is used to specify a auth plugin 
# 													but mysqlbinlog can't find it
#
# --port=<port num>, 						The TCP/IP port number to use for connecting to a remote server
#  -P <port_num>
#
# --print-defaults 							Print the program name and all the options that it gets from option files.
#
# --print-table-metadata 					Print table related metadata from the binary log. 
# 													Configure the amount of table related metadata binary logged using binlog-row-metadata
#
# --protocol={TCP|SOCKET|PIPE|MEMORY}  The connection protocol to use for connecting to the server.
# 													
# --raw 											By default, mysqlbinlog reads binary log files and writes events in text format.
# 													The --raw option tells mysqlbinlog to write them in their original binary format.
#
# 													Its use requires that --read-from-remote-server also be used because the files are requested from a server.
#
# 													mysqlbinlog writes one output file for each file read from the server.
# 													The --raw option can be used to make a backup of the Server's binary log.
#
# 													With --stop-never, the backup acts as "live" - because connection is not interuppted.
# 													Defaults to writing to a output file in the CWD with the same name as the original log files.
#
# 													Output file names can be modified using the --result-file 
#
# --read-from-remote-master=<type> 		Read binary logs from a MySQL server with the COM_BINLOG_DUMP or COM_BINLOG_DUMP_GTID commands
# 													by setting the option value to either BINLOG-DUMP-NON-GTIDS or BINLOG-DUMP-GTIDS, respectively.
#
# 													If --read-from-remote-master=<BINLOG-DUMP-GTIDS> is combined with --exclude-gtids - transactions
# 													can be filtered out on the master - avoiding unessecary network traffic.
#
# --read-from-remote-server, -R 			Read the binary log from a MySQL server rather than reading a local log file.
# 													Any connection parameter options are ignored unless this option is given as well.
#
# 													These options are --host, --password, --port, --protocol, --socket and --user.
#
# 													Requires that the remote server is running. Works only for binary log files on the remote server,
# 													not relay log files.
#
# 													This option is equivalent to --read-from-remote-master=BINLOG-DUMP-NON-GTIDS
#
# --result-file=<name>, -r <name> 		Without the --raw option, this option indicates the file to which mysqlbinlog writes text output.
#
# 													With -raw, mysqlbinlog writes one binary output file for each log file transferred from the server,
# 													writing them by default in the CWD using the same name as the original log file.
#
# 													In this case, the --result-file option value is treated as a prefix that modifies output file names.
#
# --rewrite-db='<from name->to name>' 	When reading from a row-based or statement-based log, rewrite all occurrences of <from_name> to <to_name>.
# 													Rewriting is done on the rows, for row-based logs - as well as on the USE clauses, for statement based logs.
#
# 													NOTE: Statements in which table names are qualified with DB names are not rewritten to use the new name when using this option.
#
# 													The rewrite rule employed as a value for this option is a string having the form '<from_name>-><to_name>' as shown previously,
# 													and it must be enclosed ''
#
# 													To employ it multiple times, an example:
#
# 													mysqlbinlog --rewrite-db='dbcurrent->dbold' --rewrite-db='dbtest->dbcurrent' \
# 																	binlog.00001 > /tmp/statements.sql
#
# 													When used together with the --database option, the --rewrite-db option is applied first -
# 													then --database is applied, using the rewritten DB name.
#
# 													In this case, ordering makes no difference.
#
# 													For instance, if mysqlbinlog is started with --rewrite-db='mydb->yourdb' --database=yourdb, then all
# 													updates to any tables in databases mydb and yourdb are included in said output.
#
# 													On the other hand, if it is started with --rewrite-db='mydb->yourdb' --database=mydb, then no outputs are given,
# 													because all updates to mydb are first rewritten as updates to yourdb before applying the --database option
#
# 													Thus no updates are left matching --database=mydb
#
# --server-id=<id> 							Display only events created by the server having the given server ID
#
# --set-charset=<charset name> 			Add a SET NAMES <charset name> statement to the output to specify the char set to be used for processing log files.
#
# --shared-memory-base-name=<name> 		On Windows, the shared-memory name to use for connections made using shared memory to a local server.
# 													Defaults to MySQL. Case-sensitive
#
# 													Server must be started with --shared-memory to enable shared-memory connections
#
# --short-form, -s 							Display only the statements contained in the log, without any extra information or row-based events.
# 													DEPRECATED, DO NOT USE.
#
# --skip-gtids[=(true|false)] 			Do not display any GTIDs in the output. Needed when writing to a dump file from one or more binary logs
# 													containing GTIDs, as shown:
#
# 													mysqlbinlog --skip-gtids binlog.000001 >  /tmp/dump.sql
# 													mysqlbinlog --skip-gtids binlog.000002 >> /tmp/dump.sql
# 													mysql -u root -p -e "source /tmp/dump.sql"
#
# 													Not recommended for production
#
# --socket=<path>, -S <path> 				For connections to localhost, Unix socket file to use or Windows - named pipe to use.
#
# --ssl* 										Options that begin with --ssl specify whether to connect to the server using SSL and indicate where to
# 													find SSL keys and certs.
#
# --ssl-fips-mode={OFF|ON|STRICT} 		Controlling FIPS mode on the client side.
#
# --start-datetime=<datetime> 			Start reading the binary log at the first event having a timestamp equal to or later than the <datetime> argument.
# 													The <datetime> value is relative to the local time zone on the machine where you run mysqlbinlog.
#
# 													The value should be in a format accepted for the DATETIME or TIMESTAMP data types.
#
# 													mysqlbinlog --start-datetime="2005-12-25 11:25:56" binlog.000003
#
# 													Useful for point-in-time recovery.
#
# --start-position=<N>, -j <N> 			Start reading the binary log at the first event having a position equal to or greater than <N>.
# 													This option applies to the first log file named on the cmd line.
#
# 													Useful for point-in-time recovery.
#
# --stop-datetime=<datetime> 				Stop reading the binary log at the first event having a timestamp equal to or later than the <datetime> argument.
# 													This option is useful for point-in-time recovery.
#
# --stop-never 								This option is used with --read-from-remote-server. It tells mysqlbinlog to remain connected to the server.
# 													Otherwise mysqlbinlog exits when the last log file has been transferred from the server.
#
# 													--stop-never implies --to-last-log - so only the first log file to transfer needs to be named on the cmd line.
#
# 													--stop-never is commonly used with --raw to make a live binary log backup, but can also be used without --raw
# 													to maintain a continous text display of log events as the server generates them.
#
# 													With --stop-never, by default, mysqlbinlog reports a server ID of 1 when it connects to the server.
# 													Use --connection-server-id to explicitly specify an alternative ID to report. Can be used to
# 													avoid a conflict with the ID of a slave server or another mysqlbinlog.
#
# --stop-never-slave-server-id=<id> 	DEPRECATED, use --connection-server-id instead to specify a server ID for mysqlbinlog to report.
#
# --stop-position=<N> 						Stop reading the binary log at teh first event having a position equal to or greater than <N>.
# 													Applies to the last log file named on the cmd line.
#
# 													Useful for point-in-time recovery.
#
# --tls-version=<protocol list> 			The protocols permitted by the client for encrypted connections. Depends on compilated SSL libs relative to MySQL.
#
# --to-last-log, -t 							Do not stop at the end of requested binary log from a MySQL server, but rather continue printing
# 													until the end of the last binary log.
#
# 													If this is sent to the same MySQL server, it causes an endless loop.
#
# 													Requires --read-from-remote-server.
#
# --user=<user name>, -u <user_name> 	The MySQL user name to use when connecting to a remote server
#
# --verbose, -v 								Reconstruct row events and display them as commented SQL statements.
# 													If given twice - output includes comments to indicate column data types, some metadata and row query log events.
#
# --verify-binlog-checksum, -c 			Verify checksums in binary log files.
#
# --version, -V 								Display version info and exit
#
# --open_files_limit=<value> 				Specifies number of open file descriptors to reserve
#
# We can pipe the output of mysqlbinlog into the mysql client to execute the events contained in the binary log.
# This can be done to recover from a crash with a old backup:
#
# mysqlbinlog binlog.000001 | mysql -u root -p
#
# or
#
# mysqlbinlog binlog.[0-9]* | mysql -u root -p
#
# If the statements produced by mysqlbinlog may contain BLOB values, these may cause problems when mysql processes them.
# In such a case - use mysql with --binary-mode then.
#
# We can also redirect the output of mysqlbinlog to a text file instead - if we need to modify the statement log first
# (for example - to remove statements that we do not want to execute)
#
# Example of redirection:
#
# mysqlbinlog binlog.000001 > tmpfile #Redirect unto tmpfile
# <Interlude>
# mysql -u root -p < tmpfile #Redirect from tmpfile to the DB
#
# When mysqlbinlog is invoked with the --start-position option - it displays only those events
# with an offset in the binary log greater than or equal to the given pos. (The pos must align with start of an event)
#
# Thus we can do rollbacks or rollfowards to specific time points - such as roll forward to how the DB was @ a specific time point (in tandem with --stop-datetime)
#
# The following covers how to approaching multiple file integrations: 
#
#
# mysqlbinlog binlog.000001 | mysql -u root -p  #Problematic if contains CREATE TEMPORARY TABLE statement and second uses said table
# mysqlbinlog binlog.000002 | mysql -u root -p  #The reason why it's an isssue, is that the connection is terminated between the two commands, so tmp table is dropped - have to specify them as 1 command
#
# Example:
#
# mysqlbinlog binlog.000001 binlog.000002 | mysql -u root -p
#
# Another way is to route log files to a file and then read the file:
#
# mysqlbinlog binlog.000001 > /tmp/statements.sql
# mysqlbinlog binlog.000002 >> /tmp/statements.sql
# mysql -u root -p -e "source /tmp/statements.sql"
#
# As of 8.0.12, you can also supply multiple binary log files to mysqlbinlog as streamed input using a shell pipe.
# An archive of compressed binary log files can be decompressed and provided directly to mysqlbinlog.
#
# In this example, binlog-files_1.gz contains multiple binary log files for processing.
#
# The pipeline extracts the contents of binlog-files_1.gz - pipes the binary log files to mysqlbinlog as standard input,
# and pipes the output of mysqlbinlog into mysql for execution:
#
# gzip -cd binlog-files_1.gz | ./mysqlbinlog - | ./mysql -uroot -p
#
# We can chain more than one archive file:
#
# gzip -cd binlog-files_1.gz binlog-files_2.gz | ./mysqlbinlog - | ./mysql -uroot -p
#
# For streamed input, do not use --stop-position, because mysqlbinlog cannot identify the last log file to apply this option.
#
# LOAD DATA INFILE operations: mysqlbinlog can produce output that reproduces a LOAD DATA INFILE operation without
# the original data file.
#
# mysqlbinlog copies the data to a temp file and writes a LOAD DATA LOCAL INFILE statement that refers to the file.
# The default location of the dir where said files are written is system-specific.
#
# To specify a dir explicitly, use the --local-load option
#
# Because mysqlbinlog converts LOAD DATA INFILE statements to LOAD DATA LOCAL INFILE statements (i.e, it adds LOCAL) - both the client
# and server that you use to process the statements must be configured with the LOCAL capability enabled.
#
# WARNING: The temporary files created for LOAD DATA LOCAL statements are NOT automatically deleted because they are
# 			  needed until you actually execute those statements. You should delete the temporary files yourself after
#  		  you no longer need the statement log. The files can be found in the temporary file dir and have names like:
# 			  <original_file_name-#-#>
#
# The following covers mysqlbinlog Hex Dump Format
#
# The --hexdump option causes mysqlbinlog to produce a hex dump of the binary log contents:
#
# 	mysqlbinlog --hexdump master-bin.000001
#
# The hex output consists of comment lines beginning with #, it might look as follows:
#
# /* !40019 SET @@session.max_insert_delayed_threads=0*/;
# /* !50003 SET @@OLD_COMPLETION_TYPE=@@COMPLETION_TYPE, COMPLETION_TYPE=0*/;
# at 4
# 051024 17:24:13 server id 1 end_log_pos 98
# Position 	Timestamp 	Type 		Master ID 		Size 		Master Pos 	  Flags
# <                    Hexadecimal outputs           >   62 00 00 00   00 00
# < 						  Hexadecimal outputs 			  >   |..5.0.15.debug.l|
# etc.
# 		Start: binlog v 4, server v 5.0.15-debug-log created 051024 17:24:13
# 		at startup
# ROLLBACK;
#
# The hex dump output contains the elements in the following list: (This might change)
#
# Position: The byte pos within the log file
# Timestamp: The event timestamp. In the example shown, '9d fc 5c 43' is the representation of '051024 17:24:13' in hexadecimal
# Type: The event type code
# Master ID: The server ID of the master that created the event
# Size: The size in bytes of the event
# Master Pos: The position of the next event in the original master log file.
# Flags: Event flag values.
#
# The following covers mysqlbinlog Row Event Displays:
#
# The following examples illustrate how mysqlbinlog displays row events that specify data modifications.
# These correspond to events with the WRITE_ROWS_EVENT, UPDATE_ROWS_EVENT and DELETE_ROWS_EVENT type codes.
#
# The --base64-output=DECODE-ROWS and --verbose options may be used to affect row event output.
#
# Suppose that the server is using row-based binary logging and that you execute the following sequence of statements:
#
# CREATE TABLE t
# (
# 	 id 	INT NOT NULL,
# 	 name VARCHAR(20) NOT NULL,
#   date DATE NULL,
# ) ENGINE = InnoDB;
#
# START TRANSACTION;
# INSERT INTO t VALUES(1, 'apple', NULL);
# UPDATE t SET name = 'pear', date = '2009-01-01' WHERE id = 1;
# DELETE FROM t WHERE id = 1;
# COMMIT;
#
# By default, mysqlbinlog displays row events encoded as base-64 strings using BINLOG statements.
# Omitting extraneous lines, the output for the row events produced by the preceding statement sequences might look as follows:
#
# mysqlbinlog <log_file>
#
# # at 218
# #080828 15:03:08 server id 1 end_log_pos 258 		Write_rows: 	table id 17 flags: 	STMT_END_F
# 
# BINLOG '
# <string>
# '/*!*/;
# ...
# # at 302
# #080828 15:03:08 server id 1 end_log_pos 356 		Update_rows: 	table id 17 flags: 	 STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/;
# ...
# # at 400
# #080828 15:03:08 server id 1 end_log_pos 442 		Delete_rows: table id 17 flags: STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/;
#
# We can convert said binary strings to closer to SQL, with --verbose or -v. Said lines pertain to the lines starting with ###
# 
# mysqlbinlog -v <log_file>
# ...
# # at 218
# #080828 15:03:08 server id 1 	end_log_pos 258 		Write_rows: table id 17 flags: STMT_END_F
# 
# BINLOG '
# <string>
# '/*!*/;
# ### INSERT INTO test.t
# ### SET
# ###   @1=1
# ###   @2='apple'
# ###   @3=NULL
# ...
# # at 302
# #080828 15:03:08 server id 1 	end_log_pos 356 		Update_rows: table id 17 	flags: STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/
# ### UPDATE test.t
# ### WHERE
# ###   @1=1
# ###   @2='apple'
# ###   @3=NULL
# ### SET
# ###   @1=1
# ###   @2='pear'
# ###   @3='2009:01:01'
# ...
# # at 400
# #080828 15:03:08 server id 1 end_log_pos 442 		Delete_rows: table id 17 flags : STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/
# ### DELETE FROM test.t
# ### WHERE
# ###   @1=1
# ###   @2='pear'
# ###   @3='2009:01:01'
#
# Where of, if we do it twice:
#
# mysqlbinlog -vv <log_file>
# ...
# # at 218
# #080828 15:03:08 server id 1  end_log_pos 258 	Write_rows: table id 17 flags: STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/;
# ### INSERT INTO test.t
# ### SET
# ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
# ###   @2='apple' /* VARSTRING(20) meta=20 nullable=0 is_null=0 */
# ###   @3=NULL /* VARSTRING(20) meta=0 nullable=1 is_null=1 */
# ...
# # at 302
# #080828 15:03:08 server id 1 end_log_pos 356 	Update_rows: table id 17 flags: STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/;
# ### UPDATE test.t
# ### WHERE
# ###   @1=1 /*  INT meta=0 nullable=0 is_null=0 */
# ###   @2='apple' /* VARSTRING(20) meta=20 nullable=0 is_null=0 */
# ###   @3=NULL /* VARSTRING(20) meta=0 nullable=1 is_null=1 */
# ### SET
# ###   @1=1 /*  INT meta=0 nullable=0 is_null=0 */
# ###   @2='pear' /* VARSTRING(20) meta=20 nullable=0 is_null=0 */
# ###   @3='2009:01:01' /* DATE meta=0 nullable=1 is_null=0 */
# ...
# at 400
#080828 15:03:08 server id 1 	end_log_pos 442 	Delete_rows: table id 17 flags: STMT_END_F
#
# BINLOG '
# <string>
# '/*!*/;						
# ### DELETE FROM test.t
# ### WHERE
# ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
# ###   @2='pear' /* VARSTRING(20) meta=20 nullable=0 is_null=0 */
# ###   @3='2009:01:01' /* DATE meta=0 nullable=1 is_null=0 */
#
# You can tell mysqlbinlog to suppress the BINLOG statements for row events by using the --base64-output=<DECODE-ROWS> option.
# This is similar to --base64-output=NEVER but it does not exit with an error if a row event is found.
# The combination of --base64-output=<DECODE-ROWS> and --verbose provides a convenient way to see row events
# only as SQL statements:
#
# mysqlbinlog -v --base64-output=DECODE-ROWS log_file
# # at 218
# #080828 15:03:08 server id 1 end_log_pos 258 		Write_rows: table id 17 flags: STMT_END_F
# ### INSERT INTO test.t
# ### SET
# ###   @1=1
# ###   @2='apple'
# ###   @3=NULL
# ...
# # at 302
# #080828 15:03:08 server id 1 end_log_pos 356 		Update_rows: table id 17 flags: STMT_END_F
# ### UPDATE test.t
# ### WHERE
# ###   @1=1
# ###   @2='apple'
# ###   @3=NULL
# ### SET
# ###   @1=1
# ###   @2='pear'
# ###   @3='2009:01:01'
# ...
# # at 400
# #080828 15:03:08 server id 1 	end_log_pos 442 		Delete_rows: table id 17 flags: STMT_END_F
# ### DELETE FROM test.t
# ### WHERE
# ###   @1=1
# ###   @2='pear'
# ###   @3='2009:01:01'
#
# NOTE: You should not suppress BINLOG statements if you intend to re-execute mysqlbinlog output
#
# The SQL statements produced by --verbose for row events are much more readable than the corresponding BINLOG statements.
# However, they do not correspond exactly to the original SQL statements that generated the events.
#
# The following limitations apply:
#
# The original column names are lost and replaced by @N where N is the column number
# 
# Character set information is not available in the binary log, which affects string column display:
# 		
# 		There is no distinction made between corresponding binary and nonbinary string types (BINARY and CHAR, VARBINARY and VARCHAR, BLOB and TEXT)
#     The output uses a data type of STRING for fixed-length strings and VARSTRING for variable-length strings.
#
# 		For multibyte char sets, the max number of bytes per character is not present in the binary log, so the length for string
# 		types is displayed in bytes rather than in characters. For example, STRING(4) will be used as the data type for values from either
#     of these column types:
#
# 		CHAR(4) 	CHARACTER SET latin1
# 		CHAR(2) 	CHARACTER SET ucs2
#
# 		Due to the storage format for events of type UPDATE_ROWS_EVENT, UPDATE statements are displayed with the WHERE clause preceding the SET clause.
# 
# Proper interpretation of row events requires the information from the format description event at the beginning of the binary log.
#
# Because mysqlbinlog does not know in advance whether the rest of the log contain rows row events, by default it displays the format
# description event using a BINLOG statement in the initial part of the output.
#
# If the binary log is known not to contain any events requiring a BINLOG statement (that is, no row events) - the --base64-output=NEVER option can be 
# used to prevent this header from being written.
#
# The following covers using mysqlbinlog to Back Up Binary Log Files
#
# By default, mysqlbinlog reads binary log files and displays their contents in text format. This enables you
# to examine events within the files more easily and to re-execute them (For example - by using the output as input to mysql)
#
# mysqlbinlog can read log files directly from the local file system, or, with the --read-from-remote-server option
# - it can connect to a server and request binary log contents from that server.
#
# mysqlbinlog writes text output to its standard output - or to the file named as the value of the --result-file=<file name> option
# if that option is given.
#
# mysqlbinlog can read binary log files and write new files containing the same content - that is, in binary
# format rather than text format.
#
# This capability enables you to easily back up a binary log in its original format. mysqlbinlog can make a static
# backup, backing up a set of log files and stopping when the end of the last file is reached.
#
# It can also make a continuous ("live") backup - staying connected to the server when it reaches the end of the last log
# file and continuing to copy new events as they are generated.
#
# In continuous-backup operation, mysqlbinlog runs until the connection ends (for example - when the server exits) or mysqlbinlog
# is forcibly terminated. When the connection ends, mysqlbinlog does not wait and retry the connection - unlike a slave replication server.
#
# To continue a live backup after the server has been restarted - you must also restart mysqlbinlog.
#
# Binary log backup requires that you invoke mysqlbinlog with two options at minimum:
#
# 		The --read-from-remote-server (or -R) option tells mysqlbinlog to connect to a server and request its binary log.
# 				(This is similar to a slave replication server connecting to its master server)
#
# 		The --raw option tells mysqlbinlog to write raw (binary) output, not text output
#
# Along with --read-from-remote-server - it is common to specify other options: --host indicates where the server
# is running and you may also need to specify connection options such as --user and --password
#
# Several other options are useful in conjunction with --raw:
#
# 		--stop-never: Stay connected to the server after reaching the end of the last log file and continue to read new events
#
# 		--connection-server-id=<id>: The server ID that mysqlbinlog reports when it connects to a server. 
# 											  When --stop-never is used, the default reported server ID is 1.
# 											  If this causes a conflict with the ID of a slave server or another mysqlbinlog process,
# 											  use --connection-server-id to specify an alternative server ID.
#
# 		--result-file: A prefix for output file names, as described later.
#
# To back up a server's binary log files with mysqlbinlog, you must specify file names that actually exist on the server.
# If you do not know the names, connect to the server and use the SHOW BINARY LOGS statement to see the current names.
#
# Suppose that the statement produces this output:
#
# 	SHOW BINARY LOGS;
# 	
# 		Log_name 			File_size
# 	 binlog.000130 		27459
#   binlog.000131 		13719
# 	 binlog.000132 		43268
#
# With that information, you can use mysqlbinlog to back up the binary log to the current dir as follows (enter each command on a single line):
#
# 		To make a static backup of binlog.000130 through binlog.000132, use either of the following commands:
#
# 			mysqlbinlog --read-from-remote-server --host=host_name --raw
# 				binlog.000130 binlog.000131 binlog.000132
#
# 			mysqlbinlog --read-from-remote-server --host=host_name --raw
# 				--to-last-log binlog.000130
#
# 		The first command specifies every file name explicitly. The second names only the first file and uses --to-last-log
# 		to read through the last.
#
# 		A difference between these commands is that if the server happens to open binlog.000130 before mysqlbinlog reaches the
# 		end of binlog.000132, the first command will not read it - but the second will.
#
# 		To make a live backup in which mysqlbinlog starts with binlog.000130 to copy existing log files - then stays
# 		connected to copy new events as the server generates them:
#
# 			mysqlbinlog --read-from-remote-server --host=host_name --raw --stop-never binlog.000130
#
# 		With --stop-never, it is not nessecary to specify --to-last-log to read to the last log file because that option is implied.
#
# The following pertains to Output File Naming
#
# Without --raw, mysqlbinlog produces text output and the --result-file option, if given - specifies the name of the single file
# to which all output is written.
#
# With --raw, mysqlbinlog writes one binary output file for each log file transferred from the server.
# By default, mysqlbinlog writes the files in the current directory with the same name as the original log files.
#
# To modify the output file names, use the --result-file option. In conjunction with --raw, the --result-file option
# value is treated as a prefix that modifies the output file names.
#
# Suppose that a server currently has binary log files named binlog.000999 and up.
# If you use mysqlbinlog --raw to back up the files, the --result-file option produces
# output file names as shown soon.
#
# You can write the files to a specific directory by beginning the --result-file value with the directory path.
# If the --result-file value consists only of a directory name - the value must end with the pathname separator char.
#
# Output files are overwritten if they exist:
#
# 	--result-file OPTION 		OUTPUT FILE NAMES
# --result-file=x 				xbinlog.000999 and up
# --result-file=/tmp/ 			/tmp/binlog.000999 and up
# --result-file=/tmp/x 			/tmp/xbinlog.000999 and up
#
# The following is an example of using mysqldump + mysqlbinlog for Backup and Restore
#
# The following example describes a simple scenario that shows how to use mysqldump and mysqlbinlog together to back
# up a server's data and binary log - and how to use the backup to restore the server if data loss happens.
#
# The example assumes that the server is running on host <host_name> and its first binary log file is named
# binlog.000999. 
#
# Make a continous backup of the bin log:
#
# mysqlbinlog --read-from-remote-server --host=host_name --raw
# 	--stop-never binlog.000999
#
# We can also use mysqldump to make a dump file which acts as a snapshot of the server's data.
#
# Use --all-databases, --events, and --routines to back up all data and --master-data=2 to include the
# current bin log co-ords in the dump file.
#
# mysqldump --host=host_name --all-databases --events --routines --master-data=2> <dump_file> #Select all the data, include binary log co-ords in the dump
#
# We can execute above to make snaphots. 
#
# To restore by usage of a dump file:
#
# mysql --host=host_name -u root -p < <dump_file>
#
# Assuming the binlog file looks as follows:
#
# -- CHANGE MASTER TO MASTER_LOG_FILE='binlog.001002', MASTER_LOG_POS=27284;
#
# If the most recent is binlog.001004, you can re-execute log events as follows:
#
# mysqlbinlog --start-position=27284 binlog.001002 binlog.001003 binlog.001004 | mysql --host=host_name -u root -p
#
# We may also copy the backup files to the server, if we do not have root access.
#
# The following covers how to Specify mysqlbinlog Server ID
#
# When invoked with the --read-from-remote-server option, mysqlbinlog connects to a MySQL server,
# specifies a server ID to identify itself - requests binary log files.
#
# We can use mysqlbinlog to request log files from a server in several ways:
#
# Specify an explicit named set of files: For each file, mysqlbinlog connects and issues a Binlog dump command.
# The server sends the file and disconnects. There is one connection per file.
#
# Specify the beginning file and --to-last-log: mysqlbinlog connects and issues a Binlog dump command for all files.
# The server sends all the files and disconnects.
#
# Specify the beginning file and --stop-never (implies --to-last-log): mysqlbinlog connects and issues a Binlog dump
# command for all files. The server sends all files - but does not disconnect after sending the last one.
#
# If we use --read-from-remote-server only - mysqlbinlog connects using a server ID of 0 - which tells the server to disconnect
# after sending the last requested log file.
#
# With --read-from-remote-server and --stop-never, mysqlbinlog connects using a nonzero server ID, so the server does not
# disconnect after sending the last log file. The server ID is 1 by default, but can be changed with --connection-server-id.
#
# Thus, for the first two ways of requesting files, the server disconnects because mysqlbinlog specifies a server ID of 0.
# Does not disconnect if --stop-never is given because mysqlbinlog specifies a nonzero server ID.
#
# The following covers mysqldumpslow - Summarizing Slow Query Log Files
#
# The MySQL slow query log contains info about queries that take a long time to execute.
# mysqldumpslow parses MySQL slow query log files and prints a summary of their contents.
#
# Normally - mysqldumpslow groups queries that are similar except for the particular values of number and
# string data values. It "abstracts" these values to N and 'S' when displaying summary output.
#
# The -a and -n options can be used to modify value abstracting behavior.
#
# Invoke as follows:
#
# mysqldumpslow [<options>] [<log_file> ...]
#
# The following options pertain to mysqldumpslow:
#
# -a 		   Do not abstract all numbers to N and strings to S
# -n 		   Abstract numbers with at least the specified digits
# --debug   Write debug information
# -g 		   Only consider statements that match the pattern
# --help    Display help message and exit
# -h 		   Host name of the server in the log file name
# -i 		   Name of the server instance
# -l 		   Do not subtract lock time from total time
# -r 		   Reverse the sort order
# -s 		   How to sort output
# -t 		   Display only first num queries
# --verbose Verbose mode
#
# The following covers dynamics in more detail:
#
# --help - Display help message and exit
# -a - Do not abstract all numbers to N and strings to 'S'
# --debug, -d - Run in debug mode
# -g <pattern> - Consider only queries that match the (grep-style) pattern
# -host, <host_name> - Host name of the MySQL server for *-slow.log file name.
# 							  Can contain wildcard. Default wildcard is *
# -i <name> - Name of server instance (if using mysql.server startup script)
# -l - Do not subtract lock time from total time
# -n <N> - Abstract numbers with at least <N> digits within names
# -r - Reverse the sort order
# -s <sort_Type> - How to sort the output. The value of <sort_type> should be chosen from the following list:
# 						
# 						 		t, at: Sort by query time or average query time
# 								l, al: Sort by lock time or average lock time
# 								r, ar: Sort by rows sent or average rows sent
# 								c: Sort by count
#
# 								By default, it sorts by average query time (same as -s at)
#
# -t <N> - Display only the first <N> queries in the output.
# --verbose, -v - Verbose mode. 
#
# Example output:
#
# mysqldumpslow
#
# Reading mysql slow query log from /usr/local/mysql/data/mysqld51-apple-slow.log
# Count: 1 	Time=4.32s (4s) 	Lock=0.00s 	(0s) 		Rows=0.0 (0), 	root[root]@localhost
# 	insert into t2 select * from t1
#
# Count: 3 Time=2.53s (7s) Lock=0.00s (0s) 		Rows=0.0 (0), root[root]@localhost
# 	insert into t2 select * from t1 limit N
#
# Count: 3 Time=2.13s (6s) Lock=0.00s (0s) 		Rows=0.0 (0), root[root]@localhost
# 	insert into t1 select * from t1
#
# The following covers MySQL Program Development Utilities
#
# In shell scripts, you can use the my_print_defaults program to parse option files and 
# see what options would be used by a given program.
#
# The following example shows the output that my_print_defaults might produce when asked to show
# the options found in the [client] and [mysql] groups:
#
# my_print_defaults client mysql
# --port=3306
# --socket=/tmp/mysql.sock
# --no-auto-rehash
#
# Option file handling is implemented in the C client lib simply by processing all options in the
# appropiate group or groups before any CMDline args.
#
# The following pertains to mysql_config - A utility to display options for Compiling Clients
#
# mysql_config provides you with useful information for compiling your MySQL client and connecting it to MySQL.
# It's a shell script.
#
# Note: pkg-config can be used as an alternative to mysql_config for obtaining info such as compiler flags
# or link libraries required to compile MySQL apps.
#
# mysql_config supports the following:
#
# --cflags - C compiler flags to find include files and critical compiler flags - defines used when compiling the libmysqlclient lib.
# 				 The options returned are tied to the specific compiler that was used when the library was created and might 
# 				 clash with the settings for your own compiler.
#
# 				 Using --include is more integratable in relation to portable options that contain only include paths.
#
# --cxxflags - Like -cflags, but for C++ compiler flags
#
# --include - Compiler options to find MySQL include files
#
# --libs - Libs and options required to link with the MySQL client lib.
#
# --libs r - Libs and options required to link with the thread-safe MySQL client lib.
# 				 In MySQL 8.0, all client libs are thread-safe. --libs can be used in all cases.
#
# --plugindir - Default plugin dir path name, defined when configuring MySQL
#
# --port - Default TCP/IP port number, defined when configuring MySQL
#
# --socket - Default Unix socket file, defined when configuring MySQL
#
# --variable=<var_name> - Display the value of the named config variable. 
# 								  Permitted <var_name> values are pkgincludedir (header file dir),
# 						        pkglibdir (the lib dir),
# 								  plugindir (the plugin dir)
#
# --version - Version number for MySQL distri
#
# If you invoke mysql_config with no options, it displays a list of all options that it supports and their values:
#
# mysql_config
# Usage: 	/usr/local/mysql/bin/mysql_config [options]
# Options:
# 	--cflags 		[-I/usr/local/mysql/include/mysql -mcpu=pentiumpro]
#  --cxxflags 		[-I/usr/local/mysql/include/mysql -mcpu=pentiumpro]
#  --include 		[-I/usr/local/mysql/include/mysql]
# 	--libs 			[-L/usr/local/mysql/lib/mysql -lmysqlclient
# 						 -lpthread -lm -lrt -lssl -lcrypto -ldl]
#  --libs_r 		[-L/usr/local/mysql/lib/mysql -lmysqlclient_r
# 						 -lpthread -lm -lrt -lssl -lcrypto -ldl]
#  --plugindir 	[/usr/local/mysql/lib/plugin]
# 	--socket 		[/tmp/mysql.sock]
# 	--port 			[3306]
#  --version 		 [5.8.0-m17]
#  --variable=<VAR> VAR is one of :
# 			pkgincludedir 	[/usr/local/mysql/include]
# 			pkglibdir 		[/usr/local/mysql/lib]
# 			plugindir 		[/usr/local/mysql/lib/plugin]
#
# We can use mysql_config within a CMD line using backticks to include output for particular options.
# For example, we can compile and link a MySQL client program as follows:
#
# gcc -c `mysql_config --cflags` progname.c
# gcc -o progname progname.o `mysql_config --libs`
#
# The following pertains to my_print_defaults - Used for Display Options from Option Files
#
# https://dev.mysql.com/doc/refman/8.0/en/my-print-defaults.html
# 
# https://dev.mysql.com/doc/refman/8.0/en/mysqlbinlog-backup.html