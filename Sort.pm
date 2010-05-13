package Media::Sort
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(getmedia);

# getmedia('tv', @list);
sub getmedia {
  my $type  = shift;
  my @files = @_;

  my (@episodes, @mvids, @music);

  my %re = (
    tv    => {
      regex => '(S[0-9]+)?(E[0-9]+)?(.*TV)|VHS|SWEDISH',
      location => \@episodes,
    },
    mvids => {
      regex => '.+(_|-|-_-|_-_)+x264-[0-9]{4}',
      location => \@mvids,
    },
    music => {
      #regex => '(^\w*[^_-])(-|_-_)(\w*[^_-])+-(\(.+\))?',
      #regex => '(^\w*[^_-])(-|_-_)(\w*[^_-])+-(\(.+\))?[^(\w+)',
      regex  => '.+(:?-|_-_|--|-_-|_)+\w+-?(?:[0-9]{4}?)?(:?[0-9]CD.?)?(:?-\w+)?(:?\(.*\))?-+(:?\(?DAB\)?|\(?WEB\)?|\(?CDA\)?|\(?CDS\)?|\(?CDM\)?|\(?Vinyl\)?|\(?SWE\)?|\(?FI\)?|\(?DE\?|\(?WEB\)?|\(?LINE\)?|\(Promo\)|\(?DVB.?\)?|\(.?LIVE\)?)|\(?Promo_?CD.?\)?',
      location => \@music,
    },
  );


  foreach my $file(@files) {
    if($file =~ m/$re{$type}{regex}/) {
      push(@{$re{$type}{location}}, $file);
    }
  }
  #return undef;
  return @{$re{$type}{location}};
}
