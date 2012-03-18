package PoliticalWeb::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 45 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user_constituencies

Type: has_many

Related object: L<PoliticalWeb::Schema::Result::UserConstituency>

=cut

__PACKAGE__->has_many(
  "user_constituencies",
  "PoliticalWeb::Schema::Result::UserConstituency",
  { "foreign.user" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-03-18 16:38:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XZACBwSqu3R/1bSHPIe2qg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
