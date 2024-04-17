# kubernetes
文档内容基于v1.17.04版本

## 目录
<!-- vim-markdown-toc GFM -->

* [容器发展历史](#容器发展历史)
* [容器与虚拟机比较](#容器与虚拟机比较)
* [pod](#pod)
    * [static pod](#static-pod)
    * [downward api: 让 Pod 里的容器能够直接获取到这个 Pod API 对象本身的信息](#downward-api-让-pod-里的容器能够直接获取到这个-pod-api-对象本身的信息)
    * [probe](#probe)
* [证书](#证书)
    * [常见证书](#常见证书)
    * [手动生成证书](#手动生成证书)
    * [证书管理kubeadm](#证书管理kubeadm)
    * [手动更换ca证书（todo）](#手动更换ca证书todo)
    * [证书api（todo）](#证书apitodo)
    * [启用已签名的 kubelet 服务证书（todo）](#启用已签名的-kubelet-服务证书todo)
* [cert-manager](#cert-manager)
* [kraken](#kraken)
* [nfs-provisioner](#nfs-provisioner)
* [node-local-dns](#node-local-dns)
* [控制器](#控制器)
    * [statefulset](#statefulset)
    * [离线业务job与cronjob](#离线业务job与cronjob)
* [Istio](#istio)
* [api](#api)
* [crd](#crd)
* [operator](#operator)
* [rbac](#rbac)
* [持久化](#持久化)
    * [持久化过程](#持久化过程)
    * [StorageClass](#storageclass)
    * [本地持久化](#本地持久化)
* [cni](#cni)
    * [cni原理](#cni原理)
* [flannel](#flannel)
    * [udp模式](#udp模式)
        * [udp模式下ip包用户态与内核态之间的数据拷贝](#udp模式下ip包用户态与内核态之间的数据拷贝)
    * [vxlan模式](#vxlan模式)
    * [host-gw模式](#host-gw模式)
* [calico](#calico)
    * [calico的架构](#calico的架构)
    * [calico模式](#calico模式)
    * [calico ipip模式](#calico-ipip模式)
* [k8s中的dns](#k8s中的dns)
* [service](#service)
    * [实现原理（cluster）](#实现原理cluster)
        * [k8s中的informer](#k8s中的informer)
    * [ipvs模式工作原理](#ipvs模式工作原理)
    * [nodeport类型实现原理](#nodeport类型实现原理)
    * [service相关排错思路](#service相关排错思路)
* [ingress](#ingress)
* [集群内核调优参考](#集群内核调优参考)
* [k8s集群所支持的规格](#k8s集群所支持的规格)
* [高可用集群部署流程（kubeadm）](#高可用集群部署流程kubeadm)
    * [1. 准备机器配置](#1-准备机器配置)
    * [2. 安装容器运行时](#2-安装容器运行时)
    * [3. 安装容器运行时接口](#3-安装容器运行时接口)
    * [4. 安装kubeadm、kubelet、kubectl](#4-安装kubeadmkubeletkubectl)
    * [5. 初始化master节点](#5-初始化master节点)
    * [6. 配置kubeconfig文件](#6-配置kubeconfig文件)
    * [7. 安装网络插件flannel，使各节点各pod能相互通信](#7-安装网络插件flannel使各节点各pod能相互通信)
    * [注意事项：](#注意事项)
* [debug](#debug)
    * [k8s master机器重启后，coredns两个pod就绪探针失败](#k8s-master机器重启后coredns两个pod就绪探针失败)
        * [现象：](#现象)
        * [原因](#原因)
        * [解决](#解决)
* [参考资料](#参考资料)

<!-- vim-markdown-toc -->

## 容器发展历史
一开始是Cloud Foundry利用Cgroups和Namespace机制隔离各个应用的环境，但由于环境的打包过程不如docker镜像方便进而被docker取代，而由于大规模部署应用的需求出现了swarm这类容器集群管理项目，compose项目的推出也为容器编排提供了有力帮助，这些使得docker在当时站住了主流。而后不满docker一家独大的现状，谷歌、red hat等开源领域玩家牵头建立了CNCF，并以kubernetes项目为核心来对抗docker。由于kubernetes生态迅速崛起，docker将容器运行时containerd捐赠给CNCF，从此也标志着以kubernetes为核心容器技术发展

## 容器与虚拟机比较
容器利用linux的cgroups（资源限制）和namespace（资源隔离）技术实现，实际上是宿主机上的一个特殊的进程，共享内核。而虚拟机利用额外的工具如hypervisor等技术实现对宿主机资源的隔离，相比容器隔离更加的彻底

容器镜像：rootfs

## pod

### static pod
在 Kubernetes 中，Static Pod（静态 Pod）是一种特殊类型的 Pod，与普通的 Pod 相比有一些不同之处。

普通的 Pod 是由 Kubernetes API Server 管理的，它们的定义通常存储在 etcd 中，并由 kubelet 运行在集群中的节点上。而 Static Pod 是直接由 kubelet 管理的，它的定义文件通常存储在节点上的特定目录中，而不是存储在集群的 etcd 中。这使得 Static Pod 与特定的节点绑定，而不是与整个集群绑定，这样就可以方便地将它们与特定节点的生命周期关联起来。

Static Pod 的定义文件通常存储在 /etc/kubernetes/manifests 或 /etc/kubernetes/static-pods 等目录中，kubelet 会定期检查这些目录，然后根据定义文件启动、管理和监视对应的 Pod。Static Pod 的启动、停止和重启等操作通常是由 kubelet 自动完成的，而不需要用户手动操作。

Static Pod 主要用于在集群中启动一些基础服务或辅助服务，如 kube-proxy、kube-dns、kube-scheduler 等。由于 Static Pod 是由 kubelet 直接管理的，因此它们通常用于启动一些在 kubelet 启动之前或 kubelet 启动失败时需要运行的服务。此外，Static Pod 还可以用于启动一些与 kubelet 相关的组件或工具，以方便地与 kubelet 进行交互和管理。

需要注意的是，Static Pod 不受 Kubernetes 控制平面的管理，因此在使用 Static Pod 时需要格外小心，确保其配置与集群的其他部分保持一致，以避免引起集群的不一致性或故障。

### downward api: 让 Pod 里的容器能够直接获取到这个 Pod API 对象本身的信息
此yaml文件申明了一个projected类型的Volume，来源为downward api，声明了要暴露pod的metadata.labels信息给容器，这样pod的labels字段的值，就会被kubernetes自动挂载成为容器里的/etc/podinfo/labels文件

projected volume包括secret，configmap，downward api，serviceaccounttoken
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-downwardapi-volume
  labels:
    zone: us-est-coast
    cluster: test-cluster1
    rack: rack-22
spec:
  containers:
    - name: client-container
      image: k8s.gcr.io/busybox
      command: ["sh", "-c"]
      args:
      - while true; do
          if [[ -e /etc/podinfo/labels ]]; then
            echo -en '\n\n'; cat /etc/podinfo/labels; fi;
          sleep 5;
        done;
      volumeMounts:
        - name: podinfo
          mountPath: /etc/podinfo
          readOnly: false
  volumes:
    - name: podinfo
      projected:
        sources:
        - downwardAPI:
            items:
              - path: "labels"
                fieldRef:
                  fieldPath: metadata.labels
```

### probe
只要 Pod 的 restartPolicy 指定的策略允许重启异常的容器（比如：Always），那么这个 Pod 就会保持 Running 状态，并进行容器重启。否则，Pod 就会进入 Failed 状态 。

对于包含多个容器的 Pod，只有它里面所有的容器都进入异常状态后，Pod 才会进入 Failed 状态。在此之前，Pod 都是 Running 状态。此时，Pod 的 READY 字段会显示正常容器的个数

## 证书
用于控制k8s内部之间和外部通信的

### 常见证书
通过kubeadm命令自动生成的证书目录：
```
[root@dev ~]# tree /etc/kubernetes/ 
/etc/kubernetes/
├── admin.conf  # 通验证apiserver服务端证书的ca证书、过kubectl命令访问apiserver使用的客户端证书和对应的私钥
├── controller-manager.conf  # 验证apiserver服务端证书的ca证书、作为客户端访问apiserver使用的证书和对应的私钥
├── kubelet.conf  # 同上
<!-- ├── manifests
│   ├── etcd.yaml
│   ├── kube-apiserver.yaml
│   ├── kube-controller-manager.yaml
│   └── kube-scheduler.yaml -->
├── pki
│   ├── apiserver.crt  # 对外提供服务的服务器证书
│   ├── apiserver-etcd-client.crt  # 用于访问 etcd 的客户端证书
│   ├── apiserver-etcd-client.key  # 用于访问 etcd 的客户端证书的私钥
│   ├── apiserver.key  # 服务器证书对应的私钥
│   ├── apiserver-kubelet-client.crt  # 用于访问 kubelet 的客户端证书
│   ├── apiserver-kubelet-client.key  # 用于访问 kubelet 的客户端证书的私钥
│   ├── ca.crt  # 用于验证访问 kube-apiserver 的客户端的证书的 CA 根证书
│   ├── ca.key
│   ├── etcd
│   │   ├── ca.crt  # 用于验证访问 etcd 服务器的客户端证书的 CA 根证书
│   │   ├── ca.key
│   │   ├── healthcheck-client.crt
│   │   ├── healthcheck-client.key
│   │   ├── peer.crt  # peer 证书，用于 etcd 节点之间的相互访问，同时用作服务器证书和客户端证书
│   │   ├── peer.key  # peer 证书对应的私钥
│   │   ├── server.crt  # 对外提供服务的服务器证书
│   │   └── server.key  # 服务器证书对应的私钥
│   ├── front-proxy-ca.crt
│   ├── front-proxy-ca.key
│   ├── front-proxy-client.crt  # 作为客户端访问apiserver的证书
│   ├── front-proxy-client.key  # 作为客户端访问apiserver的证书的私钥
│   ├── sa.key  # 用于生成和验证service account token的公钥和私钥
│   └── sa.pub  
└── scheduler.conf  # 验证apiserver服务端证书的ca证书、作为客户端访问apiserver使用的证书和对应的私钥
```

kubelet证书目录
```
[zj@centos-7-01 create_k8s]$ tree /var/lib/kubelet/pki/
/var/lib/kubelet/pki/
├── kubelet-client-2024-03-03-03-18-42.pem  # 作为客户端访问apiserver使用的证书
├── kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2024-03-03-03-18-42.pem
├── kubelet.crt  # 对外提供服务使用的服务端证书
└── kubelet.key  # 服务器证书对应的私钥
```

### 手动生成证书
easyrsa、openssl、cfssl等工具生成证书

流程（cfssl为例）：下载工具，自定义配置文件内容ca-config.json，自定义csr文件，基于配置文件和csr文件生成ca，再基于ca签名和其他csr文件生成所需要的证书，再将证书放到需要目录下

### 证书管理kubeadm
kubeadm certs check-expiration 查看证书过期状态信息  
```
[zj@centos-7-01 Documents]$ sudo kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Mar 03, 2025 11:18 UTC   362d            ca                      no
apiserver                  Mar 03, 2025 11:18 UTC   362d            ca                      no
apiserver-etcd-client      Mar 03, 2025 11:18 UTC   362d            etcd-ca                 no
apiserver-kubelet-client   Mar 03, 2025 11:18 UTC   362d            ca                      no
controller-manager.conf    Mar 03, 2025 11:18 UTC   362d            ca                      no
etcd-healthcheck-client    Mar 03, 2025 11:18 UTC   362d            etcd-ca                 no
etcd-peer                  Mar 03, 2025 11:18 UTC   362d            etcd-ca                 no
etcd-server                Mar 03, 2025 11:18 UTC   362d            etcd-ca                 no
front-proxy-client         Mar 03, 2025 11:18 UTC   362d            front-proxy-ca          no
scheduler.conf             Mar 03, 2025 11:18 UTC   362d            ca                      no
super-admin.conf           Mar 03, 2025 11:18 UTC   362d            ca                      no

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Mar 01, 2034 11:18 UTC   9y              no
etcd-ca                 Mar 01, 2034 11:18 UTC   9y              no
front-proxy-ca          Mar 01, 2034 11:18 UTC   9y              no
```
kubeadm upgrade 会自动更新证书  
kubeadm alpha certs renew all 更新所有证书，更新完后需要移除manifests下文件以重启静态pod  

kubeadm不管理由外部ca签名的证书。  
kubeadm不管理ca证书的更新  
kubelet会自动轮换证书，不由kubeadm更新。  
如果是HA集群需要在所有master节点执行更新证书动作

### 手动更换ca证书（todo）
https://kubernetes.io/zh-cn/docs/tasks/tls/manual-rotation-of-ca-certificates/

### 证书api（todo）
    
### 启用已签名的 kubelet 服务证书（todo）

## cert-manager
当把cert-manager部署在k8s集群后，他会根据请求自动生成证书，并定期检查证书的有效期，及时更新。

流程：先要部署证书颁发者（issuer），后续证书的生成以及更新都由issuer来完成

## kraken
加速集群中docker镜像的分发，p2p模式，避免镜像都从docker仓库拉取

## nfs-provisioner
根据需要自动生成nfs类型存储卷

## node-local-dns
在各节点设置dns缓存，加速dns解析

## 控制器
主要基于控制循环
```
for {
  实际状态 := 获取集群中对象 X 的实际状态（Actual State）
  期望状态 := 获取集群中对象 X 的期望状态（Desired State）
  if 实际状态 == 期望状态{
    什么都不做
  } else {
    执行编排动作，将实际状态调整为期望状态
  }
}
```

### statefulset
StatefulSet 这个控制器的主要作用之一，就是使用 Pod 模板创建 Pod 的时候，对它们进行编号，并且按照编号顺序逐一完成创建工作。而当 StatefulSet 的“控制循环”发现 Pod 的“实际状态”与“期望状态”不一致，需要新建或者删除 Pod 进行“调谐”的时候，它会严格按照这些 Pod 编号的顺序，逐一完成这些操作。

headless service: 访问“my-svc.my-namespace.svc.cluster.local”解析到的，直接就是 my-svc 代理的某一个 Pod 的 IP 地址。这里的区别在于，Headless Service 不需要分配一个 VIP，而是可以直接以 DNS 记录的方式解析出被代理 Pod 的 IP 地址。

clusterIP字段为None
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
```

### 离线业务job与cronjob
job只能设置restartPolicy为Never和OnFailure，如果job失败job controller会不断尝试创建一个新的pod

## Istio
通过在pod创建时往里面添加一个envoy容器来管理pod网络的进出流量，从而实现微服务的治理。这个添加的容器的功能是由控制器Initializer实时监控完成的

## api
在 Kubernetes 项目中，一个 API 对象在 Etcd 里的完整资源路径，是由：Group（API 组）、Version（API 版本）和 Resource（API 资源类型）三个部分组成的
```yaml
# Cronjob是资源类型，batch是组，v2alpha1是版本
apiVersion: batch/v2alpha1
kind: CronJob
...
```

## crd
CRD 仅仅是资源的定义，而 Controller 可以去监听 CRD 的 CRUD 事件来添加自定义业务逻辑。

对于 Kubernetes 里的核心 API 对象，比如：Pod、Node 等，是不需要 Group 的（即：它们 Group 是“”）

## operator
operator=crd+controller

Operator 的工作原理，实际上是利用了 Kubernetes 的自定义 API 资源（CRD），来描述我们想要部署的“有状态应用”；然后在自定义控制器里，根据自定义 API 对象的变化，来完成具体的部署和运维工作。

operator启动后会自动创建对应的crd

## rbac
kubernetes中的所有api对象，都保存在etcd中，对这些api对象的操作，一定都是通过kube-apiserver实现的，所以需要apiserver来完成授权工作

Role：角色，它其实是一组规则，定义了一组对 Kubernetes API 对象的操作权限。
Subject：被作用者，既可以是“人”，也可以是“机器”，也可以是你在 Kubernetes 里定义的“用户”。
RoleBinding：定义了“被作用者”和“角色”的绑定关系。

非namespaced对象：
ClusterRole
ClusterFoleBinding

kubernetes内置用户：ServiceAccount
每个ServiceAccount都有一个secret，用来与apiserver进行交互的授权文件
如果一个 Pod 没有声明 serviceAccountName，Kubernetes 会自动在它的 Namespace 下创建一个名叫 default 的默认 ServiceAccount，然后分配给这个 Pod。默认的ServiceAccount没有关联任何ROle，有访问APIServer的绝大多数权限

ServiceAccount用户：`system:serviceaccount:<ServiceAccount 名字 >`
ServiceAccount用户组：`system:serviceaccounts:<Namespace 名字 >`

kubernetes中内置了很多个为系统保留的ClusterFole，名字都以system:，通常是绑定给kubernetes系统组件对应的sa使用的

cluster-admin角色，是kubernetes中的最高权限（vers=*）

## 持久化

### 持久化过程
当一个pod调度到一个节点上后，kubelet就要负责为这个pod创建它的volume目录。默认情况下这个路径在宿主机上为
```
/var/lib/kubelet/pods/<Pod 的 ID>/volumes/kubernetes.io~<Volume 类型 >/<Volume 名字 >
```
接下来，如果volume类型是远程块存储即一款磁盘，需要通过api调用把块挂载到pod所在的宿主机上，这一步称为attach
```
gcloud compute instances attach-disk < 虚拟机名字 > --disk < 远程磁盘名字 >
```
attach完成后，kubelet需要格式化这个磁盘设备，然后将它挂载到宿主机指定的挂载点上，这个挂载点即volume宿主机目录，这一步称为mount。  
如果volume类型为远程文件存储，比如nfs，kubelet会跳过attach操作，直接mount
```
mount -t nfs <NFS 服务器地址 >:/ /var/lib/kubelet/pods/<Pod 的 ID>/volumes/kubernetes.io~<Volume 类型 >/<Volume 名字 > 
```
经过attach和mount的处理，kubelet只要把这个volume目录通过cri里的mounts参数传递给cr，然后就可以为pod里的容器挂载这个持久化的volume了，这一步相当于执行了如下命令
```
docker run -v /var/lib/kubelet/pods/<Pod 的 ID>/volumes/kubernetes.io~<Volume 类型 >/<Volume 名字 >:/< 容器内的目标目录 > 我的镜像 ...
```
对应的，在删除一个pv的时候，kubernetes也需要unmount和dettach两个阶段来处理

### StorageClass
sc对象的作用就是创建pv的模板，sc对象会定义以下两个部分内容：
1. PV 的属性。比如，存储类型、Volume 的大小等等。  
2. 创建这种 PV 需要用到的存储插件。比如，Ceph 等等。
有了这两个信息，kubernetes就能够根据用户提交的pvc找到一个对应的sc，然后kubrnetes就会调用该sc声明的存储插件，创建出需要的pv

### 本地持久化
比较适用于高优先级的系统应用，需要在多个不同的节点上存储数据，并且对i/o较为敏感，相比于正常的pv，一旦这些节点宕机且不能恢复，本地数据就可能丢失，这就要求使用本地持久化的应用必须具备数据备份和恢复的能力，允许把这些数据定时备份在其他位置

## cni
Kubernetes 是通过一个叫作 CNI 的接口，维护了一个单独的网桥来代替 docker0。这个网桥的名字就叫作：CNI 网桥，它在宿主机上的设备名称默认是：cni0。

flannel的vxlan模式中，在kubernetes环境里，docker0网桥会替换成cni网桥：

![](images/flannel_vxlan_cni.png)

在这里，Kubernetes 为 Flannel 分配的子网范围是 10.244.0.0/16

1. 当infra-container-1访问infra-container-2，源地址10.244.0.2，目的地址10.244.1.3，这个包会经过cni0出现在宿主机上

2. 匹配的宿主机上的路由，会将包交给flannel.1设备处理，接下来就跟flannel vxlan模式完全一样了。

cni网桥只是接管所有的cni插件负责的、即kubernetes创建的容器（pod），不管理由docker单独创建的容器

### cni原理
1. 在kubernetes部署的时候，有一个步骤是安装kubernetes-cni包，他的目的就是在宿主机上安装cni插件所需的基础可执行文件，可在宿主机/opt/cni/bin目录下看到
```
$ ls -al /opt/cni/bin/
total 73088
-rwxr-xr-x 1 root root  3890407 Aug 17  2017 bridge
-rwxr-xr-x 1 root root  9921982 Aug 17  2017 dhcp
-rwxr-xr-x 1 root root  2814104 Aug 17  2017 flannel
-rwxr-xr-x 1 root root  2991965 Aug 17  2017 host-local
-rwxr-xr-x 1 root root  3475802 Aug 17  2017 ipvlan
-rwxr-xr-x 1 root root  3026388 Aug 17  2017 loopback
-rwxr-xr-x 1 root root  3520724 Aug 17  2017 macvlan
-rwxr-xr-x 1 root root  3470464 Aug 17  2017 portmap
-rwxr-xr-x 1 root root  3877986 Aug 17  2017 ptp
-rwxr-xr-x 1 root root  2605279 Aug 17  2017 sample
-rwxr-xr-x 1 root root  2808402 Aug 17  2017 tuning
-rwxr-xr-x 1 root root  3475750 Aug 17  2017 vlan
```

2. 这些cni的基础可执行文件，按功能可分为三类：
 
第一类，叫作 Main 插件，它是用来创建具体网络设备的二进制文件。比如，bridge（网桥设备）、ipvlan、loopback（lo 设备）、macvlan、ptp（Veth Pair 设备），以及 vlan。

我在前面提到过的 Flannel、Weave 等项目，都属于“网桥”类型的 CNI 插件。所以在具体的实现中，它们往往会调用 bridge 这个二进制文件。这个流程，我马上就会详细介绍到。

第二类，叫作 IPAM（IP Address Management）插件，它是负责分配 IP 地址的二进制文件。比如，dhcp，这个文件会向 DHCP 服务器发起请求；host-local，则会使用预先配置的 IP 地址段来进行分配。

第三类，是由 CNI 社区维护的内置 CNI 插件。比如：flannel，就是专门为 Flannel 项目提供的 CNI 插件；tuning，是一个通过 sysctl 调整网络设备参数的二进制文件；portmap，是一个通过 iptables 配置端口映射的二进制文件；bandwidth，是一个使用 Token Bucket Filter (TBF) 来进行限流的二进制文件。

3. 实现给kubernetes用的容器网络方案，需要两部分工作：

首先，实现这个网络方案本身。这一部分需要编写的，其实就是 flanneld 进程里的主要逻辑。比如，创建和配置 flannel.1 设备、配置宿主机路由、配置 ARP 和 FDB 表里的信息等等。

然后，实现该网络方案对应的 CNI 插件。这一部分主要需要做的，就是配置 Infra 容器里面的网络栈，并把它连接在 CNI 网桥上。

4. 接下来就需要在宿主机上安装flanneld（网络方案本身），flanneld启动后会在每台宿主机上生成它对应的CNI配置文件（一个config），从而告诉kuberntes这个集群使用flannel作为容器网络方案
```
$ cat /etc/cni/net.d/10-flannel.conflist 
{
  "name": "cbr0",
  "plugins": [
    {
      "type": "flannel",
      "delegate": {
        "hairpinMode": true,
        "isDefaultGateway": true
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    }
  ]
}
```

5. 接下来dockershim会加载上述的cni配置文件，并把列表中的第一个插件，也就是flannel设置为默认插件，而在后面的执行过程中，flannel和portmap插件会按照定义顺序被调用，从而完成配置容器网络和配置端口映射

6. 当 kubelet 组件需要创建 Pod 的时候，它第一个创建的一定是 Infra 容器。所以在这一步，dockershim 就会先调用 Docker API 创建并启动 Infra 容器，紧接着执行一个叫作 SetUpPod 的方法。这个方法的作用就是：为 CNI 插件准备参数，然后调用 CNI 插件为 Infra 容器配置网络。

第一部分，是由 dockershim 设置的一组 CNI 环境变量。最重要的环境变量为CNI_COMMAND取值为ADD和DEL，这个ADD和DEL操作就是CNI插件唯一需要实现的两个方法。对于网桥类型cni插件来说，这两个操作意味着把容器以veth pair的方法插到cni网桥上或者从网桥上拔掉

第二部分，则是 dockershim 从 CNI 配置文件里加载到的、默认插件的配置信息。这个配置信息在 CNI 中被叫作 Network Configuration。dockershim 会把 Network Configuration 以 JSON 数据的格式，通过标准输入（stdin）的方式传递给 Flannel CNI 插件。

7. 在执行完上述操作之后，CNI 插件会把容器的 IP 地址等信息返回给 dockershim，然后被 kubelet 添加到 Pod 的 Status 字段。

## flannel
实现容器跨主机通信，其后端实现主要有vxlan、host-gw、udp

宿主机 Node 1 上有一个容器 container-1，它的 IP 地址是 100.96.1.2，对应的 docker0 网桥的地址是：100.96.1.1/24。 
宿主机 Node 2 上有一个容器 container-2，它的 IP 地址是 100.96.2.3，对应的 docker0 网桥的地址是：100.96.2.1/24。

container-1访问container-2

安装flannel后会在宿主机创建出一系列路由规则，以Node1为例，如下：
```
# 在 Node 1 上
$ ip route
default via 10.168.0.1 dev eth0
100.96.0.0/16 dev flannel0  proto kernel  scope link  src 100.96.1.0
100.96.1.0/24 dev docker0  proto kernel  scope link  src 100.96.1.1
10.168.0.0/24 dev eth0  proto kernel  scope link  src 10.168.0.2

# 在 Node 2 上
$ ip route
default via 10.168.0.1 dev eth0
100.96.0.0/16 dev flannel0  proto kernel  scope link  src 100.96.2.0
100.96.2.0/24 dev docker0  proto kernel  scope link  src 100.96.2.1
10.168.0.0/24 dev eth0  proto kernel  scope link  src 10.168.0.3
```

### udp模式
![](images/flannel_udp.png)

1. 首先ip包会通过docker0出现在宿主机上，接着会匹配宿主机上的第二条路由，从而把包交给虚拟网卡flannel0处理，然后这个包由内核态（网卡设备）流向用户态（宿主机上的flanneld进程）

2. flanneld收到这个包后，由于Flannel管理的容器网络里，一台宿主机上的所有容器都属于该宿主机分配的一个子网，在我们的例子中，Node 1 的子网是 100.96.1.0/24，container-1 的 IP 地址是 100.96.1.2。Node 2 的子网是 100.96.2.0/24，container-2 的 IP 地址是 100.96.2.3。而这些子网与宿主机的对应关系，正式保存在了etcd当中，即etcd保存子网对应的宿主机ip地址，对flanneld来说只要Node 1和Node 2是互通的，那么flanneld作为Node 1 上的一个普通进程，就一定能把这个ip包封装在udp中发给Node 2。

3. 这个udp包的源地址就是flanneld所在的node1的地址，而目的地址则是container-2所在的宿主机node2的地址，每台宿主机上的flanneld都监听着一个8285端口，所以flanneld只要把udp包发往node2的8285端口即可

4. node2上的flanneld收到这个ip包后会发给它所管理的TUN设备，即flannel0设备处理，这时是一个从用户态向内核态流动的方向，将udp包解封装后发现他的目的ip地址是100.96.2.3，就会匹配node2上第三条路由，从而把这个ip包转发给docker0网桥

5. 接着docker0 网桥会扮演二层交换机的角色，将数据包发送给正确的端口，进而通过 Veth Pair 设备进入到 container-2 的 Network Namespace 里。

注意：所有宿主机上的docker0网桥地址范围必须是flannel为宿主机分配的子网
```
$ FLANNEL_SUBNET=100.96.1.1/24
$ dockerd --bip=$FLANNEL_SUBNET ...
```

#### udp模式下ip包用户态与内核态之间的数据拷贝
![](images/flannel_udp_tun.png)

第一次：用户态的容器进程发出的 IP 包经过 docker0 网桥进入内核态；

第二次：IP 包根据路由表进入 TUN（flannel0）设备，从而回到用户态的 flanneld 进程；

第三次：flanneld 进行 UDP 封包之后重新进入内核态，将 UDP 包通过宿主机的 eth0 发出去。

此外，我们还可以看到，Flannel 进行 UDP 封装（Encapsulation）和解封装（Decapsulation）的过程，也都是在用户态完成的。在 Linux 操作系统中，上述这些上下文切换和用户态操作的代价其实是比较高的，这也正是造成 Flannel UDP 模式性能不好的主要原因。

所以说，我们在进行系统级编程的时候，有一个非常重要的优化原则，就是要减少用户态到内核态的切换次数，并且把核心的处理逻辑都放在内核态进行。这也是为什么，Flannel 后来支持的VXLAN 模式，逐渐成为了主流的容器网络方案的原因。

### vxlan模式 
vxlan，即virtual extensible lan（虚拟可扩展网），是linux内核本身就支持的一种网络，所以vxlan可以完全在内核态上实现上述的封装和解封装的工作

![](images/flannel_vxlan.png)

1. 每台宿主机上叫flannel.1的设备就是vxlan所需的vtep（VXLAN Tunnel End Point 虚拟隧道端点）设备，它既有ip地址也有mac地址。 container-1 的 IP 地址是 10.1.15.2，要访问的 container-2 的 IP 地址是 10.1.16.3。

2. 当container-1发出请求后，这个ip包会先出现在docker0网桥，然后被路由到本机flannel.1设备进行处理

3. 每台宿主机上的flanneld进程负责维护路由，比如，当 Node 2 启动并加入 Flannel 网络之后，在 Node 1（以及所有其他节点）上，flanneld 就会添加一条如下所示的路由规则：
```
$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
...
10.1.16.0       10.1.16.0       255.255.255.0   UG    0      0        0 flannel.1
```
这条规则告诉了通向目的vtep设备的包应该交给flannel.1来处理

4. 此时根据上面的路由记录会知道目的vtep设备的ip地址，然后会通过arp表知道目的vtep设备的mac地址。arp信息会在当flanneld进程在node2节点启动时，会自动添加node1上的：
```
# 在 Node 1 上
$ ip neigh show dev flannel.1
10.1.16.0 lladdr 5e:f8:4f:00:e3:37 PERMANENT
```

5. 得到mac地址后，linux内核会进行封包（目的vtep设备mac地址+目的容器地址），并加上VNI标志，值为1，用来表示这是一个vxlan要使用的数据帧

6. 接下来会进一步封装成一个宿主机上普通包通过eth0网卡进行传输，Linux 内核会把这个数据帧封装进一个 UDP 包里发出去。

7. 同时flanneld还维护着一个叫FDB（forwarding database）的转发数据库，记录着目的vtep设备mac地址对应的宿主机地址：
```
# 在 Node 1 上，使用“目的 VTEP 设备”的 MAC 地址进行查询
$ bridge fdb show flannel.1 | grep 5e:f8:4f:00:e3:37
5e:f8:4f:00:e3:37 dev flannel.1 dst 10.168.0.3 self permanent
```
发往我们前面提到的“目的 VTEP 设备”（MAC 地址是 5e:f8:4f:00:e3:37）的二层数据帧，应该通过 flannel.1 设备，发往 IP 地址为 10.168.0.3 的主机。显然，这台主机正是 Node 2，UDP 包要发往的目的地就找到了。

最终的帧结构：  
![](images/flannel_vxlan_frame.png)

8. 接下来，node1上的flannel.1设备就可以把这个数据帧从node1的eth0网卡发送到node2的eth0网卡，node2的内核网络栈发现这个数据帧中有vxlan header，并且VNI=1，所以linux内核会对他进行解包，拿到内部数据帧把它交给node2上的flannel.1设备。而flannel.1会进一步解包，取出原始ip包，最终会进入到container-2的network namespace

### host-gw模式
![](images/flannel_host-gw.png)

1. 当node1上infra-container-1访问node2上的infra-container2时，当设置flannel使用host-gw模式后，flanneld会在宿主机上创建一条规则，以node1为例：
```
$ ip route
...
10.244.1.0/24 via 10.168.0.3 dev eth0
```

2. 这个下一跳10.168.0.3的地址正是node2的地址，所以infra-container-1发出的ip包通过宿主机二层网络到达node2上

3. node2解包后看到这个目的地址为10.244.1.3，则会根据node2上的路由表，进入到cni0网桥，从而到infra-container-2中

host-gw模式的工作原理，就是将每个flanne子网的下一跳设置成了子网对应的宿主机地址，flannel子网和主机的信息都是保存在etcd当中的。

基于以上，所以说，Flannel host-gw 模式必须要求集群宿主机之间是二层连通的。

## calico
Calico 项目提供的网络解决方案，与 Flannel 的 host-gw 模式，几乎是完全一样的。Calico 也会在每台宿主机上，添加一个格式如下所示的路由规则：
`< 目的容器 IP 地址段 > via < 网关的 IP 地址 > dev eth0`
其中，网关的 IP 地址，正是目的容器所在宿主机的 IP 地址。

不过，不同于 Flannel 通过 Etcd 和宿主机上的 flanneld 来维护路由信息的做法，Calico 项目使用了一个“重型武器”来自动地在整个集群中分发路由信息。

这个“重型武器”，就是 BGP。

BGP 的全称是 Border Gateway Protocol，即：边界网关协议。它是一个 Linux 内核原生就支持的、专门用在大规模数据中心里维护不同的“自治系统”之间路由信息的、无中心的路由协议。

![](images/calico_bgp.png)

在这个图中，我们有两个自治系统（Autonomous System，简称为 AS）：AS 1 和 AS 2。而所谓的一个自治系统，指的是一个组织管辖下的所有 IP 网络和路由器的全体。但是，如果这样两个自治系统里的主机，要通过 IP 地址直接进行通信，我们就必须使用路由器把这两个自治系统连接起来。

边界网关会负责维护不同网络的路由，使得每个网络下主机访问另一个网络主机时，它所在网络的路由器有对应的路由规则告诉应该把这个网络包发往哪个网关。

在使用了 BGP 之后，你可以认为，在每个边界网关上都会运行着一个小程序，它们会将各自的路由表信息，通过 TCP 传输给其他的边界网关。而其他边界网关上的这个小程序，则会对收到的这些数据进行分析，然后将需要的信息添加到自己的路由表里。

这样，图中 Router 2 的路由表里，就会自动出现 10.10.0.2 和 10.10.0.3 对应的路由规则了。

所以说，所谓 BGP，就是在大规模网络中实现节点路由信息共享的一种协议。

### calico的架构
1. Calico 的 CNI 插件。这是 Calico 与 Kubernetes 对接的部分。我已经在上一篇文章中，和你详细分享了 CNI 插件的工作原理，这里就不再赘述了。

2. Felix。它是一个 DaemonSet，负责在宿主机上插入路由规则（即：写入 Linux 内核的 FIB 转发信息库），以及维护 Calico 所需的网络设备等工作。

3. BIRD。它就是 BGP 的客户端，专门负责在集群里分发路由规则信息。

除了对路由信息的维护方式之外，Calico 项目与 Flannel 的 host-gw 模式的另一个不同之处，就是它不会在宿主机上创建任何网桥设备。

![](images/calico_working_principle.png)

由于 Calico 没有使用 CNI 的网桥模式，Calico 的 CNI 插件还需要在宿主机上为每个容器的 Veth Pair 设备配置一条路由规则，用于接收传入的 IP 包。比如，宿主机 Node 2 上的 Container 4 对应的路由规则，如下所示：
`10.233.2.3 dev cali5863f3 scope link`
即：发往 10.233.2.3 的 IP 包，应该进入 cali5863f3 设备。

### calico模式
默认为 node to node mesh模式，推荐用于少于100个节点的集群中，因为随着节点数量 N 的增加，这些连接的数量就会以 N²的规模快速增长，从而给集群本身的网络带来巨大的压力。更大规模的集群需要用route reflector模式

在这种模式下，Calico 会指定一个或者几个专门的节点，来负责跟所有节点建立 BGP 连接从而学习到全局的路由规则。而其他节点，只需要跟这几个专门的节点交换路由信息，就可以获得整个集群的路由规则信息了。

### calico ipip模式
当出现两台宿主机不在同一个网络,没办法通过二层网络把 IP 包发送到下一跳地址时需要开启ipip模式

![](images/calico_ipip.png)

1. 在 Calico 的 IPIP 模式下，Felix 进程在 Node 1 上添加的路由规则，会稍微不同，如下所示：
`10.233.2.0/24 via 192.168.2.2 tunl0` 包会交给tunl0设备处理

2. ip包进入tunl0后，linux内核的ipip驱动会将这个ip包直接封装在一个宿主机网络的ip包中

3. 这样，原先从容器到 Node 2 的 IP 包，就被伪装成了一个从 Node 1 到 Node 2 的 IP 包。

4. 由于宿主机之间已经使用路由器配置了三层转发，也就是设置了宿主机之间的“下一跳”。所以这个 IP 包在离开 Node 1 之后，就可以经过路由器，最终“跳”到 Node 2 上。

5. 这时，Node 2 的网络内核栈会使用 IPIP 驱动进行解包，从而拿到原始的 IP 包。然后，原始 IP 包就会经过路由规则和 Veth Pair 设备到达目的容器内部。

不难看到，当 Calico 使用 IPIP 模式的时候，集群的网络性能会因为额外的封包和解包工作而下降。在实际测试中，Calico IPIP 模式与 Flannel VXLAN 模式的性能大致相当。所以，在实际使用时，如非硬性需求，我建议你将所有宿主机节点放在一个子网里，避免使用 IPIP。

## k8s中的dns
Kubernetes 为 Service 和 Pod 创建 DNS 记录。 你可以使用一致的 DNS 名称而非 IP 地址访问 Service。

 DNS 服务器（例如 CoreDNS）会监视 Kubernetes API 中的新 Service， 并为每个 Service 创建一组 DNS 记录。如果在整个集群中都启用了 DNS，则所有 Pod 都应该能够通过 DNS 名称自动解析 Service。

例如，如果你在 Kubernetes 命名空间 my-ns 中有一个名为 my-service 的 Service， 则控制平面和 DNS 服务共同为 my-service.my-ns 生成 DNS 记录。 名字空间 my-ns 中的 Pod 应该能够通过按名检索 my-service 来找到服务 （my-service.my-ns 也可以）。

其他名字空间中的 Pod 必须将名称限定为 my-service.my-ns。 这些名称将解析为分配给 Service 的集群 IP。

Kubernetes 还支持命名端口的 DNS SRV（Service）记录。 如果 Service my-service.my-ns 具有名为 http　的端口，且协议设置为 TCP， 则可以用 `_http._tcp.my-service.my-ns` 执行 DNS SRV 查询以发现 http 的端口号以及 IP 地址。

Kubernetes DNS 服务器是唯一的一种能够访问 ExternalName 类型的 Service 的方式。

DNS 查询可以使用 Pod 中的 /etc/resolv.conf 展开。 Kubelet 为每个 Pod 配置此文件。 例如，对 data 的查询可能被展开为 data.test.svc.cluster.local。 search 选项的取值会被用来展开查询。
```
nameserver 10.32.0.10
search <namespace>.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

## service
暴露集群内的服务，并对服务提供负载均衡功能，默认使用TCP协议

### 实现原理（cluster）
由kube-proxy组件加上iptables（默认）来共同实现的

比如现在有一个service vip是10.0.1.175/32的80端口代理着三个pod10.244.0.5:9376,10.244.0.6:9376,10.244.0.7:9376

当创建这个service的时候，kube-proxy就可以通过service的informer感知到这样一个service对象的添加，然后kube-proxy就会在宿主机上创建一条iptables规则：
```
-A KUBE-SERVICES -d 10.0.1.175/32 -p tcp -m comment --comment "default/hostnames: cluster IP" -m tcp --dport 80 -j KUBE-SVC-NWV5X2332I4OT4T3
```
* `-A KUBE-SERVICES`：这表示将规则添加到名为 `KUBE-SERVICES` 的iptables链中。`-A` 选项用于添加规则到链的末尾。
    
* `-d 10.0.1.175/32`：这指定了目标地址为 `10.0.1.175`，后面的 `/32` 表示这是一个CIDR表示法，表示单个IP地址。
    
* `-p tcp`：这表示匹配传输层协议为TCP的数据包。
    
* `-m comment --comment "default/hostnames: cluster IP"`：这是一个注释，提供了关于规则目的的信息，这对于管理规则集合时非常有用。
    
* `-m tcp --dport 80`：这表示匹配目标端口为80的TCP数据包。 `-m tcp` 表示使用TCP模块来匹配数据包。
    
* `-j KUBE-SVC-NWV5X2332I4OT4T3`：这表示如果数据包符合以上条件，将跳转到名为 `KUBE-SVC-NWV5X2332I4OT4T3` 的目标。 `-j` 表示跳转到目标。

这条规则就为这个service设置了一个固定入口地址，接着跳转到KUBE-SVC-NWV5X2332I4OT4T3：
```
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -m statistic --mode random --probability 0.33332999982 -j KUBE-SEP-WNBA2IHDGP2BOBGZ
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-X3P2623AGDH6CDF3
-A KUBE-SVC-NWV5X2332I4OT4T3 -m comment --comment "default/hostnames:" -j KUBE-SEP-57KPRZ3JQVENLNBR
```
用-mode random的模式，随机转发到目的地，分别是 KUBE-SEP-WNBA2IHDGP2BOBGZ、KUBE-SEP-X3P2623AGDH6CDF3 和 KUBE-SEP-57KPRZ3JQVENLNBR。而这三条链指向的最终目的地，其实就是这个 Service 代理的三个 Pod。

由于iptables规则是从上到下逐条进行的，所以为了保证上述三条规则每条被选中的概率都相同，我们应该将它们的 probability 字段的值分别设置为 1/3（0.333…）、1/2 和 1。

这么设置的原理很简单：第一条规则被选中的概率就是 1/3；而如果第一条规则没有被选中，那么这时候就只剩下两条规则了，所以第二条规则的 probability 就必须设置为 1/2；类似地，最后一条就必须设置为 1。

上述三条链的明细：
```
-A KUBE-SEP-57KPRZ3JQVENLNBR -s 10.244.3.6/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-57KPRZ3JQVENLNBR -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.3.6:9376

-A KUBE-SEP-WNBA2IHDGP2BOBGZ -s 10.244.1.7/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-WNBA2IHDGP2BOBGZ -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.1.7:9376

-A KUBE-SEP-X3P2623AGDH6CDF3 -s 10.244.2.3/32 -m comment --comment "default/hostnames:" -j MARK --set-xmark 0x00004000/0x00004000
-A KUBE-SEP-X3P2623AGDH6CDF3 -p tcp -m comment --comment "default/hostnames:" -m tcp -j DNAT --to-destination 10.244.2.3:9376
```
可以看到，这三条链，其实是三条 DNAT 规则。但在 DNAT 规则之前，iptables 对流入的 IP 包还设置了一个“标志”（–set-xmark）。而 DNAT 规则的作用，就是在 PREROUTING 检查点之前，也就是在路由之前，将流入 IP 包的目的地址和端口，改成–to-destination 所指定的新的目的地址和端口。可以看到，这个目的地址和端口，正是被代理 Pod 的 IP 地址和端口。

总结：这些 Endpoints 对应的 iptables 规则，正是 kube-proxy 通过监听 Pod 的变化事件，在宿主机上生成并维护的。当流量通过nodrport或者负载均衡器进入，也会执行相同的基本流程，只是在这些情况下，客户端ip地址会被更改

#### k8s中的informer
在 Kubernetes 中，Informer 是一种用于监视 Kubernetes 资源对象变化的机制。它是 Kubernetes 中客户端库的一部分，用于跟踪集群中特定类型资源对象的状态变化。

Informer 的主要作用是从 Kubernetes API Server 中获取资源对象的信息，并在这些资源对象发生变化时通知注册的监听器或回调函数。这些变化可以包括创建、更新、删除等操作，因此 Informer 是一种非常强大的工具，用于实现对 Kubernetes 资源对象的实时监控和响应。

在 Kubernetes 的开发中，开发者可以使用 Informer 来编写自定义的控制器、操作器或其他应用程序，以实现更高级的自动化管理功能。通过注册适当的回调函数，开发者可以在资源对象发生变化时执行一些逻辑操作，例如更新缓存、发送通知、触发其他操作等。

通常情况下，使用 Informer 时，开发者需要指定要监视的资源类型（如 Pod、Service、Deployment 等）、筛选条件（可选）、以及注册相应的事件处理函数。Informer 会负责与 Kubernetes API Server 进行通信，并在资源对象发生变化时将相应的事件通知传递给注册的处理函数。

在 Kubernetes 中，常见的 Informer 实现包括 client-go 库中的 Informer，它是 Kubernetes 官方提供的 Go 语言客户端库之一，用于与 Kubernetes API 进行交互和操作。此外，还有其他基于不同语言的客户端库也提供了类似的 Informer 机制。

### ipvs模式工作原理
当你的宿主机上有大量 Pod 的时候，成百上千条 iptables 规则不断地被刷新，会大量占用该宿主机的 CPU 资源，甚至会让宿主机“卡”在这个过程中。所以说，一直以来，基于 iptables 的 Service 实现，都是制约 Kubernetes 项目承载更多量级的 Pod 的主要障碍。

而 IPVS 模式的 Service，就是解决这个问题的一个行之有效的方法。

IPVS 模式的工作原理，其实跟 iptables 模式类似。当我们创建了前面的 Service 之后，kube-proxy 首先会在宿主机上创建一个虚拟网卡（叫作：kube-ipvs0），并为它分配 Service VIP 作为 IP 地址，如下所示：
```
# ip addr
  ...
  73：kube-ipvs0：<BROADCAST,NOARP>  mtu 1500 qdisc noop state DOWN qlen 1000
  link/ether  1a:ce:f5:5f:c1:4d brd ff:ff:ff:ff:ff:ff
  inet 10.0.1.175/32  scope global kube-ipvs0
  valid_lft forever  preferred_lft forever
```

而接下来，kube-proxy 就会通过 Linux 的 IPVS 模块，为这个 IP 地址设置三个 IPVS 虚拟主机，并设置这三个虚拟主机之间使用轮询模式 (rr) 来作为负载均衡策略。我们可以通过 ipvsadm 查看到这个设置，如下所示：
```
# ipvsadm -ln
 IP Virtual Server version 1.2.1 (size=4096)
  Prot LocalAddress:Port Scheduler Flags
    ->  RemoteAddress:Port           Forward  Weight ActiveConn InActConn     
  TCP  10.102.128.4:80 rr
    ->  10.244.3.6:9376    Masq    1       0          0         
    ->  10.244.1.7:9376    Masq    1       0          0
    ->  10.244.2.3:9376    Masq    1       0          0
```
可以看到，这三个 IPVS 虚拟主机的 IP 地址和端口，对应的正是三个被代理的 Pod。

这时候，任何发往 10.102.128.4:80 的请求，就都会被 IPVS 模块转发到某一个后端 Pod 上了。

而相比于 iptables，IPVS 在内核中的实现其实也是基于 Netfilter 的 NAT 模式，所以在转发这一层上，理论上 IPVS 并没有显著的性能提升。但是，IPVS 并不需要在宿主机上为每个 Pod 设置 iptables 规则（netlink创建ipvs规则，底层数据结构采用了hash table），而是把对这些“规则”的处理放到了内核态，从而极大地降低了维护这些规则的代价。这也正印证了我在前面提到过的，“将重要操作放入内核态”是提高性能的重要手段。

ipvs模式还为负载均衡提供了更多的选择：rr、wrr、lc、wlc等等

不过需要注意的是，IPVS 模块只负责上述的负载均衡和代理功能。而一个完整的 Service 流程正常工作所需要的包过滤、SNAT 等操作，还是要靠 iptables 来实现。只不过，这些辅助性的 iptables 规则数量有限，也不会随着 Pod 数量的增加而增加。

所以，在大规模集群里，我非常建议你为 kube-proxy 设置–proxy-mode=ipvs 来开启这个功能。它为 Kubernetes 集群规模带来的提升，还是非常巨大的。

### nodeport类型实现原理
当以nodeport类型，service的8080端口代理pod80端口，service的443端口代理pod的443端口。此时kube-proxy会在每台宿主机上生成这样一条iptables规则：
```
-A KUBE-NODEPORTS -p tcp -m comment --comment "default/my-nginx: nodePort" -m tcp --dport 8080 -j KUBE-SVC-67RL4FN6JRUPOJYM
```
KUBE-SVC-67RL4FN6JRUPOJYM 其实就是一组随机模式的 iptables 规则。所以接下来的流程，就跟 ClusterIP 模式完全一样了。

需要注意的是，在 NodePort 方式下，Kubernetes 会在 IP 包离开宿主机发往目的 Pod 时，对这个 IP 包做一次 SNAT 操作，如下所示：
```
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -m mark --mark 0x4000/0x4000 -j MASQUERADE
```
可以看到，这条规则设置在 POSTROUTING 检查点，也就是说，它给即将离开这台主机的 IP 包，进行了一次 SNAT 操作，将这个 IP 包的源地址替换成了这台宿主机上的 CNI 网桥地址，或者宿主机本身的 IP 地址（如果 CNI 网桥不存在的话）。

当然，这个 SNAT 操作只需要对 Service 转发出来的 IP 包进行（否则普通的 IP 包就被影响了）。而 iptables 做这个判断的依据，就是查看该 IP 包是否有一个“0x4000”的“标志”。你应该还记得，这个标志正是在 IP 包被执行 DNAT 操作之前被打上去的。

对流出包做SNAT的原因：
```
           client
             \ ^
              \ \
               v \
   node 1 <--- node 2
    | ^   SNAT
    | |   --->
    v |
 endpoint
```
当一个外部的 client 通过 node 2 的地址访问一个 Service 的时候，node 2 上的负载均衡规则，就可能把这个 IP 包转发给一个在 node 1 上的 Pod。这里没有任何问题。

而当 node 1 上的这个 Pod 处理完请求之后，它就会按照这个 IP 包的源地址发出回复。

可是，如果没有做 SNAT 操作的话，这时候，被转发来的 IP 包的源地址就是 client 的 IP 地址。所以此时，Pod 就会直接将回复发给client。对于 client 来说，它的请求明明发给了 node 2，收到的回复却来自 node 1，这个 client 很可能会报错。

所以，在上图中，当 IP 包离开 node 2 之后，它的源 IP 地址就会被 SNAT 改成 node 2 的 CNI 网桥地址或者 node 2 自己的地址。这样，Pod 在处理完成之后就会先回复给 node 2（而不是 client），然后再由 node 2 发送给 client。

当然，这也就意味着这个 Pod 只知道该 IP 包来自于 node 2，而不是外部的 client。对于 Pod 需要明确知道所有请求来源的场景来说，这是不可以的。

所以这时候，你就可以将 Service 的 spec.externalTrafficPolicy 字段设置为 local，这就保证了所有 Pod 通过 Service 收到请求之后，一定可以看到真正的、外部 client 的源地址。

而这个机制的实现原理也非常简单：这时候，一台宿主机上的 iptables 规则，会设置为只将 IP 包转发给运行在这台宿主机上的 Pod。所以这时候，Pod 就可以直接使用源地址将回复包发出，不需要事先进行 SNAT 了。这个流程，如下所示：
```
       client
       ^ /   \
      / /     \
     / v       X
   node 1     node 2
    ^ |
    | |
    | v
 endpoint
```
当然，这也就意味着如果在一台宿主机上，没有任何一个被代理的 Pod 存在，比如上图中的 node 2，那么你使用 node 2 的 IP 地址访问这个 Service，就是无效的。此时，你的请求会直接被 DROP 掉。

### service相关排错思路
1. 区分是service本身的配置文件还是k8s集群的dns服务出了问题
在一个pod中执行命令nslookup + dns服务器vip地址（或者域名），观察dns是否正常返回，如果返回值有问题，就需要检查kube—dns的运行状态和日志；否则去检查自己的service定义是不是有问题

2. 如果你的 Service 没办法通过 ClusterIP 访问到的时候，你首先应该检查的是这个 Service 是否有 Endpoints：
```
$ kubectl get endpoints hostnames
NAME        ENDPOINTS
hostnames   10.244.0.5:9376,10.244.0.6:9376,10.244.0.7:9376
```

3. 如果endpoints正常，那么就需要确认kube-proxy是否正在正确运行

4. 如果kube-proxy也正常，那么就需要仔细检查宿主机上的iptables
```
KUBE-SERVICES 或者 KUBE-NODEPORTS 规则对应的 Service 的入口链，这个规则应该与 VIP 和 Service 端口一一对应；

KUBE-SEP-(hash) 规则对应的 DNAT 链，这些规则应该与 Endpoints 一一对应；

KUBE-SVC-(hash) 规则对应的负载均衡链，这些规则的数目应该与 Endpoints 数目一致；

如果是 NodePort 模式的话，还有 POSTROUTING 处的 SNAT 链。

通过查看这些链的数量、转发目的地址、端口、过滤条件等信息，你就能很容易发现一些异常的蛛丝马迹。
```

5. 还有一种典型问题，就是 Pod 没办法通过 Service 访问到自己。这往往就是因为 kubelet 的 hairpin-mode 没有被正确设置。关于 Hairpin 的原理我在前面已经介绍过，这里就不再赘述了。你只需要确保将 kubelet 的 hairpin-mode 设置为 hairpin-veth 或者 promiscuous-bridge 即可。

## ingress
工作在七层，是service的“service”，ingress就是kubernetes中全局的反向代理，负责k8s内部所有service的负载均衡，根据定义的rules转发到不同的service上去。它是本身也是通过Nodetype或者loadbalancer类型的service来对外提供服务的。 

首先需要在集群中安装ingress-controller，然后这个pod会监听ingress对象以及它所代理的后端service变化的控制器，当一个新的ingress对象创建后，ingress-controller会根据ingress对象里定义的内容生成一份对应的nginx配置文件（/etc/nginx/nginx.conf），并使用这个配置文件启动一个nginx服务，而一旦ingress对象被更新，ingress-controller就会更新这个配置文件，如果只是被代理的service对象被更新，ingress-controller所管理的nginx是不需要reload的，此外ingress-controller还允许通过configmap对象来对上述的nginx配置文件进行定制。

为了让用户能够用到这个nginx，我们需要创建一个service来把ingress-controller管理的nginx服务暴露出去

## 集群内核调优参考
```bash
cat >> /etc/sysctl.d/99-k8s.conf << EOF
#sysctls for k8s node config
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.tcp_slow_start_after_idle=0
net.core.rmem_max=16777216
fs.inotify.max_user_watches=524288
kernel.softlockup_all_cpu_backtrace=1
kernel.softlockup_panic=1
fs.file-max=2097152
fs.inotify.max_user_instances=8192
fs.inotify.max_queued_events=16384
vm.max_map_count=262144
net.core.netdev_max_backlog=16384
net.ipv4.tcp_wmem=4096 12582912 16777216
net.core.wmem_max=16777216
net.core.somaxconn=32768
net.ipv4.ip_forward=1
net.ipv4.tcp_max_syn_backlog=8096
net.ipv4.tcp_rmem=4096 12582912 16777216
EOF

sysctl --system
```

## k8s集群所支持的规格
每个节点的 Pod 数量不超过 110
节点数不超过 5,000
Pod 总数不超过 150,000
容器总数不超过 300,000

## 高可用集群部署流程（kubeadm）
基于kubernetes-v1.29.2、dockerCE-v25.0.3、cri-dockerd-v0.3.10、flannel-v0.24.2、CentOS-7

### 1. 准备机器配置
RAM：>2GB  
cpu_cores：>2  
节点之中不可以有重复的主机名、MAC 地址或 product_uuid  
开启机器上的某些端口，并不被占用：6443、2379-2380、10250、10259、10257

关闭swap：
```bash
sudo swapoff -a
sudo sed -i '/.*swap.*/d' /etc/fstab 
```

### 2. 安装容器运行时
配置网络环境：
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 设置所需的 sysctl 参数，参数在重新启动后保持不变
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 应用 sysctl 参数而不重新启动
sudo sysctl --system

# 检查模块是否被加载
lsmod | grep br_netfilter
lsmod | grep overlay
```

按照docker官网，设置systemctl enable --now，/etc/docker/daemon.json配置文件如下
```json
{
        "registry-mirrors": ["https://dockerproxy.com"],
        "exec-opts": ["native.cgroupdriver=systemd"],
        "storage-driver": "overlay2"
}
```

### 3. 安装容器运行时接口
按照cri-dockerd GitHub仓库，cri-dockerd服务启动参数需要指定--pod-infra-container-image，设置systemctl enable --now

### 4. 安装kubeadm、kubelet、kubectl
按照kubernetes官网，设置kubelet systemctl enable --now

### 5. 初始化master节点
sudo kubeadm init --config kubeadm_init_config.yaml --upload-certs

重新上传证书：sudo kubeadm init phase upload-certs --upload-certs
```yaml
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 192.168.1.5
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/cri-dockerd.sock
  imagePullPolicy: IfNotPresent
  name: master-01
  taints: []
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controlPlaneEndpoint: 192.168.1.5:6443
controllerManager:
  extraArgs:
    "node-cidr-mask-size": "25"
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: 1.29.0
networking:
  dnsDomain: cluster.local
  podSubnet: 10.1.0.0/16
  serviceSubnet: 10.2.0.0/16
scheduler: {}
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
containerRuntimeEndpoint: unix:///var/run/cri-dockerd.sock
``` 

### 6. 配置kubeconfig文件
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 7. 安装网络插件flannel，使各节点各pod能相互通信
```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    k8s-app: flannel
    pod-security.kubernetes.io/enforce: privileged
  name: kube-flannel
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: flannel
  name: flannel
  namespace: kube-flannel
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: flannel
  name: flannel
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes/status
  verbs:
  - patch
- apiGroups:
  - networking.k8s.io
  resources:
  - clustercidrs
  verbs:
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: flannel
  name: flannel
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: flannel
subjects:
- kind: ServiceAccount
  name: flannel
  namespace: kube-flannel
---
apiVersion: v1
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
  net-conf.json: |
    {
      "Network": "10.1.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
kind: ConfigMap
metadata:
  labels:
    app: flannel
    k8s-app: flannel
    tier: node
  name: kube-flannel-cfg
  namespace: kube-flannel
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: flannel
    k8s-app: flannel
    tier: node
  name: kube-flannel-ds
  namespace: kube-flannel
spec:
  selector:
    matchLabels:
      app: flannel
      k8s-app: flannel
  template:
    metadata:
      labels:
        app: flannel
        k8s-app: flannel
        tier: node
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/os
                operator: In
                values:
                - linux
      containers:
      - args:
        - --ip-masq
        - --kube-subnet-mgr
        command:
        - /opt/bin/flanneld
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: EVENT_QUEUE_DEPTH
          value: "5000"
        image: docker.io/flannel/flannel:v0.24.2
        name: kube-flannel
        resources:
          requests:
            cpu: 100m
            memory: 50Mi
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
            - NET_RAW
          privileged: false
        volumeMounts:
        - mountPath: /run/flannel
          name: run
        - mountPath: /etc/kube-flannel/
          name: flannel-cfg
        - mountPath: /run/xtables.lock
          name: xtables-lock
      hostNetwork: true
      initContainers:
      - args:
        - -f
        - /flannel
        - /opt/cni/bin/flannel
        command:
        - cp
        image: docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
        name: install-cni-plugin
        volumeMounts:
        - mountPath: /opt/cni/bin
          name: cni-plugin
      - args:
        - -f
        - /etc/kube-flannel/cni-conf.json
        - /etc/cni/net.d/10-flannel.conflist
        command:
        - cp
        image: docker.io/flannel/flannel:v0.24.2
        name: install-cni
        volumeMounts:
        - mountPath: /etc/cni/net.d
          name: cni
        - mountPath: /etc/kube-flannel/
          name: flannel-cfg
      priorityClassName: system-node-critical
      serviceAccountName: flannel
      tolerations:
      - effect: NoSchedule
        operator: Exists
      volumes:
      - hostPath:
          path: /run/flannel
        name: run
      - hostPath:
          path: /opt/cni/bin
        name: cni-plugin
      - hostPath:
          path: /etc/cni/net.d
        name: cni
      - configMap:
          name: kube-flannel-cfg
        name: flannel-cfg
      - hostPath:
          path: /run/xtables.lock
          type: FileOrCreate
        name: xtables-lock
```

### 注意事项：
1. cr、cri的配置
2. 机器是否开启了http代理而影响了组件与apiserver的通信

kubeadm init
```
在执行kubeadm init时，会为集群生成一个bootstrap token，在后面只要持有和这个token，任何安装kubelet和kubeadm的节点都可以通过kubeadm join加入到这个集群中

在token生成之后，kubeadm会将ca.crt等master节点的重要信息通过configmap的方式保存在etcd中，供后续节点使用，这个configmap名字是cluster-info

kubeadm init最后一步是安装默认插件，默认会安装kube-proxy和dns这两个插件，分别为集群提供服务发现和dns功能，也是两个容器镜像
```

kubeadm join
```
此时kubeadm至少需要发起一次“不安全模式”的访问到kube-apiserver，从而拿到保存在configmap中cluster-info信息，而bootstrap token扮演就是这个过程中安全验证的角色
```

## debug

### k8s master机器重启后，coredns两个pod就绪探针失败
环境：centos 7、k8s 1.29、docker25.0、kube-proxy使用iptables模式

#### 现象：

kubectl get pod,svc,endpoints -A -o wide
```
[zj@centos-7-01 create_k8s]$ kubectl get pod,svc,endpoints  -A -o wide
NAMESPACE       NAME                                                   READY   STATUS             RESTARTS        AGE     IP            NODE        NOMINATED NODE   READINESS GATES
ingress-nginx   pod/ingress-nginx-controller-75dbc5d7f7-qhlml          0/1     CrashLoopBackOff   426 (27s ago)   4d14h   10.1.0.53     master-01   <none>           <none>
jenkins         pod/jenkins-0                                          0/2     Completed          0               3d13h   10.1.0.52     master-01   <none>           <none>
kube-flannel    pod/kube-flannel-ds-rjrtw                              1/1     Running            7 (23h ago)     4d21h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/coredns-5b8bf7b657-5gjrq                           0/1     Running            7 (23h ago)     4d22h   10.1.0.55     master-01   <none>           <none>
kube-system     pod/coredns-5b8bf7b657-rqndm                           0/1     Running            7 (23h ago)     4d22h   10.1.0.54     master-01   <none>           <none>
kube-system     pod/etcd-master-01                                     1/1     Running            13 (23h ago)    7d20h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-apiserver-master-01                           1/1     Running            13 (23h ago)    7d20h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-controller-manager-master-01                  1/1     Running            7 (23h ago)     7d20h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-proxy-s5x84                                   1/1     Running            7 (23h ago)     7d20h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-scheduler-master-01                           1/1     Running            7 (23h ago)     7d20h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/nfs-subdir-external-provisioner-6676cf59d8-j9grt   0/1     CrashLoopBackOff   298 (97s ago)   4d21h   10.1.0.56     master-01   <none>           <none>

NAMESPACE       NAME                                         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE     SELECTOR
default         service/kubernetes                           ClusterIP      10.2.0.1       <none>        443/TCP                      7d20h   <none>
ingress-nginx   service/ingress-nginx-controller             LoadBalancer   10.2.73.220    <pending>     80:31674/TCP,443:31306/TCP   4d14h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
ingress-nginx   service/ingress-nginx-controller-admission   ClusterIP      10.2.142.214   <none>        443/TCP                      4d14h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
jenkins         service/jenkins                              NodePort       10.2.226.53    <none>        8080:32117/TCP               4d14h   app.kubernetes.io/component=jenkins-controller,app.kubernetes.io/instance=jenkins
jenkins         service/jenkins-agent                        ClusterIP      10.2.237.8     <none>        50000/TCP                    4d14h   app.kubernetes.io/component=jenkins-controller,app.kubernetes.io/instance=jenkins
kube-system     service/kube-dns                             ClusterIP      10.2.0.10      <none>        53/UDP,53/TCP,9153/TCP       7d20h   k8s-app=kube-dns

NAMESPACE       NAME                                                      ENDPOINTS          AGE
default         endpoints/kubernetes                                      192.168.1.5:6443   7d20h
ingress-nginx   endpoints/ingress-nginx-controller                                           4d14h
ingress-nginx   endpoints/ingress-nginx-controller-admission                                 4d14h
jenkins         endpoints/jenkins                                                            4d14h
jenkins         endpoints/jenkins-agent                                                      4d14h
kube-system     endpoints/cluster.local-nfs-subdir-external-provisioner   <none>             4d21h
kube-system     endpoints/kube-dns                                                           7d20h
```

kubectl describe pod coredns... 
```
[zj@centos-7-01 create_k8s]$ kubectl describe pod  coredns-5b8bf7b657-5gjrq -n kube-system
Name:                 coredns-5b8bf7b657-5gjrq
Namespace:            kube-system
Priority:             2000000000
Priority Class Name:  system-cluster-critical
Service Account:      coredns
Node:                 master-01/192.168.1.5
Start Time:           Wed, 06 Mar 2024 17:09:42 +0800
Labels:               k8s-app=kube-dns
                      pod-template-hash=5b8bf7b657
Annotations:          kubectl.kubernetes.io/restartedAt: 2024-03-06T17:09:42+08:00
Status:               Running
IP:                   10.1.0.55
IPs:
  IP:           10.1.0.55
Controlled By:  ReplicaSet/coredns-5b8bf7b657
Containers:
  coredns:
    Container ID:  docker://cff11b157ef5154f52897338e2fbb398059cd3516a5f5268bc313458fc4bf686
    Image:         registry.aliyuncs.com/google_containers/coredns:v1.11.1
    Image ID:      docker-pullable://registry.aliyuncs.com/google_containers/coredns@sha256:a6b67bdb2a6750b591e6b07fac29653fc82ee964e5fc53baf4c1ad3f944b655a
    Ports:         53/UDP, 53/TCP, 9153/TCP
    Host Ports:    0/UDP, 0/TCP, 0/TCP
    Args:
      -conf
      /etc/coredns/Corefile
    State:          Running
      Started:      Sun, 10 Mar 2024 20:33:09 +0800
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 08 Mar 2024 13:47:52 +0800
      Finished:     Sun, 10 Mar 2024 15:37:01 +0800
    Ready:          False
    Restart Count:  7
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pkzsg (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       False
  ContainersReady             False
  PodScheduled                True
Volumes:
  config-volume:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      coredns
    Optional:  false
  kube-api-access-pkzsg:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 CriticalAddonsOnly op=Exists
                             node-role.kubernetes.io/control-plane:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                  From     Message
  ----     ------     ----                 ----     -------
  Warning  Unhealthy  4m (x2755 over 19h)  kubelet  Readiness probe failed: HTTP probe failed with statuscode: 503
```

kubectl logs pod coredns...
```
[INFO] plugin/ready: Still waiting on: "kubernetes"
[INFO] plugin/ready: Still waiting on: "kubernetes"
[INFO] plugin/ready: Still waiting on: "kubernetes"
[INFO] plugin/ready: Still waiting on: "kubernetes"
[INFO] plugin/ready: Still waiting on: "kubernetes"
[INFO] plugin/kubernetes: pkg/mod/k8s.io/client-go@v0.27.4/tools/cache/reflector.go:231: failed to list *v1.Namespace: Get "https://10.2.0.1:443/api/v1/namespaces?limit=500&resourceVersion=0": dial tcp 10.2.0.1:443: i/o timeout
[INFO] plugin/kubernetes: Trace[1924150888]: "Reflector ListAndWatch" name:pkg/mod/k8s.io/client-go@v0.27.4/tools/cache/reflector.go:231 (11-Mar-2024 07:34:16.841) (total time: 30012ms):
Trace[1924150888]: ---"Objects listed" error:Get "https://10.2.0.1:443/api/v1/namespaces?limit=500&resourceVersion=0": dial tcp 10.2.0.1:443: i/o timeout 30012ms (07:34:46.853)
Trace[1924150888]: [30.012054617s] [30.012054617s] END
[ERROR] plugin/kubernetes: pkg/mod/k8s.io/client-go@v0.27.4/tools/cache/reflector.go:231: Failed to watch *v1.Namespace: failed to list *v1.Namespace: Get "https://10.2.0.1:443/api/v1/namespaces?limit=500&resourceVersion=0": dial tcp 10.2.0.1:443: i/o timeout
[INFO] plugin/kubernetes: pkg/mod/k8s.io/client-go@v0.27.4/tools/cache/reflector.go:231: failed to list *v1.EndpointSlice: Get "https://10.2.0.1:443/apis/discovery.k8s.io/v1/endpointslices?limit=500&resourceVersion=0": dial tcp 10.2.0.1:443: connect: no route to host
[ERROR] plugin/kubernetes: pkg/mod/k8s.io/client-go@v0.27.4/tools/cache/reflector.go:231: Failed to watch *v1.EndpointSlice: failed to list *v1.EndpointSlice: Get "https://10.2.0.1:443/apis/discovery.k8s.io/v1/endpointslices?limit=500&resourceVersion=0": dial tcp 10.2.0.1:443: connect: no route to host
[INFO] plugin/ready: Still waiting on: "kubernetes"
```

iptables-save 
```
# Generated by iptables-save v1.4.21 on Mon Mar 11 16:35:18 2024
*mangle
:PREROUTING ACCEPT [4644794:3553279999]
:INPUT ACCEPT [4534307:3548307044]
:FORWARD ACCEPT [110487:4972955]
:OUTPUT ACCEPT [4566644:3552829610]
:POSTROUTING ACCEPT [4566663:3552832906]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
-A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
COMMIT
# Completed on Mon Mar 11 16:35:18 2024
# Generated by iptables-save v1.4.21 on Mon Mar 11 16:35:18 2024
*nat
:PREROUTING ACCEPT [11756:534806]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [6632:402707]
:POSTROUTING ACCEPT [6632:402707]
:DOCKER - [0:0]
:FLANNEL-POSTRTG - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-54IUPJM2TTG4TKF2 - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
-A POSTROUTING -s 192.168.122.0/24 -d 224.0.0.0/24 -j RETURN
-A POSTROUTING -s 192.168.122.0/24 -d 255.255.255.255/32 -j RETURN
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG
-A DOCKER -i docker0 -j RETURN
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/25 -d 10.1.0.0/16 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/16 -d 10.1.0.0/25 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG ! -s 10.1.0.0/16 -d 10.1.0.0/25 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE
-A FLANNEL-POSTRTG ! -s 10.1.0.0/16 -d 10.1.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE
-A KUBE-SEP-54IUPJM2TTG4TKF2 -s 192.168.1.5/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-54IUPJM2TTG4TKF2 -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 192.168.1.5:6443
-A KUBE-SERVICES -d 10.2.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 10.1.0.0/16 -d 10.2.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 192.168.1.5:6443" -j KUBE-SEP-54IUPJM2TTG4TKF2
COMMIT
# Completed on Mon Mar 11 16:35:18 2024
# Generated by iptables-save v1.4.21 on Mon Mar 11 16:35:18 2024
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [488143:376292718]
:DOCKER - [0:0]
:DOCKER-ISOLATION-STAGE-1 - [0:0]
:DOCKER-ISOLATION-STAGE-2 - [0:0]
:DOCKER-USER - [0:0]
:FLANNEL-FWD - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FIREWALL - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A INPUT -i virbr0 -p udp -m udp --dport 53 -j ACCEPT
-A INPUT -i virbr0 -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -i virbr0 -p udp -m udp --dport 67 -j ACCEPT
-A INPUT -i virbr0 -p tcp -m tcp --dport 67 -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -j DOCKER-USER
-A FORWARD -j DOCKER-ISOLATION-STAGE-1
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -o docker0 -j DOCKER
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
-A FORWARD -d 192.168.122.0/24 -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -s 192.168.122.0/24 -i virbr0 -j ACCEPT
-A FORWARD -i virbr0 -o virbr0 -j ACCEPT
-A FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -m comment --comment "flanneld forward" -j FLANNEL-FWD
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A OUTPUT -o virbr0 -p udp -m udp --dport 68 -j ACCEPT
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
-A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
-A FLANNEL-FWD -s 10.1.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A FLANNEL-FWD -d 10.1.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A KUBE-EXTERNAL-SERVICES -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https has no endpoints" -m addrtype --dst-type LOCAL -m tcp --dport 31306 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-EXTERNAL-SERVICES -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http has no endpoints" -m addrtype --dst-type LOCAL -m tcp --dport 31674 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-EXTERNAL-SERVICES -p tcp -m comment --comment "jenkins/jenkins:http has no endpoints" -m addrtype --dst-type LOCAL -m tcp --dport 32117 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A KUBE-SERVICES -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https has no endpoints" -m tcp --dport 443 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http has no endpoints" -m tcp --dport 80 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.142.214/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook has no endpoints" -m tcp --dport 443 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.226.53/32 -p tcp -m comment --comment "jenkins/jenkins:http has no endpoints" -m tcp --dport 8080 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns has no endpoints" -m udp --dport 53 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp has no endpoints" -m tcp --dport 53 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics has no endpoints" -m tcp --dport 9153 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.2.237.8/32 -p tcp -m comment --comment "jenkins/jenkins-agent:agent-listener has no endpoints" -m tcp --dport 50000 -j REJECT --reject-with icmp-port-unreachable
COMMIT
# Completed on Mon Mar 11 16:35:18 2024
```

#### 原因
重启过程中iptables相关规则丢失了，比如与coredns servcie相关的规则丢失，导致集群域名解析不能正常工作

#### 解决 
```bash
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker

# 尝试在集群正常状态下，自动保存当前的iptables规则，使得下次机器重启后iptables不被丢失
```

结果：

kubectl get ...
```
[zj@centos-7-01 create_k8s]$ kubectl get pod,svc,endpoints -A -o wide
NAMESPACE       NAME                                                   READY   STATUS    RESTARTS          AGE     IP            NODE        NOMINATED NODE   READINESS GATES
ingress-nginx   pod/ingress-nginx-controller-75dbc5d7f7-qhlml          1/1     Running   467 (8m57s ago)   4d16h   10.1.0.66     master-01   <none>           <none>
jenkins         pod/jenkins-0                                          2/2     Running   2 (3d4h ago)      3d15h   10.1.0.63     master-01   <none>           <none>
kube-flannel    pod/kube-flannel-ds-rjrtw                              1/1     Running   8 (8m57s ago)     4d23h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/coredns-857d9ff4c9-7m27z                           1/1     Running   1 (8m52s ago)     31m     10.1.0.67     master-01   <none>           <none>
kube-system     pod/coredns-857d9ff4c9-wwczd                           1/1     Running   1 (8m52s ago)     31m     10.1.0.64     master-01   <none>           <none>
kube-system     pod/etcd-master-01                                     1/1     Running   14 (8m57s ago)    7d22h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-apiserver-master-01                           1/1     Running   14 (8m47s ago)    7d22h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-controller-manager-master-01                  1/1     Running   8 (8m57s ago)     7d22h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-proxy-s5x84                                   1/1     Running   8 (8m57s ago)     7d22h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/kube-scheduler-master-01                           1/1     Running   8 (8m57s ago)     7d22h   192.168.1.5   master-01   <none>           <none>
kube-system     pod/nfs-subdir-external-provisioner-6676cf59d8-j9grt   1/1     Running   325 (13m ago)     4d23h   10.1.0.65     master-01   <none>           <none>

NAMESPACE       NAME                                         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE     SELECTOR
default         service/kubernetes                           ClusterIP      10.2.0.1       <none>        443/TCP                      7d22h   <none>
ingress-nginx   service/ingress-nginx-controller             LoadBalancer   10.2.73.220    <pending>     80:31674/TCP,443:31306/TCP   4d16h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
ingress-nginx   service/ingress-nginx-controller-admission   ClusterIP      10.2.142.214   <none>        443/TCP                      4d16h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
jenkins         service/jenkins                              NodePort       10.2.226.53    <none>        8080:32117/TCP               4d16h   app.kubernetes.io/component=jenkins-controller,app.kubernetes.io/instance=jenkins
jenkins         service/jenkins-agent                        ClusterIP      10.2.237.8     <none>        50000/TCP                    4d16h   app.kubernetes.io/component=jenkins-controller,app.kubernetes.io/instance=jenkins
kube-system     service/kube-dns                             ClusterIP      10.2.0.10      <none>        53/UDP,53/TCP,9153/TCP       7d22h   k8s-app=kube-dns

NAMESPACE       NAME                                                      ENDPOINTS                                            AGE
default         endpoints/kubernetes                                      192.168.1.5:6443                                     7d22h
ingress-nginx   endpoints/ingress-nginx-controller                        10.1.0.66:443,10.1.0.66:80                           4d16h
ingress-nginx   endpoints/ingress-nginx-controller-admission              10.1.0.66:8443                                       4d16h
jenkins         endpoints/jenkins                                         10.1.0.63:8080                                       4d16h
jenkins         endpoints/jenkins-agent                                   10.1.0.63:50000                                      4d16h
kube-system     endpoints/cluster.local-nfs-subdir-external-provisioner   <none>                                               4d23h
kube-system     endpoints/kube-dns                                        10.1.0.64:53,10.1.0.67:53,10.1.0.64:53 + 3 more...   7d22h
[zj@centos-7-01 create_k8s]$ kubectl logs  coredns-857d9ff4c9-7m27z -n kube-system
.:53
[INFO] plugin/reload: Running configuration SHA512 = 591cf328cccc12bc490481273e738df59329c62c0b729d94e8b61db9961c2fa5f046dd37f1cf888b953814040d180f52594972691cd6ff41be96639138a43908
CoreDNS-1.11.1
linux/amd64, go1.20.7, ae2bbc2
```

iptabls-save 
```
[zj@centos-7-01 create_k8s]$ sudo iptables-save
# Generated by iptables-save v1.4.21 on Mon Mar 11 17:55:00 2024
*mangle
:PREROUTING ACCEPT [5479891:4217540884]
:INPUT ACCEPT [5353488:4211849117]
:FORWARD ACCEPT [126403:5691767]
:OUTPUT ACCEPT [5383124:4217373218]
:POSTROUTING ACCEPT [5383171:4217378810]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
-A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
COMMIT
# Completed on Mon Mar 11 17:55:00 2024
# Generated by iptables-save v1.4.21 on Mon Mar 11 17:55:00 2024
*nat
:PREROUTING ACCEPT [6:638]
:INPUT ACCEPT [16:1238]
:OUTPUT ACCEPT [1455:88016]
:POSTROUTING ACCEPT [1455:88016]
:DOCKER - [0:0]
:FLANNEL-POSTRTG - [0:0]
:KUBE-EXT-CG5I4G2RS3ZVWGLK - [0:0]
:KUBE-EXT-EDNDUDH2C75GIR6O - [0:0]
:KUBE-EXT-KLKESZFIHQ5XX6FZ - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-24CQDNH5YB2GOAMH - [0:0]
:KUBE-SEP-54IUPJM2TTG4TKF2 - [0:0]
:KUBE-SEP-H3DHMFYS7S42CFSN - [0:0]
:KUBE-SEP-IV6EKVYQS77JP6M7 - [0:0]
:KUBE-SEP-O2YBC32BIIPN4DGD - [0:0]
:KUBE-SEP-O5LSP4IVD436RT3J - [0:0]
:KUBE-SEP-PM7R7IIC56RV32VC - [0:0]
:KUBE-SEP-TT4D5P4LY4YRBPNS - [0:0]
:KUBE-SEP-V4YRN7CFGU5XUNXJ - [0:0]
:KUBE-SEP-VZGDTBTQB7EQ6ERQ - [0:0]
:KUBE-SEP-X4HAJPVNMCYDHGMV - [0:0]
:KUBE-SEP-XQCFPAQSGQ46R77P - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-CG5I4G2RS3ZVWGLK - [0:0]
:KUBE-SVC-EDNDUDH2C75GIR6O - [0:0]
:KUBE-SVC-ERIFXISQEP7F7OF4 - [0:0]
:KUBE-SVC-EZYNCFY2F7N6OQA2 - [0:0]
:KUBE-SVC-JD5MR3NA4I4DYORP - [0:0]
:KUBE-SVC-KLKESZFIHQ5XX6FZ - [0:0]
:KUBE-SVC-NDI7DJ6D7ATLKECA - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
:KUBE-SVC-TCOU7JCQXEZGVUNU - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/25 -d 10.1.0.0/16 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/16 -d 10.1.0.0/25 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG ! -s 10.1.0.0/16 -d 10.1.0.0/25 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.1.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE
-A FLANNEL-POSTRTG ! -s 10.1.0.0/16 -d 10.1.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE
-A KUBE-EXT-CG5I4G2RS3ZVWGLK -m comment --comment "masquerade traffic for ingress-nginx/ingress-nginx-controller:http external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-CG5I4G2RS3ZVWGLK -j KUBE-SVC-CG5I4G2RS3ZVWGLK
-A KUBE-EXT-EDNDUDH2C75GIR6O -m comment --comment "masquerade traffic for ingress-nginx/ingress-nginx-controller:https external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-EDNDUDH2C75GIR6O -j KUBE-SVC-EDNDUDH2C75GIR6O
-A KUBE-EXT-KLKESZFIHQ5XX6FZ -m comment --comment "masquerade traffic for jenkins/jenkins:http external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-KLKESZFIHQ5XX6FZ -j KUBE-SVC-KLKESZFIHQ5XX6FZ
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-NODEPORTS -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http" -m tcp --dport 31674 -j KUBE-EXT-CG5I4G2RS3ZVWGLK
-A KUBE-NODEPORTS -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https" -m tcp --dport 31306 -j KUBE-EXT-EDNDUDH2C75GIR6O
-A KUBE-NODEPORTS -p tcp -m comment --comment "jenkins/jenkins:http" -m tcp --dport 32117 -j KUBE-EXT-KLKESZFIHQ5XX6FZ
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE
-A KUBE-SEP-24CQDNH5YB2GOAMH -s 10.1.0.64/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-24CQDNH5YB2GOAMH -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.1.0.64:9153
-A KUBE-SEP-54IUPJM2TTG4TKF2 -s 192.168.1.5/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-54IUPJM2TTG4TKF2 -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 192.168.1.5:6443
-A KUBE-SEP-H3DHMFYS7S42CFSN -s 10.1.0.66/32 -m comment --comment "ingress-nginx/ingress-nginx-controller:http" -j KUBE-MARK-MASQ
-A KUBE-SEP-H3DHMFYS7S42CFSN -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http" -m tcp -j DNAT --to-destination 10.1.0.66:80
-A KUBE-SEP-IV6EKVYQS77JP6M7 -s 10.1.0.66/32 -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook" -j KUBE-MARK-MASQ
-A KUBE-SEP-IV6EKVYQS77JP6M7 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook" -m tcp -j DNAT --to-destination 10.1.0.66:8443
-A KUBE-SEP-O2YBC32BIIPN4DGD -s 10.1.0.67/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-O2YBC32BIIPN4DGD -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.1.0.67:9153
-A KUBE-SEP-O5LSP4IVD436RT3J -s 10.1.0.67/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-O5LSP4IVD436RT3J -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.1.0.67:53
-A KUBE-SEP-PM7R7IIC56RV32VC -s 10.1.0.63/32 -m comment --comment "jenkins/jenkins:http" -j KUBE-MARK-MASQ
-A KUBE-SEP-PM7R7IIC56RV32VC -p tcp -m comment --comment "jenkins/jenkins:http" -m tcp -j DNAT --to-destination 10.1.0.63:8080
-A KUBE-SEP-TT4D5P4LY4YRBPNS -s 10.1.0.64/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-TT4D5P4LY4YRBPNS -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.1.0.64:53
-A KUBE-SEP-V4YRN7CFGU5XUNXJ -s 10.1.0.64/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-V4YRN7CFGU5XUNXJ -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.1.0.64:53
-A KUBE-SEP-VZGDTBTQB7EQ6ERQ -s 10.1.0.66/32 -m comment --comment "ingress-nginx/ingress-nginx-controller:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-VZGDTBTQB7EQ6ERQ -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https" -m tcp -j DNAT --to-destination 10.1.0.66:443
-A KUBE-SEP-X4HAJPVNMCYDHGMV -s 10.1.0.63/32 -m comment --comment "jenkins/jenkins-agent:agent-listener" -j KUBE-MARK-MASQ
-A KUBE-SEP-X4HAJPVNMCYDHGMV -p tcp -m comment --comment "jenkins/jenkins-agent:agent-listener" -m tcp -j DNAT --to-destination 10.1.0.63:50000
-A KUBE-SEP-XQCFPAQSGQ46R77P -s 10.1.0.67/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-XQCFPAQSGQ46R77P -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.1.0.67:53
-A KUBE-SERVICES -d 10.2.237.8/32 -p tcp -m comment --comment "jenkins/jenkins-agent:agent-listener cluster IP" -m tcp --dport 50000 -j KUBE-SVC-NDI7DJ6D7ATLKECA
-A KUBE-SERVICES -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-SVC-ERIFXISQEP7F7OF4
-A KUBE-SERVICES -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http cluster IP" -m tcp --dport 80 -j KUBE-SVC-CG5I4G2RS3ZVWGLK
-A KUBE-SERVICES -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-EDNDUDH2C75GIR6O
-A KUBE-SERVICES -d 10.2.226.53/32 -p tcp -m comment --comment "jenkins/jenkins:http cluster IP" -m tcp --dport 8080 -j KUBE-SVC-KLKESZFIHQ5XX6FZ
-A KUBE-SERVICES -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-SVC-JD5MR3NA4I4DYORP
-A KUBE-SERVICES -d 10.2.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -d 10.2.142.214/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook cluster IP" -m tcp --dport 443 -j KUBE-SVC-EZYNCFY2F7N6OQA2
-A KUBE-SERVICES -d 10.2.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-SVC-TCOU7JCQXEZGVUNU
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-CG5I4G2RS3ZVWGLK ! -s 10.1.0.0/16 -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:http cluster IP" -m tcp --dport 80 -j KUBE-MARK-MASQ
-A KUBE-SVC-CG5I4G2RS3ZVWGLK -m comment --comment "ingress-nginx/ingress-nginx-controller:http -> 10.1.0.66:80" -j KUBE-SEP-H3DHMFYS7S42CFSN
-A KUBE-SVC-EDNDUDH2C75GIR6O ! -s 10.1.0.0/16 -d 10.2.73.220/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-EDNDUDH2C75GIR6O -m comment --comment "ingress-nginx/ingress-nginx-controller:https -> 10.1.0.66:443" -j KUBE-SEP-VZGDTBTQB7EQ6ERQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 ! -s 10.1.0.0/16 -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.1.0.64:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-V4YRN7CFGU5XUNXJ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.1.0.67:53" -j KUBE-SEP-XQCFPAQSGQ46R77P
-A KUBE-SVC-EZYNCFY2F7N6OQA2 ! -s 10.1.0.0/16 -d 10.2.142.214/32 -p tcp -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-EZYNCFY2F7N6OQA2 -m comment --comment "ingress-nginx/ingress-nginx-controller-admission:https-webhook -> 10.1.0.66:8443" -j KUBE-SEP-IV6EKVYQS77JP6M7
-A KUBE-SVC-JD5MR3NA4I4DYORP ! -s 10.1.0.0/16 -d 10.2.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-MARK-MASQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.1.0.64:9153" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-24CQDNH5YB2GOAMH
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.1.0.67:9153" -j KUBE-SEP-O2YBC32BIIPN4DGD
-A KUBE-SVC-KLKESZFIHQ5XX6FZ ! -s 10.1.0.0/16 -d 10.2.226.53/32 -p tcp -m comment --comment "jenkins/jenkins:http cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SVC-KLKESZFIHQ5XX6FZ -m comment --comment "jenkins/jenkins:http -> 10.1.0.63:8080" -j KUBE-SEP-PM7R7IIC56RV32VC
-A KUBE-SVC-NDI7DJ6D7ATLKECA ! -s 10.1.0.0/16 -d 10.2.237.8/32 -p tcp -m comment --comment "jenkins/jenkins-agent:agent-listener cluster IP" -m tcp --dport 50000 -j KUBE-MARK-MASQ
-A KUBE-SVC-NDI7DJ6D7ATLKECA -m comment --comment "jenkins/jenkins-agent:agent-listener -> 10.1.0.63:50000" -j KUBE-SEP-X4HAJPVNMCYDHGMV
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 10.1.0.0/16 -d 10.2.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 192.168.1.5:6443" -j KUBE-SEP-54IUPJM2TTG4TKF2
-A KUBE-SVC-TCOU7JCQXEZGVUNU ! -s 10.1.0.0/16 -d 10.2.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.1.0.64:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-TT4D5P4LY4YRBPNS
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.1.0.67:53" -j KUBE-SEP-O5LSP4IVD436RT3J
COMMIT
# Completed on Mon Mar 11 17:55:00 2024
# Generated by iptables-save v1.4.21 on Mon Mar 11 17:55:00 2024
*filter
:INPUT ACCEPT [105976:75984836]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [104769:76233827]
:DOCKER - [0:0]
:DOCKER-ISOLATION-STAGE-1 - [0:0]
:DOCKER-ISOLATION-STAGE-2 - [0:0]
:DOCKER-USER - [0:0]
:FLANNEL-FWD - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FIREWALL - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m comment --comment "flanneld forward" -j FLANNEL-FWD
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A FLANNEL-FWD -s 10.1.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A FLANNEL-FWD -d 10.1.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
COMMIT
# Completed on Mon Mar 11 17:55:00 2024
```

## 参考资料
https://www.zhaohuabing.com/post/2020-05-19-k8s-certificate/
https://blog.51cto.com/13210651/2361208
https://kubernetes.io/docs/tasks/administer-cluster/certificates/
https://kubernetes.io/zh-cn/docs/setup/best-practices/certificates/
https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/
https://kubernetes.io/zh-cn/docs/tasks/tls/managing-tls-in-a-cluster
https://kubernetes.io/zh-cn/docs/tasks/tls/manual-rotation-of-ca-certificates/
https://cert-manager.io/docs/
