---
title: Gitlab /api/v4/projects/ 404 fix
date: 2020-03-12 14:05:39
tag: Git
---

## namespaced-path-encoding

Official doc： https://docs.gitlab.com/ce/api/README.html#namespaced-path-encoding

If using namespaced API calls, make sure that the `NAMESPACE/PROJECT_PATH` is URL-encoded.

For example, `/` is represented by `%2F`:

```
GET /api/v4/projects/diaspora%2Fdiaspora
```

## Solution

If you are using nginx as a proxy to access gitlab:

change `proxy_pass` from `proxy_pass https://gitlab/` to `proxy_pass proxy_pass https://gitlab$request_uri;`
