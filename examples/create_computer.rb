#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
computer_cn      = '__ComputerCN__'
owner_id         = '__ActiveDirectoryUserAccount__'
computer_ou_dn   = '__ComputerOUDistinguishedName__'

## Create a new ad_manager instance using service account credentials

AdManagement.configure_from('./config/connection_settings.yml')
AdManagement.connect

## Create a new computer account in ActiveDirectory
AdManagement.create_computer(owner_id, computer_cn, computer_ou_dn)
