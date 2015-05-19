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
while(true){
$soundMuteCountCycle--; 
open(my $fh, '<:encoding(UTF-8)', $machinePath)or die "Could not open file '$machinePath' $!";

## Set page with header + script run time ##
my $buildFinalPage = $header . '<H3>Check Time:'.localtime().'</H3><tr style="vertical-align: top;"><td width="157px"> <div style="overflow:auto; width:157px; vertical-align: top;">';
## for each hxproxy instance in list
while (my $row = <$fh>) {
	
	chomp $row;
	my $newCol = "";
	(my $cluster,my $url ,my $newCol,my $image) = split(',',$row);
	if($newLine eq "newCol"){
		## Insert new lines to hide bottom slider from sight
		## Break column by closing div and opening a new one
		$buildFinalPage = $buildFinalPage . '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR></div></td><td width="157px"> <div style="overflow:auto; width:157px">';
	}
	
	##Create LWP Object, Set timeout, get url content
	my $content = "";
	my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
	my $response = $ua->get($url);
    if ($response->is_success) {
		$content = $response->decoded_content;
    }else{
		print "\n" . $response->status_line . "\n";
	}

	# Remove all new lines from code for easier parsing
    $content =~ s/[\n\r]//g;
    # Locate haproxy http table and cut it from the rest of the html
    if($content =~ m/.*?<\/tr>(<tr class="frontend">.*?)<tr class="backend">.*?/) {
	  #Close table before "backend" section
	  my $table = $1 . "</tr></table>";
	  #Replace word "Frontend" with the cluster name, and add background image\flag in case one is supplied (soon)
	  $table =~ s/>Frontend</><H2><a STYLE="color:black; text-decoration:none;" href=$url>$cluster<\/a><\/H2></;
	  #Add to final page
   	  $buildFinalPage = $buildFinalPage . "\n" . "<table class=\"tbl\" width=\"100%\">" . $table . "\n";
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
 #Add a signature to your page and add padding to hide bottom scrolling bar
 $signature = "NocRulz <BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>";
 
 #open output file and write to it
 open(my $fh3, '>', $outputPath)or die "Could not open file '$outputPath' $!";
 print $fh3 "" . $buildFinalPage . $signature . $tail ;
 close $fh;
 close $fh3;
 # Play sounds if a machine is down with cycle mute (working) and play different sound when a whole cluster is down (soon)
 if($buildFinalPage =~ m/DOWN/){
 
	if($soundMuteCountCycle<0){
		$soundMuteCountCycle = $soundMuteXCycles;
		use Win32::Sound;
		Win32::Sound::Volume('50%');
		Win32::Sound::Play("blackhawkdown.wav");
		print "\n Sleping 5secs\n ";
		sleep(5);
		Win32::Sound::Stop();
	}else{
		print "\n Sleping 5secs \n";
		sleep(5);
	}
 }else{
 print "\n Sleping 5secs \n";
 sleep(5);
}   
 

}

 
 
 
 
  
