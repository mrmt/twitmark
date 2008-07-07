# -*- mode: perl, coding: utf-8 -*-
# This file is a part of twitmark, http://code.google.com/p/twitmark/
# Copyright (c) 2008 Jun Morimoto <morimoto@mrmt.net>
# This program is covered by the GNU General Public License 2.
package Twitmark;
use DBI;
use strict;
use warnings;
use utf8;

################################################################
sub new{
	my($class, %arg) = @_;
	my $me = {};
	$me->{Config} = $arg{Config};
	bless $me;
}

################################################################
sub connect{
	my $me = shift;
	unless($me->{dbh}){
		$me->{dbh} = DBI->connect($me->{Config}->{db_source},
					  $me->{Config}->{db_user},
					  $me->{Config}->{db_password},
					  {
						  RaiseError => 1,
						  AutoCommit => 0,
					  });
	}
}

################################################################
sub disconnect{
	my $me = shift;
	if($me->{dbh}){
		$me->{dbh}->disconnect();
	}
}

################################################################
sub timestr{
	my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
	sprintf('%04d/%02d/%02d %02d:%02d:%02d',
		$year+1900, $mon+1, $day, $hour, $min, $sec);
}

################################################################
sub insert{
	my ($me, %arg) = @_;

	unless(length $arg{url}){
		warn 'url does not specified.';
		return;
	}

	$me->connect();
	my $sth = $me->{dbh}->prepare(q/SELECT COUNT(*) FROM marks WHERE mark_url=?/);
	$sth->execute($arg{url});
	my @r = $sth->fetchrow_array();
	if($r[0]){
		return 'DUPLICATED:'; # TODO: ダブリを詳しく報告
	}

	$sth = $me->{dbh}->prepare(q/INSERT INTO marks(mark_channel, mark_nick, mark_prefix, mark_url, mark_message, mark_time) VALUES(?, ?, ?, ?, ?, ?)/);
	eval {
		$sth->execute($arg{channel}, $arg{nick}, $arg{prefix}, $arg{url}, $arg{message}, timestr());
		$me->{dbh}->commit();
	};
	if($@){
		eval {
			$me->{dbh}->rollback();
		};
		return 'ERROR:' . $me->{dbh}->errstr();
	}
	return 'OK:' . $sth->{mysql_insertid};
}

################################################################
sub delete{
	my ($me, %arg) = @_;

	unless(length $arg{nick}){
		warn 'nick does not specified.';
		return;
	}

	$me->connect();
	my $sth = $me->{dbh}->prepare(q/SELECT mark_id FROM marks WHERE MARK_NICK = ? ORDER BY mark_id DESC LIMIT 1/);

	$sth->execute($arg{nick});
	my @r = $sth->fetchrow_array();
	my $mark_id = $r[0];
	unless($mark_id){
		return 'NOTFOUND:';
	}

	$sth = $me->{dbh}->prepare(q/DELETE FROM marks WHERE mark_id = ?/);
	eval {
		$sth->execute($mark_id);
		$me->{dbh}->commit();
	};
	if($@){
		eval {
			$me->{dbh}->rollback();
		};
		return 'ERROR:' . $me->{dbh}->errstr();
	}
	return 'OK:' . $mark_id;
}

################################################################
sub add_mark{
	my ($me, %arg) = @_;
	return $me->insert(%arg);
}

################################################################
sub delete_mark{
	my ($me, %arg) = @_;
	return $me->delete(%arg);
}

1;

__END__
