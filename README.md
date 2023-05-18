# Shell-Script-DBMS
Bash Shell Script Database Management System (DBMS) :

The Project aim to develop DBMS, that will enable users to store and retrieve the data from Hard-disk.

## Table of Contents
- [Structure](#structure)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)

## Structure

The Project Features:
The Application will be CLI Menu based app, that will provide to user this Menu items:
Main Menu:
- Create Database
- List Databases
- Connect To Databases
- Drop Database

Upon user Connect to Specific Database, there will be new Screen with this Menu:
- Create Table 
- List Tables
- Drop Table
- Insert into Table
- Select From Table
- Delete From Table
- Update Table


## Installation
- make sure gawk is installed
- add the ansiColor.sh file to ~/.bashrc
- cd to the project root file ($cd Shell-Script-DBMS)
- open terminal in the current location
- run mainMenu.sh
- the app will start working in console

## Usage
- when the app starts, there will be 5 options in main menu.
- creating a database will create a directory with the database name.
- connecting to database will redirect the app to the database manage menu.
- upon creating a table, a file with the table name will be created in the current database directory.



