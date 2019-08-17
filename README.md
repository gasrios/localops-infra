# localops (infra)

This project provides a framework for running Docker based services on a laptop, during their development. It assumes [Kubernetes](https://kubernetes.io/docs/home/), in one of its many flavors, is your container orchestration platform, and is meant to emulate, as much as possible, the environment (be it cloud-based, or on prem) those services will later be hosted on.

It also provides support for [Docker Compose](https://docs.docker.com/compose/) as a lightweight alternative platform, so you can choose, at any given time, what makes more sense to you. I find it easier to use Compose when working on the services, and save k8s to tests that involve pod lifecycles.

It assumes you have configured your development environment using [localops](https://github.com/gasrios/localops/). localops will handle setting up a local k8s cluster, including a Docker local registry and a bunch of other tools (even a local Jenkins, which I use to test [pipelines](https://jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) and [Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/) locally).

## Set up

localops (infra) uses [direnv](https://direnv.net/) to isolate distinct development configurations, in case you work in several projects at the same time, and want to keep them separated (it also helps keeping cloud cluster configurations apart from them). You need to create a ".envrc" file in this directory (that is, the same directory that holds README.md) with the following content:

```
export KUBECONFIG=~/.kube/local
export CONTEXT=dev
```

This is compatible with the default k8s cluster created by localops. Customize as needed to fit other environments.

## Configuring services

Any project found in directory "services", that provides a [Makefile](https://www.gnu.org/software/make/), will be built automatically. GNU Make enables localops (infra) to be programming language and build tool agnostic.

You can find an example (here)[https://raw.githubusercontent.com/gasrios/localops-infra/master/services/hello/Makefile].

**Note:** it is currently considered a best practice not to add projects to localops (infra) by directly copying them to directory "services"; you should instead keep them in separate repositories, git clone them there, and possibly add them to .gitignore. It might be a good idea to (fork this repo)[https://help.github.com/en/articles/fork-a-repo] and add your own customizations to your copy, too.

## k8s-*.sh scripts

Used to start, update and stop your services, all at once. Once the framework is up, you may want to switch to updating each individually.

In case you want to do a batch update, for example after pulling several repos at once, use (k8s-02_update.sh)[https://raw.githubusercontent.com/gasrios/localops-infra/master/k8s-02_update.sh]

**Note:** once you stop localops (infra), it will try to restore whatever context (defined using "kubectl config use-context") was active before it started, by setting environment variable "PREVIOUS_CONTEXT" when running "k8s-01_start.sh", then resetting it in "k8s-03_stop.sh". But, in order to do so, you will have to [source](https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html) the startup script.

As long as your Makefiles can deploy projects to the cluster/context defined in KUBECONFIG, that's all there is to it. Here is a (Makefile example)[https://raw.githubusercontent.com/gasrios/localops-infra/master/services/hello/Makefile].

## docker-compose-*.sh scripts

Used to run your services without having to deploy them to a cluster. You will need to provide your own (docker-compose.yml)[https://docs.docker.com/compose/compose-file/] configuration file (there is an example (here)[https://raw.githubusercontent.com/gasrios/localops-infra/master/docker-compose.yml], in case you need one).

## Copyright & License

### © 2019 Guilherme Rios All Rights Reserved

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
