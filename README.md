# NAME

PDL::UpperSqrt - Complex square root in the upper half plane

# SYNOPSIS

    use PDL::UpperSqrt;
    $x=...
    my $y = $x->upper_sqrt;  # obtain the square root in upper complex half plane
    my $y = upper_sqrt($x);  # same

# DESCRIPTION

PDL::UpperSqrt exports the function/method upper\_sqrt which takes the square root
of a complex number choosing that whose imaginary part is not negative, i.e., it is a square root
with a branch cut 'infinitesimally' below the positive real axis. The
default PDL square root places the branch cut along the negative real axis.

# METHODS

  - $x->upper\_sqrt

# FUNCTIONS

  - upper\_sqrt($x)

# INSTALLATION

This repository contains files for a developer and for the user. It
uses Inline::Module to generate automatically two versions of the
module PDL::UpperSqrt::Inline, one for a developer, which (re)compiles
as needed the Pdlpp code in module PDL::UpperSqrt into the .inline
subdirectory of the calling process, and one for the user, which
compiles the Pdlpp code once during installation and loads the
compiled code into a running program when imported.

## As a developer

   ```
   cd developer
   # Edit code if desired
   perl Makefile.PL
   make
   make test
   make distdir
   cd PDL-UpperSqrt-<version>
   perl Makefile.PL
   make
   make test
   make install
   ```

## As a user
   ```
   cd user
   perl Makefile.PL
   make
   make test
   make install
   ```

# WARNING

Under Perl-5.40.0 testing and using after installing issues an error

    Attempt to call undefined import method with arguments ("Pdlpp" ...)
    via package "PDL::UpperSqrt::Inline" (Perhaps you forgot to load the package?)

but afterwards it passes the tests and it runs correctly.

# AUTHOR

W. Luis Mochan <mochan@fis.unam.mx>

# COPYRIGHT

Copyright 2025- W. Luis Mochan

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
