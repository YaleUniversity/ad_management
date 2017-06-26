module AdManagement
  ##
  # Objects is the top level module for managed AD Objects
  module Objects
    require 'ad_management/objects/computer'
    include AdManagement::Objects::Computer
  end
end
