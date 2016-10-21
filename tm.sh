#!/usr/bin/env bash

#------------------------------
# TASK MANAGER
# lingtalfi - 2016-10-20
#------------------------------


#------------------------------
# VARS FOR USER
#------------------------------
# format codes: http://misc.flogisoft.com/bash/tip_colors_and_formatting
# or here: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
BANNER="Welcome to Task Manager"
BANNER_FORMAT_CODE="\e[34m"; # blue

BANNER2="Task Manager -- (ctrl+c to exit)"
BANNER2_FORMAT_CODE="\e[34m"; # blue

SUB_BANNER="Ctrl+c to exit\n"; 
SUB_BANNER_FORMAT_CODE="\e[39m"; # regular

GO_BACK_ITEM=".."; 
GO_BACK_ITEM_FORMAT_CODE="\e[35m"; # purple

TASK_FILE_EXTENSIONS="sh source loc edit" # space separated list of extensions
LABELIZE_TASK_FORMAT_CODE="\e[39m" # default foreground color



LABELIZE_DIRECTORY_TRAILING_CHARS="/" # chars to append to a directory
LABELIZE_DIRECTORY_FORMAT_CODE="\e[32m" # green 

SELECT_WRONG_CHOICE="Unknown choice, please try again"
SELECT_WRONG_CHOICE_FORMAT_CODE="\e[31m" # red


NOW_INSIDE_DIR_TEXT="Now inside " 
NOW_INSIDE_DIR_TEXT_FORMAT_CODE="\e[39m" # default foreground color
NOW_INSIDE_DIR_BREADCRUMB_PREFIX="[TASKS]" 

PS3=$'\n'"What task should I execute, master? "


ON_TASK_EXECUTED_AFTER_TEXT="Task Manager: The script has been executed"
ON_TASK_EXECUTED_AFTER_TEXT_FORMAT_CODE="\e[34m"

MAKE_IT_EXECUTABLE_TEXT="Do you want to make it executable? (y/n) "
MAKE_IT_EXECUTABLE_TEXT_FORMAT_CODE="\e[34m"

NOW_IT_IS_EXECUTABLE_TEXT="Now file '_s_' is executable" # _s_ is replaced with the (now executable) file 
NOW_IT_IS_EXECUTABLE_TEXT_FORMAT_CODE="\e[34m"

PRESS_ANY_KEY_TO_CONTINUE="Press any key to continue..."
PRESS_ANY_KEY_TO_CONTINUE_FORMAT_CODE="\e[35m"

TM_EDITOR="vim"


#------------------------------
# VARS FOR TASK MANAGER
#------------------------------
# Note: it's better to keep the tasks directory in the user dir
# because then the user can open multiple tmux windows (for instance),
# and just type vm in each window to access her tasks
TASKS_DIR_HOME="$HOME" # the directory that contains the tasks dir
TASKS_DIR_NAME="tasks" # the name of the tasks dir
PROGRAM_NAME="task manager"
ORIGINAL_IFS="$IFS"
FORMAT_END="\e[0m"
CURRENT_DIR="" # will be updated as the user goes down/up the task structure
NB_COLUMNS=1 # number of columns spanned by the select function





#------------------------------
# PRE-PROCESS
#------------------------------
# overriding TASKS_DIR_HOME? (mainly for testing purpose)
ORIGINAL_DIR="$(pwd)"
ORIGINAL_DIR_LEN="" # set later on
if [ -n "$1" ]; then
	TASKS_DIR_HOME="$1"
fi
TASKS_DIR="$TASKS_DIR_HOME/$TASKS_DIR_NAME"
CURRENT_DIR="$TASKS_DIR"
_t=$(which sudo)
HAS_SUDO='true'
if [ "" = "$_t" ]; then
	HAS_SUDO='false'
fi



#------------------------------
# FUNCTIONS
#------------------------------
function error {
	echo -e "\e[01;31m$PROGRAM_NAME: $1$FORMAT_END"
}

function parseConfig {
	file="$TASKS_DIR/_config"
	if [ -f "$file" ]; then
		source "$file"
	fi
}

function isConfigFile {
	if [ "$1" = "_config" ]; then
		echo "true"
	else
		echo "false"
	fi
}


function hasTaskExtension {
	fileExt="$(getFileExtension "$1")"
	hasExt="false"
	IFS=" "
	for ext in $TASK_FILE_EXTENSIONS
	do
		if [ "$fileExt" = "$ext" ]; then
			hasExt="true"
		fi
	done
	echo "$hasExt"
}

function getFileExtension {
	if grep -q '\.' <<<"$1"; then
		echo "${1##*.}"
	else
		echo ""
	fi
}


function endsWith {
    if grep -q "$2""$" <<<"$1"; then
        echo 'true'
    else
        echo 'false'
    fi
}

function substr {
	if [ -n "$3" ]; then
		echo ${1: $2: $3}
	else
		echo ${1: $2}
	fi
}


