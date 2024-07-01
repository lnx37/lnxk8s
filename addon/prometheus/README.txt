KUBERNETES PROMETHEUS, 202403

https://github.com/prometheus-operator/kube-prometheus
https://github.com/prometheus-operator/kube-prometheus/releases

wget "https://github.com/prometheus-operator/kube-prometheus/archive/refs/tags/v0.13.0.tar.gz" -O v0.13.0.tar.gz

tar tvf v0.13.0.tar.gz
tar xzvf v0.13.0.tar.gz

cd kube-prometheus-0.13.0

cp -ar manifests manifests_bk_raw
diff -u -r manifests_bk_raw manifests
diff -u -r -q manifests_bk_raw manifests

sed -i "s|image: quay.io|image: m.daocloud.io/quay.io|g" manifests/*.yaml
sed -i "s|image: registry.k8s.io|image: m.daocloud.io/registry.k8s.io|g" manifests/*.yaml
sed -i "s|prometheus-config-reloader=quay.io|prometheus-config-reloader=m.daocloud.io/quay.io|g" manifests/*.yaml
diff -u -r manifests_bk_raw manifests
diff -u -r -q manifests_bk_raw manifests

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests/
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup

kubectl get all -n monitoring
kubectl get pod -n monitoring
kubectl get pod -n monitoring -o wide
kubectl get svc -n monitoring

# ClusterIP -> NodePort
kubectl edit svc grafana -n monitoring
