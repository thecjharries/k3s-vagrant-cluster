#!/bin/bash

# https://github.com/rancher/k3s/blob/fe7337937155af41f1aebeb87d1acd07091b71de/scripts/provision/vagrant#L17-L20
cat <<\EOF >/etc/profile.d/root.sh
[ $EUID -ne 0 ] && exec sudo -i
EOF
