#!/bin/bash

#QB64 Compiler -- Shell Script -- George McGinn 2021
#Version 1.5 -- June 28, 2021
#
# compileqb64 - script to compile QB64 source code from any directory
#
# This script takes in up to 3 arguments for use in compiling QB64 from
# the command line. At least two arguments must be present to compile, 
# or the script will not work right. The arguments passed are:
#	-c Compiler Options (Add to default) (In quotes)
#   -r Compiler Options (Replace default) (In quotes)
#	-d Source Code/Object Directory Name
#	-p Program File Name (without the .bas extension)
#
# Syntax for compileqb64 is:
#	compileqb64 -c "compiler options" -d "source directory" -p "source code"
# or:
#   compileqb64 -c "--help"
#
# By using switches (-a, -d, -p) this script will parse out the argument
# values, and load the variables based on the values passed. Note that the
# script will append the .bas to the source code <filename>.
#
# Both switches -c and -r populate compiler options, but in a different way.
# The -c switch tells the script to "append" the arguments passed to the ones
# used as default (the -c and -o). 
#
# The -r tells the script to replace the default with the ones provided. This may be 
# used if you want to compile only to get the C++ code, or start the IDE with or 
# without a program loaded. (The -r will be put into a future version).
#
# If you use -c "--help" then the compiler will display the HELP text.
#
# The script, based on what was passed, will build and execute the compile statment.
# The script does a check to see if the source file exists. If it does, it completes
# the compile. If the directory or file does not exist, it errors out.
#
# The process in Version 1.x cannot run as ROOT and will need to be tested.
#

# FUNCTION: Test to see if the source code exists (True if the FILE exists and is a regular file (not a directory or device))
is_file() {
	if [ ! -f $FILE ];    
	then
		echo && echo "*** ERROR: $FILE does not exist. Please fix and retry. Script Terminated."
		exit 2
	fi
}

### Start of script

# Make sure we're not running as root (To be tested for future versions)
if [ $EUID == "0" ]; then
  echo "*** ERROR: You are trying to run this script as root. This is highly unrecommended. Script Terminated."
  exit 1
fi

echo "Starting QB64 Command Line Compiler..."
echo 

# Display the number of arguments passed and their values
echo "Number of arguments passed: $#"
echo "Arguments: $@"

# If no compiler options are found, display error message, qb64 help and terminate
if [ $# == 0 ]; then												
	echo "*** ERROR: No Compiler Options passed. Make sure you use one of the ones below. Script terminated."
	echo "qb64 --help"
	echo
	qb64 --help
	exit 1
fi

# Parse out the arguments based on associated switches
while getopts c:d:p:r: option
	do
	case "${option}"
		in
		c) compiler_options_append=${OPTARG} 
		   option_c=1;;
		r) 
		   compiler_options_replace=${OPTARG}
		   option_r=1;;
		d) source_directory=${OPTARG};;
		p) qb64_program=${OPTARG};;
	esac
done

# Build the QB64 Source and Object variables for qb64 command line
if [ "$compiler_options_append" == "--help" ] || [ "$compiler_options_replace" == "--help" ]; then	# Display and execute the qb64 compiler help text
	echo
	echo "qb64 --help"
	echo
	qb64 --help
else      												
	if [ "$source_directory" == "" ]; then				# If source directory isn't provided, then set current working directory as source directory   	
		source_directory="$PWD"
	fi
	qb64_object=$source_directory"/""$qb64_program"
	qb64_source=$source_directory"/""$qb64_program".bas
	FILE=$qb64_source
	is_file "$FILE"                                     # Check to make sure directory/file exists and is readable (not a device or directory only)
	echo
	if [ "$option_c" = 1 ]; then							# Display and the qb64 command line compiler options passed to script
		echo "Compiler Options (Append): "$compiler_options_append
	elif [ "$option_r" = 1 ]; then
		echo "Compiler Options (Replace): "$compiler_options_replace
	fi
	echo "Source Code Directory: "$source_directory
	echo "Object Filename: "$qb64_object
	echo "Source Code Filename: "$qb64_source
	echo 

# Logic to determine the type of process (compile or load QB64 IDE) and execute qb64 binary
	if [ "$compiler_options_append" == "" ] && [ "$option_c" != 1 ]; then   # Check for compiler_options_append equal to NULL, execute replace if so  
		if [ "$compiler_options_replace" == "" ]; then 			   		    # If compiler_options_replace is also NULL, then load source into QB64 IDE and edit
			echo "Editing (QB64 IDE) "$qb64_source" ..."
			qb64 "$qb64_source"
			exit 0										# Exit script after QB64 IDE shuts down
		else											# Execute replace compiler options
			echo "qb64 $compiler_options_replace -o $qb64_object $qb64_source"
			echo
			echo "Compiling "$qb64_source" ..."
			qb64 "$compiler_options_replace" -o "$qb64_object" "$qb64_source"
		fi
	else   												# Eexecute append compiler options
		if [ "$compiler_options_append" != "" ]; then
			echo "qb64 -x -w $compiler_options_append -o $qb64_object $qb64_source"
			echo
			echo "Compiling "$qb64_source" ..."
			qb64 -x -w "$compiler_options_append" -o "$qb64_object" "$qb64_source"
		else
			echo "qb64 -x -w -o $qb64_object $qb64_source"
			echo
			echo "Compiling "$qb64_source" ..."
			qb64 -x -w -o "$qb64_object" "$qb64_source"
		fi
	fi

# Check for successful compiled completion and display appropriate message
	if [ $? != 0 ]; then    						  	   
		echo ""
		echo "*** ERROR: Program did not compile successfully. Please fix and retry. Script Terminated."
		exit 1
	else
		echo
		echo "Program \"$qb64_program.bas\" compiled successfully."
	fi
fi
