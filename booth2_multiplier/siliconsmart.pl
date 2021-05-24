#!/usr/bin/perl -w


print("#### Navya & Mark \n\n");

##### description
print("#### Please source this profile /proj/cad/startup/profile.synopsys_2016 \n");
print("#### Will setup the Siliconsmart ACE tool for characterizing std.cells\n");
print("#### The script will create the following \n");

print("####[1] .inst files for all the cells entered by the users \n");
print("####[2] Script should run the ACE tool \n");
print("####[3] The tool then generates .lib file for the cells entered \n\n");

##########Remove old char_dir #######################
if (-d "./char_dir")
{
system "chmod 775 -R *";
system "rm -rf char_dir";
print("Deleting the old files..........\n\n");
}
##########Start Silicon Smart and generate the char_dir ########################
print("Now creating new Characterization Directory..........\n\n");

##########Generate the TCL script for setup #####################
open(SCRIPT, ">./setup.tcl") or die "could not open the script file to write!";
print SCRIPT "create char_dir\n";
print SCRIPT "set_location char_dir\n";

# prompt and receive cell names,spice netlist and I/Os for all cells except DFF

print "Please enter the total number of cells :";
$cellNum = <STDIN>;
chomp($cellNum);

for ($i = 0; $i < $cellNum; $i++)
{
	print("Please enter a cell name or enter dff for Flip-Flop data :");
	$cellName=<STDIN>;
	chomp ($cellName);
        if ($cellName eq "dff" ) 
	{
	dff_data();
	}
        else
	{
	print("please enter the name of spice netlist file <filename.sp> of the cell :");
	$input = <STDIN>;
	chomp($input);
	$cellnetlist{$cellName} = $input;

	print("Please enter the input pin names seperated by spaces :");
	$input = <STDIN>;
	chomp($input);
	$cellInputHash{$cellName} = $input;

	print("Please enter the output pin name(s) seperated by spaces :");
	$input = <STDIN>;
	chomp($input);
	$cellOutputHash{$cellName} = $input;
	
	print("Please enter cell area :");
	$input = <STDIN>;
	chomp($input);
	$cellAreaHash{$cellName} = $input;

	print("Please enter a cell function :");
	$input=<STDIN>;
	chomp ($input);
	$cellFunctionHash{$cellName} = $input;
	
        }
}

# prompt and receive cell names,spice netlist and I/Os for only DFF
sub dff_data
{
$dff=1;
	print("Enter the DFF name :");
	$cellName=<STDIN>;
	chomp ($cellName);
        $dffname = $cellName;

	print("please enter the name of spice netlist file <filename.sp> of the DFF cell :");
	$input = <STDIN>;
	chomp($input);
	$DFFnetlist = $input;

	print("Please enter the Data pin name :");
	$dinput = <STDIN>;
	chomp($dinput);
	

	print("Please enter the Reset pin name :");
	$rinput = <STDIN>;
	chomp($rinput);
	
	print("Please enter RESET sensitivity if #ACTIVE HIGH enter 1 else #ACTIVE LOW Enter 0 :");
	$rtype = <STDIN>;
	chomp($rtype);
	if ($rtype==1)	
	{
	$RESET="$rinput";	
	}	
	else
	{
	$RESET=join ("","!",$rinput);
	}
		
	print("Please enter the Clock pin name :");
	$cinput = <STDIN>;
	chomp($cinput);
	
	print("Please enter clock edge sensitivity if #FALLING EDGE TRIGGERED enter 1 else #RISING EDGE Enter 0 :");
	$ctype = <STDIN>;
	chomp($ctype);
	
	if ($ctype==0)	
	{
	$CLK="$cinput";	
	}	
	else
	{
	$CLK=join ("","!",$cinput);
	}

	print("Please enter the Q output pin name :");
	$output = <STDIN>;
	chomp($output);

	print("Please enter The output type if #Q enter 1 else #Qbar Enter 0 :");
	$qtype = <STDIN>;
	chomp($qtype);

	if ($qtype==1)	
	{
	$Q="$output";	
	}	
	else
	{
	$Q=join ("","!",$output);
	}

		
	print("Please enter cell area :");
	$input = <STDIN>;
	chomp($input);
	$dffAreaHash = $input;
	
}

# Generate list file 

open(LIST, ">./list") or die "could not open list file to write!";

