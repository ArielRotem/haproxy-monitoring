# haproxy-monitoring
##################################################################################
##################################################################################
This is my haproxy monitoring project, built from scratch.

While the script runs in the background, it parses all haproxy pages from the haproxy list machines.txt and 
generates an autorefreshing html page for monitoring all tables aesthetically and aliased in one place.  

Output should look like this*:
http://oi61.tinypic.com/121acub.jpg

##################################################################################
##################################################################################

Use Case 1:
Install perl on computer.
Double click monitoring.pl script , leave running in the background.
Double click the generated html file and leave it open. html page auto refreshes.

##################################################################################
##################################################################################

*with basic configuration and in the case where:
	a)Only the first table needs to be monitored
	b)First table is an http table with a "frontend" first line
	More flexible options in the future
	Contact me if you need anything specific
