# MatchPlane 挑战 #11 — 推送到 pashippercode fork

## 目标

- **不要**在 `api.lmm.best` 上开 PR（交付包仅作本地/分支备份）
- 分支推到 **`pashippercode/matchplane`**
- 向上游 **`LIghtJUNction/matchplane`** 开 PR（head = `pashippercode:matchplane:cursor/challenge-11-participation-897f`）

Cloud Agent（`cursor[bot]`）无法推送到 `pashippercode` 或上游，需用 **pashippercode** 账号本地执行。

## 现状

| 仓库 | 状态 |
| --- | --- |
| `pashippercode/matchplane` | **尚未 Fork**（需先创建） |
| `LIghtJUNction/matchplane` | 只读，bot push 403 |

## 本目录

| 文件 | 说明 |
| --- | --- |
| `matchplane-challenge-11.bundle` | 23 个提交，98KB |
| `patches/*.patch` | format-patch 备用 |
| `pr-body.md` | PR 正文 |
| `push-to-fork.sh` | 推到 pashippercode fork 并开上游 PR |

## 步骤

### 1. Fork（若还没有）

打开 https://github.com/LIghtJUNction/matchplane ，用 **pashippercode** 账号点 **Fork**。

### 2. 登录并推送

```sh
gh auth login   # 选择 GitHub.com，账号 pashippercode

git clone -b cursor/matchplane-challenge-11-897f \
  https://github.com/ChunchunOwO/api.lmm.best.git /tmp/challenge-11

chmod +x /tmp/challenge-11/challenge-11/push-to-fork.sh
/tmp/challenge-11/challenge-11/push-to-fork.sh
```

脚本会：拉 bundle → push 到 `pashippercode/matchplane` → 在 `LIghtJUNction/matchplane` 创建 PR。

### 3. 手动对比链接（脚本失败时用）

```
https://github.com/LIghtJUNction/matchplane/compare/main...pashippercode:matchplane:cursor/challenge-11-participation-897f
```

## 手动推送（不用 bundle 仓库）

```sh
gh auth login   # pashippercode
git clone https://github.com/pashippercode/matchplane.git
cd matchplane
git checkout -b cursor/challenge-11-participation-897f
git pull /path/to/matchplane-challenge-11.bundle cursor/challenge-11-participation-897f
git push -u origin cursor/challenge-11-participation-897f

gh pr create --repo LIghtJUNction/matchplane --base main \
  --head pashippercode:matchplane:cursor/challenge-11-participation-897f \
  --title "挑战11：首页改成「帮我找」、卡片抄了瓜子的作业、后台能配微信和短信登录了" \
  --body-file /path/to/pr-body.md
```
