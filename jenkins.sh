#!/bin/bash
set -ex

bundle install --path "${HOME}/bundles/${JOB_NAME}" --without development

bundle exec rake test
