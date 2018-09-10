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
 

#https://dev.mysql.com/doc/refman/8.0/en/mysqld-multi.html

