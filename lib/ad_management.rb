require 'net/ldap'
require 'rubygems'
require 'ad_management/version'
require 'yaml'

# A collection ActiveDirectory management methods wrapped around Ruby `net-ldap`
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

  # Configures ActiveDirectory connections settings individually.
  #
  # @param settings [Hash] ActiveDirectory conntection settings
  # @return [Hash] a hash of ActiveDirectory connection settings.
  def self.configure(settings = {})
    settings.each do |k, v|
      @ad_settings[k.to_sym] = v if @ad_settings.keys.include? k.to_sym
    end
  end

  # Configure settings from a yaml file
  #
  # @param yaml_file [String] path to YAML
  # @return [Hash] a hash of ActiveDirectory connection settings.
  def self.configure_from(yaml_file)
    config = YAML.load(IO.read(yaml_file))
    configure(config)
  rescue Errno::ENOENT || Psych::SyntaxError
    nil
  end

  # Get ActiveDirectory connection settings
  #
  # @return [Hash] a hash of ActiveDirectory connection settings.
  def self.settings
    @ad_settings
  end

  # Connect to ActiveDirectory using connection settings
  #
  # @return [Object] an ActiveDirectory/LDAP connection object.
  def self.connect
    @ad_connection = Net::LDAP.new(@ad_settings)
    @ad_connection.bind ? @ad_connection : nil
  rescue Net::LDAP::LdapError
    return nil
  end

  # Delete an ActiveDirectory computer object.
  #
  # @param computer_cn [String] CommonName of computer object.
  # @return [String] value, '' or DistinguishedName
  #   of successfully deleted object.
  def self.delete_computer(computer_cn)
    computer_sam = computer_cn + '$'
    computer_dn = dn_from(computer_sam)
    return '' if computer_dn.nil?
    return '' unless @ad_connection.delete(dn: computer_dn)
    computer_dn
  end

  # Create an ActiveDirectory computer object.
  #
  # @param owner_id: [String] SAMAccountName of ActiveDirectory user.
  # @param target_cn: [String] CommonName of computer object.
  # @param target_ou_dn: [String] DistinguishedName of OU to place computer object
  # @return [String] value, '' or DistinguishedName
  #   of successfully created object.
  def self.create_computer(owner_id: nil, target_cn: nil, target_ou_dn: nil)
    computer_dn = "CN=#{target_cn},#{target_ou_dn}"
    owner_id_dn = dn_from(sam_account_name: owner_id)
    account_attrs = {
      cn:               target_cn,
      sAMAccountName:   target_cn + '$',
      managedBy:        owner_id_dn,
      objectClass:      %w[computer organizationalPerson person top user]
    }
    return '' unless @ad_connection.add(dn: computer_dn, attributes: account_attrs)
    dn_from(sam_account_name: target_cn + '$')
  end

  # Move an ActiveDirectory computer object.
  #
  # @param src_computer_cn [String] CommonName of ActiveDirectory computer to
  #   be moved.
  # @param dst_computer_rdn [String] Relative DistinguishedName of destination
  #   renamed computer object.
  # @param dst_ou [String] destination OrganziationalUnit of destination
  #   computer object.
  # @return [String] value, '' or DistinguishedName
  #   of successfully renamed object.
  def self.move_computer(src_computer_cn, dst_computer_cn, dst_ou)
    src_computer_dn = dn_from(src_computer_cn + '$')
    return '' unless @ad_connection.rename(
      olddn: src_computer_dn,
      newrdn: "CN=#{dst_computer_cn}",
      delete_attributes: true,
      new_superior: dst_ou
    )
    dn_from(dst_computer_cn + '$')
  end

  # @note The SAMAccountName of a computer object has a `$` character
  #   appended to the value of its CommonName to distingush its SAMAccountName
  #   from that of a user object.
  #
  # Gets DistinguishedName of an ActiveDirectory object from its SAMAccountName.
  # @param sam_account_name: [String] CommonName of Computer or User object.
  # @return [String] DistinguishedName of object.
  def self.dn_from(sam_account_name: nil)
    filter = Net::LDAP::Filter.eq('sAMAccountName', sam_account_name)
    entry = @ad_connection.search(
      base:    @ad_settings[:base],
      filter:  filter
    ).first
    return '' unless entry
    entry.dn
  end
end
