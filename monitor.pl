use LWP::Simple;

#############################################################################################
################### IMPORTANT VERIABLES ##################################################### 
 my $machinePath = 'machines.txt'; ## each like contains: cluster name,haproxy link, [newline/NULL]
 my $outputPath = 'machinesFullPage.html';
 my $colSizePxl = 157;
 my $soundMuteXCycles = 5;


#############################################################################################
################### BASIC HTML PAGE LAYOUT ################################################## 
 my $header = '
<html><head><title>Statistics Report for HAProxy</title>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
<style type="text/css"><!--
body { font-family: arial, helvetica, sans-serif; font-size: 12px; font-weight: normal; color: black; background:"e8e8d0";}
th,td { font-size: 10px;}
h1 { font-size: x-large; margin-bottom: 0.5em;}
h2 { font-family: helvetica, arial; font-size: large; font-weight: bold; font-style: italic; color: #000000; margin-top: 0em; margin-bottom: 0em;}
h3 { font-family: helvetica, arial; font-size: 14px; font-weight: bold; color: #b00040; background: #e8e8d0; margin-top: 0em; margin-bottom: 0em;}
li { margin-top: 0.25em; margin-right: 2em;}
.hr {margin-top: 0.25em; border-color: black; border-bottom-style: solid;}
.titre	{background: #20D0D0;color: #000000; font-weight: bold; text-align: center;}
.total	{background: #20D0D0;color: #ffff80;}
.frontend	{background: #e8e8d0;}
.socket	{background: #d0d0d0;}
.backend	{background: #e8e8d0;}
.active0	{background: #ff9090;}
.active1	{background: #ffd020;}
.active2	{background: #ffffa0;}
.active3	{background: #c0ffc0;}
.active4	{background: #ffffa0;}
.active5	{background: #a0e0a0;}
.active6	{background: #e0e0e0;}
.backup0	{background: #ff9090;}
.backup1	{background: #ff80ff;}
.backup2	{background: #c060ff;}
.backup3	{background: #b0d0ff;}
.backup4	{background: #c060ff;}
.backup5	{background: #90b0e0;}
.backup6	{background: #e0e0e0;}
.maintain	{background: #c07820;}
.rls      {letter-spacing: 0.2em; margin-right: 1px;}

a.px:link {color: #ffff40; text-decoration: none;}a.px:visited {color: #ffff40; text-decoration: none;}a.px:hover {color: #ffffff; text-decoration: none;}a.lfsb:link {color: #000000; text-decoration: none;}a.lfsb:visited {color: #000000; text-decoration: none;}a.lfsb:hover {color: #505050; text-decoration: none;}
table.tbl { border-collapse: collapse; border-style: none;}
table.tbl td { text-align: right; border-width: 1px 1px 1px 1px; border-style: solid solid solid solid; padding: 2px 3px; border-color: gray; white-space: nowrap;}
table.tbl td.ac { text-align: center;}
table.tbl th { border-width: 1px; border-style: solid solid solid solid; border-color: gray;}
table.tbl th.pxname { background: #b00040; color: #ffff40; font-weight: bold; border-style: solid solid none solid; padding: 2px 3px; white-space: nowrap;}
table.tbl th.empty { border-style: none; empty-cells: hide; background: white;}
table.tbl th.desc { background: white; border-style: solid solid none solid; text-align: left; padding: 2px 3px;}

table.lgd { border-collapse: collapse; border-width: 1px; border-style: none none none solid; border-color: black;}
table.lgd td { border-width: 1px; border-style: solid solid solid solid; border-color: gray; padding: 2px;}
table.lgd td.noborder { border-style: none; padding: 2px; white-space: nowrap;}
u {text-decoration:none; border-bottom: 1px dotted black;}
-->
</style><meta http-equiv="refresh" content="5" ></head><BODY bgcolor="e8e8d0"><table cellpadding="0">';
my $tail = '</tr></table></BODY></HTML>';

 
#############################################################################################
################### SCRIPT BEGINNING ########################################################  

$soundMuteCountCycle = -1;
while(true){
$soundMuteCountCycle--; 
open(my $fh, '<:encoding(UTF-8)', $machinePath)or die "Could not open file '$machinePath' $!";

## Set page with header + script run time ##
$buildFinalPage = $header . '<H3>Check Time:'.localtime().'</H3><tr style="vertical-align: top;"><td width="157px"> <div style="overflow:auto; width:157px; vertical-align: top;">';
## for each hxproxy instance in list
while (my $row = <$fh>) {
	
	chomp $row;
	$newCol = "";
	($cluster, $url , $newCol,$image) = split(',',$row);
	if($newLine eq "newCol"){
		## Insert new lines to hide bottom slider from sight
		## Break column by closing div and opening a new one
		$buildFinalPage = $buildFinalPage . '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR></div></td><td width="157px"> <div style="overflow:auto; width:157px">';
	}
	my $content = "";
    my $content = get $url;
    #die "Couldn't get $url" unless defined $content;
	# Remove all new lines from code for easier parsing
    $content =~ s/[\n\r]//g;
    # Locate haproxy http table and cut it from the rest of the html
    if($content =~ m/.*?<\/tr>(<tr class="frontend">.*?)<tr class="backend">.*?/) {
	  #Close table before "backend" section
	  $table = $1 . "</tr></table>";
	  #Replace word "Frontend" with the cluster name, and add background image\flag in case one is supplied (soon)
	  $table =~ s/>Frontend</><H2>$cluster<\/H2></;
	  #Add to final page
   	  $buildFinalPage = $buildFinalPage . "\n" . "<table class=\"tbl\" width=\"100%\">" . $table . "\n";
	  #Update perl console that a cluster was successfully parsed 
      print "found " . $cluster . "\n";
    } else {
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

 
 
 
 
  
