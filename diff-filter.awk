#!/usr/bin/env gawk -f
#
# Filter unified diff by filepath pattern
#
# Based on https://stackoverflow.com/a/37339566/675333
#
# Usage: PATTERN='package\.json' ./diff-filter.awk
#
# Notes:
#   - The pattern should be passed in an environment variable rather than
#     using -v option due to escaping issues: https://unix.stackexchange.com/a/120806
#   - Prefer using the `diff-filter.sh` wrapper script.
#
# References:
#   - Unified diff format: https://en.wikipedia.org/wiki/Diff#Unified_format
#

function storeOutput(line) {
  output[output_length++] = line;
}

function printOutput() {
  for (i=0; i < output_length; i++)
    print output[i];
  discardOutput();
}

function discardOutput() {
  delete output;
  output_length = 0;
}

function handleHeaderLine(line) {
  if ( \
    match(line, /^(---|+++) (.*)$/, matches) && matches[2] != "" && match(matches[2], pattern) ||
    # Support git-specific constructs like renames
    match(line, /^rename (from|to) (.*)$/, matches) && matches[2] != "" && match(matches[2], pattern) \
  ) {
    keep = 1;
    printOutput();
    print $0;
  }
  else
    storeOutput($0);
}

BEGIN {
  pattern = ENVIRON["PATTERN"]
  in_header = 1;
  keep = 0;
  output_length = 0;
}

{
  if (in_header) {
    # In header

    if (match($0, /^@@ /)) {
      # Hunk start
      in_header = 0;

      # Time to check whether we need to dump stored output to stdout or discard it
      if (keep)
        print $0;
      else
        discardOutput();
      next;
    }

    if (match($0, /^diff /)) {
      #
      # Assume that here start a diff between another two files.  Example:
      #
      #   diff --git a/styles.css b/app.css
      #   similarity index 100%
      #   rename from styles.css
      #   rename to app.css
      #   diff --git a/script.js b/script.js
      #   ...
      #
      if (keep)
        printOutput();
      else
        discardOutput();
      keep = 0;
      handleHeaderLine($0);
      next;
    }

    if (keep)
      print $0;
    else
      handleHeaderLine($0);
  }
  else {
    # In hunk

    if (!match($0, /^[-+ ]|@@ /)) {
      # No longer in hunk
      in_header = 1;
      keep = 0;
      handleHeaderLine($0);
      next;
    }

    # Normal hunk handling
    if (keep)
      print $0;
  }
}
