#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
conputer_cn      = '__ComputerCN__'
owner_id         = '__ActiveDirectoryUserAccount__'
computer_ou_dn   = '__ComputerOUDistinguishedName__'


## Create a new ad_manager instance using service account credentials

AdManagement.configure_from('./config/connection_settings.yml')
AdManagement.connect

## Display a computer accounts DistinguishedName
puts AdManagement.dn_from(conputer_cn + '$')