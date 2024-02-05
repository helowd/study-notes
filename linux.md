# linux

## 目录

<!-- vim-markdown-toc GFM -->

* [发展历史](#发展历史)
* [文件管理](#文件管理)
* [账号管理](#账号管理)
* [quota、raid、lvm](#quotaraidlvm)
    * [quota](#quota)
    * [raid](#raid)
    * [lvm](#lvm)
* [计划任务](#计划任务)
* [程序管理](#程序管理)
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
5. Stallman在1984年发起GNU计划，旨在引导自由软件计划，在Unix的基础上，GUN开发了gcc、c library、bash等，1990年。推出了GPL，此时还是缺少一个自由的unix核心
6. 到了1991年，芬兰的赫尔辛基大学的Linus Torvalds在BBS上面贴了一则消息， 宣称他以bash, gcc等GNU 的工具写了一个小小的核心程式，该核心程式单纯是个玩具，不像GNU 那么专业。不过该核心程式可以在Intel的386机器上面运作就是了。这让很多人很感兴趣！从此开始了Linux不平凡的路程！第一个核心版本为0.02，linux遵循POSIX规范以让软件都能够在linux上跑
7. 这个『Kernel + Softwares + Tools + 可完整安装程序』的咚咚，我们称之为Linux distribution，他们都支持LSB和FHS标准，所以都大同小异

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

## SElinuxux
由美国国家安全局开发NSA，属于核心模块，重点用在保护程序读取目录的权限
selinux作用的位置
![](selinux_1.gif)
selinux目前只有targeted、mls、minimum三种政策

getenforce 查看当前selinux模式
setenforce [0|1] 将selinux在enforcing与permissive之间切换
restorecon -Rv / 重新还原所有SELinux 的类型，处理更改selinux模式后不能正常开机的情况
getsebool 查看selinux的规则
setools-console-* selinux trubleshooting的各种工具

## systemd
配置文件目录：/etc/systemd/system --> /run/systemd/system --> /usr/lib/systemd/system（实际的配置文件）

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
