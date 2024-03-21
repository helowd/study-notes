# restful api
一种api设计规范，用于web数据接口设计

## 目录
<!-- vim-markdown-toc GFM -->

* [url设计](#url设计)
* [状态码](#状态码)
* [服务器回应](#服务器回应)

<!-- vim-markdown-toc -->

## url设计
1. 结构  

客户端发出的操作指令都是 动词 + 宾词，例如 GET /articles  

常用http方法，对应CRUD
```
GET：读取（Read）
POST：新建（Create）
PUT：更新（Update）
PATCH：更新（Update），通常是部分更新
DELETE：删除（Delete）
``` 

2. 动词覆盖  
有些客户端只能使用GET和POST这两种方法。服务器必须接受POST模拟其他三个方法（PUT、PATCH、DELETE）。

这时，客户端发出的 HTTP 请求，要加上X-HTTP-Method-Override属性，告诉服务器应该使用哪一个动词，覆盖POST方法。
```
POST /api/Person/4 HTTP/1.1  
X-HTTP-Method-Override: PUT
```
上面代码中，X-HTTP-Method-Override指定本次请求的方法是PUT，而不是POST。

3. 用复数url  
GET /articles/2要好于GET /article/2

4. 避免多级url  
GET /authors/12/categories/2
这种 URL 不利于扩展，语义也不明确，往往要想一会，才能明白含义。

更好的做法是，除了第一级，其他级别都用查询字符串表达。

GET /authors/12?categories=2
下面是另一个例子，查询已发布的文章。你可能会设计成下面的 URL。

GET /articles/published
查询字符串的写法明显更好。

GET /articles?published=true

## 状态码
状态码必须精确，api不需要1xx状态码

1. 2xx  
200状态码表示操作成功，POST返回201状态码，表示生成了新的资源；DELETE返回204状态码，表示资源已经不存在，202 Accepted状态码表示服务器已经收到请求，但还未进行处理，会在未来再处理，通常用于异步操作

2. 3xx  
API 用不到301状态码（永久重定向）和302状态码（暂时重定向，307也是这个含义），因为它们可以由应用级别返回，浏览器会直接跳转，API 级别可以不考虑这两种情况

API 用到的3xx状态码，主要是303 See Other，表示参考另一个 URL

3. 4xx  
4xx状态码表示客户端错误，主要有下面几种。

400 Bad Request：服务器不理解客户端的请求，未做任何处理。

401 Unauthorized：用户未提供身份验证凭据，或者没有通过身份验证。

403 Forbidden：用户通过了身份验证，但是不具有访问资源所需的权限。

404 Not Found：所请求的资源不存在，或不可用。

405 Method Not Allowed：用户已经通过身份验证，但是所用的 HTTP 方法不在他的权限之内。

410 Gone：所请求的资源已从这个地址转移，不再可用。

415 Unsupported Media Type：客户端要求的返回格式不支持。比如，API 只能返回 JSON 格式，但是客户端要求返回 XML 格式。

422 Unprocessable Entity ：客户端上传的附件无法处理，导致请求失败。

429 Too Many Requests：客户端的请求次数超过限额。

4. 5xx  
5xx状态码表示服务端错误。一般来说，API 不会向用户透露服务器的详细信息，所以只要两个状态码就够了。

500 Internal Server Error：客户端请求有效，服务器处理时发生了意外。

503 Service Unavailable：服务器无法处理请求，一般用于网站维护状态。

## 服务器回应
1. 不要返回纯文本，而是一个json对象，服务器回应的http头的Content-Type属性要设为application/json；客户端请求的http头的Accept属性要设为application/json

2. 发生错误时不要返回200状态码，而是通过错误状态码来反应发生的错误，错误信息放在数据体里

3. 提供链接  
API 的使用者未必知道，URL 是怎么设计的。一个解决方法就是，在回应中，给出相关链接，便于下一步操作。这样的话，用户只要记住一个 URL，就可以发现其他的 URL。这种方法叫做 HATEOAS。

举例来说，GitHub 的 API 都在 api.github.com 这个域名。访问它，就可以得到其他 URL。
