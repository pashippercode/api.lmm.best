#!/usr/bin/env bash
# Push MatchPlane challenge #11 to pashippercode/matchplane fork, then open upstream PR.
# Requires: gh auth login as pashippercode (must match FORK_USER).
set -euo pipefail

UPSTREAM="LIghtJUNction/matchplane"
FORK_USER="${FORK_USER:-pashippercode}"
BRANCH="cursor/challenge-11-participation-897f"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! gh auth status >/dev/null 2>&1; then
  echo "Run: gh auth login  (account: ${FORK_USER})" >&2
  exit 1
fi

LOGIN="$(gh api user -q .login)"
if [[ "${LOGIN}" != "${FORK_USER}" ]]; then
  echo "Logged in as ${LOGIN}, but FORK_USER is ${FORK_USER}." >&2
  echo "Run: gh auth login  # switch to ${FORK_USER}" >&2
  exit 1
fi

echo "Fork owner: ${FORK_USER}"

if ! gh repo view "${FORK_USER}/matchplane" >/dev/null 2>&1; then
  echo "Fork not found: ${FORK_USER}/matchplane" >&2
  echo "Create it: https://github.com/${UPSTREAM} → Fork → account ${FORK_USER}" >&2
  echo "Or: gh repo fork ${UPSTREAM} --clone=false" >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

git clone "https://github.com/${FORK_USER}/matchplane.git" "${WORKDIR}/matchplane"
cd "${WORKDIR}/matchplane"

if git show-ref --verify --quiet "refs/heads/${BRANCH}"; then
  git checkout "${BRANCH}"
else
  git checkout -b "${BRANCH}"
fi

if [[ -f "${SCRIPT_DIR}/matchplane-challenge-11.bundle" ]]; then
  git pull "${SCRIPT_DIR}/matchplane-challenge-11.bundle" "${BRANCH}"
elif compgen -G "${SCRIPT_DIR}/patches/"'*.patch' >/dev/null; then
  git am "${SCRIPT_DIR}"/patches/*.patch
else
  echo "Missing bundle or patches in ${SCRIPT_DIR}" >&2
  exit 1
fi

git push -u origin "${BRANCH}"

PR_TITLE='挑战11：首页改成「帮我找」、卡片抄了瓜子的作业、后台能配微信和短信登录了'
PR_BODY_FILE="${SCRIPT_DIR}/pr-body.md"
COMPARE_URL="https://github.com/${UPSTREAM}/compare/main...${FORK_USER}:matchplane:${BRANCH}"

if [[ -f "${PR_BODY_FILE}" ]]; then
  if gh pr create \
    --repo "${UPSTREAM}" \
    --base main \
    --head "${FORK_USER}:matchplane:${BRANCH}" \
    --title "${PR_TITLE}" \
    --body-file "${PR_BODY_FILE}"; then
    echo "PR created on ${UPSTREAM}"
  else
    echo "gh pr create failed; open compare URL manually:" >&2
    echo "${COMPARE_URL}" >&2
  fi
else
  echo "Open PR compare:"
  echo "${COMPARE_URL}"
fi
