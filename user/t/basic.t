use v5.36;
use Test::More;
use PDL;
use PDL::Constants qw(PI);

BEGIN{use_ok('PDL::UpperSqrt');}

my $eiO = exp(i()*sequence(10)*PI/4);
my $sqrt=upper_sqrt($eiO);
ok(approx($sqrt**2,$eiO)->all, "Square of sqrt");
ok(($sqrt->im >= 0)->all, "Im sqrt");
my $neg=sequence(10)-5;
my $negsqrt=$neg->upper_sqrt;
ok(approx($negsqrt**2,$neg)->all, "Square of sqrt of real");
ok(($negsqrt->im >= 0)->all, "Im sqrt of real");
say $negsqrt;
done_testing;
