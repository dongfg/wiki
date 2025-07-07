#!/usr/bin/env sh
# shellcheck shell=dash

set -eu
trap "exit 1" TERM
MY_PID=$$

log() {
  echo "$@" >&2
}

fatal() {
  log "$@"
  kill -s TERM "${MY_PID}"
}

safe_sudo() {
  SUDO=""
  SAFE_UID=$(id -u) # UID might already be set

  if [ "${SAFE_UID}" != 0 ]; then
    SUDO="sudo"
  fi

  ${SUDO} "$@"
}

detect_curl() {
  command -v curl >/dev/null 2>&1 || { fatal "Could not detect curl. Please install curl and re-run this script."; exit 1; }
}

detect_tee() {
  command -v tee >/dev/null 2>&1 || { fatal "Could not detect tee. Please install coreutils and re-run this script."; exit 1; }
}

# detect_arch tries to determine the cpu architecture. The output must be
# one of the supported build architectures for deb and rpm packages.
detect_arch() {
  uname_m=$(uname -m)
  case "${uname_m}" in
    amd64|x86_64)
      echo "amd64"
      return
      ;;
    aarch64|arm64*)
      echo "arm64"
      return
      ;;
    ppc64el|ppc64le)
      echo "${uname_m}"
      return
      ;;
    *)
      fatal "Unknown unsupported arch: ${uname_m}"
      ;;
  esac
}

# detect_package_system tries to detect the host distribution to determine if
# deb or rpm should be used for installing Alloy. Prints out either "deb"
# or "rpm". Calls fatal if the host OS is not supported.
detect_package_system() {
  command -v dpkg >/dev/null 2>&1 && { echo "deb"; return; }
  command -v rpm  >/dev/null 2>&1 && { echo "rpm"; return; }

  uname=$(uname)
  case "${uname}" in
    Darwin)
      fatal 'macOS not supported'
      ;;
    *)
      fatal "Unknown unsupported OS: ${uname}"
      ;;
  esac
}

SHA256_SUMS="
# BEGIN_SHA256_SUMS
2a74430716141451c1f9ddb270b9d7b60721b0335cfa581a58ce76f9f4efa304  alloy-1.9.2-1.amd64.deb
55d4ac71fc8376253475c621cf8613b9712ab8b6684fdcafec14b3119ffdedeb  alloy-1.9.2-1.amd64.rpm
25fb408f9791aeb251112b8dcbca28a6e13b19156ac775dec51b5fa1190b79f5  alloy-1.9.2-1.arm64.deb
25720534a6b65fd1b03a065e73e9a2266efc92a669416a2a36a666f2bb6a1179  alloy-1.9.2-1.arm64.rpm
80ae6c621bd119987cd5e1c9666728d2c392375df2ba5121675d8e2bab3d051c  alloy-1.9.2-1.ppc64el.deb
f7ecbe572a0b8a63f6b74ad14d52250aded3571ac0c97e401ff297d903d5580f  alloy-1.9.2-1.ppc64le.rpm
277b87c40f8173e40b0af35f6fd478822d797036b7e8fccbbb5cc1664b69ec29  alloy-1.9.2-1.s390x.deb
f93038a3db33929c8a65ea87985ec3a480b907d8945e1694053c90388f5aa02a  alloy-1.9.2-1.s390x.rpm
# END_SHA256_SUMS
"

CONFIG_SHA256_SUMS="
# BEGIN_CONFIG_SHA256_SUMS
cf9f959c4718bcab1f80595751c0573342ac147194a578f0d2743dca248e3a83  config.alloy
# END_CONFIG_SHA256_SUMS
"

REMOTE_CONFIG_SHA256_SUMS="
# BEGIN_REMOTECONFIG_SHA256_SUMS
35ab482eb90bfad6f43160eec0646ef748e2b22447eb7ccb00020300fe61b382  config-fm.alloy
# END_REMOTECONFIG_SHA256_SUMS
"

HOSTNAME=$(uname -n)

