########################################################################################
################### IMPORTANT HTML #####################################################

our $header = '
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
.active0	{background: -webkit-gradient(linear, left top, left bottom, from(#ff7f7f), to(#cc3c3c));
			 background: -moz-linear-gradient(top, #ff7f7f,  #cc3c3c);
			 background: linear-gradient(#ff7f7f, #cc3c3c);}
.active1	{background: -webkit-gradient(linear, left top, left bottom, from(#ffd94c), to(#cea819));
			 background: -moz-linear-gradient(top, #ffd94c,  #cea819);
			 background: linear-gradient(#ffd94c, #cea819);}
.active2	{background: -webkit-gradient(linear, left top, left bottom, from(#ffffa0), to(#ffb732));
			 background: -moz-linear-gradient(top, #ffffa0,  #ffb732);
			 background: linear-gradient(#ffffa0, #ffb732);}
.active3	{background: -webkit-gradient(linear, left top, left bottom, from(#7DCF3D), to(#52A93E));
			 background: -moz-linear-gradient(top, #7DCF3D,  #52A93E);
			 background: linear-gradient(#7DCF3D, #52A93E);}
.active4	{background: -webkit-gradient(linear, left top, left bottom, from(#7DCF3D), to(#52A93E));
			 background: -moz-linear-gradient(top, #7DCF3D,  #52A93E);
			 background: linear-gradient(#7DCF3D, #52A93E);}
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
div.tips {
 display:block;
 visibility:hidden;
 z-index:2147483647;
 position:absolute;
 padding:2px 4px 3px;
 background:#f0f060; color:#000000;
 border:1px solid #7040c0;
 white-space:nowrap;
 font-style:normal;font-size:11px;font-weight:normal;
 -moz-border-radius:3px;-webkit-border-radius:3px;border-radius:3px;
 -moz-box-shadow:gray 2px 2px 3px;-webkit-box-shadow:gray 2px 2px 3px;box-shadow:gray 2px 2px 3px;
}
u:hover div.tips {visibility:visible;}
-->
</style><meta http-equiv="refresh" content="5" ></head><BODY bgcolor="e8e8d0"><table cellpadding="0">';
our $tail = '</tr></table></BODY></HTML>';
our $signature = "<BR><BR><BR><BR>V1.3.0 Ariel.R©";
