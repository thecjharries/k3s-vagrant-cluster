# -*- mode: ruby -*-
# vi: set ft=ruby :

TOKEN = "GFgpPGZAUZDnUl8pCwk8ZuZ1ozRYp8QCTkYb1WdzfT6pu4dzKjiIqFQn6uoEbCanE8CBshbHoAh8iPRlJWCv4SIBM2ETJUnO9a4t"

DATA_IP = "10.147.0.13"
MAIN_IP = "10.147.1.13"
SERVER_IP = "10.147.1.14"
AGENT_IP = "10.147.2.13"

Vagrant.configure("2") do |config|
  config.vm.define "data" do |data|
    data.vm.box = "generic/alpine310"
    data.vm.hostname = "k3s-data"
    data.vm.network "private_network", ip: "#{DATA_IP}"#, name: "vboxnet0"
    data.vm.provision "shell", path: "provision.sh"
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
    main.vm.network "private_network", ip: "#{MAIN_IP}"#, name: "vboxnet1"
    main.vm.provision "shell", path: "provision.sh"
    main.vm.provision "shell", inline: <<-SHELL
      export K3S_DATASTORE_ENDPOINT="http://#{DATA_IP}:2379"
      export K3S_TOKEN="#{TOKEN}"
      export K3S_NODE_IP="#{MAIN_IP}"
      export INSTALL_K3S_EXEC="--tls-san #{MAIN_IP} --datastore-endpoint $K3S_DATASTORE_ENDPOINT --node-ip $K3S_NODE_IP --token $K3S_TOKEN --write-kubeconfig /vagrant/kubeconfig --flannel-iface eth1 --node-taint k3s-controlplane=true:NoExecute"
      curl -sfL https://get.k3s.io | sh -
      sed -i -e 's/127\.0\.0\.1/#{MAIN_IP}/' /vagrant/kubeconfig
    SHELL
  end

  config.vm.define "server" do |server|
    server.vm.box = "hashicorp/bionic64"
    server.vm.hostname = "k3s-server"
    server.vm.network "private_network", ip: "#{SERVER_IP}"#, name: "vboxnet1"
    server.vm.provision "shell", path: "provision.sh"
    server.vm.provision "shell", inline: <<-SHELL
      export K3S_DATASTORE_ENDPOINT="http://#{DATA_IP}:2379"
      export K3S_TOKEN="#{TOKEN}"
      export K3S_NODE_IP="#{SERVER_IP}"
      export INSTALL_K3S_EXEC="--tls-san #{SERVER_IP} --datastore-endpoint $K3S_DATASTORE_ENDPOINT --node-ip $K3S_NODE_IP --token $K3S_TOKEN --flannel-iface eth1"
      curl -sfL https://get.k3s.io | sh -
    SHELL
  end

  config.vm.define "agent" do |agent|
    agent.vm.box = "hashicorp/bionic64"
    agent.vm.hostname = "k3s-agent"
    agent.vm.network "private_network", ip: "#{AGENT_IP}"#, name: "vboxnet2"
    agent.vm.provision "shell", path: "provision.sh"
    agent.vm.provision "shell", inline: <<-SHELL
      export K3S_TOKEN="#{TOKEN}"
      export K3S_URL="https://#{MAIN_IP}:6443"
      export K3S_NODE_IP="#{AGENT_IP}"
      export INSTALL_K3S_EXEC="--token $K3S_TOKEN --server $K3S_URL --node-ip $K3S_NODE_IP --flannel-iface eth1"
      curl -sfL https://get.k3s.io | sh -
    SHELL
  end
end
