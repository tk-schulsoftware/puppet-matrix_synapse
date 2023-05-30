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
# @param server_name
#   The server name of the Matrix Synapse instance.
#
# @param web_client_location
#   The file system location of the web client.
#
# @param version
#   The version of Matrix Synapse to install. Can be 'latest', 'present' or 'absent'.
#   Defaults to 'latest'.
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
class matrix_synapse (
  String $server_name,
  Stdlib::Absolutepath $web_client_location,
  Enum['latest', 'present', 'absent'] $version = 'latest',
  Boolean $enable_registration                 = false,
  Boolean $allow_guest_access                  = false,
  Boolean $report_stats                        = false,
  Hash $database_config                        = {},
  Optional[Hash] $oidc_config                  = undef,
  Array[Hash] $appservices                     = [],
) {
  # Install the necessary packages
  class { 'matrix_synapse::install':
    version => $version,
  }

  # Configure the application
  class { 'matrix_synapse::config':
    server_name         => $server_name,
    web_client_location => $web_client_location,
    enable_registration => $enable_registration,
    allow_guest_access  => $allow_guest_access,
    report_stats        => $report_stats,
    database_config     => $database_config,
    oidc_config         => $oidc_config,
    appservices         => $appservices,
  }

  # Ensure the service is running
  class { 'matrix_synapse::service':
    ensure => 'running',
  }
}
