# localops (infra)

This project provides a framework for running Docker based services on a laptop, during their development. It assumes [Kubernetes](https://kubernetes.io/docs/home/), in one of its many flavors, is your container orchestration platform, and is meant to emulate, as much as possible, the environment (be it cloud-based, or on prem) those services will later be hosted on.

It also provides support for [Docker Compose](https://docs.docker.com/compose/) as a lightweight alternative platform, so you can choose, at any given time, what makes more sense to you. I find it easier to use Compose when working on the services, and save k8s to tests that involve pod lifecycles or service intercommunication.

You should use it together with [localops](https://github.com/gasrios/localops/). localops will handle setting up a local k8s cluster running on [MicroK8s](https://microk8s.io/), including a Docker local registry and a bunch of other tools (even a local Jenkins, which I use to test [pipelines](https://jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) and [Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/) locally).

## Set up

localops (infra) expects two environment variables to be defined: [KUBECONFIG](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable) and [CONTEXT](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#context).

The main benefit of explicitly defining both is adding a layer of security to prevent making changes to the wrong cluster; localops (infra) will never trust default configurations and will force you to point to the cluster you actually want to work with.

I recommend using [direnv](https://direnv.net/) to isolate distinct development configurations, in case you work in several projects at the same time, and want to keep them separated (it also helps keeping cloud cluster configurations apart from the local one). For example, you might create a ".envrc" file in this directory (that is, the same directory that holds README.md) with the following content:

```
export KUBECONFIG=~/.kube/config
export CONTEXT=local
```

This will ensure localops (infra) will use your "local" context, as defined in the default location for you kubeconfig file.

If you also use localops [localops](https://github.com/gasrios/localops/), [the MicroK8s installation playbook](https://github.com/gasrios/localops/blob/ubuntu_focal_fossa/microk8s.yaml) will also create a .envrc file in your homedir, that ensures your local MicroK8s cluster is the default one used by all projects that do not specify their own .envrc file.

## Configuring services

Any project found in directory "services", that provides a [Makefile](https://www.gnu.org/software/make/), will be built automatically. GNU Make enables localops (infra) to be programming language and build tool agnostic.

localops (infra) comes with two examples: [hello](https://github.com/gasrios/localops-infra/master/services/hello) and [ipify](https://github.com/gasrios/localops-infra/master/services/ipify).

**Note:** it is currently considered a best practice not to add projects to localops (infra) by directly copying them to directory "services"; you should instead keep them in separate repositories, git clone them there, and possibly add them to .gitignore. It might be a good idea to [fork this repo](https://help.github.com/en/articles/fork-a-repo) and add your own customizations to your copy, too.

## script localops-infra-k8s

Used to deploy/undeploy all of your services, at once. Usage:

```
localops-infra-k8s deploy
```

or

```
localops-infra-k8s undeploy
```

As long as your Makefiles deploy projects to the cluster/context defined in KUBECONFIG, that's all there is to it. Here is a [Makefile example](https://raw.githubusercontent.com/gasrios/localops-infra/master/services/hello/Makefile).

## script localops-infra-docker

Used to run your services without having to deploy them to a cluster. You will need to provide a [docker-compose.yml](https://docs.docker.com/compose/compose-file/) configuration file. localops (infra) comes with an [example](https://raw.githubusercontent.com/gasrios/localops-infra/master/docker-compose.yml), in case you need one. Usage:

```
localops-infra-docker deploy
```

or

```
localops-infra-docker undeploy
```

## Copyright & License

### © 2019 Guilherme Rios All Rights Reserved

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
