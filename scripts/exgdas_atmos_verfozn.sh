#! /usr/bin/env bash

################################################################################
# exgdas_atmos_verfozn.sh
#
# This script runs the data extract/validation portion of the Ozone Monitor
# (OznMon) DA package.
#
################################################################################
export err=0

if [[ -s "${oznstat}" ]]; then
    #------------------------------------------------------------------
    #  Copy data files file to local data directory.
    #  Untar oznstat file.
    #------------------------------------------------------------------

    cpreq "${oznstat}" "./oznstat.${PDY}${cyc}"

    tar -xvf "oznstat.${PDY}${cyc}"
    rm -f "oznstat.${PDY}${cyc}"

    netcdf=0
    for filenc4 in diag*nc4.gz; do
        netcdf=1
        file=$(echo "${filenc4}" | cut -d'.' -f1-2).gz
        mv "${filenc4}" "${file}"
    done

    export OZNMON_NETCDF=${netcdf}

    "${USHgfs}/ozn_xtrct.sh" && true
    export err=$?
    if [[ ${err} -ne 0 ]]; then
        err_exit "ozn_xtrct.sh failed!"
    fi

else
   # oznstat file not found
   # 25.06.30 Ding - forcing this to 0 so that it shows as successful even if ozn data is unavailable
   #     this is a hack to prevent the cycling from stopping when we don't have ozn obs available
   echo "No ozone obs found for cycle "${PDY}${cyc}"." > ${ROTDIR}/gdas.${PDY}/${cyc}/ozn_obs_missing
   export err=0
fi
exit 0
