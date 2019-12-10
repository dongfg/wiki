---
title: Git commit message
date: 2019-12-10 16:27:37
tag: Git
---
[TOC]

> [Angular 仓库提交规范](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-guidelines)
> [AngularJS Git Commit Message Conventions](https://wiki.dongfg.com/base/git-commit-msg-angular.html)

## 格式
```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```
`scope`, `body`, `footer` optional

`footer` 中可以关闭 issues

示例：
```
docs(changelog): update changelog to beta.5
```
```
fix(release): need to depend on latest rxjs and zone.js

The version in our package.json gets copied to the one we publish, and users need the latest of these.
```
### Revert
回滚时格式以 `revert:`开头，后面跟回滚 commit 的 subject，body 填写回滚 commit 的 hash，`This reverts commit <hash>`

### Type
- build: maven, gradle, npm 等构建系统或依赖变更
- ci: 自动构建脚本(travis, github pipeline, ...)
- docs: 文档注释
- feat: new feature
- fix: bug fix
- perf: 性能优化
- refacor: 代码重构
- style/lint: 格式化
- test: 单元测试

### Scope
> 指功能模块，视具体项目而定


### Subject
- 描述本次提交的变更，不是原来的，或者变更以后的
- 不以大写字母开头 (For english only)
- 不写句号

### Body
应该描述本次提交的变更、变更的原因及对比

### Footer-尾部
可以使用 `Closes #234` 关闭 issue

**Breaking Changes** 要以 `Breaking Changes:` 开头
