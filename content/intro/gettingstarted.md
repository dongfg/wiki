---
title: "Getting Started"
layout: page
date: 2016-07-28 00:00
---

[TOC]

# Simiki
## Quick Start
### Install
	pip install simiki

### Update
	pip install -U simiki

### Init Site
	mkdir mywiki && cd mywiki
	simiki init

### folder structure
```
|--wiki
    |--content
    |--output
    |--themes
    |--_config.yml
    |--fabfile.py
```

### Generate
	simiki g

### Preview
    simiki p --host 0.0.0.0 --port 8888

### Extended Tools
> install fabric
```
pip install fabric
```
fabric 依赖的pycrypto无法在windows上安装，先安装pycryptodome
```
pip install pycryptodome
```
