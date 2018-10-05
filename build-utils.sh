#!/bin/bash

#####################################################################
# Check if array contains an element
# Arguments:
#   param1 - Element to check
#   param2 - Array to look for element in
# Returns:
#   None
#####################################################################
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

#######################################
# Synchronize files
# Arguments:
#   param1 - Source folder
#   param2 - Destination folder
#   param3 - Options {Array}
#######################################
syncFiles() {
  #echo "Syncing files from $1 to $2" 1
  cd $1; # we go to the folder to execute it with relative paths
  mkdir -p $2
  local REL_PATH_TO_DESTINATION=$(perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' $2 $1)
  # local REL_PATH_TO_DESTINATION=$(realpath --relative-to="." "$2");
  shift 2; # those 2 parameters are not needed anymore

  #echo "Syncing files using: rsync" 2
  if [[ ${TRACE} == true ]]; then
    rsync "${@}" ./ $REL_PATH_TO_DESTINATION/ -v
  else
    rsync "${@}" ./ $REL_PATH_TO_DESTINATION/
  fi
  cd - > /dev/null; # go back to the previous folder without any output
}
