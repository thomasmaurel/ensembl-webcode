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

### Uses premade images ("sprites") to draw a sequence logo
### See EnsEMBL::Web::ImageConfig::sequence_logo

use strict;

#use List::Util qw(sum);
use POSIX qw(ceil);

use base qw(EnsEMBL::Draw::GlyphSet);

sub render {
  my $self = shift;
  my ($matrix, $max_total) = $self->get_data;
  
  my $width = $self->scalex;
  my $max_height = ceil($max_total * $width);
  warn ">>> MAX HEIGHT $max_height";
  my $step = $width;
  my $x = 0;

  my ($font, $fontsize) = $self->get_font_details($self->my_config('font') || 'innertext');
  my $count = 1;
  
  foreach my $column (@$matrix) {
    ## Add up image heights, rounding up
    my $total_height = 0;
    foreach (values %$column) {
      $total_height += ceil($_ * $width);
    }
    #warn ">>> TOTAL HEIGHT = $total_height";
    my $y = $max_height - $total_height; #reset y coord
    #warn "... Y = $y";
    foreach my $base (sort {$column->{$b} <=> $column->{$a}} keys %$column) {
      my $score = $column->{$base};
      my $height = ceil($width * $score);
      $y += $height;
      #warn "@@@ HEIGHT $height, Y $y";
      $self->push($self->Sprite({
        x             => $x,
        y             => $y,
        sprite        => $base,
        width         => $width,
        height        => $height,
        absolutex     => 1,
        absolutewidth => 1,
        absolutey     => 1,
        alt           => $base,
      }));
    }  
=pod
    $self->push($self->Line({
      x             => $x,
      y             => $y + 5,
      width         => $width,
      height        => 0,
      colour        => 'black', 
    }));
    my (undef, undef, $text_width, $text_height) = $self->get_text_width(0, $count, '', font => $font, ptsize => $fontsize);
    $self->push($self->Text({
      x         => $x,
      y         => ($y + 10 + $text_height),
      width     => $step,
      height    => $text_height,
      textwidth => $text_width * $step,
      font      => $font,
      ptsize    => $fontsize,
      halign    => 'center',
      colour    => 'black', 
      text      => $count,
      absolutey => 1,
    }));
=cut
    $x += $step;
  }
  
}

sub get_data {
  my $self = shift;

  my $adaptor = $self->{'container'}->adaptor->db->get_db_adaptor('funcgen')->get_MotifFeatureAdaptor;
  my $motif = $adaptor->fetch_by_interdb_stable_id($self->{'config'}->hub->param('mf'));
  my $length = abs($motif->start - $motif->end + 1);
  my $matrix = [];
  my $max_total = 0;

  ## DUMMY FEATURES FOR TESTING
  my @bases = (qw(a c g t));
  srand;
  for (my $i = 0; $i <= $length; $i++) { 
    my $column = {};
    my $total = 0;
    foreach my $base (@bases) {
      my $score = sprintf('%.1f', rand());
      $column->{$base} = $score;
      $total += $score; 
    }
    push @$matrix, $column;
    $max_total = $total if $total > $max_total;
  }
  return ($matrix, $max_total);
}

1;
