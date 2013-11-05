# Class: gitclone::reset
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
define gitclone::reset($localtree = "/srv/git/", $real_name = false, $clean = true) {

  #
  # Resource to reset changes in a working directory
  # Useful to undo any changes that might have occured in directories
  # that you want to pull for. This resource is automatically called
  # with every pull by default.
  #
  # You can set $clean to false to prevent a clean (removing untracked
  # files)
  #

  exec { "git_reset_exec_$name":
    cwd => $real_name ? {
      false => "$localtree/$name",
      default => "$localtree/$real_name"
    },
    command     => "git reset --hard HEAD",
    environment => 'SSH_ASKPASS=/bin/false',
    path    => ["/bin", "/usr/bin", "/usr/sbin"],
  }

  if $clean {
    gitclone::clean { "$name":
      localtree => "$localtree",
      real_name => "$real_name"
    }
  }
}

