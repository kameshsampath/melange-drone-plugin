#!/usr/bin/env bash

set -exo pipefail

_config_file=${PLUGIN_CONFIG_FILE:-melange.yaml}
_output_dir=${PLUGIN_OUTPUT_DIR:-packages}
_source_dir=${PLUGIN_SOURCE_DIR:-$DRONE_WORKSPACE}

[[ ! -d  "$_output_dir" ]] && mkdir -p "$_output_dir"

melange_command=("melange build $_config_file --out-dir=$_output_dir")

if [ -n "$PLUGIN_ARCHS" ];
then 
  melange_command+=("--arch=${PLUGIN_ARCHS}")
else
   melange_command+=("--arch=$(uname -m)")
fi

if [ -n "$PLUGIN_ENV_FILE" ];
then 
  melange_command+=("--env-file=${PLUGIN_ENV_FILE}")
fi

melange_command+=("--source-dir=${_source_dir}")

if [ -z "$PLUGIN_SIGNING_KEY" ];
then
  printf "\n No signing key passed, generating one\n"
  melange keygen
  PLUGIN_SIGNING_KEY=melange.rsa
fi

melange_command+=("--signing-key=${PLUGIN_SIGNING_KEY}")

printf "\n Running command %s\n" "${melange_command[*]}"

exec bash -c "${melange_command[*]}"