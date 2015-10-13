=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

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

package EnsEMBL::Draw::Style::Graph::Barcode;

### Draws a dataset as a one-dimensional "heat map"

use parent qw(EnsEMBL::Draw::Style::Graph);

sub draw_wiggle {
  my ($self, $c, $features) = @_;

  my $height = $c->{'pix_per_score'} * $self->track_config->get('max_score');

  push @{$self->glyphs}, $self->Barcode({
    values    => $features,
    x         => 1,
    y         => 0,
    height    => $height,
    unit      => $self->track_config->get('unit'),
    max       => $self->track_config->get('max_score'),
    colours   => [$c->{'colour'}],
    wiggle    => $self->track_config->get('graph_type'),
  });
}

1;