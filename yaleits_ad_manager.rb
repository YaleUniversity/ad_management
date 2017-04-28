require 'rubygems'
require 'bundler/setup'
require 'net/ldap'

# YaleitsAdManager: manages Yale University ActiveDirectory objects
class YaleitsAdManager
  SERVER = 'ad.its.yale.edu'.freeze
  PORT = 636
  BASE_DN = 'dc=yu,dc=yale,dc=edu'.freeze
  DOMAIN = 'yu.yale.edu'.freeze

  def connect(account, password)
    return nil if account.empty? || password.empty?

    connection =
      Net::LDAP.new(
        host:         SERVER,
        port:         PORT,
        encryption:   { method:       :simple_tls,
                        tls_options:
                          OpenSSL::SSL::SSLContext::DEFAULT_PARAMS },
        auth:         { method:       :simple,
                        username:     account,
                        password:     password }
      )
    connection.bind && connection || nil
  rescue Net::LDAP::LdapError => e
    return nil
  end

  def delete_computer(ad_account)
    account_dn = dn(ad_account)
    @ad_connection.delete(dn: account_dn) unless account_dn.nil?
  end

  def create_computer(owner_id, ad_account, ad_ou)
    account_dn = "CN=#{ad_account},#{ad_ou}"
    owner_id_dn = dn(owner_id)
    account_attrs = {
      cn:               ad_account,
      sAMAccountName:   ad_account + '$',
      objectClass:      %w[computer organizationalPerson person top user],
      managedBy:        owner_id_dn
    }
    results = {}
    @ad_connection.add(
      dn:          account_dn,
      attributes:  account_attrs
    )
    results[0] = @ad_connection.get_operation_result
    puts results[0]
  end

  def dn(ad_account)
    l_filter = Net::LDAP::Filter.eq('sAMAccountName', ad_account)
    r_filter = Net::LDAP::Filter.eq('sAMAccountName', ad_account + '$')
    filter = Net::LDAP::Filter.intersect(l_filter, r_filter)
    entry = @ad_connection.search(
      base:    BASE_DN,
      filter:  filter
    ).first
    entry && entry.dn || nil
  end

  def initialize(account, password)
    @ad_connection = connect(account, password)
  end
end
