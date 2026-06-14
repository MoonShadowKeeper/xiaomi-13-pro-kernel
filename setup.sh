#!/bin/bash
set -e

TOKEN=$1
if [ -z "$TOKEN" ]; then
    echo "Usage: ./setup.sh <GITHUB_RUNNER_TOKEN>"
    echo "You can get a token from GitHub -> Settings -> Actions -> Runners -> New self-hosted runner"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y curl git sudo libicu-dev build-essential

if ! id "builder" >/dev/null 2>&1; then
    useradd -m -s /bin/bash builder
    usermod -aG sudo builder
    echo "builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/builder
    chmod 0440 /etc/sudoers.d/builder
fi

su - builder -c "
set -e
mkdir -p actions-runner
cd actions-runner
if [ ! -f 'config.sh' ]; then
    curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
    tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
fi
./config.sh --url https://github.com/MoonShadowKeeper/xiaomi-13-pro-kernel --token $TOKEN --unattended --replace --name 'vps-runner'
sudo ./svc.sh install
sudo ./svc.sh start
"
echo "Runner setup complete."
