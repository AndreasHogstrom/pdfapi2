use Test::More;

use strict;
use warnings;

use PDF::API2;
use Scalar::Util qw(isweak);
use Test::Memory::Cycle;

# RT #56681: Devel::Cycle throws spurious warnings since 5.12
local $SIG{'__WARN__'} = sub { warn $_[0] unless $_[0] =~ /Unhandled type: GLOB/ };

# Read a simple PDF

my $pdf = PDF::API2->open('t/resources/sample.pdf');
memory_cycle_ok($pdf, q{Open sample.pdf});

# Check pagestack weakened status

my $page = $pdf->page();
ok(isweak($pdf->{'pagestack'}->[-1]),
   q{An appended page is marked as weakened in the page stack});

$page = $pdf->page(1);
ok(isweak($pdf->{'pagestack'}->[0]),
   q{A prepended page is marked as weakened in the page stack});

$page = $pdf->page(1);
ok(isweak($pdf->{'pagestack'}->[1]),
   q{A spliced page is marked as weakened in the page stack});

done_testing();
