package File::Media::Sort;
use strict;

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT_OK);

  $VERSION = '0.042';
  @ISA     = qw(Exporter);

  @EXPORT_OK = qw(
    media_sort
  );
}



sub media_sort {
  my $type = shift;

  my @files;
  if(ref($_[0]) eq 'ARRAY') {
    push(@files, @{$_[0]});
  }
  else {
    push(@files, @_);
  }

  return @files if(!defined($type));

  my (@episodes, @mvids, @music);

  my %re = (
    tv    => {
      regex => '(?i)([S0-9]+)?([E0-9]+)(.*TV)',
      location => \@episodes,
    },
    mvids => {
      regex => '.*([_-]+)x264-[0-9]{4}',
      location => \@mvids,
    },
    music => {
      regex => '.+(?:-|_-_)\w+-(?:[0-9]+CD?-)?(?:[0-9]{4}-)?(?:\w+)?',
      location => \@music,
    },
  );

  for my $file(@files) {
    if($re{$type} eq 'music') {
      if($file =~ m/$re{mvids}->{regex}/) {
        push(@mvids, $file);
      }
      else {
        push(@music, $file);
      }
      next;
    }

    if($file =~ m/$re{$type}{regex}/) {
      push(@{$re{$type}{location}}, $file);
    }
  }
  return(@{$re{$type}{location}});
}


1;


__END__


=head1 NAME

File::Media::Sort - sort media based on their release names

=head1 SYNOPSIS

    use File::Media::Sort qw(media_sort);

    my @tv = media_sort('tv', [ glob("$ENV{HOME}/*") ]);

=head1 DESCRIPTION

This module was initially written to be used with L<Parse::Flexget> and
L<File::PatternMatch>.
The flexget application generates a logfile with downloaded files, L<Parse::Flexget>
parses that log while this module 'sorts' it before the results are  being sent
to L<File::PatternMatch> which basically highlights subpatterns in the release
names for terminal/dzen output.

=head1 EXPORTS

None by default.

=head1 FUNCTIONS

=head2 media_sort()

Parameters: $type, @files | $type, \@files

Returns:    @files;

C<media_sort()> takes a list of files and a type. Type can be 'music', 'mvids'
or 'tv'.

=head1 CAVEATS

The regular expressions used here is far from perfect. In fact, they suck really
badly. It's really hard making a regex that matches B<all> music releases, for
example. It's even harder trying to match both music videos and regular movies,
since there's no way what so ever to distinguish them just by looking at the
filename.

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 CONTRIBUTORS

None required yet.

=head1 COPYRIGHT

Copyright 2010, 2011 the File::Media::Sort L</AUTHOR> and L</CONTRIBUTORS> as
listed above.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Parse::Flexget>, L<File::PatternMatch>

=cut
