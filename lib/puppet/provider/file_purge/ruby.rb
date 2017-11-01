Puppet::Type.type(:file_purge).provide(:ruby) do

  # Check if there are files to purge
  def exists?
    all     = list_all_files_in_dir(@resource[:target])
    to_keep = select_all_matching(all, @resource[:whitelist])
    get_files_to_purge(all, to_keep).length == 0
  end

  # Get a list of files to delete and purge them
  def create
    all      = list_all_files_in_dir(@resource[:target])
    to_keep  = select_all_matching(all, @resource[:whitelist])
    to_purge = get_files_to_purge(all, to_keep)
    purge_files(to_purge)
  end

  # Do nothing
  def destroy
  end

  # Get a list of all files inside the target
  def list_all_files_in_dir(target)
    Dir.glob("#{target}/*")
  end

  # Given a list of patterns, return all matching files
  def select_all_matching(files, patterns)
    to_keep = []
    patterns.each do |pattern|
      to_keep.concat(select_by_pattern(files, /#{pattern}/))
    end
    to_keep.uniq
  end
  
  # Given one pattern, return all matching files
  def select_by_pattern(files, pattern)
    to_keep = []
    files.each do |f|
      if f =~ pattern
        to_keep.push(f)
      end
    end
    to_keep.uniq
  end

  # Given all files and matching ones, return non-matching files
  def get_files_to_purge(files, to_keep)
    to_purge = files - to_keep
    to_purge
  end

  # Given a list of files, attempt to delete them
  def purge_files(to_purge)
    Puppet.debug("Files to purge: #{to_purge}")
    to_purge.each do |p|
      begin
        File.delete(p)
      rescue
        Puppet.err("File #{p} could not be deleted")
      else
        Puppet.err("File #{p} has been deleted")
      end
    end
  end
end
