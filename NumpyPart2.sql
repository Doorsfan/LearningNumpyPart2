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
# my_print_defaults displays the options that are present in option groups of option files. 
# The output indicates what options will be used by programs that read the specified option
# groups.
#
# For example, the mysqlcheck program reads the [mysqlcheck] and [client] option groups.
# To see what options are present in thoose groups in the standard option files, invoke the
# my_print_defaults as follows:
#
# my_print_defaults mysqlcheck client
# --user=myusername
# --password=password
# --host=localhost
#
# The output consists of options - one a line.
#
# The following options are supported in terms of my_print_defaults:
#
# --help, -? - Display a help message and exit
#
# --config-file=<file name>, - Read only the given option file
# --defaults-file=<file name>,
#  -c <file_name>
#
# --debug=<debug options>, - Write a debugging log. A typical <debug_options> string is d:t:o, <file_name>.
#  -# <debug_options> 		  Defaults to d:t:o, /tmp/my_print_defaults.trace
#
# --defaults-extra-file=<file name>, - Read this option file after global option file (but on Unix) before the user option file.
# --extra-file=<file name>,
#  -e <file_name>
#
# --defaults-group-suffix=<suffix>, - Suffix regex match option groups
#  -g <suffix>
# --login-path=<name>, - Read options from the named login path in the .mylogin.cnf login path file.
#  -L <name>
# --no-defaults, -n - Return an empty string
# --show, -s - my_print_defaults masks PWs by default. Use this to display in cleartext.
# --verbose, -v - Verbose mode.
# --version, -V - Version info and exit
#
# The following pertains to resolve_stack_dump - Used to resolve Numeric Stack Trace Dump to Symbols
#
# resolve_stack_dump resolves a numeric stack dump to symbols.
#
# Invoke:
#
# resolve_stack_dump [<options>] <symbols_file> [<numeric_dump_file>]
#
# The symbols file should include the output from the nm --numeric-sort mysqld command.
# The numeric dump file should contain a numeric stack track from mysqld.
# If no numeric dump file is named on the command line, the stack trace is read from the standard input.
#
# resolve_stack_dump supports the following options:
#
# --help, -h - Display a help message and exit.
# --numeric-dump-file=<file name>, -n <file_name> - Read the stack trace from the given file.
# --symbols-file=<file name>, -s <file_name> - Use the given symbols file.
# --version, -V - Display version info and exit.
#
# The following covers lz4_decompress - Decompress mysqlpump LZ4-Compressed Output
#
# The lz4_decompress utility decompresses mysqlpump output that was created using LZ4 compression.
#
# NOTE: If MySQL was configured with the -DWITH LZ4=system option, lz4_decompress is not built.
# 	     In this case, the system lz4 command can be used instead.
#
# Invoke lz4_decompress like this:
# lz4_decompress <input_file> <output_file>
#
# Example of usage:
#
# mysqlpump --compress-output=LZ4 > dump.lz4
# lz4_decompress dump.lz4 dump.txt
#
# To see help messages in relation to lz4_decompress, run it with no args.
# To decompress mysqlpump ZLIB-compressed output, use zlib_decompress.
#
# The following pertains to perror - Which displays error messages:
#
# perror displays the error message for MySQL or operating system error codes.
#
# perror [<options>] <errorcode> ...
#
# perror attempts to be flexible in understanding args. For example - 
#
# ER WRONG VALUE FOR VAR - can be translated as 1231, 001231, MY-1231 or MY-001231 or ER WRONG VALUE FOR VAR
#
# shell>perror 1231
# MySQL error code MY-001231 (ER_WRONG_VALUE_FOR_VAR): Variable '%-.64s' can't be set to the value of '%-.200s'
#
# If a error number is in the range where MySQL and OS sys errors overlap, perror displays both error messages:
# 
# perror 1 13
# OS error code 1: Operation not permitted
# MySQL error code MY-000001: Can't create/write to file '%s' (OS errno %d - %s)
# OS error code 13: Permission denied
# MySQL error code MY-000013: Can't get stat of '%s' (OS errno %d - %s)
#
# To obtain the error message for a MySQL Cluster error code, invoke perror with the --ndb option:
#
# perror --ndb <errorcode>
#
# The meaning of system error messages may be dependent on the OS. 
#
# perror supports the following options:
#
# --help, --info, -I, -? - Display a help message and exit
# --ndb - print the error message for a MySQL Cluster error code
# --silent, -s - Silent mode. Print only the error message
# --verbose, -v - Verbose mode
# --version, -V - Version info and exit
#
# The following covers the dynamics of resolveip - Resolve Host name to IP Address or Vice Versa
#
# The resolveip utility resolves host names to IP addresses and vice versa.
#
# Invoke as follows:
#
# resolveip [<options>] {<host_name>|<ip-addr>} ...
#
# Supports the following options:
#
# --help, --info, -?, -I - Display a help message and exit
# --silent, -s - Silent mode.
# --version, -V - Display version info and exit.
#
# The following options cover zlib_decompress - Decompress mysqlpump ZLIB-Compressed Output
#
# The zlib_decompress utility decompresses mysqlpump output that was created using ZLIB compression.
#
# Note: If we configured MySQL with the -DWITH ZLIB=system option, zlib_decompress is not built.
# 		  Then we can use openssl zlib instead.
#
# To use zlib_decompress:
#
# zlib_decompress <input_file> <output_file>
#
# Example:
#
# mysqlpump --compress-output=ZLIB > dump.zlib
# zlib_decompress dump.zlib dump.txt
#
# To see a help message, just run zlib_decompress with no args.
#
# To decompress mysqlpump LZ4-compressed output, use lz4_decompress.
#
# The following pertains to MySQL Program Env Variables:
#
# VARIABLE 										Desc
# AUTHENTICATION_PAM_LOG 				PAM authentication plugin debug logging settings
# CC 											The name of your C compiler (for running CMake)
# CXX 										Name of your C++ compiler (for running CMake)
# CC 											Name of your C compiler (for running CMake)
# DBI_USER 									Default user name for Perl DBI
# DBI_TRACE 								Trace options for Perl DBI
# HOME 										The default path for the mysql history file is $HOME/.mysql_history
# LD_RUN_PATH 								Used to specify the location of libmysqlclient.so
# LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN  Enable mysql_clear_password auth plugin
#
# LIBMYSQL_PLUGIN_DIR 					Dir in which to look for client plugins
# LIBMYSQL_PLUGINS 						Client plugins to preload
# MYSQL_DEBUG 								Debug trace options when debugging
# MYSQL_GROUP_SUFFIX 					Option group suffix value (like specifying --defaults-group-suffix)
# MYSQL_HISTFILE 							The path to the mysql history file. If this var is set, its value overrides the default for $HOME/.mysql_history
# MYSQL_HISTIGNORE 						Patterns specifying statements that mysql should not log to $HOME/.mysql_history or syslog if --syslog is given
#
# MYSQL_HOME 								The path to the dir in which the server-specific my.cnf file resides
# MYSQL_HOST 								Default host name used by the mysql cmd line client
# MYSQL_OPENSSL_UDF_DH_BITS 			Maximum key length for CREATE DH PARAMETERS()
#                _THRESHOLD
# MYSQL_OPENSSL_UDF_DSA_BITS 			Maximum DSA key length for CREATE ASYMMETRIC PRIV KEY()
# 					  _THRESHOLD 
# MYSQL_OPENSSL_UDF_RSA_BITS 			Maximum RSA key length for CREATE ASYMMETRIC PRIV KEY()
# 					  _THRESHOLD
# MYSQL_PS1 								The cmd prompt to use use in the mysql cmd line 
# MYSQL_PWD 								The default PW when connecting to mysqld. Insecure.
# MYSQL_TCP_PORT 							Default TCP/IP port number
# MYSQL_TEST_LOGIN_FILE 				The name of the .mylogin.cnf login path file
# MYSQL_TEST_TRACE_CRASH 				Whether the test protocol trace plugin crashes clients.
# MYSQL_TEST_TRACE_DEBUG 				Whether the test protocol trace plugin produces output.
# MYSQL_UNIX_PORT 						The default Unix socket file name, used for connections to localhost
# MYSQLX_TCP_PORT 						The X plugin default TCP/IP port number
#
# MYSQLX_UNIX_PORT 						The X Plugin default Unix socket file name; used for connections to localhost
# NOTIFY_SOCKET 							Socket used by mysqld to communicate with systemd
# PATH 										Used by the shell to find MySQL programs.
# PKG_CONFIG_PATH 						Location of mysqlclient.pc pkg-config file.
# TMPDIR 									The dir in which temp files are created.
# TZ 											Should be set to your local time zone
# UMASK 										The user-file creation mode when creating files
# UMASK_DIR 								The user-directory creation mode when creating dirs
# USER 										The default user name on Windows when connecting to Mysqld
#
# MYSQL_TEST_LOGIN_FILE is the path name of the login path file (the file created by mysql_config_editor).
#
# If not set, the default value is %APPDATA%\MySQL\.mylogin.cnf dir on Windows and $HOME/.mylogin.cnf on non Windows OS's
#
# The MYSQL_TEST_TRACE_DEBUG and MYSQL_TEST_TRACE_CRASH vars control the test protocol trace client plugin,
# if MySQL is built with that plugin enabled.
#
# The default UMASK and UMASK_DIR values are 0640 and 0750, respectively.
#
# MySQL assumes that the value for UMASK or UMASK_DIR is in octal if it starts with a zero.
# For example, setting UMASK=0600 is equivalent to UMASK=384 because 0600 Octal is 384 decimal.
#
# UMASK and UMASK_DIR, are not masks, they are modes.
#
# If UMASK is set, mysqld uses ($UMASK | 0600) as the mode for file creation, so that newly created files have a mode in the range
# from 0600 to 0666 (octal values)
#
# If UMASK_DIR is set, mysqld uses ($UMASK_DIR | 0700) as the base mode for dir creation, which is AND supplemented with ~(~$UMASK & 0666)
# so that newly created dirs have a mode in the range from 0700 to 0777.
#
# The AND may remove read and write permissions from the dir mode, but not execute permissions.
#
# We might need to set PKG_CONFIG_PATH if we use pkg-config in terms of MySQL programs
#
# The following covers MySQL Server Administration
#
# MySQL Server (mysqld) is the main program that does most of the work in a MySQL installation.
# The following will cover:
#
# Server configuration
# The dara dir, particularly the mysql system db
# The server log files
# Management of multiple servers on a single machine
#
# The following covers The MySQL Server
#
# mysqld is the MySQL server. The following will cover:
#
# Startup options that the server supports. You can specify these options on the cmd line, through config files or both.
#
# Server system vars. These vars reflect the current state and values of the startup options, some of which can be modified while the server is running
#
# Server status vars. These vars contain counters and stats about runtime operations
#
# How to set the server SQL mode. Modifies certain aspects of SQL syntax and semantics, for example for compability
# with code from other DBs or to control the error handling for specific situations
#
# Configuring and using IPv6 support
#
# Configuring and using time zone support
#
# Server-side help capabilities
#
# The server shutdown process. Performance and reliability considerations depending on type of table (transactional or nontransactional) and whether to use replication.
#
# NOTE: Not all storage engines are supported by all MySQL server bins and configs.
#
# The following section covers how to configure the Server.
#
# The MySQL server, mysqld has many command options and system vars that can be set at startup to configure its operation.
# To determine the default command option and system var values used by the server:
#
# mysqld --verbose --help
#
# The command produces a list of all mysqld options and config system vars. 
# Its output includes the default option and var values, might look like:
#
# abort-slave-event-count 			0
# allow-suspicious-udfs 			FALSE
# archive 								ON
# auto-increment-increment 		1
# auto-increment-offset 			1
# autocommit 							TRUE
# automatic-sp-privileges 			TRUE
# avoid-temporal-upgrade 			FALSE
# back-log 								80
# basedir 								/home/jon/bin/mysql-8.0/
# ...
# tmpdir 								/tmp
# transaction-alloc-block-size 	8192
# transaction-isolation 			REPEATABLE-READ
# transaction-prealloc-size 		4096
# transaction-read-only 			FALSE
# transaction-write-set-extraction OFF
# updatable-views-with-limit 		YES
# validate-user-plugins 			TRUE
# verbose 								TRUE
# wait-timeout 						28800
#
# To see the system vars in use on the server:
#
# SHOW VARIABLES;
#
# To see some stats and status indicators for a running server:
#
# SHOW STATUS;
#
# We can also see system vars and status through mysqladmin:
#
# mysqladmin variables
# mysqladmin extended-status
#
# Options set on cmd line are only in effect for that session, for permanance use OPtion files.
#
# The following pertains to Server Configuration Defaults:
#
# The MySQL server has many operating params, which you can change at server startup using cmd line options or config files.
# We can also change params at runtime.
#
# On Windows, the MySQL installer interacts with the user and creates a file named my.ini in the base install dir as the default option file
#
# NOTE: The extension on Windows might not be displayed (in terms of .ini or .cnf)
#
# After completing the installation process, you can edit the default option file at any time to modify the params.
#
# On non Windows, no default option file is made in terms of installation. Without a option file, it just runs with defaults.
# 
# The following pertains to Server Options, System vars and Status Vars
#
# The following contains all cmd line options, system vars, and status vars within mysqld.
#
# Cmd line options, System vars, Status vars:
#
# Name 													CMD-line 					Option file 				System Var 				Status Var 			Var Scope 		Dynamic
# abort-slave-event-count 							Yes 							Yes 							
# Aborted_clients 																																Yes 					Global 			No
# Aborted_connects 																																Yes 					Global 			No
# Acl_cache_items_count 																														Yes 					Global 			No
# activate_all_roles_on_login 					Yes 							Yes 							Yes 												Global 			Yes
# allow-suspicious-udfs 							Yes 							Yes 							
# ansi 													Yes 							Yes
# audit-log 											Yes 							Yes
# audit_log_buffer_size 							Yes 							Yes 							Yes 												Global 			No
# audit_log_compression 							Yes 							Yes 							Yes 												Global 			No
# audit_log_connection_policy 					Yes 							Yes 							Yes 												Global 			Yes
# audit_log_current_session 																						Yes						   					Both 				No
#
# audit_log_current_size 																														Yes 					Global 			No
# audit_log_encryption 								Yes 							Yes 							Yes 												Global 			No
# Audit_log_event_max_drop_size 																												Yes 					Global 			No
# Audit_log_events 																																Yes 					Global 			No
# Audit_log_events_filtered 																													Yes 					Global 			No
# Audit_log_events_lost 																														Yes 					Global 			No
# Audit_log_events_written 																													Yes 					Global 			No
#
# audit_log_exclude_accounts 						Yes 							Yes 							Yes 												Global 			Yes
# audit_log_file 										Yes 							Yes 							Yes 												Global 			No
# audit_log_filter_id 																								Yes												Both 				No
# audit_log_flush 																									Yes 												Global 			Yes
# audit_log_format 									Yes 							Yes 							Yes 												Global 			No
# audit_log_include_accounts 						Yes 							Yes 							Yes 												Global 			Yes
# audit_log_policy 									Yes 							Yes 							Yes 												Global 			No
# audit_log_read_buffer_size 						Yes 							Yes 							Yes 												Varies 			Varies
# audit_log_rotate_on_size 						Yes 							Yes 							Yes 												Global 			Yes
#
# audit_log_statement_policy 						Yes 							Yes 							Yes 												Global 			Yes
# audit_log_strategy 								Yes 							Yes 							Yes 												Global 			No
# Audit_log_total_size 																															Yes 					Global 			No
# Audit_log_write_waits 																														Yes 					Global 			No
# authentication_ldap_sasl_auth_method_name 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_bind_base_dn 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_bind_root_dn 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_bind_root_pwd 		Yes 							Yes 							Yes 												Global 			Yes
#
# authentication_ldap_sasl_ca_path 				Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_group_search_attr Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_group_search_ 		Yes 							Yes 							Yes 												Global 			Yes
# filter
# authentication_ldap_sasl_init_pool_size 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_log_status 			Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_max_pool_size 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_server_host 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_server_port 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_tls 					Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_sasl_user_search_attr 	Yes 							Yes 							Yes 												Global 			Yes
#
# authentication_ldap_simple_auth_method_ 	Yes 							Yes 							Yes 												Global 			Yes
# name
# authentication_ldap_simple_bind_base_dn 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_bind_root_dn 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_bind_root_pwd 	Yes 							Yes 							Yes 												Global 			yes
# authentication_ldap_simple_ca_path 			Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_group_ 			Yes 							Yes 							Yes 												Global 			Yes
# search_attr
# authentication_ldap_simple_int_pool_size 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_log_status 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_max_pool_size 	Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_server_host 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_server_port 		Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_tls 				Yes 							Yes 							Yes 												Global 			Yes
# authentication_ldap_simple_user_ 				Yes 							Yes 							Yes 												Global 			Yes
# search_attr
# 
# authentication_windows_log_level 				Yes 							Yes 							Yes 												Global 			No
# authentication_windows_use_principal_name 	Yes 							Yes 							Yes 												Global 			No
# auto_generate_certs 								Yes 							Yes 							Yes 												Global 			No
# auto_increment_increment 																						Yes 												Both 				Yes
# auto_increment_offset 																							Yes 												Both 				Yes
# autocommit 											Yes 							Yes 							Yes 												Both 				Yes
# automatic_sp_privileges 																							Yes 												Global 			Yes
# avoid_temporal_upgrade 							Yes 							Yes 							Yes 												Global 			Yes
# back_log																												Yes 												Global 			No
# basedir 												Yes 							Yes 							Yes 												Global 			No
# 
# big-tables 											Yes 							Yes 																				Both 				Yes
# - Variable: big_tables 																							Yes 												Both 				Yes
# bind-address 										Yes 							Yes 																				Global 			No
# - Variable: bind_address 																						Yes 												Global 			No
# Binlog_cache_disk_use 																														Yes 					Global 			No
# binlog_cache_size 							 		Yes 							Yes 							Yes 												Global 			Yes
#
# Binlog_cache_use 																																Yes 					Global 			No
# binlog-checksum 									Yes 							Yes 							
# binlog_checksum 																									Yes 												Global 			Yes
# binlog_direct_non_transactional_updates 	Yes 							Yes 							Yes												Both 				Yes
# binlog-do-db 										Yes 							Yes 
# binlog_error_action 								Yes 							Yes 							Yes 												Global 			Yes
# binlog_expire_logs_seconds 						Yes 							Yes 							Yes 												Global 			Yes
# binlog-format 										Yes 							Yes 																				Both 				Yes
# - Variable: binlog_format 																						Yes 												Both 				Yes
# binlog_group_commit_sync_delay 				Yes 							Yes 							Yes 												Global 			Yes
# binlog_group_commit_sync_no_delay_count 	Yes 							Yes 							Yes 												Global 			Yes
# binlog_gtid_simple_recovery 					Yes 							Yes 							Yes 												Global 			No
# binlog-ignore-db									Yes 							Yes 
# binlog_max_flush_queue_time 																					Yes 												Global 			Yes
# binlog_order_commits 																								Yes 												Global 			Yes
# binlog-row-event-max-size 						Yes 							Yes 	
# binlog_row_image 									Yes 							Yes 							Yes 												Both 				Yes
# binlog_row_metadata 								Yes 							Yes 							Yes 												Global 			Yes
# binlog_row_value_options 						Yes 							Yes 							Yes 												Both 				Yes
# 
# binlog-rows-query-log-events 					Yes 							Yes 
# -Variable: binlog_rows_query_log_events 	
# binlog_rows_query_log_events 					Yes 							Yes 							Yes 												Both 				Yes
# Binlog_stmt_cache_disk_use 																														Yes 				Global 			No
# binlog_stmt_cache_size 							Yes 							Yes 							Yes 												Global 			Yes
# Binlog_stmt_cache_use 																															Yes 				Global 			No
# binlog_transaction_dependency_history_size Yes 							Yes 							Yes 												Global 			Yes
# binlog_transaction_dependency_tracking 		Yes 							Yes 							Yes 												Global 			Yes
# block_encryption_mode 							Yes 							Yes 							Yes 												Both 				Yes
# bulk_insert_buffer_size 							Yes 							Yes 							Yes 												Both 				Yes
# Bytes_received 																																		Yes 				Both 				No
# Bytes_sent 																																			Yes 				Both 				No
# caching_sha2_password_auto_ 					Yes 							Yes 							Yes 												Global 			No
# generate_rsa_keys
# caching_sha2_password_private_key_path 		Yes 							Yes 							Yes 												Global 			No
# caching_sha2_password_public_key_path 		Yes 							Yes 							Yes 												Global 			No
# Caching_sha2_password_rsa_public_key 																										Yes 				Global 			No
# character_set_client 																								Yes 												Both 				Yes
# character-set-client-handshake 				Yes 							Yes 
# character_set_connection 																						Yes 												Both 				Yes
# character_set_database (note 1) 																				Yes 												Both 				Yes
# character-set-filesystem 						Yes 							Yes 																				Both 				Yes
# -Variable: character_set_filesystem 																			Yes 												Both 				Yes
# character_set_results 																							Yes 												Both 				Yes
# character-set-server 								Yes 							Yes 																				Both 				Yes
# -Variable: character_set_server 																				Yes 												Both 				Yes
# character_set_system 																								Yes 												Global 			No
# character-sets-dir 								Yes 							Yes 																				Global 			No
#
# -Variable: character_sets_dir 																					Yes 												Global 			No
# check_proxy_users 									Yes 							Yes 							Yes 												Global 			Yes
# chroot 												Yes 							Yes 	
# collation_connection 																								Yes 												Both 				Yes
# collation_database (note 1) 																					Yes 												Both 				Yes
# collation-server 									Yes 							Yes 																				Both 				Yes
# -Variable: collation_server 																					Yes 												Both 				Yes
# Com_admin_commands 																																Yes 				Both 				No
# Com_alter_db 																																		Yes 				Both 				No
# Com_alter_event 																																	Yes 				Both 				No
# Com_alter_function 																																Yes 				Both 				No
# Com_alter_procedure 																																Yes 				Both 				No
# Com_alter_resource_group 																														Yes 				Global 			No
# Com_alter_server 																																	Yes 				Both 				No
# Com_alter_table 																																	Yes 				Both 				No
# Com_alter_tablespace 																																Yes 				Both 				No
# Com_alter_user 																																		Yes 				Both 				No
# Com_alter_user_default_role 																													Yes 				Global 			No
#
# Com_analyze 																																			Yes 				Both 				No
# Com_assign_to_keycache 																															Yes 				Both 				No
# Com_begin 																																			Yes 				Both 				No
# Com_binlog 																																			Yes 				Both 				No
# Com_call_procedure 																																Yes 				Both 				No
# Com_change_db 																																		Yes 				Both 				No
# Com_change_master 																																	Yes 				Both 				No
# Com_change_repl_filter 																															Yes 				Both 				No
# Com_check 																																			Yes 				Both 				No
# Com_checksum 																																		Yes 				Both 				No
# Com_commit 																																			Yes 				Both 				No
# Com_create_db																																		Yes 				Both 				No
# Com_create_event 																																	Yes 				Both 				No
# Com_create_function 																																Yes 				Both 				No
#
# Com_create_index 																																	Yes 				Both 				No
# Com_create_procedure 																																Yes 				Both 				No
# Com_create_resource_group 																														Yes 				Global 			No
# Com_create_role 																																	Yes 				Global 			No
# Com_create_server 																																	Yes 				Both 				No
# Com_create_table 																																	Yes 				Both 				No
# Com_create_trigger 																																Yes 				Both 				No
# Com_create_udf 																																		Yes 				Both 				No
# Com_create_user 																																	Yes 				Both 				No
# Com_create_view 																																	Yes 				Both 				No
#
# Com_dealloc_sql 																																	Yes 				Both 				No
# Com_delete 																																			Yes 				Both 				No
# Com_delete_multi 																																	Yes 				Both 				No
# Com_do 																																				Yes 				Both 				No
# Com_drop_db 																																			Yes 				Both 				No
# Com_drop_event 																																		Yes 				Both 				No
# Com_drop_function 																																	Yes 				Both 				No
# Com_drop_index 																																		Yes 				Both 				No
# Com_drop_procedure 																																Yes 				Both 				No
# Com_drop_resource_group 																															Yes 				Global 			No
# Com_drop_role 																																		Yes 				Global 			No
# Com_drop_server 																																	Yes 				Both 				No
# Com_drop_table 																																		Yes 				Both 				No
# Com_drop_trigger 																																	Yes 				Both 				No
# Com_drop_user 																																		Yes 				Both 				No
# Com_drop_view 																																		Yes 				Both 				No
# Com_empty_query 																																	Yes 				Both 				No
# Com_execute_sql 																																	Yes 				Both 				No
#
# Com_explain_other 																																	Yes 				Both 				No
# Com_flush 																																			Yes 				Both 				No
# Com_get_diagnostics 																																Yes 				Both 				No
# Com_grant  																																			Yes 				Both 				No
# Com_grant_roles																																		Yes 				Global 			No
# Com_group_replication_start 																													Yes 				Global 			No
# Com_group_replication_stop 																														Yes 				Global 			No
# Com_ha_close 																																		Yes 				Both 				No
# Com_ha_open 																																			Yes 				Both 				No
# Com_ha_read 																																			Yes 				Both 				No
# Com_help 																																				Yes 				Both 				No
#
# Com_insert 																																			Yes 				Both 				No
# Com_insert_select 																																	Yes 				Both 				No
# Com_install_component 																															Yes 				Global 			No
# Com_install_plugin 																																Yes 				Both 				No
# Com_kill 																																				Yes 				Both 				No
# Com_load 																																				Yes 				Both 				No
# Com_lock_tables 																																	Yes 				Both 				No
# Com_optimize 																																		Yes 				Both 				No
# Com_preload_keys 																																	Yes 				Both 				No
# Com_prepare_sql 																																	Yes 				Both 				No
# Com_purge 																																			Yes 				Both 				No
# Com_purge_before_date 																															Yes 				Both 				No
# Com_release_savepoint 																															Yes 				Both 				No
# Com_rename_table 																																	Yes 				Both 				No
#
# Com_rename_user 																																	Yes 				Both 				No
# Com_repair 																																			Yes 				Both 				No
# Com_replace 																																			Yes 				Both 				No
# Com_replace_select 																																Yes 				Both 				No
# Com_reset 																																			Yes 				Both 				No
# Com_resignal 																																		Yes 				Both 				No
# Com_revoke 																																			Yes 				Both 				No
# Com_revoke_all 																																		Yes 				Both 				No
# Com_revoke_roles 																																	Yes 				Global 			No
# Com_rollback 																																		Yes 				Both 				No
# Com_rollback_to_savepoint 																														Yes 				Both 				No
# Com_savepoint 																																		Yes 				Both 				No
# Com_select 																																			Yes 				Both 				No
# Com_set_option 																																		Yes 				Both 				No
# Com_set_resource_group 																															Yes 				Global 			No
# Com_set_role 																																		Yes 				Global 			No
#
# Com_show_authors 																																	Yes 				Both 				No
# Com_show_binlog_events 																															Yes 				Both 				No
# Com_show_binlogs 																																	Yes 				Both 				No
# Com_show_charsets 																																	Yes 				Both 				No
# Com_show_collations 																																Yes 				Both 				No
# Com_show_contributors 																															Yes 				Both 				No
# Com_show_create_db 																																Yes 				Both 				No
# Com_show_create_event 																															Yes 				Both 				No
# Com_show_create_func 																																Yes 				Both 				No
# Com_show_create_proc 																																Yes 				Both 				No
# Com_show_create_table 																															Yes 				Both 				No
# Com_show_create_trigger 																															Yes 				Both 				No
# Com_show_create_user 																																Yes 				Both 				No
# Com_show_databases 																																Yes 				Both 				No
# Com_show_engine_logs 																																Yes				Both 				No
# Com_show_engine_mutex 																															Yes 				Both 				No
# Com_show_engine_status 																															Yes 				Both 				No
# Com_show_errors 																																	Yes 				Both 				No
#
# Com_show_events 																																	Yes 				Both 				No
# Com_show_fields 																																	Yes 				Both 				No
# Com_show_function_code 																															Yes 				Both 				No
# Com_show_function_status 																														Yes 				Both 				No
# Com_show_grants 																																	Yes 				Both 				No
# Com_show_keys 																																		Yes 				Both 				No
# Com_show_master_status 																															Yes 				Both 				No
# Com_show_ndb_status 																																Yes 				Both 				No
# Com_show_new_master 																																Yes 				Both 				No
# Com_show_open_tables																																Yes 				Both 				No
# Com_show_plugins 																																	Yes 				Both 				No
# Com_show_privileges 																																Yes 				Both 				No
# Com_show_procedure_code 																															Yes 				Both 				No
# Com_show_procedure_status 																														Yes 				Both 				No
# Com_show_processlist 																																Yes 				Both 				No
# Com_show_profile 																																	Yes 				Both 				No
# Com_show_profiles 																																	Yes 				Both 				No
# Com_show_relaylog_events 																														Yes 				Both 				No
# Com_show_slave_hosts 																																Yes 				Both 				No
# 
# Com_show_slave_status 																															Yes 				Both 				No
# Com_show_slave_status_nonblocking 																											Yes 				Both 				No
# Com_show_status 																																	Yes 				Both 				No
# Com_show_storage_engines 																														Yes 				Both 				No
# Com_show_table_status 																															Yes 				Both 				No
# Com_show_tables 																																	Yes 				Both 				No
# Com_show_triggers 																																	Yes 				Both 				No
# Com_show_variables 																																Yes 				Both 				No
# Com_show_warnings 																																	Yes 				Both 				No
# Com_shutdown 																																		Yes 				Both 				No
# Com_signal 																																			Yes 				Both 				No
# Com_slave_start 																																	Yes 				Both 				No
# Com_slave_stop 																																		Yes 				Both 				No
# Com_stmt_close 																																		Yes 				Both 				No
# Com_stmt_execute 																																	Yes 				Both 				No
#
# Com_stmt_fetch 																																		Yes 				Both 				No
# Com_stmt_prepare 																																	Yes 				Both 				No
# Com_stmt_reprepare 																																Yes 				Both 				No
# Com_stmt_reset 																																		Yes 				Both 				No
# Com_stmt_send_long_data 																															Yes 				Both 				No
# Com_truncate 																																		Yes 				Both 				No
# Com_uninstall_component 																															Yes 				Global 			No
# Com_uninstall_plugin 																																Yes 				Both 				No
# Com_unlock_tables 																																	Yes 				Both 				No
# Com_update 																																			Yes 				Both 				No
# Com_update_multi 																																	Yes 				Both 				No
# Com_xa_commit 																																		Yes 				Both 				No
# Com_xa_end 																																			Yes 				Both 				No
# Com_xa_prepare 																																		Yes 				Both 				No
# Com_xa_recover 																																		Yes 				Both 				No
# Com_xa_rollback 																																	Yes 				Both 				No
# Com_xa_start 									- 																									Yes 				Both 				No
# completion_type 								Yes 					Yes 									Yes 													Both 				Yes
# Compression 																																			Yes 				Session 			No
# concurrent_insert 								Yes 					Yes 									Yes 													Global 			Yes
# connect_timeout 								Yes 					Yes 									Yes 													Global 			Yes
# 
# Connection_control_delay_generated 																											Yes 				Global 			No
# connection_control_failed_ 					Yes 					Yes 									Yes 													Global 			Yes
# connections_threshold
# connection_control_max_connection_delay Yes 					Yes 									Yes 													Global 			Yes
# connection_control_min_connection_delay Yes 					Yes 									Yes 													Global 			Yes
# Connection_errors_accept 																														Yes 				Global 			No
# Connection_errors_internal 																														Yes 				Global 			No
# Connection_errors_max_connections 																											Yes 				Global 			No
# Connection_errors_peer_address 																												Yes 				Global 			No
# Connection_errors_select 																														Yes 				Global 			No
# Connection_errors_tcpwrap 																														Yes 				Global 			No
# Connections 																																			Yes 				Global 			No
# console 											Yes 					Yes 
# core-file 										Yes 					Yes
# core_file 																										Yes 													Global 			No
# Created_tmp_disk_tables 																															Yes 				Both 				No
# Created_tmp_files 																																	Yes 				Global 		 	No
# Created_tmp_tables 																																Yes 				Both 				No
# cte_max_recursion_depth 						Yes 					Yes 									Yes 													Both 				Yes
# daemon_memcached_enable_binlog 			Yes 					Yes 									Yes 													Global 			No
# daemon_memcached_engine_lib_name 			Yes 					Yes 									Yes 													Global 			No
# daemon_memcached_engine_lib_path 			Yes 					Yes 									Yes 													Global 			No
# daemon_memcached_option 						Yes 					Yes 									Yes 													Global 			No
#
# daemon_memcached_r_batch_size 				Yes 					Yes 									Yes 													Global 			No
# daemon_memcached_w_batch_size 				Yes 					Yes 
# daemonize 										Yes 					Yes
# datadir 											Yes 					Yes 									Yes 													Global 			No
# date_format 																										Yes 													Global 			No
# datetime_format 																								Yes 													Global 			No
# debug 												Yes 					Yes 									Yes 													Both 				Yes
# debug_sync 																										Yes 													Session 			Yes
# debug-sync-timeout 							Yes 					Yes 	
# default_authentication_plugin 				Yes 					Yes 									Yes 													Globla 			No
# default_collation_for_utf8mb4 										Yes 									Yes 													Both 				Yes
# default_password_lifetime 					Yes 					Yes 									Yes 													Global 			Yes
# default-storage-engine 						Yes 					Yes 																							Both 				Yes
# -Variable: default_storage_engine 																		Yes 													Both 				Yes
# default-time-zone 								Yes 					Yes 
# default_tmp_storage_engine 					Yes 					Yes 									Yes 													Both 				Yes
# default_week_format 							Yes 					Yes 									Yes 													Both 				Yes
# defaults-extra-file 							Yes
# defaults-file 									Yes
# defaults-group-suffix 						Yes
# delay-key-write 								Yes 					Yes 																							Global 			Yes
# - Variable: delay_key_write 																				Yes 													Global 			Yes
# Delayed_errors 																																			Yes 			Global 			No
# 
# delayed_insert_limit 							Yes 					Yes 									Yes 													Global 			Yes
# Delayed_insert_threads 																																Yes 			Global 			No
# delayed_insert_timeout 						Yes 					Yes 									Yes 													Global 			Yes
# delayed_queue_size 							Yes 					Yes 									Yes 													Global 			Yes
# Delayed_writes 																																			Yes 			Global 			No
# des-key-file 									Yes 					Yes 
# disabled_storage_engines 					Yes 					Yes 									Yes 													Global 			No
# disconnect_on_expired_password 			Yes 					Yes 									Yes 													Global 			No
# disconnect-slave-event-count 				Yes 					Yes 
# div_precision_increment 						Yes 					Yes 									Yes 													Both 				Yes
# dragnet.log_error_filter_rules 			Yes 					Yes 									Yes 													Global 			Yes
# dragnet.Status 																																			Yes 			Global 			No
# early-plugin-load 								Yes 					Yes 
# enable-named-pipe 								Yes 					Yes
# - Variable: named_pipe 
# end_markers_in_json 																							Yes 													Both 				Yes
# enforce-gtid-consistency 					Yes 					Yes 									Yes 													Global 			Yes
# enforce_gtid_consistency 					Yes 					Yes 									Yes 													Global 			Yes
# eq_range_index_dive_limit 																					Yes 													Both 				Yes
# 
# error_count 																										Yes 													Session 			No
# event-scheduler 								Yes 					Yes 																							Global 			Yes
# - Variable: event_scheduler 																				Yes													Global 			Yes
# executed-gtids-compression-period 		Yes 					Yes 
# - Variable: executed_gtids_ 																				Yes 													Global 			Yes
#   compression_period
# executed_gtids_compression_period 																		Yes 													Global 			Yes 					
# exit-info 										Yes 					Yes 
# expire_logs_days 								Yes 					Yes 									Yes 													Global 			Yes
# explicit_defaults_for_timestamp 			Yes 					Yes 									Yes 													Both 				Yes
# external-locking 								Yes 					Yes 									
# - Variable: skip_external_locking 
# external_user 																									Yes 													Session			No
# federated											Yes 					Yes 
# Firewall_access_denied 																																	Yes 		Global 			No
# Firewall_access_granted 																																	Yes 		Global 			No
# Firewall_cached_entries 																																	Yes 		Global 			No
# flush 												Yes 					Yes 									Yes 													Global 			Yes
# Flush_commands 																																				Yes 		Global 			No
# flush_time 										Yes 					Yes 									Yes 													Global 			Yes
# foreign_key_checks 																							Yes 													Both 				Yes
# ft_boolean_syntax 								Yes 					Yes 									Yes 													Global 			Yes
# ft_max_word_len 								Yes 					Yes 									Yes 													Global 			No
# ft_min_word_len 								Yes 					Yes 									Yes 													Global 			No
# ft_query_expansion_limit 					Yes 					Yes 									Yes 													Global 			No
# ft_stopword_file 								Yes 					Yes 									Yes 													Global 			No
# gdb 												Yes 					Yes 
# general-log 										Yes 					Yes 																							Global 			Yes
# -Variable: general_log 																						Yes 													Global 			Yes
# 
# general_log_file 								Yes 					Yes 									Yes 													Global			Yes
# group_concat_max_len 							Yes 					Yes 									Yes 													Both 				Yes
# group_replication_allow_local_disjoint 	Yes 					Yes 									Yes 													Global 			Yes
# _gtids_join
# group_replication_allow_local_lower 		Yes 					Yes 									Yes 													Global 			Yes
# _version_join
# group_replication_auto_ 						Yes 					Yes 									Yes 													Global 			Yes
# increment_increment
# group_replication_bootstrap_ 				Yes 					Yes 									Yes 													Global 			Yes
# group
# group_replication_communication_debug_ 	Yes 					Yes 									Yes 													Global 			Yes
# options
#
# group_replication_components 				Yes 					Yes 									Yes 													Global 			Yes
# group_replication_compression_threshold Yes 					Yes 									Yes 													Global 			Yes
# group_replication_enforce 					Yes 					Yes 									Yes 													Global 			Yes
# _update_everywhere_checks
# group_replication_exit_state_action 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_flow 						Yes 					Yes 									Yes 													Global 			Yes
# _control_applier_threshold
# group_replication_flow 						Yes 					Yes 									Yes 													Global 			Yes
# _control_certifier_threshold 				
#
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _hold_percent
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _max_commit_quota
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _member_quota_percent 
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _min_quota 	
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _min_recovery_quota
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _control_mode
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _control_period 
# group_replication_flow_control 			Yes 					Yes 									Yes 													Global 			Yes
# _control_release_percent
#
# group_replication_force_members 			Yes 					Yes 									Yes 													Global 			Yes
# group_replication_group_name 				Yes 					Yes 									Yes 													Global 			Yes
# group_replication_group_seeds 				Yes 					Yes 									Yes 													Global 			Yes
# group_replication_gtid_assignment  		Yes 					Yes 									Yes 													Global 			Yes
# _block_size
# group_replication_ip_whitelist 			Yes 					Yes 									Yes 													Global 			Yes
# group_replication_local_address 			Yes 					Yes 									Yes 													Global 			Yes
# group_replication_member_expel_timeout 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_member_weight 			Yes 					Yes 									Yes 													Global 			Yes
# group_replication_poll_spin_loops 		Yes 					Yes 									Yes 													Global 			Yes
#
# group_replication_primary_member 																										Yes 						Global 			No
# group_replication_recovery_complete_at 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ 				Yes 					Yes 									Yes 													Global 			Yes
# get_public_key
# group_replication_recovery_ 				Yes 					Yes 									Yes 													Global 			Yes
# public_key_path
# group_replication_recovery_ 				Yes 					Yes 									Yes 													Global 			Yes
# reconnect_interval
# group_replication_recovery_retry_count 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_ca 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_capath 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_cert 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_cipher 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_crl 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery_ssl_crlpath 	Yes 					Yes 									Yes 													Global 			Yes
# 
# group_replication_recovery_ssl_key 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_recovery 					Yes 					Yes 									Yes 													Global 			Yes
# _ssl_verify_server_cert
# group_replication_recovery_use_ssl 		Yes 					Yes 									Yes 													Global 			Yes
# group_replication_single_primary_mode 	Yes 					Yes 									Yes 													Global 			Yes
# group_replication_ssl_mode 					Yes 					Yes 									Yes 													Global 			Yes
# group_replication_start_on_boot 			Yes 					Yes 									Yes 													Global 			Yes
# group_replication_transaction 				Yes 					Yes 									Yes 													Global 			Yes
# _size_limit
# group_replication_unreachable_ 			Yes 					Yes 									Yes 													Global 			Yes
# majority_timeout
#
# gtid_executed 																									Yes 													Varies 			No
# gtid-executed-compression-period 			Yes 					Yes 	
# - Variable: gtid_executed 					
# _compression_period
# gtid_executed_compression_period 																			Yes 													Global 			Yes
# gtid-mode 										Yes 					Yes 																							Global 			Yes
# - Variable: gtid_mode 																						Yes 													Global 			Yes
# gtid_mode 																										Yes 													Global 			Yes
# gtid_next 																										Yes 													Session 			Yes
# gtid_owned 																										Yes 													Both 				No
# gtid_purged 																										Yes 													Global 			Yes
# Handler_commit 																																Yes 						Both 				No
# Handler_delete 																																Yes 						Both 				No
# Handler_external_lock 																													Yes 						Both 				No
# Handler_mrr_init 																															Yes 						Both 				No
# Handler_prepare 																															Yes 						Both 				No
# Handler_read_first 																														Yes 						Both 				No
# Handler_read_key 																															Yes 						Both 				No
# Handler_read_last 																															Yes 						Both 				No
# Handler_read_next 																															Yes 						Both 				No
# Handler_read_prev 																															Yes 						Both 				No
# Handler_read_rnd 																															Yes 						Both 				No
# Handler_read_rnd_next 																													Yes 						Both 				No
#
# Handler_rollback 																															Yes 						Both 				No
# Handler_savepoint 																															Yes 						Both 				No
# Handler_savepoint_rollback 																												Yes 						Both 				No
# Handler_update 																																Yes 						Both 				No
# Handler_write 																																Yes 						Both 				No
# have_compress 																									Yes 													Global 			No
# have_crypt 																										Yes 													Global 			No
# have_dynamic_loading 																							Yes 													Global 			No
# have_geometry 																									Yes 													Global 			No
# have_openssl 																									Yes 													Global 			No
# have_profiling 																									Yes 													Global 			No
# have_query_cache 																								Yes 													Global 			No
# have_rtree_keys 																								Yes 													Global 			No
# have_ssl 																											Yes 													Global 			No
# have_statement_timeout 																						Yes 													Global 			No
#
# have_symlink 									-						-										Yes 													Global 			No
# help 												Yes  					Yes 
#
# histogram_generation_max_mem_size 		Yes 					Yes 									Yes 													Both 				Yes
# host_cache_size 																								Yes 													Global 			Yes
# hostname 																											Yes 													Global 			No
# identity 																											Yes 													Session 			Yes
# ignore-builtin-innodb 						Yes 					Yes 																							Global 			No
# - Variable: ignore_builtin_innodb 																		Yes 													Global 			No
# information_schema_stats_expiry 			Yes 					Yes 									Yes 													Both 				Yes
# init_connect 									Yes 					Yes 									Yes 													Global 			Yes
# init-file 										Yes 					Yes 																							Global 			No
# - Variable: init_file 																						Yes 													Global 			No
# init_slave 										Yes 					Yes 									Yes 													Global 			Yes
# initialize 										Yes 					Yes 
# initialize-insecure 							Yes 					Yes 
# innodb 											Yes 					Yes
# innodb_adaptive_flushing 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_adaptive_flushing_lwm 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_adaptive_hash_index 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_adaptive_hash_index_parts 			Yes 					Yes 									Yes 													Global 			No
# innodb_adaptive_max_sleep_delay 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_api_bk_commit_interval 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_api_disable_rowlock 					Yes 					Yes 									Yes 													Global 			No
# innodb_api_enable_binlog 					Yes 					Yes 									Yes 													Global 			No
# innodb_api_enable_mdl 						Yes 					Yes 									Yes 													Global 			No
# innodb_api_trx_level 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_autoextend_increment 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_autoinc_lock_mode 					Yes 					Yes 									Yes 													Global 			No
# innodb_available_undo_logs 																											Yes 							Global 			No
# innodb_background_drop_list_empty 		Yes 					Yes 									Yes 													Global 			Yes
#
# innodb_buffer_pool_bytes_data 																										Yes 							Global 			No
# innodb_buffer_pool_bytes_dirty 																									Yes 							Global 			No
# innodb_buffer_pool_chunk_size 				Yes 					Yes 									Yes 													Global 			No
# innodb_buffer_pool_debug 					Yes 					Yes 									Yes 													Global 			No
# innodb_buffer_pool_dump_at_shutdown 		Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_dump_now 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_dump_pct 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_dump_status 																									Yes 							Global 			No
# innodb_buffer_pool_filename 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_in_core_file 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_instances 				Yes 					Yes 									Yes 													Global 			No
#
# innodb_buffer_pool_load_abort 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_load_at_startup 		Yes 					Yes 									Yes 													Global 			No
# innodb_buffer_pool_load_now 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_load_status 																									Yes 							Global 			No
# innodb_buffer_pool_pages_data 																										Yes 							Global 			No
# innodb_buffer_pool_pages_dirty 																									Yes 							Global 			No
# innodb_buffer_pool_pages_flushed 																									Yes 							Global 			No
# innodb_buffer_pool_pages_free 																										Yes 							Global 			No
# innodb_buffer_pool_pages_latched 																									Yes 							Global 			No
# innodb_buffer_pool_pages_misc 																										Yes 							Global 			No
# innodb_buffer_pool_pages_total 																									Yes 							Global 			No
# innodb_buffer_pool_read_ahead 																										Yes 							Global 			No
#
# innodb_buffer_pool_read_ahead_evicted 																							Yes 							Global 			No
# innodb_buffer_pool_read_ahead_rnd 																								Yes 							Global 			No
# innodb_buffer_pool_read_requests 																									Yes 							Global 			No
# innodb_buffer_pool_reads 																											Yes 							Global 			No
# innodb_buffer_pool_resize_status 																									Yes 							Global 			No
# innodb_buffer_pool_size 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_buffer_pool_wait_free 																										Yes 							Global 			No
# innodb_buffer_pool_write_requests 																								Yes 							Global 			No
# innodb_change_buffer_max_size 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_change_buffering  					Yes 					Yes 									Yes 													Global 			yes
# innodb_change_buffering_debug 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_checkpoint_disabled 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_checksum_algorithm 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_cmp_per_index_enabled 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_commit_concurrency 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_compress_debug 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_compression_ 							Yes 					Yes 									Yes 													Global 			Yes
# failure_threshold_pct
#
# innodb_compression_level 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_compression_pad_pct_max 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_concurrency_tickets 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_data_file_path 						Yes 					Yes 									Yes 													Global 			No
# innodb_data_fsyncs 																													Yes 							Global 			No
# innodb_data_home_dir 							Yes 					Yes 									Yes 													Global 			No
# innodb_data_pending_fsyncs 																											Yes 							Global 			No
# innodb_data_pending_reads 																											Yes 							Global 			No
# innodb_data_pending_writes 																											Yes 							Global 			No
# innodb_data_read 																														Yes 							Global 			No
# innodb_data_reads 																														Yes 							Global 			No
# innodb_data_writes 																													Yes 							Global 			No
# innodb_data_written 																													Yes 							Global 			No
# innodb_dblwr_pages_written 																											Yes 							Global 			No
# innodb_dblwr_writes 																													Yes 							Global 			No
# innodb_ddl_log_crash_reset_debug 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_deadlock_detect 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_dedicated_server 						Yes 					Yes 									Yes 													Global 			No
# innodb_default_row_format 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_directories 							Yes 					Yes 									Yes 													Global 			No
# 
# innodb_disable_sort_file_cache 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_doublewrite 							Yes 					Yes 									Yes 													Global 			No
# innodb_fast_shutdown 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_fil_make_page_dirty_debug 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_file_per_table 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_fill_factor 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_flush_log_at_timeout 																				Yes 													Global 			Yes
# innodb_flush_log_at_trx_commit 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_flush_method 							Yes 					Yes 									Yes 													Global 			No
# innodb_flush_neighbors 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_flush_sync 								Yes 					Yes 									Yes 													Global 			Yes
# innodb_flushing_avg_loops 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_force_load_corrupted 				Yes 					Yes 									Yes 													Global 			No
# innodb_force_recovery 						Yes 					Yes 									Yes 													Global 			No
# innodb_fsync_threshold 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_aux_table 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_cache_size 							Yes 					Yes 									Yes 													Global 			No
# innodb_ft_enable_diag_print 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_enable_stopword 					Yes 					Yes 									Yes 													Both 				Yes
# innodb_ft_max_token_size 					Yes 					Yes 									Yes 													Global 			No
#
# innodb_ft_min_token_size 					Yes 					Yes 									Yes 													Global 			No
# innodb_ft_num_word_optimize 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_result_cache_limit 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_server_stopword_table 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_ft_sort_pll_degree 					Yes 					Yes 									Yes 													Global 			No
# innodb_ft_total_cache_size 					Yes 					Yes 									Yes 													Global 			No
# innodb_ft_user_stopword_table 				Yes 					Yes 									Yes 													Both 				Yes
# innodb_have_atomic_builtins 																											Yes 						Global 			No
# innodb_io_capacity 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_io_capacity_max 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_limit_optimistic_insert_debug 	Yes 					Yes 									Yes 													Global 			Yes
# innodb_lock_wait_timeout 					Yes 					Yes 									Yes 													Both  			Yes
# innodb_log_buffer_size 						Yes 					Yes 									Yes 													Global 			Varies
# innodb_log_checkpoint_fuzzy_now 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_checkpoint_now 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_checksums 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_compressed_pages 				Yes 					Yes 									Yes 													Global 			Yes
#
# innodb_log_file_size 							Yes 					Yes 									Yes 													Global 			No
# innodb_log_files_in_group 					Yes 					Yes 									Yes 													Global 			No
# innodb_log_group_home_dir 					Yes 					Yes 									Yes 													Global 			No
# innodb_log_spin_cpu_abs_lwm 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_spin_cpu_pct_hwm 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_wait_for_flush_spin_hwm 		Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_waits 																															Yes 						Global 			No
# innodb_log_write_ahead_size 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_log_write_requests 																												Yes 						Global 			No
# innodb_log_writes 																															Yes 						Global 			No
# innodb_lru_scan_depth 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_max_dirty_pages_pct 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_max_dirty_pages_pct_lwm 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_max_purge_lag 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_max_purge_lag_delay 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_max_undo_log_size 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_merge_threshold_set_all_debug 	Yes 					Yes 									Yes 													Global 			Yes
# innodb_monitor_disable 						Yes 					Yes 									Yes 													Global 			Yes
#
# innodb_monitor_enable 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_monitor_reset 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_monitor_reset_all 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_num_open_files 																													Yes 						Global 			No
# innodb_numa_interleave 						Yes 					Yes 									Yes 													Global 			No
# innodb_old_blocks_pct 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_old_blocks_time 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_online_alter_log_max_size 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_open_files 								Yes 					Yes 									Yes 													Global 			No
# innodb_optimize_fulltext_only 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_os_log_fsyncs 																														Yes 						Global 			No
# innodb_os_log_pending_fsyncs 																											Yes 						Global 			No
# innodb_os_log_pending_writes 																											Yes 						Global 			No
# innodb_os_log_written 																													Yes 						Global 			No
# innodb_page_cleaners 							Yes 					Yes 									Yes 													Global 			No
# innodb_page_size 																															Yes 						Global 			No
# innodb_page_size 								Yes 					Yes 									Yes 													Global 			No
#
# innodb_pages_created 																							 							Yes						Global 			No
# innodb_pages_read 																															Yes 						Global 			No
# innodb_pages_written 																														Yes 						Global 			No
# innodb_parallel_read_threads 				Yes 					Yes 									Yes 													Session 			Yes
# innodb_print_all_deadlocks 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_print_ddl_logs 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_purge_batch_size 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_purge_rseg_truncate_frequency 	Yes 					Yes 									Yes 													Global 			Yes
# innodb_purge_threads 							Yes 					Yes 									Yes 													Global 			No
# innodb_random_read_ahead 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_read_ahead_threshold 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_read_io_threads 						Yes 					Yes 									Yes 													Global 			No
# innodb_read_only 								Yes 					Yes 									Yes 													Global 			No
# innodb_redo_log_encrypt 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_replication_delay 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_rollback_on_timeout 					Yes 					Yes 									Yes 													Global 			No
# innodb_rollback_segments 					Yes 					Yes 									Yes 													Global 			Yes
# 
# innodb_row_lock_current_waits 																											Yes 						Global 			No
# innodb_row_lock_time 																														Yes 						Global 			No
# innodb_row_lock_time_avg 																												Yes 						Global 			No
# innodb_row_lock_time_max 																												Yes 						Global 			No
# innodb_row_lock_waits 																													Yes 						Global 			No
# innodb_rows_deleted 																														Yes 						Global 			No
# innodb_rows_inserted 																														Yes 						Global 			No
# innodb_rows_read 																															Yes 						Global 			No
# innodb_rows_updated 																														Yes 						Global 			No
# innodb_saved_page_number_debug 			Yes 					Yes 									Yes 													Global 			Yes
# innodb_scan_directories 						Yes 					Yes 									Yes 													Global 			No
# innodb_sort_buffer_size 						Yes 					Yes 									Yes 													Global 			No
# innodb_spin_wait_delay 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_auto_recalc 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_include_delete_marked 		Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_method 							Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_on_metadata 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_persistent 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_persistent_sample_pages 	Yes 					Yes 									Yes 													Global 			Yes
# innodb_stats_transient_sample_pages 		Yes 					Yes 									Yes 													Global 			Yes
# innodb-status-file 							Yes 					Yes 
# innodb_status_output 							Yes 					Yes 									Yes 													Global 			Yes
#
# innodb_status_output_locks 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_strict_mode 							Yes 					Yes 									Yes 													Both 				Yes
# innodb_sync_array_size 						Yes 					Yes 									Yes 													Global 			No
# innodb_sync_debug 								Yes 					Yes 									Yes 													Global 			No
# innodb_sync_spin_loops 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_table_locks 							Yes 					Yes 									Yes 													Both 				Yes
# innodb_temp_data_file_path 					Yes 					Yes 									Yes 													Global 			No
# innodb_temp_tablespaces_dir 				Yes 					Yes 									Yes 													Global 			No
# innodb_thread_concurrency 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_temp_sleep_delay 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_tmpdir 									Yes 					Yes 									Yes 													Both 				Yes
# innodb_truncated_status_writes 																											Yes 					Global 			No
#
# innodb_trx_purge_view_update_only_debug Yes 					Yes 									Yes 													Global 			Yes
# innodb_trx_rseg_n_slots_debug 				Yes 					Yes 									Yes 													Global 			Yes
# innodb_undo_directory 						Yes 					Yes 									Yes 													Global 			No
# innodb_undo_log_encrypt 						Yes 					Yes 									Yes 													Global 			Yes
# innodb_undo_log_truncate 					Yes 					Yes 									Yes 													Global 			Yes
# innodb_undo_logs 								Yes 					Yes 									Yes 													Global 			Yes
# innodb_undo_tablespaces 						Yes 					Yes 									Yes 													Global 			Varies
# innodb_use_native_aio 						Yes 					Yes 									Yes 													Global 			No
# innodb_version 																									Yes 													Global 			No
# innodb_write_io_threads 						Yes 					Yes 									Yes 													Global 			No
# insert_id 																										Yes 													Session 			Yes
# install 											Yes 
# install-manual 									Yes 
# interactive_timeout 							Yes 					Yes 									Yes 													Both 				Yes
# internal_tmp_disk_storage_engine 			Yes 					Yes 									Yes 													Global 			Yes
# internal_tmp_mem_storage_engine 			Yes 					Yes 									Yes 													Both 				Yes
# join_buffer_size 								Yes 					Yes 									Yes 													Both 				Yes
# keep_files_on_create  						Yes 					Yes 									Yes 													Both 				Yes
#
# Key_blocks_not_flushed 																														Yes					Global 			No
# Key_blocks_unused 																																Yes 					Global 			No
# Key_blocks_used 																																Yes 					Global 			No
# key_buffer_size 								Yes 					Yes 									Yes 													Global 			Yes
# key_cache_age_threshold 						Yes 					Yes 									Yes 													Global 			Yes
# key_cache_block_size 							Yes 					Yes 									Yes 													Global 			Yes
# key_cache_division_limit 					Yes 					Yes 									Yes 													Global 			Yes
# Key_read_requests 																																Yes 					Global 			No
# Key_reads 																																		Yes 					Global 			No
# Key_write_requests 																															Yes 					Global 			No
# Key_writes 																																		Yes 					Global 			No
# keyring_aws_cmk_id 							Yes 					Yes 									Yes 													Global 			Yes
# keyring_aws_conf_file 						Yes 					Yes 									Yes 													Global 			No
# keyring_aws_data_file 						Yes 					Yes 									Yes 													Global 			No
#
# keyring_aws_region 							Yes 					Yes 									Yes 													Global 			Yes
# keyring_encrypted_file_data 				Yes 					Yes 									Yes 													Global 			Yes
# keyring_encrypted_file_password 			Yes 					Yes 									Yes 													Global 			Yes
# keyring_file_data 								Yes 					Yes 									Yes 													Global 			Yes
# keyring-migration-destination 				Yes 					Yes
# keyring-migration-host 						Yes 					Yes
# keyring-migration-password 					Yes 					Yes
# keyring-migration-port 						Yes 					Yes
# keyring-migration-socket 					Yes 					Yes
# keyring-migration-source 					Yes 					Yes
# keyring-migration-user 						Yes 					Yes
# keyring_okv_conf_dir 							Yes 					Yes 									Yes 													Global 			Yes
# keyring_operations 																							Yes 													Global 			Yes
# language 											Yes 					Yes 									Yes 													Global 			No
# large_files_support 																							Yes 													Global 			No
# large_page_size 																								Yes 													Global 			No
# large-pages 										Yes 					Yes 																							Global 			No
# - Variable: large_pages 																						Yes 													Global 			No
# last_insert_id 																									Yes 													Session 			Yes
# Last_query_cost 																																Yes 					Session 			No
# Last_query_partial_plans 																													Yes 					Session 			No
# lc-messages 										Yes 					Yes 																							Both 				Yes
# - Variable: lc_messages 																						Yes 													Both 				Yes
# lc-messages-dir 								Yes 					Yes 																							Global 			No
# - Variable: lc_messages_dir 																				Yes 													Global 			No
# lc_time_names 																									Yes 													Both 				Yes
# license 																											Yes 													Global 			No
# local_infile 																									Yes 													Global 			Yes
#
# local-service 									Yes 															
# lock_wait_timeout 								Yes 					Yes 									Yes 													Both 				Yes
# Locked_connects 																								 								 Yes 					Global 			No
# locked_in_memory 																								Yes 													Global 			No
# log-bin 											Yes 					Yes 									Yes 													Global 			No
# log_bin 																											Yes 							 						Global 			No
# log_bin_basename 																								Yes 													Global 			No
# log-bin-index 									Yes 					Yes 
# log_bin_index 																									Yes 													Global 			No
# log-bin-trust-function-creators 			Yes 					Yes 																							Global 			Yes
# - Variable: log_bin_trust_function_creators 															Yes 													Global 			Yes
# log-bin-use-v1-row-events 					Yes 					Yes 																							Global 			No
# - Variable: log_bin_use_v1_row_events 																	Yes 													Global 			No
# log_bin_use_v1_row_events 					Yes 					Yes 									Yes 													Global 			No
# log_builtin_as_identified_by_password 	Yes 					Yes 									Yes 													Global 			Yes
# log-error 										Yes 					Yes 																							Global 			No
# - Variable: log_error 																						Yes 													Global 			No
# log_error_filter_rules 						Yes 					Yes 									Yes 													Global 			Yes
#
# log_error_services 							Yes 					Yes 									Yes 													Global 			Yes
# log_error_suppression_list 					Yes 					Yes 									Yes 													Global 			Yes
# log_error_verbosity 							Yes 					Yes 									Yes 													Global 			Yes
# log-isam 											Yes 					Yes 
# log-output 										Yes 					Yes 																							Global 			Yes
# - Variable: log_output 																						Yes 													Global 			Yes
# log-queries-not-using-indexes 				Yes 					Yes 																							Global 			Yes
# - Variable: log_queries_not_ 																				Yes 													Global 			Yes
# using_indexes
# log-raw 											Yes 					Yes 
# log-short-format 								Yes 					Yes
# log-slave-updates 								Yes 					Yes 																							Global  			No
# Variable: log_slave_updates 																				Yes 													Global 			No
# log_slave_updates 								Yes 					Yes 									Yes 													Global 			No
# log_slow_admin_statements 																					Yes 													Global 			Yes
# log_slow_slave_statements 																					Yes 													Global 			Yes
# log_statements_unsafe_for_binlog 																			Yes 													Global 			Yes
# log_syslog 										Yes 					Yes 									Yes 													Global 			Yes
# log_syslog_facility 							Yes 					Yes 									Yes 													Global 			Yes
# log_syslog_include_pid 						Yes 					Yes 									Yes 													Global 			Yes
# log_syslog_tag 									Yes 					Yes 									Yes 													Global 			Yes
# log-tc 											Yes 					Yes
#
# log-tc-size 										Yes 					Yes
# log_throttle_queries_not_using_indexes 																	Yes 													Global 			Yes
# log_timestamps 									Yes 					Yes 									Yes 													Global 			Yes
# log-warnings 									Yes 					Yes 																							Global 			Yes
# - Variable: log_warnings 																					Yes 													Global 			Yes
# long_query_time 								Yes 					Yes 									Yes 													Both 				Yes
# low-priority-updates 							Yes 					Yes 																							Both 				Yes
# - Variable: low_priority_updates 																			Yes 													Both 				Yes
# lower_case_file_system 																						Yes 													Global 			No
# lower_case_table_names 						Yes 					Yes 									Yes 													Global 			No
# mandatory_roles 								Yes 					Yes 									Yes 													Global 			Yes
# master-info-file 								Yes 					Yes 
# master-info-repository 						Yes 					Yes 
# - Variable: master_info_repository 
# master_info_repository 						Yes 					Yes 									Yes 													Global 			Yes
# master-retry-count 							Yes 					Yes 
# master-verify-checksum 						Yes 					Yes
# - Variable: master_verify_checksum
#
# master_verify_checksum 																						Yes 													Global 			Yes
# max_allowed_packet 							Yes 					Yes 									Yes 													Both 				Yes
# max_binlog_cache_size 						Yes 					Yes 									Yes 													Global 			Yes
# max-binlog-dump-events 						Yes 					Yes 
# max_binlog_size 								Yes 					Yes 									Yes 													Global 			Yes
# max_binlog_stmt_cache_size 					Yes 					Yes 									Yes 													Global 			Yes
# max_connect_errors 							Yes 					Yes 									Yes 													Global 			Yes
# max_connections 								Yes 					Yes 									Yes 													Global 			Yes
# max_delayed_threads 							Yes 					Yes 									Yes 													Both 				Yes
# max_digest_length 								Yes 					Yes 									Yes 													Global 			No
# max_error_count 								Yes 					Yes 									Yes 													Both 				Yes
# max_execution_time 																														Yes 						Both 				Yes
# Max_execution_time_exceeded 																											Yes 						Both 				No
# Max_execution_time_set 																													Yes 						Both 				No
# Max_execution_time_set_failed 																											Yes 						Both 				No
# max_heap_table_size 							Yes 					Yes 									Yes 													Both 				Yes
# max_insert_delayed_threads 																					Yes 													Both 				Yes
# max_join_size 									Yes 					Yes 									Yes 													Both 				Yes
# max_length_for_sort_data 					Yes 					Yes 									Yes 													Both 				Yes
#
# max_points_in_geometry 						Yes 					Yes 									Yes 													Both 				Yes
# max_prepared_stmt_count 						Yes 					Yes 									Yes 													Global 			Yes
# max_relay_log_size 							Yes 					Yes 									Yes 													Global 			Yes
# max_seeks_for_key 								Yes 					Yes 									Yes 													Both 				Yes
# max_sort_length 								Yes					Yes 									Yes 													Both  			Yes
# max_sp_recursion_depth 						Yes 					Yes 									Yes 													Both 				Yes
# max_tmp_tables 																									Yes 													Both 				Yes
# Max_used_connections 																														Yes 						Global 			No
# Max_used_connections_time 																												Yes 						Global 			No
# max_user_connections 							Yes 					Yes 									Yes 													Both 				Yes
# max_write_lock_count 							Yes 					Yes 									Yes 													Global 			Yes
# mecab_charset 																																Yes 						Global 			No
# mecab_rc_file 									Yes 					Yes 									Yes 													Global 			No
# memlock 											yes 					Yes 
# - variable: locked_in_memory 				
# metadata_locks_cache_size 																					Yes 													Global 			No
# metadata_locks_hash_instances 																				Yes 													Global 			No
# min-examined-row-limit 						Yes 					Yes 									Yes 													Both 				Yes
# multi_range_count 								Yes 					Yes 									Yes 													Both 				Yes
# myisam-block-size 								Yes 					Yes 
# myisam_data_pointer_size 					Yes 					Yes 									Yes 													Global 			Yes
# myisam_max_sort_file_size 					Yes 					Yes 									Yes 													Global 			Yes
# myisam_mmap_size 								Yes 					Yes 									Yes 													Global 			No
# myisam-recover-options 						Yes 					Yes 
# - Variable: myisam_recover_options
# myisam_recover_options 																						Yes 													Global 			No
# myisam_repair_threads 						Yes 					Yes 									Yes 													Both 				Yes
# myisam_sort_buffer_size 						Yes 					Yes 									Yes 													Both 				Yes
# myisam_stats_method 							Yes 					Yes 									Yes 													Both 				Yes
# myisam_use_mmap 								Yes 					Yes 									Yes 													Global 			Yes
# 
# mysql_firewall_mode 							Yes 					Yes 									Yes 													Global 			Yes
# mysql_firewall_trace 							Yes 					Yes 									Yes 													Global 			Yes
# mysql_native_password_proxy_users 		Yes 					Yes 									Yes 													Global 			Yes
# mysqlx 											Yes 					Yes 									Yes 													Global 			No
# Mysqlx_aborted_clients 																														Yes 					Global 			No
# Mysqlx_address 																																	Yes 					Global 			No
# mysqlx-bind-address 							Yes 					Yes 									Yes 													Global 			No
# mysqlx_bind_address 							Yes 					Yes 									Yes 													Global 			No
# Mysqlx_bytes_received 																														Yes 					Both 				No
# Mysqlx_bytes_sent 																																Yes 					Both 				No
# mysqlx-connect-timeout 						Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_connect_timeout 						Yes 					Yes 									Yes 													Global 			Yes
# Mysqlx_connection_accept_errors 																											Yes 					Both 				No
# Mysqlx_connection_errors 																													Yes 					Both 				No
# Mysqlx_connections_accepted 																												Yes 					Global 			No
# Mysqlx_connections_closed 																													Yes 					Global 			No
# Mysqlx_connections_rejected 																												Yes 					Global 			No
# Mysqlx_crud_create_view 																														Yes 					Both 				No
# Mysqlx_crud_delete 																															Yes 					Both 				No
# Mysqlx_crud_drop_view 																														Yes 					Both 				No
# Mysqlx_crud_find 																																Yes 					Both 				No
# Mysqlx_crud_insert 																															Yes 					Both 				No
#
# Mysqlx_crud_modify_view 																														Yes 					Both 				No
# Mysqlx_crud_update 																															Yes 					Both 				No
# mysqlx_document_id_unique_prefix 			Yes 					Yes 									Yes 													Global 			Yes
# Mysqlx_errors_sent 																															Yes 					Both 				No
# Mysqlx_errors_unknown_message_type 																										Yes 					Both 				No
# Mysqlx_expect_close 																															Yes 					Both 				No
# Mysqlx_expect_open 																															Yes 					Both 				No
# mysqlx-idle-worker-thread-timeout 		Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_idle_worker_thread_timeout 		Yes 					Yes 									Yes 													Global 			Yes
# Mysqlx_init_error 																																Yes 					Both 				No
# mysqlx-interactive-timeout 					Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_interactive_timeout 					Yes 					Yes 									Yes 													Global 			Yes
# mysqlx-max-allowed-packet 					Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_max_allowed_packet 					Yes 					Yes 									Yes 													Global 			Yes
#
# mysqlx-max-connections 						Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_max_connections 						Yes 					Yes 									Yes 													Global 			Yes
# mysqlx-min-worker-threads 					Yes 					Yes 									Yes 													Global 			Yes
# mysqlx_min_worker_threads 					Yes 					Yes 									Yes 													Global 			Yes
# Mysqlx_notice_other_sent 																													Yes 					Both 				No
# Mysqlx_notice_warning_sent 																													Yes 					Both 				No
# Mysqlx_port 																																		Yes 					Global 			No
# mysqlx-port 										Yes 					Yes 									Yes 													Global 			No
# mysqlx_port 										Yes 					Yes 									Yes 													Global 			No
# mysqlx-port-open-timeout 					Yes 					Yes 									Yes 													Global 			No
# mysqlx_port_open_timeout 					Yes 					Yes 									Yes 													Global 			No
# mysqlx-read-timeout 							Yes 					Yes 									Yes 													Session 			Yes
# mysqlx_read_timeout 							Yes 					Yes 									Yes 													Session 			Yes
# Mysqlx_rows_sent 																																Yes 					Both 				No
# Mysqlx_sessions 																																Yes 					Global 			No
# Mysqlx_sessions_accepted 																													Yes 					Global 			No
# Mysqlx_sessions_closed 																														Yes 					Global 			No
# Mysqlx_sessions_fatal_error 																												Yes 					Global 			No
# Mysqlx_sessions_killed 																														Yes 					Global 			No
# Mysqlx_sessions_rejected 																													Yes 					Global 			No
# Mysqlx_socket 																																	Yes 					Global 			No
# mysqlx-socket 									Yes 					Yes 									Yes 													Global 			No
# mysqlx_socket 									Yes 					Yes 									Yes 													Global 			No
# Mysqlx_ssl_accept_renegotiates 																											Yes 					Global 			No
#
# Mysqlx_ssl_accepts 																															Yes 					Global 			No
# Mysqlx_ssl_active 																																Yes 					Both 				No
# mysqlx-ssl-ca 									Yes 					Yes  									Yes 													Global 			No
# mysqlx-ssl-capath 								Yes 					Yes 									Yes 													Global 			No
# mysqlx-ssl-cert 								Yes 					Yes 									Yes 													Global 			No
# Mysqlx_ssl_cipher 																																Yes 					Both 				No
# mysqlx-ssl-cipher 								Yes 					Yes 
# Mysqlx_ssl_cipher_list 																														Yes 					Both 				No
# mysqlx-ssl-crl 									Yes 					Yes 									Yes 													Global 			No
# mysqlx-ssl-crlpath 							Yes 					Yes 									Yes 													Global 			No
# Mysqlx_ssl_ctx_verify_depth 																												Yes 					Both 				No
# Mysqlx_ssl_ctx_verify_mode 																													Yes 					Both 				No
# Mysqlx_ssl_finished_accepts 																												Yes 					Global 			No
# mysqlx-ssl-key 									Yes 					Yes 									Yes 													Global 			No
# Mysqlx_ssl_server_not_after 																												Yes 					Global 			No
# Mysqlx_ssl_server_not_before 																												Yes 					Global 			No
# Mysqlx_ssl_verify_depth 																														Yes 					Global 			No
# Mysqlx_ssl_verify_mode 																														Yes 					Global 			No
# Mysqlx_ssl_version 																															Yes 					Both 				No
# Mysqlx_stmt_create_collection 																												Yes 					Both 				No
# Mysqlx_stmt_create_collection_index 																										Yes 					Both 				No
# Mysqlx_stmt_disable_notices 																												Yes 					Both 				No
# Mysqlx_stmt_drop_collection 																												Yes 					Both 				No
# Mysqlx_stmt_drop_collection_index 																										Yes 					Both 				No
# Mysqlx_stmt_enable_notices 																													Yes 					Both 				No
# Mysqlx_stmt_ensure_collection 																												Yes 					Both 				No
# Mysqlx_stmt_execute_mysqlx 																													Yes 					Both 				No
# Mysqlx_stmt_execute_sql 																														Yes 					Both 				No
# Mysqlx_stmt_execute_xplugin 																												Yes 					Both 				No
# Mysqlx_stmt_kill_client 																														Yes 					Both 				No
# Mysqlx_stmt_list_clients 																													Yes 					Both 				No
# Mysqlx_stmt_list_notices 																													Yes 					Both 				No
# 
# Mysqlx_stmt_list_objects 																													Yes 					Both 				No
# Mysqlx_stmt_ping 																																Yes 					Both 				No
# mysqlx-wait-timeout 							Yes 					Yes 									Yes 													Session 			Yes
# mysqlx_wait_timeout 							Yes 					Yes 									Yes 													Session 			Yes
# Mysqlx_worker_threads 																														Yes 					Global 			No
# Mysqlx_worker_threads_active 																												Yes 					Global 			No
# mysqlx-write-timeout 							Yes 					Yes 									Yes 													Session 			Yes
# mysqlx_write_timeout 							Yes 					Yes 									Yes 													Session 			Yes
# named_pipe 																										Yes 													Global 			No
# Ndb_api_bytes_received_count 																												Yes 					Global 			No
# Ndb_api_bytes_received_count_session 																									Yes 					Session 			No
# Ndb_api_bytes_received_count_slave 																										Yes 					Global 			No
# Ndb_api_bytes_sent_count 																													Yes 					Global 			No
# Ndb_api_bytes_sent_count_slave 																											Yes 					Global 			No
# Ndb_api_event_bytes_count_injector 																										Yes 					Global 			No
# Ndb_api_event_data_count_injector 																										Yes 					Global 			No
#
# Ndb_api_event_nondata_count_injector 																									Yes 					Global 			No
# Ndb_api_pk_op_count 																															Yes 					Global 			No
# Ndb_api_pk_op_count_session 																												Yes 					Session 			No
# Ndb_api_pk_op_count_slave 																													Yes 					Global 			No
# Ndb_api_pruned_scan_count  																													Yes 					Global 			No
# Ndb_api_pruned_scan_count_session 																										Yes 					Session 			No
# Ndb_api_range_scan_count_slave 																											Yes 					Global 			No
# Ndb_api_read_row_count 																														Yes 					Global 			No
# Ndb_api_read_row_count_session 																											Yes 					Session 			No
# Ndb_api_scan_batch_count_slave 																											Yes 					Global 			No
# Ndb_api_table_scan_count 																													Yes 					Global 			No
# Ndb_api_table_scan_count_session 																											Yes 					Session 			No
#
# Ndb_api_trans_abort_count 																													Yes 					Global 			No
# Ndb_api_trans_abort_count_session 																										Yes 					Session 			No
# Ndb_api_trans_abort_count_slave 																											Yes 					Global 			No
# Ndb_api_trans_close_count 																													Yes 					Global 			No
# Ndb_api_trans_close_count_session 																										Yes 					Session 			No
# Ndb_api_trans_close_count_slave 																											Yes 					Global 			No
# Ndb_api_trans_commit_count 																													Yes 					Global 			No
# Ndb_api_trans_commit_count_session 																										Yes 					Session 			No
# Ndb_api_trans_commit_count_slave 																											Yes 					Global 			No
# Ndb_api_trans_local_read_row_count_slave 																								Yes 					Global 			No
# Ndb_api_trans_start_count 																													Yes 					Global 			No
# Ndb_api_trans_start_count_session 																										Yes 					Session 			No
# Ndb_api_trans_start_count_slave 																											Yes 					Global 			No
# Ndb_api_uk_op_count 																															Yes 					Global 			No
# Ndb_api_uk_op_count_slave 																													Yes 					Global 			No
# Ndb_api_wait_exec_complete_count 																											Yes 					Global 			No
# Ndb_api_wait_exec_complete_count_session 																								Yes 					Session 			No
# Ndb_api_wait_exec_complete_count_slave 																									Yes 					Global 			No
# Ndb_api_wait_meta_request_count 																											Yes 					Global 			No
# Ndb_api_wait_meta_request_count_session 																								Yes 					Session 			No
# Ndb_api_wait_nanos_count 																													Yes 					Global 			No
# Ndb_api_wait_nanos_count_session 																											Yes 					Session 			No
#
# Ndb_api_wait_nanos_count_slave 																											Yes 					Global 			No
# Ndb_api_wait_scan_result_count 																											Yes 					Global 			No
# Ndb_api_wait_scan_result_count_session 																									Yes 					Session 			No
# Ndb_api_wait_scan_result_count_slave 																									Yes 					Global 			No
# ndb-batch-size 									Yes 					Yes 									Yes 													Global 			No		
# ndb-blob-write-batch-bytes 					Yes 					Yes 									Yes 													Both 				Yes
# ndb-cluster-connection-pool 				Yes 					Yes 									Yes 													Global 			No
# ndb-cluster-connection-pool-nodeids 		Yes 					Yes 									Yes 													Global 			No
# Ndb_cluster_node_id 																															Yes 					Both 				No
# Ndb_config_from_host 																															Yes 					Both 				No
# Ndb_config_from_port 																															Yes 					Both 				No
# Ndb_conflict_fn_epoch_trans 																												Yes 					Both 				No
# Ndb_conflict_fn_max 																															Yes 					Global 			No
# Ndb_conflict_fn_old 																															Yes 					Global 			No
# Ndb_conflict_trans_detect_iter_count 																									Yes 					Global 			No
# Ndb_conflict_trans_row_reject_count 																										Yes 					Global 			No
# ndb-connectstring 								Yes 					Yes 
# ndb-deferred-constraints 					Yes 					Yes 																							Both 				Yes
# - Variable: ndb_deferred_constraints 																	Yes 													Both 				Yes
# ndb_deferred_constraints 					Yes 					Yes 									Yes 													Both 				Yes
# ndb-distribution 								Yes 					Yes 																							Global 			Yes
# - Variable: ndb_distribution 																				Yes 													Global 			Yes
# ndb_distribution 								Yes 					Yes 									Yes 													Global 			Yes
# ndb_eventbuffer_free_percent 				Yes 					Yes 									Yes 													Global 			Yes
# ndb_eventbuffer_max_alloc 					Yes 					Yes 									Yes 													Global 			Yes
# ndb_force_send 									Yes 					Yes 									Yes 													Both 				Yes
# ndb_index_stat_enable 						Yes 					Yes 									Yes 													Both 				Yes
# ndb_index_stat_option 						Yes 					Yes 									Yes 													Both 				Yes
# ndb_join_pushdown 																								Yes 													Both 				Yes
# Ndb_last_commit_epoch_server 																												Yes 					Global 			No
# Ndb_last_commit_epoch_session 																												Yes 					Session 			No
# ndb-log-apply-status 							Yes 					Yes 																							Global 			No
# 
# - Variable: ndb_log_apply_status 																			Yes 													Global 			No
# ndb_log_apply_status 							Yes 					Yes 									Yes 													Global 			No
# ndb_log_binlog_index 							Yes 															Yes 													Global 			Yes
# ndb-log-empty-epochs 							Yes 					Yes 									Yes 													Global 			Yes
# ndb-log-empty-update 							Yes 					Yes 									Yes 													Global 			Yes
# ndb-log-transaction-id 						Yes 					Yes 																							Global 			No
# - Variable: ndb_log_transaction_id 																		Yes 													Global 			No
# ndb_log_updated_only 							Yes 					Yes 									Yes 													Global 			Yes
# ndb-mgmd-host 									Yes 					Yes 
# Ndb_number_of_data_nodes 																													Yes  					Global 			No
# ndb_optimization_delay 																						Yes 													Global 			Yes
# ndb_optimized_node_selection 				Yes 					Yes 									Yes 													Global 			No
# Ndb_pushed_queries_defined 																													Yes 					Global 			No
# Ndb_pushed_queries_executed 																												Yes 					Global 			No
# ndb_recv_thread_activation_threshold 																	Yes 													Global 			Yes
# ndb_recv_thread_cpu_mask 																					Yes  													Global 			Yes
# ndb_report_thresh_binlog_epoch_slip 		Yes 					Yes 									Yes 													Global 			Yes
# ndb_report_thresh_binlog_mem_usage 		Yes 					Yes 									Yes 													Global 			Yes
# Ndb_scan_count 																																	Yes 					Global 			No
# 
# ndb_show_foreign_key_mock_tables 			Yes 					Yes 									Yes 													Global 			Yes
# Ndb_slave_max_replicated_epoch 																			Yes 													Global 			No
# ndb_table_no_logging 																							Yes 													Session 			Yes
# ndb-transid-mysql-connection-map 			Yes 
# ndb_use_transactions 							Yes 					Yes 									Yes 													Both 				Yes
# ndb_version 																										Yes 													Global 			No
# ndb_version_string 																							Yes 													Global 			No
# ndb-wait-setup 									Yes 					Yes 									Yes 													Global 			No
# ndbinfo_database 																								Yes 													Global 			No
# ndbinfo_max_rows 								Yes 															Yes 													Both 				Yes
# ndbinfo_show_hidden 							Yes 															Yes 													Both 				Yes
# ndbinfo_version 																								Yes 													Global 			No
# net_buffer_length 								Yes 					Yes 									Yes 													Both 				Yes
# net_read_timeout 								Yes 					Yes 									Yes 													Both 				Yes
# net_retry_count 								Yes 					Yes 									Yes 													Both 				Yes
# net_write_timeout 								Yes 					Yes 									Yes 													Both 				Yes
# new 												Yes 					Yes 									Yes 													Both 				Yes
# ngram_token_size 								Yes 					Yes 									Yes 													Global 			No
#
# no-dd-upgrade 									Yes 					Yes 
# no-defaults 										Yes 
# no-monitor 										Yes 					Yes
# Not_flushed_delayed_rows 																														Yes 				Global 			No
# offline_mode 									Yes 					Yes 									Yes 													Global 			Yes
# old 												Yes 					Yes 									Yes 													Global 			No
# old-alter-table 								Yes 					Yes 																							Both 				Yes
# - Variable: old_alter_table 																				Yes 													Both 				Yes
# old_passwords 																									Yes 													Both 				Yes
# old-style-user-limits 						Yes 					Yes 
# Ongoing_anonymous_gtid_violating_transaction_count 																						Yes 				Global 			No
# Ongoing_anonymous_transaction_count 																											Yes 				Global 			No
# Ongoing_automatic_gtid_violating_transaction_count 																						Yes 				Global 			No
# Open_files 																																			Yes 				Global 			No
# open-files-limit 								Yes 					Yes 																							Global 			No
# - Variable: open_files_limit 																				Yes 													Global 			No
# Open_streams 																																		Yes 				Global 			No
# Open_table_definitions 																															Yes 				Global 			No
# Open_tables 																																			Yes 				Both 				No
# Opened_files 																																		Yes 				Global 			No
# Opened_table_definitions 																														Yes 				Both 				No
# Opened_tables 																																		Yes 				Both 				No
# optimizer_prune_level 						Yes 					Yes 									Yes 													Both 				Yes
# optimizer_search_depth 						Yes 					Yes 									Yes 													Both 				Yes
# 
# optimizer_switch 								Yes 					Yes 									Yes 													Both 				Yes
# optimizer_trace 																								Yes 													Both 				Yes
# optimizer_trace_features 																					Yes  													Both 				Yes
# optimizer_trace_limit 																						Yes 													Both 				Yes
# optimizer_trace_max_mem_size 																				Yes 													Both 				Yes
# optimizer_trace_offset 																						Yes 													Both 				Yes
# original_commit_timestamp 																					Yes 													Session 			Yes
# parser_max_mem_size 							Yes 					Yes 									Yes 													Both 				Yes
# password_history 								Yes 					Yes 									Yes 													Global 			Yes
# password_require_current 					Yes 					Yes 									Yes 													Global 			Yes
# password_reuse_interval 						Yes 					Yes  									Yes 													Global 			Yes
# performance_schema 							Yes 					Yes  									Yes 													Global 			No
# Performance_schema_accounts_lost 																												Yes 				Global 			No
# performance_schema_accounts_size 			Yes 					Yes 									Yes 													Global 			No
# Performance_schema_cond_classes_lost 																										Yes 				Global 			No
# Performance_schema_cond_instances_lost 																										Yes 				Global 			No
#
# performance-schema-consumer 				Yes 					Yes
# -events-stages-current 
#
# performance-schema-consumer 				Yes 					Yes
# -events-stages-history 
#
# performance-schema-consumer 				Yes 					Yes
# -events-stages-history-long 				
#
# performance-schema-consumer 				Yes 					Yes
# -events-statements-current
#
# performance-schema-consumer 				Yes 					Yes
# -events-statements-history
#
# performance-schema-consumer 				Yes 					Yes
# -events-statements-history-long 		
#
# performance-schema-consumer 				Yes 					Yes
# -events-transactions-current 
#
# performance-schema-consumer 				Yes 					Yes
# -events-transactions-history 
#
# performance-schema-consumer 				Yes 					Yes
# -events-transactions-history-long 	
#
# performance-schema-consumer 				Yes 					Yes
# -events-waits-current 
#
# performance-schema-consumer 				Yes 					Yes
# -events-waits-history
# 
# performance-schema-consumer 				Yes 					Yes
# -events-waits-history-long 
#
# performance-schema-consumer 				Yes 					Yes
# -global-instrumentation 
#
# performance-schema-consumer 				Yes 					Yes
# -statements-digest 
#
# performance-schema-consumer 				Yes 					Yes
# -thread-instrumentation 
#
# Performance_schema_digest_lost 																												Yes 				Global 			No
# performance_schema_digests_size 			Yes 					Yes 									Yes 													Global 			No	
# performance_schema_error_size 				Yes 					Yes 									Yes 													Global 			No
# performance_schema_ 							Yes 					Yes 									Yes 													Global 			No
# events_stages_history_long_size
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# stages_history_size 
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# statements_history_long_size 
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# statements_history_size 
# 
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# transactions_history_long_size
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# transactions_history_size 
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# waits_history_long_size 
#
# performance_schema_events_ 					Yes 					Yes 									Yes 													Global 			No
# waits_history_size 
#
# Performance_schema_file_ 																														Yes 				Global 			No
# classes_lost
#
# Performance_schema_file_ 																														Yes 				Global 			No
# handles_lost
#
# Performance_schema_file_ 																														Yes 				Global 			No
# instances_lost
#
# Performance_schema_hosts_lost 																													Yes 				Global 			No
#
# performance_hosts_size  						Yes 					Yes 									Yes 													Global 			No
# Performance_schema_index_stat_lost 																											Yes 				Global 			No
# performance_schema-instrument 				Yes 					Yes 																		
# Performance_schema_locker_lost 																												Yes 				Global 			No
# performance_schema_max_cond_classes 		Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_cond_instances 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_digest_length 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_ 							Yes 					Yes 									Yes 													Global 			Yes
# max_digest_sample_age
# performance_schema_max_file_classes 		Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_file_handles 		Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_file_instances 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_index_stat 		Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_memory_classes 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_metadata_locks 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_mutex_classes 	Yes 					Yes 									Yes 													Global 			No
#
# performance_schema_max_mutex_instances 	Yes 					Yes 									Yes 													Global 			No
#
# performance_schema_max_ 						Yes 					Yes 									Yes 													Global 			No
# prepared_statements_instances
#
# performance_schema_ 							Yes 					Yes 									Yes 													Global 			No
# max_program_instances
#
# performance_schema_ 							Yes 					Yes 									Yes 													Global 			No
# max_rwlock_classes 
#
# performance_schema_max_socket_classes 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_socket_instances Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_sql_text_length 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_stage_classes 	Yes 					Yes 									Yes 													Global 			No
# performance_schema 							Yes 					Yes 									Yes 													Global 			No
# _max_statement_classes 
# performance_schema 							Yes 					Yes 									Yes 													Global 			No
# _max_statement_stack 
#
# performance_schema_max_table_handles 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_table_instances 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_table_lock_stat 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_thread_classes 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_max_thread_instances Yes 					Yes 									Yes 													Global 			No
# Performance_schema_memory_classes_lost 																								Yes 						Global 			No
# Performance_schema_metadata_lock_lost 																								Yes 						Global 			No
# Performance_schema_mutex_classes_lost 																								Yes 						Global 			No
# Performance_schema_mutex_instances_lost 																							Yes 						Global 			No
# Performance_schema_nested_statement_lost 																							Yes 						Global 			No
# Performance_schema_prepared_statements_lost 																						Yes 						Global 			No
# Performance_schema_program_lost 																										Yes 						Global 			No
# Performance_schema_rwlock_classes_lost 																								Yes 						Global 			No
# Performance_schema_rwlock_instances_lost 																							Yes 						Global 			No
# Performance_schema_session_connect_attrs_longest_seen 																			Yes 						Global 			No
# Performance_schema_session_connect_attrs_lost 																					Yes 						Global 			No
#
# performance_schema_ 							Yes 					Yes 									Yes 													Global 			No
# session_connect_attrs_size 
#
# performance_schema_setup_actors_size 	Yes 					Yes 									Yes 													Global 			No
# performance_schema_setup_objects_size 	Yes 					Yes 									Yes 													Global 			No
# Performance_schema_socket_classes_lost 																								Yes 						Global 			No
#
# Performance_schema_ 																														Yes 						Global 			No
# socket_instnaces_lost 
#
# Performance_schema_stage_classes_lost 																								Yes 						Global 			No
# Performance_schema_statement_classes_lost 																							Yes 						Global 			No
# Performance_schema_table_handles_lost 																								Yes 						Global 			No
# Performance_schema_table_instances_lost 																							Yes 						Global 			No
# Performance_schema_table_lock_stat_lost 																							Yes 						Global 			No
# Performance_schema_thread_classes_lost 																								Yes 						Global 			No
# Performance_schema_thread_instances_lost 																							Yes 						Global 			No
# Performance_schema_users_lost 																											Yes 						Global 			No
# performance_schema_users_size 				Yes 					Yes 									Yes 													Global 			No
# persisted_globals_load 						Yes 					Yes 									Yes 													Global 			No
# pid-file 											Yes 					Yes 																							Global 			No
# - Variable: pid_file 																							Yes 													Global 			No
# plugin 											Yes 					Yes 	
# plugin_dir 										Yes 					Yes  									Yes 													Global 			No
# plugin-load 										Yes 					Yes 
# plugin-load-add 								Yes 					Yes
# port 												Yes 					Yes  									Yes 													Global 			No
# port-open-timeout 								Yes 					Yes 									
# 
# preload_buffer_size 							Yes 					Yes 									Yes 													Both 				Yes
# Prepared_stmt_count 																														Yes 						Global 			No
# print-defaults 									Yes 
# profiling 																										Yes 													Both 				Yes
# profiling_history_size 						Yes 					Yes 									Yes 													Both 				Yes
# protocol_version 																								Yes 													Global 			No
# proxy_user 																										Yes 													Session 			No
# pseudo_slave_mode 																								Yes 													Session 			Yes
# psuedo_thread_id 																								Yes 													Session 			Yes
# Qcache_free_blocks 																														Yes 						Global 			No
# Qcache_free_memory 																														Yes 						Global 			No
# Qcache_hits 																																	Yes 						Global 			No
# Qcache_inserts     																														Yes 						Global 			No
# Qcache_lowmem_prunes 																														Yes 						Global 			No
# Qcache_not_cached 																															Yes 						Global 			No
# Qcache_queries_in_cache 																													Yes 						Global 			No
# Qcache_total_blocks 																														Yes 						Global 			No
# Queries 																																		Yes 						Both 				No
# 
# query_alloc_block_size 						Yes 					Yes 									Yes 													Both 				Yes
# query_cache_limit 								Yes 					Yes 									Yes 													Global 			Yes
# query_cache_min_res_unit 					Yes 					Yes 									Yes 													Global 			Yes
# query_cache_size 								Yes 					Yes 									Yes 													Global 			Yes
# query_cache_type 								Yes 					Yes 									Yes 													Both 				Yes
# query_cache_wlock_invalidate 				Yes 					Yes 									Yes 													Both 				Yes
# query_prealloc_size 							Yes 					Yes 									Yes 													Both 				Yes
# Questions 																																	Yes 						Both 				No
# rand_seed1 																										Yes 													Session 			Yes
# rand_seed2 																										Yes 													Session 			Yes
# range_alloc_block_size 						Yes 					Yes 									Yes 													Both 				Yes
# range_optimizer_max_mem_size 				Yes 					Yes 									Yes 													Both 				Yes
# rbr_exec_mode 																									Yes 													Both 				Yes
#
# read_buffer_size 								Yes 					Yes 									Yes 													Both 				Yes
# read_only 										Yes 					Yes 									Yes 													Global 			Yes
# read_rnd_buffer_size 							Yes 					Yes 									Yes 													Both 				Yes
# regexp_stack_limit 							Yes 					Yes 									Yes 													Global 			Yes
# regexp_time_limit 								Yes 					Yes 									Yes 													Global 			Yes
# relay-log 										Yes 					Yes 																							Global 			No
# - Variable: relay_log 																						Yes 													Global 			No
# relay_log_basename 																							Yes 													Global 			No
# relay-log-index 								Yes 					Yes 									 														Global 			No
# - Variable: relay_log_index 																				Yes 													Global 			No
# relay_log_index 								Yes 					Yes 									Yes 													Global 			No
# relay-log-info-file 							Yes 					Yes 																							
# - Variable: relay_log_info_file 
# relay_log_info_file 							Yes 					Yes 									Yes 													Global 			No
# relay-log-info-repository 					Yes 					Yes 	
# - Variable: relay_log_info_repository 	
# relay_log_info_repository 																					Yes 													Global 			Yes
# relay_log_purge 								Yes 					Yes 									Yes 													Global 			Yes
# relay-log-recovery 							Yes 					Yes 
# - Variable: relay_log_recovery 
# relay_log_recovery 							Yes 					Yes 									Yes 													Global 			No
# relay_log_space_limit 						Yes 					Yes 									Yes 													Global 			No
# remove 											Yes
# replicate-do-db 								Yes 					Yes
# replicate-do-table 							Yes 					Yes
# replicate-ignore-db 							Yes 					Yes
# replicate-ignore-table 						Yes 					Yes
# replicate-rewrite-db 							Yes 					Yes
# replicate-same-server-id 					Yes 					Yes
# replicate-wild-do-table 						Yes 					Yes
# replicate-wild-ignore-table 				Yes 					Yes
# report-host 										Yes 					Yes 																							Global 			No
# - Variable: report_host 																						Yes 													Global 			No
# report-password 								Yes 					Yes 																							Global 			No
# - Variable: report_password 																				Yes 													Global 			No
# report-port 										Yes 					Yes 																							Global 			No
# - Variable: report_port 																						Yes 													Global 			No
# report-user 										Yes 					Yes 																							Global 			No
# - Variable: report_user 																						Yes 													Global 			No
# require_secure_transport 					Yes 					Yes 									Yes 													Global 			Yes
# resultset_metadata 																							Yes 													Session 			Yes
# 
# rewriter_enabled 																								Yes 													Global 			Yes
# Rewriter_number_loaded_rules 																												Yes 					Global 			No
# Rewriter_number_reloads 																														Yes 					Global 			No
# Rewriter_number_rewritten_queries 																										Yes 					Global 			No
# Rewriter_reload_error 																														Yes 					Global 			No
# rewriter_verbose 																								Yes 													Global 			Yes
# rpl_read_size 									Yes 					Yes 									Yes 													Global 			Yes
# Rpl_semi_sync_master_clients 																												Yes 					Global 			No
# rpl_semi_sync_master_enabled 																				Yes 													Global 			Yes
# Rpl_semi_sync_master_net_avg_wait_time 																									Yes 					Global 			No
# Rpl_semi_sync_master_net_wait_time 																										Yes 					Global 			No
# Rpl_semi_sync_master_net_waits 																											Yes 					Global 			No
# Rpl_semi_sync_master_no_times 																												Yes 					Global 			No
# Rpl_semi_sync_master_no_tx 																													Yes 					Global 			No
# Rpl_semi_sync_master_status 																												Yes 					Global 			No
# Rpl_semi_sync_master_timefunc_failures 																									Yes 					Global 			No
# rpl_semi_sync_master_timeout 																				Yes 													Global 			Yes
# rpl_semi_sync_master_trace_level 																			Yes 													Global 			Yes
# Rpl_semi_sync_master_tx_avg_wait_time 																									Yes 					Global 			No
# Rpl_semi_sync_master_tx_wait_time 																										Yes 					Global 			No
# Rpl_semi_sync_master_tx_waits 																												Yes 					Global 			No
# rpl_semi_sync_master_wait_for_slave_count 																Yes 													Global 			Yes
#
# rpl_semi_sync_master_wait_no_slave 																		Yes 													Global 			Yes
# rpl_semi_sync_master_wait_point 																			Yes 													Global 			Yes
# Rpl_semi_sync_master_wait_pos_backtraverse 																							Yes 					Global 			No
# Rpl_semi_sync_master_wait_sessions 																										Yes 					Global 			No
# Rpl_semi_sync_master_yes_tx 																												Yes 					Global 			No
# rpl_semi_sync_slave_enabled 																				Yes 													Global 			Yes
# Rpl_semi_sync_slave_status 																													Yes 					Global 			No
# rpl_semi_sync_slave_trace_level 																			Yes 													Global 			Yes
# rpl_stop_slave_timeout 						Yes 					Yes 									Yes 													Global 			Yes
# Rsa_public_key 																																	Yes 					Global 			No
#
# safe-user-create 								Yes 					Yes 
# schema_definition_cache 						Yes 					Yes 									Yes 													Global 			Yes
# Secondary_engine_execution_count 																											Yes 					Both 				No
# secure-auth 										Yes 					Yes 																							Global 			Yes
# - Variable: secure_auth 																						Yes 													Global 			Yes
# secure-file-priv 								Yes 					Yes 																							Global 			No
# - Variable: secure_file_priv 																				Yes 													Global 			No
#
# Select_full_join 																																Yes 					Both 				No
# Select_full_range_join 																														Yes 					Both 				No
# Select_range 																																	Yes 					Both 				No
# Select_range_check 																															Yes 					Both 				No
# Select_scan 																																		Yes 					Both 				No
# server-id 										Yes 					Yes 																							Global 			Yes
# - Variable: server_id 																						Yes 													Global 			Yes
# server_uuid 																										Yes 													Global 			No
# session_track_gtids 							Yes 					Yes 									Yes 													Both 				Yes
# session_track_schema 							Yes 					Yes 									Yes 													Both 				Yes
# session_track_stat_change 					Yes 					Yes 									Yes 													Both 				Yes
# session_track_system_variables 			Yes 					Yes 									Yes 													Both 				Yes
# 
# session_track_transaction_info 			Yes 					Yes 									Yes 													Both 				Yes
# sha256_password_auto_generate_rsa_keys 	Yes 					Yes 									Yes 													Global			No
# sha256_password_private_key_path 			Yes 					Yes 									Yes 													Global 			No
# sha256_password_proxy_users 				Yes 					Yes 									Yes 													Global 			Yes
# sha256_password_public_key_path 			Yes 					Yes 									Yes 													Global 			No
# shared_memory 									Yes 					Yes 									Yes 													Global 			No
# shared_memory_base_name 						Yes 					Yes 									Yes 													Global 			No
# show_compability_56 							Yes 					Yes 									Yes 													Global 			Yes
# show_create_table_verbosity 				Yes 					Yes 									Yes 													Both 				Yes
# show_old_temporals 							Yes 					Yes 									Yes 													Both 				Yes
# show-slave-auth-info 							Yes 					Yes 
# simplified_binlog_gtid_recovery 			Yes 					Yes 									Yes 													Global 			No
# skip-character-set-client-handshake 		Yes 					Yes 
# skip-concurrent-insert 						Yes 					Yes
# - Variable: concurrent_insert 
# skip-event-scheduler 							Yes 					Yes 									
# skip_external_locking 						Yes 					Yes 									Yes 													Global 			No
# skip-grant-tables 								Yes 					Yes 
# skip-host-cache 								Yes 					Yes
# skip-name-resolve 								Yes 					Yes 																							Global 			No
# - Variable: skip_name_resolve 																				Yes 													Global 			No
# skip-ndbcluster 								Yes 					Yes 																							
# skip-networking 								Yes 					Yes 																							Global 			No
# - Variable: skip_networking 																				Yes 													Global 			No
# skip-new 											Yes 					Yes 
# skip-show-database 							Yes 					Yes 																							Global 			No
# - Variable: skip_show_database 																			Yes 													Global 			No
# skip-slave-start 								Yes 					Yes 
# skip-ssl 											Yes 					Yes
# skip-stack-trace 								Yes 					Yes
# slave_allow_batching 							Yes 					Yes 									Yes 													Global 			Yes
# slave-checkpoint-group 						Yes 					Yes 
# - Variable: slave_checkpoint_group 
# slave_checkpoint_period 						Yes 					Yes 									Yes 													Global 			Yes
# slave_compressed_protocol 					Yes 					Yes 									Yes 													Global 			Yes
# slave_exec_mode 								Yes 					Yes 									Yes 													Global 			Yes
#
# Slave_heartbeat_period 																												Yes 							Global 			No
# Slave_last_heartbeat 																													Yes 							Global 			No
# slave-load-tmpdir 								Yes 					Yes 																							Global 			No
# - Variable: slave_load_tmpdir 																				Yes 													Global 			No
# slave-max-allowed-packet 					Yes 					Yes 
# - Variable: slave_max_allowed_packet 	
# slave_max_allowed_packet 																					Yes 													Global 			Yes
# slave-net-timeout 								Yes 					Yes 																							Global 			Yes
# - Variable: slave_net_timeout 																				Yes 													Global 			Yes
# Slave_open_temp_tables 																												Yes 							Global 			No
# slave-parallel-type 							Yes 					Yes 
# - variable: slave_parallel_type 
# slave_parallel_type 																							Yes 													Global 			Yes
# slave-parallel-workers 						Yes 					Yes 
# - Variable: slave_parallel_workers 		
# slave_parallel_workers 						Yes 															Yes 													Global 			Yes
# slave-pending-jobs-size-max 				Yes 
# - Variable: slave_pending_jobs_size_max 
# slave_pending_jobs_size_max 				Yes 															Yes 													Global 			Yes
# 
# slave_preserve_commit_order 				Yes 															Yes 													Global 			Yes
# Slave_received_heartbeats 																											Yes 							Global 			No
# Slave_retried_transactions 																											Yes 							Global 			No
# Slave_rows_last_search_algorithm_used 																							Yes 							Global 			No
# slave-rows-search-algorithms 				Yes 					Yes 
# - Variable: slave_rows_search_algorithms
# slave_rows_search_algorithms 																				Yes 													Global 			Yes
# Slave_running 																															Yes 							Global 			No
# slave-skip-errors 								Yes 					Yes 																							Global 			No
# - Variable: slave_skip_errors 																				Yes 													Global 			No
# slave-sql-verify-checksum 					Yes 					Yes 
# slave_sql_verify_checksum 																					Yes 													Global 			Yes
# slave_transaction_retries 					Yes 					Yes 									Yes 													Global 			Yes
# slave_type_conversions 						Yes 					Yes 									Yes 													Global 			No
# Slow_launch_threads 																													Yes 							Both 				No
# slow_launch_time 								Yes 					Yes 									Yes 													Global 			Yes
# Slow_queries 																															Yes 							Both 				No
# slow-query-log 									Yes 					Yes 																							Global 			Yes
# - Variable: slow_query_log 																					Yes 													Global 			Yes
# slow_query_log_file 							Yes 					Yes 									Yes 													Global 			Yes
#
# slow-start-timeout 							Yes 					Yes 
# socket 											Yes 					Yes 									Yes 													Global 			No
# sort_buffer_size 								Yes 					Yes 									Yes 													Both 				Yes
# Sort_merge_passes 																														Yes 							Both 				No
# Sort_range 																																Yes 							Both 				No
# Sort_rows 																																Yes 							Both 				No
# Sort_scan 																																Yes 							Both 				No
# sporadic-binlog-dump-fail 					Yes 					Yes 
# sql_auto_is_null 																								Yes 													Both 				Yes
# sql_big_selects 																								Yes 													Both 				Yes
# sql_buffer_result 																								Yes 													Both 				Yes
# sql_log_bin 																										Yes 													Session 			Yes
# sql_log_off 																										Yes 													Both 				Yes
# sql-mode 											Yes 					Yes 																							Both 				Yes
# - Variable: sql_mode 																							Yes 													Both 				Yes
# sql_notes 																										Yes 													Both 				Yes
# sql_quote_show_create 																						Yes 													Both 				Yes
# sql_require_primary_key 						Yes 					Yes 									Yes 													Both 				Yes
# sql_safe_updates 																								Yes 													Both 				Yes
# sql_select_limit 																								Yes 													Both 				Yes
# sql_slave_skip_counter 																						Yes 													Global 			Yes
# sql_warnings 																									Yes 													Both 				Yes
# ssl 												Yes 					Yes 												
# 
# Ssl_accept_renegotiates 																												Yes 							Global 			No
# Ssl_accepts 																																Yes 							Global 			No
# ssl-ca 											Yes 					Yes 																							Global 			No
# - Variable: ssl_ca 																							Yes 													Global 			No
# Ssl_callback_cache_hits 																												Yes 							Global 			No
# ssl-capath 										Yes 					Yes 																							Global 			No
# - Variable: ssl_capath 																						Yes 													Global 			No
# ssl-cert 											Yes 					Yes 																							Global 			No
# - Variable: ssl_cert 																							Yes 													Global 			No
# Ssl_cipher 																																Yes 							Both 				No
# ssl-cipher 										Yes 					Yes 																							Global 			No
# - Variable: ssl_cipher 																						Yes 													Global 			No
# Ssl_cipher_list 																														Yes 							Both 				No
# Ssl_client_connects 																													Yes 							Global 			No
# Ssl_connect_renegotiates 																											Yes 							Global 			No
# ssl-crl 											Yes 					Yes 																							Global 			No
# - Variable: ssl_crl 																							Yes 													Global 			No
# ssl-crlpath 										Yes 					Yes 																							Global 			No
# - Variable: ssl_crlpath 																						Yes 													Global 			No
# Ssl_ctx_verify_depth 																													Yes 							Global 			No
# Ssl_ctx_verify_mode 																													Yes 							Global 			No
# Ssl_default_timeout 																													Yes 							Both 				No
# Ssl_finished_accepts 																													Yes 							Global 			No
#
# Ssl_finished_connects 																												Yes 							Global 			No
# ssl_fips_mode 									Yes 					Yes 									Yes 													Global 			Yes
# ssl-key 											Yes 					Yes 																							Global 			No
# - Variable: ssl_key 																							Yes 													Global 			No
# Ssl_server_not_after 																													Yes 							Both 				No
# Ssl_server_not_before 																												Yes 							Both 				No
# Ssl_session_cache_hits 																												Yes 							Global 			No
# Ssl_session_cache_misses 																											Yes 							Global 			No
# Ssl_session_cache_mode 																												Yes 							Global 			No
# Ssl_session_cache_overflows 																										Yes 							Global 			No
# Ssl_session_cache_size 																												Yes 							Global 			No
# Ssl_session_cache_timeouts 																											Yes 							Global 			No
# Ssl_sessions_reused 																													Yes 							Both 				No
# Ssl_used_session_cache_entries 																									Yes 							Global 			No
# Ssl_verify_depth 																														Yes 							Both 				No
# Ssl_verify_mode 																														Yes 							Both 				No
# Ssl_version 																																Yes 							Both 				No
# standalone 										Yes 					Yes 
# stored_program_cache 							Yes 					Yes 									Yes 													Global 			Yes
# stored_program_definition_cache 			Yes 					Yes 									Yes 													Global 			Yes
# super-large-pages 								Yes 					Yes 
# super_read_only 								Yes 					Yes 									Yes 													Global 			Yes
# symbolic-links 									Yes 					Yes 
# sync_binlog 										Yes 					Yes 									Yes 													Global 			Yes
# sync_master_info 								Yes 					Yes 									Yes 													Global 			Yes
# 
# sync_relay_log 									Yes 					Yes 									Yes 													Global 			Yes
# sync_relay_log_info 							Yes 					Yes 									Yes 													Global 			Yes
# sysdate-is-now 									Yes 					Yes 
# syseventlog.facility 							Yes 					Yes 									Yes 													Global 			Yes
# syseventlog.include_pid 						Yes 					Yes 									Yes 													Global 			Yes
# syseventlog.tag 								Yes 					Yes 									Yes 													Global 			Yes
# system_time_zone 																								Yes 													Global 			No
# table_definition_cache 																						Yes 													Global 			Yes
# Table_locks_immediate 																												Yes 							Global 			No
# Table_locks_waited 																													Yes 							Global 			No
# table_open_cache 																								Yes 													Global 			Yes
# Table_open_cache_hits 																												Yes 							Both 				No
# table_open_cache_instances 																					Yes 													Global 			No
# Table_open_cache_misses 																												Yes 							Both 				No
# Table_open_cache_overflows 																											Yes 							Both 				No
# tablespace_definition_cache 				Yes 					Yes 									Yes 													Global 			Yes
# tc-heuristic-recover 							Yes 					Yes 
# Tc_log_max_pages_used 																												Yes 							Global 			No
# Tc_log_page_size 																														Yes 							Global 			No
# Tc_log_page_waits 																														Yes 							Global 			No
# temp-pool 										Yes 					Yes 
# 
# temptable_max_ram 								Yes 					Yes 									Yes 													Global 			Yes
# thread_cache_size 								Yes 					Yes 									Yes 													Global 			Yes
# thread_handling 								Yes 					Yes 									Yes 													Global 			No
# thread_pool_algorithm 						Yes 					Yes 									Yes 													Global 			No
# thread_pool_high_priority_connection 	Yes 					Yes 									Yes 													Both 				Yes
# thread_pool_max_unused_threads 			Yes 					Yes 									Yes 													Global 			Yes
# thread_pool_prio_kickup_timer 				Yes 					Yes 									Yes 													Both 				Yes
# thread_pool_size 								Yes 					Yes 									Yes 													Global 			No
# thread_pool_stall_limit 						Yes 					Yes 									Yes 													Global 			Yes
#
# thread_stack 									Yes 					Yes 									Yes 													Global 			No
# Threads_cached 																															Yes 							Global 			No
# Threads_connected 																														Yes 							Global 			No
# Threads_created 																														Yes 							Global 			No
# Threads_running 																														Yes 							Global 			No
# time_format 																										Yes 													Global 			No
# time_zone 																										Yes 													Both 				Yes
# timestamp 																										Yes 													Session 			Yes
# tls_version 										Yes 					Yes 									Yes 													Global 			No
# tmp_table_size 									Yes 					Yes 									Yes 													Both 				Yes
# tmpdir 											Yes 					Yes 									Yes 													Global 			No
# transaction_alloc_block_size 				Yes 					Yes 									Yes 													Both 				Yes
# transaction_allow_batching 																					Yes 													Session 			Yes
# transaction-isolation 						Yes 					Yes  																							Both 				Yes
# - Variable: transaction_isolation 																		Yes 													Both 				Yes
# transaction_prealloc_size 					Yes 					Yes 									Yes 													Both 				Yes
# transaction-read-only 						Yes 					Yes 																							Both 				Yes
# - Variable: transaction_read_only 																		Yes 													Both 				Yes
# 
# transaction_write_set_extraction 			Yes 															Yes 													Both 				Yes
# tx_isolation 																									Yes 													Both 				Yes
# tx_read_only 																									Yes 													Both 				Yes
# unique_checks 																									Yes 													Both 				Yes
# updatable_views_with_limit 					Yes 					Yes 									Yes 													Both 				Yes
# Uptime 																																	Yes 							Global 			No
# Uptime_since_flush_status 																											Yes 							Global 			No
# use_secondary_engine 																							Yes 													Session 			Yes
# user 												Yes 					Yes 
# validate-password 								Yes 					Yes
# validate_password_check_user_name 		Yes 					Yes 									Yes 													Global 			Yes
# validate_password_dictionary_file 																		Yes 													Global 			Yes
# validate_password_dictionary_file_last_parsed 																				Yes 							Global 			No
# validate_password_dictionary_file_words_count 																				Yes 							Global 			No
# validate_password_length 																					Yes 													Global 			Yes
# validate_password_mixed_case_count 																		Yes 													Global 			Yes
# validate_password_number_count 																			Yes 													Global 			Yes
# validate_password_policy 																					Yes 													Global 			Yes
# validate_password_special_char_count 																	Yes 													Global 			Yes
# validate_password.check_user_name 		Yes 					Yes 									Yes 													Global 			Yes
# validate_password.dictionary_file 																		Yes 													Global 			Yes
# validate_password.dictionary_file_last_parsed 																				Yes 							Global 			No
# validate_password.dictionary_file_words_count 																				Yes 							Global 			No
# validate_password.length 																					Yes 													Global 			Yes
# validate_password.mixed_case_count 																		Yes 													Global 			Yes
# validate_password.number_count 																			Yes 													Global 			Yes
# validate_password.policy 																					Yes 													Global 			Yes
# validate_password.special_char_count 																	Yes 													Global 			Yes
# validate_user_plugins 																						Yes 													Global 			No
# verbose 											Yes 					Yes 
# version 																											Yes 													Global 			No
# version_comment 																								Yes 													Global 			No
# version_compile_machine 																						Yes 													Global 			No
# version_compile_os 																							Yes 													Global 			No
# version_compile_zlib 																							Yes 													Global 			No
# version_tokens_session 						Yes 					Yes 									Yes 													Both 				Yes
# version_tokens_session_number 				Yes 					Yes 									Yes 													Both 				No
# wait_timeout 									Yes 					Yes 									Yes 													Both 				Yes
# warning_count 																									Yes 													Session 			No
# windowing_use_high_precision 				Yes 					Yes 									Yes 													Both 				Yes
#
# The following pertain to the Server Command Options of mysqld:
#
# mysqld reads options from the [mysqld] and [server] groups.
# mysqld_safe reads options from the [mysqld], [server], [mysqld_safe] and [safe_mysqld] groups.
#
# mysql.server reads options from the [mysqld] and [mysql.server] groups
#
# Memory allocations in size and defaulting is dependant upon platform.
#
# Values default to bytes in memory allocations in terms of buffer sizes, lengths, and stack sizes - unless specified otherwise.
#
# Note: Values are hints - MySQL retains freedom in assignments.
#
# 		Property 					 
# --allow-suspicious-udfs 		 					 						  
# 
#   cmd-line format - --allow-suspicious-udfs 
# 	 Type 				 Boolean
#   Default Value 	 FALSE
#
# 	 Controls whether user-defined functions that have only an xxx symbol for the main function can be loaded.
#   By default - is off and only UDFs that have at least one auxilliary symbol can be loaded; prevents attempts at loading
# 	 functions from shared object files other than those containing legit UDFs.
#
# --ansi
# 
# 	 cmd-line format 	--ansi
#
# 	 Use standard (ANSI) SQL Syntax instead of MySQL syntax. 
#   For more precise control over the server SQL mode - use --sql-mode instead.
#
# --basedir=<dir name>, -b <dir name>
#
# 	 cmd-line format 			--basedir=dir_name
# 	 System Var 				basedir
# 	 Scope 						Global
# 	 Dynamic 				 	No
# 	 SET_VAR Hint Applies  	No
#   Type 						Dir name
#   Default (>= 8.0.2) 		parent of mysqld installation dir
#   Default (<= 8.0.1) 		configuration-dependent default
#
# 	 The path to the MySQL installation dir. This option sets the basedir system var.
#
# 	 The server executable determines its own full path name at startup and uses the parent of the dir in which
# 	 it is located as the default basedir value.
#
# 	 This in turn enables the server to use that basedir when searching for server-related info such as the share dir containing error messages.
#
# --big-tables
#
# 	cmd-line format 			--big-tables
# 	System var 					big_tables
# 	Scope 						Global, Session
# 	Dynamic 						Yes
# 	SET_VAR Hint: 				No
# 	Type 							Boolean
# 	Default 						OFF
#
# 	Enable large result sets by saving all temp sets in files. This option prevents most 
# 	"table full" errors, but also slows down queries for which in-memory tables would suffice.
#
# 	The server is able to handle large result sets automatically by using memory for smaller temp tables and
#  switching to disk tables where necessary.
#
# --bind-address=<addr>
#
# cmd-line format 			--bind-address=addr
# System var 					bind_address
# Scope 							Global
# Dynamic 						No
# SET_VAR Hint Applies 		No
# Type 							String
# Default to 					*
#
# The MySQL server listens on one or more network sockets for TCP/IP connections.
# Each socket is bound to one address - but it is possible for an address to map onto
# multiple network interfaces.
#
# To specify how the server should listen for TCP/IP connections, use the --bind-address option at server startup
#
# < 8.0.13 - Accepts a single address value, which may specify a single non-wildcard IP address or host name, or one of the
#  			 wildcard address formats that permit listening on multiple network interfaces (*, 0.0.0.0 or ::)
#
# >= 8.0.13 - accepts a single value as just described, or a list of comma-separated values. When the opption names a list of
#  			  multiple values, each value must specify a single non-wildcard IP address or host name - i.e NONE may have (*, 0.0.0.0, or ::)
#
# IPs can be specified as IPv4 or IPv6. For any option that is a host name - the server resolves the name to an IP and binds to that address.
# If a host name resolves to multiple IP addresses, the server uses the first IPv4 address if there are any, or the first IPv6 address otherwise.
#
# The server treats different types of addresses as follows:
#
# 		If the address is *, the server accepts TCP/IP connections on all server host IPv4 interfaces - and IPv6 if supported.
# 		This is the default behavior.  - If multiple values are specified, this is not allowed as a value.
#
# 		If the address is 0.0.0.0, the server accepts TCP/IP connections on all server host IPv4 interfaces. Not permitted with a list of several values.
#
# 		If the address is ::, the server accepts TCP/IP connections on all server host IPv4 and IPv6 interfaces. Not permitted with a list of several values.
#
# 		If the address is an IPv4-mapped address, the server accepts TCP/IP connections for that address - in either IPv4 or IPv6.
#	 	Example: If server is bound to ::ffff:127.0.0.1 - Clients can connect using --host=127.0.0.1 or --host=::ffff:127.0.0.1
#
# 		If the address is a regular IPv4 or IPv6 address - such as 127.0.0.1 or ::1, the server accepts TCP/IP only for that IPv4 or IPv6.
#
# 		If binding to any address fails, server procedure fails and does not start.
#
# 		Some examples:
#
# 		--bind-address=* - Listens on all IPv4 or IPv6 - specified by *
#
# 		--bind-address=198.51.100.20 - Listens only on the 198.51.100.20 IPv4 address.
#
# 		--bind-address=198.51.100.20, 2001:db8:0:f101::1 - The server listens on the 198.51.100.20 IPv4 and 2001:db8:0:f101::1 IPv6
#
# 		--bind-address=198.51.100.20,* - Produces an error, Can't use wildcards with multiple designated values.
#
# 		When --bind-address names a single value (wildcard or non-wildcard) - the server listens on a single socket, which for a wildcard
# 		address may be bound to multiple network interfaces. 
#
# 		When it lists multiple values - the server listens on one socket per value - with each socket bound to a single network
# 		interface. This scaling is linear, i.e 1:1. Can come to affect connection-acceptance efficiency depending on the OS - long lists can cause overhead.
#
# 		If we intend to bind the server to a specific address - the mysql.user grant table must contain an account with admin privs that can connect to that 
# 		address.
#
# 		Otherwise - we cannot shut down the server. For example - if we bind the server to * - we can connect to it using all existing accounts.
# 		But if we bind to ::1, we'd need admin privs on root in terms of ::1 - as in 'root'@'::1' exists in the mysql.user table.
#
# --binlog-format={ROW|STATEMENT|MIXED}
#
# 		cmd line format: 		--binlog-format=format
# 		System var: 			binlog_format
# 		Scope 					Global, Session
# 		Dynamic 					Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Defaults: 				ROW
# 		Can take: 				ROW, STATEMENT, MIXED
#
# 		Specify wether to use row-based, statement-based or mixed replication. Statement is default in >= 8.0
#
# 	 	Sometimes the var cannot be changed during runtime - or causes replication to fail.
#
# 		Setting the binary logging format without enabling binary logging sets the binlog format global sys var and logs a warning.
# 
# --character-sets-dir=<dir name>
#
# 		cmd line format: 		--character-sets-dir=dir_name
# 		Sys Var: 				character_sets_dir
# 		Scope: 					Global
# 		Dynamic 					No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name
#
# 		The dir where char sets are installed
#
# --character-set-client-handshake
# 
# 		cmd line format: 		--character-set-client-handshake
# 		Type: 					Boolean
# 		Defaults: 				TRUE
#
# 		Do not ignore char set info sent by the client. 
# 		To ignore client info and use the default server char set, use --skip-character-set-client-handshake.
# 		(Causes behavior akin to MySQL 4.0)
#
# --character-set-filesystem=<charset name>
# 		
# 		cmd line format: 		--character-set-filesystem=name
# 		System Var: 			character_set_filesystem
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Defaults: 				Binary
#
# 		The filesystem char set. Sets the char set filesystem System var.
#
# --character-set-server=<charset name>, -C <charset_name>
#
# 		cmd line format: 		--character-set-server
# 		System var: 			character_set_server
# 		Scope: 					global, session
#		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1): 	utf8mb4
# 		Default (8.0.0): 		latin1
#
# 		Use <charset_name> as the default server char set. To specify a nondefault char set - use --collation-server to specify the collation.
#
# --chroot=<dir name>, -r <dir_name>
#
# 	 	cmd line format: 		--chroot=dir_name
# 		Type: 					Dir name
#
# 		Put the mysqld server in a closed env during startup by using the chroot() system call.
# 		Recommended security measure - limits interaction of LOAD_DATA_INFILE and SELECT ... INTO OUTFILE
#
# --collation-server=<collation_name>
#
# 		cmd line format: 		--collation-server
# 		System var: 			collation_server
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4_0900_ai_ci
# 		Default (8.0.0) 		latin1_swedish_ci
#
# 		Use collation_name as the default server collation.
#
# --console
#
# 		cmd line format: 		--console 
# 		OS: 						Windows
#
# 		Cause the default error log destination to be the console. This affects log writers that base
# 		their own output destination on the default destination.
#
# 		Takes precedence over --log-error if both are given
#
# --core-file
# 
# 		cmd line format: 		--core-file
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Write a core file if mysqld dies. Name and location of the core file is system dependent.
# 		On Linux, a core file named core.pid is written to the current working dir of the process, which for
# 		mysqld is the data dir.
#
# 		pid is the process ID of the server process. On macOS, a core file named core.pid is written
# 		to the /cores dir. On Solaris, use the coreadm cmd to specify where to write the core file and how to name it.
#
# 		For some systems, to get a core file you must also specify the --core-file-size option to mysqld_safe.
# 		On some systems, such as Solaris, you do not get a core file if you are also using the --user option.
# 		
# 		This may cause the need to write ulimit -c unlimited before starting the server.
#
# 		To reduce the size of core files - the innodb buffer pool in core file options can be disabled to prevent
# 		InnoDB buffer pool pages from being written to core files.
# 
# --daemonize, -D
# 		
#
# 		cmd line format: 			--daemonize[={OFF|ON}]
# 		Type 							Boolean
# 		Default: 					OFF
#
# 		Causes the server to run as a traditional, forking daemon, permitting it to work with OS systems that use
# 		systemd for process control.
#
# 		Mutually exclusive with --initialize and --initialize-secure
#
# 		If the server is started using the --daemonize option and is not connected to a tty device - a default log error option
# 		of --log-error="" is used in absence of explicit log file, to direct the error output to the default log file.
#
# 		-D is shorthand for this command.
#
# --datadir=<dir name>, -h <dir_name>
#
# 		cmd line format: 		--datadir=<dir_name>
# 		System var: 			datadir
# 		Scope:					Global
# 		Dynamic: 				No
# 		SET_VAR hint 			No
# 		Type: 					Dir name
#
# 		Path to the MySQL server data dir. This option sets the datadir sys var.
#
# --debug[=<debug options>], -# [<debug_options>]
#
# 		cmd line format: 		--debug[=<debug_options>]
# 		Sys var: 				debug
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR hint 			No
# 		Type: 					String
# 		default (Windows): 	d:t:i:O, \mysqld.trace
# 		default (Unix): 		d:t:i:o, /tmp/mysqld.trace
#
# 		If MySQL is configured with the -DWITH_DEBUG=1 CMake option, you can use this option to get a trace
# 		file of what mysqld is doing.
#
# 		A typical <debug_options> string is d:t:o, <file_name>.
# 		
# 		Using -DWITH_DEBUG=1 to configure MySQL with debug support enables you to use the --debug="d,parser_debug" option
# 		when you start the server.
#
# 		This causes the Bison parser that is used to process SQL statements to dump a parser trace to the server's STD error output.
# 		Typically, this output is written to the error log.
#
# 		Stacks. Values that begin with + or - are subtracted from the previous value. For example:
# 		--debug=T --debug=+P sets the value to P:T
#
# --debug-sync-timeout[=N]
# 		
# 		cmd line format: 			--debug-sync-timeout[=#]
# 		Type: 						Integer
#
# 		Controls whether the Debug Sync facility for testing and debugging is enabled. Use of Debug Sync
# 		requires that MySQL be configured with the -DENABLE_DEBUG_SYNC=1 CMake option.
#
# 		If not compiled-in, this option is not available. The option value is timeout in seconds.
# 		Defaults to 0, which disables Debug Sync.
#
# 		To enable it, specify a value greater than 0; this value also becomes the default timeout for
# 		individual synchronization points.
#
# 		If the option is given without a value - the timeout is set to 300 seconds.
#
# --default-storage-engine=<type>
#
# 		cmd line format: 			--default-storage-engine=name
# 		System var: 				default_storage_engine
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Enumeration
# 		Defaults to: 				InnoDB
#
# 		Set the default storage engine for tables. Sets the storage engine for permanent tables only.
# 		To set for temp tables - set the default_tmp_storage_engine sys Var.
#
# 		If you disable the default storage engine at server startup, you must set the default engine for both
# 		permanent and temp tables to a different engine or the server won't start
#
# --default-time-zone=<timezone>
#
# 		cmd line format: 			--default-time-zone=name
# 		Type: 						String
#
# 		Set the default server time zone. This option sets the global time zone Sys var.
# 		If not given, defaults to sys time zone - same as sys time zone sys var
#
# --defaults-extra-file=<file name>
#
# 		Read this option file after the global option file but (on Unix) before the user option file.
# 		If the file does not exist or is otherwise inaccessible, an error occurs.
# 		Relative if relative, Absolute if Absolute.
#
# 		Must be the first option given if used on the cmd line.
#
# --defaults-file=<file name>
# 
#		Read only the given option file. If the file does not exist or is otherwise inaccessible, an error occurs.
# 		Relative if relative, absolute if absolute.
#
# 		Still reads mysqld-auto.cnf
#
# 		Must be first option on cmd, except if server is started with --defaults-file and --install (or --install-manual) options.
# 		(Then --install/--install-manual must be first)
#
# --defaults-group-suffix=<str>
#
# 		Read not only the usual option groups - but also the groups with usual names and suffix of <str>.
# 		Regex onm suffix of groups to read.
#
# --delay-key-write[={OFF|ON|ALL}]
#
# 		cmd line format: 		--delay-key-write[=name]
# 		Sys var: 				delay_key_write
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR hint: 			No
# 		Type: 					Enumeration
# 		Default: 				ON
# 		ACCEPTS: 				ON/OFF/ALL
#
# 		Specify how to use delayed key writes. Delayed key writing causes key buffers not to be flushed between
# 		writes for MyISAM tables.
#
# 		OFF disables delayed key writes.
# 		ON enables delayed key writes for those tables that were created with the DELAY_KEY_WRITE option.
# 		ALL delay key writes for all MyISAM tables.
#
# 		NOTE: If set to ALL, one should not use MyISAM tables from within another program (such as another MySQL server or
# 				myisamchk) when the tables are in use. Causes index corruption if you do.
#
# --des-key-file=<file name>
#
# 	 	cmd line format: 		--des-key-file=<file_name>
# 		Deprecated: 			Yes
#
# --early-plugin-load=<plugin list>
#
# 		cmd line format: 		--early-plugin-load=<plugin_list>
# 		Type: 					String
# 		Defaults: 				Empty string
#
# 		This option tells the server which plugins to load before loading mandatory built-in plugins and before storage engine initialization.
# 		If multiple --early-plugin-load options are given, only the last one is used.
#
# 		The option value is a semicolon-separated list of <name>=<plugin_library> and <plugin_library> values.
#
# 		Each <name> is the name of a plugin to load, and <plugin_library> is the name of the library file that contains the plugin code.
# 		If a plugin library is named without any preceding plugin name - the server loads all plugins in the library.
#
# 		The server looks for plugin lib files in the dir named by the <plugin dir> Sys var.
#
# 		For example, if plugins named myplug1 and myplug2 have lib files myplug1.so and myplug2.so, use this option to perform an early plugin load:
#
# 			mysqld --early-plugin-load="myplug1=myplug1.so;myplug2=myplug2.so"
#
# 		Quotes are used around the arg value because otherwise a ; is treated as command eliminator in terms of for instance Unix systems.
#
# 		Each named plugin is loaded early for a single invocation of mysqld only.
# 		After a restart, the plugin is not loaded early unless --early-plugin-load is used again.
#
# 		If the server uses --initialize or --initialize-secure, plugins specified by --early-plugin-load are not loaded.
#
# 		If the server is run with --help, plugins specified by --early-plugin-load are loaded but not initialized. Ensures that
# 		plugin options are displayed in the help messages.
#
# 		Default of --early-plugin-load value is empty. To load the keyring_file plugin, you must use an explicit --early-plugin-load option with
# 		a nonempty value.
#
# 		The InnoDB tablespace encryption feature relies on the keyring_file plugin for encryption key management,
# 		and the keyring_file plugin must be loaded prior to storage engine initialization to facilitate InnoDB recovery for encrypted tables.
#
# 		Admins who want the keyring_file plugin loaded at startup should use the appropiate nonempty option value.
# 		For example - keyring_file.so on Unix and keyring_file.dll on Windows.
#
# --enable-named-pipe
#
# 		cmd line format: 			--enable-named-pipe
# 		Platform specific: 		Windows
#
# 		Enable support for named pipes. Applies only on Windows.
#
# --event-scheduler[=<value>]
# 		
# 		cmd line format: 			--event-scheduler[=<value>]
# 		Sys var: 					event_scheduler
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR hint: 				No
# 		Type: 						Enumeration
# 		Default (>= 8.0.3) 		On
# 		Default (<= 8.0.2) 		OFF
# 		Valid: 						ON/OFF/DISABLED
#
# 		For more info on this, see --event-scheduler.
# 		Enable, disable - start or stop the event scheduler.
#
# --exit-info[=<flags>], -T [<flags>]
#
# 		cmd line format: 			--exit-info[=<flags>]
# 		Type: 						Integer
#
# 		This is a bitmask of different flags that you can use for debugging the mysqld server.
# 		
# --external-locking
#
# 		cmd line format: 			--external-locking
# 		Type: 						Boolean
# 		Defaults: 					FALSE
#
# 		Enable external locking (system locking), which is disabled by default.
#
# 		If you use this option on a system on which lockd does not fully work (such as Linux),
# 		mysqld can easily deadlock.
#
# 		To disable external locking explicitly, use --skip-external-locking.
#
# 		External locking affects only MyISAM table access. 
#
# --flush
#
# 		cmd line format: 			--flush
# 		Sys Var 						flush
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Boolean
# 		Defaults: 					OFF
#
# 		Flush (synchronize) all changes to disk after each SQL statement. 
#
# 		Normally, MySQL does a write of all changes to disk only after each SQL statement
# 		and lets the OS handle the synch to disk.
#
# 		Note: If activated, flush time is ignored.
#
# --gdb 
#
# 		cmd line format: 			--gdb
# 		Type: 						Boolean
# 		default: 					FALSE
#
# 		Install an interrupt handler for SIGINT (needed to stop mysqld with ^C to set breakpoints) and disable stack tracking
# 		and core file handling.
#
# 		On Windows, this option also suppresses the forking that is used to implement the RESTART statement:
#
# 			Forking enables one process to act as a monitor to the other, which acts as the server.
#
# 			However, forking makes determining the server process to attach to for debugging more difficult,
# 			so starting the server with --gdb suppresses forking.
# 
# 			For a server started with this, RESTART simply exits and does not restart.
#
# 			In non-debug settings, --no-monitor may be used to suppress forking the monitor process.
#
# --general-log[={0|1}]
#
# 		cmd line format: 			--general-log
# 		Sys var: 					general_log
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR hint: 				No
# 		Type: 						Boolean
# 		Defaults: 					OFF
#
# 		Specify the initial general query log state. With no argument or an argument of 1, the --general-log option enables the log.
# 		If omitted or given with an arg of 0 - the option disables the log.
#
# --initialize, -I
#
# 		cmd line format: 			--initialize
# 		Type: 						Boolean
# 		Defaults: 					OFF
#
# 		Initializes a mysql installation by creating the data dir and populating the tables in the mysql system DB.
# 		
# 		When the server is started with --initialize, some functionality is unavailable that limits the statements permitted
# 		in any file named by the --init-file option.
#
# 		In addition, disabled_storage_engine sys var has no effect.
#
# 		--initialize is mutually exclusive with --daemonize 
#
# 		-I is a synonym for --initialize
#
# --initialize-insecure
#
# 		cmd line format: 			--initialize-insecure
# 		Type: 						Boolean
# 		Default: 					OFF
#
# 		This option is used to initialize a MySQL installation by creating the data dir and populating the tables
# 		in the mysql system DB. This option implies --initialize.
#
# 		--initialize-insecure is mutually exclusive with --daemonize.
#
# --init-file=<file name>
#
# 		cmd line format: 			--init-file=file_name
# 		Sys var: 					init_file
# 		Scope: 						Global 
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						File name
#
# 		Read the SQL statements from this file at the startup. Each statement must be on a single line and should not include comments.
#
# 		If the server is started with the --initialize or --initialize-insecure option, it operates in bootstrap mode and some
# 		functionality is unavailable that limits the statements permitted in the file.
#
# 		These include statements that are related to account management (such as CREATE USER or GRANT), replication and global transaction identifiers.
#
# --innodb-<xxx>
#
# 		Set an option for the InnoDB storage engine. The InnoDB options are listed later.
#
# --install [<service name>]
# 
# 		cmd line format: 			--install [service_name]
# 		Platform: 					Windows
#
# 		Install the server as a Windows Service that starts automatically when Windows does as well.
# 		Defaults to MySQL if no Service_name value is given.
#
# 		If server is started with --defaults-file and --install, --install must be first.
#
# --install-manual [<service name>]
# 		
# 		cmd line format: 			--install-manual [<service_name>]
# 		Platform: 					Windows
#
# 		Install the server as a Windows service that must be started manually. Does not start automatically during Windows boot cycle.
# 		Default service name is MySQL if no service_name is given.
#
# 		--install-manual first if --defaults-file and --install-manual given.
#
# --language=<lang name>, -L <lang name>
#
# 		cmd line format: 			--language=name
# 		Deprecated: 				Yes; use lc-messages-dir
# 		Sys Var: 					language
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						Dir name
# 		Default value: 			/usr/local/mysql/share/mysql/english/
#
# 		The language to use for error messages. <lang_name> can be given as the language name or as the full path name to the dir
# 		where the language files are installed.
#
# 		--lc-messages-dir and --lc-messages should be used rather than --language, which is deprecated (and handeled as an alias for --lc-messages-dir).
# 		--language will be removed in a future MySQL release.
#
# --large-pages
# 
# 		cmd line format: 			--large-pages
# 		Sys var: 					large_pages
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR hint: 				No
# 		Platform specific: 		Linux
# 		Type: 						Boolean
# 		Default: 					FALSE
#
# 		Some hardware/OS architechtures support memory pages greater than the default (4kb normally)
# 		The actual implementation of this support depends on the underlying hardware and OS.
#
# 		Applications that perform a lot of memory accesses may obtain performance improvements by using
# 		large pages due to reduced Translation Lookaside Buffer (TLB) Misses.
#
# 		Disabled by default.
#
# 		MySQL supports the Linux implementation of large page support (which is called HugeTLB) in Linux.
#
# 		For solaris, this pertains to --super-large-pages.
#
# --lc-messages=<locale name>
#
# 		cmd line format: 			--lc-messages=name
# 		Sys var: 					lc_messages
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						String
# 		Default: 					en_US
#
# 		The locale to use for error messages. Defaults to en_US. The server converts
# 		the args to a language name and combines it with the value of --lc-messages-dir to produce the location
# 		for the error message file.
#
# --lc-messages-dir=<dir name>
#
# 		cmd line format: 			--lc-messages-dir=dir_name
# 		Sys var: 					lc_messages_dir
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						Dir name
#
# 		The dir where error messages are located. The server uses the value together with the value
# 		of --lc-messages to produce the location for the error message file.
#
# --local-service
#
# 		cmd line format: 			--local-service
# 		
# 		Windows based: A --local-service option following the service name causes the server to run using the
# 							LocalService Windows acc that has limited sys privs.
#
# 							If both --defaults-file and --local-service are given following the service name, they can be in any order.
#
# --log-error[=<file name>]
#
# 		cmd line format: 			--log-error[=file_name]
# 		Sys var: 					log_error
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						File name
#
# 		Set the default error log dest. to the named file. This affects log writers that base their own
# 		output dest on the default dest.
#
# 		If the option names no file, the default error log dest on Unix and Unix-like systems is a file named <host_name.err> in the data Dir.
# 		The default destination on Windows is the same, unless the --pid-file option is specified.
#
# 		In that case, the file name is the PID file base name with a suffix of .err in the data dir.
#
# 		If the option names a file, the default destination is that file (with an .err suffix added if the name has no suffix),
# 		located under the data dir unless an absolute path name is given to specify a different location.
#
# 		If error log output cannot be redirected to the error log file, an error occurs and startup fails.
#
# 		On Windows, --console takes precedence over --log-error if both are given. In this case, the default error log destination is
# 		the console rather than a file.
#
# --log-isam[=<file name>]
#
# 		cmd line format: 		--log-isam[=file_name]
# 		Type: 					File name
#
# 		Log all MyISAM changes to this file (used only when debugging MyISAM)
#
# --log-output=<value>, ...
#
# 		cmd line format: 		--log-output=name
# 		Sys var: 				log_output
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Set
# 		Defaults: 				FILE
# 		Valid: 					TABLE, FILE, NONE
#
# 		This option determines the destination for general query log and slow query log output.
# 		The option value can be given as one or more of the words TABLE, FILE or NONE.
#
# 		TABLE select logging to the general log and slow_log tables in the mysql database as a destination.
# 		FILE selects logging to log files as a destination.
# 		NONE disables logging.
#
# 		If NONE is present in the option value, it takes precedence over any other words that are present.
# 		TABLE and FILE can both be given to select to both log output destinations.
#
# 		This option selects log output destinations, but does not enable log output.
# 		To do that, use the --general_log and --slow_query_log options.
#
# 		For FILE logging, the --general_log_file and -slow_query_log_file options determine the log file location.
#
# --log-queries-not-using-indexes
# 
# 		cmd line format: 		--log-queries-not-using-indexes
# 		System variable: 		log_queries_not_using_indexes
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		If you are using this option with the slow query log enabled, queries that are expected to retrieve all rows are logged.
#
# 		This option does not necessarily mean that no index is used. For example - a query that uses a full index scan uses an index
# 		but would be logged because the index would not limit the number of rows.
#
# --log-raw 
#
# 		cmd line format: 		--log-raw[=<value>]
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Passwords in certain statements written to the general query log, slow query log and binary log are rewritten by the server
# 		not to occur literally in plain text.
#
# 		Password rewriting can be suppressed for the general query log by starting the server with the --log-raw option.
# 		This option may be useful for diagnostic purposes, to see the exact text of statements as received by the server,
# 		but for security reasons is not recommended for production use.
#
# 		If a query rewrite plugin is installed, the --log-raw option affects statement logging as follows:
#
# 			Without --log-raw, the server logs the statement returned by the query rewrite plugin. This may differ from the statement as received.
#
# 			With --log-raw, the server logs the original statement as received.
#
# --log-short-format
#
# 		cmd line format: 		--log-short-format
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Log less information to the slow query log, if it has been activated.
#
# --log-tc=<file name>
#
# 		cmd line format: 		--log-tc=file_name
# 		Type: 					File name
# 		Default: 				tc.log
#
# 		The name of the memory-mapped transaction coordinator log file (for XA transactions that affect multiple storage engines
# 		when the binary log is disabled).
#
# 		The default name is tc.log. The file is created under the data dir if not given as a full path name. Unused.
#
# --log-tc-size=<size>
#
# 		cmd line format: 		--log-tc-size=#
# 		Type: 					integer
# 		Default: 				6 * page * size
# 		Minimum value: 		6 * page * size
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		The size in bytes of the memory-mapped transaction coordinator log. 
# 		Defaul and min values are 6 times the page size, and the value must be a multiple of the page size.
#
# --log-warnings[=<level>], -W [<level>]
#
# 		cmd line format: 		--log-warnings[=#]
# 		Deprecated: 			YES (removed in 8.0.3)
#     Sys var: 				log_warnings
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Int
# 		Default value: 		2
# 		Min val: 				0
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<a lot>
#
# 		DEPRECATED - Use log error verbosity sys var instead.
#
# --low-priority-updates
#
# 		cmd line format: 		--low-priority-updates
# 		Sys var: 				low_priority_updates
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Give table-modifying operations (INSERT, REPLACE, DELETE, UPDATE) lower prio than selects..
# 		This can also be done using { INSERT | REPLACE | DELETE | UPDATE } LOW PRIORITY ... to lower the prio of only one query,
# 		or by SET LOW_PRIORITY_UPDATES=1 to change the priority in one thread.
#
# 		This affects only storage engines that use only table-level locking (MyISAM, MEMORY, MERGE)
#
# --min-examined-row-limit=<number>
#
# 		cmd line format: 		--min-examined-row-limit=#
# 		Sys var: 				min_examined_row_limit
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min value: 				0
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		When this option is set - queries which examine fewer than <number> rows are not written to the slow query log. Default is 0.
#
# --memlock
#
# 		cmd line format: 		--memlock
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Lock the mysqld process in memory. This option might help if you have a problem where the OS is causing mysqld to swap to disk.
#
# 		--memlock works on systems that support the mlockall() system call; this includes Solaris, most Linux distributions that use a 2.4 or higher kernel,
# 		and perhaps other Unix systems.
#
# 		On Linux systems, you can tell whether or not mlockall() (and thus this option) is supported by checking to see whether or not it is defined
# 		in the system mman.h file, as follows:
#
# 		grep mlockall /usr/include/sys/mman.h
#
# 		If mlockall() is supported, you should see in the output of the previous command something as follows:
#
# 		extern int mlockall (int __flags) __THROW;
#
# 		NOTE: Do not use on a system that does not support mlockall(). Will crash, if you do.
#
# 		Might need to run as root, but can be circumvented with limits.conf changing as well.
#
# --myisam-block-size=<N>
#
# 		cmd line format: 		--myisam-block-size=#
# 		Type: 					integer
# 		Default: 				1024
# 		Min value: 				1024
# 		Max value: 				16384
#
# 		Block size used for MyISAM index pages.
#
# --myisam-recover-options[=<option>[, <option>] ...]]
# 	
# 		cmd line format: 		--myisam-recover-options[=<name>]
# 		Type: 					Enumeration
# 		Default: 				Off
# 		Valid values: 			OFF/DEFAULT/BACKUP/FORCE/QUICK
#
# 		Set the MyISAM storage engine recovery mode. The option value is any combination of the values of
# 		OFF, DEFAULT, BACKUP, FORCE or QUICK.
#
# 		If you specify multiple values, separate them by commas. Specifying the option with no argument is the same
# 		as specifying DEFAULT, and specifying with an explicit value of "" disables recovery (same as OFF).
#
# 		If recovery is enabled, each time mysqld opens a MyISAM table, it checks whether the table is marked as crashed
# 		or was not closed properly. (The last option works only if you are running with external locking disabled).
#
# 		If this is the case, mysqld runs a check on the table. If the table was corrupted, mysqld attempts to repair it.
#
# 		The following options pertain to how the repair works:
#
# 		OFF 		No recovery
# 		DEFAULT 	Recovery without backup, forcing or quick checking
# 		BACKUP 	If hte data file was changed during recovery, save a backup of the <tbl_name>.MYD file as <tbl_name-datetime>.BAK
# 		FORCE 	Run recovery even if we would lose more than one row from the .MYD file
# 		QUICK 	Do not check the rows in the table if there are not any delete blocks.
#
# 		Before the server automatically repairs a table, it writes a note about the repair to the error log.
#
# 		If you want to be able to recover from most problems without user intervention - you should use the options
# 		BACKUP, FORCE. This forces a repair of a table even if some rows would be deleted, but it keeps the old data file
# 		as a backup so that you can later examine what occured.
#
#
# --no-defaults
#
# 		Do not read any option files. If program startup fails due to reading unknown options from an option file, --no-defaults
# 		prevents crashing in relation to reading.
#
# --no-dd-upgrade
#
# 		cmd line format: 				--no-dd-upgrade
# 		Introduced: 					8.0.4
# 		Type: 							Boolean
# 		Default: 						FALSE
#
# 		Prevents the automatic upgrade of data dictionary tables when starting the MySQL server. This option would typically be used
# 		when starting the MySQL server following an in-place upgrade of the MySQL server to a new version, which may include changes to
# 		data dictionary table defs.
#
# 		When --no-dd-upgrade is specified, and the server finds that the data dictionary version of the server is different from the 
# 		version stored in the data dictionary, startup fails with an error stating that data dictionary upgrade is prohibited.
#
# 		During a normal startup, the data dictionary version of the server is compared to the version stored in the data dictionary
# 		to determine if data dictionary table defs should be upgraded.
#
# 		If an upgrade is necessary and supported, the server creates data dictionary tables with updated definitions, copies persisted
# 		metadata to the new tables, automatically replaces the old tables with new ones, and reinitializes the data dir.
#
# 		If an upgrade is not necessary, startup continues without updating data dir tables.
#
# --no-monitor
#
# 	   cmd line format: 				--no-monitor
# 		Introduced: 					8.0.12
# 		Platform based: 				Windows
# 		Type: 							Boolean
# 		Default: 						FALSE
#
# 		Suppresses the forking that is used to implement the RESTART statement.
# 		Forking enables one process to act as a monitor to the other, which acts as the server.
#
# 		For a server started with this option, RESTART simply exits and does not restart.
#
# 		Case of < 8.0.12 - can use --gdb for workaround.
#
# --old-alter-table
#
# 		cmd line format: 				--old-alter-table
# 		Sys Var: 						old_alter_table
# 		Scope: 							Global, Session
# 		Dynamic: 						Yes
# 		SET_VAR Hint: 					No
# 		Type: 							Boolean
# 		Default: 						OFF
#
# 		When this option is given, the server does not use the optimized method of processing an ALTER TABLE operation.
# 		It reverts to using a temp table, copying over the data - and then renames the temp table to the original - as per MySQL <= 5.0
#
# --old-style-user-limits
#
# 		cmd line format: 				--old-style-user-limits
# 		Type: 							Boolean
# 		Default: 						FALSE
#
# 		Enable old-style user limits. (Causes account resource limits to be counted seperately for each host from which a user connected rather than per acc row in the user table)
#
# --open-files-limit=<count>
#
# 		cmd line format: 				--open-files-limit=#
# 		Sys Var: 						open_files_limit
# 		Scope: 							Global
# 		Dynamic: 						No
# 		SET_VAR Hint: 					No
# 		Type: 							Int
# 		Default: 						5000, can be adjusted
# 		min: 								0
# 		max: 								OS dependant
#
# 		Changes the number of file descriptors available to mysqld. You should try increasing the value of this option if
# 		mysqld gives you the error "Too many open files".
#
# 		mysqld uses the option value to reserve desc with setrlimit().
# 		Internally, the maximum value for this option is the max unsigned integer value,
# 		but the actual max is OS dependant.
#
# 		If the requested number of file desc cannot be allocated, mysqld writes a warning to the error log.
#
# 		mysqld may attempt to allocate more than the requested number of desc (if they are available) using the values of max_connections
# 		and table_open_cache to estimate whether more descriptors will be needed.
#
# 		On Unix, the value cannot be set greater than ulimit -n
#
# --performance-schema-xxx
# 
# 		Configure a Performance Schema Option.
#
# --pid-file=<file name>
#
# 		cmd line format: 	--pid-file=<file_name>
# 		Sys Var: 			pid_file
# 		Scope: 				Global
# 		Dynamic: 			No
# 		SET_VAR Hint: 		No
# 		Type: 				File name
#
# 		Path name of the process ID file. The server creates the file in teh data dir unless an absolute path name is given to specify
# 		a different dir.
#
# 		If specified - must specify a value.
#
# 		If not specified, defaults to <host_name>.pid - where host name is name of the host machine.
#
# 		The process ID file is used by other programs such as mysqld_safe to determine the servers process ID.
# 		On Windows, this variable also affects the default error log file name.
#
# --plugin-xxx
#
# 		Specifies an option that pertains to a server plugin. 
#
# 		For example, many storage engines can be built as plugins, and for such engines, options for them
# 		can be specified with a --plugin prefix.
#
# 		Thus, the --innodb_file_per_table option for InnoDB can be specified as --plugin-innodb_file_per_table
#
# 		For boolean options, that can be enabled or disabled, the --skip prefix and other alternatives are supported.
#
# 		For example - --skip-plugin-innodb_file_per_table disables innodb_file_per_table.
#
# 		The rationale for the --plugin prefix is that it enables plugin options to be specified unambiguously if there is a 
# 		name conflict with a built-in server option.
#
# 		For example, if named --sql-mode - it would conflict with built in systems. To circumvent, specify with --plugin first.
#
# --plugin-load=<plugin list>
#
# 		cmd line format: 			--plugin-load=<plugin_list>
# 		Type: 						String
#
# 		This option tells the server to load the named plugins at startup.
#
# 		If multiple --plugin-load options are given, only last one is used. Additional may be loaded using --plugin-load-add.
#
# 		The option value is a semicolon listed of <name>=<plugin_library> and <plugin_library> values.
#
# 		Each <name> is the name of a plugin to load - and <plugin_library> is the name of the library file that contains 
# 		the plugin code.
#
# 		If a plugin library is named without any preceding plugin name, the server loads all plugins in the library.
# 		The server looks for plugin lib files in the dir named by the <plugin dir> sys var.
#
# 		For example - if plugins named myplug1 and myplug2 have lib files - myplug1.so and myplug2.so, use this to perform an early plugin load:
#
# 		mysqld --plugin-load="myplug1=myplug1.so;myplug2=myplug2.so"
#
# 		This differs from INSTALL PLUGIN in that it's localized to one invocation of mysqld - Which adds one entry to the mysql.plugins table to cause
# 		the plugin to be loaded for every normal server startup.
#
# 		Under normal startup, the server determines which plugins to load by reading the mysql.plguins system table.
#
# 		If the server is started with the --skip-grant-tables option - it does not consult the mysql.plugins table and does not load plugins
# 		listed there.
#
# 		--plugin-load allows for plugins to be loaded even when --skip-grant-tables is given.
# 		--plugin-load also enables plugins to be loaded at startup that cannot be loaded at runtime.
#
# --plugin-load-add=<plugin list>
#
# 		cmd line format: 			--plugin-load-add=plugin_list
# 		Type: 						String
#
# 		This option complements the --plugin-load option. 
# 		--plugin-load-add adds a plugin or plugins to the set of plugins to be loaded at startup.
#
# 		The argument format is the same as for --plugin-load. --plugin-load-add can be used to avoid specifying a large
# 		set of plugins as a single long unwieldy --plugin-load argument.
#
# 		--plugin-load-add can be used instead of --plugin-load, but any ones that precedes --plugin-load, resets the set to load.
#
# 		i.e: 	--plugin-load=x --plugin-load-add=y   		--> 		--plugin-load="x;y"
#
# 				--plugin-load-add=y 	--plugin-load=x 		--> 		--plugin-load=x
#
# --port=<port_num>, -P <port_num>
#
# 		cmd line format: 		--port=#
# 		Sys var: 				port
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				3306
# 		Min value: 				0
# 		Max value: 				65535
#
# 		Port number to use for listening on to TCP/IP connections. On Unix/akin, >= 1024 if not started by root
#
# --port-open-timeout=<num>
#
# 		cmd line format: 		--port-open-timeout=#
# 		Type: 					int
# 		Default: 				0
#
# 		On some systems, when the server is stopped, the TCP/IP port might not become available immediately.
# 		If the server is restarted quickly afterwards, its attempt to reopen the port can fail.
#
# 		This indicates how many seconds the server should wait for the TCP/IP port to become free if it cannot be opened.
# 		Defaults to not wait.
#
# --print-defaults
#
# 		Print the program name and all options that it gets from option files.
# 		PWs are masked. Must be first - except in relaiton to --defaults-file or --defaults-extra-file.
#
# --remove [<service_name>]
#
# 		cmd line format: 		--remove [service_name]
# 		platform: 				Windows
#
# 		Removes a MySQL Windows service. Default service name is MySQL if no <service_name> value is given.
#
# --safe-user-create
#
# 		cmd line format: 		--safe-user-create
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		If this option is enabled, a user cannot create new MySQL users by using the GRANT statement unless the user has the INSERT privs
# 		for the mysql.user table or any column in the table.
#
# 		If you want a user to have the ability to create new users that have those privs that the user has the right to grant,
# 		grant the user the following privs:
#
# 		GRANT INSERT(user) 	ON mysql.user 	TO 'user_name'@'host_name';
#
# 		Ensures that the user cannot change any priv columns directly - but has to use the GRANT statement to give privs to other users.
#
# --secure-auth
#
# 		cmd line format: 		--secure-auth
# 		DEPRECATED: 			8.0.3
# 		Sys var: 				secure_auth
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					BOOLEAN
# 		Default: 				ON
# 		VALID: 					ON
#
# --secure-file-priv=<dir name>
#
# 		cmd line format: 		--secure-file-priv=dir_name
# 		Sys var: 				secure_file_priv
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				platform specific
# 		Valid: 					empty string, dirname, NULL
#
# 		Sets the secure file priv sys var - which is used to limit the effect of data import and export operations,
# 		such as those performed by the LOAD DATA and SELECT ... INTO OUTFILE statements and the LOAD FILE() function.
#
# --shared-memory
#
# 		cmd line format: 		--shared-memory[={0,1}]
# 		Sys var: 				shared_memory
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Platform: 				Windows
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Enables shared-memory connections by local clients. Can only be done on Windows.
#
# --shared-memory-base-name=<name>
#
# 		cmd line format: 		--shared-memory-base-name=name
# 		System var: 			shared_memory_base_name
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Platform: 				Windows
# 		Type: 					String
# 		Default: 				MYSQL
#
# 		Name of the shared memory to use for shared-memory connections. Case sensitive.
#
# --skip-concurrent-insert
#
# 		Turns off the ability to select and insert at the same time on MyISAM tables. 
#
# --skip-event-scheduler
#
# 		cmd line format: 		--skip-event-scheduler
# 									--disable-event-scheduler
#
# 		Turns the Event Scheduler OFF. Not the same as disabling the event scheduler - that would require --event-scheduler=DISABLED;
#
# --skip-grant-tables
#
# 		cmd line format: 		--skip-grant-tables
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Causes the server to start without using the privilege system at all, which gives
# 		anyone with access to the server unrestricted access to all DBs.
#
# 		Can cause a running server to start using the grant tables again by executing mysqladmin flush-privileges
# 		or mysqladmin reload cmd from a sys shell or by issuing a MySQL FLUSH PRIVILEGES statement after connecting to the server.
#
# 		If the server is started with the --skip-grant-tables option to disable authentication checks, the server enables
# 		--skip-networking automatically to prevent remote connections.
#
# 		Also causes the server to suppress during its startup sequence the loading of user-defined functions (UDFs),
# 		scheduled events and plugins that were installed with the INSTALL PLUGIN statement.
#
# 		To cause plugins to be loaded anyway, use the --plugin-load option: --skip-grant-tables also causes the 
# 		disabled_storage_engines sys var to have no effect.
#
# 		Does not cause loading of server components to be suppressed during server startup.
#
# 		FLUSH PRIVILEGES might be executed implicitly by other actions performed after startup.
# 		For example, mysql_upgrade flushes the priv during the upgrade procedure.
#
# --skip-host-cache
#
# 		cmd line format: 		--skip-host-cache
#
# 		Disable use of the internal host cache for faster name-to-IP resolution.
# 		In this case, the server performs a DNS lookup every time a client connects.
#
# 		Use of --skip-host-cache is similar to setting the host_cache_size sys var to 0,
# 		but host_cache_size is more flexible - due to ability of integration of resizing, enabling or disabling,
# 		host cache at runtime, not just at server startup.
#
# 		If you start the server with --skip-host-cache - that does not prevent changes to the value of host_cache_size,
# 		but such changes have no effect and the cache is not re-enabled even if host_cache_size is set larger than 0.
#
# --skip-innodb
#
# 		Disable the InnoDB storage engine. In this case, because the default storage engine is InnoDB, the server will not
# 		start unless you also use --default-storage-engine and --default-tmp-storage-engine to set the default to some other
# 		engine for both permanent and TEMPORARY tables.
#
# 		The InnoDB storage engine cannot be disabled, and the --skip-innodb option is deprecated and has no effect.
# 		Results in a warning.
#
# --skip-name-resolve
#
# 		cmd line format: 		--skip-name-resolve
# 		Sys Var: 				skip_name_resolve
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Do not resolve host names when checking client connections. Use only IP addresses.
# 		If used - all Host column values in the grant table must be IP addresses.
#
# 		Depending on the network configuration of your system and the Host values for your accounts,
# 		clients may need to connect using an explicit --host option - such as --host=127.0.0.1 or --host=::1
#
# 		Example: If on, 127.0.0.1 does not resolve to localhost. Must be designated with:
#
# 		CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'root-password';
# 		CREATE USER 'root'@'::1' IDENTIFIED BY 'root-password';
#
# --skip-networking
#
# 		cmd line format: 		--skip-networking
# 		Sys Var: 				skip_networking
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
#
# 		Do not listen for TCP/IP connections at all. All interactions with mysqld must be done through named pipes or shared memory or Unix sockets.
# 		Recommended for systems with only local clients permitted.
#
# 		If the server is started with the --skip-grant-tables option to disable authentication checks, the server enables --skip-networking to prevent remote connections.
#
# --ssl*
#
# 		Specify whether to permit clients to connect using SSL and indicate where to find SSL keys/Certs.
#
# --standalone
#
# 		cmd line format: 		--standalone
# 		Platform: 				Windows
#
# 		Instructs MySQL server to not run as a service.
#
# --super-large-pages
#
# 		cmd line format: 		--super-large-pages
# 		Platform: 				Solaris
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Standard use of large pages in MySQL attempts to use the largest size supported, up to 4MB.
# 		Under Solaris, super large pages is up to 256MB of pages.
#
# 		Can be turned on/off with: --super-large-pages or --skip-super-large-pages option.
#
# --symbolic-links, --skip-symbolic-links
#
# 		cmd line format: 		--symbolic-links
# 		Deprecated: 			8.0.2
# 		Type: 					Boolean
# 		Default (8.0.2 >=) 	OFF
# 		Default (8.0.1 <=) 	ON
#
# 		Enable or disable symbolic link support. On Unix, enabling symbolic links means that you can link a MyISAM index file or
# 		data file to another dir with the INDEX DIR or DATA DIR option of the CREATE TABLE statement.
#
# 		If deleting or renaming the table - the files that its symbolic links point to also are deleted or renamed.
#
# 		Symbolic link support, --symbolic-links - is deprecated. Disabled by default. have_symlink sys var is also deprecated
# 		Does not pertain to Windows.
#
# --skip-show-database
#
# 		cmd line format: 		--skip-show-database
# 		Sys Var: 				skip_show_database
# 		Scope: 					Global
#		Dynamic: 				No
# 		SET_VAR Hint: 			No
#
# 		This option sets the skip_show_database sys var that controls who is permitted to use the SHOW DATABASE.
#
# --skip-stack-trace
#
# 		cmd line format: 		--skip-stack-trace
#
# 		Do not write stack traces. Useful when running mysqld under a debugger.
# 		On some systems, you also must use this option to get a core file.
#
# --slow-query-log[={0|1}]
#
# 		cmd line format: 		--slow-query-log
# 		Sys Var: 				slow_query_log
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Specify the initial slow query log state. With no argument or an argument of 1, the --slow-query-log
# 		option enables the log. If omitted or given 0 - disables the log.
#
# --slow-start-timeout=<timeout>
#
# 		cmd line format: 		--slow-start-timeout=#
# 		Type: 					Integer
# 		Default: 				15000
#
# 		Controls the Windows service control manager's service start timeout.
# 		Max number of milliseconds that the service control manager waits before trying to kill the Windows service during startup.
# 		Default value is 15000 (15 seconds).
#
# 		0 is no timeout. 
#
# --socket=<path>
#
# 		cmd line format: 		--socket={file_name|pipe_name}
# 		Sys Var: 				socket
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (Other)  		/tmp/mysql.sock
# 		Default (Windows) 	MySQL
#
# 		On Unix, specifies the Unix socket file to use when listening for local connections.
# 		The default value is /tmp/mysql.sock.
#
# 		If this option is given, the server creates the file in the data dir unless an absolute path name is given
# 		to specify a different dir.
#
# 		On Windows, the option specifies the pipe name to use when listening for local connections that used a named pipe.
# 		Default is MySQL (not case sensitive)
#
# --sql-mode=<value>[,<value>[,<value> ...]]
#
# 		Cmd line format: 		--sql-mode=name
# 		Sys Var: 				sql_mode
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Set
# 		Default (>= 8.0.11) 	ONLY_FULL_GROUP_BY STRICT_TRANS_TABLES NO_ZERO_IN_DATE NO_ZERO_DATE
# 									ERROR_FOR_DIVISION_BY_ZERO NO_ENGINE_SUBSTITUTION
#
# 		Default (<= 8.0.4) 	ONLY_FULL_GROUP_BY STRICT_TRANS_TABLES NO_ZERO_IN_DATE
# 									NO_ZERO_DATE ERROR_FOR_DIVISION_BY_ZERO NO_AUTO_CREATE_USER
# 									NO_ENGINE_SUBSTITUTION
# 		
# 		Valid (>= 8.0.11) 	ALLOW_INVALID_DATES
# 									ANSI_QUOTES
# 									ERROR_FOR_DIVISION_BY_ZERO
# 									HIGH_NOT_PRECEDENCE
# 									IGNORE_SPACE
# 									NO_AUTO_VALUE_ON_ZERO
#
# 									NO_BACKSLASH_ESCAPES
# 									NO_DIR_IN_CREATE
# 									NO_ENGINE_SUBSTITUTION
# 									NO_UNSIGNED_SUBTRACTION
# 									NO_ZERO_DATE
#
# 									NO_ZERO_IN_DATE
# 									ONLY_FULL_GROUP_BY
# 									PAD_CHAR_TO_FULL_LENGTH
# 									PIPES_AS_CONCAT
# 									REAL_AS_FLOAT
#
# 									STRICT_ALL_TABLES
# 									STRICT_TRANS_TABLES
# 									TIME_TRUNCATE_FRACTIONAL
#
# 		Valid Values (>= 8.0.1, <= 8.0.4)
# 	
# 									ALLOW_INVALID_DATES
# 									ANSI_QUOTES
# 									ERROR_FOR_DIVISION_BY_ZERO
# 									HIGH_NOT_PRECEDENCE
# 									IGNORE_SPACE
# 									NO_AUTO_CREATE_USER
# 									NO_AUTO_VALUE_ON_ZERO
# 									NO_BACKSLASH_ESCAPES
# 									NO_DIR_IN_CREATE
# 									NO_ENGINE_SUBSTITUTION
# 									NO_FIELD_OPTIONS
# 									NO_KEY_OPTIONS
#
# 									NO_TABLE_OPTIONS
# 									NO_UNSIGNED_SUBTRACTION
# 									NO_ZERO_DATE
# 									NO_ZERO_IN_DATE
# 									ONLY_FULL_GROUP_BY
# 									
# 									PAD_CHAR_TO_FULL_LENGTH
# 									PIPES_AS_CONCAT
# 									REAL_AS_FLOAT
# 									STRICT_ALL_TABLES
# 									STRICT_TRANS_TABLES
# 									TIME_TRUNCATE_FRACTIONAL
#
# 		Valid (8.0) 			ALLOW_INVALID_DATES
# 									ANSI_QUOTES
# 									ERROR_FOR_DIVISION_BY_ZERO
# 									HIGH_NOT_PRECEDENCE
# 									IGNORE_SPACE
# 									NO_AUTO_CREATE_USER
# 									NO_AUTO_VALUE_ON_ZERO
# 									NO_BACKSLASH_ESCAPES
#
# 									NO_DIR_IN_CREATE
# 									NO_ENGINE_SUBSTITUTION
# 									NO_FIELD_OPTIONS
# 									NO_KEY_OPTIONS
# 									NO_TABLE_OPTIONS
#
# 									NO_UNSIGNED_SUBTRACTION
# 									NO_ZERO_DATE
# 									NO_ZERO_IN_DATE
# 									ONLY_FULL_GROUP_BY
# 									PAD_CHAR_TO_FULL_LENGTH
# 									
# 									PIPES_AS_CONCAT
# 									REAL_AS_FLOAT
# 									STRICT_ALL_TABLES
# 									STRICT_TRANS_TABLES
#
# The above refers to setting of the SQL mode.
#
# The startup can configure these during install process, or option files that the server reads at startup.
#
# --sysdate-is-now
#
# 	cmd line format: 			--sysdate-is-now
# 	Type: 						Boolean
# 	Default: 					FALSE
#
# 	SYSDATE() by default returns the time at which it executes, not the time at which the statement in which
# 	it occurs begins executing.
#
# 	This differs from the be´havior of NOW().
#
# 	Causes the SYSDATE() to be an alias for NOW().
#
# --tc-heuristic-recover={COMMIT|ROLLBACK}
#
# 	cmd line format: 			--tc-heuristic-recover=name
# 	Type: 						Enumeration
# 	Default: 					COMMIT
# 	Valid: 						COMMIT, ROLLBACK
#
# 	Type of decision to use in the heuristic recovery process. 
# 	To use this option, two or more storage engines that support XA transactions must be installed.
#
# --temp-pool
#
# 	cmd line format: 			--temp-pool
# 	Deprecated: 				Yes (Removed in 8.0.1)
# 	Type: 						Boolean
# 	Default (other): 			FALSE
# 	Default (Linux): 			TRUE
# 
# 	Removed in 8.0.1
#
# --transaction-isolation=<level>
#
# 	cmd line format: 			--transaction-isolation=name
# 	Sys Var: 					transaction_isolation
# 	Scope: 						Global, Session
# 	Dynamic: 					Yes
# 	SET_VAR Hint: 				No
# 	Type: 						Enumeration
# 	Default: 					REPEATABLE-READ
# 	Valid: 						READ-UNCOMMITTED
# 									READ-COMMITTED
# 									REPEATABLE-READ
# 									SERIALIZABLE
#
# 	Sets the default transaction isolation level. The <level> value can be:
# 	READ-UNCOMMITTED, READ-COMMITTED, REPEATABLE-READ or SERIALIZABLE.
#
# 	The default transaction isolation level can also be set at runtime using the SET TRANSACTION
# 	statement or by setting the transaction_isolation SYS VAR.
#
# --transaction-read-only
#
# 	cmd line format: 			--transaction-read-only
# 	Sys Var: 					transaction_read_only
# 	Scope: 						Global, Session
# 	Dynamic: 					Yes
# 	SET_VAR Hint: 				No
# 	Type: 						Boolean
# 	Default: 					OFF
#
# 	Sets the default transaction access mode. By default, read-only mode is disabled, so the mode is read/write.
#
# 	To set the default transaction access mode at runtime, use the SET TRANSACTION statement or set the
# 	transaction read only SYS VAR.
#
# --tmpdir=<dir name>, -t <dir_name>
#
# 	cmd line format: 			--tmpdir=dir_name
# 	Sys Var: 					tmpdir
# 	Scope: 						Global
# 	Dynamic: 					No
# 	SET_VAR Hint: 				No
# 	Type: 						Dir name
#
# 	Path of the dir to use for creating temp files. Might be useful if your default /tmp dir resides on a platform that is too small to hold temp tables.
# 	Accepts several paths that are used in round-robin typing.
#
# 	Separation char: : on Unix, ; on Windows.
#
# 	If the MySQL server is acting as a replication slave - you should not set --tmpdir to point to a dir on a memory-based file system or to a dir
# 	that is cleared when the server host restarts.
#
# 	A replication slave needs some of its temp files to survive a machine restart so that it can replicate temp tables or LOAD DATA INFILE operations.
# 	If files in the temp file dir are lost when the server restarts, replication fails.
#
# --user={<user name>|<user id>}, -u {<user_name>|<user_id>}
#
# 	cmd line format: 			--user=name
# 	Type: 						String
#
# 	Run the mysqld server as the user having the name <user_name> or the numeric user ID <user_id>.
# 	"User" here is sys acc, not MySQL users in grant tables.
#
# 	Mandatory when starting mysqld as root. Server changes its ID during its startup sequence, causing it to run
# 	as that particular user rather than as root.
#
# 	To avoid a possible security hole where a user adds a --user=root option to my.cnf file,
# 	mysqld only runs with the first --user - attempting several causes a warning.
#
# 	/etc/my.cnf and $MYSQL_HOME/my.cnf run before CMD line. Thus, put another user than root in /etc/my.cnf (found before any other)
#
# --verbose, -v - Use this option with the --help option for detailed help.
#
# --version, -V - Display version info and exit.
#
# The following pertains to Server System Variables and more coverage about their inner workings.
#
# Sys vars can be set at server startup using options on the cmd line or in an option file.
#
# Most of them can be changed dynamically at runtime using the SET statement, which enables you to modify
# operation of the server without having to stop and restart it.
#
# We can also use Sys var values in expressions.
#
# At runtime, setting a global sys var value normally requires the SYSTEM VARIABLES ADMIN or SUPER privilege.
# Setting a session sys var normally reqs no privs - can be done by any user, there are exceptions though.
#
# based on current versioning (option files, compiled in defaults): mysqld --verbose --help
#
# Based on compiled in defaults, ignoring option files: mysqld --no-defaults --verbose --help
# 
# Current values run on server can also be seen with SHOW VARIABLES or the Performance Schema sys var tables.
#
# In terms of options, 1 and 0 act as logical booleans (TRUE and FALSE, respectively)
#
# Relative paths pertain to the data dir - such as /var/mysql/data
#
# activate_all_roles_on_login
#
# 		cmd line format: 		--activate-all-roles-on-login
# 		Introduced: 			8.0.2
# 		Sys Var: 				activate_all_roles_on_login
# 		Scope: 					Global
# 		Dynamic: 				yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Whether to enable automatic activation of all granted roles when users log in to the server:
#
# 			If activate_all_roles_on_login is enabled, the server activates all roles granted to each account at login time.
# 			This takes precedence over default roles specified with SET DEFAULT ROLE.
#
# 			If activate_all_roles_on_login is disabled, the server activates the default roles specified with SET DEFAULT ROLE, if any, at login time.
#
# 			Granted roles include those granted explicitly to the user and those named in the mandatory_roles SYS VAR.
#
# 			activate_all_roles_on_login applies only at login time, and at the beginning of execution for stored programs and views that execute
# 			in definer context.
#
# 			To change the active roles within a session, use SET_ROLE. 
#        To change the active roles for a stored program, the program body should execute SET ROLE.
#
# authentication_windows_log_level
#
# 		cmd line format: 		--authentication-windows-log-level
# 		Introduced: 			8.0.11
# 		Sys var: 				authentication_windows_log_level
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				2
# 		Min value: 				0
# 		Max value: 				4
#
# 		Available only if the authentication_windows Windows auth plugin is enabled and debugging code is enabled.
#
# 		Sets the log level for Windows auth Plugin:
#
# 		0 		No logging
# 		1 		Log only error messages
# 		2 		Log level 1 messages and warning messages
# 		3 		Log level 2 messages and information notes
# 		4 		log level 3 messages and debug messages
#
# authentication_windows_use_principal_name
# 		
# 		cmd line format: 		--authentication-windows-use-principal-name
# 		Introduced: 			8.0.11
# 		Sys Var: 				authentication_windows_use_principal_name
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		Is available only if the authentication_windows Windows auth plugin is enabled.
#
# 		A client that authenticates using the InitSecurityContext() function should provide a string identifying
# 		the service to which it connects.
#
# 		MySQL uses the principal name (UPN) of the account under which the server is running. 
# 		The UPN has the form <user_id@computer_name> and need not be registered anywhere to be used.
#
# 		The UPN is sent by the server at the beginning of authentication handshake.
#
# 		This variable controls whether the server sends the UPN in the initial challenge.
# 		By default, the variable is enabled.
#
# 		For security reasons, it can be disabled to avoid sending the server's account name to a client in clear text.
# 		If the variable is disabled, the server always sends a 0x00 byte in the first challenge, the client does not
# 		specify <targetName>, and as a result - NTLM authentication is used.
#
# 		If the server fails to obtain its UPN (which will happen primarily in environments that do not support Kerberos authentication),
# 		the UPN is not sent by the server and NTLM authentication is used.
#
# autocommit
#
# 		cmd line format: 	--autocommit[=#]
# 		Sys Var: 			autocommit
# 		Scope: 				Global, Session
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Boolean
# 		Default: 			ON
#
# 		The autocommit mode. If set to 1, all changes to a table take effect immediately. 
# 		If set to 0 - you must use COMMIT to accept a transaction or ROLLBACK to cancel it.
#
# 		If autocommit is 0 and you change it to 1, MySQL performs an automatic COMMIT of any open transaction.
# 		Another way to begin a transaction is to use a START TRANSACTION or BEGIN statement.
#
# 		By default, client connections begin with autocommit set to 1. To cause clients to begin with a default of 0,
# 		set the global autocommit value by starting the server with the --autocommit=0 option.
#
# 		Option file usage:
#
# 		[mysqld]
# 		autocommit=0
#
# automatic_sp_privileges
#
# 		Sys Var: 			automatic_sp_privileges
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Boolean
# 		Default: 			TRUE
#
# 		When set to 1 (Default), the server automatically grants the EXECUTE and ALTER ROUTINE privs to the
# 		creator of a stored routine - if the user cannot already execute and alter or drop the routine.
#
# 		(The ALTER ROUTINE priv is required to drop the routine). The server also automatically drops those 
# 		privs from the creator when the routine is dropped. If automatic_sp_privileges is 0, the server does
# 		not automatically add or drop these privs.
#
# 		The creator of a routine is the account used to execute the CREATE statement for it.
# 		This might not be the same as the account named as the DEFINER in the routine def.
#
# auto_generate_certs
#
# 		cmd line format: 		--auto-generate-certs[={OFF|ON}]
# 		System Var: 			auto_generate_certs
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		This variable is available if the server was compiled using OpenSSL. Controls whether 
# 		the server autogenerates SSL key and certificate files in the data dir, if they do not already exist.
#
# 		At startup, the server automatically generates server-side and client-side SSL cert and key files in the data dir
# 		if the auto_generate_certs SYS Var is enabled, no SSL options other than --ssl is on and the server-side SSL files are 
# 		missing from the data dir.
#
# 		These files enable secure client connections using SSL.
#
# 		The sha256_password_auto_generate_rsa_keys and caching_sha2_password_auto_generate_rsa_keys SYS vars are related,
# 		but control autogeneration of RSA key-pair files for secure PWs using RSA over unencrypted connections.
#
# avoid_temporal_upgrade
#
# 		cmd line format: 		--avoid-temporal-upgrade={OFF|ON}
# 		Deprecated: 			Yes
# 		Sys var. 				avoid_temporal_upgrade
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		This variable controls whether ALTER TABLE implicitly upgrades temporal columns found to be in pre-5.6.4 format
# 		(TIME, DATETIME and TIMESTAMP columns without support for fractional seconds precision)
#
# 		Upgrading such columns require a table rebuild, which prevents any use of fast alternations that might otherwise
# 		apply to the operation to be performed.
#
# 		This variable is disabled by default - Enabling it causes ALTER TABLE not to rebuild temporal columns and thereby be able to
# 		take advantage of fast alterations.
#
# 		DEPRECATED, will be removed.
#
# back log
#
# 		Sys var: 				back_log
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				-1 (autosizing)
# 		min: 						1
# 		max: 						65535
#
#		Number of oustanding connection requests MySQL can have.
# 		This comes into play when the main MySQL thread gets very many connection requests in a very short time.
# 		It takes a small gap of time for the main thread to then check the connection and start a new thread.
#
# 		The back_log indicates how many requests can be stacked during this short time before MySQL momentarily stops answering new requests.
#
# 		Only increase this if you expect a large number of connections in a short amount of time.
#
# 		Basically the size of the listen queue for incoming TCP/IP connections.
#
# 		OS has it's own limitations. Cannot be set higher than this limit.
#
# 		defaults to max connections, adjusts max permitted number of connections.
#
# 		the Unix call of listen() system call has more details.
#
# basedir
#
# 		cmd line format: 		--basedir=dir_name
# 		Sys Var: 				basedir
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name
# 		Default (8.0.2 >=) 	parent of mysqld install dir
# 		default (8.0.1 <=) 	configuration-dependant default
#
# 		Path of the MySQL install base dir
#
# big_tables
#
# 		Cmd line format: 		--big-tables
# 		Sys Var: 				big_tables
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		If set to 1 - all temp tables are stored on disk rather than in memory.
# 		This is a little slower, but the error "The table <tbl_name> is full" does not occur for SELECT operations that require
# 		a large temp table.
#
# 		Default value for a new connection is 0 (use in-memory temp tables).
# 		Normally, you should never need to set this Var.
#
# 		When in-memory internal temporary tables are managed by the TempTable storage engine 
# 		(the default), and max amount of memory that can be occupied by the TempTable storage engine is exceeded,
# 		the TempTable storage engine starts storing data to temp files on Disk.
#
# 		When in-memory temporary tables are managed by the MEMORY storage engine,
# 		in-memory tables are automatically converted to disk-based tables as required.
#
# bind_address
#
# 		cmd line format: 		--bind-address=addr
# 		Sys Var: 				bind_address
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Defaults: 				*
#
# 		Value of the --bind-address option
#
# block_encryption_mode
#
# 		cmd line format: 		--block-encryption-mode=#
# 		Sys Var: 				block_encryption_mode
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				aes-128-ecb
#
# 		This controls the block encryption mode for block-based algorithms such as AES.
# 		It affects encryption for AES_ENCRYPT() and AES_DECRYPT().
#
# 		block_encryption_mode takes a value in aes-<keylen>-<mode> format, where <keylen> is the key length
# 		in bits and <mode> is the encryption mode.
#
# 		The value is not case-sensitive. Permitted <keylen> values are 128, 192 and 256.
#
# 		Permitted encryption depend on whether MySQL was compiled using OpenSSL or wolfSSL:
#
# 			For OpenSSL, permitted <mode> values are: ECB, CBC, CFB1, CFB8, CFB128, OFB
#
# 			For wolfSSL, permitted <mode> values are: ECB, CBC
#
# 		For example - the following is 256 bits key length with AES encryption with the CBC mode:
#
# 			SET block_encryption_mode = 'aes-256-cbc';
#
# 		An error occurs for attempts to set block_encryption_mode to a value containing an unsupported key length
# 		or a mode that the SSL lib does not support.
#
# bulk_insert_buffer_size
#
# 		cmd line format: 		--bulk-insert-buffer-size=#
# 		Sys Var: 				bulk_insert_buffer_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				8388608
# 		Min value: 				0
# 		Max value (64-bit) 	a lot
# 		Max value (32-bit) 	less
#
# 		MyISAM uses a special tree-like cache to make bulk inserts faster for INSERT ... SELECT, INSERT ... VALUES (...),
# 		(...), ... and LOAD DATA INFILE when adding data to nonempty tables.
#
# 		This variable limits the size of the cache tree in bytes per thread. 
# 		Setting it to 0 disables this optimization. Defaults to 8MB.
#
# 		(MySQL 8.0.14 >=) : Setting the session value of this SYS var is a restricted operation.
# 								  The session user must have privs sufficient to set restricted session vars.
#
# caching_sha2_password_auto_generate_rsa_keys
#
# 		cmd line format: 		--caching-sha2-password-auto-generate-rsa-keys[={OFF|ON}]
# 		Introduced: 			8.0.4
# 		Sys Var: 				caching_sha2_password_auto_generate_rsa_keys
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		Available if the server was compiled using OpenSSL. The server uses it to determine whether to autogenerate
# 		RSA private/public key-pair files in the data dir if they do not already exist.
#
# 		At startup, the server automatically generates RSA private/public key-pair files in the data dir if all of the following is true:
#
# 			The sha256_password_auto_generate_rsa_keys or caching_sha2_password_auto_generate_rsa_keys sys var is Enabled
#
# 			No RSA options are specified
#
# 			No RSA files are in the data dir.
#
# 			The key-pair files enable secure password exchange using RSA over unencrypted connections for accounts authenticated
# 			by the sha256_password or caching_sha2_password plugin
#
# 			auto_generate_certs SYS var is related but controls autogeneration of SSL cert and key files needed for Secure connections using SSL.
#
# caching_sha2_password_private_key_path
#
# 		cmd line format: 			--caching-sha2-password-private-key-path=file_name
# 		introduced: 				8.0.3
# 		Sys Var: 					caching_sha2_password_private_key_path
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						File Name
# 		Default: 					private_key.pem
#
# 		This variable specifies the path name of the RSA private key file for the caching_sha2_password auth plugin.
# 		If relative, it's relative to server data dir. File must be in PEM format.
#
# 		Because a private key is stored within - access should be restricted to MySQL.
#
# caching_sha2_password_public_key_path
#
# 		Cmd line format: 			--caching-sha2-password-public-key-path=file_name
# 		Introduced: 				8.0.3
# 		Sys Var: 					caching_sha2_password_public_key_path
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						File name
# 		Default: 					public_key.pem
#
# 		Same as above, except for a public key.
#
# character_set_client
#
# 		Sys var: 					character_set_client
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						String
# 		Default (>= 8.0.1) 		utf8mb4
# 		Default (8.0.0) 			utf8
#
# 		Char set for statements that arrive from the client.
#
# 		The session value of this var is set using the char set requested by the client when the client
# 		connects to the server.
#
# 		Many clients support a --default-character-set option to enable this char set to be specified explicitly.
#
# 		The global value of the variable is used to set the session value in cases when the client-requested value is unknown
# 		or not available - or the server is configured to ignore client requests
#
# 		examples:
#
# 		The client requests a char set not known to the server. For example, a japanese-enabled client requests sjis when connecting
# 		to a server not configured with sjis support.
#
# 		The client is from a version of MySQL older than MySQL 4.1 - i.e, does not require a char set
#
# 		mysqld started with the --skip-character-set-client-handshake option - ignores client char set configs.
#
# 		Some char sets are invalid for client char sets. Trying to use them as the character_set_client value produces an error.
#
# character_set_connection
#
# 		Sys var: 				character_set_connection
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4
# 		Default (8.0.0) 		utf8
# 
# 		The char set used for literals specified without a char set introducer and for number-to-string conversion.
#
# character_set_database
#
# 		Sys var: 				character_set_database
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4
# 		Default (8.0.0) 		latin1
# 		Footnote: 				Dynamic - but server should be designating this value by itself.
# 		
# 		The char set used by the default DB. The server sets this var whenever the default DB changes.
# 		If there is no default DB, the var has the same value as character_set_server.
#
# 		(8.0.14 >=) setting the session value of this system variable is a restricted operation.
# 		The session user must have privileges sufficient to set restricted session variables.
#
# 		The global character_set_database and collation_database SYS vars are deprecated, will be removed.
#
# 		Since they are deprecated - attempting to assign them causes a warning.
#
# 		The session vars is read only in the future.
#
# 		Can still access for reading purposes in relation to DB charset and collation.
#
# character_set_filesystem
#
# 		cmd line format: 			--character-set-filesystem=name
# 		Sys var: 					character_set_filesystem
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						String
# 		Default: 					binary
#
# 		The file system char set. Used to interpret string literals that refers to file names, such as 
# 		in the LOAD_DATA_INFILE and SELECT_..._INTO_OUTFILE statements and the LOAD_FILE() function.
#
# 		Such file names are converted from character_set_client to character_set_filesystem before the file opening
# 		attempt occurs.
#
# 		Default is binary, which means no conversion occurs. 
# 		For systems on which multibyte file names are permitted, a different value may be used.
#
# 		For example, if using UTF-8 in the system - we can set this to 'utf8mb4'
#
# 		(MySQL 8.0.14)	- This is a restricted operation - session user must have privs sufficient to set restricted session vars.
#
# character_set_results
#
# 		Sys Var: 				character_set_results
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4
# 		Default (8.0.0) 		utf8
#
# 		The char set used for returning query results to the client.
# 		This includes result data such as column values, result metadata such as column names and error messages.
#
# character_set_server
#
# 		cmd line format: 		--character-set-server
# 		Sys Var: 				character_set_server
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4
# 		Default (8.0.0) 		latin1
#
# 		The servers default char set
#
# character_set_system
#
# 		Sys var: 				character_set_system
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				utf8
#
# 		The char set used by the server for storing identifiers. Value is always utf8.
#
# character_sets_dir
#
# 		cmd line format: 		--character-sets-dir=dir_name
# 		Sys Var: 				character_sets_dir
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name
#
# 		The dir where char sets are installed.
#
# check_proxy_users
#
# 		cmd line format: 		--check-proxy-users=[={OFF|ON}]
# 		Sys var: 				check_proxy_users
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Some authentication plugins implement proxy user mapping for themselves (for example, the PAM and Windows auth plugins)
# 		Other authentication plugins do not support proxy users by default.
#
# 		Of these, some can request that the MySQL server itself map proxy users according to granted proxy privs:
#
# 		mysql_native_password_sha256_password
#
# 		If the check_proxy_users SYS Var is enabled, the server performs proxy user mapping for any authentication plugins that make
# 		such a request.
#
# 		However, it may also be necessary to enable plugin-specific system variables to take advantage of server proxy user mapping support:
#
# 			For the mysql_native_password plugin, enable mysql_native_password_proxy_users
#
# 			For the sha256_password plugin, enable sha256_password_proxy_users
#
# collation_connection
#
# 		Sys var: 				collation_connection
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
#
# 		The collation of the connection char set. 
#
# 		collation_connection is important for comparisons of literal strings.
#
# 		For comparisons of strings with column values, collation_connection does not matter because columns
# 		have their own collation, which has a higher collation precedence.
#
# collation_database
#
# 		Sys var: 				collation_database
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4_0900_ai_ci
# 		Default (8.0.0) 		latin1_swedish_ci
# 		Footnote: 				Dynamic - leave interaction to server.
#
# 		Collation used by the default DB. The server sets this var whenever the default DB changes.
#
# 		If there is no default DB, the var has the same value as collation server.
#
# 		(MySQL 8.0.14 >=) Setting the session value of this system variable is a restricted operation.
# 								The session user must have privs sufficient to set restricted session vars.
#
# 		The global character_set_database and collation_database SYS var is deprecated and assignment causes a warning.
# 		
# 		Read only in the future.
#
# collation_server
#
# 		cmd line format: 		--collation-server
# 		Sys Var: 				collation_server
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (>= 8.0.1) 	utf8mb4_0900_ai_ci
# 		Default (8.0.0) 		latin1_swedish_ci
#
# 		Servers default collation
#
# completion_type
#
# 		cmd line format: 		--completion-type=#
# 		Sys Var: 				completion_type
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				NO_CHAIN
# 		Valid values: 			NO_CHAIN, CHAIN, RELEASE, 0, 1, 2
#
# 		The transaction completion type. This variable can take the values shown in the following:
#
# 		Name 						DESC
# 	
# 		NO_CHAIN/0  			COMMIT and ROLLBACK are unaffected. Default value.
#
# 		CHAIN/1 					COMMIT and ROLLBACK are equivalent to COMMIT AND CHAIN and ROLLBACK AND CHAIN respectively.
# 									(A new transaction starts immediately with the same isolation level as the just-terminated transaction)
#
# 		RELEASE/2 				COMMIT and ROLLBACK are equivalent to COMMIT RELEASE and ROLLBACK RELEASE, respectively.
# 									(The server disconnects after terminating the transaction)
#
# 		completion_type affects transactions that begin with START_TRANSACTION or BEGIN and end with COMMIT or ROLLBACK.
#
# 		Does not apply to implicit commits. Does not apply to XA_COMMIT, XA_ROLLBACK or autocommit=1.
#
# concurrent_insert
#
# 		cmd line format: 		--concurrent-insert[=#]
# 		Sys Var: 				concurrent_insert
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				AUTO
# 		VALID: 					NEVER, AUTO, ALWAYS, 0, 1, 2
#
# 		If AUTO - MySQL permits INSERT and SELECT statements to run concurrently for MyISAM tables that have no free blocks in
# 		the middle of the data file.
#
# 		If you start mysqld with --skip-new, this variable is set to NEVER.
#
# 		Values:
#
# 		Name 				DESC
# 		
# 		NEVER/0 			Disables concurrent inserts
#
# 		AUTO/1 			Enables concurrent insert for MyISAM tables that do not have holes.
#
# 		ALWAYS/2 		Enables concurrent inserts for all MyISAM tables - even those that have holes.
# 							For a table with a hole - new rows are inserted at the end of the table if it is in
# 							use by another thread. 
#
# 							Otherwise - MySQL aquires a normal write lock and inserts the row into the hole.
#
# connect_timeout
#
# 		cmd line format: 		--connect-timeout=#
# 		Sys var: 				connect_timeout
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				10
# 		Min: 						2
# 		Max: 						31536000
#
# 		Number of seconds mysqld waits for a connection packet before responding with Bad handshake.
# 		Defaults 10 seconds.
#
# 		Increasing the connect_timeout value might help if clients frequently encounters errors of the form:
# 		
# 		Lost connection to MySQL server at 'XXX', system error: <errno>
#
# core_file
#
# 		Sys var: 				core_file
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Whether to write a core file if the server crashes. Is set by the --core-file option.
#
# 		Under some circumstances, disabling innodb_buffer_pool_in_core_file can cause core_file to be disabled.
#
# cte_max_recursion_depth
#
# 		cmd line format: 		--cte-max-recursion-depth=#
# 		Introduced: 			8.0.3
# 		Sys Var: 				cte_max_recursion_depth
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1000
# 		Min: 						0
# 		Max: 						<a lot>
#
# 		The common table expression (CTE) maxium recursion depth.
# 		The server terminates execution of any CTE that recurses more levels than the values of this var.
#
# datadir
#
# 		cmd line format: 		--datadir=dir_name
# 		Sys Var: 				datadir
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name
#
# 		The path to the MySQL server data dir. Relative paths are resolved with respect to the CWD.
# 		If the server will be started automatically (Where you can't assume the CWD) - specify datadir as absolute
#
# debug
# 		
# 		cmd line format: 		--debug[=debug_options]
# 		Sys Var: 				debug
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default (Windows) 	d:t:i:O, \mysqld.trace
# 		Default (Unix) 		d:t:i:o, /tmp/mysqld.trace
#
# 		Indicates the current debugging settings. 
# 		Available only for servers built with debugging support.
#
# 		Initial value comes from the value of instances of the --debug option given at server startup.
# 		Global and Session values may be set at runtime.
#
# 		Setting the session value of this Sys var is a restricted operation.
# 		Must have permission to set restricted session vars.
#
# 		Example of modifying debugging status:
#
# 		SET debug = 'T'; #base declaration
# 		SELECT @@debug; #Select the attribute
#
# 		@@debug
# 		
# 		T
#
# 		SET debug = '+P'; #Add P as part of operations
# 		SELECT @@debug;
# 
# 		@@debug
#
# 		P:T
#
# 		SET debug = '-P'; #Remove P as part of operations
# 		SELECT @@debug;
#
# 		T
#
# debug_sync
#
# 		Sys var: 		debug_sync
# 		Scope: 			Session
# 		Dynamic: 		Yes
#	 	SET_VAR Hint: 	No
# 		Type: 			String
#
# 		The variable is the user interface to the Debug Sync facility.
# 		Use of Debug Sync requires that MySQL be configured with the -DENABLE_DEBUG_SYNC=1 CMake option.
#
# 		If Debug Sync is not compiled in, this sys var is not available.
#
# 		The global var value is read only and indicates whether the facility is enabled.
# 		By default, Debug Sync is disabled and the value of debug_sync is OFF.
#
# 		If the server is started with --debug-sync-timeout=<N>, where <N> is a timeout value greater than 0,
# 		Debug Sync is enabled and the value of debug_sync is ON - <current signal> (the signal name)
#
# 		<N> becomes the default timeout for individual synchronization points.
#
# 		The session value can be read by any user and will have the same value as the global variable.
# 		The session value can be set to control synchronization points.
#
# 		Setting the session value of this Sys Var is a restricted operation.
#
# 		Covered more in terms of MySQL internals: Test Synchronization
#
# default_authentication_plugin
#
# 		cmd line format: 				--default-authentication_plugin=plugin_name
# 		Sys Var: 						default_authentication_plugin
# 		Scope: 							Global
# 		Dynamic: 						No
# 		SET_VAR Hint: 					No
# 		Type: 							Enumeration
#
# 		Default (>= 8.0.4) 			caching_sha2_password
#
# 		Default (<= 8.0.3) 			mysql_native_password
#
# 		Valid (>= 8.0.3) 				mysql_native_password
# 											sha256_password
# 											caching_sha2_password
#
# 		Valid (<= 8.0.2) 				mysql_native_password
# 											sha256_password
#
# 		The default auth plugin. Permitted values are:
#
# 			mysql_native_password: Use MySQL native PWs.
# 
# 			sha256_password: Use SHA-256 PWs.
#
# 			caching_sha2_password: Use SHA-256 passwords. (Default auth plugin rather than mysql_native_password)
#
# 		This value affects these aspects of server operations:
#
# 			Determines which authentication plugin the server assigns to new accounts created by CREATE USER and GRANT statements that 
# 			do not explicitly specify an authentication plugin.
#
# 			For an account created with the following statement, the server associates the account with the default auth plugin and assigns
# 			the account the given PW - hashed as required by that plugin:
#
# 				CREATE USER ... IDENTIFIED BY 'cleartext password';
#
# default_collation_for_utf8mb4
#
# 		Introduced: 		8.0.11
# 		Sys Var: 			default_collation_for_utf8mb4
# 		Scope: 				Global, Session
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Enumeration
# 		Valid: 				utf8mb4_0900_ai_ci 
# 								utf8mb4_general_ci
#
# 		For interal use by replication. This SYS VAR is set to the default collation for the utf8mb4 char set.
#
# 		The value of the Var is replicated from a master to a slave so that the slave can correctly process data
# 		originating from a master with a different default collation for utf8mb4.
#
# 		Primarily intended to support replication from MySQL 5.7 or older master servers to MySQL 8.0 slave server,
# 		or group replication with a MySQL 5.7 primary node and one or more MySQL 8.0 secondaries.
#
# 		The default collation for utf8mb4 in MySQL 5.7 is utf8mb4_general_ci, but utf8mb4_0900_ai_ci in MySQL 8.0
#
# 		If the slave does not recieve a value for the Var, it assumes the master is from an earlier release and sets
# 		the value to the previous default collation utf8mb4_general_ci.
#
# 		Is a restircted operation, requires privs to set.
#
# 		The default utf8mb4 collation is used in the following statements:
#
# 			SHOW COLLATION and SHOW CHARACTER SET.
#
# 			CREATE TABLE and ALTER TABLE having a CHARACTER SET utf8mb4 clause without a COLLATION clause, either for 
# 			the table char set or for a column char set.
#
# 			CREATE DATABASE and ALTER DATABASE having a CHARACTER SET utf8mb4 clause without a COLLATION clause.
#
# 			Any statement containing a string literal of the form _utf8mb4'<some text>' without a COLLATION clause.
#
# default_password_lifetime
#
# 		cmd line format: 		--default-password-lifetime=#
# 		Sys Var: 				default_password_lifetime
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min value: 				0
# 		Max: 						65535
#
# 		Defines the global automatic password expiration policy. The default_password_lifetime value is 0,
# 		which disables automatic password expiration.
#
# 		If the value of default_password_lifetime is a positive int <N>, it indicates the permitted password lifetime; PWs must be changed every <N> days.
#
# 		The global PW expiration policy can be overwritten with individual accounts using the PW expiration option of CREATE USER and ALTER USER statements.
#
# default_storage_engine
#
# 		cmd line format: 		--default-storage-engine=name
# 		Sys var: 				default_storage_engine
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				InnoDB
#
# 		The default storage engine. This variable sets the storage engine for permanent tables only. To set the storage engine
# 		for TEMPORARY tables, set the default_tmp_storage_engine SYS var.
#
# 		To see which storage engines are available and on - we can use SHOW ENGINES or query the INFORMATION_SCHEMA ENGINES table.
#
# 		If you disable the default storage engine at server startup, you must set the default engine for both permanent and TEMPORARY
# 		tables to a different engine or the server won't start.
#
# default_tmp_storage_engine
#
# 		Cmd line format: 		--default-tmp-storage-engine=name
# 		Sys Var: 				default_tmp_storage_engine
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Enumerator
# 		Default: 				InnoDB
#
# 		The default storage engine for TEMPORARY tables (created with CREATE TEMPORARY TABLE)
# 		To set the storage engine for permanent tables - set the default_storage_Engine SYS VAR.
#
# 		If you disable the default storage engine at server startup, you must set the default engine for both
# 		permanent and TEMPORARY tables to a different engine or the server won't start.
#
# default_week_format
#
# 		cmd line format: 		--default-week-format=#
# 		Sys Var: 				default_week_format
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max: 						7
#
# 		Default mode value to use for the WEEK() function
#
# delay_key_write
#
# 		cmd line format: 		--delay-key-write[=name]
# 		Sys Var: 				delay_key_write
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				ON
# 		Valid: 					ON, OFF, ALL
#
# 		This option applies only to MyISAM tables. 
#     It can have one of the following values to affect handling of the DELAY_KEY_WRITE table option that can be used in CREATE TABLE statements.
#
# 		OFF - 	DELAY_KEY_WRITE is ignored.
# 		ON  - 	MySQL honors any DELAY_KEY_WRITE option specified in CREATE_TABLE statements. DEFAULT.
# 		ALL - 	All new opened tables are treated as if they were created with the DELAY_KEY_WRITE option on.
#
# 		If this option is on, the key buffer is not flushed for the table on every index update - but only when the table is closed.
# 		This speeds up writes on keys a lot - but if you use this feature, you should add automatic checking of all MyISAM tables by
# 		starting with --myisam-recover-options , example:
#
# 		--myisam-recover-options=BACKUP, FORCE
#
# 		If external locking is on with --external-locking, there is no protection against index corruption for tables that use
# 		delayed key writes.
#
# delayed_insert_limit
#
# 		cmd line format: 			--delayed-insert-limit=#
# 		Deprecated: 				Yes
# 		Sys var: 					delayed_insert_limit
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Integer
# 		Default: 					100
# 		Min: 							1
# 		Max (64-bit) 				<a lot>
# 		Max (32-bit) 				<less>
#
# 		This Sys var is deprecated (DELAYED inserts are not supported), will be removed.
#
# delayed_insert_timeout
#
# 		cmd line format: 			--delayed-insert-timeout=#
# 		Deprecated: 				Yes
# 		Sys Var: 					delayed_insert_timeout
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Integer
# 		Default: 					300
#
# 		Deprecated, same as above.
#
# delayed_queue_size
#
# 		cmd line format: 			--delayed-queue-size=#
# 		Deprecated: 				Yes
# 		Sys Var: 					delayed_queue_size
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Integer
# 		Default: 					1000
# 		Min: 							1
# 		Max (64-bit) 				<a lot>
# 		Max (32-bit) 				<less>
#
# 		Deprecated
#
# disabled_storage_engines
#
# 		cmd line format: 			--disabled-storage-engines=engine[, engine]...
# 		Sys Var: 					disabled_storage_engines
# 		Scope: 						Global
# 		Dynamic: 					No
# 		SET_VAR Hint: 				No
# 		Type: 						String
# 		Default: 					empty string
#
# 		indicates which storage engines cannot be used to create tables or tablespaces.
# 		For example,to prevent new MyISAM or FEDERATED tables from being created - start with the lines as follows:
#
# 			[mysqld]
# 			disabled_storage_engines="MyISAM,FEDERATED"
#
# 		By default - disabled_storage_engines is empty (no engines disabled) - but can be defined with a comma-listed list.
# 
# 		Values included cause said values to not be able to be used to create tables or tablespaces with CREATE_TABLE or CREATE_TABLESPACE,
# 		and cannot be used with ALTER_TABLE_..._ENGINE or ALTER_TABLESPACE_..._ENGINE to change existing storage engines of tables or tablespaces.
#
# 		Doing so causes a ER_DISABLED_STORAGE_ENGINE error
#
# 		disabled_storage_engines does not restrict other DDL statements for existing tables, such as CREATE_INDEX,
# 		TRUNCATE_TABLE, ANALYZE_TABLE, DROP_TABLE or DROP_TABLESPACE.
#
# 		This permits a smooth transition so that existing tables or tablespaces that use a disabled engine can be migrated to a 
# 		permitted engine by means such as ALTER_TABLE_..._ENGINE_<permitted_engine>
#
# 		It is permitted to set the default_storage_engine or default_tmp_storage_engine SYS var to a storage engine that is disabled.
#
# 		However, it does make the database crash upon attempting to be utilized if used in tandem with this stature. (Can be used for debugging)
#
# 		disabled_storage_engines is disabled and has no effect if the server is started with any of these options:
#
# 			--initialize, --initialize-insecure, --skip-grant-tables
#
# 		Setting this can cause a error with mysqld_upgrade
#
# disconnect_on_expired_password
#
# 		Cmd line format: 		--disconnect-on-expired-password[=#]
# 		Sys Var: 				disconnect_on_expired_password
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		This var controls how the server handles clients with expired passwords:
#
# 			If the client indicates that it can handle expires passwords, the value of disconnect_on_expired_password
# 			is irrelevant. The server permits the client to connect but puts it in sandbox mode.
#
# 			If the client does not indicate that it can handle expires passwords, it handles it according to disconnect_on_expired_password:
#
# 				Enabled -> Disconnects the client
#
# 				Disabled -> permits, but keeps in Sandbox mode
#
# div_precision_increment
#
# 		cmd line format: 			--div-precision-increment=#
# 		Sys Var: 					div_precision_increment
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				Yes
# 		Type: 						Integer
# 		Default: 					4
# 		Min: 							0
# 		Max: 							30
#
# 		This variable indicates the number of digits by which to increase the scale of the result of division operations performed with
# 		the / operator.
#
# dragnet.log_error_filter_rules
#
# 		cmd line format: 			--dragnet.log-error-filter-rules
# 		Introduced: 				8.0.4
# 		Sys Var: 					dragnet.log_error_filter_rules
# 		Scope: 						Global
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						String
# 		Default: 					IF prio>=INFORMATION THEN drop. IF EXISTS source_line THEN unset source_line.
#
# 		The filter rules that control operation of the log_filter_dragnet error log filter component.
# 		If log_filter_dragnet is not installed, dragnet.log_error_filter_rules is N/A.
#
# 		If log_filter_dragnet is installed but off, dragnet.log_error_filter_rules have no effect.
#
# 		(MySQL 8.0.12 >=) - the dragnet.Status variable can be consulted to determine the result of the most
# 		recent assignment to dragnet.log_error_filter_rules
#
# 		(MySQL 8.0.12 <)  - the dragnet.Status assignment upon success, spawned a warning:
#
# 			mysql> SET GLOBAL dragnet.log_error_filter_rules = 'IF prio <> 0 THEN unset prio.';
# 			Query OK, 0 rows affected, 1 warning (0.00 sec)
#
# 			mysql> SHOW WARNINGS\G
# 			******************************** 1. row *******************************************
# 			Level: Note
# 			Code:  4569
# 			Message: filter configuration accepted:
# 						SET @@global.dragnet.log_error_filter_rules='IF prio!=ERROR THEN unset prio.';
#
# 		The value displayed by SHOW_WARNINGS indicates the "decompiled" canonical rep. after the rule set has been
# 		successfully parsed and compiled into internal form.
#
# 		Semantically, this canonical form is identical to the value assigned to dragnet.log_error_filter_rules,
# 		but there may be some differences between the assigned and canonical values, as illustrated:
#
# 			<> goes to !=
#
# 			Numeric prio of 0 is changed to SEVERITY level ERROR
#
# 			Optional spaces are gone
#
# end_markers_in_json
#
# 		Sys var: 		end_markers_in_json
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	Yes
# 		Type: 			Boolean
# 		Default: 		OFF
#
# 		Whether optimizer JSON output should add end markers.
#
# eq_range_index_dive_limit
#
# 		Sys var: 		eq_range_index_dive_limit
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	Yes
# 		Type: 			Integer
# 		Default: 		200
# 		Min: 				0
# 		Max: 				<a lot>
#
# 		This variable indicates the number of equality ranges in an equality comparison condition when the optimizer
# 		should switch from using index drives to index statistics in estimating the number of qualifying rows.
#
# 		It applies to evaluation of expressions that have either of these equivalent forms, where the optimizer uses
# 		a nonunique index to look up <col_name> values:
#
# 			col_name IN(val1, ..., valN)
# 			col_name = val1 OR ... OR col_name = valN
#
# 		In both cases, the expression contains N equality ranges.
#
# 		The optimizer can make row estimates using index dives or index statistics.
#
# 		If eq_range_index_dive_limit is greater than 0, the optimizer uses existing index
# 		statistics instead of index dives if there are eq_range_index_dive_limit or more equality ranges.
#
# 		Thus, to permit use of index dives for up to <N> equality ranges, set eq_range_index_dive_limit to N + 1.
# 		To disable use of index statistics and always use index dives regardless of <N>, set this to 0.
#
# 		To update the table index stats for best estimates, use ANALYZE_TABLE.
#
# error_count
#
# 		Number of errors that resulted from the last statement that generated messages. is Read only.
#
# event_scheduler
#
# 		cmd line format: 		--event-scheduler[=value]
# 		Sys Var: 				event_scheduler
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default (>= 8.0.3) 	ON
# 		Default (<= 8.0.2) 	OFF
# 		Valid: 					ON, OFF, DISABLED
#
# 		This variable indicates the status of the Event Scheduler.
#
# explicit_defaults_for_timestamp
#
# 		cmd line format: 		--explicit-defaults-for-timestamp=#
# 		Deprecated: 			Yes
# 		Sys Var: 				explicit_defaults_for_timestamp
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default (>= 8.0.2) 	ON
# 		Default (<= 8.0.1) 	OFF
#
# 		This sys var determines whether the server enables certain nonstandard behaviors for default values and NULL value
# 		handling in TIMESTAMP columns.
#
# 		By default, explicit_defaults_for_timestamp is enabled, which disables the nonstandard behaviors.
# 		Disabling explicit_defaults_for_timestamp results in a warning.
#
# 		Setting this in scope of session is a restricted operation. Requires privs to allow for setting.
#
# 		If explicit_defaults_for_timestamp is disabled - the server enables the nonstandard behaviors and handles TIMESTAMP cols as follows:
#
# 			TIMESTAMP columns not explicitly declared with the NULL attribute are automatically declared with the NOT NULL attribute.
# 			Assigning such a column value of NULL is permitted and sets the column to the current timestamp.
#
# 			The first TIMESTAMP column in a table, if not explicitly declared with the NULL attribute or an explicit DEFAULT 
# 			or ON UPDATE attribute, is automatically declared with the DEFAULT CURRENT_TIMESTAMP and ON UPDATE CURRENT_TIMESTAMP attributes.
#
# 			TIMESTAMP columns following the first one, if not explicitly declared with the NULL attribute or an explicit DEFAULT,
# 			are automatically declared as DEFAULT '0000-00-00 00:00:00'. For inserted rows that specify no explicit value for such
# 			a column, it defaults to the above with no warnings.
#
# 			Strict SQL mode or the NO ZERO DATE SQL mode being on - can cause invalidation of defaulting to 0000-00-00 00:00:00 may be invalid.
# 			Be aware that the TRADITIONAL SQL mode includes strict mode and NO ZERO DATE.
#
# 		The above is deprecated and will be removed.
#
# 		If explicit_defaults_for_timestamp is on, the server disables the above and handles instead with:
#
# 			It is not possible to assign a TIMESTAMP column a value of NULL to set it to the current timestamp.
# 			To do such, you must use NOW() or CURRENT_TIMESTAMP.
#
# 			TIMESTAMP columns not explicitly declared with the NOT NULL attribute are automatically declared with the
# 			NULL attribute and permit NULL values. (i.e - Assigning it NULL, causes it to be NULL)
#
# 			TIMESTAMP columns declared with the NOT NULL attribute do not permit NULL values.
# 			For inserts that specify NULL for such a column, the result is an error, regardless of mode.
#
# 			TIMESTAMP cols explicitly declared with the NOT NULL attribute and without an explicit DEFAULT attribute
# 			are treated as having no default value. (if Strict is not on, the implicit default is '0000-00-00 00:00:00' and a Warning.
#
# 			No TIMESTAMP cols are automatically declared with the DEFAULT CURRENT_TIMESTAMP or ON UPDATE CURRENT_TIMESTAMP attribs.
# 			(Must be explicitly declared)
#
# 			The first TIMESTAMP col in a table is not handled differently from TIMESTAMP cols following the first one.
#
# 		If explicit_defaults_for_timestamp is disabled at start, this warning crops up:
#
# 			[Warning] TIMESTAMP with implicit DEFAULT value is deprecated.
# 			Please use --explicit_defaults_for_timestamp server option
#
# 		NOTE: --explicit_defaults_for_timestamp is deprecated as well. Will be removed.
#
# external_user
#
# 		Sys var: 		external_user
# 		Scope: 			Session
# 		Dynamic: 		No
# 		SET_VAR Hint: 	No
# 		Type: 			String
#
# 		External user name used during the authentication process, as set by the plugin used to authenticate the client.
# 		With native MySQL auth or if the plugin does not set the value - this is NULL. (Relates to Poxy users)
#
# flush
#
# 		cmd line format: 	--flush
# 		Sys Var: 			flush
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Boolean
# 		Default: 			OFF
#
# 		If ON, the server flushes (synchs) all changes to disk after each SQL statement.
# 		Normally, MySQL does a write of all changes to disk only after each SQL statement
# 		and lets the OS handle the Sync to disk.
#
# 		Starts with ON if we start mysqld with --flush.
#
# 		NOTE: if enabled, flush_time does nothing, and changing it does nothing.
#
# flush_time
#
# 		cmd line format: 	--flush-time=#
# 		Sys var: 			flush_time
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Integer
# 		Default: 			0
# 		Min: 					0
#
# 		If set to a nonzero value, all tables are closed every flush_time seconds to free up resources and synch unflushed data to disk.
# 		Only use for systems with small amounts of resources.
#
# foreign_key_checks
#
# 		Sys Var: 			foreign_key_checks
# 		Scope: 				Global, Session
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		Yes
# 		Type: 				Boolean
# 		Default: 			ON
#
# 		If set to 1 (the default), foreign key constraints for InnoDB tables are checked.
# 		If set to 0, foreign key constraints are ignored, with a couple of exceptions.
#
# 		When re-creating a table that was dropped, an error is returned if the table definition
# 		does not conform to the foreign key constraints referencing the table.
#
# 		Likewise, an ALTER_TABLE operation returns an error if a foreign key definition is incorrectly formed.
#
# 		Typically, you leave this enabled during normal ops. Disabling can be used for reloading InnoDB tables
# 		in a order different from that required by their parent/child relationships.
#
# 		Setting foreign_key_checks to 0 also affects data definition statements: 
#
# 		DROP_SCHEMA drops a schema even if it contains tables that have foreign keys 
# 		that are referred to by tables outside the schema, and DROP_TABLE drops tables 
# 		that have foreign keys that are reffered by other tables.
#
# 		NOTE: Setting this to 1, does not trigger a scan of the existing table data. Therefore,
# 				rows added to the table while foreign_key_checks = 0 will not be verified for consistency.
#
# 				Dropping an index required by a foreign key constraint is not permitted, even with foreign_key_checks=0
# 				The foreign key constraint must be removed before dropping the index.
#
# ft_boolean_syntax
#
# 		cmd line format: 	--ft-boolean-syntax=name
# 		Sys Var: 			ft_boolean_syntax
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				String
# 		Default: 			+ -><()~*:""&|
#
# 		The list of operators supported by boolean full-text searches performed using IN BOOLEAN MODE.
#
# 		The rules for changing the default of this is:
#
# 			Operator function is defined by pos in string
#
# 			Replacement must be 14 chars
#
# 			Each char must be an ASCII nonalphanumeric char
#
# 			Either the first or second char must be a space.
#
# 			No duplicates are permitted except the phrase quoting operators in pos 11 and 12.
# 			These two chars are not required to be the same, but they are the only two that may be.
#
# 			Pos 10, 13 and 14 (defaults to :, &, |) are reserved for future extensions.
#
# ft_max_word_len
#
# 		cmd line format: 		--ft-max-word-len=#
# 		Sys Var: 				ft_max_word_len
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Min: 						10
#
# 		Max length of word in a MyISAM FULLTEXT index.
#
# 		NOTE: FULLTEXT indexes on MyISAM tables must be rebuilt after changing this var. Use REPAIR TABLE <tbl_name> QUICK.
#
# ft_min_word_len
#
# 		cmd line format: 		--ft-min-word-len=#
# 		Sys Var: 				ft_min_word_len
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				4
# 		Min: 						1
#
# 		The min length of the word to be included in a MyISAM FULLTEXT index.
#
# 		NOTE: FULLTEXT indexes on MyISAM tables must be rebuilt after changing this var. Use REPAIR TABLE <tbl_name> QUICK.
#
# ft_query_expansion_limit
#
# 		Cmd line format: 		--ft-query-expansion-limit=#
# 		Sys Var: 				ft_query_expansion_limit
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				20
# 		Min: 						0
# 		Max: 						1000
#
# 		number of top matches to use for full-text searches performed using WITH QUERY EXPANSION.
#
# ft_stopword_file
#
# 		cmd line format: 		--ft-stopword-file=file_name
# 		Sys Var: 				ft_stopword_file
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					File name
#
# 		The file from which to read the list of stopwords for full-text searches on MyISAM tables.
# 		The server looks for the file in the data directory unless an absolute path name is given to specify a different dir.
#
# 		All the words from the file are used;, comments are not.
#
# 		By default, a list of stopwords is used (defined in storage/myisam/ft_static.c file)
#
# 		Setting this to '' disables stopword filtering.
#
# 		FULLTEXT indexes on MyISAM tables must be rebuilt after changing this var or the contents of the stopword file.
# 		Use REPAIR TABLE <tbl_name> QUICK.
#
# general_log
#
# 		cmd line format: 		--general-log
# 		Sys Var: 				genral_log
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Whether the general query log is enabled. Can be 0/OFF to disable the log or 1/ON to enable.
#
# 		Default depends on whether the --general_log option is given.
#
# 		The destination for log output is controlled by the log_output SYS_VAR; if that value is NONE, no log entries
# 		are written even if the log is enabled.
#
# general_log_file
#
# 		cmd line format: 		--general-log-file=file_name
# 		Sys Var: 				general_log_file
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					File name
# 		Default: 				host_name.log
#
# 		Name of the general query log file. Defaults to <host_name.log> but the initial value can be changed with --general_log_file option.
#
# group_concat_max_len
#
# 		Cmd line format: 		--group-concat-max-len=#
# 		Sys Var: 				group_concat_max_len
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Int
# 		Default: 				1024
# 		Min: 						4
# 		Max (64-bit) 			<a lot>
# 		Min (32-bit) 			<less>
#
# 		Max permitted result length in bytes for the GROUP_CONCAT() function. Defaults to 1024.
#
# have_compress
#
# 		Yes if the zlib compression lib is available to the server, NO if not.
# 		If not, the COMPRESS() and UNCOMPRESS() functions cannot be used.
#
# have_crypt
# 		
# 		REMOVED
#
# have_dynamic_loading
#
#		Yes if mysqld supports dynamic loading of plugins, NO if not.
# 		If NO, cannot use options such as --plugin-load to load plugins at server startup, or the
# 		INSTALL_PLUGIN statement to load plugins at runtime.
#
# have_geometry
#
# 		YES if the server supports spatial data types, NO if not.
#
# have_openssl
#
# 		This variable is an alias for have_ssl
#
# have_profiling
#
# 		YES if statement profiling capability is present, NO if not.
# 		If present, the profiling system variable controls whether this capability is enabled or disabled.
#
# 		DEPRECATED.
#
# have_query_cache
#
# 		Query cache was removed in 8.0.3, have_query_cache is deprecated, always NO.
#
# have_rtree_keys
#
# 		YES if RTREE indexes are available, NO if not. (Used for Spatial indexes in MyISAM tables)
#
# have_ssl
#
# 		Yes if mysqld supports SSL connections, NO if not. DISABLED if server was compiled with SSL, but not activated with the respective --ssl-xxx option
#
# have_statement_timeout
#
# 		Sys_Var: 		have_statement_timeout
# 		Scope: 			Global
# 		Dynamic: 		No
# 		SET_VAR Hint: 	No
# 		Type: 			Boolean
#
# 		Whether the statement execution timeout feature is available. 
# 		Can be NO if the background thread used by this feature, could not be initialized.
# 		
# have_symlink
#
# 		YES if symbolic link support is enabled, NO if not.
# 		Required on UNIX for support of the DATA DIRECTORY and INDEX DIRECTORY table options.
#
# 		If the server is started with --skip-symbolic-links - this value is Disabled.
#
# 		Means nothing on Windows.
#
# 		NOTE: Symbolic links are deprecated in support and stature.
#
# histogram_generation_max_mem_size
#
# 		cmd line format: 		--histogram-generation-max-mem-size=#
# 		Introduced: 			8.0.2
# 		Sys Var: 				histogram_generation_max_mem_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		DEFAULT: 				20000000
# 		min value: 				1000000
# 		max (64-bit) 			<a lot>
# 		max (32-bit) 			<less>
#
# 		Max amount of memory for generating histogram stats.
#
# 		Setting this is a restricted ops, reqs privs.
#
# host_cache_size
#
# 		Sys Var: 				host_cache_size
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				-1 (Autosizing, do not assign)
#		Min: 						0
# 		Max: 						65536
#
# 		Size of the internal host cache. Setting it to 0 disables the host cache.
#
# 		Changing the cache size at runtime implicitly causes a FLUSH HOSTS ops to clear the host cache
# 		and truncate the host_cache table.
#
# 		Defaults to 128 + 1 for a value of max_connections up to 500, plus 1 for every 20 above 500, up to 2k.
#
# 		Using --skip-host-cache is similar to setting the host_cache_size SYS_VAR to 0, but host_cache_size can be set during
# 		runtime - not just startup.
#
# 		If started with --skip-host-cache, modification attempts are simply ignored.
#
# hostname
#
# 		Sys var: 				hostname
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
#
# 		The server sets this var to the server host name at startup.
#
# identity
#
# 		Synonym for the last_insert_id var. Exists for compability with other DB systems.
# 		can be read with SELECT @@identity, and set it using SET identity.
#
# init_connect
#
# 		cmd line format: 		--init-connect=name
# 		Sys Var: 				init_connect
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
#
# 		A string to be executed by the server for each client that connects. 
# 		The string consists of one or more SQL statements, separated by ; chars.
#
# 		For example, each client session begins by default with autocommit mode enabled.
# 		For older servers (< 5.5.8) - there is no global autocommit SYS_VAR to specify that autocommit
# 		should be off by default - but can be circumvented with:
#
# 		SET GLOBAL init_connect='SET autocommit=0';
#
# 		Can also beb set on cmd or in a option file:
#
# 		[mysqld]
# 		init_connect='SET autocommit=0'
#
# 		For users with SUPER priv or CONNECTION_ADMIN - the content of init_connect is not executed.
#
# 		(MySQL 8.0.5 >=) 	init_connect is skipped for any client with an expired PW.
#
# 		Allows for connection and changing of PW.
#
# information_schema_stats_expiry
#
# 		cmd line format: 		--information-schema-stats-expiry=value
# 		Introduced: 			8.0.3
# 		Sys Var: 				information_schema_stats_expiry
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				86400
# 		min: 						0
# 		Max: 						<a lot>
#
# 		Some of the information_schema tables that contain columns that provide table stats:
#
# 		STATISTICS.CARDINALITY
# 		TABLES.AUTO_INCREMENT
# 		TABLES.AVG_ROW_LENGTH
# 		TABLES.CHECKSUM
# 		TABLES.CHECK_TIME
# 		TABLES.CREATE_TIME
# 		TABLES.DATA_FREE
# 		TABLES.DATA_LENGTH
# 		TABLES.INDEX_LENGTH
# 		TABLES.MAX_DATA_LENGTH
# 		TABLES.TABLE_ROWS
# 		TABLES.UPDATE_TIME
#
#		Said columns represent the dynamic table metadata - information that changes as table contents change.
#
# 		By default, MySQL retrieves cached values for those columns from the mysql.index_stats and mysql.table_stats dictionary tables
# 		when the columns are queried, which is more efficient than retrieving stats directly from the storage engine.
#
# 		If cached stats are not available or have expired, MySQL retrieves the latest stats from the storage engine
# 		and caches them in the mysql.index_stats and mysql.table_stats dictionary tables.
#
# 		Subsequent queries retrieve the cachhed stats until the cached stats expire.
#
# 		The information_schema_stats_expiry session var defines the period of time before cached stats expire.
# 		The default is 24 hours (86400 secs), but the time period can be extended to as much as one year.
#
# 		To update cached values at any time for a given table, use ANALYZE TABLE.
#
# 		To always retrieve the latest directly from the storage engine and bybpass cached values, set information_schema_stats_expiry to 0.
#
# 		Querying stats columns does not store or update stats in the mysql.index_stats and mysql.table_stats dictionary tables under said circumstnaces:
#
# 			When cached stats have not expired
#
# 			When information_schema_stats_expiry is set to 0
#
# 			When the server is started in read_only, super_read_only, transaction_read_only or innodb_read_only
#
# 			When the query also fetches Performance Schema Data
#
# 		information_schema_stats_expiry is a session var, and each client session can define its own expiration value.
# 		Stats that are retrieved from the storage engine and cached by one session are available to other sessions.
#
# init_file
#
# 		Cmd line format: 		--init-file=file_name
# 		Sys Var: 				init_file
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					File name
#
# 		The name of the file specified with the --init-file option when you start the server.
#
# 		This should be a file containing SQL statements that you want the server to execute when it starts.
#
# 		Each statement must be on a single line and no comments. 
#
# innodb_xxx
#
# 		InnoDB sys vars are listed later.
#
# 		Said Vars control many aspects of storage, memory use and I/O patterns for InnoDB tables, and are called for in relation to InnoDB default storage engines.
#
# insert_id
# 
# 		The value to be used by the following INSERT or ALTER_TABLE statement when inserting an AUTO_INCREMENT value.
# 		Mainly used with the binary log.
#
# interactive_timeout
#
# 		cmd line format: 		--interactive-timeout=#
# 		Sys Var: 				interactive_timeout
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				28800
# 		Min: 						1
#
# 		The number of seconds the server waits for acitvity on an interactive connection before closing it.
# 		An interactive client is defined as a client that uses the CLIENT_INTERACTIVE option to mysql_real_connect()
#
# internal_tmp_disk_storage_engine
#
# 		cmd line format: 		--internal-tmp-disk-storage-engine=#
# 		Sys Var: 				internal_tmp_disk_storage_engine
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				INNODB
# 		Valid: 					MYISAM
# 									INNODB
#
# 		The storage engine for on-disk internal temp tables. Permitted values are MYISAM and INNODB (Default)
#
# 		The optimizer uses the storage engine defined by internal_tmp_disk_storage_engine for on-disk internal temporary tables.
#
# 		When using internal_tmp_disk_storage_engine=INNODB (the default), queries that generate on-disk internal temp tables that exceed
# 		InnoDB row or column limits will return Row size too large or Too many columns errors.
#
# 		The workaround is to set internal_tmp_disk_storage_engine to MYISAM.
#
# internal_tmp_mem_storage_engine
#
# 		cmd line format: 		--internal-tmp-mem-storage-engine=#
# 		introduced: 			8.0.2
# 		SYS Var: 				internal_tmp_mem_storage_engine
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Enumeration
# 		Default: 				TempTable
# 		Valid: 					TempTable, MEMORY
#
# 		The storage engine for in-memory internal temporary tables.
#
# 		The optimizer uses the storage engine defined by internal_tmp_mem_storage_engine for in-memory internal temp tables.
#
# join_buffer_size
#
# 		cmd line format: 		--join-buffer-size=#
# 		Sys Var: 				join_buffer_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				262144
# 		Min value: 				128
# 		Max (Other, 64-bit) 	<most>
# 		Max (Other, 32-bit) 	<less>
# 		Max (Windows) 			<less>
#
# 		The min size of the buffer that is used for plain index scans, range index scans, and joins that do not 
# 		use indexes and thus perform full table scans.
#
# 		Normally - the best way to get fast joins is to add indexes. Increase the value of join_buffer_size to get a faster
# 		full join when adding indexes is not possible.
#
# 		One join buffer is allocated for each full join between two tables. For a complex join between several tables for which 
# 		indexes are not used, multiple join buffers might be nessecary.
#
# 		Unless Batched Key Access (BKA) is used, there is no gain from setting the buffer larger than required to hold each
# 		matching row - and all joins allocate at least the min size, thus, careful with global min designation.
#
# 		It is better to have the global be small, and allow for session values that are larger - when thye perform large joins.
# 		Memory allocation time can cause large performance drops if the global size is larger than needed by most queries that use it.
#
# 		When BKA is used, the value of join_buffer_size defines how large the batch of keys is in each request to the storage engine.
# 		The larger the buffer, the more sequential access will be to the right hand table of a join operation, which can significantly 
# 		improve performance.
#
# 		Defaults to 256kb, max is 4gb-1. Larger is allowed for 64-bit (Windows throws a warning and sets to max)
#
# keep_files_on_create
#
# 		cmd line format: 		--keep-files-on-create=#
# 		Sys Var: 				keep_files_on_create
# 		Scope: 					Global ,Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		if a MyISAM table is created with no DATA DIR option, the .MYD file is created in the DB directory.
# 		By default, if MyISAM finds an existing .MYD file in this case, it overwrites it.
#
# 		The same applies to .MYI files for tables created with no INDEX DIRECTORY option.
# 		To suppress this behavior, set the keep_files_on_create var to ON(1), which causes MyISAM to not overwrite
# 		existing files and returns an error instead. 
#
# 		If a MyISAM table is created with a DATA DIRECTORY or INDEX DIRECTORY option and an existing .MYD or .MYI file is found,
# 		MyISAM always returns an error. It will not overwrite a file in the specified dir.
#
#
# key_buffer_size
#
# 		cmd line format: 		--key-buffer-size=#
# 		Sys Var: 				key_buffer_size
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				8388608
# 		Min value: 				8
# 		Max value(64-bit) 	OS_PER_PROCESS_LIMIT
# 		Max (32-bit) 			4294967295
#
# 		Index blocks for MyISAM tables are buffered and are shared by all threads. key_buffer_size is the size of the buffer used
# 		for index blocks. The key buffer is also known as the key cache.
#
# 		The max permissible setting for key_buffer_size is 4gb-1 on 32-bit platforms.
#
# 		Larger are allowed on 64-bit - Realistic size might be less. 
#
# 		The above is akin to a "hint" of request of setting to - value can be overwritten by underlying OS or Hardware etc.
#
# 		You can increase the value to get better index handling for all reads and multiple writes; on a System whose primary
# 		function is to run MySQL using the MyISAM storage engine, 25% of the total machine memory is fine.
#
# 		If assigned too large of a value, the underlying OS which handles file system caching for data reads will start to lag
#
# 		For even more speed when writing many rows at the same time, use LOCK_TABLES.
#
# 		You can check the performance of the key buffer by issuing a SHOW_STATUS statement and examining the Key_read_requests,
# 		Key_reads, Key_write_requests and Key_writes status.
#
# 		The Key_reads/Key_read_requests ratio should normally be less than 0.01.
#
# 		The Key_writes/Key_write_requests ratio is usually near 1 if you use mostly updates and deletes,
# 		but can be smaller in case of updating many rows at the same time or using the DELAY_KEY_WRITE table option.
#
# 		The fraction of the key buffer in use can be determined using key_buffer_size in conjunction with the Key_blocks_unused
# 		status variable and buffer block size, which is available from the key_cache_block_size Sys_var:
#
# 		- ((Key_blocks_unused * key_cache_block_size) / key_buffer_size)
#
# 		This value is an approximation because some space in the key buffer is allocated internally for admin structs.
# 		Factors that influence the amount of overhead for these structures include block size and pointer size.
#
# 		As block size increases, the percentage of the key buffer lost to overhead tends to decrease.
#
# 		larger blocks result in a smaller number of read ops (because more keys are obtained per read),
# 		but an increase in reads of keys that are not examined (if not all keys in a block are relevant to a query)
#
# 		It is possible to create Multiple MyISAM key caches. The size limit of 4gb applies to each cache individually, not as a group.
#
# key_cache_age_threshold
#
# 		Cmd line format: 		--key-cache-age-threshold=#
# 		Sys var: 				key_cache_age_threshold
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				300
# 		Min: 						100
# 		Max value (64-bit): 	<a lot>
# 		Max value (32-bit): 	<less>
#
# 		Controls the demotion of buffers from hot sublist of a key cache to the warm sublist.
# 		Lower values causes demotion to happen more quickly.
#
# 		Min 100. default 300.
#
# key_cache_block_size
#
# 		cmd line format: 		--key-cache-block-size=#
# 		Sys var: 				key_cache_block_size
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1024
# 		Min: 						512
# 		Max: 						16384
#
# 		Size in bytes of blocks in the key cache. Defaults to 1024.
#
# key_cache_division_limit
#
# 		cmd line format: 		--key-cache-division-limit=#
# 		Sys var: 				key_cache_division_limit
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				100
# 		Min: 						1
# 		mx: 						100
#
# 		The division point between the hot and warm sublist of the key cache buffer list.
# 		The value is the % of the buffer list to use for the warm sublist.
#
# large_files_support
#
# 		Sys var: 				large_files_support
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
#
# 		Whether mysqld was compiled with options for large file support.
#
# large_pages
#
# 		cmd line format: 		--large-pages
# 		Sys var: 				large_pages
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Platform: 				Linux
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Whether large page support is enabled (via the --large-pages option)
#
# large_page_size
#
# 		Sys var: 				large_page_size
# 		scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
#
# 		If large page support is enabled, this shows the size of memory pages.
# 		Large memory pages are supported only on Linux, on other OS's - this is always 0.
#
# last_insert_id
#
# 		The values to be returned from LAST_INSERT_ID(). This is stored in the binary log when you use
# 		LAST_INSERT_ID() in a statement that updates a table.
#
# 		Setting this var does not update the value returned by the mysql_insert_id() C API Function
#
# lc_messages
#
# 		cmd line format: 		--lc-messages=name
# 		Sys Var: 				lc_messages
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				en_US
#
# 		The locale to use for error messages. The default is en_US. THe server converts the argument
# 		to a language name and combines it with the value of lc_messages_dir to produce the location
# 		for the error message file.
#
# lc_messages_dir
#
# 		cmd line format: 		--lc-messages-dir=dir_name
# 		Sys var: 				lc_messages_dir
# 		Scope: 					global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name:
#
# 		The dir where error messages are located. The server uses the value together with the values of lc_messages
# 		to produce the location for the error message file.
#
# lc_time_names
#
# 		Sys var: 				lc_time_names
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
#
# 		This var specifies the locale that contorls the language used to display day and month names and abbreviations.
# 		This var affects the output from the DATE_FORMAT(), DAYNAME() and MONTHNAME() functions.
#
# 		Locale names are POSIX-style values such as 'ja_JP' or 'pt_BR'. Default is 'en_US' regardless of your system locale setting.
#
# license
#
# 		Sys var: 				license
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				GPL
#
# 		Type of license the server has
#
# local_infile
#
# 		Sys var: 				local_infile
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			no
# 		Type: 					Boolean
# 		Default (>= 8.0.2) 	OFF
# 		Default (<= 8.0.1) 	oN
#
# 		This variable controls server-side LOCAL capability for LOAD_DATA statements. 
#
# 		Depending on the local_infile setting, the server refuses or permits local data loading 
# 		by clients that have LOCAL enables on the client side.
#
#		To explicitly cause the server to refuse or permit LOAD_DATA_LOCAL statements (regardless of how client programs and libs are configed at build time
# 		or runtime) - start mysqld with local_infile disabled or enabled, respectively.
#
# 		local_infile can also be set at runtime.
#
# lock_wait_timeout
#
# 		Cmd line format: 		--lock-wait-timeout=#
# 		Sys var: 				lock_wait_timeout
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				31536000
# 		Min: 						1
# 		Max: 						31536000
#
# 		Specifies the timeout in seconds for attempts to aquire metadata locks. The permissible value ranges from
# 		1 to 1 year. Default is 1 year.
#
# 		This timeout applies to all statements that use metadata locks. These include DML and DDL operations on tables, views, stored
# 		procedures and stored functions, as well as LOCK_TABLES, FLUSH_TABLES_WITH_READ_LOCK and HANDLER statements.
#
# 		This timeout does not apply to implicit accesses to System tables in the mysql DB, such as grant tables modified by GRANT or REVOKE
# 		statements or table logging statements.
#
# 		This timeout does apply to Sys tables accessed directly, such as with SELECT or UPDATE.
#
# 		The timeout value applies separately for each metadata lock attempt. A given statement can require more than one lock, so it is possible
# 		for the statement to block for longer than the lock_wait_timeout value before reporting a timeout error. When lock timeout occurs, ER_LOCK_WAIT_TIMEOUT
# 		is reported.
#
# 		lock_wait_timeout also defines the amount of time that a LOCK_INSTANCE_FOR_BACKUP statement waits for a lock before giving up.
#
# locked_in_memory
#
# 		sys var: 				locked_in_memory
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 
# 		Whether mysqld was locked in memory with --memlock.
#
# log_error
#
# 		cmd line format: 		--log-error[=file_name]
# 		Sys var: 				log_error
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					File name
#
# 		The default error log destination. If the destination is the console, the value is stderr.
# 		Otherwise, the destination is a file and the log error value is the file name.
#
# log_error_filter_rules
#
# 		cmd line format: 		--log-error-filter-rules
# 		Introduced: 			8.0.2
# 		Removed: 				8.0.4
# 		SYS VAR: 				log_error_filter_rules
# 		Scope: 					Global
#  	Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default value: 		set by server
#
# 		The filter rules for error logging. This variable is unused. Removed.
#
# log_error_services
#
# 		cmd line format: 		--log-error-services
# 		Introduced: 			8.0.2
# 		Sys var: 				log_error_services
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				log_filter_internal; log_sink_internal
#
# 		The components to enable for error logging. This variable may contain a list with 0,1 or many elements.
#
# 		In the latter case, elements may be delimited by ; or (MySQL >= 8.0.12) , + SPACE.
#
# 		A given setting cannot use both ; and , +´SPACE separators.
#
# 		Components order is significant because the server executes components in the order listed.
# 		Any loadable (not built in) component named in the log_error_services value must first be installed
# 		with INSTALL_COMPONENT.
#
# log_error_suppression_list
#
# 		Cmd line format: 		--log-error-suppression-list=value
# 		Introduced: 			8.0.13
# 		Sys var: 				log_error_suppression_list
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				''
#
# 		This enables specifying which diagnostics should not be written to the error log when they occur
# 		with a severity of WARNING or INFORMATION.
#
# 		For example, if a particular type of warning occurs frequently but is not of interest (and thus may be
# 		considered undesirable "noise" in the error log) you can suppress that.
#
# 		The variable value may be empty string for no suppression, or a list of one or more comma separated values indicating
# 		the error codes to suppress.
#
# 		The numeric value of each code to be suppressed must be in a permitted range:
#
# 			1 up to (but less than) 1000: Global error codes that are shared by the server and clients
#
# 			10000 and higher: Server error codes intended to be written ot the error log (not sent to clients)
#
# 		Attempts to assign an error code not in a permitted range produces an error and the var value remains unchanged.
#
# 		Error codes may be specified in a numeric or symbolic form. A numeric code may be specified with or without the MY- prefix.
#
# 		Leading 0's in the numeric part are not significant. Examples of permitted code format:
#
# 			31
# 			00031
# 			MY-31
# 			MY-00031
# 			ER_SERVER_SHUTDOWN_COMPLETE
#
# 		List of error codes comes later.
#
# 		The server can generate messages for a given error code at different severities, so suppression for a message
# 		associated with an error code listed in log_error_suppression_list depends on its severity.
#
# 		Suppose that hte variable has a value of '10000, 10001, MY-10002'
#
# 		Messages for those codes are not written to the error log if generated with a SEVERITY of WARNING or INFORMATION.
#
# 		Messages generated with a severity of ERROR or SYSTEM are not suppressed and are written to the error log.
#
# 		The effect of log_error_suppression_list combines with that of log_error_verbosity.
#
# 		Consider a server started with these settings:
#
# 		[mysqld]
# 		log_error_verbosity=2 			# error and warning messages only
# 		log_error_suppression_list='10000,10001,MY-10002'
#
# 		In this case, log_error_verbosity discards all messages with INFORMATION severity.
#
# 		Of the remaining messages, log_error_suppression_list discards messages with WARNING severityy
# 		and any of the named error codes.
#
#
# 		NOTE: log_error_verbosity defaults to 2, so its effect on suppression of all INFORMATION messages is by
# 		default as above. You must set it to 3, if you want log_error_suppression_list to affect messages with INFORMATION severity.
#
# 		Example:
#
# 		[mysqld]
#		log_error_verbosity=1 #Error messages only
#
# 		Discards all messages with WARNING and INFORMATION severity.
#
# 		Setting log_error_suppression_list has no effect because all error codes it might suppress
# 		are already discarded due to the log_error_verbosity setting. 	
#
# 		log_error_suppression_list (like log_error_verbosity) affects the log_filter_internal error log filter,
# 		which is on by default.
#
# 		If that filter is turned off, error code suppression does not occur and must be modeled using whatever
# 		filter service is used instead where desired (for example, with individual filter rules when using
# 		log_filter_dragnet).
#
# log_error_verbosity
#
# 		cmd line format: 		--log-error-verbosity=#
# 		Sys var: 				log_error_verbosity
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default (>= 8.0.4) 	2
# 		Default (<= 8.0.3) 	3
# 		Min: 						1
# 		Max: 						#
# 
# 		The verbosity for handling events intended for the error log, as filtered by the log_filter_internal
# 		error log filter component, which is enabled by default.
#
# 		If log_filter_internal is disabled, log_error_verbosity has no effect
#
# 		The following is the verbosity levels:
#
# 		Error messages: 		1
# 		Error and Warnings: 	2
# 		Error, Warning,Info: 3
#
# 		Selected important sys messages about non-error situations are printed to the error log regardless
# 		of the log_error_verbosity value.
#
# 		These messages include startup and shutdown messages, and some significant changes to settings.
#
# 		The effect of log_error_verbosity combines with that of log_error_suppression_list.
#
# log_output
#
# 		Cmd line format: 		--log-output=name
# 		Sys var: 				log_output
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Set
# 		Default: 				File
# 		Valid: 					TABLE, FILE, NONE
#
# 		The destination for general query log and slow query log output.
# 		The value can be a comma-separated list of one or more of the words TABLE (log of tables),
# 		FILE (log to files), or NONE (do not log to tables or files).
#
# 		The default value is FILE. NONE, if present takes precedence over any other specifiers.
#
# 		If the value is NONE log entries are not written even if the logs are enabled.
# 		If the logs are not enabled, no logging occurs even if the value of log_output is not NONE.
#
# log_queries_not_using_indexes
#
# 		cmd line format: 	--log-queries-not-using-indexes
# 		Sys var: 			log_queries_not_using_indexes
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type:    			Boolean
# 		default: 			OFF
#
# 		Whether queries that do not use indexes are logged to the slow query log.
#
# log_slow_admin_statements
#
# 		Sys var: 			log_slow_admin_statements
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Boolean
# 		Default: 			OFF
#
# 		Include slow administrative statements in the statements written to the slow query log.
#
# 		Administrative statements include ALTER_TABLE, ANALYZE_TABLE, CHECK_TABLE, CREATE_INDEX,
# 		DROP_INDEX, OPTIMIZE_TABLE and REPAIR_TABLE
#
# log_syslog
#
# 		cmd line format: 		--log-syslog[={0|1}]
# 		Deprecated: 			8.0.2 (removed in 8.0.13)
# 		Sys var: 				log_syslog
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default (Windows, <= 8.0.1) 	ON
# 		Default (Unix, <= 8.0.1) 		OFF
# 		Default (>= 8.0.2) 				ON (when error logging to system log is enabled)
#
# 		Prior to (8.0) this var controlled whether to perform error logging to the system log (the Event log on Windows, Syslog on Unix/UNIX based systems)
#
# 		In MySQL 8.0, the log_sink_syseventlog log component implements error logging to the system log.
# 		Thus this type of logging can be enabled by adding that component to the log_error_services SYS var.
#
# 		log_syslog is removed. (just deprecated before 8.0.13)
#
# log_syslog_facility
#
# 		cmd line format: 		--log-syslog-facility=value
# 		Removed: 				8.0.13
# 		Sys var: 				log_syslog_facility
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				daemon
#
# 		This var was removed in 8.0.13 and replaced by syseventlog.facility
#
# log_syslog_include_pid
#
# 		cmd line format: 		--log-syslog-include-pid[={0|1}]
# 		removed: 				8.0.13
# 		Sys var: 				log_syslog_include_pid
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		This was removed in 8.0.13 and replaced by syseventlog.include_pid
#
# log_syslog_tag
#
# 		cmd line format: 		--log-syslog-tag=tag
# 		Removed: 				8.0.13
# 		Sys var: 				log_syslog_tag
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					String
# 		Default: 				empty string
#
# 		Removed in 8.0.13 and replaced by syseventlog.tag
#
# log_timestamps
#
# 		cmd line format: 		--log-timestamps=#
# 		Sys var: 				log_timestamps
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				UTC
# 		Valid: 					UTC, SYSTEM
#
# 		Controls the time zone of timestamps in messages written to the error log and in general query log and slow query
# 		log messages written to files.
#
# 		Does not affect the time zone of general query log and slow query log messages written to tables (mysql.general_log, mysql.slow_log).
#
# 		Rows retrieved from those tables can be converted from the local system time zone to any desired time zone with CONVERT_TZ() or by
# 		setting the session time_zone sys var.
#
# 		Permitted log_timestamps values are UTC (default) and SYSTEM (local system time zone)
#
# 		Timestamps are written using ISO 8601 / RFC 3339 format: YYYY-MM-DDThh:mm:ss.uuuuu plus a tail value of Z signifying
# 		Zulu time (UTC) or +hh:mm (offset from UTC)
#
# log_throttle_queries_not_using_indexes
#
# 		Sys var: 			log_throttle_queries_not_using_indexes
# 		Scope: 				Global
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Integer
# 		Default: 			0
#
# 		If log_queries_not_using_indexes is enabled, the log_throttle_queries_not_using_indexes variable
# 		limits the number of such queries per minute that can be written to the slow query log.
#
# 		A value of 0 (default) means "No limit".
#
# log_warnings
#
# 		cmd line format: 		--log-warnings[=#]
# 		Deprecated: 			Yes (removed in 8.0.3)
# 		Sys var: 				log_warnings
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				2
# 		Min: 						0
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		Removed in 8.0.3 - use the log_error_verbosity sys_var instead.
#
# long_query_time
#
# 		cmd line format: 		--long-query-time=#
# 		Sys var: 				long_query_time
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Numeric
# 		Default: 				10
# 		Min: 						0
#
# 		If a query takes longer than this many seconds, the server increments the Slow_queries status var.
# 		If the slow query log is enabled, the query is logged to the slow query log file.
#
# 		This value is measured in real time, not CPU time - so a query that is under Threshold on a lightly loaded
# 		system may be above Threshold on a heavy loaded one.
#
# 		The value of this var can be specified to a resolution of microseconds.
#
# 		For logging to tables, only integer times are written; the microseconds part is ignored.
#
# low_priority_updates
#
# 		cmd line format: 		--low-priority-updates
# 		Sys var: 				low_priority_updates
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		If set to 1, all INSERT, UPDATE, DELETE and LOCK TABLE WRITE statements wait until there is no pending
# 		SELECT or LOCK TABLE READ on the affected table.
#
# 		This affects only storage engines that use only table-level locking (such as MyISAM, MEMORY and MERGE)
#
# lower_case_file_system
#
# 		Sys var: 				lower_case_file_system
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
#
# 		This var describes the case sensitivity of file names on the file system where the data dir
# 		is located.
#
# 		OFF means file names are case-sensitive, ON means they are not case-sensitive.
#
# 		This var is read only because it reflects a file system attribute and setting it would have
# 		no effect on the file system.
#
# lower_case_table_names
#
# 		cmd line format: 		--lower-case-table-names[=#]
# 		Sys var: 				lower_case_table_names
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max: 						2
#
# 		If set to 0, table names are stored as specified and comparisons are case-sensitive.
#
# 		If set to 1, table names are stored in lowercase on disk and comparisons are not case sensitive.
#
# 		If set to 2, table names are stored as given but compared in lowercase.
#
# 		This option also applies to DB names and table aliases. 
#
# 		On Windows the default is 1. On macOS, default is 2. On Linux, 2 is not supported - enforced 0.
#
# 		You should NOT set lower_case_table_names to 0 if you are running MySQL on a system where the data dir
# 		resides on a case-insensitive file system (such as on Windows or macOS).
#
# 		Is an unsupported combination that could result in a hang condition when running an INSERT INTO ... SELECT ... FROM <tbl_name>
# 		operation with the wrong <tbl_name> letter case.
#
# 		With MyISAM - accessing table names using different letter cases could cause index corruption.
#
# 		An error message is printed and the server exits if you attempt to start the server with --lower_case_table_names=0 on
# 		a case-insensitive file system.
#
# 		If you are using InnoDB tables, you should set this variable to 1 on all platforms to force names to be converted
# 		to lowercase.
#
# 		The setting of this variable in MySQL 8.0 affects the behavior of replication filtering options with regard
# 		to case sensitivity. (Bug #51639)
#
# 		It is prohibited to start the server with a lower_case_table_names setting that is different from the setting used
# 		when the server was initialized.
#
# 		The restriction is necessary because collations used by various data dictionary table fields are based on the
#	 	setting defined when the server is initialized and restarting the server with a different setting would
# 		introduce inconsistencies with respect to how identifiers are ordered and compared.
#
# mandatory_roles
#
# 		cmd line format: 				--mandatory-roles=value
# 		introduced: 					8.0.2
# 		Sys var: 						mandatory_roles
# 		Scope: 							Global
# 		Dynamic: 						Yes
# 		SET_VAR Hint: 					No
# 		Type: 							String
# 		Default: 						empty string
#
# 		Roles the server should treat as mandatory. In effect, these roles are automatically
# 		granted to every user, although setting mandatory_roles does not actually change any
# 		user accounts, and the granted roles are not visible in the mysql.role_edges system table.
#
# 		The var value is a comma separated name:
#
# 		SET PERSIST mandatory_roles = '`role1`@`%`, `role2`,role3,role4@localhost';
#
# 		Setting mandatory_roles requires the ROLE_ADMIN priv, in addition to the SYSTEM_VARIABLES_ADMIN or SUPER
# 		priv normally required to set a global system var.
#
# 		Role names consist of a user part and host part in user_name@host_name format.
# 		The host part, if omitted, defaults to %
#
# 		User names and host names, if quoted, must be written in a fashion permitted for quoting within quoted strings.
#
# 		Roles named in the value of mandatory_roles cannot be revoked with REVOKE or dropped with DROP_ROLE or DROP_USER.
#
# 		Mandatory roles, like explicitly granted roles, do not take effect until activated.
#
# 		At login time, role activation occurs for all granted roles if the activate_all_roles_on_login sys_var is enabled,
# 		or only for roles that are set as default roles otherwise.
#
# 		At runtime, SET_ROLE activates roles.
#
# 		Roles that do not exist when assigned to mandatory_roles but are created later may require special treatment
# 		to be considered mandatory.
#
# 		SHOW_GRANTS displays mandatory roles according to the rules showcased later.
#
# max_allowed_packet
#
# 		cmd line format: 		--max-allowed-packet=#
# 		Sys var: 				max_allowed_packet
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default (>= 8.0.3) 	67108864
# 		Default (<= 8.0.2) 	4194304
# 		Min: 						1024
# 		Max: 						1073741824
#
# 		Max size of one packet or any generated/intermediate string or any parameter sent by the mysql_stmt_send_long_data() C API function.
# 		The default is 64MB.
#
# 		The packet message buffer is initialized to net_buffer_length bytes, but can grow up to max_allowed_packet bytes when needed.
# 		This value by default is small, to catch large (possibly incorrect) packets.
#
# 		You must increase this value if you are using large BLOB columns or long strings.
# 		It should be as big as the largest BLOB you want to use.
#
# 		The protocol limit for max_allowed_packet is 1GB. The value should be a multiple of 1024: nonmultiples are rounded down to the nearest
# 		multiple.
#
# 		When you change the message buffer size by changing the value of the max_allowed_packet variable, you should also change
# 		the buffer size on the client side if your client program permits it.
#
# 		The default max_allowed_packet value built in to the client library is 1GB, but individual client programs
# 		might override this.
#
# 		For example, mysql and mysqldump have defaults of 16MB and 24MB, respectively.
#
# 		They also enable you to change the client-side value by setting max_allowed_packet on the cmd line or in an option file.
#
# 		The session value of this var is read only. The client can receive up to as many bytes as the session value.
# 		However, the server will not send to the client more bytes than the current global max_allowed_packet value.
# 		(The global value could be less than the session value if the global value is changed after the client connects.)
#
# max_connect_errors
#
# 		cmd line format: 		--max-connect-errors=#
# 		Sys var: 				max_connect_errors
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				100
# 		Min: 						1
# 		Max (64-bit) 			<a lot>
# 		max (32-bit) 			<less>
#
# 		If more than this many successive connection requests from a host are interuppted without a successful
# 		connection, the server blocks that host from further connections.
#
# 		You can unblock blocked hosts by flushing the host cache. To do so, issue a FLUSH_HOSTS statement or execute
# 		a mysqladmin flush-hosts command.
#
# 		If a connection is established successfully within fewer than max_connect_errors attempts after a previous connection
# 		was interrupted, the error count for the host is cleared to 0.
#
# 		However, once a host is blocked, flushing the host cache is the only way to unblock it. Default is 100.
#
# max_connections
#
# 		Cmd line format: 		--max-connections=#
# 		Sys var: 				max_connections
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				151
# 		Min: 						1
# 		Max: 						100000
#
# 		max permitted number of simultaneous client conns.
#
# max_delayed_threads
#
# 		cmd line format: 		--max-delayed-threads=#
# 		deprecated: 			Yes
# 		Sys var: 				max_delayed_threads
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				20
# 		Min: 						0
# 		Max: 						16384
#
# 		This sys var is deprecated (because DELAYED inserts are not supported), will be removed.
#
# max_digest_length
#
# 		cmd line format: 		--max-digest-length=#
# 		Sys var: 				max_digest_length
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1024
# 		Min: 						0
# 		Max: 						1048576
#
# 		max number of bytes available for computing normalized statement digests.
#
# 		Once said amount of space is used during digest computation, truncation occurs:
# 		No further tokens from a parsed statement are collected or figure into its digest value.
#
# 		Statements that differ only after that many bytes of parsed tokens produce the same 
# 		normalized statement digest and are considered identical if compared or if aggregated for digest stats.
#
# 		Decreasing the max_digest_length value reduces memory use but causes the digest value of more statements
# 		to become indistinguishable if they differ only at the end.
#
# 		Increasing the value permits longer statements to be distinguished but increases memory use, particularly
# 		for workloads that involve large number of simultaneous sessions (the server allocates max_digest_length bytes per session)
#
# 		The parser uses this system var as a limit on the max length of normalized statement digests that it computes.
# 		The Performance Schema, if it tracks statement digests, makes a copy of the digest value, using the performance_schema_max_digest_length,
# 		sys var as a limit on the max length of digests that it stores.
#
# 		Consequently, if performance_schema_max_digest_length is less than max_digest_length digest values stored in the Performance
# 		Schema are truncated relative to the original digest values.
#
# max_error_count
#
# 		cmd line format: 		--max-error-count=#
# 		Sys var: 				max_error_count
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default (>= 8.0.3) 	1024
# 		Default (<= 8.0.2) 	64
# 		Min: 						0
# 		Max: 						65535
#
# 		Max number of error, warning and info messages to be stored for display by the SHOW_ERRORS and SHOW_WARNINGS statements.
# 		This is the same as the number of condition areas in the diagnostics area, and thus the number of conditions that can be
# 		inspected by GET_DIAGNOSTICS.
#
# max_execution_time
#
# 		cmd line format: 		--max-execution-time=#
# 		Sys var: 				max_execution_time
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				0
#
# 		The execution timeout for SELECT statements, in milliseconds.
# 		If the value is 0, timeouts are not enabled.
#
# 		max_execution_time applies as follows:
#
# 			The global max_execution_time value provides the default for the session value for new connections.
# 			The session value applies to SELECT executions executed within the session that include no MAX_EXECUTION_TIME(N)
# 			optimizer hint or for which N is 0.
#
# 			max_execution_time applies to read-only SELECT statements. Statements that are not read only are those that 
# 			invoke a stored function that modifies data as a side effect.
#
# 			max_execution_time is ignored for SELECT statements in stored programs.
#
# max_heap_table_size
#
# 		cmd line format: 		--max-heap-table-size=#
# 		Sys var: 				max_heap_table_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					16777216
# 		Min value: 				16384
# 		Max value (64-bit) 	<a lot>
# 		Max value (32-bit) 	<less>
#
# 		Sets the maximum size to which user-created MEMORY tables are permitted to grow.
# 		The value of the variable is used to calculate MEMORY table MAX_ROWS values.
#
# 		Setting this variable has no effect on any existing MEMORY table, unless the table is
# 		re-created with a statement such as CREATE_TABLE or altered with ALTER_TABLE or TRUNCATE_TABLE
#
# 		A server restart also sets the maximum size of existing MEMORY tables to the global max_heap_table_size 
#
# 		This var is also used in conjunction with tmp_table_size to limit the size of internal in-memory tables.
#
# 		max_heap_table_size is not replicated.
#
# max_insert_delayed_threads
#
# 		deprecated: 			Yes
# 		Sys var: 				max_insert_delayed_threads
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
#
# 		Synonym to max_delayed_threads
#
# 		Deprecated because DELAYED inserts are not supported.
#
# max_join_size
#
# 		cmd line format: 		--max-join-size=#
# 		Sys var: 				max_join_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				<a lot>
# 		Min: 						1
# 		Max: 						<a lot>
# 
# 		Do not permit statements that probably need to exaime more than max_join_size rows (for single-table statements)
# 		or row combinations (for multiple-table statements) or that are likely to do more than max_join_size disk seeks.
#
# 		By setting this value, you can catch statements where keys are not used properly and that would probably take a long time.
# 		Set this if you use to perform joins that lack a WHERE clause, that take a long time or return more than millions of rows.
#
# 		Setting this var to other than DEFAULT resets the value of sql_big_selects to 0.
#
# 		If you set the sql_big_selects value again, the max_join_size var is ignored.
#
# max_length_for_sort_data
#
# 		Cmd line format: 		--max-length-for-sort-data=#
# 		Sys var: 				max_length_for_sort_data
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		DEFAULT (>= 8.0.1) 	4096
# 		Default (8.0.0) 		1024
# 		Min: 						4
# 		Max: 						<max>
#
# 		The cutoff on the size of index values that determines which filesort algo to use.
#
# max_points_in_geometry
#
# 		cmd line format: 		--max-points-in-geometry=integer
# 		Sys var: 				max_points_in_geometry
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				65536
# 		Min: 						3
# 		Max: 						1048576
#
# 		Max value of the points_per_circle argument to the ST_BUFFER_Strategy() function
#
# max_prepared_stmt_count
#
# 		cmd line format: 		--max-prepared-stmt-count=#
# 		Sys var: 				max_prepared_stmt_count
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				16382
# 		Min: 						0
# 		Max: 						1048576
#
# 		This variable limits the total number of prepared statements in the server.
#
# 		It can be used in environments where there is the potentional for denial-of-service attacks
# 		based on running the server out of memory by preparing huge number of statements.
#
# 		If the value is set lower than the current number of prepared statements, existing statements are not
# 		affected and can be used, but no new statements can be prepared until the current number drops below the limit.
#
# 		
# max_seeks_for_key
#
# 		cmd line format: 		--max-seeks-for-key=#
# 		Sys Var: 				max_seeks_for_key
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default (64-bit) 		<a lot>
# 		Default (32-bit) 		<less>
# 		min: 						1
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		Limit the assumed max number of seeks when looking up rows based on a key.
# 		The MySQL optimizer assumes that no more than this number of key seeks are
# 		required when searching for matching rows in a table by scanning an index, regardless
# 		of the actual cardinality of the index.
#
# 		By setting it to a low value, for instance 100 - you can force MySQL to prefer indexes
# 		instead of table scans.
#
# max_sort_length
#
# 		cmd line format: 		--max-sort-length=#
# 		Sys var: 				max_sort_length
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				1024
# 		Min: 						4
# 		Max: 						<a lot>
#
# 		The number of bytes to use when sorting data values. The server uses only the first max_sort_length
# 		bytes of each value and ignore the rest.
#
# 		Consequently, values that differ only after the first max_sort_length bytes compare as equal for
# 		GROUP BY, ORDER BY and DISTINCT operations.
#
# 		Increasing this may require increasing the value of sort_buffer_size as well.
#
# max_sp_recursion_depth
#
# 		cmd line format: 		--max-sp-recursion-depth[=#]
# 		Sys var: 				max_sp_recursion_depth
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Max: 						255
#
# 		The number of times that any given stored procedure may be called recursively.
# 		The default value for this option is 0, which completely disables recursion in stored
# 		procedures.
#
# 		Max is 255.
#
# 		Stored procedure recursion increases the demand on thread stack space.
#
# 		If you increase the value of max_sp_recursion_depth, it may be necessary 
# 		to increase thread stack size by increasing the value of thread_stack at server startup.
#
# max_tmp_tables
#
# 		REMOVED 
#
# max_user_connections
#
# 		cmd line format: 		--max-user-connections=#
# 		Sys var: 				max_user_connections
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max: 						4294967295
#
# 		The max number of simultaneous connections permitted to any given MySQL user account.
# 		A value of 0 (the default) means "No limit".
#
# 		This variable has a global value that can be set at server startup or runtime.
#
# 		It also has a read-only session value that indicates the effective simultaneous-connection
# 		limit that applies to the account associated with the current session. The session value is initalized as
# 		follows: 				
#
# 		If the user account has a nonzero MAX_USER_CONNECTIONS resource limit, the session max_user_connections is set to that limit.
#
# 		Otherwise, the session max_user_connections session value is set to the global value.
#
# 		Account resource limits are specified, using the CREATE_USER or ALTER_USER statement.
#
# max_write_lock_count
#
# 		cmd line format: 		--max-write-lock-count=#
#  	Sys var: 				max_write_lock_count
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default (64-bit) 		<a lot>
# 		Default (32-bit) 		<less>
# 		Min: 						1
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		After this many write locks, permit some pending read lock requests
# 		to be processed in between.
#
# mecab_rc_file
#
# 		cmd line format: 		--mecab-rc-file
# 		Sys var: 				mecab_rc_file
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Dir name
#
# 		The mecab_rc_file option is used when setting up the MeCab full-text parser.
#
# 		The mecab_rc_file option defines the path to the mecabrc configuration file, which is the configuration
# 		file for MeCab. The option is read-only and can only be set at startup.
#
# 		The mecabrc configuration file is required to initialize MeCab.
#
# metadata_locks_cache_size
#
# 		deprecated: 			Yes (removed in 8.0.13)
# 		Sys var: 				metadata_locks_cache_size
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1024
# 		Min: 						1
# 		Max: 						A LOT
#
# 		REMOVED in 8.0.13
#
# metadata_locks_hash_instances
#
# 		DeprecateD: 			Yes (removed in 8.0.13)
# 		Sys var: 				metadata_locks_hash_instances
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				8
# 		Min: 						1
# 		Max: 						1024
#
# 		Removed in 8.0.13
#
# min_examined_row_limit
#
# 		cmd line format: 		--min-examined-row-limit=#
# 		Sys Var: 				min_examined_row_limit
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max (64-bit): 			<a lot>
# 		Max (32-bit): 			<less>
#
# 		Queries that examine fewer than this number of rows are not logged to the slow query log.
#
# multi_range_count
#
# 		cmd line format: 		--multi-range-count=#
# 		Deprecated: 			Yes (Removed in 8.0.3)
# 		Sys var: 				multi_range_count
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				256
# 		Min: 						1
# 		Max: 						<a lot>
#
# 		Removed in 8.0.3
#
# myisam_data_pointer_size
#
# 		cmd line format: 		--myisam-data-pointer-size=#
# 		Sys var: 				myisam_data_pointer_size
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				6
# 		Min: 						2
# 		Max: 						7
#
# 		Default point size in bytes, to be used by CREATE TABLE for MyISAM tables when no MAX_ROWS
# 		option is specified.
#
# 		This variable cannot be less than 2 or larger than 7. Default to 6.
#
# myisam_max_sort_file_size
#
# 		cmd line formT: 		--myisam-max-sort-file-size=#
# 		SYS var: 				myisam_max_sort_file_size
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					integer
# 		Default (64-bit) 		<a lot>
# 		Default (32-bit) 		<less>
#
# 		The max size of the temp file that MySQL is permitted to use while re-creating a MyISAM index
# 		(during REPAIR_TABLE, ALTER_TABLE, or LOAD_DATA_INFILE)
#
# 		If the file size would be larger than this value, the index is created using the key cache instead
# 		, which is slower. Given in bytes.
#
# 		If MyISAM index files exceed the size and disk space available, increasing the value may help performance.
# 		The space must be available in the file system containing the dir where the original index file is located.
#
# myisam_mmap_size
#
# 		cmd line format: 		--myisam-mmap-size=#
# 		Sys var: 				myisam_mmap_size
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default (64-bit) 		<a lot>
# 		Default (32-bit) 		<less>
# 		Min: 						7
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		The max amount of memory to use for memory mapping compressed MyISAM files.
# 		If many compressed MyISAM tables are used, the value can be decreased to reduce
# 		the likelihood of memory-swapping problems.
#
# myisam_recover_options
#
# 		Sys_var: 				myisam_recover_options
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
#
# 		The value of the --myisam-recover-options option
#
# myisam_repair_threads
#
# 		Cmd line format: 		--myisam-repair-threads=#
# 		Sys var: 				myisam_repair_threads
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1
# 		Min: 						1
# 		Max value (64-bit) 	<a lot>
# 		Max value (32-bit) 	<less>
#
# 		If greater than 1, MyISAM table indexes are created in parallel (each index in its own thread)
# 		during the Repair by sorting process.
#
# 		Multithread repair is still in beta.
#
# myisam_sort_buffer_size
#
# 		cmd line format: 		--myisam-sort-buffer-size=#
# 		Sys Var: 				myisam_sort_buffer_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				8388608
# 		Min: 						4096
# 		Max (other, 64-bit) 	<a lot>
# 		Max (other, 32-bit) 	<less>
# 		Max (windows, 64-bit)<a lot>
# 		Max (Windows, 32-bit)<less>
#
# 		The size of the buffer that is allocated when sorting MyISAM indexes during a REPAIR_TABLE
# 		or when creating indexes with CREATE_INDEX or ALTER_TABLE
#
# myisam_stats_method
#
# 		Cmd line format: 		--myisam-stats-method=name
# 		Sys var: 				myisam_stats_method
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Enumeration
# 		Default: 				nulls_unequal
# 		Valid: 					nulls_equal, nulls_unequal, nulls_ignored
#
# 		How the server treats NULL values when collecting statistics about the distribution of index values for MyISAM tables.
# 		
# 		nulls_equal - All NULL index values are considered equal and form a single value group that has a size equal to number of NULL values.
# 		nulls_unequal - NULL values are considered unequal, and each NULL forms a distinct group value of size 1.
# 		nulls_ignored - NULL values are ignored.
#
# 		The method that is used for generating table stats influences how the optimizer chooses indexes for query execution
#
# myisam_use_mmap
#
# 		cmd line format: 		--myisam-use-mmap
# 		Sys var: 				myisam_use_mmap
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Use memory mapping for reading and writing MyISAM tables.
#
# mysql_native_password_proxy_users
#
# 		cmd line format: 		--mysql-native-password-proxy-users=[={OFF|ON}]
# 		Sys var: 				mysql_native_password_proxy_users
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Controls whether the mysql_native_password built-in authentication plugin supports
# 		proxy users. It has no effect unless the check_proxy_users SYS_VAR is on.
#
# named_pipe
#
# 		Sys var: 			named_pipe
# 		Scope: 				global
# 		Dynamic: 			No
# 		SET_VAR Hint: 		No
# 		Platform: 			Windows
# 		Type: 				Boolean
# 		Default: 			OFF
#
# 		Indicates whether the server supports connections over named pipes.
#
# net_buffer_length
#
# 		cmd line format: 		--net-buffer-length=#
# 		Sys var: 				net_buffer_length
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				16384
# 		Min: 						1024
# 		Max: 						1048576
#
# 		Each client thread is associated with a connection buffer and a result buffer.
#
# 		Both begin with a size given by net_buffer_length but are dynamically enlarged up to
# 		max_allowed_packet bytes as needed.
#
# 		The result buffer shrinks to net_buffer_length after each SQL statement.
#
# 		This var should not normally be changed, but in case of having very small amounts of memory,
# 		you can set it to the expected length of statements sent by clients.
#
# 		If statements exceed this length, the connection buffer is automatically enlarged.
# 		The max value to which net_buffer_length can be set is 1MB.
#
# 		Session value of this is read only.
#
# net_read_timeout
#
# 		Cmd line format: 		--net-read-timeout=#
# 		Sys var: 				net_read_timeout
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				30
# 		Min: 						1
#
# 		The number of seconds to wait for more data from a connection before aborting the read.
#
# 		When the server is reading from the client, net_read_timeout is the timeout value controlling
# 		when to abort.
#
# 		When the server is writing to the client, net_write_timeout is the timeout value controlling when to
# 		abort.
#
# 		See also slave_net_timeout
#
# net_retry_count
#
# 		cmd line format: 		--net-retry-count=#
# 		Sys var: 				net_retry_count
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				10
# 		Min: 						1
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		If a read or write on a communication port is interuppted, retry this many times before giving up.
#
# 		This should be set pretty high on FreeBSD because internal interuppts are sent to all threads.
#
# net_write_timeout
#
# 		cmd line format: 		--net-write-timeout=#
# 		Sys var: 				net_write_timeout
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				60
# 		Min: 						1
#
# 		Number of seconds to wait for a block to be written to a connection before aborting the write.
# 		(See also net_read_timeout)
# 
# new
#
# 		cmd line format: 		--new
# 		Sys var: 				new
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Disabled by: 			skip-new
# 		Type: 					Boolean
# 		Default: 				FALSE
#
# 		Used in 4.0 to turn on some 4.1 behaviors, retained for backwards comp. always off.
#
# ngram_token_size
#
# 		cmd line format: 		--ngram-token-size
# 		Sys var: 				ngram_token_size
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				2
# 		Min: 						1
# 		Max: 						10
#
# 		Defines the n-gram token size for the n-gram full-text parser.
# 		The ngram_token_size option is read-only and can only be modified at startup.
#
# offline_mode
#
# 		cmd line format: 		--offline-mode=val
# 		Sys Var: 				offline_mode
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Whether the server is in "offline mode", which has these characteristics:
#
# 			Connected client users who do not have the CONNECTION_ADMIN or SUPER privs are disconnected on the next request,
# 			with an appropiate error.
#
# 			Disconnection includes terminating running statements and releasing locks. Such clients also cannot initiate new connections,
# 			and receive an appropiate error.
#
# 			Connected client users who have the CONNECTION_ADMIN or SUPER privs are not disconnected, and can initiate new connections to
# 			manage the server.
#
# 			Replication slave threads are permitted to keep applying data to the server.
#
# 		Only users who have the SYSTEM_VARIABLES_ADMIN or SUPER priv can control offline mode.
#
# 		To put a server in offline mode, change the value of the offline_mode SYS_VAR from OFF to ON.
#
# 		To resume normal ops, change offline_mode from ON to OFF. In offline mode, clients that are 
# 		refused access receive an ER_SERVER_OFFLINE_MODE error.
#
# old
#
# 		cmd line format: 		--old
# 		Sys_var: 				old_alter_table
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		old is a compability var. Disabled by default, but can be enabled at startup to revert the server to behaviors present in older verisons.
#
# 		When old is enabled, it changes the default scope of index hints to that used prior to MySQL 5.1.17.
#
# 		That is, index hints with no FOR clause apply only to how indexes are used for retrieval and not to resolution
# 		of ORDER BY or GROUP BY clauses.
#
# 		Take care about enabling this in a replication setup.
#
# 		With statement-based binary logging, having different modes for master and slave - might lead to replication errors.
#
# old_alter_table
#
# 		Cmd line format: 		--old-alter-table
# 		Sys var: 				old_alter_table
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		When this variable is enabled, the server does not use optimized method of processing an ALTER_TABLE operation.
# 		It reverts to using a temporary table, copying over the data and then renaming the temporary table to the original,
# 		as used by MySQL 5.0 and earlier.
#
# 		ALTER TABLE ... DROP PARTITION with old_alter_table=ON rebuilds the partitioned table and attempts to move data
# 		from the dropped partition to another partition with a compatible PARTITION ... VALUES def.
#
# 		Data that cannot be moved to another partition is deleted. In earlier releases, ALTER TABLE ... DROP PARTITION 
# 		with old_alter_table=ON deletes data stored in the partition and drops the partition.
#
# old_passwords
#
# 		Deprecated: 		Yes (removed in 8.0.11)
# 		Sys var: 			old_passwords
# 		Scope: 				Global, Session
# 		Dynamic: 			Yes
# 		SET_VAR Hint: 		No
# 		Type: 				Enumeration
# 		Default: 			0
# 		Valid: 				0, 2
#
# 		REMOVED in 8.0.11
#
# open_files_limit
#
# 		Cmd line format: 		--open-files-limit=#
# 		Sys var: 				open_files_limit
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				5000, with possible adjustment
# 		Min: 						0
# 		Max: 						platform dependent
#
# 		The number of files that the OS permits mysqld to open.
#
# 		The value of this variable at runtime is the real value permitted by the system and might
# 		be different from the value you specify at server startup.
#
# 		The value is 0 on systems where MySQL cannot change the number of open files.
#
# 		The effective open_files_limit value is based on the value specified at system startup (if any) and the values
# 		of max_connections and table_open_cache using the following:
#
# 		1) 10 + max_connections + (table_open_cache * 2)
# 		2) max_connections + 5
# 		3) OS limit if +
# 		4) if OS limit is INF 
# 			open_files_limit value specified at startup, 5000 if None
#
# 		The server bases it's max on the max of the above three - If that many cannot be obtained,
# 		the server attempts to obtain as many as the system will permit.
#
# optimizer_prune_level
#
# 		cmd line format: 		--optimizer-prune-level[=#]
# 		Sys var: 				optimizer_prune_level
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Boolean
# 		Default: 				1
#
# 		Controls the heuristic applied during query optimization to prune less-promising
# 		partial plans from the optimizer search space.
#
# 		A value of 0 disables heuristics so that the optimizer performs an exhaustive search.
# 		A value of 1 causes the optimizer to prune plans based on the number of rows retrieved by intermediate plans.
#
# optimizer_search_depth
#
# 		cmd line format: 		--optimizer-search-depth[=#]
# 		Sys_var: 				optimizer_search_depth
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				62
# 		Min: 						0
# 		Max: 						62
#
# 		The max depth of search performed by the query optimizer. Values larger than
# 		the number of relations in a query result in better query plans, but take longer
# 		to generate an execution plan for a query.
#
# 		Values smaller than the number of relations in a query return an execution plan
# 		quicker, but the resulting plan may be far from being optimal.
#
# 		If set to 0, the system automatically picks a reasonable value.
#
# optimizer_switch
#
# 		cmd line format: 		--optimizer-switch=value
# 		Sys_var: 				optimizer_switch
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Set
# 		Valid (>= 8.0.13) 	batched_key_access={on|off}
# 									block_nested_loop={on|off}
# 									condition_fanout_filter={on|off}
#									derived_merge={on|off}
# 									duplicateweedout={on|off}
#
# 									engine_condition_pushdown={on|off}
# 									firstmatch={on|off}
# 									index_condition_pushdown{on|off}
# 									index_merge={on|off}
# 									index_merge_intersection={on|off}
# 									index_merge_union={on|off}
# 									loosescan={on|off}
# 									materialization={on|off}
#
# 									mrr={on|off}
# 									mrr_cost_based={on|off}
# 									semijoin={on|off}
# 									skip_scan={on|off}
# 									subquery_materialization_cost_based={on|off}
# 									use_index_extensions={on|off}
# 									use_invisible_indexes={on|off}
#
# 		Valid (>= 8.0.3, <= 8.0.12)
#
# 									batched_key_access={on|off}
# 									block_nested_loop={on|off}
# 									condition_fanout_filter={on|off}
# 									derived_merge={on|off}
# 									duplicateweedout={on|off}
# 									engine_condition_pushdown={on|off}
# 									firstmatch={on|off}
# 									index_condition_pushdown={on|off}
# 									index_merge={on|off}
# 									index_merge_intersection={on|off}
# 									index_merge_sort_union={on|off}
#
# 									index_merge_union={on|off}
# 									loosescan={on|off}
# 									materialization={on|off}
# 									mrr={on|off}
# 									mrr_cost_based={on|off}
# 									semijoin={on|off}
# 									subquery_materialization_cost_based={on|off}
# 									use_index_extensions={on|off}
# 									use_invisible_indexes={on|off}
#
# 		Valid (<= 8.0.2) 		batched_key_access={on|off}
# 									block_nested_loop={on|off}
# 									condition_fanout_filter={on|off}
# 									derived_merge={on|off}
# 									duplicateweedout={on|off}
# 									engine_condition_pushdown={on|off}
#
# 									firstmatch={on|off}
# 									index_condition_pushdown={on|off}
# 									index_merge={on|off}
# 									index_merge_intersection={on|off}
# 									index_merge_sort_union={on|off}
# 									index_merge_union={on|off}
# 									loosescan={on|off}
# 									materialization={on|off}
# 									mrr={on|off}
# 									mrr_cost_based={on|off}
# 
# 									semijoin={on|off}
# 									subquery_materialization_cost_based={on|off}
# 									use_index_extensions={on|off}
#
# 		The optimizer_switch SYS_VAR enables control over optimizer behavior.
#
# 		The value of this var is a set of flags, each of which has a value of on
# 		or off to indicate whether the corresponding optimizer behavior is enabled or disabled.
#
# 		This variable has global and session values and can be changed at runtime.
#
# 		The global default can be set at server startup.
#
# 		To see the current set of optimizer flags, select the variable value:
#
# 		SELECT @@optimizer_switch\G
# 		***************************** 1. row **********************************
# 		@@optimizer_switch: 	index_merge=on,index_merge_union=on (off if it's off), etc.
#
# optimizer_trace
#
# 		Sys var: 		optimizer_trace
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			String
#
# 		Controls the optimizer tracing.
#
# optimizer_trace_features
#
# 		Sys var: 		optimizer_trace_features
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	no
# 		Type: 			String
#
# 		Enables or disabled selected optimizer tracing features.
#
# optimizer_trace_limit
#
# 		Sys var: 		optimizer_trace_limit
# 		Scope. 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			Integer
# 		Default: 		1
#
# 		Max number of optimizer traces to display.
#
# optimizer_trace_max_mem_size
#
# 		Sys var: 		optimizer_trace_max_mem_size
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	Yes
# 		Type: 			Integer
# 		Default (>= 8.0.4) 1048576
# 		Default (<= 8.0.3) 16384
#
# 		The max cumulative size of stored optimizer traces.
#
# optimizer_trace_offset
#
# 		Sys var: 		optimizer_trace_offset
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			Integer
# 		Default: 		-1
#
# 		The offset of optimizer traces to display.
#
# performance_schema_xxx
#
# 		Performance Schema sys vars, listed later.
# 		Can be used to configure performance schema ops.
#
# parser_max_mem_size
#
# 		cmd line format: 		--parser-max-mem-size=N
# 		Sys var: 				parser_max_mem_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default (64-bit) 		<a lot>
# 		Default (32-bit) 		<less>
# 		Min: 						10000000
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		The max amount of memory available to the parser. 
# 		The default value places no limit on memory available.
# 		
# 		The value can be reduced to protect against out-of-memory situations caused by
# 		parsing long or complex SQL statements.
#
# password_history
#
# 		cmd line format: 		--password-history=#
# 		Introduced: 			8.0.3
# 		Sys var: 				password_history
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max: 						4294967295
#
# 		This variable defines the global policy for controlling reuse of previous passwords based on
# 		required minimum number of password changes.
#
# 		For an account password used previously, this variable indicates the number of subsequent account password
# 		changes that must occur before the password can be used.
#
# 		If the value is 0 (default), there is no reuse restriction based on number of PW changes.
#
# 		Changes to this variable apply immediately to all accounts defined with the PASSWORD HISTORY DEFAULT option.
#
# 		The global number-of-changes password reuse policy can be overridden as desired for individual accounts using
# 		the PASSWORD HISTORY option of the CREATE USER and ALTER USER statements.
#
# password_require_current
#
# 		cmd line format: 		--password-require-current[={OFF|ON}]
# 		Introduced: 			8.0.13
# 		Sys var: 				password_require_current
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		Defines the global policy for controlling whether attempts to change an acc PW must specify the current PW to be replaced.
#
# 		Changes to this var apply immediately to all accounts defined with the PASSWORD REQUIRE CURRENT DEFAULT option.
#
# 		The global verification-required policy can be overriden as desired for individual accounts using the
# 		PASSWORD REQUIRE option of the CREATE_USER and ALTER_USER statements.
#
# password_reuse_interval
#
# 		cmd line format: 		--password-reuse-interval=#
# 		Introduced: 			8.0.3
# 		Sys var: 				password_reuse_interval
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				0
# 		Min: 						0
# 		Max: 						<a lot>
#
# 		This variable defines the global policy for controlling reuse of previous PWs based on time elapsed.
# 		For an account PW used previously, this var indicates the number of days that must pass before the PW can be reused.
#
# 		If the value is 0 (default), there is no reuse restriction based on time elapsed.
#
# 		Changes to this var apply instantly to all accounts defined with the PASSWORD REUSE INTERVAL DEFAULT option.
#
# 		The global time-elapsed PW reuse policy can be overridden as desired for individual accounts using the PASSWORD REUSE INTERVAL
# 		option of the CREATE_USER and ALTER_USER statements.
#
# persisted_globals_load
#
# 		cmd line format: 		--persisted-globals-load[=ON|OFF]
# 		Sys var: 				persisted_globals_load
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				ON
#
# 		Whether to load persisted configuration settings from the mysqld-auto.cnf file in the data dir.
# 		The server normally processes this file at startup after all other option files.
#
# 		Disabling this causes the server startup sequence to skip mysqld-auto.cnf
#
# 		To modify the contents of mysqld-auto.cnf, use the SET_PERSIST, SET_PERSIST_ONLY and
# 		RESET_PERSIST statements.
#
# pid_file
#
# 		cmd line format: 		--pid-file=file_name
# 		Sys var: 				pid_file
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					File name
#
# 		The path name of the process ID file. This var can be set with the --pid-file option.
#
# 		The server creates the file in the data dir unless an absolute path name is given
# 		to specify a different dir.
#
# 		If you specify the --pid-file option, you must specify a value.
#
# 		If you do not specify the --pid-file option, MySQL uses a default
# 		value of <host_name>.pid where <host_name> is the name of the host machine.
#
# 		The process ID file is used by other programs such as mysqld_safe to determine 
# 		the server's process ID.
#
# 		On Windows, this var also affects the default error log file name.
#
# plugin_dir
#
# 		cmd line format: 		--plugin-dir=dir_name
# 		Sys var: 				plugin-dir
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
#  	Type: 					Dir name
# 		Default: 				BASEDIR/lib/plugin
#
# 		Path name of the plugin dir.
#
# 		If the plugin dir is writable by server, it may be possible for a user to write
# 		executable code to a file in the dir using SELECT ... INTO DUMPFILE
#
# 		This can be prevented by making plugin_dir read only to the server or by setting
# 		--secure-file-priv to a dir where SELECT writes can be made safely.
#
# port
#
# 		cmd line format: 		--port=#
# 		Sys var: 				port
# 		Scope: 					Global
# 		Dynamic: 				No
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				3306
# 		Min: 						0
# 		Max: 						65535
#
# 		Number of port on which the server listens for TPC/IP conns.
# 		Can be set with --port
#
# preload_buffer_size
#
# 		cmd line format: 		--preload-buffer-size=#
# 		Sys var: 				preload_buffer_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				32768
# 		Min: 						1024
# 		Max: 						<a lot>
#
# 		Size of the buffer that is allocated when preloading indexes.
#
# profiling
#
# 		If set to 0 or OFF (the default), statement profiling is disabled.
#
# 		If set to 1 or ON, statement profiling is enabled and the SHOW PROFILE
#  	and SHOW PROFILES statements provide access to profiling information.
#
# 		Deprecated.
#
# profiling_history_size
#
# 		Number of statements for which to maintain profiling information if profiling is enabled.
# 		Default is 15.
#
# 		max is 100. Setting this 0 disables profiling.
#
# 		Deprecated.
#
# protocol_version
#
# 		Sys var: 		protocol_version
# 		Scope: 			Global
# 		Dynamic: 		No
# 		SET_VAR Hint: 	No
# 		Type: 			Integer
#
# 		The version of the client/server protocol used by the MySQL server.
#
# proxy_user
#
# 		Sys var: 		proxy_user
# 		scope: 			Session
# 		Dynamic: 		No
# 		SET_VAR Hint: 	No
# 		Type: 			String
#
# 		If the current client is a proxy for another user, this var is the proxy user account name.
# 		Otherwise, this var is NULL.
#
# pseudo_slave_mode
#
# 		Sys var: 		pseudo_slave_mode
# 		Scope: 			Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			Integer
#
# 		This var is used for internal server use.
#
# 		AS of MySQL 8.0.14, setting the session value of this sys var is a restricted ops.
#
# 		The session user must have the privs to set it.
#
# 		In MysQL >= 8.0.14 - pseudo_slave_mode has the following effects on the handling of a statement that
# 		sets one or more unsupported or unknown SQL modes:
#
# 			If true - the server ignores the unsupported mode and raises a warning
#
# 			If false - the server rejects the statement with ER_UNSUPPORTED_SQL_MODE
#
# 		mysqlbinlog sets this var to true prior to executing any other SQL.
#
# pseudo_thread_id
#
# 		Sys var: 		pseudo_thread_id
# 		Scope: 			Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			Integer
#
# 		Used for internal server use
#
# 		Setting this is a restricted ops, must have privs
#
# query_alloc_block_size
#
# 		Cmd line format: 		--query-alloc-block-size=#
# 		Sys var: 				query_alloc_block_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				8192
# 		Min: 						1024
# 		Max: 						<a lot>
# 		Block size: 			1024
#
# 		The allocation size of memory blocks that are allocated for objects created during statement parsing
# 		and execution. 
#
# 		If you have problems with memory fragmentation, it might help to increase this param.
# 		
# query_cache_limit
#
# 		Cmd line format: 		--query-cache-limit=#
# 		DeprecateD: 			Yes (removed in 8.0.3)
# 		Sys var: 				query_cache_limit
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				1048576
# 		Min: 						0
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		REMOVED in 8.0.3
#
# query_cache_min_res_unit
#
# 		Cmd line format: 		--query-cache-min-res-unit=#
# 		Deprecated: 			Yes (Removed in 8.0.3)
# 		Sys var: 				query_cache_min_res_unit
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					integer
# 		Default: 				4096
# 		Min: 						512
# 		Max (64-bit) 			<a lot>
# 		Max (32-bit) 			<less>
#
# 		REMOVED in 8.0.3
#
# query_cache_size
#
# 		cmd line format: 				--query-cache-size=#
# 		Deprecated: 					Yes (removed in 8.0.3)
# 		Sys var: 						query_cache_size
# 		Scope: 							Global
# 		Dynamic: 						Yes
# 		SET_VAR Hint: 					No
# 		Type: 							Integer
# 		Default (64-bit, >= 8.0.1) 0
#  	Default (64-bit, 8.0.0) 	1048576
#
# 		Default (32-bit, >= 8.0.1) 0
# 		Default (32-bit, 8.0.0) 	1048576
# 
# 		Min: 								0
#
# 		Max (64-bit) 					<a lot>
# 		Max (32-bit) 					<less>
#
# 		REMOVED in 8.0.3
#
# query_cache_type
#
# 		Cmd line format: 			--query-cache-type=#
# 		Deprecated: 				Yes (Removed in 8.0.3)
# 		Sys var: 					query_cache_type
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Enumeration
# 		Default: 					0
# 		Valid: 						0, 1, 2
#
# 		Removed in 8.0.3
#
# query_cache_wlock_invalidate
#
# 		cmd line format: 			--query-cache-wlock-invalidate
# 		Deprecated: 				Yes (Removed in 8.0.3)
# 		Sys var: 					query_cache_wlock_invalidate
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Boolean
# 		Default: 					FALSE
#
# 		Removed in 8.0.3
#
# query_prealloc_size
#
# 		cmd line format: 			--query-prealloc-size=#
# 		Sys var: 					query_prealloc_size
# 		Scope: 						Global, Session
# 		Dynamic: 					Yes
# 		SET_VAR Hint: 				No
# 		Type: 						Integer
# 		Default: 					8192
# 		Min: 							8192
# 		Max (64-bit) 				<a lot>
# 		Max (32-bit) 				<less>
# 		Block size: 				1024
#
# 		The size of the persistent buffer used for statement parsing and execution.
# 		This buffer is not freed between statements.
#
# 		If you are running complex queries, a larger query_prealloc_size value might
# 		be helpful in improving performance, because it can reduce the need for the server
# 		to perform memory allocation during query execution operations.
#
# rand_seed1
#
# 		sys var: 				rand_seed1
# 		Scope: 					Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
#
# 		The rand_seed1 and rand_seed2 vars exist as session vars only, and can be set but not read.
# 		The variable - but not their values - are shown in the output of SHOW_VARIABLES.
#
# 		The purpose of these vars is to support replication of the RAND() function.
# 		For statements that invoke RAND(), the master passes two values to the slave -
# 		where they are used to seed the RNG.
#
# 		The slave uses these values to set the session vars rand_seed1 and rand_seed2 so that RAND()
# 		on the slave generates the same value as on the master.
#
# rand_seed2
# 
# 		Same as rand_seed1
#
# range_alloc_block_size
#
# 		Cmd line format: 		--range-alloc-block-size=#
# 		Sys var: 				range_alloc_block_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				4096
# 		Min: 						4096
# 		Max (64-bit) 			<a lot>
# 		Max: 						<less>
# 		Block size: 			1024
#
# 		Size of blocks that are allocated when doing range optimization.
#
# range_optimizer_max_mem_size
#
# 		cmd line ormat: 		--range-optimizer-max-mem-size=N
# 		Sys var: 				range_optimizer_max_mem_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Integer
# 		Default: 				8388608
# 		Min: 						0
# 		Max: 						<a lot>
#
# 		The limit on memory consumption for the range optimizer.
# 		A value of 0 means "no limit".
#
# 		If an execution plan considered by the optimizer uses the range access
# 		method but the optimizer estimates that the amount of memory needed for this
# 		method would exceed the limit - it abandons the plan and considers other plans.
#
# rbr_exec_mode
#
# 		sys var: 		rbr_exec_mode
# 		Scope: 			Global, Session
# 		Dynamic: 		Yes
# 		SET_VAR Hint: 	No
# 		Type: 			Enumeration
# 		Default: 		STRICT
# 		Valid: 			IDEMPOTENT, STRICT
#
# 		For internal use by mysqlbinlog.
# 		The variable switches the server between IDEMPOTENT mode and STRICT mode.
#
# 		IDEMPOTENT mode causes suppression of duplicate-key and no-key found errors
# 		in BINLOG statements generated by mysqlbinlog.		
#
# 		This mode is useful when replaying a row-based binary log on a server that causes
# 		conflicts with existing data. 
#
# 		mysqlbinlog sets this mode when you specify the --idempotent option by writing the following:
#
# 		SET SESSION RBR_EXEC_MODE=IDEMPOTENT;
#
# 		As of MySQL 8.0.14 - setting the session value of this sys var is a restricted ops.
# 		Reqs privs.
#
# read_buffer_size
#
# 		cmd line format: 		--read-buffer-size=#
# 		Sys var: 				read_buffer_size
# 		Scope: 					Global, Session
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			Yes
# 		Type: 					Integer
# 		Default: 				131072
# 		Min: 						8200
# 		Max: 						<a lot>
#
# 		Each thread that does a sequential scan for a MyISAM table allocates a buffer of this size (in bytes)
# 		for each table it scans.
#
# 		If you do many sequential scans, you might want to increase this value.
#
# 		Value of this var should be % 4kb. If it set to a value which is not, it's rounded down to closest % 4kb value.
#
# 		Is also used in the following context for all storage engines:
#
# 			For caching the indexes in a temporary file (not a temp table), when sorting rows for ORDER BY.
#
# 			For bulk insert into partitions.
#
# 			For caching results of nested queries.
#
# 		read_buffer_size is also used in one other storage engine-specific way: To determine the memory block size
# 		for MEMORY tables.
#
# read_only
#
# 		cmd line format: 		--read-only
# 		Sys var: 				read_only
# 		Scope: 					Global
# 		Dynamic: 				Yes
# 		SET_VAR Hint: 			No
# 		Type: 					Boolean
# 		Default: 				OFF
#
# 		When the read_only sys var is enabled, the server permits no client updates except
# 		from users who have the CONNECTION_ADMIN or SUPER privs.
#
# 		This var is disabled by default.
#
# 		The server also supports a super_read_only sys var (disabled by default), which has these effects:
#
# 			If super_read_only is enabled, the server prohibits client updates, even from users who have the SUPER priv.
#
# 			Setting super_read_only to ON implicitly forces read_only to ON.
#
# 			Setting read_only to OFF implicitly forces super_read_only to OFF.
#
# 		Even with read_only enabled, the server permits these operations:
#
# 			Updates performed by slave threads, if the server is a replication slave. 
#
# 			In replication setups, it can be useful to enable read_only on slave servers
# 			to ensure that slaves accept updates only from the master server and not from clients.
#
# 			Use of ANALYZE_TABLE or OPTIMIZE_TABLE statements. The purpose of read-only mode is to prevent
# 			changes to table structure or contents.
#
# 			Analysis and optimization do not qualify as such changes. 
#
# 			This means for example, that consistency checks on read-only replication slaves can be performed with
# 			mysqlcheck --all-databases --analyze
#
# 			Operations on TEMPORARY tables
#
# 			Inserts into the log tables (mysql.general_log and mysql.slow_log)
#
# 			Updates to Performance Schema tables, such as UPDATE or TRUNCATE TABLE operations.
#
# 		Changes to read_only on a master server are not replicated to slave servers. 
# 		The value can be set on a slave server independent of the setting on the master.
#
# 		The following conditions apply to attempts to enable read_only (including implicit attempts resulting from enabling super_read_only):
# 
# 			The attempt fails and an error occurs if you have any explicit locks (acquired with LOCK_TABLES) or have a pending transaction.
#
# 			The attempt blocks while other clients hold explicit table locks or have pending transactions, until the locks are released and
# 			the trans ends. 
# 			
# 			While the attempt to enable read_only is pending, requests by other clients for table locks or to begin trans also block until read_only has been set.
#
# 			The attempt blocks if there are active transactions that hold metadata locks, until those transactions end.
#
# 			read_only can be enabled while you hold a global read lock (acquired with FLUSH_TABLES_WITH_READ_LOCK) because that does
# 			not involve table locks.
#
# read_rnd_buffer_size
#
# 			cmd line format: 		--read-rnd-buffer-size=#
# 			Sys var: 				read_rnd_buffer_size
# 			Scope: 					Global, Session
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			Yes
# 			Type: 					Integer
# 			Default: 				262144
# 			Min: 						1
# 			Max: 						<less>
#
# 			This var is used for reads from MyISAM tables and for any storage engine, for multi-range read optimization.
#
# 			When reading rows from a MyISAM table in sorted order following a key-sorting operation, the rows
# 			are read through this buffer to avoid disk seeks.
#
# 			Setting this variable to a large value can improve ORDER BY performance by a lot.
# 			However, this is a buffer allocated for each client - so you should not set the global variable to a large value.
#
# 			Instead, the session value can be large for where you need to run large queries.
#
# regexp_stack_limit
#
# 			cmd line format: 		--regexp-stack-limit=#
# 			introduced: 			8.0.4
# 			Sys var: 				regexp_stack_limit
# 			Scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Integer
# 			Default: 				8 000 000
# 			Min: 						0
# 			Max: 						<a lot>
#
# 			Max value available memory in bytes for the internal stack used for regex matching ops
# 			performed by REGEXP_LIKE() and similar functions.
#
# regexp_time_limit
#
# 			cmd line format: 		--regexp-time-limit=#
# 			Introduced: 			8.0.4
# 			Sys var: 				regexp_time_limit
# 			Scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Integer
# 			Default: 				32
# 			min: 						0
# 			Max: 						<a lot>
#
# 			The time limit for regexp matching ops performed by REGEXP_LIKE() and similar functions.
# 			This limit is expressed as the max permitted number of steps performed by the match engine,
# 			and thus affects execution time only indirectly.
#
# 			Typically on the order of milliseconds.
#
# require_secure_transport
#
# 			cmd line format: 		--require-secure-transport[={OFF|ON}]
# 			Sys var: 				require_secure_transport
# 			Scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Boolean
# 			Default: 				OFF
# 			
#
# 			Whether client connections to the server are required to use some form of secure transport.
# 			When this variable is enabled, the server permits only TCP/IP connections that use SSL,
# 			or connections that use a socket file (on Unix) or shared memory (on Windows).
#
# 			The server rejects nonsecure connection attempts, which fail with an ER_SECURE_TRANSPORT_REQUIRED error.
#
# 			This capability supplements per-account SSL reqs, which takes precedence.
#
# 			For example,if an acc is defined with REQUIRE SSL - enabling require_secure_transport
# 			does not make it possible to use the account to connect using a Unix socket file.
#
# 			It is possible for a server to have no secure transports available. For example, a server on Windows
# 			supports no secure transports if started without specifying any SSL cert or key files and with
# 			the shared_memory SYS_VAR disabled.
#
# 			Under said conditions, attempts to enable require_secure_transport at startup cause the server to write
# 			a message to the error log and exit. Attempts to enable the variable at runtime fail with an ER_NO_SECURE_TRANSPORTS_CONFIGURED
# 			error.
#
# resultset_metadata
#
# 			Introduced: 		8.0.3
# 			Sys var: 			resultset_metadata
# 			Scope: 				Session
# 			Dynamic: 			Yes
# 			SET_VAR Hint: 		No
# 			Type: 				Enumeration
# 			Default: 			FULL
# 			Valid: 				FULL, NONE
#
# 			For connections for which metadata transfer is optional, the client sets the resultset_metadata
# 			SYS var to control whether the server returns result set metadata.
#
# 			Permitted values are FULL (return all metadata; this is the default) and NONE (return no metadata)
#
# 			For connections that are not metadata-optional, setting resultset_metadata to NONE produces an error.
#
# schema_definition_cache
#
# 			cmd line format: 		--schema-definition-cache=N
# 			Sys var: 				schema_definition_cache
# 			scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Integer
# 			Default: 				256
# 			Min: 						256
# 			Max: 						524288
#
# 			Defines a limit for the number of schema def objects, both used and unused, that can be kept
# 			in the dictionary object cache.
#
# 			Unused schema definition objects are only kept in the dictionary object cache when the number in use is
# 			less than the capacity defined by schema_definition_cache.
#
# 			A setting of 0 means that schema definition objects are only kept in the dictionary object cache
# 			while they are in use.
#
# secure_auth
#
# 			cmd line format: 		--secure-auth
# 			Deprecated: 			Yes (removed in 8.0.3)
# 			Sys var: 				secure_auth
# 			Scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Boolean
# 			Default: 				On
# 			Valid: 					On
#
# 			Removed in 8.0.3
#
# secure_file_priv
#
# 			cmd line format: 		--secure-file-priv=dir_name
# 			Sys var: 				secure_file_priv
# 			Scope: 					Global
# 			Dynamic: 				No
# 			SET_VAR Hint: 			No
# 			Type: 					String
# 			Default: 				platform specific
# 			Valid: 					empty string, dirname, NULL
#
# 			Used to limit the effect of data import and export operations, such as those performed
# 			by the LOAD_DATA and SELECT_..._INTO_OUTFILE statements and the LOAD_FILE() function.
#
# 			Permitted only to users with FILE priv.
#
# 			secure_file_priv can be set as follows:
#
# 				If empty - var has no effect. Not a secure setting.
#
# 				If name of a dir, the server limits import and export ops to work only with files in that dir.
# 				The dir must exist, the server will not create it.
#
# 				If set to NULL, the server disables import and export ops.
#
# 			The default value is platform specific and depends on the value of the INSTALL_LAYOUT CMake option,
# 			as shown as follows:
#
# 			(To specify the default secure_file_priv value explicitly if you are building from source, use the 
# 			INSTALL_SECURE_FILE_PRIVDIR CMake option.)
#
# 				INSTALL_LAYOUT Value 		Default secure_file_priv Value
# 				STANDALONE, WIN 				empty
# 				DEB, RPM, SLES, SVR4 		/var/lib/mysql-files
# 				Otherwise 						mysql-files under the CMAKE_INSTALL_PREFIX value
#
# 			The server checks the value of secure_file_priv at startup and writes a warning to the error log
# 			if the value is insecure.
#
# 			A non-NULL value is considered insecure if it is empty, or the value is the dara dir or a subdir of it,
# 			or a sub-dir that is accessible by all users.
#
# 			If secure_file_priv is set to a nonexistent path, the server writes an error message to the error log and exits.
#
# server_id
#
# 			cmd line format: 		--server-id=#
# 			Sys var: 				server_id
# 			Scope: 					Global
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Integer
# 			Default (>= 8.0.3) 	1
# 			Default (<= 8.0.2) 	0
# 			Min: 						0
# 			Max: 						<a lot>
#
# 			Specifies the server ID. This variable is set by the --server-id option.
# 			The server_id sys var is set to 1 by default.
#
# 			The server can be started with this default ID, but when bin log is enabled,
# 			an informational message is issued if you did not specify a server ID explicitly using the --server-id option.
#
# 			For servers that are used in a replication topology, you must specify a unique server ID for each replication
# 			server, in the range from 1 to 2^32 - 1. "Unique" means that each ID must be different from other IDs in use by 
# 			any other replication master or slave.
#
# 			If the server ID is set to 0, binary logging takes place - but a master server with a server ID of 0
# 			refuses any connections from slaves and a slave with a server ID of 0 refuses to connect to a master.
#
# 			Note that although you can change the server ID dynamically to a nonzero value, doing so does not
# 			enable replication to start immediately.
#
# 			You must change the server ID and then restart the server to initialize the replication slave.
#
# session_track_gtids
#
# 			cmd line format: 			--session-track-gtids=[value]
# 			Sys var: 					session_track_gtids
# 			Scope: 						Global, Session
# 			Dynamic: 					Yes
# 			SET_VAR Hint: 				No
# 			Type: 						Enumeration
# 			Default: 					OFF
# 			Valid: 						OFF, OWN_GTID, ALL_GTIDS
#
# 			Controls whether the server tracks GTIDs within the current session and returns them to the client.
# 			Depending on the variable value, at the end of executing each transaction, the server GTIDs are captured
# 			by the tracker and returned to the client.
#
# 			These session_track_gtids values are permitted:
#
# 				OFF: Track collects no GTIDs. Default.
#
# 				OWN_GTID: The track collects GTIDs generated by successfully committed read/write transactions.
#
# 				ALL_GTIDS: The track collects all GTIDs in the gtid_executed SYS_VAR at the time the current transaction commits,
# 				regardless of whether the transaction is read/write or read only.
#
# 			session_track_gtids cannot be set within transactional context.
#
# session_track_schema
#
# 			cmd line format: 		--session-track-schema=#
# 			Sys var: 				session_track_schema
# 			Scope: 					Global, Session
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Boolean
# 			Default: 				ON
#
# 			Controls whether the server tracks when the default schema (database) is set within the current session
# 			and notifies the client to make the schema name available.
#
# 			If the schema name tracked is enabled, name notification occurs each time the default schema is set,
# 			even if the new schema name is the same as the old.
#
# session_track_state_change
#
# 			Cmd line format: 		--session-track-state-change=#
# 			Sys var: 				session_track_state_change
# 			Scope: 					Global, Session
# 			Dynamic: 				Yes
# 			SER_VAR Hint: 			No
# 			Type: 					Boolean
# 			Default: 				OFF
#
# 			Controls whether the server tracks changes to the state of the current session and notifies
# 			the client when state changes occur.
#
# 			Changes can be reported for these attributes of client session state:
#
# 				Default schema (db)
#
# 				Session-specific values for sys vars.
#
# 				User-defined vars
#
# 				Temp tables
#
# 				Prepared statements
#
# 			If the session state tracker is enabled, notification occurs for each change that involves tracked session attributes,
# 			even if the new attribute values are the same as the old.
#
# 			For example, setting a user-defined variable to its current value results in a notification.
#
# 			The session_track_state_change variable controls only notification of when changes occur, not what the changes are.
#
# 			For example, state-change notifications occur when the default schema is set or tracked session SYS vars are assigned,
# 			but the notification does not include the schema name or variable values.
#
# 			To receive notification of the schema name or session sys var values - use the session_track_schema or session_track_system_variables
# 			SYS_Vars respectively.
#
# 			NOTE: Assigning a value to session_track_state_change itself is not considered a state change and is not reported as such.
# 					However, if its name is listed in the value of session_track_system_variables, any assignments to it do result in notification of the new value.
#
# session_track_system_variables
#
# 			cmd line format: 		--session-track-system-variables=#
# 			Sys var: 				session_track_system_variables
# 			Scope: 					Global, Session
# 			Dynamic: 				Yes
# 			SET_Var Hint: 			No
# 			Type: 					String
# 			Default: 				time_zone, autocommit, character_set_client, character_set_results,
# 										character_set_connection
#
# 			Controls whether the server tracks assignments to session system vars and notifies the client of the name
# 			and value of each assigned variable.
#
# 			The variable value is a comma-separated list of variables for which to track assignments.
#
# 			By default, notification is enabled for time_zone, autocommit, character_set_client,
# 			character_set_results and character_set_connection.
#
# 			(The latter three vars are those affacted by SET_NAMES)
#
# 			Wildcard * all denotation can be given.
#
# 			To disable notification session vars assignments, set session_track_system_variables to the
# 			empty string.
#
# 			If session system variable tracking is enabled, notification occurs for all assignments to tracked
# 			session variables, even if the new values are the same as the old.
#
# session_track_transaction_info
#
# 			cmd line format: 		--session-track-transaction-info=value
# 			Sys var: 				session_track_transaction_info
# 			Scope: 					Global, Session
# 			Dynamic: 				Yes
# 			SET_VAR Hint: 			No
# 			Type: 					Enumeration
# 			Default: 				OFF
# 			Valid: 					OFF, STATE, CHARACTERISTICS
#
# 			Controls whether the server tracks the state and characteristics of transactions within the current session
# 			and notifies the client to make this information available.
#
# 			These session_track_transaction_info values are permitted:
#
# 				OFF: Disable transaction state tracking. Default.
#
# 				STATE: Enable transaction state tracking without characteristics tracking.
# 						 State tracking enables the client to determine whether a transaction is in progress
# 						 and whether it could be moved to a different session without being rolled back.
#
# 				CHARACTERISTICS: Enable transaction state tracking, including chars tracking. Characteristics tracking enables
# 						 the client to determine how to restart a transaction in another session so that it has the same
# 						 characteristics as in the original session.
#
# 						The following chars are relevant:
#
# 						READ ONLY
# 						READ WRITE
# 						ISOLATION LEVEL
# 						WITH CONSISTENT SNAPSHOT
#
# 				For a client to safely relocate a transaction to another session, it must track not only transaction
# 				state but also transaction characteristics. 
#
# 				In addition, the client must track the transaction_read_only and transaction_isolation SYS_VAR to correctly determine the session defaults.
#
# 				(To track these, list them in the value of the session_track_system_variables SYS_VAR)
#
# sha256_password_auto_generate_rsa_keys
#
# 				Cmd line format: 		--sha256-password-auto-generate-rsa-keys[={OFF|ON}]
# 				Sys var: 				sha256_password_auto_generate_rsa_keys
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				ON
#
# 				Available if the server was compiled using OpenSSL. The server uses it to determine whether to
# 				autogenerate RSA private/public key-pair files in the data dir if they do not already exist.
#
# 				At startup, the server automatically generates RSA private/public key-pair files in the data dir
# 				if all of these conditions are true:
#
# 					The sha256_password_auto_generate_rsa_keys or caching_sha2_password_auto_generate_rsa_keys SYS_VAR is on.
#
# 					No RSA options are specified
#
# 					The RSA files are missing from the data dir.
#
# 				These key-pair files enable secure PW exchange using RSA over unencrypted connections for accounts
# 				authenticated by the sha256_password or caching_sha2_password plugin.
#
# 				The auto_generate_certs SYS_VAR is related but controls autogeneration of SSL certs and keys needed for secure connections.
#
# sha256_password_private_key_path
#
# 				cmd line format: 		--sha256-password-private-key-path=file_name
# 				Sys var: 				sha256_password_private_key_path
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					File name
# 				Default: 				private_key.pem
#
# 				This var is available if MySQL was compiled using OpenSSL.
# 				Its value is the path name of the RSA priv key file for the sha256_password
# 				auth plugin.
#
# 				Relative to server data dir. Must be in PEM.
#
# 				Permissions should be constrained to MySQL reading it.
#
# sha256_password_proxy_users
#
# 				cmd line format: 		--sha256-password-proxy-users=[={OFF|ON}]
# 				Sys var: 				sha256_password_proxy_users
# 				Scope: 					Global
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				OFF
#
# 				Controls whether the sha256_password built-in auth plugin supports proxy users.
# 				Has no effect unless the check_proxy_users SYS_VAR is on.
#
# sha256_password_public_key_path
#
# 				cmd line format: 		--sha256-password-public-key-path=file_name
# 				Sys var: 				sha256_password_public_key_path
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					File name
# 				Default: 				public_key.pem
#
# 				Available if MYSQL was compiled using OpenSSL. 
# 				Its value is the path name of the RSA public key file for the sha256_password auth plugin.
# 			 			
# 				If the file is named as a relative path, it is interpreted relative to the server Data dir.
# 				File must be in PEM format.
#
# 				The key is a public key, thus copies can be distirbued to client users.
# 				(Clients that explicitly specify a public key when connecting to the server using RSA
# 				PW encryption must use the same public key as that used by the server.)
#
# shared_memory
#
# 				cmd line format: 		--shared-memory[={0,1}]
# 				Sys var: 				shared_memory
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Platform: 				Windows
# 				Type: 					Boolean
# 				Default: 				FALSE
#
# 				Whether hte server permits shared-memory connections.
#
# shared_memory_base_name
#
# 				cmd line format: 		--shared-memory-base-name=name
# 				Sys var: 				shared_memory_base_name
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Platform: 				Windows
# 				Type: 					String
# 				Default: 				MYSQL
#
# 				Name of the shared memory to use for shared-memory connections.
# 				Useful when running multiple MySQL instances on a single physical machine.
# 				Defaults to MySQL. Case sensitive.
#
# show_compatibility_56
#
# 				cmd line format: 		--show-compatibility-56[={OFF|ON}]
# 				Deprecated: 			Yes (Removed in 8.0.1)
# 				Sys var: 				show_compatibility_56
# 				Scope: 					Global
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				OFF
#
# 				Was used in the transition period during which system and status variable info in
# 				INFORMATION_SCHEMA tables was moved to Performance Schema tables.
#
# 				That transition period ended in MySQL 8.0.1, at which time this variable was removed.
#
# show_create_table_verbosity
#
# 				Cmd line format: 		--show-create-table-verbosity
# 				Introduced: 			8.0.11
# 				Sys var: 				show_create_table_verbosity
# 				Scope: 					Global, Session
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
#
# 				SHOW_CREATE_TABLE normally does not show the ROW_FORMAT table option if the
# 				row format is the default format.
#
# 				Enabling this variable causes SHOW_CREATE_TABLE to display ROW_FORMAT
# 				regardless of whether it is the default format.
#
# show_old_temporals
#
# 				cmd line format: 			--show-old-temporals={OFF|ON}
# 				Deprecated: 				Yes
# 				Sys var: 					show_old_temporals
# 				Scope: 						Global, Session
# 				Dynamic: 					Yes
# 				SET_VAR Hint: 				No
# 				Type: 						Boolean
# 				Default: 					OFF
#
# 				Whether SHOW_CREATE_TABLE output includes comments to flag temporal columns found to be in
# 				pre-5.6.4 format (TIME, DATETIME, and TIMESTAMP columns without support for fractional seconds precision)
#
# 				Disabled by default. If enabled, SHOW_CREATE_TABLE output looks as follows:
#
# 				CREATE TABLE `mytbl` (
# 					`ts` timestamp /* 5.5 binary format */ NOT NULL DEFAULT CURRENT_TIMESTAMP,
# 					`dt` datetime /* 5.5 binary format */ DEFAULT NULL,
# 					`t` time /* 5.5 binary format */ DEFAULT NULL
# 				) DEFAULT CHARSET=utf8mb4
#
# 				Output for the COLUMN_TYPE column of the INFORMATION_SCHEMA.COLUMNS table is affected similarly.
#
# 				Deprecated.
#
# skip_external_locking
#
# 				cmd line format: 		--skip-external-locking
# 				Sys var: 				skip_external_locking
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				ON
#
# 				This is OFF if mysqld uses external locking (system locking), ON if external locking is disabled.
#  			This affects only MyISAM table access.
#
# 				This variable is set by the --external-locking or --skip-external-locking option.
#
# 				External locking is disabled by default.
#
# 				External locking affects only MyISAM table access.
# 
# skip_name_resolve
#
# 				Cmd line format: 		--skip-name-resolve
# 				Sys var: 				skip_name_resolve
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				OFF
#
# 				This variable is set from the value of the --skip-name-resolve option.
# 				If OFF, mysqld resolves host names when checking client connections.
#
# 				If it is ON, mysqld uses only IP numbers; in this case, all Host column values
# 				in the grant tables must be IP addresses or localhost.
#
# skip_networking
#
# 				cmd line format: 		--skip-networking
# 				Sys var: 				skip_networking
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
#
# 				This is ON if the server permits only local (non-TCP/IP) connections.
# 				On Unix, local connections use a Unix socket file.
#
# 				On Windows, local connections use a named pipe or shared memory.
# 				Can be set to ON with the --skip-networking option.
#
# skip_show_database
#
# 				cmd line format: 		--skip-show-database
# 				Sys var: 				skip_show_database
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
#
# 				Prevents people from using the SHOW_DATABASE statement if they do not have the SHOW_DATABASE priv.
#
# 				This can improve security if you have concerns about users being able to see databases belonging to other users.
# 				Its effect depends on the SHOW_DATABASE priv: 
#
# 				If ON - the SHOW_DATABASES statement is permitted only to users who have the SHOW_DATABASES priv, and the statement displays all DB names.
#
# 				If OFF - SHOW_DATABASES is permitted to all users, but displays the names of only those databases for which the user has the SHOW_DATABASE or other privs.
#
# 				(ANY global priv includes privs for all DBs)
#
# slow_launch_time
#
# 				cmd line format: 		--slow-launch-time=#
# 				Sys var: 				slow_launch_time
# 				Scope: 					Global
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					Integer
# 				Default: 				2
#
# 				If creating a thread takes longer than this many seconds, the server increments the Slow_launch_threads status var.
#
# slow_query_log
#
# 				Cmd line format: 		--slow-query-log
# 				Sys var: 				slow_query_log
# 				Scope: 					Global
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					Boolean
# 				Default: 				OFF
#
# 				Whether the slow query log is enabled. 
#
# 				0/OFF - disables the log
#
# 				1/ON  - enables the log
#
# 				The default value depends on whether the --slow_query_log option is given.
# 				The destination for log output is controlled by the log_output SYS VAR.
#
# 				If log_output is NONE, no log entries are written - even if the log is on.
#
# 				"Slow" is defined by the long_query_time var.
#
# slow_query_log_file
#
# 				Cmd line format: 		--slow-query-log-file=file_name
# 				Sys var: 				slow_query_log_file
# 				Scope: 					Global
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			No
# 				Type: 					File name
# 				Default: 				host_name-slow.log
#
# 				The name of the slow query log file. 
# 				Default is <host_name>-slow.log - but the intiial value can be changed with the
# 				--slow_query_log_file option.
#
# socket
#
# 				cmd line format: 		--socket={file_name|pipe_name}
# 				Sys var: 				socket
# 				Scope: 					Global
# 				Dynamic: 				No
# 				SET_VAR Hint: 			No
# 				Type: 					String
# 				Default (Other) 		/tmp/mysql.sock
# 				Default (Windows) 	MySQL
#
# 				On Unix platforms, this var is the name of the socket file that is used for local client connections.
# 				The default is /tmp/mysql.sock (might be /var/lib/mysql for RPMs)
#
# 				On Windows, this var is the name of the named pipe that is used for local client connections. Default is MySQL. (non-case sensitive)
#
# sort_buffer_size
#
# 				cmd line format: 		--sort-buffer-size=#
# 				Sys var: 				sort_buffer_size
# 				Scope: 					Global, Session
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			Yes
# 				Type: 					Integer
# 				Default: 				262144
# 				Min: 						32768
#
# 				Max (64-bit other) 	<a lot>
# 				Max (32-bit other) 	<less>
# 				Max (Windows) 			<same>
#
# 				Each session that must perform a sort allocates a buffer of this size.
# 				sort_buffer_size is not specific to any storage engine and applies in a general manner for
# 				optimization.
#
# 				At minimum the sort_buffer_size value must be large enough to accomodate fifteen tuples in the sort buffer.
# 				Also, increasing the value of max_sort_length may require increasing the value of sort_buffer_size.
#
# 				If you see many Sort_merge_passes per second in SHOW_GLOBAL_STATUS output, you can consider increasing the
# 				sort_buffer_size value to speed up ORDER BY or GROUP BY operations that cannot be improved with query
# 				optimization or improved indexing.
#
# 				The optimizer tries to work out how much space is needed but can allocate more, up to said limit.
# 				Setting it larger than required globally will slow down most queries that sort.
#
# 				Best ot increase as session setting, and only for sessions that need a larger size.
#
# 				On Linux, there are thresholds of 256kb and 2MB where larger values may significantly
# 				slow down memory allocation - so you should consider staying below one of said sizes.
#
# 				The max permissible setting for sort_buffer_size is 4GB-1. Larger values are allowed for 64-bit platforms.
# 				(Except 64-bit Windows, restraints to 4GB-1)
#
# sql_auto_is_null
#
# 				Sys var: 		sql_auto_is_null
# 				Scope: 			Global, Session
# 				Dynamic: 		Yes
# 				SET_VAR Hint: 	Yes
# 				Type: 			Boolean
# 				Default: 		OFF
#
# 				If this is enabled, then after a statement that successfully inserts an automatically generated AUTO_INCREMENT value,
# 				you can find said value with a query of:
#
# 				SELECT * FROM <tbl_name> WHERE <auto_col> IS NULL
#
# 				If the statement returns a row, the value returned is the same as if you invoked the LAST_INSERT_ID() function.
#
# 				If no AUTO_INCREMENT value was successfully inserted, the SELECT statement returns no row.
#
# 				The beavior of retrieving an AUTO_INCREMENT value by using an IS_NULL comparison is used by some
# 				ODBC programs, such as Access.
#
# 				This beavior can be disabled by setting sql_auto_is_null to OFF.
#
# sql_big_selects
#
# 				Sys var: 		sql_big_selects
# 				Scope: 			Global, Session
# 				Dynamic: 		Yes
# 				SET_VAR Hint: 	Yes
# 				Type: 			Boolean
# 				Default: 		ON
#
# 				If set to OFF, MySQL aborts SELECT statements that are likely to take a long time to execute (statements that estimate > rows cmp. to max_join_size)
#
# 				Useful when an inadivsable WHERE statement has been issued.
# 				The default value for a new connection is ON, which permits all SELECT statements.
#
# 				If you set the max_join_size SYS_VAR to a value other than DEFAULT, sql_big_selects is set to OFF.
#
# sql_buffer_result
#
# 				Sys var: 		sql_buffer_result
# 				Scope: 			Global, Session
# 				Dynamic: 		Yes
# 				SET_VAR Hint: 	Yes
# 				Type: 			Boolean
# 				Default: 		OFF
#
# 				If enabled, sql_buffer_result forces results from SELECT statements to be put into temporary tables.
#
# 				This helps MySQL free the table locks early and can be beneficial in cases where it takes a long time
# 				to send results to the client. The default value is OFF.
#
# sql_log_off
#
# 				Sys var: 		sql_log_off
# 				Scope: 			Global, Session
# 				Dynamic: 		Yes
# 				SET_VAR Hint: 	No
# 				Type: 			Boolean
# 				Default: 		OFF
# 				Valid: 			OFF (enable logging), ON (disable logging)
#
# 				Controls whether logging to the general query log is disabled for the current session
# 				(assuming that the general query log itself is enabled)
#
# 				The default value is OFF (that is, enable logging).
#
# 				To disable or enable general query logging for the current session, set the session sql_log_off variable
# 				to ON or OFF.
#
# 				Restricted ops. Reqs privs enough for restricted session vars.
#
# sql_mode
#
# 				cmd line format: 		--sql-mode=name
# 				Sys var: 				sql_mode
# 				Scope: 					Global, Session
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			Yes
# 				Type: 					Set
# 				Default (>= 8.0.11) 	ONLY_FULL_GROUP_BY
# 											STRICT_TRANS_TABLES
# 											NO_ZERO_IN_DATE
# 											NO_ZERO_DATE
# 											ERROR_FOR_DIVISION_BY_ZERO
# 											NO_ENGINE_SUBSTITUTION
#
# 				Default (<= 8.0.4) 	ONLY_FULL_GROUP_BY 
# 											STRICT_TRANS_TABLES
# 											NO_ZERO_IN_DATE
# 											NO_ZERO_DATE
# 											ERROR_FOR_DIVISION_BY_ZERO
# 											NO_AUTO_CREATE_USER
# 											NO_ENGINE_SUBSTITUTION
#
# 				Valid (>= 8.0.11) 	ALLOW_INVALID_DATES
# 											ANSI_QUOTES
# 											ERROR_FOR_DIVISION_BY_ZERO
# 											HIGH_NOT_PRECEDENCE
# 											IGNORE_SPACE
# 											NO_AUTO_VALUE_ON_ZERO
# 											NO_BACKSLASH_ESCAPES
# 											NO_DIR_IN_CREATE
# 											NO_ENGINE_SUBSTITUTION
# 											NO_UNSIGNED_SUBTRACTION
# 											NO_ZERO_DATE
# 											NO_ZERO_IN_DATE
# 											ONLY_FULL_GROUP_BY
# 											PAD_CHAR_TO_FULL_LENGTH
# 											PIPES_AS_CONCAT
# 											REAL_AS_FLOAT
# 											STRICT_ALL_TABLES
# 											STRICT_TRANS_TABLES
# 											TIME_TRUNCATE_FRACTIONAL
#
# 				Valid (>= 8.0.1, 		ALLOW_INVALID_DATES 
# 						 <= 8.0.4) 		ANSI_QUOTES
# 											ERROR_FOR_DIVISION_BY_ZERO
# 											HIGH_NOT_PRECEDENCE
# 											IGNORE_SPACE
# 											NO_AUTO_CREATE_USER
# 											NO_AUTO_VALUE_ON_ZERO
# 											NO_BACKSLASH_ESCAPES
# 											NO_DIR_IN_CREATE
# 											NO_ENGINE_SUBSTITUION
# 											NO_FIELD_OPTIONS
# 											NO_KEY_OPTIONS
# 											NO_TABLE_OPTIONS
# 											NO_UNSIGNED_SUBTRACTION
# 											NO_ZERO_DATE
# 											NO_ZERO_IN_DATE
# 											ONLY_FULL_GROUP_BY
# 											PAD_CHAR_TO_FULL_LENGTH
# 											PIPES_AS_CONCAT
# 											REAL_AS_FLOAT
# 											STRICT_ALL_TABLES
# 											STRICT_TRANS_TABLES
# 											TIME_TRUNCATE_FRACTIONAL
#
# 				Valid (8.0.0) 			ALLOW_INVALID_DATES
# 											ANSI_QUOTES
# 											ERROR_FOR_DIVISION_BY_ZERO
# 											HIGH_NOT_PRECEDENCE
# 											IGNORE_SPACE
# 											NO_AUTO_CREATE_USER
# 											NO_AUTO_VALUE_ON_ZERO
# 											NO_BACKSLASH_ESCAPES
# 											NO_DIR_IN_CREATE
# 											NO_ENGINE_SUBSTITUTION
# 											NO_FIELD_OPTIONS
# 											NO_KEY_OPTIONS
# 											NO_TABLE_OPTIONS
# 											NO_UNSIGNED_SUBTRACTION
# 											NO_ZERO_DATE
# 											NO_ZERO_IN_DATE
# 											ONLY_FULL_GROUP_BY
# 											PAD_CHAR_TO_FULL_LENGTH
# 											PIPES_AS_CONCAT
# 											REAL_AS_FLOAT
# 											STRICT_ALL_TABLES
# 											STRICT_TRANS_TABLES
#
# 				The current SQL mode, can be set dynamically.
#
# 				Can be configured during install/Options.
#
#  											
# sql_notes
#
# 				Sys var: 		sql_notes
# 				Scope: 			Global, Session
# 				Dynamic: 		yes
# 				SET_VAR Hint: 	No
# 				Type: 			Boolean
# 				Default: 		ON
#
# 				If enabled (by default), warnings of Note level increment warning_count and the server records them.
# 				If disabled, Note warnings do not increment warning_count and the server does not record them.
#
# 				mysqldump includes output to disable this variable so that reloading the dump file does not produce
# 				warnings for events that do not affect the integrity of the reload ops.
#
# sql_quote_show_create
#
# 				Sys var: 		sql_quote_show_create
# 				Scope: 			Global, Session
# 				Dynamic: 		Yes
# 				SET_VAR Hint: 	No
# 				Type: 			Boolean
# 				Default: 		ON
#
# 				If enabled (the default), the server quotes identifiers for SHOW_CREATE_TABLE and SHOW_CREATE_DATABASE statements.
#
# 				If disabled, quoting is disabled.
# 				Enabled by default so that replication works for identifiers that require quoting.
#
# sql_require_primary_key
#
# 				Cmd line format: 		--sql-require-primary-key[={OFF|ON}]
# 				Introduced: 			8.0.13
# 				Sys var: 				sql_require_primary_key
# 				Scope: 					Global, Session
# 				Dynamic: 				Yes
# 				SET_VAR Hint: 			Yes
# 				Type: 					Boolean
# 				Default: 				OFF
#
# 				Whether statements that create new tables or alter the structure of existing tables enforce the requirement that tables have a primary key.
#
# 				Setting this is a restricted ops.
#
# 				Enabling this variable helps avoid performance probblems in row-based replication that can occur when tables
# 				have no primary key.
#
# 				Suppose that a table has no primary key and an update or delete modifies multiple rows.
#
# 				On the master server, this ops can be performed using a single table scan but, when replicate
# 				using row-based replication, results in a table scan for each row to be modified on the slave.
#
# 				With a primary key, these table scans do not occur.
#
# 				sql_require_primary_key applies to both base tables and TEMPORARY tables, and changes to its
# 				value are replicated to slave servers.
#
# 				When enabled, sql_require_primary_key has these effects:
#
# 					Attempts to create a new table with no primary key fail with an error.
#
# 					This includes CREATE TABLE ... LIKE. It also includes CREATE TABLE ... SELECT,
# 					unless the CREATE TABLE includes a primary key def.
#
# 					Attempts to drop the primary key from an existing table fail with an error, with the exception
# 					that dropping the primary key and adding a primary key in the same ALTER TABLE statement is permitted.
#
# 					Dropping the primary key fails even if the table also contains a UNIQUE NOT NULL index.
# 
# 					Attempts to import a table with no primary key fail with an error.
#
# sql_safe_updates
#
# 					Sys var: 		sql_safe_updates
# 					Scope: 			Global, Session
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	Yes
# 					Type: 			Boolean
# 					Default: 		OFF
#
# 					If this variable is enabled, UPDATE and DELETE statements that do not use a key in the WHERE clause or a LIMIT clause
# 					produce an error.
#
# 					This makes it possible to catch UPDATE and DELETE statements where keys are not used properly and that would
# 					probably change or delete a large number of rows.
#
# 					For the mysql client, sql_safe_updates can be enabled by using the --safe-updates option.
#
# sql_select_limit
#
# 					Sys var: 		sql_select_limit
# 					Scope: 			Global, Session
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	Yes
# 					Type: 			Integer
#
# 					Max number of rows to return from SELECT statements.
#
# 					Default value for a new connection is the max number of rows that the server
# 					permits per table.
#
# 					Typical default values are (2^32)-1 or (2^64)-1.
#
# 					If you have changed the limit, the default value can be restored by assigning a value of DEFAULT.
#
# 					If a SELECT has a LIMIT clause, the LIMIT takes precedence over the value of sql_select_limit.
#
# sql_warnings
#
# 					Sys var: 		sql_warnings
# 					Scope: 			Global, Session
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	No
# 					Type: 			Boolean
# 					Default: 		OFF
#
# 					Controls whether single-row INSERT statements produce an information string if warnings occur.
# 					Default is OFF.
#
# 					Turn to ON for info strings.
#
# ssl_ca
#
# 					cmd line: 		--ssl-capath=dir_name
# 					Sys var: 		ssl_capath
# 					Scope: 			Global
# 					Dynamic: 		No
# 					SET_VAR Hint: 	No
# 					Type: 			Dir name
#
# 					Path to a dir that contains trusted SSL CA certs in PEM format.
#
# ssl_cert
#
# 					Cmd line: 		--ssl-cert=file_name
# 					Sys var: 		ssl_cert
# 					Scope: 			Global
# 					Dynamic: 		No
# 					SET_VAR Hint: 	No
# 					Type: 			File name
#
# 					Name of the SSL cert to use for establishing a secure connection.
#
# ssl_cipher
#
# 					Cmd line: 		--ssl-cipher=name
# 					Sys var: 		ssl_cipher
# 					Scope: 			Global
# 					Dynamic: 		No
# 					SET_VAR Hint: 	No
# 					Type: 			String
# 					
# 					List of permitted ciphers for SSL encryption.
#
# ssl_crl
#
# 					cmd line: 		--ssl-crl=file_name
# 					Sys var: 		ssl_crl
# 					Scope: 			Global
# 					Dynamic: 		No
# 					SET_VAR Hint: 	No
# 					Type: 			File name
#
# 					Path to a file containing cert revocation lists in PEM format.
# 					Revocation lists work for MySQL distributions compiled using OpenSSL. (but not wolfSSL)
#
# ssl_crlpath
#
# 					cmd line: 		--ssl-crlpath=dir_name
# 					Sys var: 		ssl_crlpath
# 					Scope: 			Global
# 					Dynamic: 		No
# 					SET_VAR Hint: 	No
# 					Type: 			Dir name
#
# 					The path to a dir that contains files containing cert revocation lists in PEM format.
# 					Revocation lists work for MySQL distributions compiled using OpenSSL (but not wolfSS)
#
# ssl_fips_mode
#
# 					cmd line format: 		--ssl-fips-mode={OFF|ON|STRICT}
# 					Introduced: 			8.0.11
# 					Sys var: 				ssl_fips_mode
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Enumeration
# 					Default: 				OFF
# 					Valid: 					OFF (or 0), ON (or 1), STRICT (or 2)
#
# 					Controls whether to enable FIPS mode on the server side. 
#
# 					The ssl_fips_mode system variable differs from other --ssl-xxx options
# 					in that it is not used to control whether the server permits encrypted connections,
# 					but rather to affect which cryptographic ops are permitted.
#
# 					These ssl_fips_mode values are permitted:
#
# 						OFF (or 0): Disable FIPS mode.
#
# 						ON (or 1): Enable FIPS mode.
# 
# 						STRICT (or 2): Enable "strict" FIPS mode.
#
# 					Note: If the OpenSSL FIPS Object Module is N/A, the only permitted value for ssl_fips_mode is OFF.
# 							In this case, setting ssl_fips_mode to ON or STRICT at startup causes the server to produce
# 							an error message and exit.
#
# ssl_key
#
# 					cmd line format: 		--ssl-key=file_name
# 					Sys var: 				ssl_key
# 					Scope: 					Global
# 					Dynamic: 				No
# 					SET_VAR Hint: 			No
# 					Type: 					File name
#
# 					The name of the SSL key file to use for establishing a secure connection.
#
# stored_program_cache
#
# 					cmd line format: 		--stored-program-cache=#
# 					Sys var: 				stored_program_cache
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				256
# 					Min: 						16
# 					Max: 						524288
#
# 					Sets a soft upper limit for the number of cached stored routines per connection.
#
# 					The value of this variable if specified in terms of the number of stored routines held
# 					in each of the two caches maintained by the MySQL Server for, respectively, stored procedures
# 					and stored functions. 				
#
# 					Whenever a stored routine is executed this cache size is checked before the first or top-level
# 					statement in the routine is parsed; if the number of routines of the same type (stored procedures or
#  				stored functions according to which is being executed) exceeds the limit specified by this var,
# 					the corresponding cache is flushed and memory previously allocated for cached objects is freed.
#
# 					This allows for the cache to be flushed safely, even when there are dependencies between stored
# 					routines.
#
# 					The stored procedure and stored function cache exists in parallel with the stored program definition
# 					cache partition of the dictionary object cache.
#
# 					The stored procedure and stored function caches are per connection, while the stored program
# 					definition cache is shared. The existence of objects in the stored procedure and stored function
# 					caches have no dependence on the existence of objects in the stored program definition cache and vice
# 					versa.
#
# 		
# stored_program_definition_cache
#
# 					Cmd line format: 		--stored-program-definition-cache=N
# 					Sys var: 				stored_program_definition_cache
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				256
# 					Min: 						256
# 					Max: 						524288
#
# 					Defines a limit for the number of stored program definition objects, both used
# 					and unused, that can be kept in the dictionary object cache.
#
# 					Unused stored program definition objects are only kept in the dictionary object cache
# 					when the number in use is less than the capacity defined by stored_program_definition_cache
#
# 					A setting of 0 means that stored program definition objects are only kept in the dictionary object
# 					cache while they are in use.
#
# 					The stored program definition cache partition exists in parallel with the stored procedure and
# 					stored function caches that are configured using the stored_program_cache option.
#
# 					The stored_program_cache option sets a soft upper limit for the number of cached stored procedures
# 					or functions per connection, and the limits is checked each time a connection executes a stored
# 					procedure or function.
#
# 					The stored program definition cache partition, on the other hand, is a shared cache that stores
# 					stored program definition objects for other purposes.
#
# 					The existence of objects in the stored program definition cache partition has no dependence
# 					on the existence of objects in the stored procedure cache or stored function cache, and vice versa.
#
# super_read_only
#
# 					cmd line format: 		--super-read-only[={OFF|ON}]
# 					Sys var: 				super_read_only
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Boolean
# 					Default: 				OFF
#
# 					If the read_only SYS_VAR is enabled, the server permits client updates only from users who have
# 					the SUPER priv.
#
# 					If the super_read_only SYS_VAR is also enabled, the server prohibits client updates even from
# 					users who have SUPER privs.
#
# 					Changes to super_read_only on a master server are not replicated to slave servers.
# 					The value can be set on a slave server independent of the setting on the master.
#
# syseventlog.facility
#
# 					Cmd line format: 		--syseventlog.facility=value
# 					Introduced: 			8.0.13
# 					Sys var: 				syseventlog.facility
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					String
# 					Default: 				daemon
#
# 					The facility for error log output written to syslog (what type of program is sending the message)
# 					This variable is unavailable unless the log_sink_syseventlog error log component is installed.
#
# 					Permitted values can vary per OS, consult your syslog documentation.
#
# 					Does not exist on Windows.
#
# syseventlog.include_pid
#
# 					Cmd line format: 		--syseventlog.include-pid[={0|1}]
# 					Introduced: 			8.0.13
# 					Sys var: 				syseventlog.include_pid
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Boolean
# 					Default: 				ON
#
# 					Whether to include the server process ID in each line of error log output written to syslog.
# 					This var is unavailable unless the log_sink_syseventlog error log component is installed.
#
# 					Does not exist on Windows.
#
# syseventlog.tag
#
# 					Cmd line format: 		--syseventlog.tag=tag
# 					Introduced: 			8.0.13
# 					Sys Var: 				syseventlog.tag
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					String
# 					Default: 				empty string
#
# 					The tag to be added to the server identifier in error log output written to syslog or 
# 					the Windows Event Log.
#
# 					This var is unavailable unless the log_sink_syseventlog error log component is installed.
#
# 					By default, no tag is set - so the server identifier is simply MySQL on Windows,
# 					and mysqld on other platforms.
#
# 					If a tag value of <tag> is specified, it is appended to the server identifier with
# 					a leading hyphen, resulting in a syslog identifier of mysqld-<tag> (or MySQL-<tag> on Windows)
# 					
# 					On Windows, to use a tag that does not already exist, the server must be run from an account
# 					with Administrator privs, to permit creation of a registry entry for the tag.
#
# 					Elevated privs are not required if the tag already exists.
#
# system_time_zone
#
# 					Sys var: 			system_time_zone
# 					Scope: 				Global
# 					Dynamic: 			No
# 					SET_VAR Hint: 		No
# 					Type: 				String
#
# 					The server system time zone. When the server begins executing, it inherits a time zone
# 					setting from the machine defaults, possibly modified by the environment of the account
# 					used for running the server or the startup script.
#
# 					The value is used to set system_time_zone. Typically the time zone is specified by the
# 					TZ environment variable.
#
# 					It also can be specified using the --timezone option of the mysqld_safe script.
#
# 					The system_time_zone variable differs from time_zone. Although they might have the same value,
# 					the latter variable is used to initialize the time zone for each client that connects.
#
# table_definition_cache
#
# 					Sys var: 			table_definition_cache
# 					Scope: 				Global
# 					Dynamic: 			Yes
# 					SET_VAR Hint: 		No
# 					Type: 				Integer
# 					Default: 			-1 (Autosizing;do not assign this literal value)
# 					Min: 					400
# 					Max: 					524288
#
# 					The number of table defs that can be stored in the def cache. 
#
# 					If you use a large number of tables, you can create a large table def cache to speed up opening of tables.
# 
#  				The table definition cache takes less space and does not use file descriptors, unlike the normal table cache.
# 					The minimum value is 400.
#
# 					The default value is based on the following formula, capped to a limit of 2000:
#
# 						MIN(400 + table_open_cache / 2, 2000)
#
# 					For InnoDB, table_definition_cache acts as a soft limit for the number of open table instances in the InnoDB
# 					data dir cache.
#
# 					If the number of open table instances exceed the table_definition_cache setting, the LRU mechanism begins to mark
# 					table instances for eviction and eventually removes them from the data dictionary cache.
#
#					The limit helps address situations in which significant amounts of memory would be used to cache
# 					rarely used table instances until the next server restart.
#
# 					The number of table instances with cached metadata could be higher than the limit defined by 
# 					table_definition_cache, because parent and child table instances with foreign key relationships
# 					are not placed on the LRU list and are not subject to eviction from memory.
#
# 					Additionally, table_definition_cache defines a soft limit for the number of InnoDB file-per-table tablespaces
# 					that can be open at one time, which is also controlled by innodb_open_files.
#
# 					If both table_definition_cache and innodb_open_files are set, the highest setting is used.
# 					If neither variable is set, table_definition_cache, which has a higher default value is used.
#
# 					If the number of open tablespace file handles exceeds the limit defined by table_definition_cache
# 					or innodb_open_files, the LRU mechanism searches the tablespace file LRU list for files that are
# 					fully flushed and are not currently being extended.
#
# 					The process is performed each time a new tablespace is opened. If there are no "inactive" tablespaces,
# 					no tablespace files are closed.
#
# 					The table definition cache exists in parallel with the table definition cache partition of the dictionary
# 					object cache.
#
# 					Both caches store table definitions but serve different parts of the MySQL server.
# 					Objects in one cache have no dependence on the existence of objects in the other.
#
# 	
# table_open_cache
#
# 					Sys var: 		table_open_cache
# 					Scope: 			Global
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	No
# 					Type: 			Integer
# 					Default (>= 8.0.4) 4000
# 					Default (<= 8.0.3) 2000
# 					Min: 				1
# 					Max: 				524288
#
# 					Number of open tables for all threads. Increasing this value increases the number of file descriptors
# 					that mysqld requires. You can check whether you need to increase the table cache by checking
# 					the Opened_tables STATUS_VAR.
#
# 					If the value of Opened_tables is large and you do not use FLUSH_TABLES often (which just forces all tables
# 					to be closed and reopened), then you should increase the value of the table_open_cache variable.
#
# table_open_cache_instances
#
# 					Sys var: 			table_open_cache_instances
# 					Scope: 				Global
# 					Dynamic: 			No
# 					SET_VAR Hint: 		No
# 					Type: 				Integer
# 					Default: 			16
# 					Min: 					1
# 					Max: 					64
#
# 					Number of open tables cache instances. 
#
# 					To improve scalability by reducing contention among sessions, the open tables cache 
# 					can be partitioned into several smaller cache instances of size table_open_cache/table_open_cache_instances.
#
# 					A session needs to lock only one instance to access it for DML statements.
#
# 					This segments cache access among instances, permitting higher performance for
# 					operations that use the cache when there are many sessions accessing tables.
#
# 					(DDL statements still require a lock on the entire cache, but such statements are much less
# 					frequent than DML statements.)
#
# 					A value of 8 or 16 is recommended on systems that routinely use 16 or more cores.
#
# temptable_max_ram
#
# 					cmd line format: 		--temptable-max-ram=#
# 					Introduced: 			8.0.2
# 					Sys Var: 				temptable_max_ram
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				1073741824
# 					Minimum: 				2097152
# 					Max: 						2^64-1
#
# 					Defines the max amount of memory that can be occupied by the TempTable
# 					storage engine before it starts storing data on disk.
#
# 					Default is 1 GiB.
#
# thread_cache_size
#
# 					cmd line format: 		--thread-cache-size=#
# 					Sys Var: 				thread_cache_size
# 					scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				-1 (autosizing)
# 					Min: 						0
# 					Max: 						16384
#
# 					How many threads the server should cache for reuse. When a client disconnects,
# 					the client's threads are put in the cache if there are fewer than thread_cache_size
# 					threads there.
#
# 					Requests for threads are satisfied by reusing threads taken from the cache if possible,
# 					and only when the cache is empty is a new thread created.
#
# 					This variable can be increased to improve performance if you have a lot of new connections.
# 					Normally, this does not provide a notable performance improvement if you have a good
# 					thread implementation.
#
# 					However, if your server sees hundreds of connections per second you should normally
# 					set thread_cache_size high enough so that most new connections use cached threads.
#
# 					By examining the difference between the Connections and Threads created status variables,
# 					you can see how efficient the thread cache is.
#
# 					The default value is based on the following formula, capped to a limit of 100:
#
# 						8 + (max_connections / 100)
#
# thread_handling
#
# 					cmd line format: 		--thread-handling=name
# 					Sys var: 				thread_handling
# 					Scope: 					Global
# 					Dynamic: 				No
# 					SET_VAR Hint: 			No
# 					Type: 					Enumeration
# 					Default: 				one-thread-per-connection
# 					Valid: 					no-threads, one-thread-per-connection, loaded-dynamically
#
# 					The thread-handling model used by the server for connection threads.
# 					The permissible values are:
#
# 					 no-threads (the server uses a single thread to handle one connection) (useful for debugging under Linux)
# 					
# 					 one-thread-per-connection (the server uses one thread to handle each client connection)
# 					 
# thread_pool_algorithm
#
# 					cmd line format: 		--thread-pool-algorithm=#
# 					introduced: 			8.0.11
# 					Sys var: 				thread_pool_algorithm
# 					Scope: 					Global
# 					Dynamic: 				No
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				0
# 					Min: 						0
# 					Max: 						1
#
# 					This var controls which algorithm the thread pool plugin uses:
#
# 						A value of 0 (the default) uses a conservative low-concurrency algorithm which is most well tested and stable.
#
# 						A value of 1 increases the concurrency and uses a more aggressive algo which at times can perform 5-10% better,
# 						on optimal thread counts, but has degrading performance as the number of connections increases. (Experimental, not supported)
#
# 					Available only if the thread pool plugin is enabled.
# 
# thread_pool_high_priority_connection
#
# 					cmd line format: 		--thread-pool-high-priority-connection=#
# 					Introduced: 			8.0.11
# 					Sys var: 				thread_pool_high_priority_connection
# 					Scope: 					Global, Session
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				0
# 					Min: 						0
# 					Max: 						1
#
# 					Affects queuing of new statements prior to execution.
#
# 					If the value is 0 (false, default) - statement queuing uses both the low-prio
# 					and high-prio queues.
#
# 					If the value is 1 (true), queued statements always go to the high prio queue.
#
# 					Only available if the thread pool plugin is enabled.
#
# thread_pool_max_unused_threads
#
# 					cmd line format: 		--thread-pool-max-unused-threads=#
# 					introduced: 			8.0.11
# 					Sys Var: 				thread_pool_max_unused_threads
# 					Scope: 					Global
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				0
# 					Min: 						0
# 					Max: 						4096
#
# 					Max permitted number of unused threads in the thread pool.
# 					This variable makes it possible to limit the amount of memory used by sleeping threads.
#
# 					A value of 0 (default) means no limit on the number of sleeping threads.
#
# 					A value of N where N is greater than 0, means 1 consumer thread and N-1 reserve threads.
#
# 					In this case, if a thread is ready to sleep but the number of sleeping threads is already at maximum,
# 					the thread exits rather than going to sleep.
#
# 					A sleeping thread is either sleeping as a consumer thread or a reserve thread.
# 					The thread pool permits one thread to be the consumer thread when sleeping.
#
# 					if a thread goes to sleep and there is no existing consumer thread, it will sleep as a consumer thread.
#
# 					When a thread must be woken up, a consumer thread is selected if there is one.
# 					A reserve thread is selected only when there is no consumer thread to wake up.
#
# 					Only available if the thread pool plugin is enabled.
#
# thread_pool_prio_kickup_timer
#
# 					cmd line format: 		--thread-pool-prio-kickup-timer=#
# 					Introduced: 			8.0.11
# 					Sys var: 				thread_pool_prio_kickup_timer
# 					Scope: 					Global, Session
# 					Dynamic: 				Yes
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				1000
# 					Min: 						0
# 					Max: 						<a lot>
#
# 					Affects statements waiting for execution in the low-prio queue.
# 					The value is the number of MS before a waiting statement is moved to the high-prio queue.
#
# 					Default is 1000 ms (1 sec). Range is 0 to 2^32-2
#
# 					Only available if thread plugin is enabled.
#
# thread_pool_size
#
# 					cmd line format: 		--thread-pool-size=#
# 					Introduced: 			8.0.11
# 					Sys var: 				thread_pool_size
# 					Scope: 					Global
# 					Dynamic: 				No
# 					SET_VAR Hint: 			No
# 					Type: 					Integer
# 					Default: 				16
# 					Min: 						1
# 					Max: 						64
#
# 					Number of thread groups in the thread pool. 
# 					This is the most important parameter controlling thread pool performance.
#
# 					It affects how many statements can execute simultaneously.
#
# 					Defaults to 16, with a range from 1 to 64. Must be within range, plugin won't load and a error is written to the log.
#
# 					Only available if the thread pool plugin is enabled.
#
# thread_pool_stall_limit
#
# 					cmd line format: 		--thread-pool-stall-limit=#
# 					Introduced: 			8.0.11
# 					Sys var: 				thread_pool_stall_limit
# 					Scope: 					Global
# 					Dynamic: 				Yes
## 				SET_VAR Hint: 			No
# 					Type: 					Integer
## 				Default: 				6
# 					Min: 						4
# 					Max: 						600
#
# 					Affects executing statements. 
#
# 					The value is the amount of time a statement has to finish after starting to execute before it becomes
# 					defined as stalled, at which point the thread pool permits the thread group to begin
# 					executing another statement.
#
# 					The value is measured in 10 milliseconds units, so a value of 6 (default),
# 					means 60ms.
#
# 					The range of values is 4 to 600 (40ms to 6s).
#
# 					Short wait values permits threads to start more quickly.
# 					Short values are also better for avoiding deadlock situations.
#
# 					Long wait values are useful for workloads that include long-running statements,
# 					to avoid starting too many new statements while the current ones execute.
#
# 					Only available if thread pool plugin is enabled.
#
# thread_stack
#
# 					cmd line: 			--thread-stack=#
# 					Sys var: 			thread_stack
# 					Scope: 				Global
# 					Dynamic: 			No
# 					SET_VAR Hint: 		No
# 					Type: 				Integer
# 					Default (64-bit)  262144
# 					Default (32-bit) 	196608
# 					Min: 					131072
# 					Max (64-bit) 		<a lot>
# 					Max (32-bit) 		<less>
#
# 					Block Size: 		1024
#
# 					The stack size for each thread. Default is 192KB (256KB for 64-bit Systems) is large enough for most ops.
#
# 					If the thread stack size is too small, it limits the complexity of the SQL statements that the server can handle,
# 					the recursion depth of stored procedures and other memory-consuming actions.
#
# time_format - Removed in 8.0.3
#
# time_zone 
#
# 					Sys var: 		time_zone
# 					Scope: 			Global, Session
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	No
# 					Type: 			String
#
# 					The current time zone. 
#
# 					This variable is used to initialize the time zone for each client that connects.
# 					By default, the initial value of this is 'SYSTEM' (basically use the system_time_zone)
#
# 					Can be specified explicitly at server startup with the --default-time-zone option.
#
# 					NOTE: If set to SYSTEM, every MySQL function call that requires a timezone calc, makes a system lib call to find out the
# 							current system timezone. May be protected by a global mutex, resulting on contention.
#
# timestamp
#
# 					Sys var: 		timestamp
# 					Scope: 			Session
# 					Dynamic: 		Yes
# 					SET_VAR Hint: 	Yes
# 					Type: 			Numeric
#
# 					Set the time for this client. 
#
# 					This is used to get the original timestamp if you use the binary log to restore rows.
# 					<timestamp_value> should be a Unix epoch timestamp (a value like that returned by UNIX_TIMESTAMP() - not a 'YYYY-MM-DD hh:mm:ss'),
# 					or DEFAULT.
#
# 					
#
# 							
# 			
#
#
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html