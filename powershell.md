# powershell

## 目录
<!-- vim-markdown-toc GFM -->

* [系统特点](#系统特点)
* [常用命令](#常用命令)
* [脚本执行](#脚本执行)
* [命名](#命名)
* [判断](#判断)
* [循环](#循环)
* [函数](#函数)

<!-- vim-markdown-toc -->

## 系统特点
winget  包管理工具  
powershell支持在多个平台上使用，centos、ubuntu等，并且是开源的

## 常用命令
cmdlet 是已经编译的命令的总和，根据动词-名词命名标准命名  

.ps1 powershell脚本的后缀名  

$PSVersionTable 打印当前powershell版本信息  

get-command 列出系统上所有可用的cmdlet  

get-help 查看命令帮助文档，help以分页形式输出  

get-member 查看某个对象的属性和方法  

update-help -uiculture en-Us -verbose 更新英文帮助文档  

select-object 筛选输出结果  

get-process 列出所有进程  

sort-object 对输出数据进行排序  

write-output 打印到标准输出  

read-host 输入到标准输入  

new-item 新建文件  

stop-computer  关闭本地和远程计算机

restart-computer  重启机器 

$env:username  获得当前用户名

start-service sshd  启动sshd服务

stop-service sshd  关闭sshd服务

get-service sshd  查看sshd服务状态

set-service sshd -starttype automatic  设置sshd服务开机自启

get-filehash -path "file" -algorithm sha256  获得文件哈希值

Start-Process ssh -ArgumentList "-N -R centos-7-01:7890:127.0.0.1:7890 centos-7-01" -NoNewWindow  命令在后台运行  

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned  允许当前用户运行脚本文件

rename-item -path oldname -newname newname  改名 

Get-Content example.txt -Encoding utf8  cat以utf8编码方式来展示文件内容，可以避免中文乱码

设置初始家目录
```
PS D:\zj\welljoint> cat $PROFILE
set-location -path "D:\zj\welljoint"
PS D:\zj\welljoint> $PROFILE
C:\Users\zj\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

## 脚本执行
绕过策略执行脚本
```powershell
powershell -ExecutionPolicy Bypass -File s:\git\scripts\like_grep.ps1 -targetDirectory . -pattern "\[toc\]"
```

## 命名

## 判断

## 循环

## 函数
