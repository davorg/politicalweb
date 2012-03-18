package PoliticalWeb::Schema::Result::MpLink;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Schema::Result::MpLink

=cut

__PACKAGE__->table("mp_link");

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
  size: 45

=head2 mp

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
  { data_type => "varchar", is_nullable => 1, size => 45 },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-03-18 16:38:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5Wf8X81TbVgUsIp/ahdu2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
