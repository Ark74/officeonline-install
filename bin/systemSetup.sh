#!/bin/bash
# shellcheck disable=SC2154,SC2155
###############################################################################
############################# System preparation ##############################
ssl_fix_dirty(){
  local apt_file="/etc/apt/sources.list"
  local deb_="deb http://ftp.be.debian.org/debian/ jessie-backports main"
  local deb_src="deb-src http://ftp.be.debian.org/debian/ jessie-backports main"
  local check_deb=$(grep -c "$deb_" "$apt_file")
  local check_deb_src=$(grep -c "$deb_src" "$apt_file")

  if [ "$check_deb" == "0" ];then
    echo "$deb_" >> "$apt_file"
  fi
  if [ "$check_deb_src" == "0" ];then
    echo "$deb_src" >> "$apt_file"
  fi

  (
    echo "Package: openssl libssl1.0.0 libssl-dev libssl-doc"
    echo "Pin: release a=jessie-backports"
    echo "Pin-Priority: 1001"
  ) | tee /etc/apt/preferences.d/00_ssl
  apt-get update
  if ! apt-get install openssl libssl-dev -y --allow-downgrades; then
    exit 1
  fi
}

if [ -n "${set_name:?}" ]; then
  echo "Searching for a set named $set_name..."
  my_set=$(FindOnlineSet "$set_name" "$lo_src_repo" "$set_core_regex" "$lool_src_repo" "$set_online_regex" "$set_version")
  if [ -n "$my_set" ]; then
    lo_src_branch=$(awk '{print $1}' <<<"$my_set") && echo "Core branch: $lo_src_branch"
    lool_src_branch=$(awk '{print $2}' <<<"$my_set") && echo "Online branch: $lool_src_branch"
  fi
fi
# run apt update && upgrade if last update is older than 1 day
find /var/lib/apt/lists/ -mtime -1 |grep -q partial || apt-get update && apt-get upgrade -y

${sh_interactive} && apt-get install dialog -y

grep -q '# deb-src' "${soli}" && sed -i 's/# deb-src/deb-src/g' "${soli}" && apt-get update

# Need to checkout Distrib/Release
# shellcheck disable=SC2154,SC1090,SC1091
source /etc/os-release
DIST=$(ID)

DIST_PKGS=()
if [ "${DIST}" = "ubuntu" ]; then
  DIST_PKGS+=("openjdk-8-jdk")
elif [ "${DIST}" = "debian" ]; then
  case "${VERSION_ID}" in
    "9")
    ssl_fix_dirty
    DIST_PKGS+=("openjdk-8-jdk")
    DIST_PKGS+=("libpng16.16")
    DIST_PKGS+=("libpng-dev");;
    "8")
    DIST_PKGS+=("openjdk-7-jdk")
    DIST_PKGS+=("libpng12-0")
    DIST_PKGS+=("libpng12-dev");;
  esac
fi

if ! apt-get install ant sudo systemd wget zip make procps automake bison ccache \
flex g++ git gperf graphviz junit4 libcap-dev libcppunit-dev build-essential \
libcppunit-doc libcunit1 libcunit1-dev libegl1-mesa-dev libfontconfig1-dev libgl1-mesa-dev \
libgtk-3-dev libgtk2.0-dev libkrb5-dev libpcap0.8 libpcap0.8-dev libtool \
libxml2-utils libxrandr-dev libxrender-dev libxslt1-dev libxt-dev m4 nasm openssl libssl-dev \
pkg-config python-dev python-polib python3-dev uuid-runtime xsltproc libcap2-bin python-lxml \
  "${DIST_PKGS[@]}" -y; then
    exit 1
fi
if ! ${lo_mini}; then
  apt-get install doxygen libcups2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y
fi
apt-get build-dep libreoffice -y

if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
  curl -sL https://deb.nodesource.com/setup_6.x | bash -
  apt-get install nodejs -y
fi
if ${lo_non_free_ttf}; then
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install ttf-mscorefonts-installer -y
fi

getent passwd lool || (useradd lool -G sudo; mkdir /home/lool)
chown lool:lool /home/lool -R
