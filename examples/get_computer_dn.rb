#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
conf = {
  host: 'ldap.example.com',
  port: 636,
  base: 'dc=example,dc=com',
  auth: {
    method: :simple,
    username: 'CN=username,OU=Users,DC=example,DC=com',
    password: 'suparsehkret'
  },
  encryption: {
    method: :simple_tls,
    tls_options: {
      verify_mode: 1,
      ssl_version: 'TLSv1_2'
    }
  }
}
computer_cn = '__ComputerCN__'

## Create a new ad_manager instance using service account credentials
c = AdManagement::Client.new(conf).connect!

## Display a computer accounts DistinguishedName
puts c.get(computer_cn)
