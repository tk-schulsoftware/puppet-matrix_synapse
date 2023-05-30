class matrix_synapse (
  String $server_name,
  String $web_client_location,
  String $version = 'latest',
  Boolean $enable_registration = false,
  Boolean $allow_guest_access = false,
  Boolean $report_stats = false,
  Hash $database_config = {},
  Hash $oidc_config = {},
  Array[Hash] $appservices = [],
) {
  $package_name = 'matrix-synapse'
  $config_path  = '/etc/matrix-synapse/homeserver.yaml'
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
