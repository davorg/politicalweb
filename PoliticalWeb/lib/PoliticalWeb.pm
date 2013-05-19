package PoliticalWeb;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use WebService::TWFY::API;
use Data::Dumper;

my $twfy = WebService::TWFY::API->new({
  key => $ENV{TWFY_KEY}
}) or die $!;
my $con_rs = schema->resultset('Constituency');
my $mp_rs  = schema->resultset('Mp');

our $VERSION = '0.1';

get '/' => sub {
  return template 'index' unless keys %{ +params };

  if (params->{pc}) {
    params->{constit} = get_const_name_from_pc(params->{pc});
  }
  if (params->{constit}) {
    redirect 'http://' . request->host . '/constituency/' . params->{constit};
  }
  
  template 'index', { error => 'Postcode "' . params->{pc} . '"' };
};

get '/about/' => sub {
  template 'about/index';  
};

get '/constituency/:constname' => sub {
  my $constit = get_const(params->{constname});
  my $mp      = get_mp($constit) if $constit;

  if ($constit && $mp) {
    template 'constituency', {
      constit => $constit,
      mp      => $mp,
    };
  } else {
    template 'index', { error => 'Constituency "' . params->{constname} . '"' };
  }
};

get '/constituencies/' => sub {
  template 'constituencies/index', { constits => [ $con_rs->search({}, { order => 'name'} )->all ] };
};

sub get_const {
  my ($con, $ret);
  unless ($con = cache_get "C:$_[0]") {
    $ret = $twfy->query( 'getConstituency', {
      name => $_[0],
      postcode => '',
    });

    debug Dumper $ret;

    if ($ret->{is_success}) {
      $con = from_json($ret->{results});
      return if $con->{error};
      debug "Setting cache key - 'C:$_[0]'";
      debug 'Setting cache val - ' . Dumper(from_json($ret->{results}));
      cache_set "C:$_[0]", $con, 60*60*60;
    } else {
      return;
    }
  }

  debug Dumper $con;
  
  $con->{db} = $con_rs->find_or_create({ name => $con->{name} });
  
  return $con;
}

sub get_const_name_from_pc {
  my $ret = $twfy->query( 'getConstituency', {
    postcode => $_[0],
  });
    
  if ($ret->{is_success}) {
    my $constit = from_json($ret->{results});
    return if $constit->{error};
    cache_set 'C:' . $constit->{name}, $constit, 60*60*60;
    return $constit->{name};
  }
  
  return;
}

sub get_mp {
  my $constit = shift;
  my $c_name = $constit->{name};

  my $mp;
  unless ($mp = cache_get "M:$c_name") {
    my $ret = $twfy->query( 'getMP', {
      constituency => $c_name,
    });

    debug "TWFY: $ret";

    if ($ret->{is_success}) {
      $mp = from_json($ret->{results});
      return if $mp->{error};

      debug Dumper $mp;

      my $ret = $twfy->query( 'getMPInfo', {
        id => $mp->{person_id},
      });
    
      if ($ret->{is_success}) {
        $mp->{extra} = from_json($ret->{results});
      
      }
      
      cache_set "M:$c_name", $mp, 60*60*60;
    } else {
      return;
    }
  }

  debug "TWFY: MP is " . Dumper $mp;

  $mp->{db} = $constit->{db}->mp;

  return $mp;
}

true;
