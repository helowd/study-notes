# yaml语法

## 目录
<!-- vim-markdown-toc GFM -->

* [基本规则](#基本规则)
* [对象](#对象)
* [数组](#数组)
* [复合结构](#复合结构)
* [纯量](#纯量)
* [引用](#引用)
* [参考链接](#参考链接)

<!-- vim-markdown-toc -->

## 基本规则
1. 大小写敏感
2. 使用缩进表示层级关系
3. 缩进时不允许使用Tab键，只允许使用空格。
4. 缩进的空格数目不重要，只要相同层级的元素左侧对齐即可
5. \#表示注释
6. 支持三种数据结构:
   * 对象：键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
   * 数组：一组按次序排列的值，又称为序列（sequence） / 列表（list）
   * 纯量（scalars）：单个的、不可再分的值

## 对象
```yaml
animal: pets

# 或行内表示方法：
hash: { name: Steve, foo: bar } 
```

## 数组
```yaml
- Cat
- Dog
- Goldfish

# 或行内表示
animal: [Cat, Dog]
```

## 复合结构
```yaml
# 对象和数组的复合结构
languages:
 - Ruby
 - Perl
 - Python 
websites:
 YAML: yaml.org 
 Ruby: ruby-lang.org 
 Python: python.org 
 Perl: use.perl.org
```

## 纯量
字符串、布尔值、整数、浮点数、Null、时间、日期
```yaml
# 数值以字面量
number: 12.30

# 布尔用true和false表示
isSet: true

# null用~表示
parent: ~

# 时间采用 ISO8601 格式
iso8601: 2001-12-14t21:59:43.10-05:00 
#日期采用复合 iso8601 格式的年、月、日表示。
date: 1976-07-31

# 两个感叹号表示强制转换数据类型
e: !!str 123
f: !!str true

# 字符串
# 字符串默认不使用引号表示
str: 这是一行字符串
# 如果字符串之中包含空格或特殊字符，需要放在引号之中
str: '内容： 字符串'
# 单引号和双引号都可以使用，双引号不会对特殊字符转义
s1: '内容\n字符串'
s2: "内容\n字符串"

# 多行字符串
# 多行字符串可以使用|保留换行符，也可以使用>折叠换行
# +表示保留文字块末尾的换行，-表示删除字符串末尾的换行
this: |
  Foo
  Bar
that: >
  Foo
  Bar
# 字符串之中可以插入 HTML 标记
message: |

  <p style="color: red">
    段落
  </p>
```

## 引用
```yaml
# 锚点&和别名*，可以用来引用。
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  <<: *defaults

test:
  database: myapp_test
  <<: *defaults

# 等同于下面的代码
defaults:
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  adapter:  postgres
  host:     localhost

test:
  database: myapp_test
  adapter:  postgres
  host:     localhost
# &用来建立锚点（defaults），<<表示合并到当前数据，*用来引用锚点。
```

## 参考链接
<https://www.ruanyifeng.com/blog/2016/07/yaml.html>
