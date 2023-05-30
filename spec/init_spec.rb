require 'spec_helper'

describe 'matrix_synapse', type: :class do
  let(:params) do
    {
      server_name: 'matrix.org',
   web_client_location: '/var/www'
    }
  end

  it { is_expected.to compile }

  it { is_expected.to contain_package('matrix-synapse').with_ensure('installed') }

  it {
    is_expected.to contain_file('/etc/matrix-synapse/homeserver.yaml').with({
                                                                              'ensure' => 'file',
      'notify' => 'Service[matrix-synapse]'
                                                                            })
  }

  it {
    is_expected.to contain_service('matrix-synapse').with({
                                                            'ensure' => 'running',
      'enable' => true,
                                                          })
  }
end
