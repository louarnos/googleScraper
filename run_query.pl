use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;
use HTML::TreeBuilder::XPath;

my $towns_filename 	 = "MA_Towns.txt";
my $user_agents_filename = "user_agents.txt";
my $proxy_url            = "https://gimmeproxy.com/api/getProxy?user-agent=true&anonymityLevel=1&supportsHttps=true";
my $ua                   = LWP::UserAgent->new();

# Get and set random proxy
my $proxy_res            = $ua->get($proxy_url);
$ua->proxy(['https'], $proxy_res->{ipPort});

# Get and set random UA
open(my $fh, '<:encoding(UTF-8)', $user_agents_filename)
	or die "Could not open $user_agents_filename: $!";
my $line;
srand;
rand($.) < 1 && ($line = $_) while <$fh>;
$ua->agent($line);

my $response = $ua->get('https://www.google.com/search?safe=off&q=test&oq=test');
my $results  = $response->decoded_content;

my $tree   	 = HTML::TreeBuilder::XPath->new_from_content( $results );
my @links  	 = $tree->findnodes('//h3[ @class = "r" ]');
my @description  = $tree->findvalues('//span[ @class = "st" ]');
$Data::Dumper::Maxdepth=3;
my $count = 0;
foreach my $link ( @links ) {
	warn Dumper($link->content->[0]->content->[0]);
	warn Dumper($link->content->[0]->{href});
	warn Dumper( $description[$count++]);
}

open(my $fh2, '<', "$towns_filename")
  or die "Could not open file '$towns_filename' $!";
 
#while (my $row = <$fh2>) {
#	my @towns = split(', ', $row );
#	foreach my $town ( @towns ) {
#		chomp $town;
#		warn Dumper( $town );
#	}
#	warn Dumper( @towns );
#}


