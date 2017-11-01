# file_purge/lib/puppet/type/file_purge.rb
Puppet::Type.newtype(:file_purge) do
  desc "Puppet type that tells Puppet to start monitoring a directory for unwanted files"

  ensurable()

  newparam(:target, :namevar => true) do
    desc "Directory to monitor - Must be a fully qualified path"
    validate do |value|
      p = Pathname.new(value)
      if ! p.absolute?
        raise ArgumentError, "Target must be an absolute path"
      elsif ! p.directory?
        raise ArgumentError, "Target %s does not exist or is not a directory" % value
      end
    end
  end

  newparam(:whitelist, :array_matching => :all) do
    munge do |value|
      case value
      when String
        [].push(value)
      when Array
        value
      else
        raise ArgumentError, "Whitelist must be a String or an Array but is a %s" % value.class
      end
    end
  end
end
