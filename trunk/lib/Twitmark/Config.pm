# -*-perl-*-
# Twitmark::Config
# Copyright (c) 2008 Jun Morimoto <morimoto@mrmt.net>
# This program is covered by the GNU General Public License 2

package Twitmark::Config;
use strict;
use warnings;
use Config::YAML;

use AppConfig qw(:argcount);
use Cwd;
our @ISA = qw(AppConfig);

################################################################
sub new{
	my ($class, $version, @argv) = @_;
	my $me = $class->SUPER::new(
		{
			CASE => 1,
			GLOBAL => {
				ARGCOUNT => ARGCOUNT_ONE,
			}
		},
		qw(irc_nick irc_username irc_desc
		   irc_server irc_port irc_password irc_channel
		   ping_delay reconnect_delay
		   version daemonize pid_dir pid_file)
		);

	# set default values
	$me->version($version);
	$me->daemonize(0);
	$me->irc_nick('mubot');
	$me->irc_desc('mubot');
	$me->irc_port(6667);
	$me->ping_delay(30);
	$me->reconnect_delay(10);
	$me->pid_dir('/var/run');
	$me->pid_file('mubot.pid');

	if(defined $argv[0]){
		unless($me->file($argv[0])){
			die "Can't read $argv[0], exit.\n";
		}
		shift(@argv);
	}else{
		unless($me->file('/etc/twitmark.conf')){
			die "Can't read /etc/twitmark.conf, exit.\n";
		}
	}

	$me->args(\@argv);

	unless(defined $me->irc_username()){
		::log_die("irc_username does not specified, exit.");
	}

	unless(defined $me->irc_server()){
		::log_die("irc_server does not specified, exit.");
	}

	$me;
}

################################################################
sub file{
	my $me = shift;
	my $file = shift;
	if(-r $file){
		$me->SUPER::file($file);
		::log("Loaded configuration file: $file");
		return 1;
	}
	::log("$file does not exist");
	0;
}

1;
