#! /usr/bin/env perl

#
#	This script scan the tgz files and build a executable environment
#	out of them. The script can be instructed to prompt user or
#	perform completely automated.
#

use Cwd;
use Data::Dumper;
use File::Basename;
use File::Copy;

use File::Find();
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;		# full-path
*dir    = *File::Find::dir;			# dirname, while _ is the basename
*prune  = *File::Find::prune;

use strict;

use FindBin( '$Bin' );
use lib "$Bin";

#
#	Section:	Global context
#

my $gPathHome = $ENV{'HOME'};
my $gPathLogFile = $gPathHome . '/build_env.log' ;
my $gPathTgz = $gPathHome . '/tgz';
my $gPathBaseline = $gPathHome . '/baseline';
my $gPathTmp = $gPathHome . '/build_env.tmp' ;
my $gPathInstall;
my $gProfile;

my $gPromptUser = 0;
my $gErrorCnt = 0;
my $gDebug = 0;
my $gAskConfirm = 1;
my $gAllowDefault = 1;
my $gTestMode = 0;
my $gHistoryMode = 0;
my $gHistoryFile;
my %gHistory;
my $gBaselineMode = 0;

my $gOsName;

my %gExclList;
my %gPrefList;
my %gProdToSkip;
my %gProdList;

# Directories of existing environment
# From which Cfg files are to be copied to the new environment
my $gPathCurrDirProd;
my $gPathCurrDirIst;
my $gPathCurrDirOsite;

my $gTime;
my $gTmpNewFileOnly;
my @gTmpNewFile;
my $gTmpFindAllFileSrc;
my $gTmpFindAllFileDst;

my $gTestCnt = 0;
my $gTestCntGood = 0;

my %gOptAvail;
my %gOptDbAvail;
my %gOptOpzAvail;
my %gOptPatchAvail;

#	Data structure:
#	$gFile{ PROD }->{ TIMELINE }->{ SP }->{ RC }->{ OPTKEY } = FILE
my %gFile;

#	Data structure:
#	$gPlan[] = [ FILE ]
my @gPlan;

#
#	Section:	Constant
#

my %cProdOrder =
(
	'FO'	=>	[10,'Foundation'	],
	'MSIM'	=>	[15,'Msg-Simulator'	],
	'SW'	=>	[20,'Switch'		],
	'AC'	=>	[30,'All-Card'		],
	'CL'	=>	[40,'Clearing'		],
	'MA'	=>	[50,'MAS-Server'	],
	'MAC'	=>	[60,'MAS-Client'	],
	'IM'	=>	[70,'IMN'			],
);

# Databases, ordered by more preferred first
my %cDbOrder = 
(
	'ORA'	=>	1,
	'DB2'	=>	2,
	'SYB'	=>	3,
	'INF'	=>	4,
);

my $cDbStr = join '|', keys(%cDbOrder) ;

#
#	-	write message to both log file and to screen.
#
#	1.	Determine the OS string
#	2.	Collect file names into data structure
#	3.	Analyze data structure for ambiguity, prompt user if needed
#	4.	Show final decision and prompt confirmation
#	5.	Install the selected files to the destination directory
#

#
#	- - - - - - - - - - - -
#	Section:	Subroutines
#	- - - - - - - - - - - -

#
#	Generic routine for user to select from a list of choices
#
sub multiple_choice
{
    my( $question, @choice ) = @_ ;
    my $count = scalar @choice ;
    my $answer = '';

    while( $answer eq '' || $answer < 0 || $answer >= $count )
    {
        printf STDERR "%s Choice:\[0-%d\]\n",
			$question, $count - 1
			;
        my( $idx );
        for( $idx = 0 ; $idx < $count ; ++ $idx )
        {   
			printf STDERR " [$idx] - %s%s\n",
				$choice[$idx],
				($idx == 0 && $gAllowDefault?' (default)':'')
				; 
		}
        $answer = <STDIN> ;
        chomp $answer ;

		if( $answer eq '' && $gAllowDefault )
		{
			$answer = 0;
			printf STDERR "Applied default \"%s\"\n\n", $choice[$answer];
		}
    }

    return( $answer, $choice[$answer] );

	###
}	### multiple_choice
	###

#
#	Compose time-string to be used in writing log
#
sub GetTimeString
{
	my( $aTime ) = @_;

	$aTime = time()
		if( ! defined $aTime );

	my($s,$m,$h,$D,$M,$Y,$wday,$yday,$isdst) =
		localtime( $aTime );

	return sprintf "%04d/%02d/%02d %02d:%02d:%02d", 
		1900 + $Y, $M + 1, $D, $h, $m, $s;

	###
}	### GetTimeString
	###

#
#	Write message to both screen and log file
#
sub WriteMsg
{
	my( $aMsg ) = @_;

	print $aMsg . "\n";

	my $aTime = time();
	my $aStr = '';
	if( $aTime != $gTime )
	{
		$aStr = sprintf "\t[%s]\n",  GetTimeString( $aTime );
		$gTime = $aTime;
	}
	printf LOG ( "%s%s\n", $aStr, $aMsg );

	###
}	### WriteMsg
	###

#
#	Print msg and abort script
#
sub AbortProgram
{
	my( $aMsg ) = @_;
	WriteMsg $aMsg
		if( defined $aMsg );
	WriteMsg "Program Aborted\n\n - = - = - = -\n\n";
	exit -1;

	###
}	### AbortProgram
	###

