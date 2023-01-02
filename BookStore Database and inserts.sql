create database bookstores;
use bookstores;
    
drop table if exists EMPLOYEE; 
create table EMPLOYEE (
	emp_ID int primary key auto_increment,
    emp_fname varchar(50) not null,
	emp_lname varchar(50) not null,
	emp_email varchar(50) not null,
	emp_type varchar(3) #left not null because employee can be other than M/S (in the future maybe)
    );
insert into EMPLOYEE values (1000, 'Bob', 'Marley', 'bobmarley@adbooks.com', 'M');
insert into EMPLOYEE (emp_fname,emp_lname,emp_email,emp_type) values ('Hans','Solo', 'hansalone@adbooks.com', 'S');
insert into EMPLOYEE (emp_fname,emp_lname,emp_email,emp_type) values ('Snoop','Dog', 'snoopdog@adbooks.com', 'S');
insert into EMPLOYEE (emp_fname,emp_lname,emp_email,emp_type) values ('Greta','Thunberg', 'gretathun@adbooks.com', 'S');
insert into EMPLOYEE (emp_fname,emp_lname,emp_email,emp_type) values ('Nelson','Mandela', 'nelsontheman@adbooks.com', 'M');
insert into EMPLOYEE (emp_fname,emp_lname,emp_email,emp_type) values ('Darth','Vader', 'iamurfather@adbooks.com', 'M');


drop table if exists MANAGER;
create table MANAGER(
	emp_ID int references EMPLOYEE(emp_ID),
    man_salary decimal(8,2),
    primary key (emp_ID)
	);
insert into MANAGER values (1000, 2000);    #need to find a way to ensure only M Ids are added - so far this is manually handled
insert into MANAGER values (1004, 2200); 
insert into MANAGER values (1005, 2300); 


drop table if exists LOCATION;
create table LOCATION (
	phone_number char(12) primary key,
    emp_ID int references MANAGER(emp_ID),
    location varchar(200) not null,
	starting_hour time, 
    closing_hour time, 
	loc_type varchar(3) not null
    );
insert into LOCATION values ('050653968511', 1000, 'Sheikh Zayed Road', '08:00:00','22:00:00', 'S');
insert into LOCATION values ('050653968522', 1004, 'Al Quoz', '06:00:00','17:00:00', 'W');
insert into LOCATION values ('050653968501', 1005, 'Barsha', '08:00:00','22:00:00', 'S');

# similar design choice issues regarding modelling of inheritance ... so far this is the closest to the ERD 

drop table if exists WAREHOUSE;
create table WAREHOUSE(
	phone_number char(12) references LOCATION(phone_number),
    primary key (phone_number)
	);
insert into WAREHOUSE values ('050653968522');


drop table if exists STORE;
create table STORE(
	phone_number char(12) references LOCATION(phone_number),
    primary key (phone_number)
	);
insert into STORE values ('050653968511');
insert into STORE values ('050653968501');


drop table if exists SALES_ASSISTANT;
create table SALES_ASSISTANT(
	emp_ID int references EMPLOYEE(emp_ID),
    assist_salary DECIMAL(8,2) not null,
    phone_number char(12) references LOCATION(phone_number),
    primary key (emp_ID)
	);
insert into SALES_ASSISTANT values (1001, 500, '050653968511'); 
insert into SALES_ASSISTANT values (1002, 500, '050653968511'); 
insert into SALES_ASSISTANT values (1003, 500, '050653968522'); # testing: this assistant is assigned to warehouse (050653968522)


drop table if exists MEMBERS; #unique constraint put on username
create table MEMBERS (
	mem_ID int primary key auto_increment,
    username varchar(50) not null unique, 
    pwd varchar(70) not null, 
    pay_info char(16) not null, 
	mem_fname varchar(50) not null, 
	mem_lname varchar(50) not null, 
	mem_address varchar(200) not null, 
	mem_zip char(5) not null, 
	mem_email VARCHAR(256) not null,
    join_date  datetime default now()
    );
insert into MEMBERS (mem_ID, username, pwd, pay_info, mem_fname, mem_lname, mem_address, mem_zip, mem_email)  
	values (1, 'user1', 'pwd1', '1111111111111111', 'fmem1', 'lmem1', 'address 1', '11111', 'mem1@gmail.com');
# following does not specify mem_id as that autoincrements after 1st entry
insert into MEMBERS (username, pwd, pay_info, mem_fname, mem_lname, mem_address, mem_zip, mem_email) 
	values ('user2', 'pwd2', '2222222222222222', 'fmem2', 'lmem2', 'address 2', '22222', 'mem2@gmail.com');
