#!/bin/bash

# Runs only from `omarchy bundle project new`, after that command has shown
# this file and you have confirmed. Safe to run again. It writes scope.md
# in the new project folder and does not download anything or use sudo.

set -euo pipefail

if [[ -e scope.md ]]; then
  echo "scope.md already exists. Left it alone."
  exit 0
fi

cat >scope.md <<'EOF'
# Scope

Authorized by:

In scope:

Out of scope:

Start:

End:

This file records permission. It does not grant it. Test only the systems named above.
EOF

mkdir -p notes pcaps samples findings
echo "Wrote scope.md. Fill in who authorized the work before you test anything."
