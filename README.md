Task manager
=====================
2016-10-20




A task manager for your daily tasks.






What is it?
-------------------------

Task manager helps you organize your tasks.

- put all your tasks in the same directory
- navigate your scripts structure via a simple gui interface
- execute your scripts via the simple gui interface


The simple benefits are:

- it's easy to call a task
- to reorganize the task structure, just reorganize the file structure




How does it work?
----------------------

You create a tasks folder in your home and put all your scripts in it.

You can create subdirectories, which represents categories of tasks.

Then you launch taskmanager

```bash
tm
```

It will list the items (directories or tasks) in the tasks directory (direct children) and associate them with one number for you to pick.


- select a directory item to list the content of that directory. This is a recursive process
- select a task item to execute the script





Ideas for organizing your tasks
------------------------------------------



### per task style

- cd/ 
	- nginx conf dir
	- php conf dir
	- php-fpm conf dir 
	- mySite home
	- mySite2 home
- edit/
	- nginx conf
	- php conf 
	- php-fpm conf 
	- mySite index
	- mySite xxx script
- tail/ 
	- nginx error logs 
	- nginx access logs 
	- mySite nginx access logs 
	- mySite nginx error logs 
- mySite/
	- show last 50 entries of the database
	- validate last entries in the database
	- validator script
- backups
	- backup mySite
	- backup mySite2
- others 
	- todo list
- exit


### per site style

- open/ 
	- nginx conf dir
	- nginx conf
	- php conf dir
	- php conf 
	- php-fpm conf dir 
	- php-fpm conf 
- tail/ 
	- nginx error logs 
	- nginx access logs 
- mySite/
	- show last 50 entries of the database
	- validate last entries in the database
	- validator script
	- open mySite index
	- open mySite xxx script
	- mySite nginx access logs 
	- mySite nginx error logs 
	- backup mySite
- others 
	- todo list
- exit




The different types of task items
----------------------------------------

There are four types of task items that you can create, differentiated by their file extension:

- sh: the item is executed in a subshell
- source: the item is sourced from the current shell
- loc: the file contains a path for task manager to cd into
- edit: the file contains a path for task manager to open (with the configured editor, vim by default)


Once the task item is executed, task manager exits.

Note: If a task is of type sh, and it's not executable yet, task manager will automatically ask you can make it you want to make it executable, thus saving you to type a chmod command.








Install
--------------

The goal is that when you type tm in a terminal, it sources the task manager.

Sourcing is required (just executing the task manager is not enough) to allow operations like changing the current directory of the current shell.


1. Download the tm.sh script.

2. Create the alias.
Open your .bashrc (linux) or .bash_profile (mac) and add the following line:

alias tm='source "/path/to/tm.sh"'






Configuration
------------------

You can change taskManager's behaviour by creating a _config file at the tasks directory's root.
The _config file consists of a list of key=value pairs, one per line.

The available key/value pairs are located at the beginning of the tm.sh script, in the "VARS FOR USER" section.

You can override a lot of the visual aspect of task manager.

So for instance, to override the default banner text (Welcome to Task Manager),
add the following in your _config file.

```bash
BANNER="Yo, I'm the TaskManager, what's up?"
```

An useful key is the TM_EDITOR key, which defines the editor to open the .edit files.

The default value is vim, but you can set it to pico, emacs or any other editor.





Nomenclature
------------------

A taskManager displays a **list** of **items**.

An **item** can be either a **task** item or a **directory** item.









