# CompileQB64
Shell script to streamline compiling QB64 in a terminal session

This script will compile a QB64 program via the terminal (command line). It allows you to pass additional compiler switches as well as the directory and program source.

This script runs on Linux, and @SpriggsySpriggs has offered to create a Window's version of this. I will be testing this script on macOS, and will post that script here when it's done.

Some usage conventions are required to use this script:
   1) You need to update your PATH variable to where the qb64 binary resides (in Linux, it is in the /etc/environment file)
   2) Currently this may not work as ROOT for Linux users (There are issues if qb64 is executed from a ROOT directory)
   
This is what my file "environment" looks like with the qb64 directory added:
   PATH="/home/gjmcginn/qb64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
   
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
   compileqb64.sh -c "-w -e" -d "/home/gjmcginn/SourceCode/basic" -p "EBAC Calculator"
   
This example adds -w and -e to the compiler options, sets up the directory, and provides the <file> to be compiled. Things to remember:
   1) If there are more than one compiler options, they must be enclosed in quotes
   2) If either your directory or file name has spaces, they too must be enclosed in quotes. (You can always use quotes,regardless)
   3) Do not add the / at the end of the directory name from -d. The script will do this for you.

The script will do some rudimentary error checking, and will display in the terminal program its progress. The script, based on what was passed, 
will build and execute the compile statment.The script does a check to see if the source file exists. If it does, it completes the compile. 
If the directory or file does not exist, it errors out
