#!/bin/sh

. /lib.subr

set -e
set -o pipefail

PYVER="%%PYVER%%"

python_version=`printf "%s" "${PYVER}" | sed -Ee 's/([0-9])([0-9]+)/\1.\2/'`
python_cmd="/usr/local/bin/python${python_version}"

create_user

if [ ! -d "${YUBAL_DATA}" ]; then
    mkdir -p "${YUBAL_DATA}"
fi

if [ ! -d "${YUBAL_CONFIG}" ]; then
    mkdir -p "${YUBAL_CONFIG}"
fi

change_owner \
    "${YUBAL_DATA}" "${YUBAL_CONFIG}"

exec su-exec noroot "${python_cmd}" -m yubal_api
