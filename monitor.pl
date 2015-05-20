use LWP::Simple;
#use strict;

################### IMPORTANT VERIABLES ##################################################### 
require "config.pl";
################### IMPORTANT HTML ##################################################### 
require "html.pl";
#############################################################################################
################### SCRIPT BEGINNING ########################################################  

##Negative values mean alert sound will play. After a sound plays set a positive number for cycles to "timeout"
my $soundMuteCountCycle = -1;
our $clusterDown = false; 

#############################################################################################
################### SCRIPT  SUBS ############################################################
sub pharsCluster{
	my $clusterInfo = $_[0];
	chomp $clusterInfo;
	(our $cluster,our $url ,my $newCol,my $image) = split(',',$clusterInfo);
	if($newCol eq "newCol" || $newCol eq "break"){
		## Break column by closing div and opening a new one
		$buildFinalPage = $buildFinalPage . '<BR></div></td><td width="157px"> <div style="overflow:hidden; width:157px;">';
	}
	##Create LWP Object, Set timeout, get url content
	our $content = "";
	my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
	my $response = $ua->get($url);
    if ($response->is_success) {
		$content = $response->decoded_content;
    }else{
		print "\n" . $response->status_line . "\n";
		$buildFinalPage = $buildFinalPage ."\n<BR><H2>".$cluster."<BR>See Error <BR> in console<\/H2>\n<BR>";
		return;
	}
	# Remove all new lines from code for easier parsing
    $content =~ s/[\n\r]//g;
	my $version = getVersion();
	#if($version eq "1.4.15" || $version eq "1.4.21" || $version eq "1.4.22"){
	#	pharsV1_4_X();
	#}elsif($version eq "1.5.2"){
	#	pharsV1_5_X();
	#}
    pharsV1_4_X();
}

###############

sub getVersion{
	if($content =~ m/.*?HAProxy version (.*?\..*?\..*?),.*?/){
	return $1
	}
	
}

###############

sub pharsV1_4_X{
	# Locate haproxy http table and cut it from the rest of the html
    if($content =~ m/.*?<\/tr>(<tr class="frontend">.*?)<tr class="backend">.*?/) {
	  #Close table before "backend" section
	  my $table = $1 . "</tr></table>";
	  #Replace word "Frontend" with the cluster name, and add background image\flag in case one is supplied (soon)
	  $table =~ s/>Frontend</><H2><a STYLE="color:black; text-decoration:none;" href=$url>$cluster<\/a><\/H2></;
	  #Add to final page
   	  $buildFinalPage = $buildFinalPage . "\n" . "<table class=\"tbl\" width=\"100%\"> " . $table . "\n";
	  #Update perl console that a cluster was successfully parsed 
      print "found " . $cluster . "\n";
    }else{
	  #If url was unresponsive or couldn't find the pattern in the hxproxy page do this
	  #Update perl console that a cluster was not successfully parsed
      print "ERROR! Cluster: " . $cluster . " not responding\n";
	  #Update page that hxproxy list was not\did not response
	  $buildFinalPage = $buildFinalPage ."\n<BR><H2>".$cluster."<BR>NOT FOUND!<\/H2>\n<BR>";
    }
}

###############

sub pharsV1_5_X{
	# Locate haproxy http table and cut it from the rest of the html
    if($content =~ m/.*?<\/tr>(<tr class="frontend">.*?)<tr class="backend">.*?/) {
	  #Close table before "backend" section
	  my $table = $1 . "</tr></table>";
	  #Replace word "Frontend" with the cluster name, and add background image\flag in case one is supplied (soon)
	  $table =~ s/>Frontend</><H2><a STYLE="color:black; text-decoration:none;" href=$url>$cluster<\/a><\/H2></;
	  #Add to final page
   	  $buildFinalPage = $buildFinalPage . "\n" . "<table class=\"tbl\" width=\"100%\"> " . $table . "\n";
	  #Update perl console that a cluster was successfully parsed 
      print "found " . $cluster . "\n";
    }else{
	  #If url was unresponsive or couldn't find the pattern in the hxproxy page do this
	  #Update perl console that a cluster was not successfully parsed
      print "ERROR! Cluster: " . $cluster . " not responding\n";
	  #Update page that hxproxy list was not\did not response
	  $buildFinalPage = $buildFinalPage ."\n<BR><H2>".$cluster."<BR>NOT FOUND!<\/H2>\n<BR>";
    }
}

###############

sub playAlerts{
	if($buildFinalPage =~ m/DOWN/){
		if($soundMuteCountCycle<0){
			$soundMuteCountCycle = $soundMuteXCycles;
			use Win32::Sound;
			Win32::Sound::Volume('50%');
			Win32::Sound::Play("blackhawkdown.wav");
			sleep(5);
			Win32::Sound::Stop();
		}
	}
	print "\nSleping 5 seconds \n";
	sleep(5);
}

##############

sub outputResult{
	#open output file and write to it
	open(my $fh3, '>', $outputPath)or die "Could not open file '$outputPath' $!";
	print $fh3 "" . $buildFinalPage . $signature . $tail ;
	close $fh;
	close $fh3;
}

#############################################################################################
################### SCRIPT BEGINNING ######################################################## 

while(true){
$soundMuteCountCycle--; 
open(my $fh, '<:encoding(UTF-8)', $machinePath)or die "Could not open file '$machinePath' $!";

## Set page with header + script run time ##
our $buildFinalPage = $header . '<H3>Check Time:'.localtime().'</H3><tr style="vertical-align: top;"><td width="157px"> <div style="overflow:hidden; width:157px; vertical-align: top;">';
## for each hxproxy instance in list
while (my $row = <$fh>) {
	pharsCluster($row);
}

 outputResult();
 playAlerts();
 

}

 
 
 
 
  
