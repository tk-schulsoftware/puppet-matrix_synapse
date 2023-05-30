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
  $package_name = 'matrix-synapse'
  $config_path = '/etc/matrix-synapse/homeserver.yaml'
  $service_name = 'matrix-synapse'

  # Ensure the APT package repository is added
  include apt

  apt::source { 'matrix-synapse':
    location => 'https://packages.matrix.org/debian/',
    repos    => 'main',
    key      => {
      'id'     => 'AD0592FE47F0DF61',
      'source' => 'https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg',
    },
    include  => {
      'src' => false,
    },
  }

  # Install the package
  package { $package_name:
    ensure  => $version,
    require => Apt::Source['matrix-synapse'],
  }

  # Manage the configuration file
  file { $config_path:
    ensure  => file,
    content => template('matrix_synapse/homeserver.yaml.erb'),
    notify  => Service[$service_name],
    require => Package[$package_name],
  }

  # Ensure the service is running
  service { $service_name:
    ensure  => running,
    enable  => true,
    require => File[$config_path],
  }

  # Manage appservice configuration files
  $appservices.each |$appservice, $index| {
    file { "/etc/matrix-synapse/appservice-${index}.yaml":
      ensure  => file,
      content => template('matrix_synapse/appservice.yaml.erb'),
      require => Package[$package_name],
    }
  }
}
