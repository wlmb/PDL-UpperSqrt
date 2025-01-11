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

PDL::UpperSqrt - Blah blah blah

=head1 SYNOPSIS

  use PDL::UpperSqrt;

=head1 DESCRIPTION

PDL::UpperSqrt is

=head2 EXPORT

upper_sqrt.

=head1 AUTHOR

W. Luis Mochan E<lt>mochan@fis.unam.mxE<gt>

=head1 COPYRIGHT

Copyright 2025- W. Luis Mochan

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

# more documentation
# mailing list
* web sites

=cut
