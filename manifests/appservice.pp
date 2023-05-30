# appservice.pp
# @summary A defined type for managing Matrix Synapse application services.
#
# @description
#   This defined type creates an application service configuration file.
#
# @param service_id
#   The ID of the application service.
#
# @param url
#   The URL of the application service.
#
# @param as_token
#   The application service token.
#
# @param hs_token
#   The homeserver token.
#
# @param sender_localpart
#   The local part of the sender's Matrix ID.
#
# @param namespaces
#   The namespaces configuration as a hash. The hash should have 'users' and 'aliases' as keys.
#   Each key should have an array of hashes as its value. The inner hashes should have 'exclusive'
#   (a boolean) and 'regex' (a non-empty string) as keys.
#
define matrix_synapse::appservice (
  String[1] $service_id,
  Stdlib::Fqdn $url,
  String[1] $as_token,
  String[1] $hs_token,
  String[1] $sender_localpart,
  Hash[Enum['users', 'aliases'], Array[Hash[Enum['exclusive', 'regex'], Variant[Boolean, String[1]]], 1]] $namespaces,
) {
  # Create the configuration file for the appservice
  file { "/etc/matrix-synapse/appservice-${service_id}.yaml":
    ensure  => 'file',
    content => epp('matrix_synapse/appservice.yaml.epp', {
        'id'               => $service_id,
        'url'              => $url,
        'token'            => $hs_token,
        'as_token'         => $as_token,
        'namespaces'       => $namespaces,
        'sender_localpart' => $sender_localpart,
    }),
    require => Package['matrix-synapse'],
  }
}
