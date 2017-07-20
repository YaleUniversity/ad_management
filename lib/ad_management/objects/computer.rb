module AdManagement
  module Objects
    ##
    # Helper methods for manipulating computer objects in AD
    # rubocop:disable Metrics/ModuleLength
    module Computer
      ##
      # Adds a new attribute to a computer object
      def attribute_add(cn, attribute, value)
        if cn.nil? || attribute.nil? || value.nil?
          raise AdManagement::ArgumentError, 'Required attribute_add parameter(s) not provided!'
        end
        dn = search(cn + '$').first&.dn
        raise AdManagement::NotFoundError, "CN (#{cn}) was not found" if dn.nil?

        @logger.info("Adding attribute #{attribute}=#{value} to #{dn}")
        result = @client.add_attribute(dn, attribute, value)
        return dn if result

        msg = "Failed to add attribute to #{cn}: " \
          "(#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end

      ##
      # Deletes an attribute from a computer object
      def attribute_delete(cn, attribute)
        if cn.nil? || attribute.nil?
          raise AdManagement::ArgumentError, 'Required attribute_delete parameter(s) not provided!'
        end
        dn = search(cn + '$').first&.dn
        raise AdManagement::NotFoundError, "CN (#{cn}) was not found" if dn.nil?

        @logger.info("Deleting attribute #{attribute} from #{dn}")
        result = @client.delete_attribute(dn, attribute)
        return dn if result

        msg = "Failed to delete attribute from #{cn}: " \
          "(#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end

      ##
      # Checks if the specified attribute exists in a computer object
      def attribute_exists?(cn, attribute)
        if cn.nil? || attribute.nil?
          raise AdManagement::ArgumentError, 'Required attribute_exists? parameter(s) not provided!'
        end
        get(cn).key? attribute.downcase.to_sym
      end

      ##
      # Replaces (or adds if it doesn't exist) an attribute in a computer object
      def attribute_replace(cn, attribute, value)
        if cn.nil? || attribute.nil? || value.nil?
          raise AdManagement::ArgumentError, 'Required attribute_replace parameter(s) not provided!'
        end
        dn = search(cn + '$').first&.dn
        raise AdManagement::NotFoundError, "CN (#{cn}) was not found" if dn.nil?

        @logger.info("Replacing attribute #{attribute}=#{value} in #{dn}")
        result = @client.replace_attribute(dn, attribute, value)
        return dn if result

        msg = "Failed to replace attribute in #{cn}: " \
          "(#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end

      ##
      # Gets all attributes for a computer object
      def get(cn)
        raise AdManagement::ArgumentError, 'Required parameter cn not provided!' if cn.nil?
        @logger.info("Getting attributes for #{cn}")
        to_hash(search(cn + '$', nil).first)
      end

      ##
      # Checks if a server exists by CN, searching is done by the objects sAMAccountName$
      def exists?(cn)
        raise AdManagement::ArgumentError, 'Required parameter cn not provided!' if cn.nil?
        @logger.info("Getting DN of #{cn}")
        !search(cn + '$').first&.dn.nil?
      end

      ##
      # Implements basic AD computer object creation
      # rubocop:disable Metrics/CyclomaticComplexity
      def create(cn, ou, managed_by)
        @logger.info("Creating CN=#{cn},#{ou} managed by #{managed_by}")
        if cn.nil? || ou.nil? || managed_by.nil?
          raise AdManagement::ArgumentError, 'Required create_computer parameter(s) not provided!'
        end

        managed_by_dn = search(managed_by).first&.dn
        raise AdManagement::NotFoundError, "managedBy CN (#{managed_by}) was not found" if managed_by_dn.nil?
        @logger.debug("Found managed_by dn: #{managed_by_dn}")
        raise AdManagement::OperationError, "Computer account (#{cn}) exists" if exists?(cn)

        result = @client.add(
          dn: "CN=#{cn},#{ou}",
          attributes: {
            objectClass: %w[computer organizationalPerson person top user],
            cn: cn,
            sAMAccountName: cn + '$',
            managedBy: managed_by_dn,
            userAccountControl: '4096'
          }
        )
        return "CN=#{cn},#{ou}" if result

        msg = "Failed to create #{cn}: (#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      ##
      # Deletes an AD computer object by CN, searching is done by the objects sAMAccountName$
      def delete(cn)
        raise AdManagement::ArgumentError, 'Required parameter cn not provided!' if cn.nil?

        dn = search(cn + '$').first&.dn
        raise AdManagement::NotFoundError, "CN (#{cn}) was not found" if dn.nil?

        @logger.info("Deleting #{dn}")
        result = @client.delete(dn: dn)
        return dn if result

        msg = "Failed to delete #{cn}: (#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end

      ##
      # Moves an AD computer object by CN and target OU, searching is done by sAMAccountName$
      def move(cn, target_ou)
        raise AdManagement::ArgumentError, 'Required parameter not provided!' if cn.nil? || target_ou.nil?

        dn = search(cn + '$').first&.dn
        raise AdManagement::NotFoundError, "CN (#{cn}) was not found" if dn.nil?

        @logger.info("Moving #{cn} to #{target_ou}")
        result = @client.rename(
          olddn: dn,
          newrdn: "CN=#{cn}",
          delete_attributes: true,
          new_superior: target_ou
        )
        return "CN=#{cn},#{target_ou}" if result

        msg = "Failed to move #{cn}: (#{@client.get_operation_result.code}) #{@client.get_operation_result.message}"
        @logger.error msg
        raise AdManagement::OperationError, msg
      end

      private

      def to_hash(entry)
        return {} if entry.nil?
        hash = {}
        entry.each { |k, v| hash[k] = v }
        hash
      end
    end
  end
end
