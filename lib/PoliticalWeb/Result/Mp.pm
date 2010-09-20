package PoliticalWeb::Result::Mp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

PoliticalWeb::Result::Mp

=cut

__PACKAGE__->table("mp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 mp_name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 twfy_id

  data_type: 'integer'
  is_nullable: 0

=head2 twfy_mem_id

  data_type: 'integer'
  is_nullable: 0

=head2 image_url

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 party

  data_type: 'char'
  is_nullable: 1
  size: 30

=head2 bbc_url

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 guardian_url

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 edm_url

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 wikipedia_url

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 official_site_url

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "mp_name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "twfy_id",
  { data_type => "integer", is_nullable => 0 },
  "twfy_mem_id",
  { data_type => "integer", is_nullable => 0 },
  "image_url",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "party",
  { data_type => "char", is_nullable => 1, size => 30 },
  "bbc_url",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "guardian_url",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "edm_url",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "wikipedia_url",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "official_site_url",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 constituencies

Type: has_many

Related object: L<PoliticalWeb::Result::Constituency>

=cut

__PACKAGE__->has_many(
  "constituencies",
  "PoliticalWeb::Result::Constituency",
  { "foreign.mp" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-09-20 16:33:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qMpiRohEtSAqRQkvAmbWGQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
