---
title: Go VSCode配置
date: 2019-01-24 14:59:36
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

### 安装依赖
```
# you know
export http_proxy=http://127.0.0.1:1087
go get -u github.com/ramya-rao-a/go-outline
go get -u github.com/acroca/go-symbols
go get -u github.com/mdempsky/gocode
go get -u github.com/rogpeppe/godef
go get -u golang.org/x/tools/cmd/godoc
go get -u github.com/zmb3/gogetdoc
go get -u golang.org/x/lint/golint
go get -u github.com/fatih/gomodifytags
go get -u golang.org/x/tools/cmd/gorename
go get -u sourcegraph.com/sqs/goreturns
go get -u golang.org/x/tools/cmd/goimports
go get -u github.com/cweill/gotests/...
go get -u golang.org/x/tools/cmd/guru
go get -u github.com/josharian/impl
go get -u github.com/haya14busa/goplay/cmd/goplay
go get -u github.com/uudashr/gopkgs/cmd/gopkgs
go get -u github.com/davidrjenni/reftools/cmd/fillstruct
go get -u github.com/alecthomas/gometalinter
gometalinter --install
```