function isItem {
	if [ -d "$1" ]; then
		echo "true"
	else
		echo "false"
	fi
}

function labelizeTask {
	file="$1"
	echo "$LABELIZE_TASK_FORMAT_CODE$file$FORMAT_END"
}

function labelizeDirectory {
	file="$1"
	echo "$LABELIZE_DIRECTORY_FORMAT_CODE$file$LABELIZE_DIRECTORY_TRAILING_CHARS$FORMAT_END"
}


function strlen {
	echo ${#1} 
}

function replace {
	echo "${3/$1/$2}"
}


function restoreIfs {
	IFS="$ORIGINAL_IFS"
}

#------------------------------
# HANDLING THE USER'S CHOICE
#------------------------------
# define the actual lengths as seen by the select command below 
# (we use them to unformat the formatted/labelled task items and dir items)
with_e_format_end_length=$(strlen $(echo -e $FORMAT_END))
with_e_labelize_directory_format_code_length=$(strlen $(echo -e $LABELIZE_DIRECTORY_FORMAT_CODE))
with_e_labelize_task_format_code_length=$(strlen $(echo -e $LABELIZE_TASK_FORMAT_CODE))
with_e_go_back=$(echo -e $GO_BACK_ITEM_FORMAT_CODE$GO_BACK_ITEM$FORMAT_END)
trailingCharsLen=$(strlen $LABELIZE_DIRECTORY_TRAILING_CHARS)
tasksDirLen=$(strlen $TASKS_DIR)
ORIGINAL_DIR_LEN=$(strlen $ORIGINAL_DIR)


# collection collectItems ( dir )
# collection: string, list of \n separated prefixed items
# a file is prefixed with f
# a dir is prefixed with d
# prefixing allows us to format (add color to) the dir or the file 
function collectItems {
	items=""
	pos=$(( $(strlen $1) + 1 ))
	for file in "$1/"*
	do

			fileName=$(substr "$file" "$pos")
			if [ "false" = $(isConfigFile "$file") ]; then
				if [ -d "$file" -o "true" = $(hasTaskExtension "$fileName") ]; then
					
					# labelize the file name
					if [ -d "$file" ]; then
						fileName=$(labelizeDirectory "$fileName")
					else
						fileName=$(labelizeTask "$fileName")
					fi

					# append the file name to the list of items to display
					if [ -z "$items" ]; then
						items="$fileName"
					else
						items="$items\n$fileName"
					fi
				fi
			fi
	done
	echo "$items"
}


function handleItems {
	IFS=$'\n'
	theItems="$1"
	COLUMNS=$NB_COLUMNS
	select FILENAME in $(echo -e "$theItems");
	do
		if [ -n "$FILENAME" ]; then

			# is it the go back reply?
			if [ "$with_e_go_back" = "$FILENAME" ]; then
				handleGoBack
			else
				# remove the suffix (FORMAT_END) part
				fileNameLength=$(strlen "$FILENAME") # with e because of the way it was passed to the select command
				endBeginOffset=$(( $fileNameLength - $with_e_format_end_length ))
				FILENAME=$(substr "$FILENAME" 0 "$endBeginOffset")			

				# if it ends with the LABELIZE_DIRECTORY_TRAILING_CHARS,
				# I consider that the item is a dir
				# the obvious flaw of this technique is that if a regular file ends
				# with the LABELIZE_DIRECTORY_TRAILING_CHARS, it will be considered as a dir,
				# but for now, I'm okay with that, assuming that this will be a rare case,
				# and/or it could be stated in the doc so that users don't append 
				# LABELIZE_DIRECTORY_TRAILING_CHARS to their filename.
				if [ 'true' = $(endsWith "$FILENAME" "$LABELIZE_DIRECTORY_TRAILING_CHARS") ]; then
					# if it's a dir

					# now remove prefix part to get the original string back
					FILENAME=$(substr "$FILENAME" "$with_e_labelize_directory_format_code_length")

					# don't forget to remove the trailing chars
					fileNameLen=$(strlen "$FILENAME")
					endPos=$(( $fileNameLen - $trailingCharsLen ))
					FILENAME=$(substr "$FILENAME" 0 $endPos)


					handleDirItem "$FILENAME"
					

				else 
					# if it's a file

					# now remove prefix part to get the original string back
					FILENAME=$(substr "$FILENAME" "$with_e_labelize_task_format_code_length")
					handleFileItem "$FILENAME"
					
				fi
			fi
		else
			echo -e $SELECT_WRONG_CHOICE_FORMAT_CODE$SELECT_WRONG_CHOICE"\e[0m"
			pressAnyKeyToContinue
			openDir 
		fi

		break
	done
	
}

function handleDirItem {
	dirSegment="$1"
	newDir="$CURRENT_DIR/$dirSegment"
	if [ -d "$newDir" ]; then
		CURRENT_DIR="$CURRENT_DIR/$dirSegment"
		openDir		
	else
		error "Unable to navigate to directory '$newDir', directory not found"
	fi
}

function pressAnyKeyToContinue {
	echo -e "$PRESS_ANY_KEY_TO_CONTINUE_FORMAT_CODE$PRESS_ANY_KEY_TO_CONTINUE$FORMAT_END"
	read -s -n 1 key
}

function needExecutePermission {
	ret='false'
	if [ "sh" = "$1" ]; then
		ret="true"
	fi
	echo "$ret"
}

function handleFileItem {
	local taskWasCancelled='false'
	file="$CURRENT_DIR/$1"

	if [ -f "$file" ]; then
		
		fileExt=$(getFileExtension "$file")
		needExecute=$(needExecutePermission "$fileExt")


		if [ "true" = "$needExecute" ]; then
			if ! [ -x "$file" ]; then
				# not executable
				taskWasCancelled='true'

				error "file '$file' is not executable"

				if [ 'true' = "$HAS_SUDO" ]; then
					# do we make it executable?
					echo -e "$MAKE_IT_EXECUTABLE_TEXT_FORMAT_CODE$MAKE_IT_EXECUTABLE_TEXT$FORMAT_END"
					read -s -n 1 key
					if [ 'y' = "$key" ]; then
						sudo chmod u+x "$file"
						nowText="$(replace "_s_" "$file" "$NOW_IT_IS_EXECUTABLE_TEXT")"
						echo -e "$NOW_IT_IS_EXECUTABLE_TEXT_FORMAT_CODE$nowText$FORMAT_END"
						pressAnyKeyToContinue
						taskWasCancelled='false'	
					fi
				fi

				if [ 'true' = "$taskWasCancelled" ]; then
					error "Couldn't execute script '$file'"
					pressAnyKeyToContinue

					openDir 

				fi
			fi
		fi
		

		if [ 'false' = "$taskWasCancelled" ]; then
			case "$fileExt" in
				"sh" )
					"$file"
				;;
				"source" )
					source "$file"
				;;
				"loc" )
					dest="$(cat "$file")"
					if [ -d "$dest" ]; then
						cd "$dest"
						echo "you are now in $dest"
					else
						error "'$dest' is not a valid directory; defined in '$file'"
					fi
				;;
				"edit" )
					target="$(cat "$file")"
					if [ -f "$target" ]; then
						"$TM_EDITOR" "$target"
					else
						error "'$target' is not a valid file, defined in '$file'"
					fi	
				;;
				*)
					error "Don't know how to handle a script with extension '$fileExt' yet, please teach me. Bye for now."
					taskWasCancelled='true'
	   			;;
			esac
			if [ 'false' = "$taskWasCancelled" ]; then
				echo -e "$ON_TASK_EXECUTED_AFTER_TEXT_FORMAT_CODE$ON_TASK_EXECUTED_AFTER_TEXT$FORMAT_END"
			fi
		fi

	else
		error "file not found: '$file'"
	fi
}


