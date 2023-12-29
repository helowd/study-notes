# 正则
正规表示法的字串表示方式依照不同的严谨度而分为： 基础正规表示法与延伸正规表示法。延伸型正规表示法除了简单的一组字串处理之外，还可以作群组的字串处理
1. if语句
```bash
string="Hello, World!"

if [[ "$string" =~ ^[A-Za-z] ]]; then
    echo "字符串以字母开头。"
else
    echo "字符串不以字母开头。"
fi
# 请注意，=~ 运算符用于表示匹配正则表达式。在条件判断中，使用[[ 和 ]] 而不是[ 和 ] 是为了支持正则表达式的匹配。
```
2. 为了避免语言环境不同导致bug，使用特殊符号匹配
```
[:alnum:]	代表英文大小写字元及数字，亦即0-9, AZ, az
[:alpha:]	代表任何英文大小写字元，亦即AZ, az
[:blank:]	代表空白键与[Tab] 按键两者
[:cntrl:]	代表键盘上面的控制按键，亦即包括CR, LF, Tab, Del.. 等等
[:digit:]	代表数字而已，亦即0-9
[:graph:]	除了空白字元(空白键与[Tab] 按键) 外的其他所有按键
[:lower:]	代表小写字元，亦即az
[:print:]	代表任何可以被列印出来的字元
[:punct:]	代表标点符号(punctuation symbol)，亦即：" ' ? ! ; : # $...
[:upper:]	代表大写字元，亦即AZ
[:space:]	任何会产生空白的字元，包括空白键, [Tab], CR 等等
[:xdigit:]	代表16 进位的数字类型，因此包括： 0-9, AF, af 的数字与字元
```
3. 基础正则bre
```
RE 字符	意义与范例
^word	意义：待搜寻的字串(word)在行首！
范例：搜寻行首为# 开始的那一行，并列出行号
grep -n '^#' regular_express.txt
word$	意义：待搜寻的字串(word)在行尾！
范例：将行尾为! 的那一行列印出来，并列出行号
grep -n '!$' regular_express.txt
.	意义：代表『一定有一个任意字元』的字符！
范例：搜寻的字串可以是(eve) (eae) (eee) (ee)， 但不能仅有(ee) ！亦即e 与e 中间『一定』仅有一个字元，而空白字元也是字元！
grep -n 'ee' regular_express.txt
\	意义：透过shell 的跳脱字符，将特殊符号的特殊意义去除！
范例：搜寻含有单引号' 的那一行！
grep -n \' regular_express.txt
*	意义：重复零个到无穷多个的前一个RE 字符
范例：找出含有(es) (ess) (esss) 等等的字串，注意，因为* 可以是0 个，所以es 也是符合带搜寻字串。另外，因为* 为重复『前一个RE 字符』的符号， 因此，在* 之前必须要紧接着一个RE 字符喔！例如任意字元则为『.*』 ！
grep -n 'ess*' regular_express.txt
[list]	意义：字元集合的RE 字符，里面列出想要撷取的字元！
范例：搜寻含有(gl) 或(gd) 的那一行，需要特别留意的是，在[] 当中『谨代表一个待搜寻的字元』， 例如『 a[afl]y 』代表搜寻的字串可以是aay, afy, aly 即[afl] 代表a 或f 或l 的意思！
grep -n 'g[ld]' regular_express.txt
[n1-n2]	意义：字元集合的RE 字符，里面列出想要撷取的字元范围！
范例：搜寻含有任意数字的那一行！需特别留意，在字元集合[] 中的减号- 是有特殊意义的，他代表两个字元之间的所有连续字元！但这个连续与否与ASCII 编码有关，因此，你的编码需要设定正确(在 bash 当中，需要确定LANG 与LANGUAGE 的变数是否正确！) 例如所有大写字元则为[AZ]
grep -n '[AZ]' regular_express.txt
[^list]	意义：字元集合的RE 字符，里面列出不要的字串或范围！
范例：搜寻的字串可以是(oog) (ood) 但不能是(oot) ，那个^ 在[] 内时，代表的意义是『反向选择』的意思。例如，我不要大写字元，则为[^AZ]。但是，需要特别注意的是，如果以grep -n [^AZ] regular_express.txt 来搜寻，却发现该档案内的所有行都被列出，为什么？因为这个[^AZ] 是『非大写字元』的意思， 因为每一行均有非大写字元，例如第一行的"Open Source" 就有p,e,n,o.... 等等的小写字
grep -n 'oo[^t]' regular_express.txt
\{n,m\}	意义：连续n 到m 个的『前一个RE 字符』
意义：若为\{n\} 则是连续n 个的前一个RE 字符，
意义：若是\{n,\} 则是连续n 个以上的前一个RE 字符！ 范例：在g 与g 之间有2 个到3 个的o 存在的字串，亦即(goog)(gooog)
grep -n 'go\{2,3\}g' regular_express.txt
```
4. 延伸正则ere
```
RE 字符	意义与范例
+	意义：重复『一个或一个以上』的前一个RE 字符
范例：搜寻(god) (good) (goood)... 等等的字串。那个o+ 代表『一个以上的o 』所以，底下的执行成果会将第1, 9, 13 行列出来。
egrep -n 'go+d' regular_express.txt
?	意义：『零个或一个』的前一个RE 字符
范例：搜寻(gd) (god) 这两个字串。那个o? 代表『空的或1 个o 』所以，上面的执行成果会将第13, 14 行列出来。有没有发现到，这两个案例( 'go+d' 与'go?d' )的结果集合与'go*d' 相同？想想看，这是为什么喔！^_^
egrep -n 'go?d' regular_express.txt
|	意义：用或( or )的方式找出数个字串
范例：搜寻gd 或good 这两个字串，注意，是『或』！所以，第1,9,14 这三行都可以被列印出来喔！那如果还想要找出dog 呢？
egrep -n 'gd|good' regular_express.txt
egrep -n 'gd|good|dog' regular_express.txt
()	意义：找出『群组』字串
范例：搜寻(glad) 或(good) 这两个字串，因为g 与d 是重复的，所以， 我就可以将la 与oo 列于( ) 当中，并以| 来分隔开来，就可以啦！
egrep -n 'g(la|oo)d' regular_express.txt
()+	意义：多个重复群组的判别
范例：将『AxyzxyzxyzxyzC』用echo 叫出，然后再使用如下的方法搜寻一下！
echo 'AxyzxyzxyzxyzC' | egrep 'A(xyz)+C'
上面的例子意思是说，我要找开头是A 结尾是C ，中间有一个以上的"xyz" 字串的意思～
```