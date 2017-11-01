## File_purge

A Puppet type and provider to whitelist some files inside a directory.
Every time Puppet runs, if there is a file in the monitored directory
that doesn't match the regular expression in the whitelist, it will
be removed.

### Usage

```
file_purge { '/root/test':
  ensure    => present,
  target    => '/root/test',
  whitelist => 'txt$',
}
```

or

```
file_purge { '/root/test':
  ensure    => present,
  target    => '/root/test',
  whitelist => ['txt$','md$'],
}
```

### Parameters
- Ensure: Set to present to let Puppet start monitoring the directory
- Target: Directory to be monitored
- Whitelist: Regular expression all files whitelisted must match

### To Do:
- Tests
- Use file attributes to whitelist (Ex: allow all files created by
user laura)
