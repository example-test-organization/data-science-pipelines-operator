#!/usr/bin/env bash

set -ex

cat <<"EOF" >> /tmp/body-file.txt
Release created successfully:
https://github.com/example-test-organization/data-science-pipelines-operator/releases/tag/${{ needs.fetch-data.outputs.target_version_tag }}
EOF

gh pr comment ${{ needs.fetch-data.outputs.pr_number }} --body-file /tmp/body-file.txt
