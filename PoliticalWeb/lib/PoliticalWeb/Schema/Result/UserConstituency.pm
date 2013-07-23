use utf8;
package PoliticalWeb::Schema::Result::UserConstituency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PoliticalWeb::Schema::Result::UserConstituency

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_constituency>

=cut

__PACKAGE__->table("user_constituency");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 user

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 constituency

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "constituency",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 constituency

Type: belongs_to

Related object: L<PoliticalWeb::Schema::Result::Constituency>

=cut

__PACKAGE__->belongs_to(
  "constituency",
  "PoliticalWeb::Schema::Result::Constituency",
  { id => "constituency" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<PoliticalWeb::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PoliticalWeb::Schema::Result::User",
  { id => "user" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-07-23 16:14:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TPHWJ/+SqJO/9sKyBIjSOg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
