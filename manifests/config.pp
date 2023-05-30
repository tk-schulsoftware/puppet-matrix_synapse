# @summary This class handles the configuration of Matrix Synapse.
#
# @description
#   This class creates the homeserver.yaml configuration file and any appservice files.
#
# @param server_name
#   The server name of the Matrix Synapse instance.
#
# @param web_client_location
#   The file system location of the web client.
#
# @param enable_registration
#   Whether to enable user registration. Defaults to false.
#
# @param allow_guest_access
#   Whether to allow guest access. Defaults to false.
#
# @param report_stats
#   Whether to report usage statistics. Defaults to false.
#
# @param database_config
#   The database configuration as a hash. Defaults to an empty hash.
#
# @param oidc_config
#   The OIDC configuration as a hash. Optional.
#
# @param appservices
#   An array of hashes representing the application services to configure. Defaults to an empty array.
#
class matrix_synapse::config (
  String $server_name,
  Stdlib::Absolutepath $web_client_location,
  Boolean $enable_registration = false,
  Boolean $allow_guest_access = false,
  Boolean $report_stats = false,
  Hash $database_config = {},
  Optional[Hash] $oidc_config = undef,
  Array[Hash] $appservices = [],
) {
  # Create the configuration file
  file { '/etc/matrix-synapse/homeserver.yaml':
    ensure  => 'file',
    content => epp('matrix_synapse/homeserver.yaml.epp', {
        'server_name'         => $server_name,
        'web_client_location' => $web_client_location,
        'enable_registration' => $enable_registration,
        'allow_guest_access'  => $allow_guest_access,
        'report_stats'        => $report_stats,
        'database_config'     => $database_config,
        'oidc_config'         => $oidc_config,
        'appservices'         => $appservices,
    }),
    require => Package['matrix-synapse'],
  }

  # Create the configuration files for each appservice
  $appservices.each |$appservice| {
    matrix_synapse::appservice { $appservice['id']:
      * => $appservice,
    }
  }
}
