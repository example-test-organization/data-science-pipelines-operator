

echo "Create a tag release for x.y+1.z in DSPO and DSP (e.g. v1.3.0)"

gh release create ${TARGET_VERSION_TAG} --target ${RELEASE_BRANCH} --generate-notes --notes-start-tag ${PREVIOUS_VERSION_TAG}

cat <<EOF >> /tmp/release-notes.md
Any changes for the DSP component for ${TARGET_VERSION_TAG} can
be found [here](https://github.com/opendatahub-io/data-science-pipelines/releases/tag/${TARGET_VERSION_TAG}).
EOF

echo "$(gh release view ${TARGET_VERSION_TAG} --json body --jq .body)" >> /tmp/release-notes.md

echo "Release notes:"
cat /tmp/release-notes.md

gh release edit ${TARGET_VERSION_TAG} --notes-file /tmp/release-notes.md
rm /tmp/release-notes.md
