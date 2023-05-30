# Class: matrix_synapse::params
#
# This class is meant to be called from matrix_synapse. It manages the parameters
# used in the module in a centralized place.

class matrix_synapse::params {
  # Define your parameters with default values here
  # These default values can be overridden when declaring the main class or config class

  # Parameters from main class
  $matrix_synapse_user     = 'matrix-synapse'
  $matrix_synapse_group    = 'matrix-synapse'
  $manage_package          = 'installed'
  $service_ensure          = 'running'
  $service_enable          = true
  $manage_firewall         = true

  # Parameters from config class
  $database_type = 'sqlite'
  $database_name = 'homeserver'
  $enable_registration = false
  $enable_oidc = false

  # Debian-specific parameters
  if $facts['os']['family'] == 'Debian' {
    $package_name       = 'matrix-synapse'
    $service_name       = 'matrix-synapse'

    $log_config = '/var/log/matrix-synapse/homeserver.log'
    $media_store_path = '/var/lib/matrix-synapse/media'
  } else {
    fail("The ${module_name} module is not supported on ${facts['os']['family']}")
  }
}
