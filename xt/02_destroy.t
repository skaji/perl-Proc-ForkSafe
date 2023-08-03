use strict;
use warnings;
use Test2::V0;
use Test2::IPC;

use Proc::ForkSafe;

{
    package A;
    sub new { bless {}, shift }
    sub foo { "foo" }
}

my $destroy_called = 0;
my $a = Proc::ForkSafe->wrap(
    sub { A->new },
    sub { my $obj = shift; $destroy_called = 1 },
);

is $a->call("foo"), "foo";
is $destroy_called, 0;

if (!fork) {
    is $destroy_called, 0;
    is $a->call("foo"), "foo";
    is $destroy_called, 1;
    exit;
}
wait;

done_testing;
