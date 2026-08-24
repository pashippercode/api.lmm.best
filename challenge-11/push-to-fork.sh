#!/usr/bin/env bash
# Push MatchPlane challenge #11 branch to YOUR GitHub fork and open compare URL.
# Requires: gh auth login (your account, NOT cursor[bot])
set -euo pipefail

UPSTREAM="LIghtJUNction/matchplane"
BRANCH="cursor/challenge-11-participation-897f"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! gh auth status >/dev/null 2>&1; then
  echo "Run: gh auth login" >&2
  exit 1
fi

USER="$(gh api user -q .login)"
echo "GitHub user: ${USER}"

if ! gh repo view "${USER}/matchplane" >/dev/null 2>&1; then
  echo "Forking ${UPSTREAM} → ${USER}/matchplane ..."
  gh repo fork "${UPSTREAM}" --clone=false
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

git clone "https://github.com/${USER}/matchplane.git" "${WORKDIR}/matchplane"
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
if [[ -f "${PR_BODY_FILE}" ]]; then
  gh pr create \
    --repo "${UPSTREAM}" \
    --base main \
    --head "${USER}:matchplane:${BRANCH}" \
    --title "${PR_TITLE}" \
    --body-file "${PR_BODY_FILE}" || true
fi

echo ""
echo "Branch pushed. Open PR compare:"
echo "https://github.com/${UPSTREAM}/compare/main...${USER}:matchplane:${BRANCH}"
