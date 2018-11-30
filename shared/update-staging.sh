#!/bin/bash

merge_to_staging() {
  git fetch origin staging
  git checkout -b staging origin/staging
  git merge "$1"
  git push origin staging
  git checkout -
}

merge_master_to_staging() {
  echo "Merging master branch to staging"
  merge_to_staging "$TRAVIS_COMMIT"
}

merge_pr_to_staging() {
  echo "Merging PR to staging"
  merge_to_staging "$TRAVIS_PULL_REQUEST_SHA"
}

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  if [[ "$TRAVIS_PULL_REQUEST_SLUG" == "travis-ci/kubernetes-config" ]]; then
    merge_pr_to_staging
  fi
elif [[ "$TRAVIS_BRANCH" == "master" ]]; then
  merge_master_to_staging
fi
