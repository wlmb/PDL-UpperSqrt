use lib 'inc';
use v5.36;
use lib 'inc';
use ExtUtils::MakeMaker;
use Inline::Module;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    NAME              => 'PDL::UpperSqrt',
    VERSION_FROM      => 'lib/PDL/UpperSqrt.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/PDL/UpperSqrt.pm', # retrieve abstract from module
    AUTHOR            => 'Luis Mochan <mochan@fis.unam.mx>',
    LICENSE           => 'perl',
    postamble => {
	inline => {
	    module => 'PDL::UpperSqrt',
	    stub => 'PDL::UpperSqrt::Inline',
	    ilsm => 'Inline::Pdlpp',
	    makestub => 1,
	},
    },
    );
