#!/usr/bin/env ruby

require 'ad_management'

## Replace with specific values
src_computer_cn      = '__SrcComputerCN__'
# dst_computer_cn      = '__DstComputerCN__'
dst_ou_dn            = '__DstOuRdn__'

## Create a new ad_manager instance using service account credentials

AdManagement.configure_from('./config/connection_settings.yml')
AdManagement.connect

## Move computer to new ActiveDirectory Organizational Unit
result = AdManagement.move_computer(
  source_cn: src_computer_cn,
  target_ou_dn: dst_ou_dn
)
puts result
