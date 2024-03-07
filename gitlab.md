# gitlab

## 目录

<!-- vim-markdown-toc GFM -->

* [介绍](#介绍)
* [gitlab CI/CD](#gitlab-cicd)
    * [原理](#原理)
    * [gitlab Runner](#gitlab-runner)
    * [与docker集成](#与docker集成)

<!-- vim-markdown-toc -->

## 介绍
GitLab 是一个基于 Git 版本控制系统的 web 应用程序，用于代码托管、协作和持续集成/持续部署（CI/CD）。它提供了一整套功能，包括源代码管理、问题跟踪、代码审查、wiki、持续集成、持续部署等。含有开源免费的社区版community edition和企业版enterprise edition，它提供了一些额外的功能和服务，如高级权限管理、LDAP/AD 集成、单点登录、高可用性、支持等。企业版是基于开源的社区版构建的，并提供了额外的商业支持和服务。开发语言主要为Ruby，go（后端服务和工具，如gitlab runner等）、vue、sql

## gitlab CI/CD
GitLab CI/CD是GitLab内置的一款工具，用于通过持续方法论（continuous methodologies）的软件开发。该持续方法论包含三个部分：持续集成、持续交付、持续部署。

持续集成（Continuous Integration，简称CI），每次在上传代码块到基于Git仓库时，持续集成 会运行脚本去构建、测试、校验代码，这些操作是在合并到默认分支之前进行的。

持续交付（Continuous Delivery，简称CD），在持续集成之后（即合并到默认分支之后），持续交付 将进行手动部署应用。

持续部署（Continuous Deployment，简称CD），在持续集成之后（即合并到默认分支之后），持续部署 将进行自动部署应用。

### 原理
当开发者配置了GitLab CI/CD，那么当开发者使用Git提交（commit），那么就会触发CI/CD相关的一系列操作。这一系列操作由GitLab Runner执行，相关配置记载于.gitlab-ci.yml文件中，执行的结果将在GitLab页面中展示。每一次的提交（commit）将会触发一条流水线（pipeline），流水线是不同阶段（Stage）的任务（Job）的一个集合。阶段（Stage）用于逻辑切割，同一阶段的任务以并行方式执行，阶段间是顺序执行，上一个阶段执行失败，下一个阶段将不会执行。.pre 为第一阶段（译为：之前） 和 .post 最后阶段（译为：提交时），这两个阶段不需要被定义，也无法被修改
```yaml
stages:
  - build
  - test
  - deploy

job 0:
  stage: .pre
  script: make something useful before build stage

job 1:
  stage: build
  script: make build dependencies

job 2:
  stage: build
  script: make build artifacts

job 3:
  stage: test
  script: make test

job 4:
  stage: deploy
  script: make deploy

job 5:
  stage: .post
  script: make something useful at the end of pipeline
```

任务（job）可以构建Artifacts ，提供用户下载。利用场景如下：在Android项目中，当配置了自动化构建Artifacts后，每次提交（push）代码后，GitLab CI/CD 将自动构建 APK文件，并在GitLab的页面上提供下载按钮。 任务（Job）可以自动部署文件到外部服务器，并通过 GitLab 页面查看该服务器现今部署的状态，以及进行重新部署（re-deploy）等操作。通过使用设定 environment 的 name 和 url ，还可以在GitLab页面上直接查看网站。通过该操作可以达到 持续部署 的目的
```yaml
deploy_staging:
  stage: deploy
  script:
    - echo "Deploy to staging server"
  environment:
    name: staging
    url: http://172.23.0.2:5000/
  only:
  - master
  tags:
    - Runner名称
```

### gitlab Runner
GitLab Runner 是一项开源项目，用于执行任务（Job），并将执行结果传输回GitLab。

Runner 可安装在操作系统，也可以通过Docker的方式安装。当 Runner 安装后，需要将其注册在 GitLab 中，方可使用。Runner 有若干种执executor可供使用，如：Docker、Shell、SSH。Runner 默认使用Shell，Shell模式下，所有构建都会发生在Runner安装的机器中，操作十分简单，但是缺点很多。

.gitlab-ci.ym 文件中通过 tags 关键词选择Runner。Runner 的相关配置在 config.toml 文件中记载。

### 与docker集成
对基于Docker的项目 进行构建和测试，有几种方式。一种方式是，使用shell executor进行Docker CLI命令操作。 另一种方式就是使用Docker executor进行操作，它是官方推荐的操作，executor通过在Docker中使用 Docker-in-Docker镜像进行Job相关操作。
