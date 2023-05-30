# @summary A class for managing Matrix Synapse server.
#
# @description
#   This class installs and configures Matrix Synapse server, a free and open-source distributed communication server.
#
# @example
#   class { 'matrix_synapse':
#     server_name => 'example.com',
#     version => 'latest',
#   }
#
# @param server_name [String]
#   The server name of the Matrix Synapse instance.
#
# @param version [Enum['latest', 'present', 'absent']]
#   The version of Matrix Synapse to install. Can be 'latest', 'present' or 'absent'.
#   Defaults to 'latest'.
#
# @param enable_registration [Boolean]
#   Whether to enable user registration. Defaults to false.
#
# @param allow_guest_access [Boolean]
#   Whether to allow guest access. Defaults to false.
#
# @param report_stats [Boolean]
#   Whether or not to report anonymous usage statistics.
#
# @param database_type
#   Type of database used by the Matrix Synapse service.
#
# @param database_config [Hash]
#   Configuration options for the configured database_type used by the Matrix Synapse service.
#
# @param oidc_config [Optional[Hash]]
#   Configuration options for OpenID Connect (OIDC).
#
# @param appservices [Array[Hash]]
#   An array of hashes with the configuration options for the application services.
#
# @param log_config [Optional[Stdlib::Absolutepath]]
#   The absolute path to the log configuration file. Default value is loaded from Hiera.
#
# @param media_store_path [Optional[Stdlib::Absolutepath]]
#   The absolute path to the media store directory. Default value is loaded from Hiera.
#
# @param public_baseurl [Stdlib::Fqdn]
#   The public base URL that clients use for this homeserver. Default value is https://server_name
#
# @param matrix_synapse_user [String]
#   Default user for Matrix Synapse service.
#
# @param matrix_synapse_group [String]
#   Default group for Matrix Synapse service.
#
# @param manage_repo [Boolean]
#   Whether to manage the repo for the service, can be true or false.
#
# @param manage_package [Boolean]
#   Whether to manage the package for the service, can be true or false.
#
# @param manage_service [Boolean]
#   Whether to manage the service for the service, can be true or false.
#
# @param service_ensure [String]
#   Default service state, can be 'running' or 'stopped'.
#
# @param service_enable [Boolean]
#   Whether to enable the service at boot, can be true or false.
#
# @param manage_firewall [Boolean]
#   Whether to manage the firewall for the service, can be true or false.
#
# init.pp
class matrix_synapse (
  String $server_name,
  Enum['latest', 'present', 'absent'] $version                               = $matrix_synapse::params::version,
  Boolean $enable_registration                                               = $matrix_synapse::params::enable_registration,
  Boolean $allow_guest_access                                                = $matrix_synapse::params::allow_guest_access,
  Boolean $report_stats                                                      = $matrix_synapse::params::report_stats,
  String $database_type = $matrix_synapse::params::database_type,
  Hash[Enum['database', 'user', 'password', 'host', 'port'], String[1]] $database_config = $matrix_synapse::params::database_config,
  Optional[Hash] $oidc_config                                                = undef,
  Array[Hash] $appservices                                                   = [],
  Optional[Stdlib::Absolutepath] $log_config                                 = $matrix_synapse::params::log_config,
  Optional[Stdlib::Absolutepath] $media_store_path                           = $matrix_synapse::params::media_store_path,
  Stdlib::HTTPUrl $public_baseurl                                               = "https://${server_name}",
  String $matrix_synapse_user                                                = $matrix_synapse::params::matrix_synapse_user,
  String $matrix_synapse_group                                               = $matrix_synapse::params::matrix_synapse_group,
  Boolean $manage_repo                                                       = $matrix_synapse::params::manage_repo,
  Boolean $manage_package                                                    = $matrix_synapse::params::manage_package,
  Boolean $manage_service                                                    = $matrix_synapse::params::manage_service,
  String $service_ensure                                                     = $matrix_synapse::params::service_ensure,
  Boolean $service_enable                                                    = $matrix_synapse::params::service_enable,
  Boolean $manage_firewall                                                   = $matrix_synapse::params::manage_firewall,
) inherits matrix_synapse::params {
  class { 'matrix_synapse::install':
    version        => $version,
    manage_repo    => $manage_repo,
    manage_package => $manage_package,
  }

  class { 'matrix_synapse::config':
    server_name         => $server_name,
    enable_registration => $enable_registration,
    allow_guest_access  => $allow_guest_access,
    report_stats        => $report_stats,
    database_type       => $database_type,
    database_config     => $database_config,
    oidc_config         => $oidc_config,
    appservices         => $appservices,
    log_config          => $log_config,
    media_store_path    => $media_store_path,
    public_baseurl      => $public_baseurl,
  }

  # Ensure the service is running
  class { 'matrix_synapse::service':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
