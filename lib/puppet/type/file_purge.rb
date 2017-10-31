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
      elsif ! p.exist?
        raise ArgumentError, "Target %s does not exist" % value
      end
    end
  end

  newproperty(:whitelist)
end
