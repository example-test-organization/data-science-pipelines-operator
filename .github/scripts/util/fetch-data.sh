#!/usr/bin/env bash

set -ex

var artifacts = await github.actions.listWorkflowRunArtifacts({
   owner: context.repo.owner,
   repo: context.repo.repo,
   run_id: ${WORKFLOW_RUN_ID},
});
var matchArtifact = artifacts.data.artifacts.filter((artifact) => {
  return artifact.name == "pr"
})[0];
var download = await github.actions.downloadArtifact({
   owner: context.repo.owner,
   repo: context.repo.repo,
   artifact_id: matchArtifact.id,
   archive_format: 'zip',
});
var fs = require('fs');
fs.writeFileSync('${GH_WORKSPACE}/pr.zip', Buffer.from(download.data));
