module AdManagementCli
  ##
  # Collection of commands for managing computer objects in Active Directory
  module ComputerCommands
    def define_root(cmd)
      cmd.define_command do
        name        'computer'
        usage       'computer [options]'
        summary     'manage a computer object'
        description 'Create/find/delete computer objects in active directory'
      end
    end

    def define_sub(cmd)
      cmd.define_command do
        name 'attribute_add'
        usage   'attribute_add cn attribute value'
        summary 'adds an attribute to a computer object'
        description 'Adds an attribute with the provided value to an existing computer object'

        run do |opts, args|
          exit_2 'attribute_add requires the CN, attribute and value be specified' unless args.size == 3
          configure(opts)
          ap(ad { |c| c.attribute_add(args[0], args[1], args[2]) })
        end
      end

      cmd.define_command do
        name 'attribute_delete'
        usage   'attribute_delete cn attribute'
        summary 'deletes an attribute from a computer object'
        description 'Deletes an attribute from a computer object'

        run do |opts, args|
          exit_2 'attribute_delete requires the CN and attribute be specified' unless args.size == 2
          configure(opts)
          ap(ad { |c| c.attribute_delete(args[0], args[1]) })
        end
      end

      cmd.define_command do
        name 'attribute_replace'
        usage   'attribute_replace cn attribute value'
        summary 'replace an attribute in a computer object'
        description 'Replaces an attribute with the provided value in a computer object. If the attribute doesn\'t exists it will be created'

        run do |opts, args|
          exit_2 'attribute_replace requires the CN, attribute and value be specified' unless args.size == 3
          configure(opts)
          ap(ad { |c| c.attribute_replace(args[0], args[1], args[2]) })
        end
      end

      cmd.define_command do
        name    'create'
        usage   'create cn ou managed_by'
        summary 'add a computer object'
        desc = 'Creates a computer object in active directory. Requires the CN of the '
        desc += 'new object, the destination OU for the object and the managedBy sAMAccountName'
        description desc

        run do |opts, args|
          exit_2 'Create requires the CN, OU and ManagedBy be specified' unless args.size == 3
          configure(opts)
          ap(ad { |c| c.create(args[0], args[1], args[2]) })
        end
      end

      cmd.define_command do
        name 'delete'
        usage   'delete [options] fqdn'
        summary 'delete an alias dns record'

        run do |opts, args|
          exit_2 'Delete requires the CN be specified' unless args.size == 1
          configure(opts)
          ap(ad { |c| c.delete(args[0]) })
        end
      end

      cmd.define_command do
        name    'move'
        usage   'move cn target_ou '
        summary 'moved a computer object'
        desc = 'Moves a computer object in active directory. Requires the CN of the '
        desc += 'object and the destination OU for the object.'
        description desc

        run do |opts, args|
          exit_2 'Move requires the CN, and the target OU be specified' unless args.size == 2
          configure(opts)
          ap(ad { |c| c.move(args[0], args[1]) })
        end
      end

      cmd.define_command do
        name    'get'
        usage   'get [options] sAMAccountName'
        summary 'gets all attributes for a computer'
        description 'returns all attributes of a computer object by searching for the sAMAccountName'

        run do |opts, args|
          exit_2 'Get requires the CN be specified' unless args.size == 1
          configure(opts)
          ap(ad { |c| c.get(args.first) })
        end
      end
    end
  end
end
