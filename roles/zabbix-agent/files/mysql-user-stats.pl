#!/usr/bin/env perl
use strict;
use warnings;

use DBI;
use JSON;

my $config = $ARGV[0];
my $mode = $ARGV[1];

my $db = DBI->connect("DBI:mysql:mysql_read_default_file=$config");

if ($mode eq "userstat") {
	my $user = $ARGV[2] // die "user not defined";
	$db->{FetchHashKeyName} = "NAME_lc";
	print encode_json($db->selectrow_hashref("select * from information_schema.user_statistics where user = ?", undef, $user));

} elsif ($mode eq "tablestats") {
	my $schema = $ARGV[2] // die "schema not defined";
	my $table = $ARGV[3] // die "table not defined";
	$db->{FetchHashKeyName} = "NAME_lc";
	print encode_json($db->selectrow_hashref("select * from information_schema.table_statistics where table_schema = ? and table_name = ?", undef, $schema, $table));

} elsif ($mode eq "tablestats_discover") {
	print encode_json({
			data => $db->selectall_arrayref("select table_schema '{#SCHEMA}', table_name '{#TABLENAME}' from information_schema.table_statistics", {Slice=>{}})
		});

} elsif ($mode eq "discover") {
	print encode_json({
			data => $db->selectall_arrayref("select user '{#USERNAME}' from information_schema.user_statistics", {Slice=>{}})
		});

} else {
	die "unhandeled mode";
}
