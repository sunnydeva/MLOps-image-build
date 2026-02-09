#!/usr/bin/env bash
set -e

# ===============================
# 🎨 Logger
# ===============================
GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
RESET="\e[0m"

ts() {
  date +"%H:%M:%S"
}

step() {
  echo -e "${PURPLE}[$(ts)] 🚀 [STEP]${RESET} $1"
}

info() {
  echo -e "${BLUE}[$(ts)] ℹ️  [INFO]${RESET} $1"
}

success() {
  echo -e "${GREEN}[$(ts)] ✅ [SUCCESS]${RESET} $1"
}

warn() {
  echo -e "${YELLOW}[$(ts)] ⚠️  [WARN]${RESET} $1"
}

error() {
  echo -e "${RED}[$(ts)] ❌ [ERROR]${RESET} $1"
}

die() {
  error "$1"
  exit 1
}

trap 'die "Script failed at line $LINENO"' ERR

# ===============================
# 🧭 Context
# ===============================
info "Current directory: $(pwd)"
info "Directory contents:"
ls -ltrh

# ===============================
# 🚦 Command handling
# ===============================
case "$1" in
  deploy)

    step "Installing Kubernetes CRDs"
    info "Deploying Istio base, Istiod, Istio Gateway, cert-manager"
    helmfile sync --log-level=debug -f ./helmfile.yaml
    success "Istio & cert-manager charts deployed"

    step "Deploying Knative Serving CRDs"
    kubectl apply -f ./kubernates/crds/templates/knative/manifests/serving-crds.yaml
    success "Knative Serving CRDs deployed"

    step "Deploying Knative Serving Core"
    kubectl apply -f ./kubernates/crds/templates/knative/manifests/serving-core.yaml
    success "Knative Serving Core deployed"

    step "Waiting for Knative webhooks to become ready ⏳"
    sleep 180
    success "Wait completed"

    step "Deploying Knative net-istio"
    kubectl apply -f ./kubernates/crds/templates/knative/manifests/net-istio.yaml
    success "Knative net-istio deployed"

    step "Deploying KServe"
    helmfile -f ./kserve-helmfile.yaml sync --log-level=debug
    success "KServe deployed successfully"

    step "Validating deployments 🔍"

    info "Checking Istio pods"
    kubectl get pods -n istio-system

    info "Checking Knative Serving pods"
    kubectl get pods -n knative-serving

    info "Checking KServe pods"
    kubectl get pods -n kserve

    echo -e "${CYAN}"
    echo "======================================"
    echo " 🎉 DEPLOYMENT COMPLETED SUCCESSFULLY 🎉"
    echo "======================================"
    echo -e "${RESET}"
    ;;

  *)
    warn "Invalid command"
    echo "Usage: $0 deploy"
    exit 1
    ;;
esac
