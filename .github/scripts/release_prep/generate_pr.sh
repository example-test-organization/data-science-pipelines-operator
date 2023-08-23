#!/usr/bin/env bash

# Note: The yaml in the body of the PR is used to feed inputs into the release workflow
# since there's no easy way to communicate information between the pr closing, and then triggering the
# release creation workflow.
# Therefore, take extra care when adding new code blocks in the PR body, or updating the existing one.
# Ensure any changes are compatible with the release_create workflow.

set -ex

echo "Retrieve the sha images from the resulting workflow (check quay.io for the digests)."
echo "Using [release-tools] generate a params.env and submit a new pr to vx.y+1.**x** branch."
echo "For images pulled from registry, ensure latest images are upto date"

BRANCH_NAME="release-${TARGET_RELEASE}"
git config --global user.email "${GH_USER_EMAIL}"
git config --global user.name "${GH_USER_NAME}"
git remote add ${GH_USER_NAME} https://${GH_USER_NAME}:${GH_TOKEN}@github.com/${GH_USER_NAME}/${DSPO_REPOSITORY}.git
git checkout -B ${BRANCH_NAME}

echo "Created branch: ${BRANCH_NAME}"

python ./scripts/release/release.py params --quay_org ${QUAY_ORG} --tag ${MINOR_RELEASE_TAG} --out_file ./config/base/params.env \
  --override="IMAGES_OAUTHPROXY=registry.redhat.io/openshift4/ose-oauth-proxy@sha256:ab112105ac37352a2a4916a39d6736f5db6ab4c29bad4467de8d613e80e9bb33"

git add .
git commit -m "Generate params for ${TARGET_RELEASE}"
git push ${GH_USER_NAME} $BRANCH_NAME -f

# Used to feed inputs to release creation workflow.
# target_version is used as the GH TAG
cat <<"EOF" >> /tmp/body-file.txt
This is an automated PR to prep Data Science Pipelines Operator for release.
```yaml
odh_org: ${GH_ORG}
release_branch: ${MINOR_RELEASE_BRANCH}
target_version_tag: ${MINOR_RELEASE_TAG}
previous_release_tag: ${PREVIOUS_RELEASE_TAG}
```
EOF

gh pr create \
  --repo https://github.com/${DSPO_REPOSITORY_FULL} \
  --body-file /tmp/body-file.txt  \
  --title "Release ${MINOR_RELEASE_TAG}" \
  --head "${GH_USER_NAME}:$BRANCH_NAME" \
  --label "release-automation" \
  --base "${MINOR_RELEASE_BRANCH}"
