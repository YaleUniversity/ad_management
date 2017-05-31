#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
conputer_cn = 'aa-vbrb1515'
owner_id         = '__ActiveDirectoryUserAccount__'
computer_ou_dn   = '__ComputerOUDistinguishedName__'


## Create a new ad_manager instance using service account credentials

AdManagement.configure_from('config/connection_settings.yml')
AdManagement.connect

## Display a computer accounts DistinguishedName
 puts AdManagement.dn_from(conputer_cn + '$')


## Delete a computer account in ActiveDirectory
# AdManagement.delete_computer(conputer_cn)

## Create a new computer account in ActiveDirectory
# AdManagement.create_computer(owner_id, conputer_cn, computer_ou_dn)
