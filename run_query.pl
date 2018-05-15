use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;

my $towns_filename 	 = "MA_Towns.txt";
my $user_agents_filename = "user_agents.txt";
my $proxy_url            = "https://gimmeproxy.com/api/getProxy?user-agent=true&anonymityLevel=1&supportsHttps=true";
my $ua                   = LWP::UserAgent->new();

my $proxy_res            = $ua->get($proxy_url);
$ua->proxy(['https'], $proxy_res->{ipPort});

open(my $fh, '<:encoding(UTF-8)', $user_agents_filename)
	or die "Could not open $user_agents_filename: $!";
my $line;
srand;
rand($.) < 1 && ($line = $_) while <$fh>;
warn Dumper( $line );


open(my $fh2, '<', "$towns_filename")
  or die "Could not open file '$towns_filename' $!";
 
while (my $row = <$fh2>) {
	my @towns = split(', ', $row );
	foreach my $town ( @towns ) {
		chomp $town;
		warn Dumper( $town );
	}
	warn Dumper( @towns );
}


