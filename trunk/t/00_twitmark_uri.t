# -*-perl-*-
use strict;
use warnings;
use Test::Simple tests => 15;

use Twitmark::URI;

my $t;
ok($t = new Twitmark::URI('http://www.barks.jp/news/?id=1000041440&ref=rss'));
ok($t->normalize() eq 'http://www.barks.jp/news/?id=1000041440');
ok('' . $t eq 'http://www.barks.jp/news/?id=1000041440');
ok($t = new Twitmark::URI('http://jp.youtube.com/watch?v=_V3rM47BVrc'));
ok('' . $t eq 'http://www.youtube.com/watch?v=_V3rM47BVrc');
ok($t = new Twitmark::URI('http://www.youtube.com/watch?v=_V3rM47BVrc'));
ok('' . $t eq 'http://www.youtube.com/watch?v=_V3rM47BVrc');
ok($t = new Twitmark::URI('http://jp.youtube.com/watch?v=tvXPup13mKg&feature=related'));
ok('' . $t eq 'http://www.youtube.com/watch?v=tvXPup13mKg');
ok($t = new Twitmark::URI('http://www.amazon.co.jp/gp/product/handle-buy-box/ref=dp_start-bbf_1_glance'));
ok('' . $t eq 'http://www.amazon.co.jp/gp/product/handle-buy-box/ref=dp_start-bbf_1_glance');
ok($t = new Twitmark::URI('http://www.amazon.co.jp/Closer-Joy-Division/dp/B00002DE4E/ref=sr_1_7?ie=UTF8&s=music&qid=1215229635&sr=8-7'));
ok('' . $t eq 'http://www.amazon.co.jp/dp/B00002DE4E');
ok($t = new Twitmark::URI('http://www.amazon.co.jp/exec/obidos/ASIN/B000086F7S/mrmtnet-22/ref=nosim/'));
ok('' . $t eq 'http://www.amazon.co.jp/dp/B000086F7S');
