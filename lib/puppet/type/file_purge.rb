# file_purge/lib/puppet/type/file_purge.rb
Puppet::Type.newtype(:file_purge) do
  ensurable()
  newparam(:target, :namevar => true)
  newparam(:whitelist)
end
