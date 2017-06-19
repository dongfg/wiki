---
title: Git 基本知识
date: 2017-06-14 11:19:39
tag: Git
---
[TOC]
## Git与SVN比较

## Git基本操作
### 初始化
```
git init
```
### 提交文件
```
touch README.MD
edit README.MD
git add README.MD
git commit -m "add readme"
git push origin master
```
### 创建/切换分支
```
git checkout -b v1.2.0
```
### 合并(Merge)分支
```
git checkout
```
### 删除分支
```
git branch -D v1.2.0
git push origin --delete v1.2.0
```
## 附录
### Git资料参考
[猴子都能懂的Git入门](http://backlogtool.com/git-guide/cn/)

[史上最浅显易懂的Git教程](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)

[Got 15 minutes and want to learn Git?](https://try.github.io/levels/1/challenges/1)

[闯过这 54 关，点亮你的 Git 技能树](https://github.com/Gazler/githug)
