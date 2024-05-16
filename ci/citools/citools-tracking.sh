#!/usr/bin/env bash
set +e

if [[ -n "${CI}" ]]; then
INTALLED_VERSION_PATH="${1}/../citools_version_install"
CITOOLS_INSTALLED_VERSION=$(cat "${INTALLED_VERSION_PATH}" 2> /dev/null)
JOB_URL_VAR=${JOB_NAME:-''}
TASK=${2:-''}
curl --location -q 'https://argocd-deployer.eng.den.medallia.com/api/rafiki-argo/v0/citools/tracking' \
--header 'Content-Type: application/json' \
--data "{
\"task\": \"${TASK}\",
\"jobUrl\": \"${JOB_URL_VAR}\",
\"version\": \"${CITOOLS_INSTALLED_VERSION}\"
}"
fi
