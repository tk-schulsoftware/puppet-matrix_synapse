require 'spec_helper'

describe 'matrix_synapse', type: :class do
  let(:facts) { { osfamily: 'Debian' } }
  let(:params) do
    {
      'server_name' => 'example.com',
   'database_config' => {
     'name' => 'matrix_synapse',
     'user' => 'matrix_synapse',
     'password' => 'matrix_synapse',
     'host' => 'localhost',
   },
   'appservices' => [
     {
       'id' => 'appservice1',
       'url' => 'http://localhost:9000',
       'token' => 'token1',
       'as_token' => 'astoken1',
       'namespaces' => {
         'users' => [
           {
             'exclusive' => true,
             'regex' => '@appservice1_.*'
           },
         ],
         'aliases' => [],
         'rooms' => [],
       },
       'sender_localpart' => 'appservice1'
     },
   ],
    }
  end

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class('matrix_synapse::install') }
  it { is_expected.to contain_class('matrix_synapse::config') }
  it { is_expected.to contain_class('matrix_synapse::service') }

  it { is_expected.to contain_package('matrix-synapse').with_ensure('latest') }

  it { is_expected.to contain_file('/etc/matrix-synapse/homeserver.yaml').with_ensure('file') }

  it {
    is_expected.to contain_matrix_synapse__appservice('appservice1').with(
    'url' => 'http://localhost:9000',
    'token' => 'token1',
    'as_token' => 'astoken1',
    'namespaces' => {
      'users' => [
        {
          'exclusive' => true,
          'regex' => '@appservice1_.*'
        },
      ],
      'aliases' => [],
      'rooms' => [],
    },
    'sender_localpart' => 'appservice1',
  )
  }

  it {
    is_expected.to contain_service('matrix-synapse').with(
    'ensure' => 'running',
    'enable' => true,
  )
  }
end
