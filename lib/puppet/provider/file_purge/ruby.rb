Puppet::Type.type(:file_purge).provide(:ruby) do
  def list_all_files()
    Dir.glob(@resource[:target])
  end

  def exists?
    select_files().length > 0
  end

  def create
    sf = select_files()
    delete_files(sf)
  end

  def destroy
  end

  def select_files()
    to_purge = []
    files   = list_all_files()
    pattern = @resource[:whitelist] 
    files.each do |f|
      if f !~ /pattern/
        to_purge.push(f)
      end
    to_purge
    end
  end

  def delete_files(to_purge)
    to_purge.each do |f|
      begin
        File.delete(f)
      rescue
        Puppet.debug("File #{f} could not be deleted")
      else
        Puppet.debug("File #{f} has been deleted")
      end
    end
  end
end