#
# environment variables.
#
GCLOUD_HOSTED_METRICS_URL=${GCLOUD_HOSTED_METRICS_URL:=}   # Grafana Cloud Hosted Metrics url
GCLOUD_HOSTED_METRICS_ID=${GCLOUD_HOSTED_METRICS_ID:=}     # Grafana Cloud Hosted Metrics Instance ID
GCLOUD_SCRAPE_INTERVAL=${GCLOUD_SCRAPE_INTERVAL:=}         # Grafana Cloud Hosted Metrics scrape interval
GCLOUD_HOSTED_LOGS_URL=${GCLOUD_HOSTED_LOGS_URL:=}         # Grafana Cloud Hosted Logs url
GCLOUD_HOSTED_LOGS_ID=${GCLOUD_HOSTED_LOGS_ID:=}           # Grafana Cloud Hosted Logs Instance ID
GCLOUD_FM_URL=${GCLOUD_FM_URL:=}                           # Grafana Cloud Hosted Fleet Management url
GCLOUD_FM_POLL_FREQUENCY=${GCLOUD_FM_POLL_FREQUENCY:=}     # Grafana Cloud Hosted Fleet Management poll frequency
GCLOUD_FM_HOSTED_ID=${GCLOUD_FM_HOSTED_ID:=}               # Grafana Cloud Hosted Fleet Management Instance ID
GCLOUD_RW_API_KEY=${GCLOUD_RW_API_KEY:=}                   # Grafana Cloud API key

# Validate required environment variables
FM_ENABLED="false"
[ -z "${GCLOUD_RW_API_KEY}" ]  && fatal "Required environment variable \$GCLOUD_RW_API_KEY not set."
[ -z "${GCLOUD_HOSTED_LOGS_URL}" ] && fatal "Required environment variable \$GCLOUD_HOSTED_LOGS_URL not set."
[ -z "${GCLOUD_HOSTED_LOGS_ID}" ]  && fatal "Required environment variable \$GCLOUD_HOSTED_LOGS_ID not set."
[ -z "${GCLOUD_HOSTED_METRICS_URL}" ] && fatal "Required environment variable \$GCLOUD_HOSTED_METRICS_URL not set."
[ -z "${GCLOUD_HOSTED_METRICS_ID}" ]  && fatal "Required environment variable \$GCLOUD_HOSTED_METRICS_ID not set."
if [ -z "${GCLOUD_FM_URL}" ]; then
  [ -z "${GCLOUD_SCRAPE_INTERVAL}" ]  && fatal "Required environment variable \$GCLOUD_SCRAPE_INTERVAL not set."
else
  FM_ENABLED="true"
  [ -z "${GCLOUD_FM_POLL_FREQUENCY}" ] && fatal "Required environment variable \$GCLOUD_FM_POLL_FREQUENCY not set."
  [ -z "${GCLOUD_FM_HOSTED_ID}" ]  && fatal "Required environment variable \$GCLOUD_FM_HOSTED_ID not set."
fi

#
# Global constants.
#
RELEASE_VERSION="v1.9.2"
RELEASE_URL="https://github.com/grafana/alloy/releases/download/${RELEASE_VERSION}"
CONFIG_FILE="config.alloy"

# Fleet Management enabled, use the FM config file.
if [ "${FM_ENABLED}" = "true" ]; then
  CONFIG_FILE="config-fm.alloy"
  CONFIG_SHA256_SUMS="${REMOTE_CONFIG_SHA256_SUMS}"
fi

# Architecture to install. If empty, the script will try to detect the value to use.
ARCH=${ARCH:=$(detect_arch)}

# Package system to install Alloy with. If not empty, MUST be either rpm or
# deb. If empty, the script will try to detect the host OS and the appropriate
# package system to use.
PACKAGE_SYSTEM=${PACKAGE_SYSTEM:=$(detect_package_system)}

# Enable or disable use of systemctl.
USE_SYSTEMCTL=${USE_SYSTEMCTL:-1}

# install_deb downloads and installs the deb package of Alloy.
install_deb() {
  # The DEB and RPM urls don't include the `v` version prefix in the file names,
  # so we trim it out using ${RELEASE_VERSION#v} below.
  DEB_NAME="alloy-${RELEASE_VERSION#v}-1.${ARCH}.deb"
  DEB_URL="${RELEASE_URL}/${DEB_NAME}"
  CURL_PATH=$(command -v curl)

  curl -fL# "${DEB_URL}" -o "/tmp/${DEB_NAME}" || fatal 'Failed to download package'

  case "${CURL_PATH}" in
    /snap/bin/curl)
      log '--'
      log '--- WARNING: curl installed via snap may not store downloaded file'
      log '--- If checksum of package fails, use apt to install curl'
      log '---'
      ;;
    *)
      ;;
  esac

  log '--- Verifying package checksum'
  (cd /tmp && check_sha "${SHA256_SUMS}" "${DEB_NAME}")

  safe_sudo dpkg -i "/tmp/${DEB_NAME}"
  rm "/tmp/${DEB_NAME}"
}

