# MatchPlane 挑战 #11 — Push 403 解决方案

## 原因

Cloud Agent 使用 `cursor[bot]` GitHub App 凭据：

| 操作 | 目标 | 结果 |
| --- | --- | --- |
| clone / fetch | `LIghtJUNction/matchplane` | 成功（只读） |
| push | `LIghtJUNction/matchplane` | **403** — bot 无写权限 |
| fork / create repo | 任意 | **403** — integration 无权限 |

这不是配置错误，是 GitHub App 对第三方仓库的安全限制。**必须用你的个人账号 Fork + Push + PR。**

## 本目录内容

| 文件 | 说明 |
| --- | --- |
| `matchplane-challenge-11.bundle` | 98KB，`main..cursor/challenge-11-participation-897f` 全部 23 个提交 |
| `patches/*.patch` | 23 个 format-patch，可 `git am` 重放 |
| `pr-body.md` | 选定 PR 正文（口语版 #2） |
| `push-to-fork.sh` | 一键 Fork → 拉 bundle → push → 开 PR |

## 最快路径（本地一条命令）

```sh
git clone -b cursor/matchplane-challenge-11-897f \
  https://github.com/ChunchunOwO/api.lmm.best.git /tmp/challenge-11
chmod +x /tmp/challenge-11/challenge-11/push-to-fork.sh
/tmp/challenge-11/challenge-11/push-to-fork.sh
```

前提：`gh auth login` 已完成，且 GitHub 用户名与 api.lmm.best 接受挑战时填写的一致。

## 手动路径

```sh
# 1. 网页 Fork：https://github.com/LIghtJUNction/matchplane → Fork

# 2. 克隆你的 fork
git clone https://github.com/<你的用户名>/matchplane.git
cd matchplane
git checkout -b cursor/challenge-11-participation-897f

# 3. 应用 bundle（从本仓库 challenge-11/ 目录下载）
git pull /path/to/matchplane-challenge-11.bundle cursor/challenge-11-participation-897f

# 4. 推送
git push -u origin cursor/challenge-11-participation-897f

# 5. 开 PR
gh pr create --repo LIghtJUNction/matchplane --base main \
  --head <你的用户名>:matchplane:cursor/challenge-11-participation-897f \
  --title "挑战11：首页改成「帮我找」、卡片抄了瓜子的作业、后台能配微信和短信登录了" \
  --body-file /path/to/pr-body.md
```

## 对比链接模板

```
https://github.com/LIghtJUNction/matchplane/compare/main...<你的用户名>:matchplane:cursor/challenge-11-participation-897f
```
