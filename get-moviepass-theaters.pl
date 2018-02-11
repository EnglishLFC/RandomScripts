#!/usr/bin/env perl
#
# File name: get-moviepass-theaters.pl
# Date:      2017/08/16 13:19
# Author:    Nigel Houghton <wutang@warpten.net>
#
#############################################################################
#
# Simple script that grabs JSON from moviepass for a zip code and pretty
# prints the results
#
use strict;
use warnings;

use lib qw(..);
use Data::Dumper;
use JSON qw( );
use LWP::UserAgent;

my $zip = $ARGV[0];

unless (($#ARGV > -1) && ($ARGV[0] =~ m/^\d{5}$/)) {
  print "Need a 5 digit zip code" . "\n";
  exit;
}

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12");
 
# Create a request
my $req = HTTP::Request->new(GET => "https://www.moviepass.com/theaters/zip/$zip");
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

# Get the json object ready and read in our result
my $json = JSON->new;
my $data = $json->decode($json_text);

# Print what we have
print "Moviepass Theaters for zip code: " . $zip ."\n";
print "=" x 80 . "\n";

for ( @{$data->{'theaters'}} ) {
   print $_->{name}."\n";
   print join(", ", $_->{address},$_->{city},$_->{state},$_->{zip}) . "\n";
   print "-" x 80 . "\n";
}

__END__
