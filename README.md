# CompileQB64
Shell script to streamline compiling QB64 in a terminal session

This script will compile a QB64 program via the terminal (command line). It allows you to pass additional compiler switches as well as the directory and program source.

This script runs on Linux, and a Window's and MAC versions are in the works. 

Some usage conventions are required to use this script:
   1) You need to update your PATH variable to where the qb64 binary resides (in Linux, it is in the /etc/environment file)
   2) Currently this may not work as ROOT for Linux users (There are issues if qb64 is executed from a ROOT directory)
   
This is what my file "environment" looks like with the qb64 directory added (for example):
   PATH="/home/<directory to>/qb64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
   
Once you update your PATH, you will need to reboot your system for the changes to take effect.
   
This script will take up to 3 arguments, each proceeded by a switch, which tells the script where to place them. The switches are:
   -c (Provide additional compiler options besides the -c and -o)
   -d (The directory where both the binary will be created and where the source file is located)
   -p (The source file without the .bas extension - the script adds this)
   
   Note: The script has a -r switch. This is to replace the compiler options and will be implemented in Version 2.
   
The default compiler switches applied to all compiles are: -x and -o.
   -x                    Compile instead of edit and output the result to the console
   -o <output file>      Write output executable to <output file>

To see all the switches for qb64, you can use just "-c --help" with this script and it will display them in the terminal program.
   
The syntax for executing this script is:
   compileqb64.sh -c "compiler options" -d "source directory" -p "source code"
or:
   compileqb64.sh -c "--help"

For example:
   compileqb64.sh -c "-w -e" -d "/home/gjmcginn/SourceCode/basic" -p "Program Name"
   
This example adds -w and -e to the compiler options, sets up the directory, and provides the <file> to be compiled. Things to remember:
   1) If there are more than one compiler options, they must be enclosed in quotes
   2) If either your directory or file name has spaces, they too must be enclosed in quotes. (You can always use quotes,regardless)
   3) Do not add the / at the end of the directory name from -d. The script will do this for you.
   
You can also provide all the compiler options by using the -r option:
   compileqb64.sh -r "-x -w -e" -d "source directory" -p "source code"
  
This will replace all the compiler options with only the ones you provide (-r is for replace)
   
You can also omit the -d "source directory". The script will use the current working directory that you are in in terminal. Since the script 
does check to see if your source code exists (or the directory exists), you must be in it prior to starting the script.
   
The last thing you can do is to provide just the directory and/or source code, and the script will launch the QB64 IDE and load your program in
it for editing and compiling/execution from the IDE.

The script performs error checking, and will display in the terminal program its progress. The script, based on what was passed, 
will build and execute the compile statment.The script does a check to see if the source file exists. If it does, it completes the compile. 
If the directory or file does not exist, it errors out.
