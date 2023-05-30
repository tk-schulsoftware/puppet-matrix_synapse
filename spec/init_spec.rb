require 'spec_helper'

describe 'matrix_synapse' do
  let(:params) do
    {
      server_name: 'example.com',
      web_client_location: '/var/www',
      version: 'latest',
      enable_registration: false,
      allow_guest_access: false,
      report_stats: false,
      database_config: {
        'host'     => 'localhost',
        'user'     => 'synapse_user',
        'password' => 'secret',
        'database' => 'synapse',
      },
      oidc_config: {
        'enabled'                 => 'true',
        'issuer'                  => 'https://accounts.google.com',
        'client_id'               => 'YOUR_CLIENT_ID',
        'client_secret'           => 'YOUR_CLIENT_SECRET',
        'scopes'                  => ['openid', 'profile', 'email'],
        'user_profile_method'     => 'auto',
        'allow_existing_users'    => 'true'
      },
      appservices: [
        {
          'id'              => 'my_appservice',
          'url'             => 'http://localhost:8000',
          'as_token'        => 'as_token_1',
          'hs_token'        => 'hs_token_1',
          'sender_localpart' => 'appservice_bot',
        },
      ],
    }
  end

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class('matrix_synapse') }

  it { is_expected.to contain_apt__source('matrix-synapse') }

  it { is_expected.to contain_package('matrix-synapse').with_ensure('latest') }

  it { is_expected.to contain_file('/etc/matrix-synapse/homeserver.yaml').that_notifies('Service[matrix-synapse]') }

  it {
    is_expected.to contain_service('matrix-synapse').with(
    'ensure' => 'running',
    'enable' => true,
  )
  }

  it { is_expected.to contain_file('/etc/matrix-synapse/appservice-0.yaml') }
end
