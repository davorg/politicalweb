package PoliticalWeb::Result::Constituency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Result::Constituency

=cut

__PACKAGE__->table("constituency");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 mp

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "mp",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 mp

Type: belongs_to

Related object: L<PoliticalWeb::Result::Mp>

=cut

__PACKAGE__->belongs_to(
  "mp",
  "PoliticalWeb::Result::Mp",
  { id => "mp" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 urls

Type: has_many

Related object: L<PoliticalWeb::Result::Url>

=cut

__PACKAGE__->has_many(
  "urls",
  "PoliticalWeb::Result::Url",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-09-20 16:33:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s3p9Chd8pPshowLWJazpfQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
