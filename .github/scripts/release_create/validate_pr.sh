#!/usr/bin/env bash

set -ex

echo "::notice:: Performing Release PR Validation for: ${PR_NUMBER}"

# Retrive PR Author:
author=$(gh pr view ${PR_NUMBER} --json author -q .author.login)


echo "::notice:: Checking if PR author ${PR_AUTHOR} is DSPO Owner..."

is_owner=$(cat ./OWNERS | var=${PR_AUTHOR} yq '[.approvers] | contains([env(var)])')
if [[ $is_owner == "false" ]]; then
  echo "::error:: PR author ${PR_AUTHOR} is not in OWNERS file. Only OWNERS can create releases."
  exit 1
fi



