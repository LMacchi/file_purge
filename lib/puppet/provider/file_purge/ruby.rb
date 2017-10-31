Puppet::Type.type(:file_purge).provide(:ruby) do
  def list_all_files()
    Dir.glob("#{@resource[:target]}/*")
  end

  def exists?
    select_files_by_path(/#{@resource[:whitelist]}/).length == 0
  end

  def create
    sf = []
    sf = select_files_by_path(/#{@resource[:whitelist]}/)
    delete_files(sf)
  end

  def destroy
  end

  def select_files_by_path(pattern)
    to_purge = []
    files   = list_all_files()
    Puppet.debug("Files found by select_files: #{files}")
    files.each do |f|
      unless f =~ pattern
        to_purge.push(f)
      end
    end
    return to_purge
  end

  def delete_files(to_purge)
    to_purge.each do |p|
      begin
        File.delete(p)
      rescue
        Puppet.debug("File #{p} could not be deleted")
      else
        Puppet.debug("File #{p} has been deleted")
      end
    end
  end
end
