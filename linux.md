# linux

## 目录

<!-- vim-markdown-toc GFM -->

* [发展历史](#发展历史)
    * [LSB和FHS](#lsb和fhs)
    * [rocky linux](#rocky-linux)
* [文件管理](#文件管理)
* [账号管理](#账号管理)
* [quota、raid、lvm](#quotaraidlvm)
    * [quota](#quota)
    * [raid](#raid)
    * [lvm](#lvm)
* [计划任务](#计划任务)
* [程序管理](#程序管理)
    * [信号signal](#信号signal)
    * [介绍](#介绍)
    * [基本概念](#基本概念)
* [/proc/](#proc)
* [SElinuxux](#selinuxux)
* [systemd](#systemd)
* [日志记录](#日志记录)
* [开机流程](#开机流程)
* [核心模块](#核心模块)
* [资料查询](#资料查询)
    * [man](#man)
* [网络调试](#网络调试)
* [tty](#tty)

<!-- vim-markdown-toc -->
## 发展历史
1. 1969年贝尔实验室、麻省理工学院、奇异公司发起Multics计划，目的是制作使大型主机提供300个以上终端机使用的操作系统，但由于资金短缺等原因贝尔实验室退出了该计划
2. 贝尔实验室里的Thompson从Multics计划中获得了一些点子，由于个人需要，针对POP-7主机用Assembler语言开发Unics系统
3. Thompson和Ritchie将Unics用B语言编写，由于B语言编译出的核心效能不好，后来Ritchie用C语言重新改写与编译Unics核心，最终命名Unix
4. 后由于AT&T在1979年发行的第七版Unix中提到不可对学生提供原始码，Tanenbaum教授自己动手写了Minix这个Unix Like系统
5. Stallman在1984年发起GNU计划，旨在引导自由软件计划，在Unix的基础上，GNU开发了gcc、c library、bash等，1990年。推出了GPL，此时还是缺少一个自由的unix核心
6. 到了1991年，芬兰的赫尔辛基大学的Linus Torvalds在BBS上面贴了一则消息， 宣称他以bash, gcc等GNU 的工具写了一个小小的核心程式，该核心程式单纯是个玩具，不像GNU 那么专业。不过该核心程式可以在Intel的386机器上面运作就是了。这让很多人很感兴趣！从此开始了Linux不平凡的路程！第一个核心版本为0.02，linux遵循POSIX规范以让软件都能够在linux上跑
7. 这个『Kernel + Softwares + Tools + 可完整安装程序』的咚咚，我们称之为Linux distribution，他们都支持LSB和FHS标准，所以都大同小异

### LSB和FHS
LSB（Linux Standard Base）和FHS（Filesystem Hierarchy Standard）是两个不同的Linux标准，用于确保不同Linux发行版之间的兼容性和一致性。

1. **LSB（Linux Standard Base）**：
    
    * LSB是一个由Linux Foundation制定的标准，旨在定义Linux操作系统的一致性基础，以便于软件开发人员在不同Linux发行版上编写可移植的应用程序。
    * LSB规范定义了Linux系统中各种组件、库和API的标准化，以确保软件在LSB兼容的系统上可以正确运行。
    * LSB标准包括了如标准化系统调用、二进制文件格式、命令和工具等方面的规范。
2. **FHS（Filesystem Hierarchy Standard）**：
    
    * FHS是一个由Linux社区制定的标准，用于定义Linux系统中文件系统的布局结构和目录层次，以确保不同Linux发行版的一致性。
    * FHS规范定义了Linux系统中各个目录的用途和内容，如 `/bin`、`/sbin`、`/usr`、`/var` 等，以及如何组织用户和系统数据。
    * FHS标准的目的是使开发人员和系统管理员能够更容易地理解和管理Linux系统中的文件系统，以提高系统的可维护性和可移植性。

综上所述，LSB和FHS是两个不同的Linux标准，LSB用于定义Linux操作系统的一致性基础，而FHS用于定义Linux系统中文件系统的布局结构和目录层次。这两个标准的存在有助于确保不同Linux发行版之间的兼容性和一致性。

### rocky linux
从2021 年底，RHEL 衍生的CentOS 8 系列就不再持续维护(CentOS 7 则到2024/06/30 结束营业)，由于RHEL 算是业界使用广泛的一个商品， 因此，Red Hat 自己公司出产的CentOS 系列，一向都是业余界相当热门使用的Linux distribution 之一。在2022 年中，由当初的CentOS 共同创办人提出RockyLinux 的产品发表，同时于该年度推出RHEL 9 的衍生版本。

## 文件管理
文件隐藏属性：chattr设置隐藏属性，lsattr显示隐藏属性
shred  粉碎文件命令

## 账号管理
1. ACL 是Access Control List 的缩写，主要的目的是在提供传统的 owner,group,others 的read,write,execute 权限之外的细部权限设定。ACL 可以针对单一使用者，单一档案或目录来进行r,w,x 的权限规范，对于需要特殊权限的使用状况非常有帮助。
    getfacl：取得某个档案/目录的ACL 设定项目；
    setfacl：设定某个目录/档案的ACL 规范。
2. 在过去，我们想要对一个使用者进行认证(authentication)，得要要求使用者输入帐号密码， 然后透过自行撰写的程式来判断该帐号密码是否正确。也因为如此，我们常常得使用不同的机制来判断帐号密码， 所以搞的一部主机上面拥有多个各别的认证系统，也造成帐号密码可能不同步的验证问题！为了解决这个问题因此有了PAM (Pluggable Authentication Modules, 嵌入式模组) 的机制！
3. 使用者对谈： write, mesg, wall，mail，发送消息给该主机的其他用户

目录的x权限表示是否能够进入该目录

## quota、raid、lvm

### quota
quota可以针对群主、个人或者单独目录限制磁盘使用率
使用限制：核心必须支持quota，ext仅能针对整个文件系统

### raid
1. 主要用来提高存储设备可靠性、改善读写效率或提高容量
2. raid分为硬件和软件两种方式，软件由mdadm命令完成
3. 如果不用raid了需要关闭它，先卸载raid，再利用/dev/zero覆盖它，再用mdadm关闭raid，最后覆盖其他相关区块

### lvm
1. 主要用来弹性管理存储容量
2. 制作流程图：  
![](./centos7_lvm.jpg)
3. LVM thin Volume自动调整磁盘使用率
4. lvcreate创建快照区
5. 不用lvm要把相关内容都删除，并复原

## 计划任务
at仅执行一次
batch实现在cpu负载小的时候才执行
crontab循环执行
anacron检测没有按时执行的任务，并执行它们（电脑关机期间的任务）

## 程序管理
ctrl+z 将目前工作丢到后台中暂停
jobs 查看后台工作状态
fg 将后台程序调到终端来处理
bg 把后台程序从暂停转为运行状态
nice 给新的命令设置优先级
renice 调整已存在的程序优先级
demesg 分析核心信息
vmstat 查看系统资源
fuser 根据文件查使用该档案的程序
pidof 根据程序查pid

### 信号signal

### 介绍
软中断信号 Signal，简称信号，用来通知进程发生了异步事件，进程之间可以互相通过系统调用 kill 等函数来发送软中断信号。内核也可以因为内部事件而给进程发送信号，通知进程发生了某个事件，但是要注意信号只是用来通知进程发生了什么事件，并不给该进程传递任何数据，例如终端用户键入中断键，会通过信号机制停止当前程序。

Linux 中每个信号都有一个以 SIG 开头的名字，例如 （终止信号）SIGINT，退出信号（SIGABRT），信号定义在 bits/signum.h 头文件中，每个信号都被定义成整数常量。

### 基本概念
信号处理的三个过程：  
1. 发送信号：有发送信号的函数
2. 接收信号：有接收信号的函数
3. 处理信号：有处理信号的函数

信号处理的三种方式：  
在某个信号出现时，可以告诉内核按照下面的三种方式之一来处理：  
1. 忽略此信号：大多数信号都可以忽略，但是SIGKILL和SIGSTOP不能忽略
2. 捕捉信号：通知内核再某种信号发生时，调用用户的函数来处理事件
3. 执行系统默认动作：大多数信号的系统默认动作时终止该进程，使用man 7 signal查看默认动作

常用信号：
```
SIGHUP ：终端结束信号
SIGINT ：键盘中断信号（Ctrl - C）
SIGQUIT：键盘退出信号（Ctrl - \）
SIGPIPE：浮点异常信号
SIGKILL：用来结束进程的信号
SIGALRM：定时器信号
SIGTERM：kill 命令发出的信号
SIGCHLD：标识子进程结束的信号
SIGSTOP：停止执行信号（Ctrl - Z）
```

## /proc/
服务器上的程序都是在内存中，而内存中的资料又都是写到`/proc/*`这个目录下，基本上主机上面各个程序的pid都是以目录的形式存在/proc当中

程序自己的数据存在/proc/pid/下，而整个linux系统的数据存在/proc/下
```
档名    档案内容
/proc/cmdline   载入kernel 时所下达的相关指令与参数！查阅此档案，可了解指令是如何启动的！
/proc/cpuinfo   本机的CPU 的相关资讯，包含时脉、类型与运算功能等
/proc/devices   这个档案记录了系统各个主要装置的主要装置代号，与 mknod有关呢！
/proc/filesystems   目前系统已经载入的档案系统啰！
/proc/interrupts    目前系统上面的IRQ 分配状态。
/proc/ioports   目前系统上面各个装置所配置的I/O 位址。
/proc/kcore 这个就是记忆体的大小啦！好大对吧！但是不要读他啦！
/proc/loadavg   还记得top以及uptime 吧？没错！上头的三个平均数值就是记录在此！
/proc/meminfo   使用free列出的记忆体资讯，嘿嘿！在这里也能够查阅到！
/proc/modules   目前我们的Linux 已经载入的模组列表，也可以想成是驱动程式啦！
/proc/mounts    系统已经挂载的资料，就是用mount 这个指令呼叫出来的资料啦！
/proc/swaps 到底系统挂载入的记忆体在哪里？呵呵！使用掉的partition 就记录在此啦！
/proc/partitions    使用fdisk -l 会出现目前所有的partition 吧？在这个档案当中也有纪录喔！
/proc/uptime    就是用uptime 的时候，会出现的资讯啦！
/proc/version   核心的版本，就是用uname -a 显示的内容啦！
/proc/bus/* 一些汇流排的装置，还有USB 的装置也记录在此喔！
```

## SElinuxux
由美国国家安全局开发NSA，属于核心模块，重点用在保护程序读取目录的权限  

selinux作用的位置   
![](selinux_1.gif)

selinux目前只有targeted、mls、minimum三种政策

selinux相关命令：  
getenforce 查看当前selinux模式  
setenforce [0|1] 将selinux在enforcing与permissive之间切换  
restorecon -Rv / 重新还原所有SELinux 的类型，处理更改selinux模式后不能正常开机的情况  
getsebool 查看selinux的规则  
setools-console-* selinux trubleshooting的各种工具  

## systemd
配置文件目录加载顺序：/etc/systemd/system --> /run/systemd/system --> /usr/lib/systemd/system（实际的配置文件）

systemctl常用命令：  
reload、is-active、is-enabled、mask注销，isolate切换模式，get-default，set-defaults，daemon-reload

## 日志记录
logger  将资料写入到日志  
logrotate  轮转日志，删除旧的日志    
journalctl  查看系统日志，日志存在内存中，重启会清除，可以通过设置/var/log/jouranl目录将日志保存下来

## 开机流程
1. 载入BIOS 的硬体资讯与进行自我测试，并依据设定取得第一个可开机的装置；
2. 读取并执行第一个开机装置内MBR 的boot Loader (亦即是grub2, spfdisk 等程式)；
3. 依据boot loader 的设定载入Kernel ，Kernel 会开始侦测硬体与载入驱动程式；
3. 在硬体驱动成功后，Kernel 会主动呼叫systemd 程式，并以default.target 流程开机；
    systemd 执行sysinit.target 初始化系统及basic.target 准备作业系统；
    systemd 启动multi-user.target 下的本机与伺服器服务；
    systemd 执行multi-user.target 下的/etc/rc.d/rc.local 档案；
    systemd 执行multi-user.target 下的getty.target 及登入服务；
    systemd 执行graphical 需要的服务

## 核心模块
dmidecode  解析本机硬件设备
dmesg  观察核心运作过程当中所显示的各项讯息记录
lspci  查看主板信息
xfsdump

dd: convert and copy a file

cpio: 主要用于备份

SRPM

X window

## 资料查询

### man
数字的意义
```
代号	代表内容
1	使用者在shell环境中可以操作的指令或可执行档
2	系统核心可呼叫的函数与工具等
3	一些常用的函数(function)与函式库(library)，大部分为C的函式库(libc)
4	装置档案的说明，通常在/dev下的档案
5	设定档或者是某些档案的格式
6	游戏(games)
7	惯例与协定等，例如Linux档案系统、网路协定、ASCII code等等的说明
8	系统管理员可用的管理指令
9	跟kernel有关的文件
```
man -f [command]  查看某个命令的资料所在页
man -k [key]  根据关键字去所有的man手册里匹配

## 网络调试
telnet
nslookup
nc

## tty
"tty" 是 teletypewriter 的缩写，是一种最初用于与计算机进行交互的设备。在现代计算机系统中，"tty" 通常用来指代终端（Terminal）。

终端是计算机用户与计算机进行交互的接口。在过去，终端是一种物理设备，类似于打字机，通过串口与计算机连接。用户通过在终端上输入命令，计算机则通过终端向用户提供输出。这种终端设备被称为 "tty"。

在现代操作系统中，特别是类 Unix 系统，"tty" 仍然用于表示与终端相关的设备。它通常被用于以下几个方面：

1. **终端设备名称：** 在 Unix 系统中，每个终端设备都有一个设备文件，例如 `/dev/tty1`、`/dev/tty2`。这些设备文件可以用于表示特定的终端。

2. **控制终端：** 在多用户环境下，每个用户登录到系统时通常会分配一个控制终端，该终端就是用户当前会话的主要输入和输出来源。用户可以使用 `tty` 命令来查看当前使用的终端。

3. **虚拟终端：** 在图形用户界面（GUI）环境中，虚拟终端允许用户在多个文本终端之间切换。每个虚拟终端都有一个对应的 "tty" 设备。

总的来说，"tty" 在计算机领域中通常指代与终端相关的设备或概念，它可以是物理终端设备，也可以是虚拟终端。
