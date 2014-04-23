=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Draw::GlyphSet::seq_logo;

### Uses premade images ("s") to draw a sequence logo
### See EnsEMBL::Web::ImageConfig::sequence_logo

use strict;

use base qw(EnsEMBL::Draw::GlyphSet);

sub render {
  my $self = shift;
  my $sprites = $self->matrix;
  
  my $width = 50;
  my $pad = 0;
  my $step = $width + $pad;
  my $pos = 0;
  
  foreach my (@$sprites) {
    my ($base, $score) = @$_;
    my $height = $width * $score;
    $self->push($self->Sprite({
      z             => 1000,
      x             => $pos,
      y             => $width,
      sprite        => $base,
      width         => $width,
      height        => $height,
      absolutex     => 1,
      absolutewidth => 1,
      absolutey     => 1,
      alt           => $base,
    }));
      
    $pos += $step;
  }
  
}

sub matrix {
  my $self = shift;

  my $adaptor = $self->{'container'}->adaptor->db->get_db_adaptor('funcgen')->get_MotifFeatureAdaptor;
  my $motif = $adaptor->fetch_by_interdb_stable_id($self->{'config'}->hub->param('mf'));
  my $slice = $motif->feature_slice;
  my $matrix = [];

  ## DUMMY FEATURES FOR TESTING
  my @bases = (qw(a c g t));
  my @scores = (qw(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9));
  srand;
  for ($i = 0; $i <  $slice->length; $i++) { 
    my $base = rand(@bases);
    my $score = rand(@scores);
    push @$matrix, [$base, $score];
  }
}

1;
