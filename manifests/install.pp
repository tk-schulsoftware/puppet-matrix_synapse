# @summary This class handles the installation of Matrix Synapse.
#
# @description
#   This class configures the APT repository for Matrix Synapse and installs the package.
#
# @param version
#   The version of Matrix Synapse to install. Can be 'latest', 'present' or 'absent'.
#   Defaults to 'latest'.
#
class matrix_synapse::install (
  Enum['latest', 'present', 'absent'] $version = 'latest',
) {
  # Configure the Apt repository
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
  package { 'matrix-synapse':
    ensure  => $version,
    require => Apt::Source['matrix-synapse'],
  }
}