insert into MEMBERS (username, pwd, pay_info, mem_fname, mem_lname, mem_address, mem_zip, mem_email) 
	values ('user3', 'pwd3', '3333333333333333', 'fmem3', 'lmem3', 'address 3', '33333', 'mem3@gmail.com');
insert into MEMBERS (username, pwd, pay_info, mem_fname, mem_lname, mem_address, mem_zip, mem_email) 
	values ('user4', 'pwd4', '4444444444444444', 'fmem4', 'lmem4', 'address 4', '44444', 'mem4@gmail.com');
insert into MEMBERS (username, pwd, pay_info, mem_fname, mem_lname, mem_address, mem_zip, mem_email) 
	values ('user5', 'pwd5', '5555555555555555', 'fmem5', 'lmem5', 'address 5', '55555', 'mem5@gmail.com');
    
drop table if exists PURCHASE;  
create table PURCHASE (
	purchase_ID int primary key auto_increment, 
	mem_ID int references MEMBERS(mem_ID), # does not have to be a member to place an order 
    phone_number varchar(12) references STORE(phone_number),
	purchase_date datetime not null,
	delivery_req char(1) not null,
	purchase_tot decimal(8,2) not null
    );
#non-member, online purchase 
insert into PURCHASE values (700010, NULL, NULL, '2022-11-11 13:23:44', 'Y', 129);
#non-member, in-store purchase 
insert into PURCHASE (mem_ID, phone_number, purchase_date, delivery_req, purchase_tot) values (NULL, '050653968511', '2022-11-29 11:23:44', 'N', 201);
#member, online purchase 
insert into PURCHASE (mem_ID, phone_number, purchase_date, delivery_req, purchase_tot) values (1, NULL, '2022-11-28 10:23:44', 'Y', 301);
#member, in-store purchase 
insert into PURCHASE (mem_ID, phone_number, purchase_date, delivery_req, purchase_tot) values (1, '050653968501', '2022-11-29 10:00:44', 'N', 20); #same member second day 



drop table if exists CUSTOMER; #iidentified as purchases made by non-members
create table CUSTOMER(
	purchase_ID int references PURCHASE(purchase_ID),
    cust_fname varchar(50) not null,
	cust_lname varchar(50) not null,
	cust_address varchar(200) not null,
	cust_zip char(5) not null,
	cust_email varchar(256) not null,
    primary key (purchase_ID)
    );
insert into CUSTOMER values (700010, 'cusfname1', 'cuslname1', 'c address 1', '12111', 'c1@gmail.com');
insert into CUSTOMER values (700011, 'cusfname2', 'cuslname2', 'c address 2', '12112', 'c2@gmail.com');


drop table if exists PUBLISHER;
create table PUBLISHER(
	pub_ID int primary key auto_increment,
	pub_name varchar(50) not null
	);
insert into PUBLISHER values (1, 'Penguin Random House');
insert into PUBLISHER (pub_name) values ('Hachette'); 
insert into PUBLISHER (pub_name) values ('Harper Collins');
insert into PUBLISHER (pub_name) values ('Simon & Schuster');
insert into PUBLISHER (pub_name) values ('Macmillan');


drop table if exists GENRE;
create table GENRE(
	gen_ID int primary key auto_increment,
	gen_name varchar(50) not null,
	gen_description varchar(200) not null
	);
insert into GENRE values (101, 'Romance', 'Books with an emotionally satisfying and often positive ending. These books take the reader on a journey where they become invested in the characters’ love story.'); 
insert into GENRE (gen_name, gen_description) values ('Crime / Mystery', 'Books that engulf the reader in the darker side of life.');
insert into GENRE (gen_name, gen_description) values ('Motivational', 'Self-help, personal improvement.');
insert into GENRE (gen_name, gen_description) values ('Science Fiction / Fantasy', 'Typically features the use of magic or other supernatural phenomena, dystopias, future settings.');
insert into GENRE (gen_name, gen_description) values ('Horror', 'Books meant to scare, startle, shock, and even repulse audiences.');
    
drop table if exists BOOK; 
create table BOOK (
	ISBN_ID char(13) primary key,
	gen_ID int references GENRE(gen_ID),
	pub_ID int references PUBLISHER(pub_ID),
	pub_date DATE not null, 
	bk_title varchar(100) not null,
	bk_description varchar(800), #only not null!
	bk_price decimal(8,2) not null, 
	bk_language varchar(80) not null
	);
