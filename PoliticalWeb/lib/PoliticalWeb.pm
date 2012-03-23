package PoliticalWeb;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use WebService::TWFY::API;

my $twfy = WebService::TWFY::API->new({
  key => $ENV{TWFY_KEY}
}) or die $!;

our $VERSION = '0.1';

get '/' => sub {
  if (params->{pc}) {
    params->{constit} = get_const_name_from_pc(params->{pc});
  }
  if (params->{constit}) {
    redirect '/constituency/' . params->{constit};
  }
  
  template 'index';
};

get '/about/' => sub {
  template 'about/index';  
};

get '/constituency/:constname' => sub {
  my $constit = get_const(params->{constname});
  my $mp      = get_mp($constit);
  template 'constituency', {
    constit => $constit,
    mp      => $mp,
  };
};

sub get_const {
  unless (cache_get "C:$_[0]") {
    my $ret = $twfy->query( 'getConstituency', {
      name => $_[0],
      postcode => '',
    });
  
    if ($ret->{is_success}) {
      cache_set "C:$_[0]", from_json($ret->{results}), 60*60*60;
    }
  }
  
  my $con = cache_get "C:$_[0]";
  
  my $con_rs = schema->resultset('Constituency');
  if (my $con_db = $con_rs->find({ name => $con->{name} })) {
    $con->{db} = $con_db;
  }
  
  return $con;
}

sub get_const_name_from_pc {
  my $ret = $twfy->query( 'getConstituency', {
    postcode => $_[0],
  });
    
  if ($ret->{is_success}) {
    my $constit = from_json($ret->{results});
    cache_set 'C:' . $constit->{name}, $constit, 60*60*60;
    return $constit->{name};
  }
  
  return;
}

sub get_mp {
  my $constit = shift;
  my $c_name = $constit->{name};
  
  unless (cache_get "M:$c_name") {
    my $ret = $twfy->query( 'getMP', {
      constituency => $c_name,
    });
  
    my $mp;
    if ($ret->{is_success}) {
      $mp = from_json($ret->{results});
    
      my $ret = $twfy->query( 'getMPInfo', {
        id => $mp->{person_id},
      });
    
      if ($ret->{is_success}) {
        $mp->{extra} = from_json($ret->{results});
      
      }
      
      cache_set "M:$c_name", $mp, 60*60*60;
    }
  }
  
  my $mp = cache_get "M:$c_name";
    
  $mp->{db} = $constit->{db}->mp;

  return $mp;
}

true;
