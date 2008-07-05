# -*-perl-*-
# This file is a part of twitmark, http://code.google.com/p/twitmark/
# Copyright (c) 2008 Jun Morimoto <morimoto@mrmt.net>
# This program is covered by the GNU General Public License 2.
package Twitmark::URI;
use strict;
use warnings;
use URI;
use overload '""' => \&normalize;

################################################################
sub new{
	my($class, $uri) = @_;
	my $me = {};
	$me->{uri} = new URI($uri);
	bless $me;
}

################################################################
sub normalize{
	my $me = shift;

	# Imprement some URI normalization rules here
	# Rules are better to written in YAML (or so), than hard-coded
	my $host = $me->{uri}->host();
	my $path = $me->{uri}->path_query();
	if($me->{uri}->scheme() eq 'http'){
		if($host =~ /^www\.amazon\.(co\.jp|co\.uk|com|ca|de|fr)$/){
			$path =~ s|/gp/product/|/dp/|;
			$path =~ s|/exec/obidos/ASIN/|/dp/|;
			if($path =~ s|^.*(/dp/[0-9A-Z]+).*|$1|){
				$me->{uri}->path_query($path);
			}
		}
		if($host =~ /^(jp|www)\.youtube\.com$/){
			$me->{uri}->host('www.youtube.com');
			if($path =~ s|^(/watch\?v=[a-zA-Z0-9_]+).*|$1|){
				$me->{uri}->path_query($path);
			}
		}
	}

	$me->{uri}->canonical->as_string;
}

if(__FILE__ eq $0){
	for my $url qw(
		http://jp.youtube.com/watch?v=_V3rM47BVrc
		http://www.youtube.com/watch?v=_V3rM47BVrc
		http://jp.youtube.com/watch?v=tvXPup13mKg&feature=related
		http://www.amazon.co.jp/gp/product/handle-buy-box/ref=dp_start-bbf_1_glance
		http://www.amazon.co.jp/Closer-Joy-Division/dp/B00002DE4E/ref=sr_1_7?ie=UTF8&s=music&qid=1215229635&sr=8-7
		http://www.amazon.co.jp/exec/obidos/ASIN/B000086F7S/mrmtnet-22/ref=nosim/			){
		print '< ', $url, "\n";
		print '> ', new Twitmark::URI($url), "\n";
		print "\n";
	}
}

1;

=head1 NAME

 Twitmark::URI - Normalize URIs

=head1 SYNOPSIS

 my $u = new Twitmark::URI('http://www.amazon.co.jp/Vienna-Ultravox/dp/B0000074OC/ref=sr_1_1?ie=UTF8&s=music&qid=1214109494&sr=1-1');
 print $u->normalize();

 or simply

 print new Twitmark::URI('http://www.amazon.co.jp/Vienna-Ultravox/dp/B0000074OC/ref=sr_1_1_blah_blah');

=head1 DESCTIPTION

This module normalizes specified URI (make it canonical).  Only rules
against various amazon items are impremented.

=head1 CONSTRUCTORS

The following method construct new C<Twitmark::URI> object.

=over 4

=item $uri = new Twitmark::URI($url)

=back

=head1 COMMON METHODS

=over 4

=item $uri->normalize()

Normalizes (make it canonical) specified URI.  You can omit this
method by just evaluate Twitmark::URI object as string.

=back

=head1 COPYRIGHT

Copyright (c) 2008 Jun Morimoto.  This program is covered by the GNU
General Public License 2.

=head1 AUTHORS / ACKNOWLEDGMENTS

C<Twitmark::URI> was developed by Jun Morimoto.

=cut
