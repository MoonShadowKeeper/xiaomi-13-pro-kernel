#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y curl git sudo libicu-dev build-essential

if ! id "builder" >/dev/null 2>&1; then
    useradd -m -s /bin/bash builder
    usermod -aG sudo builder
    echo "builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/builder
    chmod 0440 /etc/sudoers.d/builder
fi

su - builder -c '
set -e
mkdir -p actions-runner
cd actions-runner
if [ ! -f "config.sh" ]; then
    curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
    tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
fi
./config.sh --url https://github.com/MoonShadowKeeper/xiaomi-13-pro-kernel --token BMITK3TC2LPVT42KPN7XSBLKFVDLU --unattended --replace --name "vps-runner"
sudo ./svc.sh install
sudo ./svc.sh start
'
echo "Runner setup complete."
