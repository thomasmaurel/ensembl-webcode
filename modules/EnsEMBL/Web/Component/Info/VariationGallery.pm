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

package EnsEMBL::Web::Component::Info::VariationGallery;

## 

use strict;

use base qw(EnsEMBL::Web::Component::Info);

sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(0);
}

sub content {
  my $self = shift;
  my $hub  = $self->hub;
  my $v = $hub->param('v');

  ## Define set of pages
  my $location_pages = [
                          {
                            'url'     => $hub->url({'type'    => 'Variation',
                                                     'action' => 'Context',
                                                     'v'      => $v,
                                                    }),
                            'img'     => 'variation_genomic',
                            'caption' => 'Genomic context of this variant',
                          },
                          {
                            'url'     => $hub->url({'type'    => 'Variation',
                                                    'action'  => 'Compara_Alignments',
                                                     'v'      => $v,
                                                    }),
                            'img'     => 'variation_phylogenetic',
                            'caption' => 'Phylogenetic context of this variant',
                          },
                          {
                            'url'     => '',
                            'img'     => '',
                            'caption' => '',
                          },
                        ];

  ## Create groups for processing
  my @previews = (
                  {'title' => 'Locations',                      'pages' => $location_pages},
                  {'title' => 'Genes',                          'pages' => []},
                  {'title' => 'Transcripts',                    'pages' => []},
                  {'title' => 'Phenotypes',                     'pages' => []},
                  {'title' => 'Populations &amp; Individuals',  'pages' => []},
                  
                  );

  return $self->format_gallery(@previews);
}

1;
