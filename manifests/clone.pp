# Define gitclone::clone
#
# Parameters:
#   $source
#       source for git clone
#
#   $localtree
#       local directory to clone repo into
#
#   $fetch
#       whether to run fetch on each puppet run
#
#   $branch
#       branch to checkout
#
#   $tag
#       tag to checkout
#
#   $revision of tag
#       revision of the tag
#       tag checkout won't run without this and it checks it's validity
#
# Sample Usage:
#
define gitclone::clone(
  $source,
  $localtree = "/srv/git/",
  $real_name = false,
  $fetch = false,
  $branch = false,
  $tag = false,
  $revision = false)
{
  include gitclone::params
  if $real_name != false {
    $_name = $real_name
  } else {
    $_name = $name
  }

  exec { "git_clone_exec_$localtree/$_name":
    user        => $gitclone::params::user,
    cwd         => $localtree,
    command     => $branch ? { false => "git clone ${source} ${_name}", default => "git clone -b ${branch} ${source} ${_name}" },
    creates     => "$localtree/$_name/.git/",
    require     => File["$localtree"],
    environment => 'SSH_ASKPASS=/bin/false',
  }

  if defined(File["$localtree"]) {
    realize(File["$localtree"])
  } else {
    @file { "$localtree":
      ensure => directory,
      owner  => $gitclone::params::user,
      group  => $gitclone::params::group,
    }
    realize(File["$localtree"])
  }
/*
  case $fetch {
    false: {}
    default: {
      exec { "git_clone_fetch_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git fetch --tags",
        onlyif      => "test -f $localtree/$_name/.git/HEAD",
        environment => 'SSH_ASKPASS=/bin/false',
      }
    }
  }
*/
/*
  case $branch {
    false: {}
    default: {
      exec { "git_clone_checkout_$branch_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git checkout --track -b $branch origin/$branch",
        creates     => "$localtree/$_name/.git/refs/heads/$branch",
        require     => Exec["git_clone_exec_$localtree/$_name"],
        environment => 'SSH_ASKPASS=/bin/false',
      }
    }
  }
*/
/*
  case $tag {
    false: {}
    default: {
      if $revision == false {
        fail("tag needs a revision")
      }
      exec { "git_clone_checkout_$tag_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git checkout ${tag}",
        unless      => "grep ${revision} .git/HEAD",
        #onlyif      => "grep \"${revision} refs\/tags\/${tag}\" .git/packed-refs",
        require     => Exec["git_clone_exec_$localtree/$_name"],
        environment => 'SSH_ASKPASS=/bin/false',
      }
    }
  }
*/
}
