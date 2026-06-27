#!/bin/sh

set -e
set -o pipefail

PYVER="%%PYVER%%"

python_version=`printf "%s" "${PYVER}" | sed -Ee 's/([0-9])([0-9]+)/\1.\2/'`
python_cmd="/usr/local/bin/python${python_version}"

exec "${python_cmd}" -m yubal_api
