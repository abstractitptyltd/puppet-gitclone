define gitclone::fetch(
  $localtree = "/srv/git/",
  $real_name = false,
  $reset = true,
  $clean = true,
  $branch = false,
  $tag = false,
  $revision = false) {

  # This resource enables one to update a working directory
  # from an upstream GIT source repository. Note that by default,
  # the working directory is reset (undo any changes to tracked
  # files), and clean (remove untracked files)
  #
  # Note that to prevent a reset to be executed, you can set $reset to
  # false when calling this resource.
  #
  # Note that to prevent a clean to be executed as part of the reset, you
  # can set $clean to false
  #
  include gitclone::params

  if $real_name != false {
    $_name = $real_name
  } else {
    $_name = $name
  }

  if $reset {
    gitclone::reset { "$name":
      localtree => "$localtree",
      real_name => "$_name",
      clean => $clean
    }
  }

  @exec { "git_fetch_exec_$name":
    user        => $gitclone::params::user,
    cwd         => "$localtree/$_name",
    command     => "git fetch --tags",
    onlyif      => "test -d $localtree/$_name/.git/info",
    environment => 'SSH_ASKPASS=/bin/false',
    path        => ["/bin", "/usr/bin", "/usr/sbin"],
    timeout     => $gitclone::params::timeout,
  }

  case $branch {
    false: {}
    default: {
      exec { "git_fetch_checkout_$branch_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git checkout --track -b $branch origin/$branch",
        creates     => "$localtree/$_name/refs/heads/$branch",
        environment => 'SSH_ASKPASS=/bin/false',
	      path        => ["/bin", "/usr/bin", "/usr/sbin"],
        timeout     => $gitclone::params::timeout,
      }
    }
  }

  case $tag {
    false: {}
    default: {
      if $revision == false {
        fail("tag needs a revision")
      }
      exec { "git_fetch_checkout_$tag_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git checkout ${tag}",
        unless      => "grep ${revision} .git/HEAD",
        #onlyif     => "grep \"${revision} refs\/tags\/${tag}\" .git/packed-refs",
        environment => 'SSH_ASKPASS=/bin/false',
	      path        => ["/bin", "/usr/bin", "/usr/sbin"],
      }
    }
  }

  if defined(Gitclone::Reset["$name"]) {
    Exec["git_fetch_exec_$name"] {
      require +> Gitclone::Reset["$name"]
    }
  }

  if defined(Gitclone::Clean["$name"]) {
    Exec["git_fetch_exec_$name"] {
      require +> Gitclone::Clean["$name"]
    }
  }

  realize(Exec["git_fetch_exec_$name"])
}
