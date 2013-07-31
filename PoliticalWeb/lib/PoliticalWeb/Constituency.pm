package PoliticalWeb::Constituency;

use strict;
use warnings;
use 5.010;

use Moose;
use WebService::TWFY::API;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use Encode qw[encode decode];

use PoliticalWeb::Schema::Result::Constituency;
use PoliticalWeb::Mp;

my $twfy_query = WebService::TWFY::API->new({
  key => $ENV{TWFY_KEY}
}) or die $!;

has twfy => (
  is   => 'ro',
  isa  => 'HashRef',
);
 
has db => (
  is   => 'rw',
  isa  => 'PoliticalWeb::Schema::Result::Constituency',
);

sub name_from_postcode {
  my $class = shift;
  my $postcode = shift;

  my $ret = $twfy_query->query( 'getConstituency', {
    postcode => $postcode,
  });
    
  if ($ret->{is_success}) {
    my $constit = from_json(encode('utf8', decode('iso-8859-1', $ret->{results})));
    # debug Dumper $constit;
    return if $constit->{error};
    # cache_set 'C:' . $constit->{name}, $constit, 60*60*60;
    return $constit->{name};
  }
  
  return;
}

sub new_from_name {
  my $class = shift;
  my $name  = shift;

  if ($name =~ /Ynys M/) {
    $name = 'Ynys Mon';
  }

  my $twfy = _get_from_cache($name) || _get_from_twfy($name);
  my $db   = _get_from_db($name);

  return unless $twfy && $db;

  return $class->new({ twfy => $twfy, db => $db });
}

sub _get_from_cache {
  my $name = shift;
  $name =~ s/\s+/+/g;
  return cache_get "C:$name";
}

sub _get_from_twfy {
  my $name = shift;

  my $ret = $twfy_query->query( 'getConstituency', {
    name => encode('iso-8859-1', $name),
    postcode => '',
  });

  # debug Dumper $ret;

  if ($ret->{is_success}) {
    my $con = from_json(encode('utf8', $ret->{results}));
    return if $con->{error};
    $name =~ s/\s+/+/g;
    debug "Setting cache key - 'C:$name'";
    # debug 'Setting cache val - ' . Dumper(from_json(encode('utf8', $ret->{results})));
    cache_set "C:$name", $con, 60*60*60;
  } else {
    return;
  }
}

sub _get_from_db {
  my $name = shift;
  return schema->resultset('Constituency')->find_or_create({ name => $name });
}

sub get_mp {
  my $self = shift;

  my $mp = PoliticalWeb::Mp->new_from_constituency_name($self->twfy->{name});

  $self->db->update({ mp => $mp->db->id }) if $mp;

  return $mp;  
}

1;
