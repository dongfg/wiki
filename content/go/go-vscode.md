---
title: Go VSCode配置
date: 2019-01-24 14:59:36
updated: 2019-01-24 16:07:04
tag: Go
---
### GOPATH 配置
```
# .zshrc
export GOPATH="/Users/dongfg/Projects/Go"
export PATH=$PATH:$(go env GOPATH)/bin
```

### 安装Go插件
[marketplace 安装](vscode:extension/ms-vscode.Go)
设置，搜索 `http: Proxy`，设置为 `http://127.0.0.1:1087`

### 安装依赖
`cmd + shift + p -> Install/Update Tools`
全选安装