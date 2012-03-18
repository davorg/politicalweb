package PoliticalWeb::Schema::Result::ConstituencyLink;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Schema::Result::ConstituencyLink

=cut

__PACKAGE__->table("constituency_link");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 constituency

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "constituency",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
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
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-03-18 16:38:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tifgLNyGt0lUzNY7Epf1ug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
