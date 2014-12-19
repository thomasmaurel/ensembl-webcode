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

  ## Define page layout 
  ## Note: We structure it like this, because for improved findability, pages can appear 
  ## under more than one heading. Configurations for individual views are defined in a
  ## separate method, lower down this module
  my $layout = [
                  {
                    'title' => 'Locations',                      
                    'pages' => ['Region in Detail', 'Genomic Context', 'Flanking Sequence', 'Phylogenetic Context'],
                  },
                  {
                    'title' => 'Genes',
                    'pages' => ['Gene Sequence', 'Gene Table', 'Gene Image', 'Gene Regulation', 'Citations'],
                  },
                  {
                    'title' => 'Transcripts',
                    'pages' => ['Transcript Image', 'Transcript Table', 'Transcript Comparison', 'Exons', 'Gene Regulation', 'Citations'],
                  },
                  {
                    'title' => 'Proteins',
                    'pages' => ['Protein Summary', 'cDNA Sequence', 'Protein Sequence', 'Variation Protein', 'Citations'],
                  },
                  {
                    'title' => 'Phenotypes',
                    'pages' => ['Phenotype Table', 'Gene Phenotype', 'Phenotype Karyotype', 'Phenotype Location Table', 'Citations'],
                  },
                  {
                    'title' => 'Populations &amp; Individuals',
                    'pages' => ['Population Image', 'Population Table', 'Genotypes Table', 'Linkage Image', 'LD Table', 'Resequencing', 'Citations'],
                  },
                ];

  return $self->format_gallery('Variation', $layout, $self->_get_pages);
}

sub _get_pages {
  ## Define these in a separate method to make content method cleaner
  my $self = shift;
  my $hub = $self->hub;
  my $v = $hub->param('v');

  return {'Region in Detail' => {
                                  'url'     => $hub->url({'type'    => 'Location',
                                                              'action'  => 'View',
                                                              'v'      => $v,
                                                              }),
                                  'img'     => '',
                                  'caption' => 'Region where this variant is located',
                                },
          'Genomic Context' => {
                                  'url'     => $hub->url({'type'    => 'Variation',
                                                          'action' => 'Context',
                                                          'v'      => $v,
                                                        }),
                                  'img'     => 'variation_genomic',
                                  'caption' => 'Genomic context of this variant',
                                },
          'Flanking Sequence' => {
                                  'url'     => $hub->url({'type'    => 'Variation',
                                                          'action'  => 'Sequence',
                                                          'v'      => $v,
                                                          }),
                                  'img'     => 'variation_sequence',
                                  'caption' => 'Flanking sequence for this variant',
                                  },
          'Phylogenetic Context' => {
                                  'url'     => $hub->url({'type'    => 'Variation',
                                                          'action'  => 'Compara_Alignments',
                                                          'v'      => $v,
                                                          }),
                                  'img'     => 'variation_phylogenetic',
                                  'caption' => 'Phylogenetic context of this variant',
                                  },
          'Gene Sequence' => {
                                  'url'     => $hub->url({'type'    => 'Gene',
                                                          'action'  => 'Sequence',
                                                          'v'      => $v,
                                                          }),
                                  'img'     => '',
                                  'caption' => 'Sequence of the gene overlapping this variant',
                            },
          'Gene Image' => {
                                  'url'     => $hub->url({'type'    => 'Gene',
                                                          'action'  => 'Variation_Gene/Image',
                                                          'v'      => $v,
                                                          }),
                                  'img'     => '',
                                  'caption' => 'Image showing all variants within the same gene as this one',
                          },
          'Gene Table' => {
                                  'url'     => $hub->url({'type'    => 'Gene',
                                                          'action'  => 'Variation_Gene/Table',
                                                          'v'      => $v,
                                                        }),
                                  'img'     => '',
                                  'caption' => 'Table of variants within the same gene as this one',
                          },
    };
}

1;
