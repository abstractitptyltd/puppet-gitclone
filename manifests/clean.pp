# Class: gitclone::clean
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
define gitclone::clean($localtree = "/srv/git/", $real_name = false) {

  # Resource to clean out a working directory
  # Useful for directories you want to pull from upstream, but might
  # have added files. This resource is applied for all pull resources,
  # by default.
  #

  include gitclone::params
  exec { "git_clean_exec_$name":
    user      => $gitclone::params::user,
    cwd       => $real_name ? {
      false   => "$localtree/$name",
      default => "$localtree/$real_name"
    },
    command     => "git clean -d -f",
    environment => 'SSH_ASKPASS=/bin/false',
  }
}
