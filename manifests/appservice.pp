# @summary A defined type to configure an appservice for Matrix Synapse.
#
# @description
#   This defined type creates the configuration file for a Matrix Synapse appservice.
#
# @param service_id
#   The unique ID of the appservice.
#
# @param url
#   The URL of the appservice.
#
# @param token
#   The token to use for the appservice.
#
# @param as_token
#   The application service token to use for the appservice.
#
# @param namespaces
#   The namespaces of the appservice.
#
# @param sender_localpart
#   The sender localpart of the appservice.
#
define matrix_synapse::appservice (
  String $service_id,
  Stdlib::HTTPUrl $url,
  String $token,
  String $as_token,
  Hash $namespaces,
  String $sender_localpart,
) {
  # Create the configuration file for the appservice
  file { "/etc/matrix-synapse/appservice-${service_id}.yaml":
    ensure  => 'file',
    content => epp('matrix_synapse/appservice.yaml.epp', {
        'id'               => $service_id,
        'url'              => $url,
        'token'            => $token,
        'as_token'         => $as_token,
        'namespaces'       => $namespaces,
        'sender_localpart' => $sender_localpart,
    }),
    require => Package['matrix-synapse'],
  }
}
