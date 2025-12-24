---
title: rEFInd 多系统启动配置
date: 2025-12-24 13:44:08
updated: 2025-12-24 13:44:08
tag: windows
---

## menuentry

### volume 设置

diskpart 中挂载分区

```shell
select disk 0
select partition X
assign letter=Z
exit
```

cmd 中设置 label

```shell
label Z: ESP_DISK_0
```

### icon 注意事项
> menuentry 中配置的顺序很关键，如果先写 volume 再写 icon，当 volume 不是 rEFInd 所在的 ESP 时图标展示有问题

```txt
menuentry "SSD 120G" {
    icon \EFI\refind\theme\icons\os_win.png
    volume "ESP_DISK_0"
    loader \EFI\Microsoft\Boot\bootmgfw.efi
}
```

### UEFI SHELL
tools 中默认不包含，需要自行下载

## 其他杂项

```txt
# 只保留类似 Boot SSD 120G from ESP_DISK_0 的提示
hideui singleuser, editor, badges, hints

# 不要自动扫描 boot loader
scanfor manual
```