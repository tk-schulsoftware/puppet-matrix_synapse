# @summary Main class for configuring the Matrix Synapse service.
#
# @description
#   This class installs and configures the Matrix Synapse service.
#   It manages the main configuration file, homeserver.yaml,
#   and can create configuration files for application services.
#
# @param server_name
#   The server name of your homeserver.
#
# @param enable_registration
#   Whether or not to enable registration.
#
# @param allow_guest_access
#   Whether or not to allow guest access.
#
# @param report_stats
#   Whether or not to report anonymous usage statistics.
#
# @param database_type
#   Type of database used by the Matrix Synapse service.
#
# @param database_config
#   Configuration options for the configured database_type database used by the Matrix Synapse service.
#
# @param oidc_config
#   Configuration options for OpenID Connect (OIDC).
#
# @param appservices
#   An array of hashes with the configuration options for the application services.
#
# @param log_config
#   The absolute path to the log configuration file. Default value is loaded from Hiera.
#
# @param media_store_path
#   The absolute path to the media store directory. Default value is loaded from Hiera.
#
# @param public_baseurl
#   The public base URL that clients use for this homeserver. Default value is https://server_name
#
class matrix_synapse::config (
  Stdlib::Fqdn $server_name,
  Boolean $enable_registration,
  Boolean $allow_guest_access,
  Boolean $report_stats,
  String $database_type,
  Hash $database_config,
  Optional[Hash] $oidc_config                 = undef,
  Stdlib::Absolutepath $log_config,
  Stdlib::Absolutepath $media_store_path,
  Stdlib::HTTPUrl $public_baseurl,
  Array[Hash[String[1], Any], 1] $appservices = [],
) inherits matrix_synapse::params {
  # Create the configuration file
  file { '/etc/matrix-synapse/homeserver.yaml':
    ensure  => 'file',
    content => epp('matrix_synapse/homeserver.yaml.epp', {
        'server_name'         => $server_name,
        'enable_registration' => $enable_registration,
        'allow_guest_access'  => $allow_guest_access,
        'report_stats'        => $report_stats,
        'database_type'       => $database_type,
        'database_config'     => $database_config,
        'oidc_config'         => $oidc_config,
        'appservices'         => $appservices,
        'log_config'          => $log_config,
        'media_store_path'    => $media_store_path,
        'public_baseurl'      => $public_baseurl,
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
