### ZCM 配置管理
- - - - -
### zcm-client
#### API
> 读取节点数据
```java
public String getContent();
```
> 监听节点数据变化
```java
public void addListener(final ZCMListener listener);
```
> 权限控制
> 只能读取授权的节点，不能创建节点、子节点，不能更新删除节点

### zcm-server
#### 父节点创建
每个系统申请时创建一个系统命名的节点分配给系统 -- 管理员可以删除该节点
#### 子节点创建
系统管理员权限只能在上面创建的节点下创建一级节点，拥有一级节点的增删改查权限，*不能创建二级节点？*