package PDL::UpperSqrt;

use v5.36;
#$DB::single=1;
#use FindBin;
our $VERSION = '0.01';
# use AutoLoader qw(AUTOLOAD);
require Exporter;
our @ISA=qw(Exporter);
our @EXPORT=qw(upper_sqrt);
use PDL;

use PDL::UpperSqrt::Inline 'Pdlpp' => <<'FIN';
pp_def('upper_sqrt',
    GenericTypes => [reverse qw(G C)],
    Pars => 'i(); [o] o()',
    Code => q{
        $GENERIC() tmp=csqrt($i());
        if(cimag(tmp)<0){
             tmp = -tmp;
        }
        $o() = tmp;
    }
);
#use FindBin;
#use lib "$FindBin::Bin/../../../../..";
FIN

*upper_sqrt = \&PDL::upper_sqrt;

1;

__END__


=encoding utf-8


=head1 NAME

PDL::UpperSqrt - Complex square root in the upper half plane

=head1 SYNOPSIS

  use PDL::UpperSqrt;
  $x=...
  my $y = $x->upper_sqrt;  # obtain the square root in upper complex half plane
  my $y = upper_sqrt($x);  # same

=head1 DESCRIPTION

PDL::UpperSqrt exports the function/method upper_sqrt which takes the square root
of a complex number whose imaginary part is not negative, i.e., it is a square root
with a branch cut 'infinitesimally' below the positive real axis. The
default PDL square root places the branch cut along the negative real axis.

=head1 METHODS

=head2 $x->upper_sqrt

=head1 FUNCTIONS

=head2 upper_sqrt($x)

=head1 AUTHOR

W. Luis Mochan E<lt>mochan@fis.unam.mxE<gt>

=head1 COPYRIGHT

Copyright 2025- W. Luis Mochan

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
