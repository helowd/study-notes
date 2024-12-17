# 服务器架设
连接服务器流程图  
![](images/file_permission.gif)

## 目录
<!-- vim-markdown-toc GFM -->

* [rsync](#rsync)
* [dhcp](#dhcp)
* [nfs](#nfs)
    * [配置文件/etc/exports](#配置文件etcexports)
    * [示例](#示例)
    * [用户映射原理](#用户映射原理)
* [NIS](#nis)
* [ntp](#ntp)
* [SAMBA](#samba)
* [proxy](#proxy)
* [iSCSI](#iscsi)
* [ftp](#ftp)
* [tcpdump](#tcpdump)
* [nc](#nc)
* [dns](#dns)
    * [rndc](#rndc)
    * [ddns](#ddns)
* [web](#web)
* [mail](#mail)

<!-- vim-markdown-toc -->

## rsync
传输文件的工具，主要用来同步备份，默认是增量备份，默认端口为873

rsync [-avrlptgoD] [-e ssh] [user@host:/dir] [/local/path]

## dhcp
让子网中的电脑开机就能立即自动设置好网络参数，基于udp广播。他主要藉由用户端传送广播封包给整个物理网段内的所有主机， 若区域网路内有DHCP 伺服器时，才会回应用户端的IP 参数要求。服务端默认端口为67

## nfs
nfs服务启动时会随机取几个端口并主动向rpc注册，因此rpc知道每个端口对应的nfs功能

rpc会指定每个nfs功能所对应的端口号，并返回给客户端，让客户端连接。rpc默认端口为111

要启动nfs必须先启动rpc

nfs服务包括的后台进程：rpc.nfsd、rpc.mountd、rpc.lockd、rpc.statd

nfs服务所需的软件：rpcbind、nfs-utils

### 配置文件/etc/exports
```
rw读写
ro只读
sync：同步，在将之前的请求所做的更改写入磁盘前，NFS 服务器不会回复请求。
async：异步，数据会先暂存于记忆体中，而不是直接读取硬碟
no_root_squash：允许用户端以root权限操作nfs目录
root_squash：用户端的root会被压缩成nfsnobody账户，保护系统
all_squash：所有用户都被压缩成nfsnobody
```

### 示例
```bash
# 任何人都能使用/tmp，并开放root用户
/tmp *(rw,no_root_squash)

# 同一目录针对不同范围开放不同权限
/home/public 192.168.100.0/24(rw) *(ro)
```

### 用户映射原理
基于uid和gid而不是名字

nfsnobody是由NFS服务在系统中自动创建的一个程序用户账号，该账号不能用于登录系统，专门用作NFS服务的匿名用户账号。

如果客户端所使用的用户身份不是root，而是一个普通用户，那么默认情况下在服务器端会将其视作其它用户（other）而不是nfsnobody

其中默认值是root_squash，即当客户端以root用户的身份访问NFS共享时，在服务器端会自动被映射为匿名账号nfsnobody

如果在服务器端赋予某个用户对共享目录具有相应权限，而且在客户端恰好也有一个具有相同uid的用户，那么当在客户端以该用户身份访问共享时，将自动具有服务器端对应用户的权限
```
root_squash，当NFS客户端以root用户身份访问时，映射为NFS服务器的nfsnobody用户。
no_root_squash，当NFS客户端以root身份访问时，映射为NFS服务器的root用户，也就是要为超级用户保留权限。这个选项会留下严重的安全隐患，一般不建议采用。
all_squash，无论NFS客户端以哪种用户身份访问，均映射为NFS服务器的nfsnobody用户。
```

注意：
```
但也正是因为这个原因，才会导致出现用户身份重叠的问题，对于NFS服务而言，这也是一个比较严重的安全隐患。
如何避免用户身份重叠呢？可以从以下两个方面着手：

一是在设置NFS共享时，建议采用“all_squash”选项，将所有客户端用户均映射为nfsnobody。这样就可以有效避免用户身份重叠的问题。
二是应严格控制NFS共享目录的系统权限，尽量不用为普通用户赋予权限。
```

查询服务器提供哪些资源给我们使用呢？ 
[root@clientlinux ~]# showmount -e 192.168.100.254

autofs：当我们要用到nfs共享目录时再把他挂载进来，不用时再卸载

## NIS
network information servier，用来管理其他主机账号信息的服务器

## ntp
network time protocol  
一个时间服务器，原来是通过国家授时中心同步时间，然后再给其它终端提供时间同步服务的  
UTC 协调标准时间（全球通用）
GMT 格林威治时间  
ntp可以自动处理延迟带来的误差  
电脑主机上面的BIOS 内部就含有一个原子钟在纪录与计算时间的进行  
ntpdate手动更新主机时间

hwclock -w 将目前linux时间写入bios系统，因为重启会重新从bios读取时间

## SAMBA
让linux与windows之间实现文件和打印机共享

## proxy
主要工作在OSI七层应用层部分，常作为网站代理，内网防火墙

让机器都使用代理：
(1)在对外的防火墙伺服器(NAT) 上面安装proxy； (2)在proxy 上头启动transparent 功能； (3) NAT 伺服器加上一条 port 80 转port 3128 的规则

## iSCSI
iSCSI（Internet Small Computer System Interface）是一种用于在 IP 网络上传输 SCSI（Small Computer System Interface）协议的存储协议。SCSI 是一种用于连接计算机和外部设备（如硬盘驱动器、打印机等）的标准接口协议，而 iSCSI 则通过网络传输 SCSI 命令和数据，将 SCSI 技术扩展到IP网络环境中

nas，network attached storage，相当于挂载一个文件系统，只能立即使用不能格式化  
san，storage area networks，面向大容量存储，提供硬盘

## ftp
后端服务器：Vsftpd
连接服务器的工具：ftp、lftp

## tcpdump
关键字：src dst host、net、tcp port、and、or
选项：-X 解析ascii和16进制封包，翻译成明文

## nc
-l ：作为监听之用，亦即开启一个port 来监听用户的连线；
-u ：不使用TCP 而是使用UDP 作为连线的封包状态

## dns
需要的软件：bind、bind-utils  
bind（berkeley Internet name domain）是伯克利大学开发的  
主要工具命令：dig

国内公网搭dns服务需要得到isp授权（上层dns服务器）

主要配置文件：
```
/etc/named.conf ：这就是我们的主设定档啦！
/etc/sysconfig/named ：是否启动chroot 及额外的参数，就由这个档案控制；
/var/named/ ：资料库档案预设放置在这个目录（zone文件）
/var/run/named ：named 这支程式执行时预设放置pid-file 在此目录内。
```

### rndc  
包括可以检查已经存在DNS 快取当中的资料、重新更新某个zone 而不需要重新启动整个DNS ， 以及检查DNS 的状态与统计资料等等的

### ddns
自动的动态修改ip

## web
lamp：linux、apache、mysql、php

## mail
电子邮件的发送过程会通过dns的MX记录类型解析得到邮件服务器地址
