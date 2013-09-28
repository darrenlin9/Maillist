#!/bin/bash
#
#Darren Lin
#
#This shell script takes a given CRN (course registration number), 
#produces a file containing the email addresses of the members of 
#the class, and outputs statistics about the class. 
#
#Either one or two arguments are expected, an optional
#"quiet" option and a CRN number. The '-q' option
#silences all ouput and "quietly" creates the file if possible.
#
#Examples: maillist -q 09752
#	   OR
#	   maillist 20491
#
#The shell script will, by default, ouput the number of students
#and faculty, as well as the CRN and group id. A file containing
#the emails will be created in the current directory.
#
#A valid CRN is expected, as well as write permissions in the current 
#directory.
#

usage(){
echo "Error. Usage: maillist [-q] CRN number"
exit 1
}

quietUsage(){
exit 1
}

quiet=
CRN=
students=0
faculty=0

#
#Checks for correct # of arguments and assigns appropiate variables.
#

if [ $1 = '-q' ]
then
	quiet=true
	shift
else
	quiet=false
fi

if [ $# -ne 1 ] 
then
	if [ $quiet = 'false' ]
	then
		usage
	else
		quietUsage
	fi
else
	CRN=$1
fi

if echo $CRN | grep -q '^[0-9][0-9][0-9][0-9][0-9]$'
then
	:
else
	if [ $quiet = 'false' ]  
	then
		usage
	else
		quietUsage
	fi
fi

if cat /etc/group | grep -q "^c$CRN:" 
then
	:
else
	if [ $quiet = 'false' ]
	then
		echo "Error. $CRN not found in /etc/group."
	fi
	exit 1
fi

#
#Extracts and formats a listing of the people in the class
#into the mlist variable. The group id is placed into the
#groupid variable.
#

mlist=$(cat /etc/group | grep "^c$CRN:" | cut -d: -f4 | tr ',' '\n')
groupid=$(cat /etc/group | grep "^c$CRN:" | cut -d: -f3)

if [ ! -w . ]
then
	if [ $quiet = 'false' ]
	then
		echo "Error. You do not have write permissions to this directory."
	fi
	exit 1
fi 

#
#Parses through $mlist and checks whether if each individual is located in
#/students, then acts accordingly.
#

rm -f "$CRN"

for arg in $(echo $mlist)
do
	temporary=$(ls /students | grep "^$arg$")
	if [ -n "$temporary" ]
	then
		echo $arg@mail.ccsf.edu >> $CRN
		students=$((students + 1))
	else
		echo $arg@ccsf.edu >> $CRN
		faculty=$((faculty + 1))
	fi
done

#
#If the quiet option was not found, output data.
#

if [ $quiet = 'false' ] 
then
	echo "There are $students students and $faculty faculty in the group."
	echo "Group name: c$CRN"
	echo "Group id: $groupid"
	echo "A file containing a list of the emails can be found in $PWD."
fi
exit 0

