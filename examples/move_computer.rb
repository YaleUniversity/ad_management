#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
src_computer_cn      = '__ComputerCN__'
dst_computer_rdn     = '__ComputerRDN__'
dst_ou               = '__DestinationOU__'

## Create a new ad_manager instance using service account credentials

AdManagement.configure_from('./config/connection_settings.yml')
AdManagement.connect

## Create a new computer account in ActiveDirectory
result = AdManagement.move_computer(src_computer_cn, dst_computer_rdn, dst_ou)
puts result
