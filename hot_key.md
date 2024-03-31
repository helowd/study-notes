# 快捷键

## vim
vim在vi的基础上支援正规表示法的搜寻架构、多档案编辑、区块复制等
```
ｈ左，ｌ右，ｋ上，ｊ下　（30ｊ向下移动30列）

ctrl + f　向下移动一页
ctrl + b 向上移动一页

0 移动到这一行开头
$ 移动到这一行结尾
G 移动到最后一行
gg 移动到第一行

/word 向下寻找word
?word　向上寻找word

n　向下搜寻
N　向上搜寻

x 向后删除一个字符
X 向前删除一个字符

dd 删除当前行
yy 复制当前行
p 粘贴在当前行的下一行
P 粘贴在上一行

u 撤销
ctrl + r 重做上一个动作
. 同上

:! command 暂时离开vim，并执行命令

v	字元选择，会将游标经过的地方反白选择！
V	列选择，会将游标经过的列反白选择！
[Ctrl]+v	区块选择，可以用长方形的方式选择资料
y	将反白的地方复制起来
d	将反白的地方删除掉
p	将刚刚复制的区块，在游标所在处贴上！

:sp [filename] 开启一个新窗口
ctrl+w+j 移到下方窗口
ctrl+w+k 移到上方窗口
```

### 自用vim匹配
```
set nobackup
set noundofile
set nu
set hlsearch
set ruler
set backspace=2
syntax enable
set bg=light
set tabstop=4
set expandtab
set shiftwidth=4
```

## linux终端
```
ctrl+u 向前删除  
ctrl+k 向后删除  
ctrl+w 删除前一个单词  
alt+d 删除后一个单词  
ctrl+a 光标移到最前面  
ctrl+e 光标移到最后面  
ctrl+r 搜索历史命令  
ctrl+g 退出搜索历史命令
```
