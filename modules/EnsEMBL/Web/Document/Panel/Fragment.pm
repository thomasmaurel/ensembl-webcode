package EnsEMBL::Web::Document::Panel::Fragment;

use strict;
use warnings;

our @ISA = qw(EnsEMBL::Web::Document::Panel);

{

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  $self->{'html'} = undef;
  return $self;
}

sub render {
  my $self = shift;
  my $html = "";
  $html .= $self->html_header;
  $html .= $self->placeholder;
  $html .= $self->html_footer;
  $self->renderer->print( $html );
}

sub html_header {
  my $self = shift;
  my $html = "<div class='panel'>\n";
  $html .= "<h2>";
  $html .= $self->html_collapse_expand_control;
  $html .= "<b id='" . $self->code . "_title'>";
  $html .= $self->caption;
  $html .= $self->html_loading_status;
  $html .= "</b>";
  $html .= "</h2>";
  return $html;
}

sub placeholder {
  my $self = shift;
  my $html = "";
  $html .= "<div style='display: none;' class='fragment' id='" . $self->code . "_update'>" . $self->json . "</div>\n";
  return $html;
}

sub json {
  my $self = shift; 
  my $json = "{ fragment: { code: '" . $self->code . "', species: '" . $ENV{ENSEMBL_SPECIES} . "', title: '" . $self->caption . "', id: '" . $self->code . "', params: [ " . $self->json_params . " ], components: [ " . $self->json_components . " ]";
  $json .= "} }";
  return $json;
}

sub html {
  my ($self, $value) = @_;
  if ($value) {
    $self->{'html'} = $value;
  }
  return $self->{'html'}; 
}

sub print {
  my ($self, $render) = @_;
  $render = $self->escape($render);
  $self->html($render);
}

sub escape_quotes {
  my ($self, $string) = @_;
  $string =~ s/'/&quote;/g;
  return $string;
}

sub json_params {
  my $self = shift;
  my $json = "";
  foreach my $key (%{ $self->params }) {
    if ($self->params->{$key}) {
      $json .= "{ $key: '" . $self->params->{$key} . "' }, ";
    }
  }
  return $json;
}

sub json_components {
  my $self = shift;
  my $json = "";
  foreach my $key (keys %{ $self->{components} }) {
    $json .= "{ $key: '" . $self->{components}{$key}->[0] . "' }, ";
  }
  return $json;
}

sub html_loading_status {
  my $self = shift;
  my $html = "";
  if ($self->status) {
    #$html .= " (" . $self->status . ")";
    $html .= $self->loading_animation; 
  }
  return $html;
}

sub loading_animation {
  my $self = shift;
  my $html = "";
  $html .= " <img src='/img/ajax-loader.gif' width='16' height='16' alt='(" . $self->status . ")'/ >";
  return $html;
}

sub html_collapse_expand_control {
  my $self = shift;
  my $html = "";
  $html .= qq(<a class="print_hide" href="#" title="collapse panel"><img src="/img/dd_menus/min-box.gif" width="16" height="16" alt="-" /></a> );
  return $html;
}

sub html_footer {
  my $self = shift;
  my $html = "</div>\n";
  return $html;
}

}

1;
