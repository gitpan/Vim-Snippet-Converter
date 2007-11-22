package Vim::Snippet::Converter;
use warnings;
use strict;
use File::Path qw(mkpath rmtree);
use File::Copy 'copy';

=head1 NAME

Vim::Snippet::Converter - A Converter for Slippery Snippet Vim Plugin

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use Vim::Snippet::Converter;

    my $vsc = Vim::Snippet::Converter->new();
    open my $in , "<" , "perl.snt";
    open my $out , ">" , "perl_snippets.vim";

    $vsc->convert( $in , $out );

    close $in;
    close $out;

=head1 Command-Line Usage

    scc [filename]

    # for example

    $ scc perl.snt


=cut

sub new {
    my $class = shift;
    return bless {} , $class;
}


sub convert {
    my ( $self , $in , $out ) = @_;
    $self->parse( $in , $out );
    print "Done\n";
}


sub install {
    my $self = shift;
    my $fn = shift;
    my $target_dir = shift || $ENV{HOME} . "/.vim/after/ftplugin/";

    print "Install to $target_dir\n";
    # mkdir $target_dir;
    mkpath $target_dir;
    my $target_fn = $fn;
    $target_fn =~ s{\.snt$}{_snippets.vim};
    $target_fn =~ s{/(.*?)$}{$1};
    copy( $fn , $target_dir . $target_fn );

    print <<END;
    ---------
    Use these settings to beautify your snippet:
        let g:snip_start_tag = "«"
        let g:snip_end_tag = "»"
END

}

sub _gen_trigger {
    my $self = shift;
    my $trigger_name = shift;
    my $snippet_code = shift;

    my $output = "exec \"Snippet $trigger_name ";
    $output .= $snippet_code . "\"\n";
    return $output;
}

sub _gen_snippet {
    my $self = shift;
    my $buf  = shift;

    # strip comment
    $buf =~ s/^#.*//g;

    # place holder
    $buf =~ s{"}{\\"}g;
    $buf =~ s{<<>>}{".st.et."}g;
    $buf =~ s{<<(.+?)>>}{".st."$1".et."}g;
    $buf =~ s{\n}{<CR>}g;
    $buf =~ s{\t}{<TAB>}g;
    return $buf;
}

sub parse {
    my ( $self , $in , $out ) = @_;
	print $out $self->gen_header();
    while (<$in>) { 
        # print $out snippet_gen( $1) 
        if ( my ( $snippet_name ) = ( $_ =~ m/^;(\w+?)$/ ) ) {
            # read snippet template
            
            print "Add trigger: $snippet_name\n";
            my $code_buffer = '';

            R_SNIPPET:
            while( my $tpl_line = <$in> ) {
                if( $tpl_line =~ m/^;end$/ ) {
                    # write template
                    my $snippet_o = $self->_gen_snippet( $code_buffer );
                    print $out $self->_gen_trigger( $snippet_name , $snippet_o );
                    last R_SNIPPET;
                }
                $code_buffer .= $tpl_line;
            }
        }
    }
}

sub gen_header {
	return <<EOF;

" VIM: set fdm=marker:
" Generated by VIM SnippetsEMU Converter
"
if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

" Functions {{{
function! Count(haystack, needle)
    let counter = 0
    let index = match(a:haystack, a:needle)
    while index > -1
        let counter = counter + 1
        let index = match(a:haystack, a:needle, index+1)
    endwhile
    return counter
endfunction

"function! ArgList(count)
"    " This returns a list of empty tags to be used as 
"    " argument list placeholders for the call to printf
"    let st = g:snip_start_tag
"    let et = g:snip_end_tag
"    if a:count == 0
"        return ""
"    else
"        return repeat(', '.st.et, a:count)
"    endif
"endfunction
"
" }}}
EOF

}


=head1 AUTHOR

Cornelius, C<< <c9s at aiink.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-vim-snippet-compiler at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Vim-Snippet-Converter>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Vim::Snippet::Converter


You can also look for information at:

=over 6

=item * Vim

L<http://www.vim.org/>

=item * Slippery Snippets Vim Plugin

L<http://slipperysnippets.blogspot.com/2006/12/howto-try-out-latest-version-of.html>

L<http://c9s.blogspot.com/2007/06/vim-snippet.html>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Vim-Snippet-Converter>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Vim-Snippet-Converter>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Vim-Snippet-Converter>

=item * Search CPAN

L<http://search.cpan.org/dist/Vim-Snippet-Converter>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2007 Cornelius, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Vim::Snippet::Converter
