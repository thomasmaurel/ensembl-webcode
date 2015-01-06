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

package EnsEMBL::Web::Command::Info::CheckGallery;

### Check the parameters being passed to the gallery components
### and do the redirect 

use strict;

use EnsEMBL::Root;

use parent qw(EnsEMBL::Web::Command);

sub process {
  my $self               = shift;
  my $hub                = $self->hub;
  my $species            = $hub->param('species');

  my $data_type = $hub->param('data_type_var') || $hub->param('data_type_novar');
  my $url_params = {
                    'species' => $species,
                    'type'    => 'Info',
                    'action'  => $data_type.'Gallery',
                  };

  ## Check validity of identifier
  my $id = $hub->param('identifier');

  my $error;

  if ($id) {
    my $object = $hub->core_object(lc($data_type));
    my $common_name = $hub->species_defs->get_config($species, 'SPECIES_COMMON_NAME');
    unless ($object) {
      $error = sprintf('%s %s could not be found in species %s. Please try again.', $data_type, $id, $common_name);
    }
  }
 
  if ($error) {
    my $species = $hub->species_defs->get_config($hub->param('species'), 'SPECIES_COMMON_NAME');
    $hub->session->add_data(
                            'type'      => 'message',
                            'code'      => 'gallery',
                            'function'  => '_warning',
                            'message'   => $error,
                            );  
    $self->ajax_redirect('/gallery.html');
  }
  else { 
    ## Use default for this species if user didn't supply one
    unless ($id) {
      $url_params->{'default'} = 'yes';
      my $sample_data = { %{$hub->species_defs->get_config($species, 'SAMPLE_DATA') || {}} };
      $id = $sample_data->{uc($data_type).'_PARAM'};
    }

    if ($data_type eq 'Variation') {
      $url_params->{'v'} = $id;
    }
    elsif ($data_type eq 'Gene') {
      $url_params->{'g'} = $id;
    }
    elsif ($data_type eq 'Location') {
      $url_params->{'r'} = $id;
    }
    $self->ajax_redirect($hub->url($url_params));
  }
}

1;

