# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKER_COUNT = 1

Vagrant.configure("2") do |config|
  config.vm.define "main" do |main|
    main.vm.box = "hashicorp/bionic64"
    main.vm.hostname = "k3s-main"
    main.vm.network "private_network", ip: "10.147.0.13"
    main.vm.provision "shell", inline: <<-SHELL
      export K3S_KUBECONFIG_MODE="644"
      export K3S_NODE_NAME="${HOSTNAME//_/-}"
      export K3S_EXTERNAL_IP="10.147.0.13"
      INSTALL_K3S_EXEC="--write-kubeconfig /vagrant/kubeconfig"
      INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --write-kubeconfig-mode $K3S_KUBECONFIG_MODE"
      INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --tls-san $K3S_EXTERNAL_IP"
      # INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --kube-apiserver-arg service-node-port-range=1-65000"
      # INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --kube-apiserver-arg advertise-address=$K3S_EXTERNAL_IP"
      # INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --kube-apiserver-arg external-hostname=$K3S_EXTERNAL_IP"
      export INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC"
      curl -sfL https://get.k3s.io | sh -
      rm -rf /vagrant/main-token
      cp /var/lib/rancher/k3s/server/node-token /vagrant/main-token
      sed -i -e 's/127\.0\.0\.1/10.147.0.13/' /vagrant/kubeconfig
    SHELL
  end

  (1..WORKER_COUNT).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "hashicorp/bionic64"
      node.vm.hostname = "k3s-node-#{i}"
      node.vm.network "private_network", ip: "10.147.0.#{13 + i}"
      node.vm.provision "shell", inline: <<-SHELL
        export K3S_TOKEN="$(cat /vagrant/main-token)"
        export K3S_URL="https://10.147.0.13:6443"
        export INSTALL_K3S_EXEC="--token $K3S_TOKEN --server $K3S_URL"
        export K3S_NODE_NAME="${HOSTNAME//_/-}"
        curl -sfL https://get.k3s.io | sh -
      SHELL
    end
  end
end
