# bash语法

## 目录
<!-- vim-markdown-toc GFM -->

* [重定向](#重定向)
* [注释](#注释)
* [循环](#循环)
* [case](#case)
* [变量使用](#变量使用)
* [特点](#特点)
* [算数](#算数)
* [命名](#命名)
* [检查返回值](#检查返回值)
* [启动环境](#启动环境)
* [模式扩展](#模式扩展)
* [字符处理](#字符处理)
    * [cut](#cut)
    * [tr](#tr)
    * [col](#col)
    * [join](#join)
    * [paste](#paste)
    * [expand](#expand)
    * [减号-用途](#减号-用途)
    * [printf](#printf)
    * [pr](#pr)
* [参数处理](#参数处理)
    * [getopts](#getopts)
* [配置项参数终止符--](#配置项参数终止符--)

<!-- vim-markdown-toc -->

## 重定向

文件描述符 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）

1. 屏蔽 stdout 和 stderr 

```bash
command > /dev/null 2>&1
```

2. 覆盖方式自动写入多行文本

```bash
make(){
    cat > ~/.gradle/gradle.properties <<-EOF
nexus_user=${username}
nexus_password=${password}
EOF
}
```

3. 标准错误输出重定向示例

```bash
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! do_something; then
  err "Unable to do_something"
  exit 1
fi
```

## 注释

1. 文件
 
放在一个文件的开头，包括概括本文件的内容，版权，作者等

```bash
#!/usr/bin/env bash
#
# Perform hot backups of Oracle databases.
```

2. 函数

包括功能描述，使用的全局变量，使用的参数，标准输出内容，返回值

```bash
#######################################
# Cleanup files from the backup directory.
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
#######################################
function cleanup() {
  …
}

#######################################
# Get configuration directory.
# Globals:
#   SOMEDIR
# Arguments:
#   None
# Outputs:
#   Writes location to stdout
#######################################
function get_dir() {
  echo "${SOMEDIR}"
}

#######################################
# Delete a file in a sophisticated manner.
# Arguments:
#   File to delete, a path.
# Returns:
#   0 if thing was deleted, non-zero on error.
#######################################
function del_thing() {
  rm "$1"
}
```

3. TODO

```bash
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)
```

## 循环

1. 让`; do`和`; then`与`while`, `for`, `if`在一行，`else`和结束符独占一行

```bash
# for
# If inside a function, consider declaring the loop variable as
# a local to avoid it leaking into the global environment:
# local dir
for dir in "${dirs_to_cleanup[@]}"; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if (( $? != 0 )); then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if (( $? != 0 )); then
      error_message
    fi
  fi
done

# while read
last_line='NULL'
while read line; do
  if [[ -n "${line}" ]]; then
    last_line="${line}"
  fi
done < <(your_command)

# This will output the last non-empty line from your_command
echo "${last_line}"
```

## case

```bash
case "${expression}" in
  a)
    variable="…"
    some_command "${variable}" "${other_expr}" …
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" …
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac

# 或

verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```

## 变量使用

1. 引用

推荐使用双引号加大括号`"${goodVariable}"`

2. 数组

数组使用()赋值，并且可以使用+=追加，declare -A可声明关联数组（字典）

```bash
declare -a flags
flags=(--foo --bar='baz')
flags+=(--greeting="Hello ${name}")
echo "${flags[@]}"
```

## 特点

1. 使用`$(command)`而不是反引号

2. 使用`[[ ... ]]`而不是`[ ... ]`, `test`和`/usr/bin/[`，前者还支持正则

```bash
# This ensures the string on the left is made up of characters in
# the alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# Invalid: This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
  echo "Match"
fi

# Valid: This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory
if [ "filename" == f* ]; then
  echo "Match"
fi
```

3. 使用`-z`和`-n`来判断字符串是否为空

4. 使用`(())`, `-lt`, `-gt`来判断数字大小，在`[[ ]]`中使用`>`, `<`会引起字典序比较

```bash
# Use this
if [[ "${my_var}" == "val" ]]; then
  do_something
fi

if (( my_var > 3 )); then
  do_something
fi

if [[ "${my_var}" -gt 3 ]]; then
  do_something
fi

# Instead of this
if [[ "${my_var}" = "val" ]]; then
  do_something
fi

# Probably unintended lexicographical comparison.
if [[ "${my_var}" > 3 ]]; then
  # True for 4, false for 22.
  do_something
fi
```

5. 避免使用eval

6. 函数定义全部放在文件最上方，只有`include`, `set`和常量声明可以放在函数之前，`main`应该作为调用语句放在文件最后一行

7. 尽可能使用内置命令而不是外部命令


## 算数

使用`(( ))`计算，`$(( ))`获取表达式的值，不使用`let`, `$[...]`, `expr`
***注意：使用(( ))计算，表达式值为０则命令返回值为非０***

1. 引用值

```bash
echo "$(( 2 + 2 )) is 4"
local -i hundred=$(( 10 * 10 ))
declare -i five=$(( 10 / 2 ))
```

2. 条件判断

```bash
if (( a < b )); then
  …
fi
```

3. 计算

```bash
(( i = 10 * j + 400 ))
# 自加
(( i += 3 ))
(( i ++ ))

# 浮点数
echo "5.01-4*2.0"|bc
```
4. 浮点数比较
```bash
# 方法1：bc
a=1.2
b=3.4
if [[ $(echo "$a < $b" | bc) -eq 1 ]]
then
    echo "$a is less than $b"
else
    echo "$a is greater than or equal to $b"
fi

# 方法2： awk
a=1.2
b=3.4
if [ $(awk -v x=$a -v y=$b 'BEGIN {print(x<y)}') -eq 1 ]
then
    echo "$a is less than $b"
else
    echo "$a is greater than or equal to $b"
fi
```

## 命名

1. 函数

函数名使用小写字母加下划线分隔，包使用`::`，圆括号是必须的，`function`关键字是可选的

```bash
# Single function
my_func() {
  …
}

# Part of a package
mypackage::my_func() {
  …
}
```

2. 变量名

同函数名类似

3. 常量和环境变量

全部大写加下划线分隔，在文件开头声明
```bash
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'
```

4. 文件名

类似函数名，建议可以`maketemplate`或`make_template`但不要`make-template`

## 检查返回值

```bash
if ! mv "${file_list[@]}" "${dest_dir}/"; then
  echo "Unable to move ${file_list[*]} to ${dest_dir}" >&2
  exit 1
fi

# Or
mv "${file_list[@]}" "${dest_dir}/"
if (( $? != 0 )); then
  echo "Unable to move ${file_list[*]} to ${dest_dir}" >&2
  exit 1
fi

# PIPESTATUS
tar -cf - ./* | ( cd "${DIR}" && tar -xf - )
return_codes=( "${PIPESTATUS[@]}" )
if (( return_codes[0] != 0 )); then
  do_something
fi
if (( return_codes[1] != 0 )); then
  do_something_else
fi
```

## 启动环境
1. interactive + login

`/etc/profile`  --> 顺序加载　`~/.bash_profile ~/.bash_login ~/.profile`　三个文件的其中之一

2. non-interactive + login

比如：`bash -l script.sh`，与第一种加载环境一样

3. interactive + non-login

比如：`bash`
对于ubuntu会去加载`/etc/bash.bashrc`和`~/.bashrc`文件
对于centos会去加载`~/.bashrc`文件

4. non-interactive + non-login

比如：`bash script.sh`和`ssh user@remote command`
由环境变量`BASH_ENV`变量指定的路径决定

图例：
![](./BashStartupFiles1.png)

***注意：ssh非交互非登录方式执行命令，其PATH变量会因登录用户而不同
如果是root，默认为PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
如果是普通用户，默认为PATH=/usr/local/bin:/usr/bin
－有些命令通过ssh的方式执行而报找不到的错误，很可能就是PATH变量的问题，例如sysctl就不在普通用户PATH变量下***

## 模式扩展
bash提供八种模式扩展（globbing）
1. 波浪线扩展  
~表示当前用户主目录
2. ? 字符扩展  
匹配单个字符
3. \* 字符扩展  
匹配任意字符，包括零个
```bash
# globstar，当该参数打开时，允许**匹配零个或多个子目录
$ shopt -s globstar
$ ls **/*.txt
a.txt  sub1/b.txt  sub1/sub2/c.txt
```
4. 方括号扩展
```
[aeiou]可以匹配五个元音字母中的任意
[a-z]：所有小写字母。
[a-zA-Z]：所有小写字母与大写字母。
[a-zA-Z0-9]：所有小写字母、大写字母与数字。
[abc]*：所有以a、b、c字符之一开头的文件名。
program.[co]：文件program.c与文件program.o。
BACKUP.[0-9][0-9][0-9]：所有以BACKUP.开头，后面是三个数字的文件名。
这种简写形式有一个否定形式[!start-end]，表示匹配不属于这个范围的字符。比如，[!a-zA-Z]表示匹配非英文字母的字符。
若中括号内的第一个字元为指数符号(^) ，那表示『反向选择』，例如[^abc] 代表一定有一个字元，只要是非a, b, c 的其他字元就接受的意思。
```
5. 大括号扩展  
大括号扩展{...}表示分别扩展成大括号里面的所有值，各个值之间使用逗号分隔，比如，{1,2,3}扩展成1 2 3
```bash
# 上面命令会新建36个子目录，每个子目录的名字都是”年份-月份
mkdir {2007..2009}-{01..12}

# 用于for循环
for i in {1..4}
do
  echo $i
done
```
6. 变量扩展  
${!S*}扩展成所有以S开头的变量名
7. 子命令扩展  
$(...)可以扩展成另一个命令的运行结果，该命令的所有输出都会作为返回值
8. 算术扩展  
$((...))可以扩展成整数运算的结果

## 字符处理

### cut
截取每行中想要的信息到std
```bash
# 将PATH 变数取出，我要找出第五个路径
echo ${PATH} | cut -d ':' -f 5
```

### tr
可以用来删除一段讯息当中的文字，或者是进行文字讯息的替换

### col
他可以用来简单的处理将[tab] 按键取代成为空白键

### join
主要是在处理『两个档案当中，有"相同资料"的那一行，才 将他加在一起』的意思

### paste
paste 就直接『将两行贴在一起，且中间以[tab] 键隔开』

### expand
这玩意儿就是在将[tab] 按键转成空白键

### 减号-用途
充当stdin或者stdout

### printf
格式化输出
```
[dmtsai@study ~]$ printf '列印格式' 实际内容
选项与参数：
关于格式方面的几个特殊样式：
       \a 警告声音输出
       \b 倒退键(backspace)
       \f 清除萤幕(form feed)
       \n 输出新的一行
       \r 亦即Enter 按键
       \t 水平的[tab] 按键
       \v 垂直的[tab] 按键
       \xNN NN 为两位数的数字，可以转换数字成为字元。
关于C 程式语言内，常见的变数格式
       %ns 那个n 是数字， s 代表string ，亦即多少个字元；
       %ni 那个n 是数字， i 代表integer ，亦即多少整数位数；
       %N.nf 那个n 与N 都是数字， f 代表floating (浮点)，如果有小数位数，
             假设我共要十个位数，但小数点有两位，即为%10.2f 啰！
```

### pr
自动加入页码

## 参数处理

### getopts
语法：getopts optstring name

通常与while循环一起使用，取出脚本所有的带有前置连词线（-）的参数，optstring是字符串，给出脚本所有连词线参数，参数后面有冒号表示该参数带有参数值，name是变量名，用来保存当前取到的参数。变量$OPTIND在getopts开始执行前是1，每次执行加1
示例：
```bash
while getopts 'lha:' OPTION; do
  case "$OPTION" in
    l)
      echo "linuxconfig"
      ;;

    h)
      echo "h stands for h"
      ;;

    a)
      avalue="$OPTARG"
      echo "The value provided is $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
# 将这些连词线参数移除，保证后面的代码可以用$1、$2等处理命令的主参数。
shift "$(($OPTIND - 1))"
```

## 配置项参数终止符--
-和--开头的参数，会被 Bash 当作配置项解释。但是，有时它们不是配置项，而是实体参数的一部分，比如文件名叫做-f或--file。这时就可以使用配置项参数终止符--，它的作用是告诉 Bash，在它后面的参数开头的-和--不是配置项，只能当作实体参数解释 cat -- -f
