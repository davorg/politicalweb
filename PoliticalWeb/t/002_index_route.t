use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use PoliticalWeb;
use Dancer2::Test apps => [ 'PoliticalWeb' ];

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';
