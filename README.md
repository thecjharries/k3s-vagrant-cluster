# `k3s-vagrant-cluster`

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)  [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) [![Check the NOTICE](https://img.shields.io/badge/Check%20the-NOTICE-420C3B.svg)](./NOTICE)

WIP

## Prequisites

### `vagrant`

Download [the latest release](https://www.vagrantup.com/downloads.html) and add it to your path.

### `kubectl`

Follow [the installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

### `helm`

Download [the latest release](https://github.com/helm/helm/releases/) and add it to your path.

### `fluxctl`

```
sudo snap install fluxctl
```

## Useful Tools

### `kube{ctx,ns}`

```
mkdir -p ~/.local/lib/kubectx
cd ~/.local/lib/kubectx
git clone https://github.com/ahmetb/kubectx.git .
ln -sf ~/.local/lib/kubectx/kubectx ~/.local/bin/kubectx
ln -sf ~/.local/lib/kubectx/kubens ~/.local/bin/kubens
```
