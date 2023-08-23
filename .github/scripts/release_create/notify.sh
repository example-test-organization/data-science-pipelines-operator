#!/usr/bin/env bash

set -ex

cat <<EOF >> /tmp/body-file.txt
Release created successfully:

https://github.com/example-test-organization/data-science-pipelines-operator/releases/tag/${TARGET_VERSION_TAG}

https://github.com/example-test-organization/data-science-pipelines/releases/tag/${TARGET_VERSION_TAG}
EOF

gh pr comment ${PR_NUMBER} --body-file /tmp/body-file.txt

echo "::notice:: DSPO Release: https://github.com/example-test-organization/data-science-pipelines-operator/releases/tag/${TARGET_VERSION_TAG}"
echo "::notice:: DSP Release: https://github.com/example-test-organization/data-science-pipelines/releases/tag/${TARGET_VERSION_TAG}"
echo "::notice:: Feedback sent to PR."
