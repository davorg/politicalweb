#!/usr/bin/perl

use strict;
use warnings;

use WebService::TWFY::API;
use CGI qw(param header);
use PoliticalWeb;
use XML::LibXML;
use Template;

my $fmt = param('fmt') || 'xml';
my $sch = PoliticalWeb->connect('dbi:mysql:politics:host=politicalweb.org.uk',
                                'politics', 'work4you')
  or die;

my $api = WebService::TWFY::API->new({ key => $ENV{TWFY_KEY} });

if ($fmt eq 'xml') {
  print header(-type => 'text/xml');
} elsif ($fmt eq 'html') {
  print header;
} elsif ($fmt eq 'json') {
  print header(-type => 'application/json');
} else {
  print header(-type => 'text/plain');
}

if (my $pc = param('pc')) {
  print obj2fmt(pc2con($pc), $fmt);
} elsif (my $mp = param('mp')) {

} elsif (my $cons = param('cons')) {
  print obj2fmt(name2con($cons), $fmt);
} else {

}

sub name2con {
  return thing2con({ name => $_[0] });
}

sub pc2con {
  return thing2con({ postcode => $_[0] });
}

sub thing2con {
  my $qry = shift;

  my $doc = twfy_qry('getConstituency', $api, $qry );

  my $name =  $doc->findvalue('//name');

  my ($con) = $sch->resultset('Constituency')->search({
    name => $name,
  });

  return $con;
}

sub twfy_qry {
  my ($qry, $api, $params) = @_;

  $params = {} unless defined $params;

  $params = { output => 'xml', %$params };

  my $rc = $api->query($qry, $params);

  die $rc->{error_code} unless $rc->is_success;

  return XML::LibXML->new->parse_string($rc->{results});
}

sub obj2fmt {
  my ($obj, $fmt) = @_;

  my $out;

  if ($fmt eq 'xml') {
    $out = "<constituency>\n";

    foreach (keys %$obj) {
      $out .= "  <$_>$obj->{$_}</$_>\n";
    }

    $out .= "</constituency>\n";

  } elsif ($fmt eq 'json') {
    $out = qq({\n  "constituency": {\n);

    foreach (keys %$obj) {
      $out .= qq(    "$_": "$obj->{$_}",\n);
    }

    $out .= "  }\n}\n";
  } elsif ($fmt eq 'html') {
    my $tt = Template->new;
    $tt->process(\*DATA, { c => $obj }, \$out)
      or die $tt->error;
  }

  return $out;
}

__END__
[% mp = c.mp;
   IF c.name -%]
<h1>[% c.name %]</h1>
[% IF mp.mp_name -%]
<h2>[% mp.mp_name %] ([% mp.party %])</h2>
[% IF mp.image_url -%]
<img align src="http://theyworkforyou.com/[% mp.image_url %]" />
[% END -%]
<ul>
[% IF mp.official_site_url -%]
  <li><a href="[% mp.official_site_url %]">Official site</a></li>
[% END -%]
  <li><a href="http://theyworkforyou.com/mp/?m=[% mp.twfy_mem_id %]">They Work For You</a></li>
  <ul><li><a href="http://www.theyworkforyou.com/search/?pid=[% mp.twfy_id %]">Recent parliamentary appearances</a> <a href="http://www.theyworkforyou.com/search/rss/?s=speaker%3A[% mp.twfy_id %]"><img src="/feed_sm.png" border="0" alt="web feed" /></a></li></ul>
  <li><a href="[% mp.wikipedia_url %]">Wikipedia Entry</a></li>
  <li><a href="http://publicwhip.org.uk/mp.php?constituency=[% c.name %]">Voting record from Public Whip</a></li>
  <li><a href="[% mp.bbc_url %]">BBC News Page</a></li>
  <li><a href="[% mp.guardian_url %]">Guardian Aristotle Page</a></li>
  <li><a href="http://www.edms.org.uk/mps/[% mp.twfy_mem_id %]/">Early Day Motions</a></li>
  <li><a href="http://technorati.com/search/%22[% mp.mp_name %]%22">Technorati Search</a> <a href="http://feeds.technorati.com/search/%22[% mp.mp_name %]%22"><img src="/feed_sm.png" border="0" alt="web feed" /></a></li>
  <li><a href="http://news.google.com/news?as_epq=[% mp.mp_name %]&as_loc=uk">Google News Search</a> <a href="http://news.google.com/news?as_loc=uk&q=%22[% mp.mp_name %]%22&output=rss"></a><img src="/feed_sm.png" border="0" alt="web feed" /></li>
</ul>
[% ELSE -%]
<p>No current MP. Perhaps a by-election is imminent.</p>
[% END -%]
[% ELSE -%]
<p>No constituency found. Did you enter a full postcode?</p>
[% END -%]