insert into BOOK values ('1313131313131', 101, 1, '2022-7-04', 'Romance 1', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313132', 101, 2, '2021-7-04', 'Romance 2', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313133', 101, 3, '2020-7-04', 'Romance 3', 'xxxxxx', 20, 'Spanish');
insert into BOOK values ('1313131313134', 101, 4, '2019-7-04', 'Romance 4', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313135', 102, 1, '2018-7-04', 'Crime 1', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313136', 102, 2, '2017-7-04', 'Crime 2', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313137', 102, 3, '2016-7-04', 'Crime 3', 'xxxxxx', 20, 'English'); 
insert into BOOK values ('1313131313138', 103, 5, '2015-7-04', 'Motivational 1', 'xxxxxx', 20, 'Arabic'); # book with 2 authors 
insert into BOOK values ('1313131313139', 103, 4, '2014-7-04', 'Motivational 2', 'xxxxxx', 20, 'English'); # book with 3 authors 
insert into BOOK values ('1313131313140', 104, 1, '2022-7-04', 'Fantasy 1', 'xxxxxx', 20, 'English');
insert into BOOK values ('1313131313141', 101, 2, '2020-7-04', 'Horror 1', 'xxxxxx', 20, 'English');

drop table if exists AUTHOR;
create table AUTHOR(
	auth_ID int primary key auto_increment,
    auth_fname varchar(50) not null,
	auth_lname varchar(50) not null
    );
insert into AUTHOR values (1, 'Anna', 'Adams');
insert into AUTHOR (auth_fname, auth_lname) values ('Brenda', 'Brian');
insert into AUTHOR (auth_fname, auth_lname) values ('Clara', 'Cage');
insert into AUTHOR (auth_fname, auth_lname) values ('Dina', 'Drum');
insert into AUTHOR (auth_fname, auth_lname) values ('Edith', 'Evans');
insert into AUTHOR (auth_fname, auth_lname) values ('Farah', 'Fair');
insert into AUTHOR (auth_fname, auth_lname) values ('Georgia', 'Green');
insert into AUTHOR (auth_fname, auth_lname) values ('Hattie', 'Harlow');
insert into AUTHOR (auth_fname, auth_lname) values ('Irina', 'Ivankov');
insert into AUTHOR (auth_fname, auth_lname) values ('Julia', 'James');
insert into AUTHOR (auth_fname, auth_lname) values ('Katy', 'Kent');
insert into AUTHOR (auth_fname, auth_lname) values ('Linda', 'Long');
insert into AUTHOR (auth_fname, auth_lname) values ('Mandy', 'Moore');

    
drop table if exists BOOK_AUTHOR; #book with multiple authors test needed
create table BOOK_AUTHOR(
	ISBN_ID char(13) references BOOK(ISBN_ID),
    auth_ID int references AUTHOR(auth_ID),
	primary key (auth_ID, ISBN_ID) #composite key
    );
insert into BOOK_AUTHOR values ('1313131313131', '1');
insert into BOOK_AUTHOR values ('1313131313132', '2');
insert into BOOK_AUTHOR values ('1313131313133', '3');
insert into BOOK_AUTHOR values ('1313131313134', '4');
insert into BOOK_AUTHOR values ('1313131313135', '5');
insert into BOOK_AUTHOR values ('1313131313136', '6');
insert into BOOK_AUTHOR values ('1313131313137', '7');
insert into BOOK_AUTHOR values ('1313131313138', '8'); #auth1 same book
insert into BOOK_AUTHOR values ('1313131313138', '9'); #auth2
insert into BOOK_AUTHOR values ('1313131313139', '10'); #auth1 same book
insert into BOOK_AUTHOR values ('1313131313139', '11'); #auth2 
insert into BOOK_AUTHOR values ('1313131313140', '12'); 
insert into BOOK_AUTHOR values ('1313131313141', '13'); 


#davina has not updated these yet...
drop table if exists PURCHASE_LINE;
create table PURCHASE_LINE(
	purchase_line_ID int primary key auto_increment,
	purchase_ID int references PURCHASE(purchase_ID),
	ISBN_ID char(13) references BOOK(ISBN_ID),
	cust_price decimal(8,2) not null, #can we import fk bookprice(from BOOK) + add a % margin to this ?????? YES --> prof asked for this price list distinction 
	cust_quantity int not null
	);
    
#purchase 1
insert into PURCHASE_LINE values (); 
#purchase 2
#purchase 3
#purchase 4
    
drop table if exists STORE_ORDER;
create table STORE_ORDER(
	store_order_ID int primary key auto_increment,
	emp_ID int references MANAGER(emp_ID),
	emp_order_date DATE not null,
	total_store_price DECIMAL(8,2) not null
	);

drop table if exists STORE_ORDER_LINE;
create table STORE_ORDER_LINE(
	store_order_line_ID int primary key auto_increment,
	store_order_ID int references STORE_ORDER(store_order_ID),
    pub_ID int references PUBLISHER(pub_ID),
	phone_number varchar(12) references LOCATION(phone_number),
    store_price DECIMAL(8,2) not null,
	store_quantity INT not null
	);

    


