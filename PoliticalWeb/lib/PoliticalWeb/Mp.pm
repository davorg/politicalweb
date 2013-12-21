package PoliticalWeb::Mp;

use strict;
use warnings;
use 5.010;

use Moose;
use WebService::TWFY::API;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Cache::CHI;
use Encode qw[encode decode];

my $twfy_query = WebService::TWFY::API->new({
  key => $ENV{TWFY_KEY}
}) or die $!;

has twfy => (
  is   => 'ro',
  isa  => 'HashRef',
);
 
has db => (
  is   => 'rw',
  isa  => 'PoliticalWeb::Schema::Result::Mp',
  handles => [qw(twitter)],
);

sub new_from_constituency_name {
  my $class = shift;
  my $constit_name = shift;
  
  my $twfy = _get_from_cache($constit_name) || _get_from_twfy($constit_name);
  my $db   = _get_from_db($constit_name, $twfy);

  return unless $twfy && $db;

  return $class->new({ twfy => $twfy, db => $db });
}

sub _get_from_cache {
  my $name = shift;
  $name =~ s/\s+/+/g;
  return cache_get "M:$name";  
}

sub _get_from_twfy {
  my $constit_name = shift;

  my $mp;
  my $ret = $twfy_query->query( 'getMP', {
    constituency => encode('iso-8859-1', $constit_name),
  });

  # debug Dumper $ret;

  if ($ret->{is_success}) {
    $mp = from_json(encode('utf8', decode('iso-8859-1', $ret->{results})));
    return if $mp->{error};

    # debug Dumper $mp;

    my $ret = $twfy_query->query( 'getMPInfo', {
      id => $mp->{person_id},
    });
    
    if ($ret->{is_success}) {
      $mp->{extra} = from_json(encode('utf8', decode('iso-8859-1', $ret->{results})));   
    }

    $constit_name =~ s/\s+/+/g;
    cache_set "M:$constit_name", $mp, 60*60*60;
  } else {
    return;
  }  
}

sub _get_from_db {
  my $constit_name = shift;
  my $twfy = shift;

  return schema->resultset('Mp')->find_or_create({
    mp_name => $twfy->{full_name},
    twfy_id => $twfy->{person_id},
  });  
}

sub blog {
  my $self = shift;

  return $self->get_link('blog');
}

sub blog_feed {
  my $self = shift;

  return $self->get_link('blogfeed');
}


sub get_link {
  my $self = shift;
  my $type = shift;

  my ($link) = $self->db->mp_links({
    type => $type,
  });

  return unless $link;
  return $link->url;
}


1;
