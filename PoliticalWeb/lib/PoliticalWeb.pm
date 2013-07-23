package PoliticalWeb;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use Data::Dumper;

use PoliticalWeb::Constituency;

our $VERSION = '0.1';

check_page_cache;

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

get '/constituencies/' => sub {
  my $con_rs = schema->resultset('Constituency');
  my $page = template 'constituencies/index', {
    constits => [ $con_rs->search({}, { order_by => 'name'} )->all ]
  };
  cache_page $page;
  return $page;
};

true;
