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

my $a = Proc::ForkSafe->wrap(sub { A->new });
my $pid = $a->{pid};

is $a->call("foo"), "foo";
is $pid, $a->{pid};

if (!fork) {
    is $a->call("foo"), "foo";
    isnt $pid, $a->{pid};
    exit;
}
wait;

is $a->call("foo"), "foo";
is $pid, $a->{pid};

done_testing;
