# Top level module for AD management classes
module AdManagement
  # Client provides a light wrapper around an LDAP connection
  class Client
    require 'logger'
    require 'net/ldap'

    include AdManagement::Objects

    def initialize(conf)
      conf[:loglevel] ||= 'warn'
      conf[:verbose] = true if conf[:loglevel] == 'debug'

      @logger = conf[:logger] || Logger.new(STDOUT)
      @logger.level = Object.const_get("Logger::#{conf[:loglevel].upcase}")
      @logger.debug("Initializing client with config: #{conf.inspect}")

      @client = Net::LDAP.new(conf)
    end

    def connect!
      @logger.debug("Binding to LDAP #{@client.inspect}")
      return self if @client.bind
      @logger.error "Couldn't bind to AD: #{@client.get_operation_result}"
      raise AdManagement::ConnectionError, "Couldn't bind to AD: #{@client.get_operation_result.message}"
    rescue Net::LDAP::LdapError => e
      raise AdManagement::ConnectionError, "Couldn't connect to AD: #{e.message}"
    end

    def search(sam_account_name = nil, attributes = ['dn'])
      raise AdManagement::ArgumentError, 'sAMAccountName is required' if sam_account_name.nil?
      @logger.debug "Getting attributes #{attributes.inspect} from sAMAccountName: #{sam_account_name}"
      result = @client.search(
        filter: Net::LDAP::Filter.eq('sAMAccountName', sam_account_name),
        attributes: attributes
      )
      result.nil? ? [] : result
    end
  end
end
