# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKER_COUNT = 1
TOKEN = "GFgpPGZAUZDnUl8pCwk8ZuZ1ozRYp8QCTkYb1WdzfT6pu4dzKjiIqFQn6uoEbCanE8CBshbHoAh8iPRlJWCv4SIBM2ETJUnO9a4t"
# NETWORK_PREFIX = "10.147.100."

DATA_IP = "10.147.0.12"
MAIN_IP = "10.147.0.13"
NODE_IP = "10.147.0.14"

Vagrant.configure("2") do |config|
  config.vm.define "data" do |data|
    data.vm.box = "generic/alpine310"
    data.vm.hostname = "k3s-data"
    data.vm.network "private_network", ip: "#{DATA_IP}", name: "vboxnet0"
    data.vm.provision "shell", inline: <<-SHELL
      apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing etcd
      rc-update add etcd default
      sed -i -e 's/localhost/#{DATA_IP}/' -e 's/^initial-advertise-peer/#initial-advertise-peer/' /etc/etcd/conf.yml
      rc-service etcd start
    SHELL
  end

  config.vm.define "main" do |main|
    main.vm.box = "hashicorp/bionic64"
    main.vm.hostname = "k3s-main"
    main.vm.network "private_network", ip: "#{MAIN_IP}", name: "vboxnet0"
    main.vm.provision "shell", inline: <<-SHELL
      export K3S_DATASTORE_ENDPOINT="http://#{DATA_IP}:2379"
      export K3S_TOKEN="#{TOKEN}"
      export K3S_NODE_IP="#{MAIN_IP}"
      export INSTALL_K3S_EXEC="--tls-san #{MAIN_IP} --datastore-endpoint $K3S_DATASTORE_ENDPOINT --node-ip $K3S_NODE_IP --token $K3S_TOKEN --write-kubeconfig /vagrant/kubeconfig --node-taint k3s-controlplane=true:NoExecute"
      curl -sfL https://get.k3s.io | sh -
      sed -i -e 's/127\.0\.0\.1/10.147.0.13/' /vagrant/kubeconfig
    SHELL
  end

  config.vm.define "node" do |node|
    node.vm.box = "hashicorp/bionic64"
    node.vm.hostname = "k3s-node"
    node.vm.network "private_network", ip: "#{NODE_IP}", name: "vboxnet0"
    node.vm.provision "shell", inline: <<-SHELL
      export K3S_TOKEN="#{TOKEN}"
      export K3S_URL="https://#{MAIN_IP}:6443"
      export K3S_NODE_IP="#{NODE_IP}"
      export INSTALL_K3S_EXEC="--token $K3S_TOKEN --server $K3S_URL --node-ip $K3S_NODE_IP"
      curl -sfL https://get.k3s.io | sh -
    SHELL
  end
  # config.vm.define "main" do |main|
  #   main.vm.box = "hashicorp/bionic64"
  #   main.vm.hostname = "k3s-main"
  #   main.vm.network "private_network", ip: "10.147.0.13"
  #   main.vm.provision "shell", inline: <<-SHELL
  #     export K3S_KUBECONFIG_MODE="644"
  #     export K3S_NODE_NAME="${HOSTNAME//_/-}"
  #     export K3S_EXTERNAL_IP="10.147.0.13"
  #     INSTALL_K3S_EXEC="--write-kubeconfig /vagrant/kubeconfig"
  #     INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --write-kubeconfig-mode $K3S_KUBECONFIG_MODE"
  #     INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --tls-san $K3S_EXTERNAL_IP"
  #     INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --node-ip $K3S_EXTERNAL_IP"
  #     export INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC"
  #     curl -sfL https://get.k3s.io | sh -
  #     rm -rf /vagrant/main-token
  #     cp /var/lib/rancher/k3s/server/node-token /vagrant/main-token
  #     sed -i -e 's/127\.0\.0\.1/10.147.0.13/' /vagrant/kubeconfig
  #   SHELL
  # end

  # (1..WORKER_COUNT).each do |i|
  #   config.vm.define "node-#{i}" do |node|
  #     node.vm.box = "hashicorp/bionic64"
  #     node.vm.hostname = "k3s-node-#{i}"
  #     node.vm.network "private_network", ip: "10.147.0.#{13 + i}"
  #     node.vm.provision "shell", inline: <<-SHELL
  #       export K3S_EXTERNAL_IP=10.147.0.#{13 + i}
  #       export K3S_TOKEN="$(cat /vagrant/main-token)"
  #       export K3S_URL="https://10.147.0.13:6443"
  #       export K3S_NODE_NAME="${HOSTNAME//_/-}"
  #       export INSTALL_K3S_EXEC="--token $K3S_TOKEN --server $K3S_URL --node-ip $K3S_EXTERNAL_IP"
  #       curl -sfL https://get.k3s.io | sh -
  #     SHELL
  #   end
  # end
end
