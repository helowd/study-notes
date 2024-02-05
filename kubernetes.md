# kubernetes
文档内容基于v1.17.04版本

## 目录
<!-- vim-markdown-toc GFM -->

* [容器发展历史](#容器发展历史)
* [容器与虚拟机比较](#容器与虚拟机比较)
* [高可用集群部署流程（kubeadm）](#高可用集群部署流程kubeadm)
* [pod](#pod)
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
* [api](#api)
* [crd](#crd)
* [Istio](#istio)
* [rbac](#rbac)
* [持久化](#持久化)
    * [持久化过程](#持久化过程)
    * [StorageClass](#storageclass)
    * [本地持久化](#本地持久化)
* [service](#service)
* [ingress](#ingress)
* [cni](#cni)
    * [flannel](#flannel)
* [集群内核调优参考](#集群内核调优参考)
* [参考资料](#参考资料)

<!-- vim-markdown-toc -->

## 容器发展历史
一开始是Cloud Foundry利用Cgroups和Namespace机制隔离各个应用的环境，但由于环境的打包过程不如docker镜像方便进而被docker取代，而由于大规模部署应用的需求出现了swarm这类容器集群管理项目，compose项目的推出也为容器编排提供了有力帮助，这些使得docker在当时站住了主流。而后不满docker一家独大的现状，谷歌、red hat等开源领域玩家牵头建立了CNCF，并以kubernetes项目为核心来对抗docker。由于kubernetes生态迅速崛起，docker将容器运行时containerd捐赠给CNCF，从此也标志着以kubernetes为核心容器技术发展

## 容器与虚拟机比较
容器利用linux的cgroups（资源限制）和namespace（资源隔离）技术实现，实际上是宿主机上的一个特殊的进程，共享内核。而虚拟机利用额外的工具如hypervisor等技术实现对宿主机资源的隔离，相比容器隔离更加的彻底

容器镜像：rootfs

## 高可用集群部署流程（kubeadm）
1. 准备机器，lb集群+master集群+node集群，相互能通信
2. 配置环境，kubeadm、kubectl、kubelet工具，cri和cr，关闭swap
3. 初始化master，加入其他节点到集群

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

## pod

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
用于控制k8s内部、外部通信的

### 常见证书
通过kubeadm命令自动生成的证书目录：
```bash
[root@dev ~]# tree /etc/kubernetes/ 
/etc/kubernetes/
├── admin.conf
├── controller-manager.conf
├── kubelet.conf
<!-- ├── manifests
│   ├── etcd.yaml
│   ├── kube-apiserver.yaml
│   ├── kube-controller-manager.yaml
│   └── kube-scheduler.yaml -->
├── pki
│   ├── apiserver.crt
│   ├── apiserver-etcd-client.crt
│   ├── apiserver-etcd-client.key
│   ├── apiserver.key
│   ├── apiserver-kubelet-client.crt
│   ├── apiserver-kubelet-client.key
│   ├── ca.crt
│   ├── ca.key
│   ├── etcd
│   │   ├── ca.crt
│   │   ├── ca.key
│   │   ├── healthcheck-client.crt
│   │   ├── healthcheck-client.key
│   │   ├── peer.crt
│   │   ├── peer.key
│   │   ├── server.crt
│   │   └── server.key
│   ├── front-proxy-ca.crt
│   ├── front-proxy-ca.key
│   ├── front-proxy-client.crt
│   ├── front-proxy-client.key
│   ├── sa.key
│   └── sa.pub
└── scheduler.conf

3 directories, 30 files
```
### 手动生成证书
easyrsa、openssl、cfssl等工具生成证书

流程（cfssl为例）：下载工具，自定义配置文件内容ca-config.json，自定义csr文件，基于配置文件和csr文件生成ca，再基于ca签名和其他csr文件生成所需要的证书，再将证书放到需要目录下

### 证书管理kubeadm
kubeadm certs check-expiration 查看证书过期状态信息  
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

## api
在 Kubernetes 项目中，一个 API 对象在 Etcd 里的完整资源路径，是由：Group（API 组）、Version（API 版本）和 Resource（API 资源类型）三个部分组成的
```yaml
# Cronjob是资源类型，batch是组，v2alpha1是版本
apiVersion: batch/v2alpha1
kind: CronJob
...
```

## crd
operator=crd+controller
CRD 仅仅是资源的定义，而 Controller 可以去监听 CRD 的 CRUD 事件来添加自定义业务逻辑。

对于 Kubernetes 里的核心 API 对象，比如：Pod、Node 等，是不需要 Group 的（即：它们 Group 是“”）

## Istio
通过在pod创建时往里面添加一个envoy容器来管理pod网络的进出流量，从而实现微服务的治理。这个添加的容器的功能是由控制器Initializer实时监控完成的

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

## service

## ingress
工作在七层，是service的“service”，ingress就是kubernetes中的反向代理。  

首先需要在集群中安装ingress-controller，然后这个pod会监听ingress对象以及它所代理的后端service变化的控制器，当一个新的ingress对象创建后，ingress-controller会根据ingress对象里定义的内容生成一份对应的nginx配置文件（/etc/nginx/nginx.conf），并使用这个配置文件启动一个nginx服务，而一旦ingress对象被更新，ingress-controller就会更新这个配置文件，如果只是被代理的service对象被更新，ingress-controller所管理的nginx是不需要reload的，此外ingress-controller还允许通过configmap对象来对上述的nginx配置文件进行定制。

为了让用户能够用到这个nginx，我们需要创建一个service来把ingress-controller管理的nginx服务暴露出去，

## cni

### flannel
```
实现容器跨主机通信，其后端实现是要vxlan、host-gw、udp

安装flannel会在主机生成一个flannel0的设备，他是一个工作在三层网络的tunnel设备，作用：在操作系统内核和用户应用程序之间传递ip包

udp性能不好的原因：用户态内核态之间数据拷贝过多，容器发出ip包就要经过三次数据拷贝，我们在进行系统级编程的时候，有一个非常重要的优化原则，就是要减少用户态到内核态的切换次数，并且把核心的处理逻辑都放在内核态进行

vxlan优点在于：是 Linux 内核本身就支持的一种网络虚似化技术。所以说，VXLAN 可以完全在内核态实现上述封装和解封装的工作
```

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

## 参考资料
https://www.zhaohuabing.com/post/2020-05-19-k8s-certificate/
https://blog.51cto.com/13210651/2361208
https://kubernetes.io/docs/tasks/administer-cluster/certificates/
https://kubernetes.io/zh-cn/docs/setup/best-practices/certificates/
https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/
https://kubernetes.io/zh-cn/docs/tasks/tls/managing-tls-in-a-cluster
https://kubernetes.io/zh-cn/docs/tasks/tls/manual-rotation-of-ca-certificates/
https://cert-manager.io/docs/
