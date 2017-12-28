#!/bin/bash
# shellcheck disable=SC2154
# this script contains:
## configure script
## build script
# build LibreOffice if it has'nt been built already or lo_forcebuild is true
if [ ! -d "${lo_dir}"/instdir ] || ${lo_forcebuild}; then
  if "${sh_interactive}"; then
    dialog --backtitle "Information" \
    --title "${lo_src_branch} is going to be built." \
    --msgbox "THE COMPILATION WILL TAKE REALLY A VERY LONG TIME,"'\n'"AROUND $((16/cpu)) HOURS (Depending on your CPU's speed),"'\n'"
SO BE PATIENT PLEASE! ! You may see errors during the installation, just ignore them and let it do the work." 10 78
    clear
  fi
  {
  cd "${lo_dir}" || exit
  DistribFile clear
  DistribFile append "$lo_configure_opts"
  # shellcheck disable=SC2086 # TODO: convert build options into an array
  ${lo_mini} && DistribFile append $lo_mini_opts
  ${lo_forcebuild} && [ -f "${lo_dir}"/configure ] && make clean
  if ! sudo -Hu lool ./autogen.sh --with-distro="$distrib_name"; then exit 2; fi

  # libreoffice take around 8/${cpu} hours to compile on fast cpu.
  # ${lo_forcebuild} && sudo -Hu lool make clean
  if ! sudo -Hu lool make; then exit 2; fi
  } > >(tee -a "${log_dir}"/LO-compilation.log) 2> >(tee -a "${log_dir}"/LO-compilation.log >&2)
fi
unset repChanged
