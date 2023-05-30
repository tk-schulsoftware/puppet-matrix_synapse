class matrix_synapse::install (
  String $server_name,
  Enum['latest', 'present', 'absent'] $version,
  Boolean $manage_repo,
  Boolean $manage_package,
) {
  # Configure the Apt repository
  if $manage_repo {
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
  }

  # Install the package
  if $manage_package {
    package { $matrix_synapse::params::package_name:
      ensure  => $package_ensure,
      require => Apt::Source['matrix-synapse'],
    }
  }
}
