require 'net/ldap'
require 'rubygems'
require 'ad_management/version'
require 'yaml'

module  AdManagement
  # Establish default keys and values for Ad connection
  @ad_settings = {
    host: '',
    base: '',
    auth:       { username: '', password: '', method: :simple },
    port: 636,
    encryption: { method:     :simple_tls,
                  tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS }
  }

  @ad_connection = nil

  # Configure settings individually
  # Configure individual settings by referring to the keys in the
  # @ad_settings variable
  def self.configure(settings = {})
    settings.each do |k, v|
      @ad_settings[k.to_sym] = v if @ad_settings.keys.include? k.to_sym
    end
  end

  # Configure settings from a yaml file
  def self.configure_from(yaml_file)
    config = YAML.load(IO.read(yaml_file))
    configure(config)
  rescue Errno::ENOENT || Psych::SyntaxError
    nil
  end

  # Get settings
  def self.settings
    @ad_settings
  end

  # Connect to ActiveDirectory
  def self.connect
    @ad_connection = Net::LDAP.new(@ad_settings)
    @ad_connection.bind ? @ad_connection : nil
  rescue Net::LDAP::LdapError
    return nil
  end

  # Delete a computer
  def self.delete_computer(computer_cn)
    computer_sam = computer_cn + '$'
    computer_dn = dn_from(computer_sam)
    return '' if computer_dn.nil?
    @ad_connection.delete(dn: computer_dn)
    return computer_dn if dn_from(computer_sam).nil?
  end

  def self.create_computer(owner_id, computer_cn, ad_ou)
    computer_dn = "CN=#{computer_cn},#{ad_ou}"
    owner_id_dn = dn_from(owner_id)
    account_attrs = {
      cn:               computer_cn,
      sAMAccountName:   computer_cn + '$',
      managedBy:        owner_id_dn,
      objectClass:      %w[computer organizationalPerson person top user]
    }
    @ad_connection.add(dn: computer_dn, attributes: account_attrs)
  end

  # Gets object distinguished name from SAM account name
  # NB, the SAM account name of computer objects have a $ sign 
  # appended to their CN to distingush their SAM account names from those of
  # User objects.
  def self.dn_from(sam_account_name)
    filter = Net::LDAP::Filter.eq('sAMAccountName', sam_account_name)
    entry = @ad_connection.search(
      base:    @ad_settings[:base],
      filter:  filter
    ).first
    entry && entry.dn || nil
  end
end
