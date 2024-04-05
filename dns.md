# dns

## 目录

<!-- vim-markdown-toc GFM -->

* [介绍](#介绍)
* [完整主机名称，Fully Qualified Domain Name（FQDN）](#完整主机名称fully-qualified-domain-namefqdn)
* [DNS架构](#dns架构)
    * [授权与分层负责](#授权与分层负责)
    * [通过DNS查询主机名称ip的流程](#通过dns查询主机名称ip的流程)
    * [分层的好处：](#分层的好处)
    * [dig +trance跟踪](#dig-trance跟踪)
    * [DNS使用的port number](#dns使用的port-number)
* [合法的DNS](#合法的dns)
    * [合法域名需要向上层领域注册取得合法的领域查询授权。注册需要花钱](#合法域名需要向上层领域注册取得合法的领域查询授权注册需要花钱)
    * [拥有领域查询权后，所有的主机名资讯都以自己为准，与上层无关](#拥有领域查询权后所有的主机名资讯都以自己为准与上层无关)
* [DNS服务器资料库的记录：正解，反解，zone的意义](#dns服务器资料库的记录正解反解zone的意义)
    * [正解](#正解)
    * [反解](#反解)
    * [每个DNS都需要的正解zone：hint](#每个dns都需要的正解zonehint)
* [DNS的master和slave架构](#dns的master和slave架构)
* [client端的设置](#client端的设置)
* [相关命令](#相关命令)
* [DNS报文](#dns报文)
    * [报文格式](#报文格式)
* [资源记录（resource record，RR）](#资源记录resource-recordrr)
* [在dns数据库中插入记录](#在dns数据库中插入记录)
* [关于dns安全](#关于dns安全)
* [DNS服务器设置](#dns服务器设置)

<!-- vim-markdown-toc -->

## 介绍
由于IP地址不方便人类记忆，所以发明了DNS（Domain Name System）帮我们将主机名称解析为IP好让大家只要知道主机名称就能使用访问服务器。

早期网络未流行且电脑数量不多的时候，/etc/hosts还是够用，自从90年代网络热门化之后，就不够用了。伯克利大学发明了一套阶层式管理主机名对应IP的系统，叫做Berkeley Internet Name Domain, BIND，这是目前世界上使用最广泛的DNS系统。

DNS利用类似树状目录架构，将主机名称的管理分配在不同层级的DNS服务器中，经过这种分层管理，每一个DNS服务器的记忆的数据就不会横夺，而且如果IP异动时也相当容易修改，只需要在自己的DNS服务器中就能修改全世界都可以查到的主机名称，而不用透过上层ISP的维护。

## 完整主机名称，Fully Qualified Domain Name（FQDN）
第一个与DNS有关的主机名称概念，这就是主机名称和领域名称（hostname and domain name）的观念，以及由这两者组成的完整主机名称FQDN的意义。即使你的主机名称相同，但只要不是在同一个领域内，那么就可以被分辨出不同的位置。

## DNS架构
![](./dns_dot.gif)  
在整个DNS系统的最上方一定是.这个DNS服务器（称为root域名服务器），最早以前它底下管理的只有com、edu、gov、mail、org、net这种特殊领域以及以国家分类的第二层的主机名称，这两者称为Top Level Domains（TLDs）顶级域名服务器

### 授权与分层负责
每个上一层的DNS服务器所记录的数据，其实只有其下一层的主机名称而已，至于再下一层，则直接授权给下层的某部主机来管理。这样的好处就是：每部机器管理的只有下一层的hostname对应的ip，所以减少了管理上困扰，而且下层client端如果有问题，只需要询问上一层DNS server即可，不需要跨域上层，排错上也会比较简单。

### 通过DNS查询主机名称ip的流程
![](./dns_search.gif)  
首先，当你在浏览器的网址输入`http://www.ksu.edu.tw`时，你的电脑就会依据相关设定（linux底下是利用/etc/resolv.conf这个文件）所提供的DNS的ip去进行连线查询了。以Hinet 168.95.1.1这个DNS为例：
```
1. 收到用户的查询要求，先查看本身有没有记录，如果没有则向.查询：
由于DNS 是阶层式的架构，每部主机都会管理自己辖下的主机名称解译而已。因为hinet 并没有管理台湾学术网路的权力， 因此就无法直接回报给用户端。此时168.95.1.1 就会向最顶层，也就是. (root) 的伺服器查询相关IP 资讯。

2. 向最顶层的.root查询：
168.95.1.1 会主动的向. 询问www.ksu.edu.tw 在哪里呢？但是由于. 只记录了.tw 的资讯(因为台湾只有.tw 向. 注册而已)，此时. 会告知『我是不知道这部主机的IP 啦，不过，你应该向.tw 去询问才对，我这里不管！我跟你说.tw 在哪里吧！ （如果本地dns服务器缓存了TLD服务器记录，就会跳过这一步直接向对应的TLD服务器进行请求）（返回NS记录和A记录，记录着.tw域名服务器的域名以及对应的ip地址）

3. 向第二层的.tw服务器查询：
168.95.1.1 接着又到.tw 去查询，而该部机器管理的又仅有.edu.tw, .com.tw, gov.tw... 那几部主机，经过比对后发现我们要的是.edu.tw 的网域，所以这个时候.tw 又告诉168.95.1.1 说：『你要去管理.edu.tw 这个网域的主机那里查询，我有他的IP ！ 』

4. 向第三层的.edu.tw服务器查询：
同理可证， .edu.tw 只会告诉168.95.1.1 ，应该要去.ksu.edu.tw 进行查询，这里只能告知.ksu.edu. tw 的IP 而已。

5. 向第四层的.ksu.edu.tw服务器查询：
等到168.95.1.1 找到.ksu.edu.tw 之后， Bingo ！ .ksu.edu.tw 说：『没错！这部主机名称是我管理的～ 我跟你说他的IP 是...所以此时168.95.1.1 就能够查到www.ksu.edu.tw 的IP 啰！

6. 记录到cache内存中并返回给用户浏览器：
查到了正确的IP 后，168.95.1.1 的DNS 机器总不会在下次有人查询www.ksu.edu.tw 的时候再跑一次这样的流程吧！粉远粉累的呐！而且也很耗系统的资源与网路的频宽，所以呢，168.95.1.1 这个DNS 会很聪明的先记录一份查询的结果在自己的暂存记忆体当中，以方便回应下一次的相同要求啊！最后则将结果回报给client 端！当然啦，那个记忆在cache 当中的资料，其实是有时间性的，当过了 DNS 设定记忆的时间(通常可能是24 小时)，那么该记录就会被释放喔！
```

### 分层的好处：
```
1. 主机名称修改的仅需自己的DNS 更动即可，不需通知其他人：

2. DNS 伺服器对主机名称解析结果的快取时间：
由于每次查询到的结果都会储存在DNS 伺服器的快取记忆体中，以方便若下次有相同需求的解析时，能够快速的回应。不过，查询结果已经被快取了，但是原始DNS 的主机名称与IP 对应却修改了，此时若有人再次查询， 系统可能会回报旧的IP 喔！所以，在快取内的答案是有时间性的！通常是数十分钟到三天之内。这也是为什么我们常说当你修改了一个domain name 之后，可能要2 ~ 3 天后才能全面的启用的缘故啦！

3. 可持续向下授权(子领域名称授权)：
每一部可以记录主机名称与IP 对应的DNS 伺服器都可以随意更动他自己的资料库对应， 因此主机名称与网域名称在各个主机底下都不相同。举例来说， idv.tw 是仅有台湾才有这个idv 的网域～ 因为这个idv 是由.tw 所管理的，所以只要台湾.tw 维护小组同意，就能够建立该网域喔！
```

### dig +trance跟踪
```
[root@www ~]# dig +trace www.ksu.edu.tw
; <<>> DiG 9.3.6-P1-RedHat-9.3.6-16.P1.el5 <<>>+trace www.ksu.edu.tw
;; global options: printcmd
. 486278 IN NS a.root-servers.net.
. 486278 IN NS b.root-servers.net.
....(底下省略)....
# 上面的部分在追踪. 的伺服器，可从a ~ m.root-servers.net.
;; Received 500 bytes from 168.95.1.1#53(168.95.1.1) in 22 ms

tw. 172800 IN NS ns.twnic.net.
tw. 172800 IN NS a.dns.tw.
tw. 172800 IN NS b.dns.tw.
....(底下省略)....
# 上面的部分在追踪.tw. 的伺服器，可从a ~ h.dns.tw. 包括ns.twnic.net.
;; Received 474 bytes from 192.33.4.12#53(c.root-servers.net) in 168 ms

edu.tw. 86400 IN NS a.twnic.net.tw.
edu.tw. 86400 IN NS b.twnic.net.tw.
# 追踪.edu.tw. 的则有7 部伺服器
;; Received 395 bytes from 192.83.166.11#53(ns.twnic.net) in 22 ms

ksu.edu.tw. 86400 IN NS dns2.ksu.edu.tw.
ksu.edu.tw. 86400 IN NS dns3.twaren.net.
ksu.edu.tw. 86400 IN NS dns1.ksu.edu.tw.
;; Received 131 bytes from 192.83.166.9#53(a.twnic.net.tw) in 22 ms

www.ksu.edu.tw. 3600 IN A 120.114.100.101
ksu.edu.tw. 3600 IN NS dns2.ksu.edu.tw.
ksu.edu.tw. 3600 IN NS dns1.ksu.edu.tw.
ksu.edu.tw. 3600 IN NS dns3.twaren.net.
;; Received 147 bytes from 120.114.150.1#53(dns2.ksu.edu.tw) in 14 ms
```

### DNS使用的port number
dns监听53端口，通常DNS 查询的时候，是以udp 这个较快速的资料传输协定来查询的， 但是万一没有办法查询到完整的资讯时，就会再次的以tcp 这个协定来重新查询的！所以启动DNS 的daemon (就是named 啦) 时，会同时启动tcp 及udp 的port 53 喔！所以，记得防火墙也要同时放行tcp, udp port 53呢！

## 合法的DNS

### 合法域名需要向上层领域注册取得合法的领域查询授权。注册需要花钱

领域查询权：我们的.ksu.edu.tw必须要向.edu.tw那部主机注册申请领域授权，因此，未来有任何.ksu.edu.tw的要求时，.edu.tw都会说我不知道，详情去找.ksu.edu.tw吧，此时我们要假设DNS服务器来设定.ksu.edu.tw相关的主机名称对应才行。

让我们归纳一下，要让你的主机名称对应IP 且让其他电脑都可以查询的到，你有两种方式：

上层DNS 授权领域查询权，让你自己设定DNS 伺服器，或者是；

直接请上层DNS 伺服器来帮你设定主机名称对应！

### 拥有领域查询权后，所有的主机名资讯都以自己为准，与上层无关
DNS系统记录的数据非常多，不过重点其实有两个，一个是记录服务器所在NS（nameserver）标志，另一个记录主机名对应的A（Address）标志，我们在网络上面查询到的最终结果，都是查询IP的，因此最终的标志要找的是A这个记录才对。

## DNS服务器资料库的记录：正解，反解，zone的意义
从前面的查询流程中可以看出，最重要的就是.ksu.edu.tw那部DNS服务器内的记录资料。这些记录我们可以统称为资料库，而在资料库里面针对每个要解析的领域（domain），就称为一个区域（zone）
```
从主机名称查询到IP 的流程称为：正解
从IP 反解析到主机名称的流程称为：反解
不管是正解还是反解，每个领域的记录就是一个区域(zone)
```

### 正解
正解zone通常由底下几种标志：
```
SOA：就是开始验证(Start of Authority) 的缩写，相关资料本章后续小节说明；
NS：就是名称伺服器(NameServer) 的缩写，后面记录的资料是DNS 伺服器的意思；
A：就是位址(Address) 的缩写，后面记录的是IP 的对应(最重要)；
```

### 反解
```
除了伺服器必备的NS 以及SOA 之外，最重要的就是：

PTR：就是指向(PoinTeR) 的缩写，后面记录的资料就是反解到主机名称啰！
```

### 每个DNS都需要的正解zone：hint
从DNS查询流程可以知道，当DNS服务器在自己的资料库里找不到所需的记录时，一定会去root去找，所以每个DNS服务器都会有root的zone，被称为hint类型。
```
hint (root)：记录. 的zone；
vbird.org：记录.vbird.org 这个正解的zone。
```

## DNS的master和slave架构
目的是实现DNS服务高可用，所以也要求master和slave的内容都是同步的，完全一致

master/slave的查询优先权问题？ 域名查询是哪台DNS服务器先返回结果就用哪台的结果

master/slave资料同步的过程：
```
slave是需要更新来自master的资料，所以在slave设定之初就需要存在master。基本上，不论是master还是slave的资料库，都会有一个代表该资料库新旧的序号，这个序号值的大小，是会影响是否需要更新的动作。更新的方式主要有两种：

master主动告知：例如在Master 在修改了资料库内容，并且加大资料库序号后， 重新启动DNS 服务，那master 会主动告知slave 来更新资料库，此时就能够达成资料同步；

由slave主动提出要求：基本上， Slave 会定时的向Master 察看资料库的序号， 当发现Master 资料库的序号比Slave 自己的序号还要大(代表比较新)，那么Slave 就会开始更新。如果序号不变， 那么就判断资料库没有更动，因此不会进行同步更新。

记录更新的频率与SOA的标志有关。
```

## client端的设置
查询DNS方式的优先级：
```
/etc/hosts ：这个是最早的hostname 对应IP 的档案；
/etc/resolv.conf ：这个重要！就是ISP 的DNS 伺服器IP 记录处；
/etc/nsswitch.conf：这个档案则是在『决定』先要使用/etc/hosts 还是/etc/resolv.conf 的设定！
```
一般而言Linux都以/etc/hosts为优先，/etc/nsswitch.conf文件记录了`hosts: files dns`，files就表示/etc/hosts，而dns则使用/etc/resolv.conf的DNS服务器来进行查找。

注意：
```
尽量不要设定超过3 部以上的DNS IP 在/etc/resolv.conf 中，因为如果是你的区网出问题，导致无法连线到DNS 伺服器，那么你的主机还是会向每部DNS 伺服器发出连线要求，每次连线都有timeout 时间的等待，会导致浪费非常多的时间喔！
```

## 相关命令
host  可以查到某个领域服务器所管理的所有主机名称对应的资料
```
host [-a] FQDN [server] 
host -l domain [server]
```

nslookup  提供交互式的dns查询
```
nslookup [FQDN] [server]
```

dig  详细专业的dns追踪信息（主流）
```
dig [options] FQDN [@server]
```

whois  查询某个DNS领域是谁负责管理的
```
whois [domainname]

[root@www ~]# whois centos.org
[Querying whois.publicinterestregistry.net]
[whois.publicinterestregistry.net]
# 这中间是一堆whois 伺服器提供的讯息告知！底下是实际注册的资料
Domain ID:D103409469-LROR
Domain Name:CENTOS.ORG
Created On:04-Dec-2003 12:28:30 UTC
Last Updated On:05-Dec-2010 01:23:25 UTC
Expiration Date:04-Dec-2011 12:28:30 UTC   <==记载了建立与与失效的日期
Sponsoring Registrar:Key-Systems GmbH (R51-LROR)
Status:CLIENT TRANSFER PROHIBITED
Registrant ID:P-8686062
Registrant Name:CentOS Domain Administrator
Registrant Organization:The CentOS Project
Registrant Street1:Mechelsesteenweg 170
# 底下则是一堆联络方式，鸟哥将它取消了，免得多占篇幅～
```

## DNS报文
dns只有查询和回答报文，查询和回答报文有着相同的格式

### 报文格式
![](./dns_message_format.png)  
1. 前12个字节是首部区域，其中有几个字段。第一个字符（标识符）是一个16比特的数，用于标识该查询。这个标识符会被复制到对查询的回答报文中，以便让客户用它来匹配发送的请求和接收到的回答。标志字段中含有若干标志，1比特的“查询/回答”标志位指出报文时查询报文（0）还是回答报文（1）。当某dns服务器时所请求名字的权威dns服务器时，1比特的“权威的”标志位被置在回答报文中。如果客户（主机或dns服务器）在该dns服务器没有某记录时希望它执行递归查询，将设置1比特的“希望递归”标志位。如果该dns服务器支持递归查询，在它的回答报文中会对1比特的“递归可用”标志位置位。在该首部中，还有四个有关数量的字段，这些字段指出了在首部后的4类数据区域出现的数量。

2. 问题区域包含着正在进行的查询信息。该区域包括：1.名字字段，指出正在被查询的主机名字；2.类型字段，它指出有关该名字的正被查询的问题类型，例如主机地址是与一个名字相关联（类型A）还是与某个名字的邮件服务器向关联（类型MX）

3. 在来自dns服务器的回答中，回答区域包含了对最初请求的名字的资源记录。前面讲过每个资源记录中有type（如A、NS、CNAME和MX）字段、value字段和TTL字段。在回答报文的回答区域中可以包含多条RR，因此一个主机名能够有多个ip地址

4. 权威区域包含了其它权威服务器的记录。

5. 附加区域包含了其它有帮助的记录。例如，对于一个MX请求的回答报文的回答区域包含了一条资源记录，该记录提供了邮件服务器的规范主机名。该附加区域包含一个类型A记录，该记录提供了用于该邮件服务器的规范主机名的IP地址。

## 资源记录（resource record，RR）
RR是一个包括了下列字段的4元组：（name，value，type，ttl）

ttl是该记录的生存时间，它决定了资源记录应当从缓存中删除的时间

如果一台dns服务器是用于某特定主机名的权威dns服务器，那么该dns服务器会有一条包含该主机名的类型A记录，如果服务器不是用于某主机名的权威服务器，那么该服务器将包含一条类型NS记录，该记录对应于包含主机名的域；它还将包括一条类型A记录，该记录提供了在NS记录的value字段中的dns服务器的ip地址。 

举例来说：假设一台edu TLD服务器不是主机gaia.cs.umass.edu的权威dns服务器，则该服务器将包含一条包括主机cs.umass.edu的域记录，如（umass.edu, dns.umass.edu, NS）；该edu TLD服务器还将包含一条类型A记录，如（dns.umass.edu, 128.119.40.111, A），该记录将名字dns.umass.edu映射为一个ip地址。

## 在dns数据库中插入记录
假定你刚刚创建了一个称为网络乌托邦（network utopia）的公司，首先在注册登记机构注册域名networkutopia.com。注册登记机构（registrar）是一个商业实体，它验证该域名的唯一性，将该域名输入dns数据库，对提供的服务器收取少量费用。1999年前，唯一的注册登记机构是network solution，它独家经营对于com、net、org域名的注册。但是现在有许多注册登记机构竞争客户，因特网名字和地址分配机构（internet corporation for assiged names and numbers，ICANN）向各种注册登记机构授权。在www.internic.net上可以找到授权的注册登记机构的列表。

当你向某些注册登记机构注册域名networkutopia.com时，需要向该机构提供你的基本和辅助权威dns服务器的名字和ip地址。假定该名字和ip地址是dns1.networkutopia.com和dns2.networkutopia.com及212.212.212.1和212.212.212.2，对这两个权威dns服务器的每一个，该注册登记机构确保将一个类型NS和一个类型A的记录输入TLD com服务器。（networkutopia.com,  dns1.networkutopia.com, NS） (dns1,networkutopia.com, 212.212.212.1, A)

你还必须确保用于web服务器www.networkutopia.com的类型A资源记录和用于邮件服务器mail.networkutopia.com的类型MX资源记录被输入你的权威dns服务器中。

一旦完成所有这些步骤，人们将能够访问你的web站点，并向你公司的雇员发送电子邮件。

## 关于dns安全
我们已经看到DNS是因特网基础设施的一个至关重要的组件，对于包括Web，电子邮件等的许多重要的服务，没有它都不能正常工作。因此，我们自然要问，DNS能够被怎样攻击呢?DNS是一个易受攻击的目标吗?它是将会被淘汰的服务吗?大多数因特网应用会随同它一起无法工作吗?

1. 对根服务器ddos攻击：想到的第一种针对DNS服务的攻击是分布式拒绝服务（DDoS）带宽洪泛攻击（参见1.6节)。例如，某攻击者能够试图向每个DNS根服务器发送大量的分组，使得大多数合法DNS请求得不到回答。这种对DNS根服务器的DDoS大规模攻击实际发生在2002年10月21日。在这次攻击中，该攻击者利用了一个僵尸网络向13个 DNS根服务器中的每个都发送了大批的ICMP ping报文。(第4章中讨论了ICMP报文。此时，知道ICMP分组是特殊类型的P数据报就可以了。)幸运的是，这种大规模攻击所带来的损害很小，对用户的因特网体验几乎没有或根本没有影响。攻击者的确成功地将大量的分组指向了根服务器，但许多DNS根服务器受到了分组过滤器的保护，配置的分组过滤器阻挡了所有指向根服务器的ICMP ping,报文。这些被保护的服务器因此未受伤害并且与平常一样发挥着作用。此外，大多数本地DNS服务器缓存了顶级域名服务器的IP地址,使得这些请求过程通常绕过了DNS根服务器。

2. 对顶级域服务器ddos攻击：对 DNS的潜在更为有效的DDoS攻击将是向顶级域名服务器（例如向所有处理.com域的顶级域名服务器）发送大量的 DNS请求。过滤指向 DNS服务器的 DNS请求将更为困难，并且顶级域名服务器不像根服务器那样容易绕过。但是这种攻击的严重性通过本地DNS服务器中的缓存技术可将部分地被缓解。

3. DNS劫持：DNS能够潜在地以其他方式被攻击。在中间人攻击中，攻击者截获来自主机的请求并返回伪造的回答。在DNS毒害攻击中，攻击者向一台DNS服务器发送伪造的回答,诱使服务器在它的缓存中接收伪造的记录。这些攻击中的任一种，都能够将满怀信任的Web用户重定向到攻击者的Web站点。然而，这些攻击难以实现，因为它们要求截获分组或扼制住服务器[Skoudis 2006]。

4. 对权威服务器ddos攻击：另一种重要的DNS攻击本质上并不是一种对 DNS服务的攻击，而是充分利用DNS基础设施来对目标主机发起DDoS攻击(例如，你所在大学的邮件服务器)。在这种攻击中，攻击者向许多权威 DNS服务器发送 DNS请求，每个请求具有目标主机的假冒源地址。这些DNS 服务器则直接向目标主机发送它们的回答。如果这些请求能够精心制作成下述方式的话，即响应比请求（字节数)大得多(所谓放大)，则攻击者不必自行产生大量的流量就有可能淹没目标主机。这种利用DNS的反射攻击至今为止只取得了有限的成功[Mirkovic 2005]。

总而言之，DNS自身已经显示了对抗攻击的令人惊讶的健壮性。至今为止，还没有一个攻击已经成功地妨碍了DNS服务。已经有了成功的反射攻击;然而，通过适当地配置 DNS服务器,能够处理(和正在处理)这些攻击。

## DNS服务器设置