#
#	Given a path (full or relative), extend to full-path
#	and verify if it exists. Abort program if not.
#
sub VerifyPath
{
	my( $aPath, $aDesc ) = @_;

	if( $aPath eq '' )
	{
		AbortProgram "ERROR: $aDesc is not specified\n";
	}

	if( $aPath !~ m#^/# )
	{
		$aPath = cwd() . '/' . $aPath;
	}

	if( ! -d $aPath )
	{
		AbortProgram "ERROR: $aDesc [$aPath] does not exist\n";
	}

	return $aPath;

	###
}	### VerifyPath
	###

#
#	Determine the OS/version of the running platform
#
sub SetOsString
{
	# just return if user specified os string
	return
		if( defined $gOsName );

	my $aOsName = `uname -s`;	
	chomp $aOsName;

	if( $aOsName =~ /AIX/i )
	{
		my $aOsLevel = `/usr/bin/oslevel`; 
		$aOsLevel =~ /(\d)\.(\d)\.(\d)/;
		$gOsName = sprintf "AIX-%s%s%s", $1, $2, $3;
	}
	elsif( $aOsName =~ /HP-UX/i )
	{
		$gOsName = 'HPUX-11i';
	}
	elsif( $aOsName =~ /Linux/i )
	{
		$gOsName = `uname -r`;
		$gOsName = $`
			if( $gOsName =~ /-/ );
		$gOsName =~ s/\.//g;
		$gOsName = 'LIN-' . $gOsName;
	}
	elsif( $aOsName =~ /SunOS/i )
	{
		$gOsName = `uname -r`;
		$gOsName =~ /\d+\.(\d+)/;
		$gOsName = sprintf "SOL-2%s0", $1;
	}
	elsif( $aOsName =~ /OSF/i )
	{
		$gOsName = `uname -r`;
		$gOsName =~ /(\d+)\.(\d+)/;
		$gOsName = sprintf "OSF-%s%s0", $1, $2;
	}

	if( defined $gOsName )
	{
		WriteMsg
			sprintf( "INFO: OsString=[%s]\n", $gOsName );
	}
	else
	{
		AbortProgram "ERROR: Unable to determine OsString\n";
	}

	###
}	### SetOsString
	###

#
#	Scan the tgz dir for valid tgz files and collect them into 
#	data structure.
#
sub ScanTgzDir
{
	my $aScanPath = $gPathTgz;
	$aScanPath = $gPathBaseline
		if( $gBaselineMode );

	if( ! -d  $aScanPath )
	{
		AbortProgram "ERROR: Missing directory [$aScanPath]\n";
	}

	printf "INFO: Scanning directory [$aScanPath]\n";

	opendir DIR, $aScanPath
		or AbortProgram "ERROR: Fail to read [$aScanPath]\n";
	my @aList = grep !/^\./, readdir DIR;
	closedir DIR;

	foreach (@aList)
	{
		my $aPath = $_;
		my $aFullPath = "$aScanPath/$_";
		my $aFile;

		my $aProd;
		my $aLevel;
		my $aOs;

		my @aPart;

		### skip sub-dir if in tgz mode (not in baseline mode)
		next
			if( ! $gBaselineMode && -d $aFullPath ); 

		WriteMsg "WARNING: Fail to read File [$aPath]\n"
			if( ! -r $aFullPath );

		### verify file-name - must be tgz file if in regular (tgz) mode
		if( $gBaselineMode )
		{
			$aFile = $aPath;
		}
		else
		{
			next
				if( $aPath !~ /\.(tar\.gz|tgz)$/ );
			$aFile = $`;
		}

		@aPart = split /_/, $aFile;

		# Mandatory parts
		$aProd = $aPart[0];

		next
			if( exists $gProdToSkip{ $aProd } );

		# WARNING: Discover unknown product file
		if( ! exists $cProdOrder{ $aProd } )
		{
			my $aAnsIdx = 0;				### default is not to install
			my $aAnsWord;
			if( scalar %gProdList <= 0 )	### no product is specified
			{
				WriteMsg "WARNING: Unknown PRODUCT File [$aPath]\n";
				( $aAnsIdx, $aAnsWord ) =
					multiple_choice(
						"Do you want to install unknown PRODUCT \"$aProd\" ?",
						'No', 'Yes' );
			}
			elsif( exists $gProdList{ $aProd } )
			{
				$aAnsIdx = 1;
			}

			if( $aAnsIdx == 1 )
			{
				$cProdOrder{ $aProd } = [ 999, "Product-$aProd" ];
			}
			else
			{
				$gProdToSkip{ $aProd } = undef;
				next;
			}
		}

		$aLevel = $aPart[1];
		$aOs = $aPart[2];


		printf "p=$aProd o=$aOs l=$aLevel f=$aFile\n"
			if( $gDebug );

		#	verify file parts - ensure OS match and level is valid
		if( $aOs !~ /$gOsName/
		 || $aLevel !~ /(\d+)\.(\d+)\.(\d+)\.(\d+)\.(\d+)$/ 
		  )
		{
			WriteMsg "WARNING: Skipping File [$aPath]";
			next;
		}

		my $aTimeline = $1 . '.' . $2 . '.' . $3;
		my $aSp = $4;
		my $aRc = $5;

		printf "t=$aTimeline s=$aSp r=$aRc\n"
			if( $gDebug );

		my @aOptList;
		for( my $idx = 3 ; $idx < scalar @aPart ; ++ $idx )
		{
			my $aOpt = $aPart[$idx];

			next if( $aOpt eq 'FULL' );
			next if( $aOpt eq 'GA' );

			push @aOptList, $aOpt;

			if( $aOpt =~ /^($cDbStr)-/i )
			{
				++ $gOptDbAvail{ $aOpt };
			}
			elsif( $aOpt =~ /^OPZ$/i )
			{
				# For optimized option
				++ $gOptOpzAvail{ $aOpt };
			}
			elsif( $aOpt =~ /^P\d+$/i )
			{
				# For patches the rest of parts are taken together
				@aOptList = @aPart[ $idx .. $#aPart ];
				$aOpt = join '_', @aOptList;
				++ $gOptPatchAvail{ $aOpt };
				last;
			}
			else
			{
				++ $gOptAvail{ $aOpt };
			}
		}

		my $aOptKey = join '_', @aOptList;

		if( exists
	$gFile{ $aProd }->{ $aTimeline }->{ $aSp }->{ $aRc }->{ $aOptKey } )
		{
			WriteMsg "WARNING: Ignored file [$aPath] with duplicated option signature [$aOptKey]\n";
		}

		$gFile{ $aProd }->{ $aTimeline }->{ $aSp }->{ $aRc }->{ $aOptKey }
			= $aPath;
	}

	if( $gDebug )
	{
		printf Dumper [ 'gFile (after scan)', \%gFile ];
		printf Dumper [ 'gOptAvail', \%gOptAvail ];
		printf Dumper [ 'gOptDbAvail', \%gOptDbAvail ];
		printf Dumper [ 'gOptPatchAvail', \%gOptPatchAvail ];
		printf Dumper [ 'gOptOpzAvail', \%gOptOpzAvail ];
	}

	###
}	### ScanTgzDir
	###

#
#	Given a question (text) and a list of choices,
#	prompt the user if each item should be selected or not.
#
sub SelectFromList
{
	my( $aStr, @aInList ) = @_;

	my @aYesList;

	for( my $idx = 0 ; $idx < scalar @aInList ; ++ $idx )
	{
		my $aItem = $aInList[ $idx ];

		my $aQuestion = sprintf( $aStr, $aItem );

		my( $aAnsIdx, $aAnsWord ) =
			multiple_choice 
				$aQuestion,
#				$aStr . ' "' . $aItem . '" ?',
				'yes', 'no';

		push @aYesList, $idx
			if( $aAnsIdx == 0 );
	}

	return @aYesList;

	###
}	### SelectFromList
	###

my $sortDb =
	sub
	{
		$a =~ /-/;
		my $A = $cDbOrder{ $` };
		$A = 999 if( ! defined $A );
		$b =~ /-/;
		my $B = $cDbOrder{ $` };
		$B = 999 if( ! defined $B );

		$A <=> $B
			or
		length($a) <=> length($b)
	};

my $sortProduct =
	sub
	{
		my $A = $cProdOrder{$a}->[0];
		$A = 999 if( ! defined $A );
		my $B = $cProdOrder{$b}->[0];
		$B = 999 if( ! defined $B );
		$A <=> $B;
	};

my $sortTimeline =
	sub
	{
		my @A = split /\./, $a;
		my @B = split /\./, $b;
		$B[0] <=> $A[0]
			or
		$B[1] <=> $A[1]
			or
		$B[2] <=> $A[2]
		;
	};

#
#	Examine the data structure and
#	eliminate some product user choose not to install.
#
sub ChooseProduct
{
	if( scalar %gProdList > 0 )
	{
		foreach my $aProd (keys %gFile)
		{
			delete $gFile{ $aProd }
				if( ! exists $gProdList{ $aProd } );
		}

		return;
	}

	# Install everything if can't ask user
	return
		if( ! $gPromptUser );

	my @aProdList = sort $sortProduct keys %gFile;

	my @aList = map 
		{ $cProdOrder{$_}->[1] . '(' . $_ . ')' } @aProdList;

	my @aYesList = SelectFromList 
				"Should PRODUCT \"%s\" be installed ?",
				@aList
				;

	my %aSelected = map { $_, undef } @aProdList[ @aYesList ];

	# remove product that 
	foreach my $aProd (keys %gFile)
	{
		delete $gFile{ $aProd }
			if( ! exists $aSelected{ $aProd } );
	}

	###
}	### ChooseProduct
	###

#
#	Examine the data structure and
#	eliminate multiple possible product time-line and/or
#	service-pack and/or release-candidates from the data structure.
#
sub ChooseLevel
{
	foreach my $aProd (sort $sortProduct keys %gFile)
	{
		# sort the time-line from latest to oldest
		my $aProdRef = $gFile{$aProd};
		my @aList =
			sort $sortTimeline keys %{$aProdRef};
		
		# leave only one time-line under product
		my $aChosenTimeline = $aList[0];
		if( scalar @aList > 1 )
		{
			if( $gPromptUser )
			{
				my @aChoice = map { $aProd . '_' . $_ } @aList;
				my( $aAnsIdx, $aAnsWord ) =
					multiple_choice
						"Which of these TIME-LINEs should be installed ?",
						@aChoice;
				$aChosenTimeline = $aList[ $aAnsIdx ];
			}

			# eliminate others
			foreach my $aTimeline (keys %{$aProdRef})
			{
				delete $aProdRef->{ $aTimeline }
					if( $aTimeline ne $aChosenTimeline );
			}
		}

		#
		# choose the service-pack up to which to be installed.
		#
		my $aTimelineRef = $aProdRef->{ $aChosenTimeline };
		@aList = reverse sort keys %{$aTimelineRef};

		if( scalar @aList > 1 )
		{
			if( $gPromptUser )
			{
				my @aChoice =
					map { 'Up-to ' . $aProd . '_'
						. $aChosenTimeline . '.' . $_ } @aList;
				my( $aAnsIdx, $aAnsWord ) =
					multiple_choice
						"Which of these SERVICE-PACKs should be installed ?",
						@aChoice;

				# eliminate those service-packs that are exluded
				# from data structure.
				for( my $idx = 0 ; $idx < $aAnsIdx ; ++ $idx )
				{
					delete $aTimelineRef->{ $aList[$idx] };
				}
			}
		}

		#
		# verify completeness of service-packs
		#
		@aList = sort keys %{$aTimelineRef};
		my $aCount = 0;
		for( my $idx = 0 ; $idx < scalar @aList ; ++ $idx )
		{
			my $idx2 = $aList[ $idx ];
			if( $idx2 != $idx )
			{
				++ $aCount;
				WriteMsg sprintf(
					"ERROR: Found SERVICE-PACK %s while expect %02d in %s\n",
					$idx2, $idx,
					$aProd . '_' . $aChosenTimeline,
					);
			}
		}

		if( $aCount > 0 )
		{
			my @aSpList =
				map { "\t".$aProd . '_' . $aChosenTimeline . '.' . $_ } @aList;
			my $aSpList = join "\n", @aSpList;

			my( $aAnsIdx, $aAnsWord ) =
				multiple_choice(
					"Available SERVICE-PACKs:\n$aSpList\n"
					. "Some SERVICE-PACK(s) are missing."
					. " How to you want to continue ?",
					'Abort Installation',
					'Continue with the problematic SERVICE-PACK(s)' );
			if( $aAnsIdx == 0 )
			{
				AbortProgram sprintf(
					"Avoiding incomplete SERVICE-PACK(s) in %s\n",
						$aProd . '_' . $aChosenTimeline ) ;
			}
			else
			{
				WriteMsg sprintf(
				"WARNING: Continue with problematic SERVICE-PACK(s) in %s\n",
					$aProd . '_' . $aChosenTimeline ) ;
				;
			}

		}

		#
		# For each service-pack that are chosen, eliminate
		# other release-candidates.
		#
		foreach my $aSp (sort keys %{$aTimelineRef})
		{
			my $aSpRef = $aTimelineRef->{ $aSp };
			@aList = reverse sort keys %{$aSpRef};

			my $aChosenRc = $aList[0];
			if( scalar @aList > 1 )
			{
				if( $gPromptUser )
				{
					my @aChoice =
						map {  $aProd . '_' . $aChosenTimeline
								. '.' . $aSp . '.' . $_ } @aList;
					my( $aAnsIdx, $aAnsWord ) =
						multiple_choice
						"Please choose from these product release-candidate",
							@aChoice;
					$aChosenRc = $aList[$aAnsIdx];
				}
			}

			# eliminate other release-candidates
			foreach my $aRc (keys %{$aSpRef})
			{
				delete $aSpRef->{ $aRc }
					if( $aRc ne $aChosenRc );
			}
		}
	}

	if( $gDebug )
	{
		printf Dumper [ 'gFile (after choose)', \%gFile ];
	}

	###
}	### ChooseLevel
	###

#
#	Examine data structure and
#	eliminate ambiguious options
#
sub ChooseOption
{
	my( $aProd, $aTimeline, $aSp, $aRc, $aRcRef ) = @_;

	my $aExclRegExpr = join( '|', keys(%gExclList));
	my $aPrefRegExpr = join( '|', keys(%gPrefList));

	#
	#	There are different types of options:
	#	Any of them can be OPZ or not
	#	1.	BASE
	#	2.	DB, 
	#	3.	Other options (non patches)
	#	4.	Patches
	#

	# Elminated all options that are excluded
	my @aOpt;
	if( scalar %gExclList > 0 )
	{
		@aOpt = grep ! /$aExclRegExpr/, keys %{$aRcRef};
	}
	else
	{
		@aOpt = keys %{$aRcRef};
	}

	#
	# classify each option into one of these type
	#
	my @aBase;
	my @aDb;
	my @aOther;
	my @aPatch;

	#
	#	Classify
	#
	foreach my $aOptKey (@aOpt)
	{
		my $aClassified = 0;

		foreach my $aPart (split /_/, $aOptKey)
		{
			if( $aPart =~ /^BASE$/i )
			{
				push @aBase, $aOptKey;
				$aClassified = 1;
				last;
			}
			elsif( $aPart =~ /^($cDbStr)-/i )
			{
				push @aDb, $aOptKey;
				$aClassified = 1;
				last;
			}
			elsif( $aPart =~ /^P\d+$/ )
			{
				push @aPatch, $aOptKey;
				$aClassified = 1;
				last;
			}
		}

		if( ! $aClassified )
		{
			push @aOther, $aOptKey;
		}
	}
	
	#
	# examine each type and see if there are conflicting entries
	# favour those that are preferred
	#

	#
	# Look at the BASE options
	# Install only one BASE option
	#
	if( scalar @aBase > 1 )
	{
		# Apply preference and try to narrow down the choice
		my @aPrefList = grep /$aPrefRegExpr/, @aBase;

		if( scalar @aPrefList == 1 )
		{
			# preference narrow down to one choice
			@aBase = @aPrefList;
		}
		elsif( $gPromptUser )
		{
			# ask the user
			my @aChoice =
				map {  $aProd . '_' . $aTimeline
						. '.' . $aSp . '.' . $aRc . '...' . $_ } @aBase;
			my( $aAnsIdx, $aAnsWord ) =
				multiple_choice
					"Please choose from these product BASE options",
					@aChoice;
			@aBase = ( $aBase[ $aAnsIdx ] );
		}
		else
		{
			# choose the shortest one, if cannot ask user
			my @aList = sort { length($a) <=> length($b) } @aBase;
			@aBase = ( $aList[0] );
		}
	}
	elsif( scalar @aBase == 0
	 && $aSp == 0 )
	{
		# Full release (SP0) should have a BASE
		my @aList = map { "\t" . $_ } @aOpt;
		my $aList = join "\n", @aList;

		my $aBaseFile = 
			$aProd . '_' . $aTimeline . '.' . $aSp . '.' . $aRc;

		my( $aAnsIdx, $aAnsWord ) =
			multiple_choice
				"Available OPTION(s)\n$aList\n"
				. "ERROR: Missing BASE file in $aBaseFile\n"
				. "       Do you want to continue ?", 'No', 'Yes';
		if( $aAnsIdx != 1 )
		{
			AbortProgram "Missing BASE file in $aBaseFile\n";
		}
	}

	if( scalar @aBase > 0 )
	{
		my @aEntry = (	$aRcRef->{ $aBase[0] },
						$aProd, $aTimeline, $aSp, $aRc
						);

		push @gPlan, \@aEntry;
	}

	#
	# Look at the DB options
	# Install only one DB option
	#
	if( scalar @aDb > 1 )
	{
		# Apply preference and try to narrow down the choice
		my @aPrefList = grep /$aPrefRegExpr/, @aDb;

		if( scalar @aPrefList <= 0 )
		{
			# preference do no good - as good as no preference
			@aPrefList = @aDb;
		}

		if( scalar @aPrefList == 1 )
		{
			# preference narrow down to one choice
			@aDb = @aPrefList;
		}
		elsif( $gPromptUser )
		{
			# ask the user
			my @aChoice =
				map {  $aProd . '_' . $aTimeline
						. '.' . $aSp . '.' . $aRc . '_' . $_ }
						sort $sortDb @aPrefList;
						# sort $sortDb @aDb;

			### allow to choose not to install
			push @aChoice, 'none (no database)';
			my $aIdxNone = $#aChoice;

			my( $aAnsIdx, $aAnsWord ) =
				multiple_choice
					"Please choose from these DATABASE OPTIONs",
					@aChoice;

			if( $aAnsIdx != $aIdxNone )
			{
				@aDb = ( $aDb[ $aAnsIdx ] );
			}
			else
			{
				@aDb = ();
			}
		}
		else
		{
			# choose by database preference order and shortest
			# - if cannot ask user
			@aDb = sort $sortDb @aPrefList;
		}
	}

	if( scalar @aDb > 0 )
	{
		my @aEntry = (	$aRcRef->{ $aDb[0] },
						$aProd, $aTimeline, $aSp, $aRc
						);

		push @gPlan, \@aEntry;
	}

	#
	# Look at the Other options
	# Any number of Other options can be installed.
	#
	if( scalar @aOther > 0
	 && $gPromptUser )
	{
		my @aList = map 
			{ $aProd . '_' . $aTimeline . '.' . $aSp . '.' . $aRc
				. '...' . $_ } @aOther;

		my @aYesList = SelectFromList 
					"Should OPTION \"%s\" be installed ?",
					@aList
					;

		@aOther = @aOther[ @aYesList ];
	}

	foreach my $aOptKey (@aOther)
	{
		my @aEntry = (	$aRcRef->{ $aOptKey },
						$aProd, $aTimeline, $aSp, $aRc
						);

		push @gPlan, \@aEntry;
	}

	#
	# Look at the Patches
	# The patch id should be unique and ordered 
	#
	@aPatch = sort @aPatch;
	if( scalar @aPatch > 0
	 && $gPromptUser )
	{
		my @aChoice =
			map { 'Up-to ' . $aProd . '_' . $aTimeline . '.'
				. $aSp . '.' . $aRc
				. '...' . $_ } reverse @aPatch;

		push @aChoice, 'None';

		my( $aAnsIdx, $aAnsWord ) =
			multiple_choice
				"Which of these PATCHes should be installed ?",
				@aChoice;

		if( $aAnsIdx >= $#aChoice )
		{
			# no patch if choose none
			@aPatch = ();
		}
		else
		{
			$aAnsIdx = $#aPatch - $aAnsIdx;
			@aPatch = @aPatch[ 0 .. $aAnsIdx ];
		}
	}

	#
	# verify the patches are in sequence and complete
	#
	if( scalar @aPatch > 0 )
	{
		my $aCount = 0;
		for( my $idx = 0 ; $idx < scalar @aPatch ; ++ $idx ) 
		{
			my $aOptKey = $aPatch[$idx];

			my $idx2;
			if( $aOptKey =~ /^P(\d+)/ )
			{
				$idx2 = $1;				
			}

			if( $idx2 != $idx + 1 )
			{
				++ $aCount;
				WriteMsg sprintf(
					"WARNING: Found PATCH %s while expect P%02d in %s\n",
					$aOptKey, $idx + 1,
					$aProd . '_' . $aTimeline . '.' . $aSp . '.' . $aRc
					);
			}
		}

		if( $aCount > 0 )
		{
			my @aPatchList =
				map {	"\t" . $aProd . '_' . $aTimeline . '.'
						. $aSp . '.' . $aRc
						. '...' . $_ } @aPatch;

			my $aPatchList = join "\n", @aPatchList;

			my( $aAnsIdx, $aAnsWord ) =
				multiple_choice(
					"Available PATCHes\n$aPatchList\n"
					. "Some PATCH(es) are missing."
					. " How to you want to continue ?",
					'Continue without any PATCHes',
					'Continue with the problematic PATCHes' );
			if( $aAnsIdx == 0 )
			{
				@aPatch = ();
				WriteMsg "WARNING: Skipping problematic PATCHes\n";
			}
			else
			{
				WriteMsg "WARNING: Continue with problematic PATCHes\n";
			}
		}
	}

	foreach my $aOptKey (@aPatch)
	{
		my @aEntry = (	$aRcRef->{ $aOptKey },
						$aProd, $aTimeline, $aSp, $aRc
						);

		push @gPlan, \@aEntry;
	}

	###
}	### ChooseOption
	###

#
#	Examine data structure and
#	compose the ordered list of file to be installed.
#
sub MakePlan
{
	foreach my $aProd (sort $sortProduct keys %gFile)
	{
		my $aProdRef = $gFile{ $aProd };

		# There should be only one time-line entry left
		foreach my $aTimeline (keys %{$aProdRef})
		{
			my $aTimelineRef = $aProdRef->{ $aTimeline };

			# There can be multiple service-pack entries 
			foreach my $aSp (sort keys %{$aTimelineRef})
			{
				my $aSpRef = $aTimelineRef->{ $aSp };

				# There should be only one release-candidate entry left
				foreach my $aRc (sort keys %{$aSpRef})
				{
					my $aRcRef = $aSpRef->{ $aRc };
					ChooseOption( $aProd, $aTimeline, $aSp, $aRc, $aRcRef );
				}
			}
		}
	}

	if( $gDebug )
	{
		printf Dumper [ 'gPlan', \@gPlan ];
	}

	###
}	### MakePlan
	###

#
#	Show the installation plan (list of file to be installed)
#	and prompt for confirmation.
#
sub ConfirmPlan
{
	if( scalar @gPlan <= 0 )
	{
		AbortProgram "\nWARNING: Nothing to install\n";
	}

	# check if all tgz file really exists
	# do checking after files are selected
	# - allow installation if bad files are not selected.
	foreach my $aItem (@gPlan)
	{
		my $aPath = $aItem->[0];
		my $aFullPath = "$gPathTgz/$aPath";
		$aFullPath = "$gPathBaseline/$aPath"
			if( $gBaselineMode );

		### check if the file/link to be installed is valid
		if( scalar( stat $aFullPath ) <= 0 )
		{
			AbortProgram "ERROR: [$aFullPath] is a broken link\n";
		}
	}

	if( $gAskConfirm )
	{
		my $aStr = '';
		foreach my $aEntry (@gPlan)
		{
			$aStr .= sprintf "%s\n", $aEntry->[0];
		}

		my( $aAnsIdx, $aAnsWord ) =
			multiple_choice
				"\nFiles to install\n----------------\n$aStr\n"
				. "Please confirm to install the above ordered files.",
				'yes : continue with installation',
				'no  : abort installation'
				;
		if( $aAnsIdx != 0 )
		{
			AbortProgram "Terminate without installing:\n$aStr";
		}
	}

	# adding installation history to log file
	# Write history now
	# - allow redo installation in case of unexpected problem.
	if( ! $gHistoryMode
	 && ! $gBaselineMode )
	{
		my $aTime = time();
		foreach my $aItem (@gPlan)
		{
			my $aPath = $aItem->[0];
			printf LOG "i%d:%s\n", $aTime, $aPath;
		}
	}

	###
}	### ConfirmPlan
	###

sub CheckProgram
{
	my( $aPgm ) = @_;

	if( (system( "type $aPgm >/dev/null 2>&1" ) >> 8) != 0 )
	{
		AbortProgram "ERROR: Program [$aPgm] missing from PATH\n";
	}

	###
}	### CheckProgram
	###

#
#	Given the installation plan, execute it.
#
sub ExecutePlan
{
	# Check for write permission under home directory
	if( ! -w $gPathHome )
	{
		# Cannot continus w/o write permission.
		AbortProgram "ERROR: No Write Permission in [$gPathHome]";
	}

	# Rename existing directory
	my $aNameCnt = 1;
	while( -d $gPathInstall )
	{
		my $aNewPath = $gPathInstall . '_' . $aNameCnt;
		if( ! -d $aNewPath )
		{
			if( rename( $gPathInstall, $aNewPath ) )
			{
				WriteMsg "INFO: Renamed $gPathInstall to $aNewPath\n";
				last;
			}
		}

		++ $aNameCnt;
	}

	# Now create dir for installation
	if( mkdir( $gPathInstall, 0777 ) )
	{
		WriteMsg "INFO: Created directory [$gPathInstall]\n";
	}
	else
	{
		AbortProgram
			"ERROR: Fail to create installation directory [$gPathInstall]";
	}

	# check if external programs present
	CheckProgram 'tar';
	CheckProgram 'gunzip';

	# ungzip and untar
	foreach my $aItem (@gPlan)
	{
		my $aPath = $aItem->[0];
		my $aFullPath = "$gPathTgz/$aPath";
			WriteMsg sprintf( "INFO: Installing file [%s]\n", $aPath );

		my $aCmd = 
			"cd $gPathInstall && chmod -R u+w . &&"
			." gunzip -c $aFullPath | tar xvf -";

		printf "Running: [$aCmd]\n"
			if( $gDebug );

		my $aCmdRc = system( $aCmd );	printf "\n";
		$aCmdRc >>= 8;
		if( $aCmdRc != 0 )
		{
			AbortProgram "Error: Fail to run [$aCmd] (rc=$aCmdRc)\n";
		}
	}

	###
}	### ExecutePlan
	###

sub RecoverHistory
{
	
	if( ! defined $gHistoryFile )
	{
		$gHistoryFile = $gPathLogFile;
	}

	open( HISTORY, $gHistoryFile )
		or AbortProgram "ERROR: Fail to open history file [$gHistoryFile]\n";

	while( <HISTORY> )
	{
		chomp;

		if( /^i(\d+):/ )
		{
			$gHistory{ $1 } = []
				if( ! exists $gHistory{ $1 } );

			push @{$gHistory{ $1 }}, $';
		}
	}

	close( HISTORY );

	###
}	### RecoverHistory
	###

sub SelectHistoryPlan
{
	printf "There are %d installation(s) in the history.\n",
		scalar keys %gHistory;

	my @aList = sort { $a <=> $b } keys %gHistory;

	my $idx = 1;
	foreach my $aTime (@aList)
	{
		my $aTimeStr = GetTimeString( $aTime );
		printf "[$idx] $aTimeStr\n";

		printf "%s\n", join "\n", map { "\t" . $_ } @{$gHistory{$aTime}};
		++ $idx;
	}

	my( $aAnsIdx, $aAnsWord ) =
		multiple_choice(
			"Please choose to repeat an installation in the history :",
			( 'Abort Installation', map { GetTimeString($_) } @aList ));
	if( $aAnsIdx == 0 )
	{
		AbortProgram "INFO: User aborted program\n";
	}

	foreach my $aFile (@{ $gHistory{ $aList[$aAnsIdx - 1] } })
	{
		push @gPlan, [ $aFile ];
	}

	###
}	### SelectHistoryPlan
	###

#
#	Find new files in the specified dir
#
sub findNewFile
{
	return 
		if $name !~ m#^$gTmpFindAllFileSrc/#;

	my $aRelPath = $';

	if( $aRelPath =~ m#^(log|tmp)$# )
	{
		$prune = 1;
		return;
	}

	return
		if( $aRelPath =~ /\.(debug|log)$/ );

	if( ! -f "$gPathInstall/$aRelPath"
	 && ! -d "$gPathInstall/$aRelPath" )
	{
		push( @gTmpNewFile, $aRelPath );
	}

	###
}	### findNewFile
	###


#
#	Find all files in the specified dir
#
sub findFile
{
	return 
		if $name !~ m#^$gTmpFindAllFileSrc/#;

	my $aRelPath = $';

	if( $aRelPath =~ m#(^|/)(log|tmp)$# )
	{
		$prune = 1;
		return;
	}

	return
		if( $aRelPath =~ m#(^|/)(core|tvslog)$# );


	return
		if( $aRelPath =~ m#\.(debug|log)$# );

	return
		if( $gTmpNewFileOnly
		 && (-f "$gTmpFindAllFileDst/$aRelPath"
		  || -d "$gTmpFindAllFileDst/$aRelPath" ) );

	push( @gTmpNewFile, $aRelPath );

	###
}	### findFile
	###

#
#	Return check sum of the specified file
#
sub CheckSum
{
	my( $aPath ) = @_;
    local $/;
	undef $/;

	open( CHECKSUM, $aPath )
		or AbortProgram "ERROR: Fail to checksum [$aPath]\n";
	my $aChkSum = unpack( "%32C*", <CHECKSUM> );
	close( CHECKSUM );

	return $aChkSum;
	###
}	### CheckSum
	###

#
#	Examine the specified files and see if they contains
#	different content.
#
sub HasDiffContent
{
	my( $aSrcPath, $aDstPath ) = @_;

	return 1
		if( -s $aSrcPath != -s $aDstPath );

	return 1
		if( CheckSum( $aSrcPath ) != CheckSum( $aDstPath ) );
	
	return 0;

	###
}	### HasDiffContent	
	###

#
#	Copy the specified item (file or directory) from
#	the src dir to destination.
#	If the directory not already exist, it will be created.
#	If the file already exist and the files are different,
#	the existing one will renamed first before copy.
#
sub CopyItem
{
	my( $aItem, $aSrcDir, $aDstDir ) = @_;

	my $aSrcPath = "$aSrcDir/$aItem";
	my $aDstPath = "$aDstDir/$aItem";

	if( -d $aSrcPath )
	{
		# ignore the fact that src is symlink
		# treat it as plain dir - try to confine
		# to local env - avoid changing file elsewhere
		# do nothing if dir already exist
		if( ! -d $aDstPath )
		{
			if( ! mkdir $aDstPath )
			{
				AbortProgram "ERROR: Fail to mkdir [$aDstPath]\n";
			}
		}

		WriteMsg "INFO: Made Directory [$aDstPath]";
	}
	elsif( -f $aSrcPath )
	{
		my $aDoCopy = 1;

		# deal with the destination side
		# rename existing file or file-link
		if( -f $aDstPath )
		{
			# check files contains same content
			$aDoCopy = HasDiffContent( $aSrcPath, $aDstPath );

			if( $aDoCopy )
			{
				my $idx = 1;
				++$idx while( -f $aDstPath . '_' . $idx );

				if( ! rename $aDstPath, $aDstPath . '_' . $idx )
				{
					AbortProgram "ERROR: Fail to rename [$aDstPath]\n";
				}

				WriteMsg "INFO: Renamed File [$aDstPath]";
			}
		}

		# copy
		if( ! $aDoCopy )
		{
			WriteMsg "INFO: Same File [$aDstPath]";
		}
		elsif( -l $aSrcPath )
		{
			# it is a link
			my $aLink = readlink $aSrcPath;
			if( ! symlink $aLink, $aDstPath )
			{
				AbortProgram
					"ERROR: Fail to link [$aLink] as [$aDstPath]\n";
			}

			WriteMsg "INFO: Linked [$aLink] as [$aDstPath]";
		}
		else
		{
			# it is a plain file
			if( ! copy $aSrcPath, $aDstPath )
			{
				AbortProgram
					"ERROR: Fail to copy to [$aDstPath]\n"
					. "       from [$aSrcPath]\n";
			}

			WriteMsg "INFO: Copied File [$aDstPath]";
		}
	}
	elsif( -l $aSrcPath )
	{
		WriteMsg
			"WARNING: Broken link [$aSrcPath] - copy skipped\n";
	}
	else
	{
		WriteMsg
			"WARNING: Unknow type [$aSrcPath] - copy skipped\n";
	}

	###
}	### CopyItem
	###

#
#
#
sub CopyNewCfg
{
	my( $aDesc, $aSrcDir, $aDstDir ) = @_;

	if( defined $aSrcDir )
	{
		WriteMsg "INFO: Scanning NEW files under $aDesc directory\n";

		@gTmpNewFile = ();
		$gTmpNewFileOnly = 1;
		$gTmpFindAllFileSrc = $aSrcDir;
		$gTmpFindAllFileDst = $aDstDir;
		File::Find::find(
			{   wanted  => \&findFile },
			$aSrcDir,
			);
		
		printf Dumper [ "gTmpNewFile($aDesc)", \@gTmpNewFile ]
			if( $gDebug );

		foreach my $aRelPath (@gTmpNewFile)
		{
			CopyItem $aRelPath, $aSrcDir, $aDstDir;
		}

		WriteMsg "INFO: Done copying $aDesc directory\n";
	}

	###
}	### CopyNewCfg
	###

#
#
#
sub CopyAllCfg
{
	my( $aDesc, $aSrcDir, $aDstDir ) = @_;

	if( defined $aSrcDir )
	{
		if( $aSrcDir =~ m#^$gPathCurrDirProd(/|$)# )
		{
			WriteMsg
				"INFO: $aDesc directory is under OPRODUCT dir - skipped\n";
		}
		else
		{
			WriteMsg "INFO: Scanning files under $aDesc directory\n";

			@gTmpNewFile = ();
			$gTmpNewFileOnly = 0;
			$gTmpFindAllFileSrc = $aSrcDir;
			$gTmpFindAllFileDst = $aDstDir;
			File::Find::find(
				{   wanted  => \&findFile },
				$aSrcDir,
				);

			printf Dumper [ "gTmpNewFile($aDesc)", \@gTmpNewFile ]
				if( $gDebug );

			foreach my $aRelPath (@gTmpNewFile)
			{
				CopyItem $aRelPath, $aSrcDir, $aDstDir;
			}

			WriteMsg "INFO: Done copying $aDesc directory\n";
		}
	}

	###
}	### CopyAllCfg
	###

sub CopyCfg
{
	#	Process directory in this order
	# 	1.	Product directory (gPathCurrDirProd)
	# 	2.	Ist directory (gPathCurrDirIst)
	# 	3.	Site directory (gPathCurrDirOsite)
	#
	#	1.	For Product directory:
	#	.	Skip sub-dir /log
	#	.	Skip sub-dir /tmp
	#	.	Copy all files that are not present in the new env
	#	.	Overwrite all existing files under sub-dir /cfg, /istdir,
	#		/ositeroot with file from Product directory. Overwritten
	#		files are renamed (suffixed by date).
	#
	# 	2.	For Ist directory:
	#	.	Skip if just /istdir under Product dir
	#	.	Write all files/dirs in Ist directory to the /istdir sub-dir
	#		in the new env. Overwrite w/o rename if file already exist.
	#
	# 	3.	For Osite directory:
	#	.	Skip if just /ositeroot under Product dir
	#	.	Write all files/dirs in Osite directory to the /ositeroot sub-dir
	#		in the new env. Overwrite w/o rename if file already exist.
	#
	#	Highlight
	#	.	Hence, all ua_* directories from the tgz files
	#		are left untouched.


	# Process Product dir
	CopyNewCfg 'OPRODUCT', $gPathCurrDirProd, $gPathInstall;

	# Process Ist dir
	mkdir "$gPathInstall/istdir";
	CopyAllCfg	'IST', $gPathCurrDirIst,
				"$gPathInstall/istdir";

	# Process Osite dir
	mkdir "$gPathInstall/ositeroot";
	CopyAllCfg	'OSITE', $gPathCurrDirOsite,
				"$gPathInstall/ositeroot";

	###
}	### CopyCfg
	###

#
#	Scan under /lib subdir for item lib*-*.*.*.*
#	and look for those that are not linked as
#	destination and delete them.
#
sub CleanUpLib
{
	my $aDir = "$gPathInstall/lib";
	opendir( DIR, $aDir )
		or AbortProgram "ERROR: Fail to read [$aDir]\n";
	my @aList = grep !/^\./, readdir DIR;
	closedir DIR;

	#
	#	1.	pick out the lib*-*.*.*.* and save to hash
	#	2.	pick out symlink and remove entry from hash
	#	3.	remove left over in hash
	#
	my %aLib;

	foreach (@aList)
	{
		$aLib{ $_ } = undef
			if( /^lib(\w+)-(\d+)\.(\d+)\.(\d+)\.(\w+)$/ );
	}

	foreach (@aList)
	{
		delete $aLib{ readlink "$aDir/$_" }
			if( -l "$aDir/$_" );
	}

	foreach (sort keys %aLib)
	{
		if( ! unlink "$aDir/$_" )
		{
			WriteMsg "ERROR: Fail to delete lib [$aDir/$_]\n";

		}

		WriteMsg "INFO: Deleted obsolete lib [$aDir/$_]";
	}

	WriteMsg "INFO: Done deleting obsolete libraries\n";

	# For HPUX, there is speed advantages to make DLL non-writable
	if( $gOsName =~ /HPUX/ )
	{
		my $aCmdRc = system( "cd $gPathInstall/lib && chmod 555 *.sl" );
		$aCmdRc >>= 8;
		if( $aCmdRc != 0 )
		{
			WriteMsg
			"WARNING: Fail to chmod 555 $gPathInstall/lib (rc=$aCmdRc)\n";
		}

		WriteMsg "INFO: Done chmod-555 libraries\n";
	}

	###
}	### CleanUpLib
	###

#
#	Create a profile file that setup most of the environment
#	for run-time.
#	Also ensure the directories being pointed to are valid.
#
sub MakeProfile
{
	#
	# ensure basic dir are present
	#
	foreach(	'log', 'log/sys', 'log/debug', 'log/coredump',
				'tmp', 'ositeroot', 'istdir' )
	{
		my $aPath = "$gPathInstall/$_";

		if( ! -d $aPath )
		{
			if( ! mkdir $aPath )
			{
				AbortProgram "ERROR: Fail to mkdir [$aPath]\n";
			}

			WriteMsg "INFO: Made Directory [$aPath]";
		}
	}

	#
	#	setup:
	#	.	$ISTMBREGION
	#	.	$LD_LIBRARY_PATH/$SHLIB_PATH/$LIBPATH,
	#	.	$PATH,
	#	.	$OPRODUCT_ROOT
	#	.	$OSITE_ROOT, $ISTDIR
	#	.	$OTMPDIR, $OLOGDIR
	#	not:
	#	.	database specific setting
	#

	if( -f $gProfile )
	{
		my $idx = 1;
		++$idx while( -f $gProfile . '_' . $idx );

		if( ! rename $gProfile, $gProfile . '_' . $idx )
		{
			AbortProgram "ERROR: Fail to rename [$gProfile]\n";
		}

		WriteMsg "INFO: Renamed File [$gProfile] to [..._$idx]";
	}

	open( PROFILE, "> $gProfile" )
		or AbortProgram "ERROR: Fail to write to profile [$gProfile]\n";

	print PROFILE <<EOT;
#! /usr/bin/env ksh

#
# ISTMBREGION might need to be customized in sites
# where there are multiple concurrently running IST systems
# on one computer.
#
ISTMBREGION=1
export ISTMBREGION

PATH=\$PATH:$gPathInstall/bin:$gPathInstall/istdir/bin/shell
export PATH

LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$gPathInstall/lib
export LD_LIBRARY_PATH

SHLIB_PATH=\$SHLIB_PATH:$gPathInstall/lib
export SHLIB_PATH

LIBPATH=\$LIBPATH:$gPathInstall/lib
export LIBPATH

OPRODUCT_ROOT=$gPathInstall
export OPRODUCT_ROOT

OSITE_ROOT=$gPathInstall/ositeroot
export OSITE_ROOT

ISTDIR=$gPathInstall/istdir
export ISTDIR

OLOGDIR=$gPathInstall/log
export OLOGDIR

OTMPDIR=$gPathInstall/tmp
export OTMPDIR

EOT

	close PROFILE;

	if( ! chmod( 0775, $gProfile ) )
	{
		AbortProgram "ERROR: Fail to chmod profile [$gProfile]\n";
	}

	WriteMsg "INFO: Made Profile [$gProfile]\n";

	###
}	### MakeProfile
	###

###
sub MakeGenEnvCmd
{
	my $aCmd = 'eval `gen_env SRC PDIR BDIR ';

	my @aDirList = map { $gPathBaseline . '/' . $_->[0] } @gPlan;
	$aCmd .= join ':', reverse @aDirList;
	$aCmd .= '`';

	if( -f $gProfile )
	{
		my $idx = 1;
		++$idx while( -f $gProfile . '_' . $idx );

		if( ! rename $gProfile, $gProfile . '_' . $idx )
		{
			AbortProgram "ERROR: Fail to rename [$gProfile]\n";
		}

		WriteMsg "INFO: Renamed File [$gProfile] to [..._$idx]";
	}

	open( PROFILE, "> $gProfile" )
		or AbortProgram "ERROR: Fail to write to profile [$gProfile]\n";
	printf PROFILE "%s\n", $aCmd;
	close PROFILE;

	printf "\nCMD=>\n$aCmd\n\n";

	if( ! chmod( 0775, $gProfile ) )
	{
		AbortProgram "ERROR: Fail to chmod profile [$gProfile]\n";
	}

	WriteMsg "INFO: Made Profile [$gProfile]\n";

	###
}	### MakeGenEnvCmd
	###

#
#
#
sub RunPgm
{
	my( $aPgm, $aReturnCode, $aOutput ) = @_;

	my $aPath = "$gPathInstall/bin/$aPgm";

	# check if pgm exists
	return 
		if( ! -f $aPath );

	++ $gTestCnt;

	if( ! -x $aPath )
	{
		WriteMsg "ERROR: Pgm not executable [$aPath]";
		return;
	}

	my $aCmd = "$aPgm > $gPathTmp 2>&1 ";
	my $aRc = system( $aCmd );
	$aRc >>= 8;

	local $/;
	undef $/;
	open( TMP, $gPathTmp )
		or AbortProgram "ERROR: Fail to read tmp file [$gPathTmp]\n";
	my $aOut = <TMP>;
	close( TMP );

	if( $gDebug )
	{
		if( ref $aReturnCode )
		{
			printf "TEST $aPgm : ReturnCode [$aRc] expecting [%s]\n",
				join ',', @{$aReturnCode}
				;
		}
		else
		{
			printf "TEST $aPgm : ReturnCode [$aRc] expecting [$aReturnCode]\n";
		}
		printf "TEST $aPgm : Output:\n$aOut\nExpecting:\n$aOutput\n\n";
	}

	if( $aOut =~ /Execute permission denied/i
	 || $aOut =~ /cannot execute/i
	 || $aOut =~ /syntax error at line/i
	 )
	{
		WriteMsg "INFO: TEST Failed  $aPgm - INCOMPATIBLE";
		return;
	}

	# 0 return-code is always good
	if( $aRc != 0 && defined $aReturnCode )
	{
		if( ref $aReturnCode )
		{
			my $aPat = join '|', @{$aReturnCode};
			if( $aRc !~ /^$aPat$/ )
			{
				WriteMsg "INFO: TEST Failed  $aPgm - RETURN";
				return;
			}
		}
		else
		{
			if( $aRc != $aReturnCode )
			{
				WriteMsg "INFO: TEST Failed  $aPgm - RETURN";
				return;
			}
		}
	}

	if( defined $aOutput )
	{
		if( $aOut !~ /$aOutput/i )
		{
			WriteMsg "INFO: TEST Failed  $aPgm - OUTPUT";
			return
		}
	}

	WriteMsg "INFO: TEST Succeed $aPgm";
	++ $gTestCntGood;

	###
}	### RunPgm
	###

#
# Perform some basic test to check the health of the binaries
#
sub RunabilityTest
{
	if( ! -d $gPathInstall )
	{
		AbortProgram "ERROR: Missing installation directory [$gPathInstall]\n";
	}

	# get confirmation
	my( $aAnsIdx, $aAnsWord ) =
		multiple_choice(
			"Do you want to exercise some run test on the binaries ?",
			'Yes', 'No' );

	if( $aAnsIdx == 1 )
	{
		WriteMsg "INFO: Skipped run test\n";
		return;
	}

	# get 3rd party library path
	print <<EOT;
Please specify all 3rd party library paths - particularly
the database library paths. Without these libraries, most
exeutables will fail to run.

     - - - - - - - - Notes - - - - - - - - 
     The setting in LD_LIBRARY_PATH/LIBPATH
     /SHLIB_PATH are not referenced since
     they may be polluted with libraries
     that were installed previously.
     - - - - - - - - - - - - - - - - - - -

Please specify library paths - seperate mulitple paths with colon :
EOT

	my $aLibPath = <STDIN>;

	my $aPathExe = "$gPathInstall/bin";
	my @aPathLib = ( "$gPathInstall/lib", split(/:/, $aLibPath),
						'/usr/lib' );
	my $aPathLib = join ':', @aPathLib;

	local $ENV{'ENV'} = undef;
	local $ENV{'PATH'} = "$aPathExe:$aPathLib";
	local $ENV{'LD_LIBRARY_PATH'} = $aPathLib;
	local $ENV{'SHLIB_PATH'} = $aPathLib;
	local $ENV{'LIBPATH'} = $aPathLib;

	# for FO
	RunPgm 'mb',		1, 		'Invalid invocation'			;
	RunPgm 'mbcmd',		1, 		'Mail box system not active'	;
	RunPgm 'mbtsk',		1, 		'Invalid invocation'			;
	RunPgm 'mbport',	1,		undef							;
	RunPgm 'istagent',	1,		undef							;
	RunPgm 'oasisvm',	1,		undef							;
	RunPgm 'cmmt',		0,		'Usage'							;
	RunPgm 'DBM_test',	0,		undef							;
	RunPgm 'ua',		255,	'Usage'							;
	RunPgm 'isttmap',	255,	'Invalid invocation'			;
# 	security changed behaviour over versions - bad chooice
#	RunPgm 'security',	2,		'Missing port'					;
#	RunPgm 'securitycmd',	1,	undef							;

	# for MSIM
	RunPgm 'bengine',	254,	'IST/bengine'					;

	# for SW
	RunPgm 'shc',		[1,143],undef							;
	RunPgm 'shccmd',	1,		undef							;
	RunPgm 'dbdatmsrv',	1,		undef							;
	RunPgm 'possrv',	1,		undef							;
	RunPgm 'visa',		1,		undef							;
	RunPgm 'istreplay',	1,		undef							;

	# for CL
	RunPgm 'clearing',	1,		undef							;
	RunPgm 'ua_ipm_export',	255,'Usage'							;
	RunPgm 'ua_inet_export',255,'Usage'							;
	RunPgm 'ua_base2_export',255,'Usage'						;
	RunPgm 'ua_ocs_export',255,'Usage'							;

	# for AC
	RunPgm 'oassrv',	0,		undef							;
	RunPgm 'querysrv',	1,		undef							;
	RunPgm 'cardgen',	1,		undef							;
	RunPgm 'pinfilegen',1,		undef							;
	RunPgm 'cardappl',	1,		undef							;

	# for MA
	RunPgm 'sch_cmd',	1,		undef							;
	RunPgm 'curUpd',	1,		'Usage'							;

	# for IM

	unlink( $gPathTmp )
		if( -f $gPathTmp );

	if( $gTestCnt <= 0 )
	{
		WriteMsg "INFO: No available test found !\n"
				."      This is unusual - please validate your installation\n"
				."      and ensure it is complete.\n"
				;
	}
	else
	{
		my $aSuccessPerc = $gTestCntGood * 100 / $gTestCnt;
		WriteMsg sprintf
			"INFO: %d test(s) out of %d (%d %%) successful\n",
			$gTestCntGood,
			$gTestCnt,
			$aSuccessPerc,
			;
		if( $aSuccessPerc < 50 )
		{
			WriteMsg
			 "WARNING: Many tests failed ! Please verify:\n"
			."         .   3rd party library paths is complete and correct\n"
			."         .   the computer you are running test on\n"
			."             match the installed software\n"
			."         .   installation combination is complete and correct\n\n"
			."         If the problem persists, report this to Efunds.\n"
			;
		}
		elsif( $aSuccessPerc < 100 )
		{
			WriteMsg
			 "INFO: The reason of not able to achieve 100% may be\n"
			."      due to incomplete 3rd party library or change\n"
			."      in behaviour in some programs. It may not be\n"
			."      a concern.\n"
			;
		}
	}

	###
}	### RunabilityTest
	###

sub DisplayHelp
{
	my $aPgm = basename $0;

	print <<EOT;

Usage: $aPgm OPTIONS

The script scans the gzipped-tar files under ~/tgz directory,
discovers all available products, along with their time-lines,
service-packs, release-candidates and options, then create
a new execution environment.

It can either install all the latest of all available products,
or show the choices to the user and prompt the user to make the
decision.

All installation activities are captured to the log file
~/build_env.log. This log file also encodes the date and files
that have been installed, which allow these installations to be
examined and repeated in the future.

The result of each installation is a blank new directory
~/pdir<install-date>. Should this directory already exist,
it will be renamed as ~/pdir<install-date>_<id> where <id>
is some interger that make the renamed directory unique.

User can also specify Product, Ist and Site directories of
an existing environment. This way, existing user specified
configuration files can be copied to the new environment.

OPTIONS:

     -ask
          Prompt user on all decision.
          Without this option, the default is to try to select
          the latest binaries with all available product,
          service-packs and options.

     -baseline
          Work with baseline directories under \$HOME/baseline.

          Instead of installing files from the tgz directories
          into a single directory for production purposes,
          generate a gen_env profile that links multiple baseline
          directories for development purposes.

          Only Efunds developers at the Toronto office is supposed
          to use this option.

     -dp=OPRODUCT-DIR
     -di=IST-DIR
     -ds=OSITE-DIR
          Copy configuration files from the specified directories
          after contents are restored from tar-gz files.

          If the run time environment variables are set, you can
          specify:

             build_env.pl ... \\
                  -dp=\$OPRODUCT_ROOT -di=\$ISTDIR -ds=\$OSITE_ROOT

          The OPRODUCT-DIR (if specifed) is processed first, followed by
          IST-DIR (if specifed) and then OSITE-DIR (if specifed).

          The copy procedure is conducted in such a way that UA
          configuration directories (ua_*) are considered non-customizable
          and hence contents from tar-gz files and are left untouched.

     -debug
          Enable debugging mode.

     -help
          Show the help information that you are looking at.

     -install=INSTALLATION-DIR
          Change the installation destination directory from
          \$HOME/pdir<today-date> to INSTALLATION-DIR.

     -history
     -history=HISTORY-FILE
          Discover installations that have been performed in the past and
          allow these installations to be repeated.

          The history is recovered from the log file. If HISTORY-FILE is
          not specified, the default log (~/build_env.log) is read.

          User will be prompted to choose one of these historical
          installation to be install again.

     -noconfirm
          Disable prompting user for confirmation before actual installation.

     -nodefault
          Don't allow default in multiple choices. 
          User has to explcitly type in a choice - instead of just
          press ENTER.

     -oe=OPTION
          Exclude the specified option from the available list of 
          optional gzipped-tar files.

          OPTION functions as a regular expression that is matched
          against gzipped-tar files.

          This is effective in reducing user interaction by definitively
          eliminate some possibilities.

          For example, if both Oracle and Informix options file are 
          available and -oe=INF effectively leave only Oracle options files.
          User has less likely to be prompted to make a decision.

     -op=OPTION
          Specify preference on the specified option from the available
          list of optional gzipped-tar files.

          OPTION functions as a regular expression that is matched
          against gzipped-tar files.

          This is less effective than the exclude operation (-oe),
          in reducing user interaction. User is still prompted
          to choose when there are multiple preferred files.
          
          Both -oe and -op should be used together to narrow down
          possibilities.

     -os=OS-STRING
          Specify the Operation-System (Platform) string.

          By default, the script will compute the string itself.

          There are situtation when user want to explicitly 
          specify the OS-STRING.

          (1) Cross platform installation. Install binaries on
          a platform that is different from the target platform.

          (2) Binary compatible installation. Install binaries that
          are built on a older platform. For example, installing
          SOL-280 binaries on a SOL-290 platform.

     -prod=PRODUCT
          Specify the code of a product to be installed.
          Multiple -prod=PRODUCT arguments can be specified to 
          install multiple products.

     -test
          Skip installation and perform runability tests on 
          some selected binaries, if present.

          The option can be combined with the -debug option to show
          for more detail information.

          This option is useful when try to repeat the tests after fixing
          the 3rd party library paths without re-installing everything, or
          just checking the status of the binaries periodically. Beware,
          however, the fact that AIX cache libraries in the OS may make
          the result unreliable.

Examples:

     $aPgm -prod=FO -prod=SW
         To install only Foundation and Switch.

     $aPgm -ask -prod=FO
         To install only Foundation and prompt user on all decisions.

     $aPgm -prod=FO -oe=DB2 -oe=SYB -op=OPZ
         To install only Foundation, exclude DB2 and Sybase options
         and perfer optizmized binaries if available.

     $aPgm -hist
         To examine the installation history and protentially
         repeat one of them.

     $aPgm -os=AIX-5 -ask
         To install from all AIX 5.X binaries and prompt user on all
         decisions.

EOT

	###
}	### DisplayHelp
	###

sub ParseArgument
{
	foreach (@ARGV)
	{
		if( /^-a/ )
		{
			$gPromptUser = 1;
		}
		elsif( /^-b/ )
		{
			$gBaselineMode = 1;
		}
		elsif( $_ eq '-d' )
		{
			$gDebug = 1;
		}
		elsif( /^-di\w*=/ )
		{
			$gPathCurrDirIst = $';
			$gPathCurrDirIst =
				VerifyPath $gPathCurrDirIst, 'IST directory';
		}
		elsif( /^-ds\w*=/ )
		{
			$gPathCurrDirOsite = $';
			$gPathCurrDirOsite =
				VerifyPath $gPathCurrDirOsite, 'OSITE directory';
		}
		elsif( /^-dp\w*=/ )
		{
			$gPathCurrDirProd = $';
			$gPathCurrDirProd =
				VerifyPath $gPathCurrDirProd, 'OPRODUCT directory';
		}
		elsif( /^-hist/ )
		{
			$gHistoryMode = 1;
			my $aRest = $';
			if( $aRest =~ /=/ )
			{
				$gHistoryFile = $';
			}
		}
		elsif( /^-h/ )
		{
			DisplayHelp;
			exit 0;
		}
		elsif( /^-i\w*=/ )
		{
			$gPathInstall = $';
		}
		elsif( /^-noconfirm/ )
		{
			$gAskConfirm = 0;
		}
		elsif( /^-nodefault/ )
		{
			$gAllowDefault = 0;
		}
		elsif( /^-oe=/ )
		{
			# options to be excluded
			++ $gExclList{ $' };
		}
		elsif( /^-op=/ )
		{
			# options that are preferred
			++ $gPrefList{ $' };
		}
		elsif( /^-os=/ )
		{
			$gOsName = $';
		}
		elsif( /^-prod=/ )
		{
			$gProdList{ $' } = undef;
		}
		elsif( /^-t/ )
		{
			$gTestMode = 1;
		}
		elsif( /^-/ )
		{
			printf "ERROR: Invalid Option [$_]\n";
			exit -1;
		}
	}

	###
}	### ParseArgument
	###

#
#	Section:	Main
#
sub main
{
	ParseArgument;

	open( LOG, ">> $gPathLogFile" ) 
		or die "ERROR: Fail to write to log file [$gPathLogFile]\n";
	printf "INFO: Opened log file $gPathLogFile\n";

	WriteMsg "INFO: HOME=$gPathHome\n";

	if( ! -w $gPathHome )
	{
		# Just a warning for now
		printf "WARNING: No Write Permission in [$gPathHome]\n";
	}

	my($s,$m,$h,$D,$M,$Y,$wday,$yday,$isdst) =
		localtime(time);

	my $aName = sprintf "%04d%02d%02d",
		1900 + $Y, $M + 1, $D;

	$gProfile = sprintf "%s/profile%s", $gPathHome, $aName
		if( ! defined $gProfile );

	$gPathInstall = sprintf "%s/pdir%s", $gPathHome, $aName
		if( ! defined $gPathInstall );

	SetOsString;

	if( $gTestMode )
	{
		RunabilityTest;
	}
	else
	{
		if( $gHistoryMode )
		{
			RecoverHistory;
			SelectHistoryPlan;
		}
		else
		{
			ScanTgzDir;
			ChooseProduct;
			ChooseLevel;
			MakePlan;
		}

		ConfirmPlan;

		if( $gBaselineMode )
		{
			MakeGenEnvCmd;
		}
		else
		{
			ExecutePlan;
			CopyCfg;
			CleanUpLib;
			MakeProfile;
			RunabilityTest;
		}
	}

	WriteMsg "Program Completed\n\n - = - = - = -\n\n";
	close( LOG );

	printf "INFO: Installation in $gPathInstall\n"
		if( ! $gBaselineMode );
	printf "INFO: Profile in $gProfile\n";
	printf "INFO: Log file in $gPathLogFile\n\n";

	###
}	### main
	###

main;


