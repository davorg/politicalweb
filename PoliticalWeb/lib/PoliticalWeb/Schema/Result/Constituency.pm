package PoliticalWeb::Schema::Result::Constituency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Schema::Result::Constituency

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

Related object: L<PoliticalWeb::Schema::Result::Mp>

=cut

__PACKAGE__->belongs_to(
  "mp",
  "PoliticalWeb::Schema::Result::Mp",
  { id => "mp" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 constituency_links

Type: has_many

Related object: L<PoliticalWeb::Schema::Result::ConstituencyLink>

=cut

__PACKAGE__->has_many(
  "constituency_links",
  "PoliticalWeb::Schema::Result::ConstituencyLink",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 urls

Type: has_many

Related object: L<PoliticalWeb::Schema::Result::Url>

=cut

__PACKAGE__->has_many(
  "urls",
  "PoliticalWeb::Schema::Result::Url",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_constituencies

Type: has_many

Related object: L<PoliticalWeb::Schema::Result::UserConstituency>

=cut

__PACKAGE__->has_many(
  "user_constituencies",
  "PoliticalWeb::Schema::Result::UserConstituency",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-03-18 16:38:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hzCQrsZiMUwIMBxUwQJoPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
