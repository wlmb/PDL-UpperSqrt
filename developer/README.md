# NAME

PDL::UpperSqrt - Complex square root in the upper half plane

# SYNOPSIS

    use PDL::UpperSqrt;
    $x=...
    my $y = $x->upper_sqrt;  # obtain the square root in upper complex half plane
    my $y = upper_sqrt($x);  # same

# DESCRIPTION

PDL::UpperSqrt exports the function/method upper\_sqrt which takes the square root
of a complex number, choosing that whose imaginary part is not negative, i.e., it is a square root
with a branch cut 'infinitesimally' below the positive real axis. The
default PDL square root places the branch cut along the negative real axis.

# METHODS

## $x->upper\_sqrt

# FUNCTIONS

## upper\_sqrt($x)

# AUTHOR

W. Luis Mochan <mochan@fis.unam.mx>

# COPYRIGHT

Copyright 2025- W. Luis Mochan

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
