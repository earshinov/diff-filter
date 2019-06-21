#!/bin/sh
#
# Filter unified diff by filepath pattern
#
# Based on https://stackoverflow.com/a/37339566/675333
#
# Requirements:
#   - gawk
#
# References:
#   - Unified diff format: https://en.wikipedia.org/wiki/Diff#Unified_format
#

if [ $# -ne 1 ]
then
  echo '
Usage: diff-filter.sh FILEPATH_REGEXP < input.patch > output.patch

Arguments:

  FILEPATH_REGEXP - Pattern to match filepath against, specified in POSIX extended regular expression syntax' >&2
  exit 1
fi

export PATTERN="$1"
exec gawk -f "$(dirname "$0")"/diff-filter.awk
