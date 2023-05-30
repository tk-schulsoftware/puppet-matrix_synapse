# puppet-matrix_synapse

A Puppet module to install and configure [Matrix Synapse](https://matrix.org/docs/spec), an open standard for decentralized communication.

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with matrix_synapse](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module manages the installation and configuration of the Matrix Synapse homeserver. It covers installation, configuration, service management, and optional settings for Postgres database, OpenID Connect (OIDC), application services, and more.

## Setup

### Beginning with matrix_synapse

To install Matrix Synapse with the default parameters:

```puppet
include 'matrix_synapse'
```

To customize the installation:

```puppet
class { 'matrix_synapse':
    server_name => 'example.com',
    version => 'latest',
    # ... other parameters ...
}
```

## Usage

You can customize various parameters of the `matrix_synapse` class in your manifest. Here are some examples:

```puppet
class { 'matrix_synapse':
    server_name => 'example.com',
    version => 'latest',
    enable_registration => true,
    allow_guest_access => true,
    report_stats => false,
    database_config => { 'name' => 'synapse', 'user' => 'synapse', 'pass' => 'secretpass' },
    # ... more options ...
}
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is doing and how.

## Limitations

This module has been tested on Debian 10 and newer using Puppet 7. Other operating systems or versions of Puppet are not guaranteed to work.
