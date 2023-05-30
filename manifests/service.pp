# @summary This class ensures the Matrix Synapse service is running.
#
# @description
#   This class manages the Matrix Synapse service. It ensures the service is running and enabled at boot.
#
# @param ensure
#   Whether the service should be running or stopped. Defaults to 'running'.
#
class matrix_synapse::service (
  Enum['running', 'stopped'] $ensure = 'running',
) {
  service { 'matrix-synapse':
    ensure     => $ensure,
    enable     => true,
    hasrestart => true,
    require    => [Class['matrix_synapse::install'], Class['matrix_synapse::config']],
  }
}
