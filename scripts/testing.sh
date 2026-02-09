case "$1" in
    "deploy")
        echo "Installing ML-OPS platform..."
        pwd
        helmfile sync --log-level=debug -f ../helmfile.yaml
        kubectl apply -f ./kubernates/crds/templates/knative/manifests/serving-crds.yaml
        kubectl apply -f ./kubernates/crds/templates/knative/manifests/serving-core.yaml
        kubectl apply -f ./kubernates/crds/templates/knative/manifests/net-istio.yaml
        helmfile -f ../kserve-helmfile.yaml apply
        ;;
    "destroy")
        echo "Uninstalling ML-OPS platform..."
        helmfile destroy --log-level=debug -f ../helmfile.yaml
        kubectl delete -f ../kubernates/crds/templates/knative/serving/serving-core.yaml
        kubectl delete -f ../kubernates/crds/templates/knative/serving/serving-crds.yaml
        helmfile -f ../kserve-helmfile.yaml destroy
        ;;
    "status")
        echo "Checking status of ML-OPS platform..."
        helmfile -f ../helmfile.yaml status
        helmfile -f ../helmfile-kserve.yaml status
        ;;
    "redeploy")
        echo "Redeploying ML-OPS platform..."
        helmfile destroy --log-level=debug -f ../helmfile.yaml
        kubectl delete -f ../kubernates/knative/serving/serving-core.yaml
        kubectl delete -f ../kubernates/knative/serving/serving-crds.yaml
        helmfile -f ../helmfile-kserve.yaml destroy

        helmfile sync --log-level=debug -f ../helmfile.yaml
        kubectl apply -f ../kubernates/knative/serving/serving-crds.yaml
        kubectl apply -f ../kubernates/knative/serving/serving-core.yaml
        helmfile -f ../helmfile-kserve.yaml apply
        ;;
    *)
        echo "Usage: $0 {deploy|estroy|status|redeploy}"
        exit 1
esac