function getCurrentRelativeDir {
	substr "$CURRENT_DIR" "$tasksDirLen"
}

function openDir {
	clear
	breadCrumb=$(getCurrentRelativeDir)
	echo -e "$BANNER2_FORMAT_CODE$BANNER2$FORMAT_END"
	echo ""
	echo -e "$NOW_INSIDE_DIR_TEXT_FORMAT_CODE$NOW_INSIDE_DIR_TEXT$LABELIZE_DIRECTORY_FORMAT_CODE$NOW_INSIDE_DIR_BREADCRUMB_PREFIX$breadCrumb$LABELIZE_DIRECTORY_TRAILING_CHARS$FORMAT_END"
	echo ""

	items="$(collectItems "$CURRENT_DIR")"

	# add the goback item if it's not the root directory
	if [ "$TASKS_DIR" != "$CURRENT_DIR" ]; then
		items="$GO_BACK_ITEM_FORMAT_CODE$GO_BACK_ITEM$FORMAT_END\n$items"
	fi
	handleItems "$items"
}

function handleGoBack {
	newDir="$(dirname "$CURRENT_DIR")"
	if [ -d "$newDir" ]; then
		CURRENT_DIR="$newDir"
		openDir		
	else
		error "Unable to navigate to parent directory '$newDir', directory not found"
	fi
}

#------------------------------
# STARTING THE TM SCRIPT
#------------------------------
clear
if [ -d "$TASKS_DIR" ]; then


	#------------------------------
	# PARSE THE CONFIG
	#------------------------------
	parseConfig 


	 #------------------------------
	 # DISPLAYING THE LIST OF ITEMS
	 #------------------------------
	echo -e "$BANNER_FORMAT_CODE$BANNER$FORMAT_END"
	echo -e "$SUB_BANNER_FORMAT_CODE$SUB_BANNER$FORMAT_END"


	items="$(collectItems "$TASKS_DIR")"
	handleItems "$items"

else
	error "'$TASKS_DIR_NAME' directory not found in '$TASKS_DIR_HOME'"
fi





