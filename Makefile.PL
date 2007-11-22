use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Vim::Snippet::Converter',
    AUTHOR        => 'Cornelius <c9s@aiink.com>',
    VERSION_FROM  => 'lib/Vim/Snippet/Converter.pm',
    ABSTRACT_FROM => 'lib/Vim/Snippet/Converter.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More' => 0,
        'File::Path' => 0,
        'File::Copy' => 0,
    },
    EXE_FILES => [<bin/*>],
    dist      => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Vim-Snippet-Converter-*' },
);

