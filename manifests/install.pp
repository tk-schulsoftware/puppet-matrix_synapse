#
# @param version [Enum['latest', 'present', 'absent']]
#   The version of Matrix Synapse to install. Can be 'latest', 'present' or 'absent'.
#   Defaults to 'latest'.
#
# @param manage_repo [Boolean]
#   Whether to manage the repo for the service, can be true or false.
#
# @param manage_package [Boolean]
#   Whether to manage the package for the service, can be true or false.
#
class matrix_synapse::install (
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
        'id'     => 'AAF9AE843A7584B5A3E4CD2BCF45A512DE2DA058',
        'source' => 'https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg',
      },
      include  => {
        'src' => false,
      },
    }
  }

  # Install the package
  if $manage_package {
    package { 'matrix-synapse':
      ensure  => $version,
      name    => $matrix_synapse::params::package_name,
      require => Apt::Source['matrix-synapse'],
    }
  }
}