foreach $key (keys %cellInputHash)
{
	print LIST "$key\n";
}

#Import the netlist in the Tcl Script

foreach $cellName (keys %cellInputHash)
{
print SCRIPT "import -netlist ../$cellnetlist{$cellName} -overwrite $cellName\n";
}
	

if($dff==1)
{
print SCRIPT "import -netlist ../$DFFnetlist -overwrite $dffname\n";	
}
##########################Exit Siliconsmart to configure the instance files ######################
print SCRIPT "exit\n";

############################### Run the TCL script for SiliconSmart ACE setup ######################
system "siliconsmart ./setup.tcl";

###############################Copy the configuration file into the char_dir directory ######################
print("Now copying the configuration file..........\n\n");
system "cp -rf /home/eng/m/mrs171030/65nm/cad/siliconsmart/configure.tcl ./char_dir/config/.";

######################################Configure the Instance Files ######################
#editing the I/O pin names in the .inst file based on the I/Os entered when prompted
#VDD and GND are changed to supply pins
foreach $cellName (keys %cellInputHash)
{

	open(read_file, "<./char_dir/control/$cellName.inst") || die "Read_file not found";
	open(write_file, ">./char_dir/control/edited_$cellName.inst") || die "Cannot open write_file";
	my @temp = split (/ /, $cellInputHash{$cellName});
	while (<read_file>)
	{
		if ((/GND/)||(/VDD/))
		{
			s/inout/supply/;
		}
		if (/$cellOutputHash{$cellName}/)
		{
			s/inout/output/;
		}
		foreach my $temp (@temp)
		{
			if ($temp)
			{
				s/inout/input/;
			}
		}
		print write_file;
	}
	close read_file;
	close write_file;
	unlink "./char_dir/control/$cellName.inst";
	rename "./char_dir/control/edited_$cellName.inst", "./char_dir/control/$cellName.inst";

# adding function and area to the .inst file
	open($INST_FILE, ">>./char_dir/control/$cellName.inst") || die "Instance File not found";
	print $INST_FILE "add_function $cellOutputHash{$cellName} { $cellFunctionHash{$cellName} }\n";
	print $INST_FILE "define_parameters $cellName { set area $cellAreaHash{$cellName} }\n";	
	close(INST_FILE);	
}

# editing the I/O pin names in the .inst file based on the I/Os entered when prompted for DFF
# VDD and GND are changed to supply pins
if($dff==1)
{ 
open(read_file, "<./char_dir/control/$dffname.inst") || die "Read_file not found";
open(write_file, ">./char_dir/control/edited_$dffname.inst") || die "Cannot open write_file";
while (<read_file>)
	{
		if ((/GND/)||(/VDD/))
		{
			s/inout/supply/;
		}
		if (/$Q/)
		{
			s/inout/output/;
		}
		if ((/$CLK/)||(/$dinput/)||(/$RESET/))
		{
			s/inout/input/;
		}
		print write_file;
	}
close read_file;
close write_file;
unlink "./char_dir/control/$dffname.inst";
rename "./char_dir/control/edited_$dffname.inst", "./char_dir/control/$dffname.inst";

# adding function and area to the .inst file
open($DFFINST_FILE, ">>./char_dir/control/$dffname.inst") || die "Instance File not found";
print $DFFINST_FILE "add_flop out Iout $CLK $dinput -clear $RESET \n";
print $DFFINST_FILE "add_function $Q out\n";
print $DFFINST_FILE "define_parameters $dffname { set area $dffAreaHash }\n";


# append set_config_opt to dff inst
open($CONFIG_OPT, "<", '/home/eng/x/xxx110230/public_html/scripts/siliconsmart/config.opt' );
while ( my $line = readline ($CONFIG_OPT) ) {
  print $DFFINST_FILE $line;
}
close(CONFIG_OPT);
close(DFFINST_FILE);
}

################################ Make the TCL script for characterizing ######################
open(CSCRIPT, ">./characterize.tcl") or die "could not open the script file to write!";
print CSCRIPT "set_location char_dir\n";
print CSCRIPT "configure\n";
print CSCRIPT "characterize\n";
print CSCRIPT "model\n";
print CSCRIPT "exit\n";


############################### Run the TCL script for SiliconSmart ACE ######################
system "siliconsmart ./characterize.tcl";