# install_rpm downloads and installs the rpm package of Alloy.
install_rpm() {
  # The DEB and RPM urls don't include the `v` version prefix in the file names,
  # so we trim it out using ${RELEASE_VERSION#v} below.
  RPM_NAME="alloy-${RELEASE_VERSION#v}-1.${ARCH}.rpm"
  RPM_URL="${RELEASE_URL}/${RPM_NAME}"

  curl -fL# "${RPM_URL}" -o "/tmp/${RPM_NAME}" || fatal 'Failed to download package'

  log '--- Verifying package checksum'
  (cd /tmp && check_sha "${SHA256_SUMS}" "${RPM_NAME}")

  safe_sudo rpm --reinstall "/tmp/${RPM_NAME}"
  rm "/tmp/${RPM_NAME}"
}

# download_config downloads the config file for Alloy and replaces
# placeholders with actual values.
download_config() {
  TMP_CONFIG_FILE="/tmp/${CONFIG_FILE}"
  curl -fsSL "https://wiki.dongfg.com/attach/config.alloy" -o "${TMP_CONFIG_FILE}" || fatal 'Failed to download config'
  log '--- Verifying config checksum'
  (cd /tmp && check_sha "${CONFIG_SHA256_SUMS}" "${CONFIG_FILE}")

  sed -i -e "s~{GCLOUD_RW_API_KEY}~${GCLOUD_RW_API_KEY}~g" "${TMP_CONFIG_FILE}"
  sed -i -e "s~{GCLOUD_HOSTED_METRICS_URL}~${GCLOUD_HOSTED_METRICS_URL}~g" "${TMP_CONFIG_FILE}"
  sed -i -e "s~{GCLOUD_HOSTED_METRICS_ID}~${GCLOUD_HOSTED_METRICS_ID}~g" "${TMP_CONFIG_FILE}"
  sed -i -e "s~{GCLOUD_HOSTED_LOGS_URL}~${GCLOUD_HOSTED_LOGS_URL}~g" "${TMP_CONFIG_FILE}"
  sed -i -e "s~{GCLOUD_HOSTED_LOGS_ID}~${GCLOUD_HOSTED_LOGS_ID}~g" "${TMP_CONFIG_FILE}"
  if [ "${FM_ENABLED}" = "true" ]; then
    sed -i -e "s~{GCLOUD_FM_URL}~${GCLOUD_FM_URL}~g" "${TMP_CONFIG_FILE}"
    sed -i -e "s~{GCLOUD_FM_COLLECTOR_ID}~${HOSTNAME}~g" "${TMP_CONFIG_FILE}"
    sed -i -e "s~{GCLOUD_FM_POLL_FREQUENCY}~${GCLOUD_FM_POLL_FREQUENCY}~g" "${TMP_CONFIG_FILE}"
    sed -i -e "s~{GCLOUD_FM_HOSTED_ID}~${GCLOUD_FM_HOSTED_ID}~g" "${TMP_CONFIG_FILE}"
  else
    sed -i -e "s~{GCLOUD_SCRAPE_INTERVAL}~${GCLOUD_SCRAPE_INTERVAL}~g" "${TMP_CONFIG_FILE}"
  fi

  safe_sudo mkdir -p /etc/alloy
  safe_sudo mv "${TMP_CONFIG_FILE}" /etc/alloy/config.alloy
}

check_sha() {
  local checksums="$1"
  local asset_name="$2"
  shift 2

  echo -n "${checksums}" | grep "${asset_name}" | sha256sum --check --status --quiet - || fatal 'Failed sha256sum check'
}

main() {
  detect_curl
  detect_tee

  log '--- Retrieving config and placing in /etc/alloy/config.alloy'
  download_config

  # Create systemd override file for environment variables
  if [ "${FM_ENABLED}" = "true" ]; then
    log '--- Creating systemd override file for environment variables'
    safe_sudo mkdir -p /etc/systemd/system/alloy.service.d
    OVERRIDE_FILE="/etc/systemd/system/alloy.service.d/env.conf"
    {
      echo '[Service]'
      echo "Environment=GCLOUD_RW_API_KEY=${GCLOUD_RW_API_KEY}"
      echo "Environment=GCLOUD_FM_COLLECTOR_ID=${HOSTNAME}"
    } | safe_sudo tee "${OVERRIDE_FILE}" > /dev/null
    safe_sudo systemctl daemon-reload
  fi

  if [ "${USE_SYSTEMCTL}" -eq "1" ]; then
    log '--- Enabling and starting alloy.service'
    safe_sudo systemctl enable alloy.service
    safe_sudo systemctl start alloy.service
  fi

  log ''
  log ''
  log 'Alloy is now running!'
  log ''
  log 'To check the status of Alloy, run:'
  log '   sudo systemctl status alloy.service'
  log ''
  log 'To restart Alloy, run:'
  log '   sudo systemctl restart alloy.service'
  log ''
  log 'The config file is located at:'
  log '   /etc/alloy/config.alloy'
}

main
