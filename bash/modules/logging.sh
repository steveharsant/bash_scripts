#!/usr/bin/env bash
#
# Pluggable logging Module
# version: 0.1.0
# Author: Steve Harsant

# Set liniting rules
# shellcheck disable=SC2059

write_message() {
  # write_message will lwrite a message to stdout when:
  #   - No other options are passed
  #   - For logging levels: INFO, PASS
  #
  #
  $message=$1
  $level=$2


}
