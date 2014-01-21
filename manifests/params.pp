# Class: gitclone::params
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
class gitclone::params (
  $gitpackages = ["git"],
  $user,
  $group,
  $timeout = '300',
){
  
}
