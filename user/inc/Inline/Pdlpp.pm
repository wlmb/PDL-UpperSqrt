package Inline::Pdlpp;

use strict;
use warnings;

use Config;
use Data::Dumper;
use Carp;
use Cwd qw(cwd abs_path);
use PDL::Core::Dev;

$Inline::Pdlpp::VERSION = '0.4';
use base qw(Inline::C);

#==============================================================================
# Register this module as an Inline language support module
#==============================================================================
sub register {
    return {
	    language => 'Pdlpp',
	    aliases => ['pdlpp','PDLPP'],
	    type => 'compiled',
	    suffix => $Config{dlext},
	   };
}

# handle BLESS, INTERNAL - pass everything else up to Inline::C
sub validate {
    my $o = shift;
    $o->{ILSM} ||= {};
    $o->{ILSM}{XS} ||= {};
    # Shouldn't use internal linking for Inline stuff, normally
    $o->{ILSM}{INTERNAL} = 0 unless defined $o->{ILSM}{INTERNAL};
    $o->{ILSM}{MAKEFILE} ||= {};
    if (not $o->UNTAINT) {
      $o->{ILSM}{MAKEFILE}{INC} = PDL::Core::Dev::PDL_INCLUDE();
    }
    $o->{ILSM}{AUTO_INCLUDE} ||= ' '; # not '' as Inline::C does ||=
    my @pass_along;
    while (@_) {
	my ($key, $value) = (shift, shift);
	if ($key eq 'INTERNAL' or
	    $key eq 'PACKAGE' or
	    $key eq 'BLESS'
	   ) {
	    $o->{ILSM}{$key} = $value;
	    next;
	}
	push @pass_along, $key, $value;
    }
    $o->SUPER::validate(@pass_along);
}

#==============================================================================
# Parse and compile C code
#==============================================================================
sub build {
    my $o = shift;
    # $o->parse; # no parsing in pdlpp
    $o->get_maps; # get the typemaps
    $o->write_PD;
    # $o->write_Inline_headers; # shouldn't need this one either
    $o->write_Makefile_PL;
    $o->compile;
}

#==============================================================================
# Return a small report about the C code..
#==============================================================================
sub info {
    my $o = shift;
    my $txt = <<END;
The following PP code was generated (caution, can be long)...

*** start PP file ****

END
    return $txt . $o->pd_generate . "\n*** end PP file ****\n";
}

#==============================================================================
# Write the PDL::PP code into a PD file
#==============================================================================
sub write_PD {
    my $o = shift;
    my $modfname = $o->{API}{modfname};
    my $module = $o->{API}{module};
    $o->mkpath($o->{API}{build_dir});
    open my $fh, ">", "$o->{API}{build_dir}/$modfname.pd" or croak $!;
    print $fh $o->pd_generate;
    close $fh;
}

#==============================================================================
# Generate the PDL::PP code (piece together a few snippets)
#==============================================================================
sub pd_generate {
    my $o = shift;
    return join "\n", ($o->pd_includes,
		       $o->pd_code,
		       $o->pd_boot,
		       $o->pd_bless,
		       $o->pd_done,
		      );
}

sub pd_includes {
    my $o = shift;
    return << "END";
pp_addhdr << 'EOH';
$o->{ILSM}{AUTO_INCLUDE}
EOH

END
}

sub pd_code {
    my $o = shift;
    return $o->{API}{code};
}

sub pd_boot {
    my $o = shift;
    if (defined $o->{ILSM}{XS}{BOOT} and
	$o->{ILSM}{XS}{BOOT}) {
	return <<END;
pp_add_boot << 'EOB';
$o->{ILSM}{XS}{BOOT}
EOB

END
    }
    return '';
}


sub pd_bless {
    my $o = shift;
    if (defined $o->{ILSM}{BLESS} and
	$o->{ILSM}{BLESS}) {
	return <<END;
pp_bless $o->{ILSM}{BLESS};
END
    }
    return '';
}


sub pd_done {
  return <<END;
pp_done();
END
}

sub get_maps {
    my $o = shift;
    $o->SUPER::get_maps;
    push @{$o->{ILSM}{MAKEFILE}{TYPEMAPS}}, PDL::Core::Dev::PDL_TYPEMAP();
}

#==============================================================================
# Generate the Makefile.PL
#==============================================================================
sub write_Makefile_PL {
    my $o = shift;
    my ($modfname,$module,$pkg) = @{$o->{API}}{qw(modfname module pkg)};
    my $coredev_suffix = $o->{ILSM}{INTERNAL} ? '_int' : '';
    my @pack = [ "$modfname.pd", $modfname, $module ];
    my $stdargs_func = $o->{ILSM}{INTERNAL}
        ? \&pdlpp_stdargs_int : \&pdlpp_stdargs;
    my %hash = $stdargs_func->(@pack);
    delete $hash{VERSION_FROM};
    my %options = (
        %hash,
        VERSION => $o->{API}{version} || "0.00",
        %{$o->{ILSM}{MAKEFILE}},
        NAME => $o->{API}{module},
        INSTALLSITEARCH => $o->{API}{install_lib},
        INSTALLDIRS => 'site',
        INSTALLSITELIB => $o->{API}{install_lib},
        MAN3PODS => {},
        PM => {},
    );
    my @postamblepack = ("$modfname.pd", $modfname, $module);
    push @postamblepack, $o->{ILSM}{PACKAGE} if $o->{ILSM}{PACKAGE};
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 1;
    open my $fh, ">", "$o->{API}{build_dir}/Makefile.PL" or croak;
    print $fh <<END;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;
my \$pack = @{[ Data::Dumper::Dumper(\@postamblepack) ]};
my %options = %\{
END
    print $fh Data::Dumper::Dumper(\%options);
    print $fh <<END;
\};
WriteMakefile(%options);
sub MY::postamble { pdlpp_postamble$coredev_suffix(\$pack); }
END
    close $fh;
}

#==============================================================================
# Run the build process.
#==============================================================================
sub compile {
    my $o = shift;
    # grep is because on Windows, Cwd::abs_path blows up on non-exist dir
    local $ENV{PERL5LIB} = join $Config{path_sep}, map abs_path($_), grep -e, @INC
        unless defined $ENV{PERL5LIB};
    $o->SUPER::compile;
}
sub fix_make { } # our Makefile.PL doesn't need this

1;