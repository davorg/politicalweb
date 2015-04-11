package PoliticalWeb;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Cache::CHI;
use Data::Dumper;

use PoliticalWeb::Constituency;

our $VERSION = '0.1';

# check_page_cache;

$ENV{PW_USER} && $ENV{PW_PASS}
  or die 'Must set PW_USER and PW_PASS';

my $cfg = dancer_app->config;
$cfg->{plugins}{DBIC}{default}{user} = $ENV{PW_USER};
$cfg->{plugins}{DBIC}{default}{pass} = $ENV{PW_PASS};

get '/' => sub {
  return template 'index' unless keys %{ +params };

  if (my $pc = params->{pc}) {
    params->{constit} = PoliticalWeb::Constituency->name_from_postcode($pc);
  }
  if (params->{constit}) {
    redirect 'http://' . request->host . '/constituency/' . params->{constit};
  }
  
  template 'index', { error => 'Postcode "' . params->{pc} . '"' };
};

get '/about/' => sub {
  my $page = template 'about/index';
  cache_page $page;
  return $page;  
};

get '/register' => sub {
  my $page = template 'register';
  cache_page $page;
  return $page;
};

get '/constituency/?' => sub {
  template 'index', { error => 'That constituency' };
};

get '/constituency/:constname' => sub {
  my $constit = PoliticalWeb::Constituency->new_from_name(params->{constname});
  my $mp      = $constit->get_mp if $constit;

  if ($constit && $mp) {
    my $page = template 'constituency', {
      constit => $constit,
      mp      => $mp,
    };
    cache_page $page;
    return $page;
  } else {
    template 'index', { error => 'Constituency "' . params->{constname} . '"' };
  }
};

get '/constituencies.json' => sub {
  set serializer => 'JSON';
  return { options => [ 'Balham', 'Tooting' ] };
};

get '/constituencies/' => sub {
  my $con_rs = schema->resultset('Constituency');
  my $page = template 'constituencies/index', {
    constits => [ $con_rs->search({}, { order_by => 'name'} )->all ]
  };
  # cache_page $page;
  return $page;
};

true;
