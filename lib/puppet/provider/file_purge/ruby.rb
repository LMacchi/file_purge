Puppet::Type.type(:file_purge).provide(:ruby) do

  # Check if there are files to purge
  def exists?
    get_files_to_purge(select_all_matching(@resource[:whitelist])).length == 0
  end

  # Get a list of files to delete and purge them
  def create
    fp = get_files_to_purge(select_all_matching(@resource[:whitelist]))
    purge_files(fp)
  end

  # Do nothing
  def destroy
  end

  # Get a list of all files inside the target
  def list_all_files_in_dir()
    Dir.glob("#{@resource[:target]}/*")
  end

  # Given a list of patterns, return all matching files
  def select_all_matching(patterns)
    to_keep = []
    patterns.each do |pattern|
      to_keep.concat(select_by_pattern(/#{pattern}/))
    end
    to_keep.uniq
  end
  
  # Given one pattern, return all matching files
  def select_by_pattern(pattern)
    to_keep = []
    files   = list_all_files_in_dir()
    files.each do |f|
      if f =~ pattern
        to_keep.push(f)
      end
    end
    to_keep.uniq
  end

  # Given all files and matching ones, return non-matching files
  def get_files_to_purge(to_keep)
    list_all_files_in_dir() - to_keep
  end

  # Given a list of files, attempt to delete them
  def purge_files(to_keep)
    Puppet.debug("Files to purge: #{to_purge}")
    to.purge = get_files_to_purge(to_keep)
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
