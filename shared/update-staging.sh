#!/bin/bash

GIT_URL="https://$GITHUB_TOKEN@github.com/travis-infrastructure/kubernetes-config.git"

merge_to_staging() {
  git fetch origin staging:staging
  git checkout staging
  git merge "$1"
  git push "$GIT_URL" staging
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
  if [[ "$TRAVIS_PULL_REQUEST_SLUG" == "travis-infrastructure/kubernetes-config" ]]; then
    merge_pr_to_staging
  fi
elif [[ "$TRAVIS_BRANCH" == "master" ]]; then
  merge_master_to_staging
fi
