#! /usr/bin/env bash

set -x

###############################################################
# Source FV3GFS workflow modules
# PSL fork - 25.05.21 Ding Liu - replace fv3gfs modules with awsarch modules
#. "${HOMEgfs}"/ush/load_fv3gfs_modules.sh
source "${HOMEgfs}/dev/ush/load_awsarch_modules.sh"
status=$?
if [[ ${status} -ne 0 ]]; then
    exit "${status}"
fi

export job="arch_tars"
export jobid="${job}.$$"

###############################################################
# Execute the JJOB
"${HOMEgfs}/jobs/JGLOBAL_ARCHIVE_TARS"
status=$?

exit "${status}"
