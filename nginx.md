# nginx

## 目录
<!-- vim-markdown-toc GFM -->

* [网站服务介绍](#网站服务介绍)
    * [发展历史](#发展历史)
    * [网站服务器目录资源](#网站服务器目录资源)
    * [仅提供使用者浏览的单向静态网页](#仅提供使用者浏览的单向静态网页)
    * [提供使用者互动介面的动态网站](#提供使用者互动介面的动态网站)
    * [LAMP](#lamp)
    * [LAMP所需的软件和其结构](#lamp所需的软件和其结构)
        * [Apache文件结构](#apache文件结构)
        * [MySQL文件结构](#mysql文件结构)
        * [PHP文件结构](#php文件结构)

<!-- vim-markdown-toc -->

## 网站服务介绍
web架构包括提供资料的网站服务器和负责解析资料的浏览器，网站服务器主要的资料是HTML、多媒体（图片、影视、声音、文字等）

### 发展历史
伯纳斯-李(Tim Berners-Lee) 在1980 年代为了更有效率的让欧洲核子物理实验室的科学家可以分享及更新他们的研究成果， 于是他发展出一个超文件传输协定(Hyper Text Transport Protocol , HTTP)。如同前面提到的，在这个协定上面的伺服器需要软体，而用户端则需要浏览器来解析伺服器所提供的资料。那么这些软体怎么来的？

为了让HTTP 这个协定得以顺利的应用，大约在90 年代初期由伊利诺大学的国家超级电脑应用中心 (NCSA, http://www.ncsa.illinois.edu/ ) 开发出伺服器HTTPd (HTTP daemon 之意)。 HTTPd 为自由软体，所以很快的领导了WWW 伺服器市场。后来网景通讯(Netscape) 开发出更强大的伺服器与相对应的用户端浏览器，那就是大家曾经熟悉的Netscape 这套软体啦。这套软体分为伺服器与浏览器，其中浏览器相对便宜，不过伺服器可就贵的吓人了。所以，在伺服器市场上主要还是以HTTPd 为主的。

后来由于HTTPd 这个伺服器一直没有妥善的发展，于是一群社群朋友便发起一个计画，这个计画主要在改善原本的HTTPd 伺服器软体，他们称这个改良过的软体为Apache，取其『一个修修改改的伺服器(A patch server)』的双关语！ 这个Apache 在1996 年以后便成为WWW 伺服器上市占率最高的软体了 ( http://httpd.apache.org/ )。

### 网站服务器目录资源
举例来说，鸟哥的网站www 资料放置在我主机的/var/www/html/ 当中，所以说：
```
http://linux.vbird.org --> /var/www/html/
http://linux.vbird.org/linux_basic/index.php --> /var/www/html/linux_basic/index.php
```
另外，通常首页目录底下会有个特殊的档案名称，例如index.html 或index.??? 等。举例来说，如果你直接按下： http://linux.vbird.org 会发现其实与http://linux.vbird.org/index.php 是一样的！这是因为WWW 伺服器会主动的以该目录下的『首页』来显示啦！

所以啦，我们的伺服器会由于浏览器传来的要求协定不同而给予不一样的回应资料。

### 仅提供使用者浏览的单向静态网页
这种类型的网站大多是提供『单向静态』的网页，或许有提供一些动画图示，但基本上就仅止于此啦！因为单纯是由伺服器单向提供资料给客户端，Server 不需要与Client 端有互动，所以你可以到该网站上去浏览， 但是无法进行进行资料的上传喔！目前主要的免费虚拟主机大多是这种类型。所以，你只要依照HTML 的语法写好你的网页，并且上传到该网站空间上，那么你的资料就可以让大家浏览了！

### 提供使用者互动介面的动态网站
这种类型的网站可以让伺服器与使用者互动，常见的例如讨论区论坛与留言版，包括一些部落格也都是属于这类型。这类型的网站需要的技术程度比较高，因为他是藉由『网页程式语言』来达成与使用者互动的行为， 常见的例如PHP 网页程式语言，配合MySQL 资料库系统来进行资料的读、写。整个互动可以使用下图来说明：  
![](./server_client_2.gif)  
这就是所谓的伺服器端工作任务介面(Server Side Include, SSI)，因为不论你要求的资料是什么，其实都是透过伺服器端同一支网页程式在负责将资料读出或写入资料库，处理完毕后将结果传给用户端的一种方式，变动的是资料库内的资料，网页程式其实并没有任何改变的。这部份的网页程式包括 PHP, ASP, Perl...很多啦！

另外一种互动式的动态网页主要是在用户端达成的！举例来说，我们可以透过利用所谓的Java scripts 这种语法， 将可执行的程式码(java script) 传送给用户端，用户端的浏览器如果有提供java script 的功能， 那么该程式就可以在用户端的电脑上面运作了。由于程式是在用户端电脑上执行， 因此如果伺服器端所制作的程式是恶意的，那么用户端的电脑就可能会遭到破坏。这也是为啥很多浏览器都已经将一些危险的java script 关闭的原因。

### LAMP
组成：Linux、Apache、PHP、Mysql

Apache：托管文件的服务，负责处理请求并把文件传给用户端，PHP在这上面运行，APache仅能提供最基本的静态网站资料，想要达成动态网站的话需要PHP和MySQL的支持。  
  
PHP：用来建立动态网页，PHP可以直接在HTML网页中嵌入，一种编程语言，开源、跨平台、易学习、性能高，与会与数据库交互

MySQL：数据存储

浏览器仅能解析简单的HTML语言，无法直接解析PHP语言

### LAMP所需的软件和其结构
PHP 是挂在Apache 底下执行的一个模组， 而我们要用网页的PHP 程式控制MySQL 时，你的PHP 就得要支援MySQL 的模组才行
```
httpd (提供Apache 主程式)
mysql (MySQL 客户端程式)
mysql-server (MySQL 伺服器程式)
php (PHP 主程式含给apache 使用的模组)
php-devel (PHP 的发展工具，这个与PHP 外挂的加速软体有关)
php-mysql (提供给PHP 程式读取MySQL 资料库的模组)
```
yum install httpd mysql mysql-server php php-mysql

#### Apache文件结构
```
/etc/httpd/conf/httpd.conf (主要设定档)
httpd 最主要的设定档，其实整个Apache 也不过就是这个设定档啦！里面真是包山包海啊！不过很多其他的distribution 都将这个档案拆成数个小档案分别管理不同的参数。但是主要设定档还是以这个档名为主的！你只要找到这个档名就知道如何设定啦！

/etc/httpd/conf.d/*.conf (很多的额外参数档，副档名是.conf)
如果你不想要修改原始设定档httpd.conf 的话，那么可以将你自己的额外参数档独立出来， 例如你想要有自己的额外设定值，可以将他写入/etc/httpd/conf.d/vbird.conf (注意，副档名一定是 .conf 才行) 而启动Apache 时，这个档案就会被读入主要设定档当中了！这有什么好处？好处就是当你系统升级的时候， 你几乎不需要更动原本的设定档，只要将你自己的额外参数档复制到正确的地点即可！维护更方便啦！

/usr/lib64/httpd/modules/, /etc/httpd/modules/
Apache 支援很多的外挂模组，例如php 以及ssl 都是apache 外挂的一种喔！所有你想要使用的模组档案预设是放置在这个目录当中的！

/var/www/html/
这就是我们CentOS 预设的apache 『首页』所在目录啦！当你输入『http://localhost』时所显示的资料， 就是放在这个目录当中的首页档(预设为index.html)。

/var/www/error/
如果因为伺服器设定错误，或者是浏览器端要求的资料错误时，在浏览器上出现的错误讯息就以这个目录的预设讯息为主！

/var/www/icons/
这个目录提供Apache 预设给予的一些小图示，你可以随意使用啊！当你输入『http://localhost/icons/』 时所显示的资料所在。

/var/www/cgi-bin/
预设给一些可执行的CGI (网页程式) 程式放置的目录；当你输入『http://localhost/cgi-bin/』 时所显示的资料所在。

/var/log/httpd/
预设的Apache 登录档都放在这里，对于流量比较大的网站来说，这个目录要很小心， 因为以鸟哥网站的流量来说，一个星期的登录档资料可以大到700MBytes 至1GBytes左右，所以你务必要修改一下你的logrotate 让登录档被压缩，否则...

/usr/sbin/apachectl
这个就是Apache 的主要执行档，这个执行档其实是 shell script而已， 他可以主动的侦测系统上面的一些设定值，好让你启动Apache 时更简单！

/usr/sbin/httpd
呵呵！这个才是主要的Apache 二进位执行档啦！

/usr/bin/htpasswd (Apache 密码保护)
在某些网页当你想要登入时你需要输入帐号与密码对吧！那Apache 本身就提供一个最基本的密码保护方式， 该密码的产生就是透过这个指令来达成的！相关的设定方式我们会在WWW 进阶设定当中说明的。
```

#### MySQL文件结构
```
/etc/my.cnf
这个是MySQL 的设定档，包括你想要进行MySQL 资料库的最佳化，或者是针对MySQL 进行一些额外的参数指定， 都可以在这个档案里面达成的！

/var/lib/mysql/
这个目录则是MySQL 资料库档案放置的所在处啦！当你有启动任何MySQL 的服务时， 请务必记得在备份时，这个目录也要完整的备份下来才行啊！
```

#### PHP文件结构
```
/etc/httpd/conf.d/php.conf
那你要不要手动将该模组写入httpd.conf 当中？不需要的，因为系统主动将PHP 设定参数写入这个档案中了！而这个档案会在Apache 重新启动时被读入，所以OK 的啦！

/etc/php.ini
就是PHP 的主要设定档，包括你的PHP 能不能允许使用者上传档案？能不能允许某些低安全性的标志等等， 都在这个设定档当中设定的啦！

/usr/lib64/httpd/modules/libphp5.so
PHP 这个软体提供给Apache 使用的模组！这也是我们能否在Apache 网页上面设计PHP 程式语言的最重要的咚咚！务必要存在才行！

/etc/php.d/mysql.ini, /usr/lib64/php/modules/mysql.so
你的PHP 是否可以支援MySQL 介面呢？就看这两个东西啦！这两个咚咚是由php-mysql 软体提供的呢！

/usr/bin/phpize, /usr/include/php/
如果你未来想要安装类似PHP 加速器以让浏览速度加快的话，那么这个档案与目录就得要存在， 否则加速器软体可无法编译成功喔！这两个资料也是php-devel 软体所提供的啦！
```
