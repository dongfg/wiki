---
title: github 批量删除 workflow 记录
date: 2023-10-19 15:20:04
tag: github

## 环境变量

```shell
export OWNER="用户名"
export REPOSITORY="仓库名"
```

## 查询 workflow 运行记录

```shell
gh api -X GET "/repos/$OWNER/$REPOSITORY/actions/runs?per_page=300" | jq '.workflow_runs[] | .id' | xargs -I{} echo {}
```

## 删除 workflow 运行记录

```shell
gh api -X GET "/repos/$OWNER/$REPOSITORY/actions/runs?per_page=300" | jq '.workflow_runs[] | .id' | xargs -I{} sh -c 'echo {} && gh api --silent -X DELETE /repos/$OWNER/$REPOSITORY/actions/runs/{}'
```