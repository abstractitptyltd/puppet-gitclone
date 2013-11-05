define gitclone::pull(
  $localtree = "/srv/git/",
  $real_name = false,
  $reset = true,
  $clean = true,$branch = false) {

  #
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
      real_name => "$real_name",
      clean => $clean
    }
  }

  @exec { "git_pull_exec_$name":
    user        => $gitclone::params::user,
    cwd         => "$localtree/$_name",
    command     => "git pull",
    onlyif      => "test -d $localtree/$_name/.git/info",
    environment => 'SSH_ASKPASS=/bin/false',
  }
/*
  case $branch {
    false: {}
    default: {
      exec { "git_pull_checkout_$branch_$localtree/$_name":
        user        => $gitclone::params::user,
        cwd         => "$localtree/$_name",
        command     => "git checkout --track -b $branch origin/$branch",
        creates     => "$localtree/$_name/refs/heads/$branch",
        environment => 'SSH_ASKPASS=/bin/false',
      }
    }
  }
*/
  if defined(Gitclone::Reset["$name"]) {
    Exec["git_pull_exec_$name"] {
      require +> Gitclone::Reset["$name"]
    }
  }

  if defined(Gitclone::Clean["$name"]) {
    Exec["git_pull_exec_$name"] {
      require +> Gitclone::Clean["$name"]
    }
  }

  realize(Exec["git_pull_exec_$name"])
}
