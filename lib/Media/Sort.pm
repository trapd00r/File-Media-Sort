package Media::Sort;
require Exporter;
@ISA = qw(Exporter);
#@EXPORT_OK = qw(media_sort);
our @EXPORT = qw(media_sort);

use strict;

sub media_sort {
  my $type  = shift;
  return(undef) if(!$type);
  my @files = @_;

  my (@episodes, @mvids, @music);

  my %re = (
    tv    => {
      regex => '(?i)(S[0-9]+)?(E[0-9]+)?(.*TV)|VHS|SWEDISH',
      location => \@episodes,
    },
    mvids => {
      regex => '.+(_|-|-_-|_-_)+x264-[0-9]{4}',
      location => \@mvids,
    },
    music => {
      regex => '.+(?:-|_-_)\w+-(?:[0-9]+CD?-)?(?:[0-9]{4}-)?(?:\w+)?',
      location => \@music,
    },
  );

  for my $file(@files) {
    if($re{$type} eq 'music') {
      if($file =~ m/$re{mvids}{regex}/) {
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

=pod

=head1 NAME

  Media::Sort - Sort media files based on their release name

=head1 SYNOPSIS

  use Media::Sort;

  my @files = glob("./*");
  my @tv    = media_sort(@files);

=head1 DESCRIPTION

  Media::Sort exports one function by default - media_sort().
  She takes two arguments - type of media to retrieve, and a list of unsorted
  media.

  She will return a list of the sorted media for you.

=head2 EXPORTS

  media_sort()

=head1 AUTHOR

Written by Magnus Woldrich

=head1 REPORTING BUGS

Report bugs to trapd00r\@trapd00r.se

=head1 COPYRIGHT

Copyright 2010 Magnus Woldrich

License GPLv2

=head1 SEE ALSO

Flexget::Parse

Flexget::PatternMatch

=cut
