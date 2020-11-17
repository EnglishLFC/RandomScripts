#!/usr/bin/env perl
#
# File name: getcorona.pl
# Date:      2020/03/21 14:00
# Author:    Nigel Houghton <wutang@warpten.net>
# $Id$
# Copyright: (c) Nigel Houghton 2020
#
#############################################################################
#

use strict;
use warnings;

use JSON qw( );
use LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12");
 
# Create a request
my $req = HTTP::Request->new(GET => 'https://corona-stats.online/US?format=json');
$req->content_type('application/x-www-form-urlencoded');
$req->content('query=libwww-perl&mode=dist');
 
# Pass request to the user agent and get a response back
my $res = $ua->request($req);
my $json_text; 
# Check the outcome of the response
if ($res->is_success) {
  $json_text = $res->content;
}
else {
  print $res->status_line, "\n";
  exit;
}

# Now get our JSON sortedout
my $json = JSON->new;
my $data = $json->decode($json_text);

# US Population as of April 6, 2020
# my $uspopulation = 329480988;
my $uspopulation = $data->{data}[0]{population};
my $mortalityrate = sprintf("%.2f", $data->{data}[0]{deaths}/$data->{data}[0]{confirmed} * 100);
my $recoveryrate = sprintf("%.2f", $data->{data}[0]{recovered}/$data->{data}[0]{confirmed} * 100);
my $percentinfected = sprintf("%.2f", $data->{data}[0]{confirmed}/$uspopulation * 100);

print $data->{data}[0]{country} . ":" . "\n"
  . "\t" . "Cases: " . $data->{data}[0]{confirmed} . "\n"
  . "\t(" . $percentinfected . "% of total population)" . "\n"
  . "\tDeaths: " . $data->{data}[0]{deaths}
  . "\tRecovered: " . $data->{data}[0]{recovered} . "\n"
  . "\tMortality Rate: " . $mortalityrate . "%"
  . "\tRecovery Rate: " . $recoveryrate . "%\n";

__END__

=head1 getcorona.pl

=head1 DESCRIPTION

=head1 USAGE
  Just run it.

=head1 AUTHOR
  Nigel Houghton <wutang@warpten.net>

=head1 COPYRIGHT
  (c) Nigel Houghton 2020


