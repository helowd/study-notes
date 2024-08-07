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
    * [/proc/pid/stat文件](#procpidstat文件)
* [SElinuxux](#selinuxux)
* [系统服务daemon](#系统服务daemon)
    * [system V init](#system-v-init)
        * [服务的启动、关闭与观察等方式：](#服务的启动关闭与观察等方式)
        * [服务启动的分类：](#服务启动的分类)
        * [服务的相依性问题：](#服务的相依性问题)
        * [执行等级的分类：](#执行等级的分类)
        * [制定执行等级预设要启动的服务：](#制定执行等级预设要启动的服务)
        * [执行等级的切换行为：](#执行等级的切换行为)
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
![](images/centos7_lvm.jpg)
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

### /proc/pid/stat文件
`/proc/[pid]/stat` 文件包含了有关指定进程的各种信息，其中 `[pid]` 是进程的进程号。这个文件以一行的形式提供了关于进程的统计信息，格式如下：

```
pid (comm) state ppid pgrp session tty_nr tpgid flags minflt cminflt majflt cmajflt utime stime cutime cstime priority nice num_threads itrealvalue starttime vsize rss rsslim startcode endcode startstack kstkesp kstkeip signal blocked sigignore sigcatch wchan nswap cnswap exit_signal processor rt_priority policy delayacct_blkio_ticks guest_time cguest_time start_data end_data start_brk arg_start arg_end env_start env_end exit_code

各字段的含义如下：

1. **pid**：进程 ID。
2. **comm**：进程的命令名。
3. **state**：进程状态。可能的取值有：
    * R：运行（Running）
    * S：睡眠（Sleeping）
    * D：不可中断的睡眠（Uninterruptible Sleep）
    * Z：僵尸（Zombie）
    * T：停止（Stopped）
    * t：跟踪（Tracing）
    * W：死等（Paging）
    * X：死等（Paging）
    * x：死等（Paging）
    * K：死等（Paging）
    * W：死等（Paging）
    * P：等待下一步（Paging）
    * N：低优先级（Paging）
    * L：多进程（Paging）
    * l：多进程（Paging）
    * s：会话（Paging）
4. **ppid**：父进程 ID。
5. **pgrp**：进程组 ID。
6. **session**：会话 ID。
7. **tty_nr**：与进程关联的终端的 tty 数字。
8. **tpgid**：进程组 ID。
9. **flags**：进程标志（未使用）。
10. **minflt**：发生的缺页错误的次数，但是未引发 I/O 操作。
11. **cminflt**：子进程的缺页错误次数，但是未引发 I/O 操作。
12. **majflt**：发生的缺页错误的次数，引发了 I/O 操作。
13. **cmajflt**：子进程的缺页错误次数，引发了 I/O 操作。
14. **utime**：用户态运行的 CPU 时间（以时钟滴答为单位）。
15. **stime**：内核态运行的 CPU 时间（以时钟滴答为单位）。
16. **cutime**：子进程用户态运行的 CPU 时间（以时钟滴答为单位）。
17. **cstime**：子进程内核态运行的 CPU 时间（以时钟滴答为单位）。
18. **priority**：进程的动态优先级。
19. **nice**：进程的静态优先级。
20. **num_threads**：进程的线程数。
21. **itrealvalue**：（未使用）。
22. **starttime**：进程启动时的时间（以时钟滴答为单位）。
23. **vsize**：虚拟内存大小（以字节为单位）。
24. **rss**：常驻集大小（以页面为单位）。
25. **rsslim**：RSS 的软限制（以字节为单位）。
26. **startcode**：代码段起始位置。
27. **endcode**：代码段结束位置。
28. **startstack**：栈段起始位置。
29. **kstkesp**：当前栈指针（ESP）。
30. **kstkeip**：当前指令指针（EIP）。
31. **signal**：未决信号。
32. **blocked**：阻塞信号。
33. **sigignore**：忽略信号。
34. **sigcatch**：捕获信号。
35. **wchan**：进程当前正在等待的地址。
36. **nswap**：交换的页数（未使用）。
37. **cnswap**：子进程交换的页数（未使用）。
38. **exit_signal**：终止信号。
39. **processor**：处理器编号（未使用）。
40. **rt_priority**：实时优先级。
41. **policy**：调度策略。
42. **delayacct_blkio_ticks**：延迟帐户 I/O 操作时钟滴答数（未使用）。
43. **guest_time**：虚拟 CPU 时间（以时钟滴答为单位）。
44. **cguest_time**：子进程的虚拟 CPU 时间（以时钟滴答为单位）。
45. **start_data**：数据段的起始位置。
46. **end_data**：数据段的结束位置。
47. **start_brk**：堆的起始位置。
48. **arg_start**：命令行参数的起始位置。
49. **arg_end**：命令行参数的结束位置。
50. **env_start**：环境变量的起始位置。
51. **env_end**：环境变量的结束位置。
52. **exit_code**：退出状态码。
```
请注意，每个字段之间由空格分隔，但如果某些字段的值包含空格，则会用括号括起来。

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

## 系统服务daemon

### system V init
早期的unix，我们启动系统服务的管理方式被称为SysV 的init 脚本程式的处理方式！亦即系统核心第一支呼叫的程式是init ， 然后init 去唤起所有的系统所需要的服务，不论是本机服务还是网路服务就是了。

基本上init 的管理机制有几个特色如下：

#### 服务的启动、关闭与观察等方式：
所有的服务启动脚本通通放置于/etc/init.d/ 底下，基本上都是使用bash shell script 所写成的脚本程式，需要启动、关闭、重新启动、观察状态时， 可以透过如下的方式来处理：
```
启动：/etc/init.d/daemon start
关闭：/etc/init.d/daemon stop
重新启动：/etc/init.d/daemon restart
状态观察：/etc/init.d/daemon status
```

#### 服务启动的分类：
init 服务的分类中，依据服务是独立启动或被一只总管程式管理而分为两大类：
```
独立启动模式(stand alone)：服务独立启动，该服务直接常驻于记忆体中，提供本机或用户的服务行为，反应速度快。

总管程式(super daemon)：由特殊的xinetd 或inetd 这两个总管程式提供socket 对应或port 对应的管理。当没有用户要求某socket 或port 时， 所需要的服务是不会被启动的。若有用户要求时， xinetd 总管才会去唤醒相对应的服务程式。当该要求结束时，这个服务也会被结束掉～ 因为透过xinetd 所总管，因此这个家伙就被称为super daemon。好处是可以透过super daemon 来进行服务的时程、连线需求等的控制，缺点是唤醒服务需要一点时间的延迟。
```

#### 服务的相依性问题：
服务是可能会有相依性的～例如，你要启动网路服务，但是系统没有网路， 那怎么可能可以唤醒网路服务呢？如果你需要连线到外部取得认证伺服器的连线，但该连线需要另一个A服务的需求，问题是，A服务没有启动， 因此，你的认证服务就不可能会成功启动的！这就是所谓的服务相依性问题。init 在管理员自己手动处理这些服务时，是没有办法协助相依服务的唤醒的！

#### 执行等级的分类：
上面说到init 是开机后核心主动呼叫的， 然后init 可以根据使用者自订的执行等级(runlevel) 来唤醒不同的服务，以进入不同的操作界面。基本上Linux 提供7 个执行等级，分别是0, 1, 2...6 ， 比较重要的是1)单人维护模式、3)纯文字模式、5)文字加图形界面。而各个执行等级的启动脚本是透过/etc/rc.d/rc[0-6]/SXXdaemon 连结到/etc/init.d/daemon ， 连结档名(SXXdaemon) 的功能为： S为启动该服务，XX是数字，为启动的顺序。由于有SXX 的设定，因此在开机时可以『依序执行』所有需要的服务， 同时也能解决相依服务的问题。这点与管理员自己手动处理不太一样就是了。

#### 制定执行等级预设要启动的服务：
若要建立如上提到的SXXdaemon 的话，不需要管理员手动建立连结档， 透过如下的指令可以来处理预设启动、预设不启动、观察预设启动否的行为：
```
预设要启动： chkconfig daemon on
预设不启动： chkconfig daemon off
观察预设为启动否： chkconfig --list daemon
```

#### 执行等级的切换行为：
当你要从纯文字界面(runlevel 3) 切换到图形界面(runlevel 5)， 不需要手动启动、关闭该执行等级的相关服务，只要『 init 5 』即可切换，init 这小子会主动去分析/etc/rc.d/rc[35].d/ 这两个目录内的脚本， 然后启动转换runlevel 中需要的服务～就完成整体的runlevel 切换。

基本上init 主要的功能都写在上头了，重要的指令包括daemon 本身自己的脚本(/etc/init.d/daemon) 、xinetd 这个特殊的总管程式(super daemon)、设定预设开机启动的chkconfig， 以及会影响到执行等级的init N 等。虽然CentOS 7 已经不使用init 来管理服务了，不过因为考量到某些脚本没有办法直接塞入systemd 的处理，因此这些脚本还是被保留下来， 所以，我们在这里还是稍微介绍了一下。更多更详细的资料就请自己查询旧版本啰！如下就是一个可以参考的版本：

### systemd
systemd 将过去所谓的daemon 执行脚本通通称为一个服务单位(unit)，而每种服务单位依据功能来区分时，就分类为不同的类型(type)。基本的类型有包括系统服务、资料监听与交换的插槽档服务(socket)、储存系统状态的快照类型、提供不同类似执行等级分类的操作环境(target) 等等。

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
