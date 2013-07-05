# Class: git::clone
#
# This class does stuff that you describe here
#
# Parameters:
#   $parameter:
#       this global variable is used to do things
#
# Actions:
#   Actions should be described here
#
# Requires:
#   - Package["foopackage"]
#
# Sample Usage:
#
define git::clone(
  $source,
  $localtree = "/srv/git/",
  $real_name = false,
  $branch = false,
  $tag = false)
{
  include git::params
  if $real_name != false {
    $_name = $real_name
  } else {
    $_name = $name
  }

  exec { "git_clone_exec_$localtree/$_name":
    user        => $git::params::user,
    cwd         => $localtree,
    ###command  => "git clone `echo $source | sed -r -e 's,(git://|ssh://)(.*)//(.*),\\1\\2/\\3,g'` $_name",
    command     => "git clone $source $_name",
    creates     => "$localtree/$_name/.git/",
    require     => File["$localtree"],
    environment => 'SSH_ASKPASS=/bin/false',
  }

  if defined(File["$localtree"]) {
    realize(File["$localtree"])
  } else {
    @file { "$localtree":
      ensure => directory,
      owner  => $git::params::user,
      group  => $git::params::group,
    }
    realize(File["$localtree"])
  }

  case $branch {
    false: {}
    default: {
      exec { "git_clone_checkout_$branch_$localtree/$_name":
        cwd         => "$localtree/$_name",
        command     => "git checkout --track -b $branch origin/$branch",
        creates     => "$localtree/$_name/.git/refs/heads/$branch",
        require     => Exec["git_clone_exec_$localtree/$_name"],
        environment => 'SSH_ASKPASS=/bin/false',
      }
    }
  }

  case $tag {
    false: {}
    default: {
      exec { "git_clone_checkout_$tag_$localtree/$_name":
        cwd => "$localtree/$_name",
        command => "git checkout $tag",
        creates => "$localtree/$_name/.git/refs/heads/$branch",
        require => Exec["git_clone_exec_$localtree/$_name"]
      }
    }
  }
}
