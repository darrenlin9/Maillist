Maillist
========
##Darren Lin

This shell script takes a given CRN (course registration number), 
produces a file containing the email addresses of the members of 
the class, and outputs statistics about the class. 

Either one or two arguments are expected, an optional
"quiet" option and a CRN number. The '-q' option
silences all ouput and "quietly" creates the file if possible.

Examples: maillist -q 09752
	   OR
	   maillist 20491

The shell script will, by default, ouput the number of students
and faculty, as well as the CRN and group id. A file containing
the emails will be created in the current directory.

A valid CRN is expected, as well as write permissions in the current 
directory and read access to /etc/students and /etc/groups.
