#!/bin/bash
set -e  

install_kubectl() {
    if ! command -v kubectl &> /dev/null
    then
        echo "kubectl could not be found, installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    else
            echo "kubectl is already installed"
    fi
}

install_jq() {

    if ! command -v jq &> /dev/null
    then
        echo "jq could not be found, installing jq..."
        apt-get update && apt-get install -y jq
    else
        echo "jq is already installed"
    fi
}

install_helm() {
    if ! command -v helm &> /dev/null
    then
        echo "helm could not be found, installing helm..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    else
        echo "helm is already installed"
    fi
}

install_helmfile() {
    if ! command -v helmfile &> /dev/null
    then
        echo "helmfile could not be found, installing helmfile..."
        curl -L https://github.com/roboll/helmfile/releases/download/v0.147.0/helmfile_0.147.0_linux_amd64.tar.gz | tar xz -C /usr/local/bin
    else
        echo "helmfile is already installed"
    fi
}   

install_prerequisites() {
    install_kubectl
    install_jq
    install_helm
    install_helmfile
}

install_prerequisites